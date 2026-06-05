import 'package:flutter/material.dart';
import 'package:geolocation/widgets/drop_down.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:geolocation/widgets/text_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/customtextfield.dart';
import 'add_visit_viewmodel.dart';

class AddVisitScreen extends StatefulWidget {
  final String VisitId;
  const AddVisitScreen({super.key, required this.VisitId});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVisitViewModel>.reactive(
      viewModelBuilder: () => AddVisitViewModel(),
      onViewModelReady: (model) => model.initialise(context, widget.VisitId),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Text(
                  model.isVisitInCompleted
                      ? "Resume Visit"
                      : "Create Visit",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        body: fullScreenLoader(
          context: context,
          loader: model.isBusy,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ================= VISIT TYPE =================
                _sectionCard(
                  icon: Icons.group,
                  title: "Visit Type",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownButton2(
                        value: model.visitType,
                        items: const ["Customer", "Lead"],
                        hintText: "Select Visit Type",
                        labelText: "Visit Type *",
                        onChanged: model.setVisitType,
                      ),
                      if (model.visitType == null)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "Visit Type is required",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ================= PARTY =================
                if (model.visitType != null)
                  _sectionCard(
                    icon: Icons.person_outline,
                    title: "${model.visitType} Details",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdownButton2(
                          value: model.selectedParty,
                          items: model.filteredParties,
                          hintText: "Select ${model.visitType}",
                          labelText: "${model.visitType} *",
                          onChanged: model.setParty,
                        ),
                        if (model.selectedParty == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              "Please select party",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // ================= DATE & TIME =================
                if (model.selectedParty != null)
                  _sectionCard(
                    icon: Icons.access_time,
                    title: "Current Time",
                    child: Text(
                      model.formatTime(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // ================= MAP =================
                if (model.currentLatLng != null)
                  _sectionCard(
                    icon: Icons.map_outlined,
                    title: "Location",
                    child: _mapPreview(model.currentLatLng!),
                  ),

                const SizedBox(height: 20),

                // ================= CHECK IN =================
                if (!model.isVisitInCompleted)
                  CTextButton(
                    text: "Start Visit",
                    buttonColor: Colors.green,
                    onPressed: () {
                      if (model.visitType == null ||
                          model.selectedParty == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select Visit Type and Party"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      model.saveVisitStep(true, context);
                    },
                  ),

                // ================= AFTER CHECK IN =================
                if (model.isVisitInCompleted) ...[
                  const SizedBox(height: 16),
                  _sectionCard(
                    icon: Icons.description_outlined,
                    title: "Visit Description",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSmallTextFormField(
                          lineLength: 3,
                          controller: model.descriptionController,
                          labelText: "Description *",
                          hintText: "Enter Description",
                          onChanged: model.setDescription,
                        ),
                        if (model.descriptionController.text.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              "Description is required",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CTextButton(
                    text: "End Visit",
                    buttonColor: Colors.redAccent,
                    onPressed: () {
                      if (model.descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter description"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      model.saveVisitStep(false, context);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= MAP =================
  Widget _mapPreview(LatLng latlng) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: latlng, zoom: 15),
          markers: {
            Marker(markerId: const MarkerId("current"), position: latlng),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }

  // ================= SECTION CARD =================
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

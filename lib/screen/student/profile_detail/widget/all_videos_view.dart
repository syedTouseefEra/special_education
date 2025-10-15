import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/video_player_screen.dart';
import 'package:special_education/utils/video_thumbnail_generator.dart';

class AllVideosView extends StatefulWidget {
  final String studentId;

  const AllVideosView({super.key, required this.studentId});

  @override
  State<AllVideosView> createState() => _AllVideosViewState();
}

class _AllVideosViewState extends State<AllVideosView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      ).getAllVideos(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDashboardProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading;
        final error = provider.error;
        final videos = (provider.allVideoData ?? [])
            .where(
              (video) => video.videoList != null && video.videoList!.isNotEmpty,
            )
            .toList();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Add Long Term Goal Which Kid Achieve',
                fontSize: 17.sp,
                fontFamily: 'Poppins',
                color: AppColors.textGrey,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 15.sp),

              if (isLoading) ...[
                const Center(child: CupertinoActivityIndicator()),
              ] else if (error != null) ...[
                Center(
                  child: Text(error, style: TextStyle(color: Colors.red)),
                ),
              ] else if (videos.isEmpty) ...[
                const Center(child: Text("No videos found")),
              ] else ...[
                ListView.builder(
                  itemCount: videos.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                text: 'Week ${video.weekCount}',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 5.sp),
                              CustomText(
                                text: video.goalStatus == 2
                                    ? '. Completed'
                                    : video.goalStatus == 3
                                    ? '. Upcoming'
                                    : '. OnGoing',
                                color: video.goalStatus == 2
                                    ? AppColors.yellow
                                    : video.goalStatus == 3
                                    ? AppColors.green
                                    : AppColors.yellow,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          Divider(thickness: 1, color: AppColors.grey),
                          if (video.videoList != null &&
                              video.videoList!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 10.sp),
                              child: SizedBox(
                                height: 180.h,
                                width: MediaQuery.sizeOf(context).width,
                                child: ListView.builder(
                                  itemCount: video.videoList!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final mainUrl =
                                        'https://hamaaresitaareapi.edumation.in/FileUploads/weeklyGoal/';
                                    final videoUrl = video.videoList![index];
                                    final fullUrl =
                                        '$mainUrl${videoUrl.videoName ?? ''}';

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 200.h,
                                          width: MediaQuery.sizeOf(
                                            context,
                                          ).width,
                                          child: FutureBuilder<String?>(
                                            future:
                                                VideoThumbnailGenerator.generateThumbnail(
                                                  fullUrl,
                                                ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              if (snapshot.hasError ||
                                                  snapshot.data == null) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          VideoPlayerScreen(
                                                            videoUrl: fullUrl,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        ClipRRect(
                                                          child: Image.file(
                                                            File(
                                                              snapshot.data!,
                                                            ),
                                                            width:
                                                                MediaQuery.sizeOf(
                                                                  context,
                                                                ).width,
                                                            height: 150.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          size: 40.sp,
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      color:
                                                          AppColors.themeColor,
                                                      height: 30.sp,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10.0,
                                                            ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons.fullscreen,
                                                              color: AppColors
                                                                  .white,
                                                              size: 25.sp,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                AlertView()
                                                                    .alertToast(
                                                                      "Download Complete",
                                                                    );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .save_alt,
                                                                    color: AppColors
                                                                        .white,
                                                                    size: 18.sp,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2.sp,
                                                                  ),
                                                                  CustomText(
                                                                    text:
                                                                        'Download',
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 20.sp),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

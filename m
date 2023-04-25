Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E386EE77B
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDYSVT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDYSVS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 14:21:18 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5041A7D85
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 11:21:17 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id A2656442EFC0; Tue, 25 Apr 2023 11:21:02 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Date:   Tue, 25 Apr 2023 11:20:51 -0700
Message-Id: <20230425182054.2826621-2-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230425182054.2826621-1-shr@devkernel.io>
References: <20230425182054.2826621-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds two functions to manage the napi busy poll settings:
- io_uring_register_napi
- io_uring_unregister_napi

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h          |  3 +++
 src/include/liburing/io_uring.h | 12 ++++++++++++
 src/liburing-ffi.map            |  2 ++
 src/liburing.map                |  2 ++
 src/register.c                  | 12 ++++++++++++
 5 files changed, 31 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 70c1774..add17a0 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -241,6 +241,9 @@ int io_uring_register_sync_cancel(struct io_uring *ri=
ng,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
=20
+int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *=
napi);
+int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi=
 *napi);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
=20
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 3d3a63b..0e6e0bd 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -523,6 +523,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			=3D 26,
+	IORING_UNREGISTER_NAPI			=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
=20
@@ -662,6 +666,14 @@ struct io_uring_buf_reg {
 	__u64	resv[3];
 };
=20
+/* argument for IORING_(UN)REGISTER_NAPI */
+struct io_uring_napi {
+	__u32   busy_poll_to;
+	__u8    prefer_busy_poll;
+	__u8    pad[3];
+	__u64   resv;
+};
+
 /*
  * io_uring_restriction->opcode values
  */
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 0a5e12c..2d9ab9f 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -171,6 +171,8 @@ LIBURING_2.4 {
 		io_uring_prep_msg_ring_fd;
 		io_uring_prep_msg_ring_fd_alloc;
 		io_uring_prep_sendto;
+		io_uring_register_napi;
+		io_uring_unregister_napi;
 	local:
 		*;
 };
diff --git a/src/liburing.map b/src/liburing.map
index 3b37022..c775b61 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -79,4 +79,6 @@ LIBURING_2.4 {
 		io_uring_register_restrictions;
 		io_uring_setup_buf_ring;
 		io_uring_free_buf_ring;
+		io_uring_register_napi;
+		io_uring_unregister_napi;
 } LIBURING_2.3;
diff --git a/src/register.c b/src/register.c
index a3fcc78..d494be7 100644
--- a/src/register.c
+++ b/src/register.c
@@ -337,3 +337,15 @@ int io_uring_register_file_alloc_range(struct io_uri=
ng *ring,
=20
 	return do_register(ring, IORING_REGISTER_FILE_ALLOC_RANGE, &range, 0);
 }
+
+int io_uring_register_napi(struct io_uring *ring, struct io_uring_napi *=
napi)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_REGISTER_NAPI, napi, 0);
+}
+
+int io_uring_unregister_napi(struct io_uring *ring, struct io_uring_napi=
 *napi)
+{
+	return __sys_io_uring_register(ring->ring_fd,
+				IORING_UNREGISTER_NAPI, napi, 0);
+}
--=20
2.39.1


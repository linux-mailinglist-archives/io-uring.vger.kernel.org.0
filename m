Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA968B13D
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 19:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBESvq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Feb 2023 13:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBESvp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Feb 2023 13:51:45 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00828193CF
        for <io-uring@vger.kernel.org>; Sun,  5 Feb 2023 10:51:44 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 5628F658CF44; Sun,  5 Feb 2023 10:51:28 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v8 1/4] liburing: add api to set napi busy poll settings
Date:   Sun,  5 Feb 2023 10:51:19 -0800
Message-Id: <20230205185122.2096480-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230205185122.2096480-1-shr@devkernel.io>
References: <20230205185122.2096480-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
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
 src/liburing.map                |  3 +++
 src/register.c                  | 12 ++++++++++++
 5 files changed, 32 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1f91983..13546c4 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -240,6 +240,9 @@ int io_uring_register_sync_cancel(struct io_uring *ri=
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
index 636a4c2..ab6c86e 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -518,6 +518,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation *=
/
 	IORING_REGISTER_FILE_ALLOC_RANGE	=3D 25,
=20
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			=3D 26,
+	IORING_UNREGISTER_NAPI			=3D 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -640,6 +644,14 @@ struct io_uring_buf_reg {
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
index cebf882..ed29000 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -166,6 +166,8 @@ LIBURING_2.4 {
 		io_uring_prep_recv;
 		io_uring_prep_msg_ring_cqe_flags;
 		io_uring_prep_msg_ring_fd;
+		io_uring_register_napi;
+		io_uring_unregister_napi;
 	local:
 		*;
 };
diff --git a/src/liburing.map b/src/liburing.map
index 1dbe765..013dc4a 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -76,4 +76,7 @@ LIBURING_2.4 {
=20
 		io_uring_enable_rings;
 		io_uring_register_restrictions;
+
+		io_uring_register_napi;
+		io_uring_unregister_napi;
 } LIBURING_2.3;
diff --git a/src/register.c b/src/register.c
index ac4c9e3..966839b 100644
--- a/src/register.c
+++ b/src/register.c
@@ -342,3 +342,15 @@ int io_uring_register_file_alloc_range(struct io_uri=
ng *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
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
2.30.2


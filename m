Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713C0632CC7
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 20:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiKUTPk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 14:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKUTPa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 14:15:30 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F393654F8
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 11:15:16 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 9009A1B8130E; Mon, 21 Nov 2022 11:15:00 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [PATCH v5 1/4] liburing: add api to set napi busy poll settings
Date:   Mon, 21 Nov 2022 11:14:56 -0800
Message-Id: <20221121191459.998388-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121191459.998388-1-shr@devkernel.io>
References: <20221121191459.998388-1-shr@devkernel.io>
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
---
 src/include/liburing.h          |  3 +++
 src/include/liburing/io_uring.h | 12 ++++++++++++
 src/liburing.map                |  6 ++++++
 src/register.c                  | 12 ++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 12a703f..98ffd73 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ri=
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
index a3e0920..25caee3 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -499,6 +499,10 @@ enum {
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
@@ -621,6 +625,14 @@ struct io_uring_buf_reg {
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
diff --git a/src/liburing.map b/src/liburing.map
index 06c64f8..74036d3 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -67,3 +67,9 @@ LIBURING_2.3 {
 		io_uring_get_events;
 		io_uring_submit_and_get_events;
 } LIBURING_2.2;
+
+LIBURING_2.4 {
+	global:
+		io_uring_register_napi;
+		io_uring_unregister_napi;
+} LIBURING_2.3;
diff --git a/src/register.c b/src/register.c
index e849825..ff87e73 100644
--- a/src/register.c
+++ b/src/register.c
@@ -367,3 +367,15 @@ int io_uring_register_file_alloc_range(struct io_uri=
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


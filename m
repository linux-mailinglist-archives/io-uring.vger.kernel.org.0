Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A568B13B
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 19:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjBESvp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Feb 2023 13:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBESvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Feb 2023 13:51:44 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102391C31F
        for <io-uring@vger.kernel.org>; Sun,  5 Feb 2023 10:51:41 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 5AAAC658CF46; Sun,  5 Feb 2023 10:51:28 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v8 2/4] liburing: add documentation for new napi busy polling
Date:   Sun,  5 Feb 2023 10:51:20 -0800
Message-Id: <20230205185122.2096480-3-shr@devkernel.io>
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

This adds two man pages for the two new functions:
- io_uring_register_nap
- io_uring_unregister_napi

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_register_napi.3   | 40 ++++++++++++++++++++++++++++++++++
 man/io_uring_unregister_napi.3 | 27 +++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3

diff --git a/man/io_uring_register_napi.3 b/man/io_uring_register_napi.3
new file mode 100644
index 0000000..6ce8cff
--- /dev/null
+++ b/man/io_uring_register_napi.3
@@ -0,0 +1,40 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_napi 3 "November 16, 2022" "liburing-2.4" "liburin=
g Manual"
+.SH NAME
+io_uring_register_napi \- register NAPI busy poll settings
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_napi(struct io_uring *" ring ","
+.BI "                           struct io_uring_napi *" napi)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_napi (3)
+function registers the NAPI settings for subsequent operations. The NAPI
+settings are specified in the structure that is passed in the
+.I napi
+parameter. The structure consists of the napi timeout
+.I busy_poll_to
+(napi busy poll timeout in us) and
+.IR prefer_busy_poll .
+
+Registering a NAPI settings sets the mode when calling the function
+napi_busy_loop and corresponds to the SO_PREFER_BUSY_POLL socket
+option.
+
+NAPI busy poll can reduce the network roundtrip time.
+
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_napi (3)
+return 0. On failure they return
+.BR -errno .
+It also updates the napi structure with the current values.
diff --git a/man/io_uring_unregister_napi.3 b/man/io_uring_unregister_nap=
i.3
new file mode 100644
index 0000000..f7087ef
--- /dev/null
+++ b/man/io_uring_unregister_napi.3
@@ -0,0 +1,27 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_unregister_napi 3 "November 16, 2022" "liburing-2.4" "libur=
ing Manual"
+.SH NAME
+io_uring_unregister_napi \- unregister NAPI busy poll settings
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_unregister_napi(struct io_uring *" ring ","
+.BI "                             struct io_uring_napi *" napi)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_unregister_napi (3)
+function unregisters the NAPI busy poll settings for subsequent operatio=
ns.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_unregister_napi (3)
+return 0. On failure they return
+.BR -errno .
+It also updates the napi structure with the current values.
--=20
2.30.2


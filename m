Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD395AD3D1
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbiIENZD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbiIENZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:25:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B3F17E2E
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:25:00 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 285BkDnb009235
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:24:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/dwzYe7skYYa7PtXqGvN3HFbnRJ0KJOIyWyVDMKn8H8=;
 b=aOWduP4IjoZUHB0LduRjGx+uNHvyc/AqdtrigqKNt2XIxMwNcasTjSzDyWObHLZ9dJ7E
 csagwtwXwGvfFo/jPAyuu0Yt2Q2zrDD3rCOJc4RGDWIurGAZSeDUk9QFEYf5NDuJH+Zp
 7wq0PA7gY6p5OAzmb4eW5+uRzStuAApURag= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jc2kx0wn2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:24:59 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:24:58 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1E2C65AC516C; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 02/11] Add documentation for IORING_SETUP_DEFER_TASKRUN flag
Date:   Mon, 5 Sep 2022 06:22:49 -0700
Message-ID: <20220905132258.1858915-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AzcduOHQ9m3dJj2eQQu0vmrS5ccUfLZ5
X-Proofpoint-GUID: AzcduOHQ9m3dJj2eQQu0vmrS5ccUfLZ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add man page entry to io_uring_setup.2 for the new flag

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_setup.2 | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 32a9e2ee89b5..01eb70d95292 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -257,6 +257,25 @@ how many userspace tasks do
 .I
 io_uring_enter(2).
 Available since 5.20.
+.TP
+.B IORING_SETUP_DEFER_TASKRUN
+By default, io_uring will process all outstanding work at the end of any=
 system
+call or thread interrupt. This can delay the application from making oth=
er progress.
+Setting this flag will hint to io_uring that it should defer work until =
an
+.BR io_uring_enter(2)
+call with the=20
+.B IORING_ENTER_GETEVENTS
+flag set. This allows the application to request work to run just before=
 it wants to
+process completions.
+This flag requires the
+.BR IORING_SETUP_SINGLE_ISSUER
+flag to be set, and also enforces that the call to
+.BR io_uring_enter(2)
+is called from the same thread that submitted requests.
+Note that if this flag is set then it is the application's responsibilit=
y to periodically
+trigger work (for example via any of the CQE waiting functions) or else =
completions may
+not be delivered.
+Available since 6.1.
 .PP
 If no flags are specified, the io_uring instance is setup for
 interrupt driven I/O.  I/O may be submitted using
--=20
2.30.2


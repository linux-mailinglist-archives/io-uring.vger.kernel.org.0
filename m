Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D242B549A4F
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 19:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiFMRoJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiFMRmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 13:42:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18639158772
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:33 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D1d68h022959
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=YVDzKMOKGKG8h77weDdq3OggI2tckbaO/ENb+ZiltXA=;
 b=q5K+Lqg0uNCWx0R7BD+mHZYgC6KCAkSPgoXWO3N9sYS3wawTf3SeDLQvLepFPL0A2qFt
 G4QfldyJfXT43vovqaEfvXVMXgtJSW7+Zn6nNHg96gVrCOqvYU8QR254QaW4MdtdqVgA
 MYgmn4juRTeIk9JprhmlAIyXIv66MyCq+jg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmrrn85ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 06:13:06 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 13 Jun 2022 06:13:04 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 510FC19A7604; Mon, 13 Jun 2022 06:12:56 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 1/4] remove non-existent manpage reference
Date:   Mon, 13 Jun 2022 06:12:50 -0700
Message-ID: <20220613131253.974205-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613131253.974205-1-dylany@fb.com>
References: <20220613131253.974205-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PnXgy6HIxeBL2PuMkpkRKbAdA__9mrcS
X-Proofpoint-ORIG-GUID: PnXgy6HIxeBL2PuMkpkRKbAdA__9mrcS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_06,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This function doesn't exist

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 man/io_uring_register_buf_ring.3 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/man/io_uring_register_buf_ring.3 b/man/io_uring_register_buf=
_ring.3
index 82a8efc..9e0b53d 100644
--- a/man/io_uring_register_buf_ring.3
+++ b/man/io_uring_register_buf_ring.3
@@ -131,7 +131,6 @@ On success
 returns 0. On failure it returns
 .BR -errno .
 .SH SEE ALSO
-.BR io_uring_buf_ring_alloc (3),
 .BR io_uring_buf_ring_add (3),
 .BR io_uring_buf_ring_advance (3),
 .BR io_uring_buf_ring_cq_advance (3)
--=20
2.30.2


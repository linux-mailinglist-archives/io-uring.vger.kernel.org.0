Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0754BFE4F
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 17:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiBVQSb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 11:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiBVQSa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 11:18:30 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1038165C1F
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:18:03 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21M8MqxR008012
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:18:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=sAS+yhP6M/KBAqTWm+Sl37KXHeR+8ch+5URhdyiyxuI=;
 b=LfcpQD0/am7CzjV4slUyQpwrwDan6sWsXSTPQOtMKa+2kOnbWihQaq3MPK3+tjhY6bSK
 6mlH4qrtHXracBtVnS2yIkpkxGkkzdVFvdJ71uayK7oyP6xqSCCZoZ5ZW0BSi1AjKvYm
 Mop6jk5coEGmPG5KWPYidIRTUfyb2VkDpW0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ecv8qjnmu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 08:18:03 -0800
Received: from twshared26885.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 08:18:00 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 9B20D47F7668; Tue, 22 Feb 2022 08:17:53 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>,
        <syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com>
Subject: [PATCH] io_uring: disallow  modification of rsrc_data during quiesce
Date:   Tue, 22 Feb 2022 08:17:51 -0800
Message-ID: <20220222161751.995746-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2ns3xdp_bOtg_g833dgJ1AjfL6n_R_i6
X-Proofpoint-GUID: 2ns3xdp_bOtg_g833dgJ1AjfL6n_R_i6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_04,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220100
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_ref_quiesce will unlock the uring while it waits for references t=
o
the io_rsrc_data to be killed.
There are other places to the data that might add references to data via
calls to io_rsrc_node_switch.
There is a race condition where this reference can be added after the
completion has been signalled. At this point the io_rsrc_ref_quiesce call
will wake up and relock the uring, assuming the data is unused and can be
freed - although it is actually being used.

To fix this check in io_rsrc_ref_quiesce if a resource has been revived.

Reported-by: syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com
Fixes: b36a2050040b ("io_uring: fix bug in slow unregistering of nodes")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..02086e8e0dec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7924,7 +7924,15 @@ static __cold int io_rsrc_ref_quiesce(struct io_rs=
rc_data *data,
 		ret =3D wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-			break;
+			if (atomic_read(&data->refs) > 0) {
+				/*
+				 * it has been revived by another thread while
+				 * we were unlocked
+				 */
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				break;
+			}
 		}
=20
 		atomic_inc(&data->refs);

base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
--=20
2.30.2


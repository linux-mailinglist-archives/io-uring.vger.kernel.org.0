Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8CC4BDD0B
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377493AbiBUORk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 09:17:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377480AbiBUORk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 09:17:40 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C719DF63
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:17 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21L4KJ8a014222
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7+Oc8xa6Bsvgnpy9ryRsNs518qoE8ZxNm654+iprwTg=;
 b=MCVSv+khawygWSut5xj3DQBvdpVzGsOHMwE0JjZjiagRtYSNHusjCb+zNirvXZwKmAap
 oQSQR6XjEM8ewWYUi/9P/A4BqCYsX958PrpyEBe+CSST6h1yvDsJJSja4xwEyTyBDftH
 LUVZ0xiSiqBHmwtoEm9ooCoF+Iw4i2pDMgw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eaxhx98da-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:17 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 06:17:15 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 6BA3E46F08E3; Mon, 21 Feb 2022 06:17:12 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 0/4] io_uring: consistent behaviour with linked read/write
Date:   Mon, 21 Feb 2022 06:16:45 -0800
Message-ID: <20220221141649.624233-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jogWxTi-r2h4_9I1Lwz1jiAe6I9ILhHZ
X-Proofpoint-GUID: jogWxTi-r2h4_9I1Lwz1jiAe6I9ILhHZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=742
 suspectscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210086
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

Currently submitting multiple read/write for one file with offset =3D -1 =
will
not behave as if calling read(2)/write(2) multiple times. The offset may =
be
pinned to the same value for each submission (for example if they are
punted to the async worker) and so each read/write will have the same
offset.

This patch series fixes this.

Patch 1,3 cleans up the code a bit

Patch 2 grabs the file position at execution time, rather than when the j=
ob
is queued to be run which fixes inconsistincies when jobs are run asynchr=
onously.

Patch 4 increments the file's f_pos when reading it, which fixes
inconsistincies with concurrent runs.=20

A test for this will be submitted to liburing separately.

v2:
  * added patch 4 which fixes cases where IOSQE_IO_LINK is not set

Dylan Yudaken (4):
  io_uring: remove duplicated calls to io_kiocb_ppos
  io_uring: update kiocb->ki_pos at execution time
  io_uring: do not recalculate ppos unnecessarily
  io_uring: pre-increment f_pos on rw

 fs/io_uring.c | 103 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 88 insertions(+), 15 deletions(-)


base-commit: 754e0b0e35608ed5206d6a67a791563c631cec07
--=20
2.30.2


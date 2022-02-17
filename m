Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28324BA54B
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbiBQP6y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 10:58:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiBQP6x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 10:58:53 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E679166A7E
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:39 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H4IuFT029457
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=7i7ZpEwMFIIF3DK2x0LZ1nlkf2sc6rNxVSfC7LiAG8Q=;
 b=BvsvHalOW+zkM4nuPG1fHthFAVDdi/aCvqoAUw5BtPbrmlmSN65RgUaqoTBNy1PwwKpZ
 zKO7pB0Bqb4wM6ElGOHUw8Hf6kY52dyqY3MMUtZUVmUwCIcz421uvcNxtuzR//CQQi7Y
 t5AeQ2tY8hJqvBiiMNY4evHZ5zFkm3Y9Lio= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9f7rbnn0-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:39 -0800
Received: from twshared12416.02.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 07:58:34 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id E5DE74395265; Thu, 17 Feb 2022 07:58:27 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 0/3] io_uring: consistent behaviour with linked read/write
Date:   Thu, 17 Feb 2022 07:58:12 -0800
Message-ID: <20220217155815.2518717-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nz_3aYO1RXwTa2IUc-00wSbsiTJom_FI
X-Proofpoint-ORIG-GUID: nz_3aYO1RXwTa2IUc-00wSbsiTJom_FI
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501 mlxlogscore=698
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170072
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently submitting multiple read/write for one file with IOSQE_IO_LINK
and offset =3D -1 will not behave as if calling read(2)/write(2) multiple
times. The offset may be pinned to the same value for each submission (for
example if they are punted to the async worker) and so each read/write will
have the same offset.

This patchset fixes this by grabbing the file position at execution time,
rather than when the job is queued to be run.

A test for this will be submitted to liburing separately.

Worth noting that this does not purposefully change the result of
submitting multiple read/write without IOSQE_IO_LINK (for example as in
[1]). But then I do not know what the correct approach should be when
submitting multiple r/w without any explicit ordering.

[1]: https://lore.kernel.org/io-uring/8a9e55bf-3195-5282-2907-41b2f2b23cc8@=
kernel.dk/

Dylan Yudaken (3):
  io_uring: remove duplicated calls to io_kiocb_ppos
  io_uring: update kiocb->ki_pos at execution time
  io_uring: do not recalculate ppos unnecessarily

 fs/io_uring.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)


base-commit: 754e0b0e35608ed5206d6a67a791563c631cec07
--=20
2.30.2


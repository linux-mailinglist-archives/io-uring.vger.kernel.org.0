Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767EA7CE115
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjJRPYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 11:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjJRPYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 11:24:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B335194
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:23:59 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IB8i9E027339
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:23:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=p0WjUc4vLfEtzfqeD61Mot1OdvMxukOfxmo5qKfqmk8=;
 b=BDz+6X7qzfjvMbwTgF7VvLEHY6IuoJwlk3jUVBR6lK7lN9LrPXX/oIQvFbhIuJMop9v6
 QocOhwUF7tZ0bst+Y8YaJEDj998xjy03czkXpR0sdCLZsEvoMTHrru/5sU6jBZdWh1LP
 cGUkZbwzH64gnG2sEt2KcHV9JDThPD5JbH1eIA4RK/gaUXQhNy+VYwXS+2Qhe1f+rMZ7
 UolJXcGSzNAua9v3DBnrW/+cG5HdioSf97XEN/iC7WxijQ39OmP8LBXi1k1uR7BVT3ti
 g4TREMmiw/PEw7sI7Hx8r8EezuD3I448zF0M6eSyhYHruu7aDEDpINtmPDk1za19vuDI nw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tte7n9hy9-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:23:58 -0700
Received: from twshared34392.14.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 18 Oct 2023 08:23:56 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id C28C3205F3CE0; Wed, 18 Oct 2023 08:18:43 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 0/4] block integrity: direclty map user space addresses
Date:   Wed, 18 Oct 2023 08:18:39 -0700
Message-ID: <20231018151843.3542335-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: bjZO_lC68Sa-jIr-nM1A5Es3avQxpKyl
X-Proofpoint-ORIG-GUID: bjZO_lC68Sa-jIr-nM1A5Es3avQxpKyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_13,2023-10-18_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Handling passthrough metadata ("integrity") today introduces overhead
and complications that we can avoid if we just map user space addresses
directly. This patch series implements that.

Keith Busch (4):
  block: bio-integrity: add support for user buffers
  nvme: use bio_integrity_map_user
  iouring: remove IORING_URING_CMD_POLLED
  io_uring: remove uring_cmd cookie

 block/bio-integrity.c         |  67 +++++++++++++
 drivers/nvme/host/ioctl.c     | 174 ++++++----------------------------
 include/linux/bio.h           |   8 ++
 include/linux/io_uring.h      |   8 +-
 include/uapi/linux/io_uring.h |   2 -
 io_uring/uring_cmd.c          |   1 -
 6 files changed, 104 insertions(+), 156 deletions(-)

--=20
2.34.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD76372A4EF
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 22:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjFIUpn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 16:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjFIUpm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 16:45:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C80B2D7C
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 13:45:42 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 359KLZgw020324
        for <io-uring@vger.kernel.org>; Fri, 9 Jun 2023 13:45:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=1kZjeiWSwR0l0AHDID9w8iNkq6BqXuyHlq5IGLxTmXc=;
 b=ihq0nR7GzmXeIHgpFcbkUS/Wt0cGqkh8v7JpOh4Oud+ZAXc/WN5U6PoFch22p1hPOuLF
 PAikMmi5HjgondPR1YCGqltq3fkjugpi2+doa7uo/qU4kURdQsyJf0zU32OF3MZtWnQ8
 N/B5nGvI+8Dp6sUlToexLxriCPEE4PluHPu3N2uA4rmIo7u4J/xmsd82MvBTFlDMOS7y
 0JINKFKYARUOe6upHPA34q76ieQIYcHcykHekjB+JBGOqT82V0Oue4+6B6Pfw7avT8Tb
 OE57xzOsgDL7qfxAy+JEkBysaXONHBkvQASMNfQl8t7KlWKeb3LLNI5g815IACi8L1R1 uw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r4b1ug53k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 13:45:41 -0700
Received: from twshared5974.02.ash9.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 13:45:39 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id E007F19D4CC35; Fri,  9 Jun 2023 13:45:19 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/2] enhanced nvme uring command polling
Date:   Fri, 9 Jun 2023 13:45:15 -0700
Message-ID: <20230609204517.493889-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Mjjq-ZH40jDIeO8znPwtXqGk2-Rqb1Mw
X-Proofpoint-GUID: Mjjq-ZH40jDIeO8znPwtXqGk2-Rqb1Mw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_16,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Changes from previous version:

  Used the new hctx polling for the existing request polling use case.
  (Christoph)

  Open coded the qc/rq conversion functions since they're simple and
  have one caller each. (Christoph)

  Merged up to block/for-6.5/io_uring because (1) this series touches
  io_uring uapi, and (2) using this baseline prevents a future merge
  conflict.

Keith Busch (2):
  block: add request polling helper
  nvme: improved uring polling

 block/blk-mq.c                | 48 ++++++++++++++++--------
 drivers/nvme/host/ioctl.c     | 70 ++++++++++-------------------------
 drivers/nvme/host/multipath.c |  2 +-
 drivers/nvme/host/nvme.h      |  2 -
 include/linux/blk-mq.h        |  2 +
 include/uapi/linux/io_uring.h |  2 +
 6 files changed, 56 insertions(+), 70 deletions(-)

--=20
2.34.1


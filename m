Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A876DB3FD
	for <lists+io-uring@lfdr.de>; Fri,  7 Apr 2023 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjDGTRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 15:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjDGTRE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 15:17:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868FEBDD3
        for <io-uring@vger.kernel.org>; Fri,  7 Apr 2023 12:16:58 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 337GiKdO028055
        for <io-uring@vger.kernel.org>; Fri, 7 Apr 2023 12:16:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=nWvxQ8Ox9CeKkhvc5Inedpz7NyvfDoB9E9p0Y0nxkTc=;
 b=OMxWj1dCoTMrTXODRy05JY3uVMH1f8FGOsGMWChfKTeP674FLF3qMplOvrrVRf/YG5dD
 6jBrN/oJ5cQbWNI5XRvWDhWnwN2zk8jxOuWjsBbBwwpS20Bg21Hj0Ra+OYT9a1sHlVqo
 lmJ6jePSfIMh4SP6VGO3AUfO2ZXEH7ydjadfz6ILE6kYdFS1R5noL1pWuq6+3ibHZfAf
 vtjNtNyDvBEgcoLjD2HrbMevlVmY/nRTbEAQ8dFCMXzZuz72DzR/siQQXR8PdCNU1Ajw
 sw2nTsWiIirzB5mNe4DGkvthMnP9te+hX+TuUnGQsSF0Air7wkTa99/f8SP+3ajj+1tu aQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3pt9yhn2am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Apr 2023 12:16:57 -0700
Received: from twshared21760.39.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 7 Apr 2023 12:16:56 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 66855157B5F7D; Fri,  7 Apr 2023 12:16:47 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/5] nvme io_uring_cmd polling enhancements
Date:   Fri, 7 Apr 2023 12:16:31 -0700
Message-ID: <20230407191636.2631046-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 53Q0uHiXht0S0Rg_nC_FhbGsd-U-kDWE
X-Proofpoint-ORIG-GUID: 53Q0uHiXht0S0Rg_nC_FhbGsd-U-kDWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Similar idea as the original v1, but even better.

This series originally aimed at improve polling without payloads, and
fix a potential bug when polling multipath. This ended up significantly
simplifying the nvme uring_cmd handling in the process.

In order to ensure we're polling the correct thing, we need the original
request, but we can't depend on the "cookie" since the field has
multi-purpose. But we have a free spot for the request in the driver's
"pdu", so the driver just needs to detangle the "bio" occupying the same
spot.

Keith Busch (5):
  block: add request polling helper
  nvme: simplify passthrough bio cleanup
  nvme: unify nvme request end_io
  nvme: use blk-mq polling for uring commands
  io_uring: remove uring_cmd cookie

 block/blk-mq.c                |  18 +++++
 drivers/nvme/host/ioctl.c     | 137 ++++++----------------------------
 drivers/nvme/host/multipath.c |   2 +-
 drivers/nvme/host/nvme.h      |   2 -
 include/linux/blk-mq.h        |   2 +
 include/linux/io_uring.h      |   8 +-
 io_uring/uring_cmd.c          |   1 -
 7 files changed, 47 insertions(+), 123 deletions(-)

--=20
2.34.1


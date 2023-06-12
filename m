Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB872CEF1
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 21:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbjFLTEG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 15:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbjFLTEE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 15:04:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29AB7
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:04:03 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35CH5oUe015689
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=4cT2BB79av4X2m47c8QSpy8GnjpJdMG3CuizmFlgZO8=;
 b=nVhZS5GTwOR5q65Hqd/gN4IUHb/PLTqxRyHiFtLmMw8bKDr7UjdzDjoeBFiUVnIdKJpB
 CElO1+eJMInK/yshDVVSTHDKVRyHTpNGCrCexhfA+6JcYCfMK4ZeCBXrPR0a02k/MjT0
 gp0uwz2eZ1NoUT9ot8NDGOcwtgXYGn6cHkWHUo2xVdWtlk07JIg8Il2jWoNjmXJijth+
 suNZZDTMYz9+iUAl1oWIMlP4V+5Jcr/Yw4oL0Ph+uDyKo72SZGA3mFG7PlBAdIDe88ez
 D75363Thj+2oM8r05ge5x8cHrXJmkbnHZx030bIGSuECRRfv7vPNl4+axGWjmaU9IqXz bw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r5xf14csa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:04:02 -0700
Received: from twshared35445.38.frc1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 12:04:01 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id E58CA19FA77A0; Mon, 12 Jun 2023 12:03:44 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/2] enhanced nvme uring command polling
Date:   Mon, 12 Jun 2023 12:03:41 -0700
Message-ID: <20230612190343.2087040-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MA4GyeG3Ce7TZvMkoNfUbaf0khErkWmR
X-Proofpoint-GUID: MA4GyeG3Ce7TZvMkoNfUbaf0khErkWmR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_14,2023-06-12_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Changes from previous version:

  Fixex botched merge compiler bug (kernel test robot)

  Added reviews

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


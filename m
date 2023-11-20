Return-Path: <io-uring+bounces-111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B132A7F2081
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 23:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E26DC1C2188B
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 22:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D081E3C0B;
	Mon, 20 Nov 2023 22:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="BDrW9ouA"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71178A2
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:15 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 3AKMSZNE013393
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=ug9QRpF/FSlWiJJzjUxxWpma7Oj8fHWym/H8mm64YIY=;
 b=BDrW9ouAOFrx2/BcEvAet9hhLURx4pPPJk4U0MtmyluWuCJ31cz9SfcwGqz3DRYJsclk
 Pgf+bP2Jus1p0PUsJ5DPTW3cm0B7fZjEzQaT2NW8DSd4ewknNqQtNEwBRwjEtVaVt5pw
 Ea9SdD7s81zZFClYGfMzOmMxR+ryEC6Utt3Oej+7kNaiBNiDor7iSKrfDi6qFY6ZxAod
 V8sxBWYtTX+KzYrYH/3KFHMYIL/94I4Cfl2nMsFcLhG5PTk6/fy5FMvjkKhZCUi2086B
 Uxy3Ey1jK+xs9+b34JjaBygM13eL7Vxajifozl1lZQYICIUDaGNI18zrNiCna6L33RyQ QA== 
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0001303.ppops.net (PPS) with ESMTPS id 3ugbt1abug-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:14 -0800
Received: from twshared13322.02.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:41:02 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 81B2421F1B1A6; Mon, 20 Nov 2023 14:40:59 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 0/5] block integrity: directly map user space addresses
Date: Mon, 20 Nov 2023 14:40:53 -0800
Message-ID: <20231120224058.2750705-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: M2D3XBtLr8Hl8b7rLEGZkAnesReF8oZP
X-Proofpoint-ORIG-GUID: M2D3XBtLr8Hl8b7rLEGZkAnesReF8oZP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_22,2023-11-20_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Handling passthrough metadata ("integrity") today introduces overhead
and complications that we can avoid if we just map user space addresses
directly. This patch series implements that, falling back to a kernel
bounce buffer if necessary.

v2->v3:

  Introduces a multi-page bvec iterator.

  Fix leaking pinned user pages (Kanchan)

  Fix final unpaired 'put' on user pages (Kanchan)

  Doesn't increase the size of 'struct bio_integrity_profile'; if the
  'copy_vec' pointer is needed, it gets appended to the existing bvec.

  Fix compiler warnings

  Fix compiler error for !CONFIG_BLK_INTEGRITY

Keith Busch (5):
  bvec: introduce multi-page bvec iterating
  block: bio-integrity: directly map user buffers
  nvme: use bio_integrity_map_user
  iouring: remove IORING_URING_CMD_POLLED
  io_uring: remove uring_cmd cookie

 block/bio-integrity.c     | 212 ++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c | 197 ++++++-----------------------------
 include/linux/bio.h       |  12 +++
 include/linux/bvec.h      |   6 ++
 include/linux/io_uring.h  |   9 +-
 io_uring/uring_cmd.c      |   1 -
 6 files changed, 261 insertions(+), 176 deletions(-)

--=20
2.34.1



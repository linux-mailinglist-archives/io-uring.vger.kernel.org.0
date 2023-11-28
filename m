Return-Path: <io-uring+bounces-164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF157FC97B
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 23:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC1511C20FEC
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 22:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B9F50254;
	Tue, 28 Nov 2023 22:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dG3HqqGR"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4E885
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 14:28:08 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 3ASMGMfm014696
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 14:28:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=x1zlHo3Q0pSUeyHRtLLKebQeFEuwDiMtVQDgTgJdZPI=;
 b=dG3HqqGRFHXTBBk8APEbObBCyu6vU73Q5nDlkLQx6qbOii2BB8NLtdrkPx6jHU/HUkQM
 EUnowuO0q6U0Ts75TU2c+HbFYwlmgBOPaw+e1k2d/3OXDJCTD4nM6L1vQDEgBkmsbyHC
 oDeRHnfPFriji3t4PyJzlM25VDjaetmAzQ6Xgy8DVscC7UpNEmyEYhCEMvxqERyrgskj
 PQkMNdZFJ/z7xW6GjzhB8fPsTdi5TFDdScoqYV9T2IzLROyJabEjC52eBw1AOagk35FV
 Y/1HzQWe6v552XUrq1fzRFAh8Prclt+KM/lUycE3DHOLADv5vUroJQnmL+y5IRPvIV3E eA== 
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0089730.ppops.net (PPS) with ESMTPS id 3unf81cty6-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 14:28:07 -0800
Received: from twshared34392.14.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 14:28:05 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 3AE362252F0C0; Tue, 28 Nov 2023 14:27:53 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv4 0/4] block integrity: directly map user space addresses
Date: Tue, 28 Nov 2023 14:27:48 -0800
Message-ID: <20231128222752.1767344-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 5ttxMssCP44LYMZ3wjqz8W7yuSFAWcP4
X-Proofpoint-ORIG-GUID: 5ttxMssCP44LYMZ3wjqz8W7yuSFAWcP4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_24,2023-11-27_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Handling passthrough metadata ("integrity") today introduces overhead
and complications that we can avoid if we just map user space addresses
directly. This patch series implements that, falling back to a kernel
bounce buffer if necessary.

v3->v4:

  Code organization suggestions (Jens, Christoph)

  Spelling and unnecessary punctionation (Anuj)

  Open code the final user page unpin (Ming)

  Eliminate another allocation for the bounce copy by moving the bvec
  into the bip rather than just a pointer to it (me)

Keith Busch (4):
  block: bio-integrity: directly map user buffers
  nvme: use bio_integrity_map_user
  iouring: remove IORING_URING_CMD_POLLED
  io_uring: remove uring_cmd cookie

 block/bio-integrity.c     | 203 ++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c | 197 ++++++------------------------------
 include/linux/bio.h       |   9 ++
 include/linux/io_uring.h  |   9 +-
 io_uring/uring_cmd.c      |   1 -
 5 files changed, 243 insertions(+), 176 deletions(-)

--=20
2.34.1



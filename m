Return-Path: <io-uring+bounces-182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A6D7FFE04
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 22:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3D231C20F54
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 21:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594305E0C8;
	Thu, 30 Nov 2023 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FxVFm3E7"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62C310DE
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:22 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AULJ2C5014893
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=11exKg3ZnsRTT5ybj72lSgW6CmpKbELb2RISVcksvgs=;
 b=FxVFm3E7BkmGUUwVm9sfd1CnEnnZx5VfaHjbcQxmNcd/9jakFluJ54lk6eIumwckSCeW
 xy7K9WwMHr+jwdCAdqXjNsS1N1kqXbs20dGqHjdmZ8ei223YCsBIrp1nEQR0ZvcSxLH8
 am2p73xMgPyt9JgE5rlDVelBHyLmRRWAdK7ujoyQIzJmXZr1Q0jO94Atpeq1/ccvEMoE
 WVXU0YZb96YblLCGTmHCOKj79vpfmO92woaQ8UfCZOIaeIZGZ+Qw756+Gz3hOTdk6P6q
 MgPPzK5nQq80uGO6p75YJfrbagJkUY4N1LUbj15f+Z3VAQ6b0p/e9z1iEU+YgQtq/aKw 6A== 
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3upeus7w67-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:22 -0800
Received: from twshared19681.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 13:53:21 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 2C089226BF681; Thu, 30 Nov 2023 13:53:10 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 0/4] block integrity: directly map user space addresses
Date: Thu, 30 Nov 2023 13:53:05 -0800
Message-ID: <20231130215309.2923568-1-kbusch@meta.com>
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
X-Proofpoint-GUID: vvORouXJWJq5GgVNkmFHamM0mIdKqVNb
X-Proofpoint-ORIG-GUID: vvORouXJWJq5GgVNkmFHamM0mIdKqVNb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-30_22,2023-11-30_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Handling passthrough metadata ("integrity") today introduces overhead
and complications that we can avoid if we just map user space addresses
directly. This patch series implements that, falling back to a kernel
bounce buffer if necessary.

v4->v5:

  Unpin user pages after setup for write commands (Kanchan)

  Added reviews to the unchanged patches (Christoph, Martin)

Keith Busch (4):
  block: bio-integrity: directly map user buffers
  nvme: use bio_integrity_map_user
  iouring: remove IORING_URING_CMD_POLLED
  io_uring: remove uring_cmd cookie

 block/bio-integrity.c     | 214 ++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c | 197 ++++++-----------------------------
 include/linux/bio.h       |   9 ++
 include/linux/io_uring.h  |   9 +-
 io_uring/uring_cmd.c      |   1 -
 5 files changed, 254 insertions(+), 176 deletions(-)

--=20
2.34.1



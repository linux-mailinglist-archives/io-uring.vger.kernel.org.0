Return-Path: <io-uring+bounces-4040-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2CC9B11B4
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 23:37:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B93D91F22194
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 21:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC87920D508;
	Fri, 25 Oct 2024 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="b4Ljz4jb"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0B020C329
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 21:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729892244; cv=none; b=UmGZq/Slh+f7GB2Lfn2+ylYFGpg4WlgvOiGC9LNObTPVz+J50tFR4RCFufOEjLAA95FfLOtPK250aZ1XZtAAKMT8Fq2dO6CztHEXk5aEMDFdYp5abA+DYmBsZn2RsA/u8PPW/4lOCg1VbDM7GSvDNyhYNqEcU0MqDyeOAiotssQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729892244; c=relaxed/simple;
	bh=YOZ58UBNTMsnhcYtd0gZ1ZqymIVjFUr/1L3J9cjAsaQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WD/v4oxEu1dhbes6dT1RkP0idoMzQUVrfSzKaP+55kWgAMHYjSru0lG9KMkgQO+xNsEKI130JT1wGe7pDDYBIT4exreRjIvRONLpReB2ieDBTcqV3oN2iqWqPSXD0ClZEEEDC8z06BmPPPJx1SiBG5Np8vg7Kf5rr646pchFanc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=b4Ljz4jb; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PKXeaG001280
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=/GQfP/1bQVo+MIHxlX
	/7bWekCbFNLz0QJfbEivfPyp8=; b=b4Ljz4jbiYYgNE6E7pJJS61xYVIOwWwnIZ
	8bWHNKURSQBglgrN/fF3PasxbhGqOVFlXIsJfllFNojf/KldUjUn0wuC+D4+0UIT
	a4o8JMppCG2/qzxtExf4OVSc/LThDiDDZ0rmxndnrSKSCR6tj1fxi+t59JmGgij8
	sSfIQUQSa5K3BACjIatE7kw5hsU2voOHUwSuHcQnsRJL7FSU3jkN8+eGWfMH5L1h
	86ud3IUzEsKDFlfkdAu0/4TXulZpJ3WiYvMltx6DKAtEfXEiQGJx3eXKwprjPs6n
	8cMg4ICj0P3BGD3yfveg8MCUR86wCsUyEhmbtuDULGTKvvLMOP/A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ga1xv7hu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:37:21 -0700 (PDT)
Received: from twshared13976.17.frc2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 25 Oct 2024 21:37:20 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 6023F1476D735; Fri, 25 Oct 2024 14:37:06 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <hch@lst.de>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, <bvanassche@acm.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv9 0/7] write hints with nvme fdp, scsi streams
Date: Fri, 25 Oct 2024 14:36:38 -0700
Message-ID: <20241025213645.3464331-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xeH2qNo8pApyDaWeC2i8W_1o0TtkLQ3W
X-Proofpoint-GUID: xeH2qNo8pApyDaWeC2i8W_1o0TtkLQ3W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

A little something for everyone here.

Upfront, I really didn't get the feedback about setting different flags
for stream vs. temperature support. Who wants to use it, and where and
how is that information used?

Changes from v8:

  Added reviews.

  Removed an unused header.

  Changed "hint" to "streams" in the commit logs.

  Ability to split available hints that a partition can use.

  Dropped all the generic filesystem changes that were defaulting to the
  kiocb write_hint. They are unchanged, which having no functional
  change was really the intention anyway, so let's just not change them.

  The above means we don't need a special fop flag to indicate support
  for the kiocb write_hint. Those filesystems that don't support it
  simply don't read it.

  Added the SCSI support since I had to read the spec anyway, and it is
  just a one-line change.

Kanchan Joshi (2):
  io_uring: enable per-io hinting capability
  nvme: enable FDP support

Keith Busch (5):
  block: use generic u16 for write hints
  block: introduce max_write_hints queue limit
  block: allow ability to limit partition write hints
  block, fs: add write hint to kiocb
  scsi: set permanent stream count in block limits

 Documentation/ABI/stable/sysfs-block |  7 +++
 block/bdev.c                         | 15 +++++
 block/blk-settings.c                 |  3 +
 block/blk-sysfs.c                    |  3 +
 block/fops.c                         | 26 ++++++++-
 block/partitions/core.c              | 46 +++++++++++++++-
 drivers/nvme/host/core.c             | 82 ++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h             |  5 ++
 drivers/scsi/sd.c                    |  2 +
 include/linux/blk-mq.h               |  3 +-
 include/linux/blk_types.h            |  4 +-
 include/linux/blkdev.h               | 12 ++++
 include/linux/fs.h                   |  1 +
 include/linux/nvme.h                 | 19 +++++++
 include/uapi/linux/io_uring.h        |  4 ++
 io_uring/rw.c                        |  3 +-
 16 files changed, 225 insertions(+), 10 deletions(-)

--=20
2.43.5



Return-Path: <io-uring+bounces-5417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2E49EBA95
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 21:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F1881884E0E
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 20:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8F91D356E;
	Tue, 10 Dec 2024 20:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="i1/Lxjyt"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7CF8633A
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 20:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733861089; cv=none; b=nyk/qVZwUzBi45/fh/YCTD0l7VoYK1pgMGgMOHE59tMbtDKFOe7Quuk4J6a+XugVtxFYKWg3uvHlz+NYhjfvQZWd6r6t9raJs9QDj7+2bWfmlIGI4+fOlKMeBDkxPe7ax3pIOWjzNMueoFvLWIwQEoF2QFPNh9paBW7EhHWppJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733861089; c=relaxed/simple;
	bh=x5FAuAHlWfJxZCfiPnAfDv6VsD0ypUIU+reJg7JyMuQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QgWOqp7/+ZjfVYK7n/zhaBqx8S3dpyk7PloSUB1hpvQ33CBWeH75guEmvbOz/jwlQSdUAnB68MAN/HRfuW1pE1+Jz1cSRjefRGiDVfrc6pMYMIe6pebp4DUPBFFIKGGVep/tETGf9iBabhcO8sLoI9KhCQVsHzd6DWRa7x3EOZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=i1/Lxjyt; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAFTcQL002558
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 12:04:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=ZtDYxbjHiaugtFmzLq
	be9j/YPTnjBLHkM7Z0sBvStvs=; b=i1/LxjytsrUE2esRwd3xvkCBcnoiRiXuyU
	pbeKfuULkMjMu0pa+MTaqto5feRfwEeTIeHQF1QgRbTZfCjzLDfwXgPC27TsvqYV
	5gb2ODWwzrYYP7V57XvJDs/tZROnH8DWmBkW/c74Ms8mnkQ0fcsGn+zzPEPGzTLb
	GnT45+0dFOv9r7UHNNP1fxNDqZXJShVHfCyiixEztSlanHuXDtzRqW8KMzDEtLy/
	T8eSGXHqBDMmmL7RiixMCDLGK2vxfT9zCTyNZkbxKdHdoM0oxaaQOgu/0kF5U78F
	kpTpOMzIyAYV8074XVkLyHhwgAPyd8uZlhFUfG0Mvp2w0artKgAQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43eraujb8t-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 12:04:45 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 10 Dec 2024 20:04:31 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 207B715D5C7B7; Tue, 10 Dec 2024 11:48:08 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv13 00/11] block write streams with nvme fdp
Date: Tue, 10 Dec 2024 11:47:11 -0800
Message-ID: <20241210194722.1905732-1-kbusch@meta.com>
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
X-Proofpoint-GUID: sYZqWPUhk6_dhXgzbWGi7kRvGnCL64p6
X-Proofpoint-ORIG-GUID: sYZqWPUhk6_dhXgzbWGi7kRvGnCL64p6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Previous discussion threads:

  v12: https://lore.kernel.org/linux-nvme/20241206221801.790690-1-kbusch@=
meta.com/T/#u
  v11: https://lore.kernel.org/linux-nvme/20241206015308.3342386-1-kbusch=
@meta.com/T/#u

Changes from v12:

 - Removed statx. We need additional time to consider the best way to
   expose these attributes. Until then, applications can fallback to the
   sysfs block attribute to query write stream settings.

 - More verbose logging on error.

 - Added reviews.

 - Explicitly clear the return value to 0 for unsupported or
   unrecognized FDP configs; while it's not technically needed (it's
   already 0 in these paths), it makes it clear that a non-error return
   wasn't an accidental oversight.

 - Fixed the compiler warnings from unitialized variable; switched the
   do-while to a more clear for-loop.

 - Fixed long-line wrapping

 - Memory leak when cleaning up the namespace head.

 - Don't rescan FDP configuration if we successfully set it up before.
   The namespaces' FDP configuration is static.

 - Better function name querying the size granularity of the FDP reclaim
   unit.

Christoph Hellwig (7):
  fs: add a write stream field to the kiocb
  block: add a bi_write_stream field
  block: introduce a write_stream_granularity queue limit
  block: expose write streams for block device nodes
  nvme: add a nvme_get_log_lsi helper
  nvme: pass a void pointer to nvme_get/set_features for the result
  nvme: add FDP definitions

Keith Busch (4):
  block: introduce max_write_streams queue limit
  io_uring: enable per-io write streams
  nvme: register fdp parameters with the block layer
  nvme: use fdp streams if write stream is provided

 Documentation/ABI/stable/sysfs-block |  15 +++
 block/bio.c                          |   2 +
 block/blk-crypto-fallback.c          |   1 +
 block/blk-merge.c                    |   4 +
 block/blk-sysfs.c                    |   6 +
 block/bounce.c                       |   1 +
 block/fops.c                         |  23 ++++
 drivers/nvme/host/core.c             | 186 ++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h             |   7 +-
 include/linux/blk_types.h            |   1 +
 include/linux/blkdev.h               |  16 +++
 include/linux/fs.h                   |   1 +
 include/linux/nvme.h                 |  77 +++++++++++
 include/uapi/linux/io_uring.h        |   4 +
 io_uring/io_uring.c                  |   2 +
 io_uring/rw.c                        |   1 +
 16 files changed, 341 insertions(+), 6 deletions(-)

--=20
2.43.5



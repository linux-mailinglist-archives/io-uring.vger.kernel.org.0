Return-Path: <io-uring+bounces-5448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3D99ED658
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 20:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A3DA188BCF4
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 19:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C95B2210F2;
	Wed, 11 Dec 2024 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JX8RI6Cw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A42288CF
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 19:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733944130; cv=none; b=ea9pCLfmDCQWUOhT4i/FqD65iR+DkKvo02exaQWqmsxUp6jIaifor6GV2OFth9iQVXeU4seDn2/kwmvH5agb1QwIf7XdeHovI9RAST/YdZ5fa/pDGHFNfsAf4e/LiV5VIlynIx/XRrvN8DDXlkBTHK6YiwuEQydRfLQ79wQ2F7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733944130; c=relaxed/simple;
	bh=sIHNlv58GzR8qJbuqoxtcjO1QTMLtUk280QOTIo8ols=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P1ALqubERs5eBuuowWUBYw+KTarJi5jAfd9UKmIaqs0rV141twh6DRVIJF0W3LISxrTuvemG1c597wCzLSGTFKi9zqwPDAtKXIRdjLaniuzZapwkz5HKzL7jq36cDGw5uYIMyRl/hdG8epmDfRfxlS9wxZ3bkU+BNQv9FCCVxNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JX8RI6Cw; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBIaOQE026402
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 11:08:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=s8GAwMobQbYzm1WpzP
	fIBLt+oYBnnbj6arNEC9wHIYw=; b=JX8RI6CwFXQDwtwFdYbP50iojC2l8fBcjJ
	ZvB57GxwQ9odca3acZmX/DzDndAevyQ7vugOdzBvCC9NmQWzeBXTOGxHPy18a7nY
	JMH6rZ7RzRmzLiFM+KGg/+I3Nj81fYQqduP2dehfBDdfF2EZ0dyX6gEP4QKIQ+Dg
	Gxx8/pPzqfY2bx86MHi34cJnXuLc4IehQz2YCd5ZP8prr4GM1YKVVsHG5rV5h6ct
	4wheMzhn1pa353euov2DT6t8OlTk5pIsAPzkmdvX+yN92NpTRBdX3PU4f4Zs/c8A
	vkDMAQdOccifqH6MNJliWG+Z8B7/YnGbI5NZX/x3s9W2xjgpZ82g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43fg5k87q2-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 11:08:47 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Dec 2024 19:08:40 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id C094E15DE394C; Wed, 11 Dec 2024 10:35:15 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv14 00/11] block write streams with nvme fdp
Date: Wed, 11 Dec 2024 10:35:03 -0800
Message-ID: <20241211183514.64070-1-kbusch@meta.com>
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
X-Proofpoint-GUID: AbNmIYM4HoCK2Q32CC_ZGt6YbnZz2niz
X-Proofpoint-ORIG-GUID: AbNmIYM4HoCK2Q32CC_ZGt6YbnZz2niz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Previous discussion:

https://lore.kernel.org/linux-nvme/20241210194722.1905732-1-kbusch@meta.c=
om/T/#u

Changes from v13:

  Fixed up printing size_t format (kernel test robot)

  Use %d for endgid (John)

  Removed bdev write stream granularity helper (no user in this series)
  (John)

  Clamp variable size FDP config log page size to max order (Hannes)

  Ensure the log descriptor sizes make sense (Hannes)

  Comment typos (Nitesh)

  Commit log description fix for where to find the write stream
  parameters (Nitesh).

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
 drivers/nvme/host/core.c             | 192 ++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h             |   7 +-
 include/linux/blk_types.h            |   1 +
 include/linux/blkdev.h               |  10 ++
 include/linux/fs.h                   |   1 +
 include/linux/nvme.h                 |  77 +++++++++++
 include/uapi/linux/io_uring.h        |   4 +
 io_uring/io_uring.c                  |   2 +
 io_uring/rw.c                        |   1 +
 16 files changed, 341 insertions(+), 6 deletions(-)

--=20
2.43.5



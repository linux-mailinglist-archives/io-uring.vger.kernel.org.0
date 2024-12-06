Return-Path: <io-uring+bounces-5279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E39ED9E7BAC
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C5D9283BB2
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801611714DF;
	Fri,  6 Dec 2024 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="eEBHxEti"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044022C6C1
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523851; cv=none; b=nNncDFL2PavJE9uquWORUNcmd6BPT1vD9XNM6Gze38ijddxciWL9BJ6P0XhCirmVZZFAJ4hbTkXPV22uij2ydTrvuIQMkFZnJCrcU/kb828Dddm5sB5Wl3Ycdb2oB8gBwOUmrBcpUCWf6GxBlOzCT1P/cF4tNGr8df+UNhN1vXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523851; c=relaxed/simple;
	bh=r3koaxsuV7KRYMQQuL1iABt/DZExJ5OsjL7aJy+EW8s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jLDNTOPXxHQEL3TG/D6hIgu8xsMs4BzZTNJGLJFdUkKD2qZ0GH0oGhftg/ACJgnPTPG5ZJWSqmWe0NnBoV3YbK0DlOwLhecEC3FsCBAZm/uo2yQgdNd6A0EUiTLNzYAmyYOMIMjjSIwM2uaB/P0lwGn2is7uJynIFOMyy8erRyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=eEBHxEti; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4B6LhBt5028061
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:24:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=eoz5xj3OlJBjoZHpah
	qecFAxl1o6Z2RPCniU5IcA/qM=; b=eEBHxEti/bAnRVfXulFldRSKPWw0qFq2x3
	c3Pd8K+teNcXkJ43y4Rvw15j6ngrp0yz+2/71PSPPGQ5Q5bI942kZ1oHYMzxAvWn
	3m+AW+p3fSTvcbOnF6luXY34LojeckIwR+c92lK4sxzzjwvLdNqF8gTd+8vgyxRa
	YccmM14u33WBk9tWtmRmSt6+GHtjhEHP59Bvbry4R1VWyTt/m4kRhZsDCMrGPrX9
	KogTkr6c1+Wk/ngVKg9tM+8tsas+SZMQGRysb64IqssiCGNYbpoG9rVrGUV6T3Xq
	VS1p1TLllBFmv0khgSvNLB22T7fpU9hMZ1BTORyh87wynNYE7bPw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 43c1ggkvha-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:24:08 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:24:03 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id E2A8015B8CB67; Fri,  6 Dec 2024 14:18:26 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 00/12] block write streams with nvme fdp
Date: Fri, 6 Dec 2024 14:17:49 -0800
Message-ID: <20241206221801.790690-1-kbusch@meta.com>
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
X-Proofpoint-GUID: JS93UFkGtLIooYVLchT2abvKdNQTOS0l
X-Proofpoint-ORIG-GUID: JS93UFkGtLIooYVLchT2abvKdNQTOS0l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

changes from v11:

 - Place the write hint in an unused io_uring SQE field
   - Obviates the need to modify the external "attributes" stuff that
     support PI
   - Make it a u8 to match the type the block layer supports
   - And it's just easier to use for the user

 - Fix the sparse warnings from FDP definitions
   - Just use the patches that Christoph posted a few weeks ago since
     it already defined it in a way that makes sparse happy; I just made
     some minor changes to field names to match what the spec calls them

 - Actually include the first patch in this series

Christoph Hellwig (7):
  fs: add a write stream field to the kiocb
  block: add a bi_write_stream field
  block: introduce a write_stream_granularity queue limit
  block: expose write streams for block device nodes
  nvme: add a nvme_get_log_lsi helper
  nvme: pass a void pointer to nvme_get/set_features for the result
  nvme.h: add FDP definitions

Keith Busch (5):
  fs: add write stream information to statx
  block: introduce max_write_streams queue limit
  io_uring: enable per-io write streams
  nvme: register fdp parameters with the block layer
  nvme: use fdp streams if write stream is provided

 Documentation/ABI/stable/sysfs-block |  15 +++
 block/bdev.c                         |   6 +
 block/bio.c                          |   2 +
 block/blk-crypto-fallback.c          |   1 +
 block/blk-merge.c                    |   4 +
 block/blk-sysfs.c                    |   6 +
 block/bounce.c                       |   1 +
 block/fops.c                         |  23 ++++
 drivers/nvme/host/core.c             | 160 ++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h             |   9 +-
 fs/stat.c                            |   2 +
 include/linux/blk_types.h            |   1 +
 include/linux/blkdev.h               |  16 +++
 include/linux/fs.h                   |   1 +
 include/linux/nvme.h                 |  77 +++++++++++++
 include/linux/stat.h                 |   2 +
 include/uapi/linux/io_uring.h        |   4 +
 include/uapi/linux/stat.h            |   7 +-
 io_uring/io_uring.c                  |   2 +
 io_uring/rw.c                        |   1 +
 20 files changed, 332 insertions(+), 8 deletions(-)

--=20
2.43.5



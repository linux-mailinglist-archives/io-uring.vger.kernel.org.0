Return-Path: <io-uring+bounces-7859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E18FAAC44A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C8273A694E
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEFB27AC39;
	Tue,  6 May 2025 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="saxEBW7e"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2527A478
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534859; cv=none; b=f//vPvgm3pPmjoczbc4JXrsoajxSCooF352mN72Lh0HTlU7W8KIZkz097VN8NF1Vhf2vHNfKBn5pudiBESe4z1NWh7HqmuIo02/lt2Adu8eyqZpwgLZYuCOfH9hvFilA1NHgx7kAzHcrSBcCYJGC3T/WuGZ0YyJJUuUWj1tdkzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534859; c=relaxed/simple;
	bh=eOQE0gLVZYrr9y6H0YJ9SasJQbUCpS4eWuL/O+Fkv7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=nJNvQQHKATLxmiedWm0h75Oe2aMqNOQ1E7lAoRAkgk/ZNZhO1L3QMvuvgDBQHI5WP40CN9be++6LC+P3SCPQjUkwwj/gYEohIn/IgpH0CUy6hWoZxMmpZtn9iTUgXxFmaaMRsigGafoR6HrTDE8RvHWbZkgkxm3G6hJGiaFgXDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=saxEBW7e; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250506122636epoutp014bb42ca02677453598bbe5de9deaeb4b~878eYEewS2795627956epoutp012
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250506122636epoutp014bb42ca02677453598bbe5de9deaeb4b~878eYEewS2795627956epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534396;
	bh=EP95YAKMGmar4fGvEahN3sfxzyzUKGg4D2wnOZeDrg8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=saxEBW7etCxAbwq6GD5VB8cpEMo6Dzevc3cdhIZwcWgP45zlhw/ZGjwrr2fqIlrtx
	 yR1REtuaqWnP+j+Mb1O7AHxD6EuwFAA/DzkEwfnbOb/gfKIX1LZIT8LeEkHzRJqjlO
	 atJQXJUbhODGZ8HiV5vtbpp5A27iyJ3788RWf0+E=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122635epcas5p415c62b44a7a1d9d877a84bc1ae8ca4d4~878d-Huyq1362913629epcas5p48;
	Tue,  6 May 2025 12:26:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.181]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4ZsHgs6YTBz2SSKX; Tue,  6 May
	2025 12:26:33 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122633epcas5p21d2c989313f38dea82162fff7b9856e7~878cBgr0K2629626296epcas5p2D;
	Tue,  6 May 2025 12:26:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250506122633epsmtrp137c67cdfd15529befad5ce1ab710c2ba~878cA1-UT2524025240epsmtrp1f;
	Tue,  6 May 2025 12:26:33 +0000 (GMT)
X-AuditID: b6c32a2a-d63ff70000002265-4a-6819fff90a16
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.6E.08805.9FFF9186; Tue,  6 May 2025 21:26:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122632epsmtip2077afd01fb4311aaad9b024ee9ba4802~878an1Igm1679416794epsmtip2Y;
	Tue,  6 May 2025 12:26:31 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v16 00/11] Block write streams with nvme fdp
Date: Tue,  6 May 2025 17:47:21 +0530
Message-Id: <20250506121732.8211-1-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsWy7bCSvO7P/5IZBj/6xC3mrNrGaLH6bj+b
	xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0rbYs/cki8X8ZU/ZHTg9ds66y+5x+Wypx6ZVnWwe
	m5fUe+y+2cDm0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBkT359iLngpWfHk9h2WBsY3Il2M
	HBwSAiYSHxbHdzFycQgJ7GaUmPj2AnMXIydQXFyi+doPdghbWGLlv+fsEEUfGSUuzDvGCNLM
	JqApcWFyKUiNiECAxMvFj5lBapgFljJKdCycCDZIWMBG4teN02CDWARUJTZsnMoIYvMKmEvM
	v/2LFWKBvMTMS9/ZIeKCEidnPmEBsZmB4s1bZzNPYOSbhSQ1C0lqASPTKkbJ1ILi3PTcYsMC
	o7zUcr3ixNzi0rx0veT83E2M4DDW0trBuGfVB71DjEwcjIcYJTiYlUR479+XzBDiTUmsrEot
	yo8vKs1JLT7EKM3BoiTO++11b4qQQHpiSWp2ampBahFMlomDU6qBSezZcS2JRfpH/7xpOaf0
	L/sSn7LJtB13dinIbTSsf9Y9MbVTd3tXw80J0VETN4SIcOsZqh/+oSRTqfKIleFv65zw0ud1
	AozspRdYhBzNvzSGaJ/RbVZsWGfy2+ii4u2SrXK/zG6bRYXr3J7Yk1IZya827WvFRi65ysWy
	T065snK7Jc2SPj+55eTzzMe3uZWnziu9sk7724pHWtJ7jl1MnDJvrbM6b/iuiaZqVpt3utUt
	r007vOda/pG0xusTJeynGVqcyqnMbj7a0WDTP9nTZuOUc3c3sCxO/nrw/5sipp4fKzg6MuZ5
	F3zzn79p1q3nxq+39H95vJpRNcOPP/LeliX1Sf+tbdbZvJ6+7m6ikBJLcUaioRZzUXEiALK5
	JHnSAgAA
X-CMS-MailID: 20250506122633epcas5p21d2c989313f38dea82162fff7b9856e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122633epcas5p21d2c989313f38dea82162fff7b9856e7
References: <CGME20250506122633epcas5p21d2c989313f38dea82162fff7b9856e7@epcas5p2.samsung.com>

The series enables FDP support for block IO.
The patches
- Add ki_write_stream in kiocb (patch 1), and bi_write_stream in bio (patch 2).
- Introduce two new queue limits - max_write_streams and
  write_stream_granularity (patch 3, 4)
- Pass write stream (either from kiocb, or from inode write hints)
  for block device (patch 5)
- Per I/O write stream interface in io_uring (patch 6)
- Register nvme fdp via write stream queue limits (patch 10, 11)

Changes since v15:
- Merged to latest for-next (Jens)

Previous discussions:
v15: https://lore.kernel.org/linux-nvme/20250203184129.1829324-1-kbusch@meta.com/T/#u
v14: https://lore.kernel.org/linux-nvme/20241211183514.64070-1-kbusch@meta.com/T/#u
v13: https://lore.kernel.org/linux-nvme/20241210194722.1905732-1-kbusch@meta.com/T/#u
v12: https://lore.kernel.org/linux-nvme/20241206221801.790690-1-kbusch@meta.com/T/#u
v11: https://lore.kernel.org/linux-nvme/20241206015308.3342386-1-kbusch@meta.com/T/#u
v10: https://lore.kernel.org/linux-nvme/20241029151922.459139-1-kbusch@meta.com/T/#u
v9: https://lore.kernel.org/linux-nvme/20241025213645.3464331-1-kbusch@meta.com/T/#u
v8: https://lore.kernel.org/linux-nvme/20241017160937.2283225-1-kbusch@meta.com/T/#u
v7: https://lore.kernel.org/linux-nvme/20240930181305.17286-1-joshi.k@samsung.com/T/#u
v6: https://lore.kernel.org/linux-nvme/20240924092457.7846-1-joshi.k@samsung.com/T/#u
v5: https://lore.kernel.org/linux-nvme/20240910150200.6589-1-joshi.k@samsung.com/T/#u
v4: https://lore.kernel.org/linux-nvme/20240826170606.255718-1-joshi.k@samsung.com/T/#u
v3: https://lore.kernel.org/linux-nvme/20240702102619.164170-1-joshi.k@samsung.com/T/#u
v2: https://lore.kernel.org/linux-nvme/20240528150233.55562-1-joshi.k@samsung.com/T/#u
v1: https://lore.kernel.org/linux-nvme/20240510134015.29717-1-joshi.k@samsung.com/T/#u


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
 block/fops.c                         |  23 ++++
 drivers/nvme/host/core.c             | 191 ++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h             |   7 +-
 include/linux/blk_types.h            |   1 +
 include/linux/blkdev.h               |  10 ++
 include/linux/fs.h                   |   1 +
 include/linux/nvme.h                 |  77 +++++++++++
 include/uapi/linux/io_uring.h        |   4 +
 io_uring/io_uring.c                  |   2 +
 io_uring/rw.c                        |   1 +
 15 files changed, 339 insertions(+), 6 deletions(-)


base-commit: e6d9dcfdc0c53b87cfe86163bfbd14f6457ef2b7
-- 
2.25.1



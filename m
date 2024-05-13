Return-Path: <io-uring+bounces-1883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A828C3D28
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 10:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05FE7282478
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 08:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8513C1474B0;
	Mon, 13 May 2024 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AZIDRNAq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F3A1474A2
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715588981; cv=none; b=on7YJL1ii4T0QK7b+pkdD9We9yZBLzMwVcXXJeET/Gx7nKsDfgYgn//37b/dM9vE2i3q/16pVz2v2aSwvNbt8Sj7nFCA2SwxoalK4OOCguICeqryvIHvt+UQynU1OfJFAV2JkJftpftDawiE1RUE8hutDxjX4WyXVshP8Nk4am4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715588981; c=relaxed/simple;
	bh=NZ4O6x66zd3GPjs7vj4jBkJ+CZIkvBB/SiJ9OQ7LGzM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=LuUcSCqrFnCj5veRrSoMxM9Z16ihcRYUyuxHmV/8Q4E87Ee4NbRncRZusIKV+c/Ec6u3m1eTIfJ9LB2YaHZ3ysRWlEAzdc3l3lUyGoZZrFxNSkbP3BXf8FvMX4exZkZQURhUegA/3wEWRL+hLcsLldsvR7AsXIzxirG/zUy5TPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AZIDRNAq; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240513082935epoutp02936aa899dbf5bd7004bb4680e88cbd07~O-xVPjwPm1220212202epoutp02T
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 08:29:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240513082935epoutp02936aa899dbf5bd7004bb4680e88cbd07~O-xVPjwPm1220212202epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715588975;
	bh=FGrXOBHCe7bY5f/swu2rrmy6csXA9XzLsgo/XToYpM0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=AZIDRNAq9AbDtTbzvAdG6tWl/7JucsRPZNGoU+OHYowjEUHu1y5YXtvfu1VSVx98J
	 8+A1bRY4n8bJuulY2CbXOPhZZ7M1G9duaoB7wrjLVsCF6Gqc/Guknq3mCnNOn5sxuM
	 hUKcaCplNqTdiurSvqPAbi8mwhyyT0+oP4/sfcKI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240513082934epcas5p4a497a4191dd477e0e9d6481d42c5feca~O-xU7RXSG0141701417epcas5p4_;
	Mon, 13 May 2024 08:29:34 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VdCMd063tz4x9Pp; Mon, 13 May
	2024 08:29:33 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	56.D5.09688.C6FC1466; Mon, 13 May 2024 17:29:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97~O-rrPUaWY2155321553epcas5p23;
	Mon, 13 May 2024 08:23:06 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240513082306epsmtrp10153bf84c76ed624294f18ef529cdb35~O-rrKmgKL1295312953epsmtrp1l;
	Mon, 13 May 2024 08:23:06 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-a2-6641cf6c03da
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.6C.08390.AEDC1466; Mon, 13 May 2024 17:23:06 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513082305epsmtip2e7244983ddca5e545b70b39ea4d42591~O-rqOuJgD1129311293epsmtip2B;
	Mon, 13 May 2024 08:23:05 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v3 0/5] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Mon, 13 May 2024 16:22:55 +0800
Message-Id: <20240513082300.515905-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTUzfnvGOawfVzlhZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ3RteQIc8FlkYp5f1ayNzB2CHQxcnJICJhInLjbwdLFyMUhJLCbUWL1vyWs
	EM4nRombDRuZIJxvjBKvG2cDlXGAtfTfEYKI72WUuHu8D6roF6PEsV03mUHmsgnoSPxe8YsF
	xBYR0JZ4/Xgq2A5mgSWMErs6lzOCJIQFQiX+T13BDjKVRUBVomGGDEiYV8BW4uvs2+wQ98lL
	7D94lhkiLihxcuYTsJnMQPHmrbOZQWZKCNxjl7j7/hUzxHUuEn+XB0D0Cku8Or4Fao6UxMv+
	NnaIkmKJZevkIFpbGCXev5vDCFFjLfHvyh6wJ5kFNCXW79KHCMtKTD21jgliLZ9E7+8nTBBx
	Xokd82BsVYkLB7dBrZKWWDthKzOE7SExq30OmC0kECtx/P031gmM8rOQfDMLyTezEDYvYGRe
	xSiZWlCcm55abFpglJdaDo/X5PzcTYzgRKnltYPx4YMPeocYmTgYDzFKcDArifA6FNqnCfGm
	JFZWpRblxxeV5qQWH2I0BYbwRGYp0eR8YKrOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2x
	JDU7NbUgtQimj4mDU6qBKShqBf+xGI9QV8V9ul2th0WXN3VobNqrl87dcrK68OBdx3M8Yt16
	koG9nrPVrV7/XHn8escm4zV9n6ubLh9p/ynl08M6LaKwZse61dWV4t9cfS5ULPo2JZa37M/u
	N/W31PIX7C4OPPX7+skCt03nYzY92jr5ZpHN6ytnExdeUG+wVzH0WFy/QJzPUtNL48rWtT43
	/aMO3fn5Vee/1MrpF1XCp56++F7Ci/+cr5zZPq4lgW6Hv099mFD2mv2zxL0Fmvt375CZ9rvY
	q3/+qdaDB2dExjIms9xkiuCyPlrXFWobnPQrtC3maMotKR6X7t+WT5+LZso/qtU6eXXfOcuj
	8kxPZLdeC2m1sw74YX2TS4mlOCPRUIu5qDgRAMqBrukdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvO6rs45pBpu28FjMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fouj/9+yWfzqvstosfXLV1aLZ3s5Lc5O+MDqwOWxc9Zddo/LZ0s9
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6NryRHmgssiFfP+rGRvYOwQ6GLk4JAQMJHovyPU
	xcjFISSwm1Fi78bJzF2MnEBxaYmOQ63sELawxMp/z9khin4wSry+fYsFJMEmoCPxe8UvFpBB
	IgK6Eo13FUBqmAVWMUpcfd/OClIjLBAscX/WFiaQGhYBVYmGGTIgYV4BW4mvs29DzZeX2H/w
	LDNEXFDi5MwnYOOZgeLNW2czT2Dkm4UkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8
	dL3k/NxNjOCQ1dLawbhn1Qe9Q4xMHIyHGCU4mJVEeB0K7dOEeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ83573ZsiJJCeWJKanZpakFoEk2Xi4JRqYMraVxh5dteytWvmTFn2rPfJ3QQ+9a1Z2ik7
	rV2Ps4n1KB5ezc/A+lhR6214+QEOs8oVc6pkFI0e7jpiwrNLb3O4gpsW//6PigmneatN/dfO
	WD7VeNbxw6fTXOdN/lvT2vpNYoX78iZxwwzdNx2H1v+tqXHjbtZqWMz2fYLN38RvSRrqGTz9
	a/bEz5nwf/IV2bkfHnM27vBs+ml3UTdzhfp9wQm8vzce+2wx32uRgaP/TZmzHScNvyu1K/48
	xfvg1dadl2Ql7c7udejYOmEey9rIWOfE9s9cFw/0NfBEtl88KsceO3XF129pheEbJi5fVmzi
	vb5mpeuj/61fNinu7dgx9XJq1m3JGJYe5a++OpFKLMUZiYZazEXFiQBU9twtyAIAAA==
X-CMS-MailID: 20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97
References: <CGME20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97@epcas5p2.samsung.com>

Registered buffers are stored and processed in the form of bvec array,
each bvec element typically points to a PAGE_SIZE page but can also work
with hugepages. Specifically, a buffer consisting of a hugepage is
coalesced to use only one hugepage bvec entry during registration.
This coalescing feature helps to save both the space and DMA-mapping time.

However, currently the coalescing feature doesn't work for multi-hugepage
buffers. For a buffer with several 2M hugepages, we still split it into
thousands of 4K page bvec entries while in fact, we can just use a
handful of hugepage bvecs.

This patch series enables coalescing registered buffers with more than
one hugepages. It optimizes the DMA-mapping time and saves memory for
these kind of buffers.

Perf diff of 8M(4*2M) hugepage fixed buffer fio test:

fio/t/io_uring -d64 -s32 -c32 -b8388608 -p0 -B1 -F0 -n1 -O1 -r10 \
-R1 /dev/nvme0n1

Before          After           Symbol

5.90%                           [k] __blk_rq_map_sg
3.70%                           [k] dma_direct_map_sg
3.07%                           [k] dma_pool_alloc
1.12%                           [k] sg_next
                +0.44%          [k] dma_map_page_attrs

First three patches prepare for adding the multi-hugepage coalescing
into buffer registration, the 4th patch enables the feature. The 5th
patch add test cases for this feature in liburing.

-----------------
Changes since v2:

- Modify the loop iterator increment to make code cleaner
- Minor fix to the return procedure in coalesced buffer account
- Correct commit messages
- Add test cases in liburing

v2 : https://lore.kernel.org/io-uring/20240513020149.492727-1-cliang01.li@samsung.com/T/#t

Changes since v1:

- Split into 4 patches
- Fix code style issues
- Rearrange the change of code for cleaner look
- Add speciallized pinned page accounting procedure for coalesced
  buffers
- Reordered the newly add fields in imu struct for better compaction

v1 : https://lore.kernel.org/io-uring/20240506075303.25630-1-cliang01.li@samsung.com/T/#u

Chenliang Li (5):
  io_uring/rsrc: add hugepage buffer coalesce helpers
  io_uring/rsrc: store folio shift and mask into imu
  io_uring/rsrc: add init and account functions for coalesced imus
  io_uring/rsrc: enable multi-hugepage buffer coalescing
  liburing: add test cases for hugepage registered buffers

 io_uring/rsrc.c | 217 +++++++++++++++++++++++++++++++++++++++---------
 io_uring/rsrc.h |  12 +++
 2 files changed, 191 insertions(+), 38 deletions(-)


base-commit: 59b28a6e37e650c0d601ed87875b6217140cda5d
-- 
2.34.1



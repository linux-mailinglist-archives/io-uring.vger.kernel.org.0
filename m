Return-Path: <io-uring+bounces-1899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9928C4D5A
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 09:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F5FB1F22603
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89B017996;
	Tue, 14 May 2024 07:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RLdnZLt4"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889114A8F
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673332; cv=none; b=lKB6nQPH8/8b2/d5EpQi7EGfPhhAOv/geQo/dDArvTCJTROpRuFKR9hKkxbBdpxZ/V8x/UTIJC15wUGT+jzqVvNaWWBcqsypqOdBie2xFOGP/L2iwIIYxdv6pcxc/+nef4TnAD1S5QxBqy6C/A6CeOa8IanIZBA0bM2pJH1Qlc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673332; c=relaxed/simple;
	bh=tGIqK7r1Rf5ay2faVJcx/QTihnHGeiUxaiNJEhY/DOM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=GpxgBKQTnLHahBpk5jT6mG9WklcqEZHD7e39r18Ou7SLq4z+HKrQli5A1Pc/uCaYd8RLTfx2O9T5lip/S5pOOfx9B/ltvkNdZQqlP90qhzkKXyVnUNr8Mzfdz+dSgYZ/Y0eNSyuV9/slb5ZR3FZ2IAPWyKbLwGXCvvzbBln//TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RLdnZLt4; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240514075521epoutp02c4f8f5cff13ed9f006d5c2b7e5979478~PS8vR87AP1040110401epoutp02k
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240514075521epoutp02c4f8f5cff13ed9f006d5c2b7e5979478~PS8vR87AP1040110401epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673321;
	bh=4RXSzJ0DmjhVI+BOs3W0eZ0/5NNJ2g1yhWv0W6A/E8I=;
	h=From:To:Cc:Subject:Date:References:From;
	b=RLdnZLt4oIIOJ+oQIC2fZ5xQIzWAYZGMtMmvpAe0Y4U5bePmcn7FHnDoSB0JWFdt8
	 /CUi7JTNf+YlZ1fcMCk1DmddlfvRBUDxBwAbI6I5TK7vIXdKDV9VTLgkF5nokAJyqs
	 jPA3DYiR2oVUD2NMsRhZzcc9SOeFk8aTAyf5mefA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240514075521epcas5p3b592f616f4116b5e24daaa0b384a719e~PS8uuOZ4L1697316973epcas5p3m;
	Tue, 14 May 2024 07:55:21 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VdpYg3b5tz4x9Pv; Tue, 14 May
	2024 07:55:19 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.79.08600.7E813466; Tue, 14 May 2024 16:55:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be~PS8Ufymcm2658726587epcas5p1Z;
	Tue, 14 May 2024 07:54:53 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514075453epsmtrp1155594b49d3d5df14c173d3a20c744e1~PS8Ue-L8j0510505105epsmtrp1g;
	Tue, 14 May 2024 07:54:53 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-66-664318e79e86
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.21.19234.CC813466; Tue, 14 May 2024 16:54:52 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075451epsmtip2a482a678c3bc4f196a166d60436a634c~PS8TXugjs0428404284epsmtip2B;
	Tue, 14 May 2024 07:54:51 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Tue, 14 May 2024 15:54:40 +0800
Message-Id: <20240514075444.590910-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTU/e5hHOawdyzkhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsbjhXsZC+5JVWzfs5mlgfG3aBcjJ4eEgInE3pWrWLsYuTiEBHYz
	SnRv38YI4XxilHh/YgcbnNP9YyZQGQdYy8pJeRDxnYwSm4+1M0M4vxgllq48wQoyl01AR+L3
	il8sILaIgLbE68dTwWxmgV2MEgvPSYHYwgKhEotmH2cEGcoioCrx+0csSJhXwFZi6u9V7BDn
	yUvsP3iWGSIuKHFy5hOoMfISzVtng+2VELjGLrFpWxfUcS4SnTtcIXqFJV4d3wI1R0riZX8b
	O0RJscSydXIQrS1AT76bwwhRYy3x78oeFpAaZgFNifW79CHCshJTT61jgljLJ9H7+wkTRJxX
	Ysc8GFtV4sLBbVCrpCXWTtjKDGF7SHztOgs2XkggVqJl1gWWCYzys5B8MwvJN7MQNi9gZF7F
	KJlaUJybnppsWmCYl1oOj9bk/NxNjOCEqeWyg/HG/H96hxiZOBgPMUpwMCuJ8DoU2qcJ8aYk
	VlalFuXHF5XmpBYfYjQFhvBEZinR5Hxgys4riTc0sTQwMTMzM7E0NjNUEud93To3RUggPbEk
	NTs1tSC1CKaPiYNTqoHJZ8nxqN9sCYVv3ppOXibtbmAXW2F7xTi/hbl2d5Royo1C7z+sVw5O
	lPh1NSz5S7V3pVRvsSfT3W8TJ5WanCpU4MwJnyEgvurXi/T56ydIfNF9EXhvzlx3KclT3W/0
	p1zR8TqiwPq38HTMGobFd+99v+Qn193gqHJrSXWzboOU3PbIhGUMMnWc6yZJLnxoJX227EX+
	5U3XFW7PvPv16awTlyMUzYObL3XItiaeXGXwdQF3XuTxrpfdXy6ek/Fhmu58VjH1WfipLu5m
	R1GmloPrN8rdnM2lHLeb8+inJzdn+4cyt5ZNnK+Tnu5xXPDywgUlIpMO9XkyFXnt0c8OX/T4
	c/0tMZE4+2+/m1u5VnoosRRnJBpqMRcVJwIAHfHX7yEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvO4ZCec0g2s7zC2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuOFexkL7klVbN+zmaWB8bdoFyMHh4SA
	icTKSXldjFwcQgLbGSU6Ls1h72LkBIpLS3QcaoWyhSVW/nvODlH0g1Gi+XIHI0iCTUBH4veK
	Xywgg0QEdCUa7yqA1DALHAKq2dAMViMsECxxcW4nE0gNi4CqxO8fsSBhXgFbiam/V0HNl5fY
	f/AsM0RcUOLkzCcsIDYzULx562zmCYx8s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeu
	l5yfu4kRHLRaQTsYl63/q3eIkYmDEeguDmYlEV6HQvs0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6pBqbk8PiZj1gD7ogsm3+MqyPizZolDV9X8BxJtnLc
	xPk9p8rUJe9lak6VVU9a2iwHgde8FybdF9Nk7ljg6LP6yKLgK9p6N25evrKpX8j8SlZ/9dPJ
	DIGRxpdWzGs8ZREU/+R8kmrsqlgX3YslJZnnzjsp6UbuZjK96ltyr24L+0Rpm9kXHG4c8GhZ
	dcXgjZCD3pvvR2WkQjQ+XVszN6A+5JFLUIxb4ZfelMavBdEuGXYck6e9qXgR7/QpT1tJmE3j
	0rpvd6f19ogmsWzbdSYgLzTxbu2JV/fmpnesmHBRI0vxQDDPi+NL35nfNOhnO961UsbvrML6
	N20bref3N1Z8VWxXLotOUtr/aPd2oSWcdUosxRmJhlrMRcWJAIX2OKDJAgAA
X-CMS-MailID: 20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be
References: <CGME20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be@epcas5p1.samsung.com>

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

Testing:

The hugepage fixed buffer I/O can be tested using fio without
modification. The fio command used in the following test is given
in [1]. There's also a liburing testcase in [2]. Also, the system
should have enough hugepages available before testing.

Perf diff of 8M(4 * 2M hugepages) fio randread test:

Before          After           Symbol
.....................................................
4.68%				[k] __blk_rq_map_sg
3.31%				[k] dma_direct_map_sg
2.64%				[k] dma_pool_alloc
1.09%				[k] sg_next
                +0.49%		[k] dma_map_page_attrs

Perf diff of 8M fio randwrite test:

Before		After		Symbol
......................................................
2.82%				[k] __blk_rq_map_sg
2.05%				[k] dma_direct_map_sg
1.75%				[k] dma_pool_alloc
0.68%				[k] sg_next
		+0.08%		[k] dma_map_page_attrs

First three patches prepare for adding the multi-hugepage coalescing
into buffer registration, the 4th patch enables the feature. 

-----------------
Changes since v3:

- Delete unnecessary commit message
- Update test command and test results

v3 : https://lore.kernel.org/io-uring/20240514001614.566276-1-cliang01.li@samsung.com/T/#t

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

[1]
fio -iodepth=64 -rw=randread(-rw=randwrite) -direct=1 -ioengine=io_uring \
-bs=8M -numjobs=1 -group_reporting -mem=shmhuge -fixedbufs -hugepage-size=2M \
-filename=/dev/nvme0n1 -runtime=10s -name=test1

[2]
https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u

Chenliang Li (4):
  io_uring/rsrc: add hugepage buffer coalesce helpers
  io_uring/rsrc: store folio shift and mask into imu
  io_uring/rsrc: add init and account functions for coalesced imus
  io_uring/rsrc: enable multi-hugepage buffer coalescing

 io_uring/rsrc.c | 217 +++++++++++++++++++++++++++++++++++++++---------
 io_uring/rsrc.h |  12 +++
 2 files changed, 191 insertions(+), 38 deletions(-)


base-commit: 59b28a6e37e650c0d601ed87875b6217140cda5d
-- 
2.34.1



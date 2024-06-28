Return-Path: <io-uring+bounces-2388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE08191CB7E
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 09:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED699B2265E
	for <lists+io-uring@lfdr.de>; Sat, 29 Jun 2024 07:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4774D1CAA6;
	Sat, 29 Jun 2024 07:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XVHDtnbZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4396714A85
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719645983; cv=none; b=KE8baiMfhkV+ew+A56WPiR6fFJht+x5ZArtwo3FSoWOMTgrhmi8HF3jFwJKmuUZjNiKVYu806i8BnEwyE2QiZDiSakPlj2Ywb00zCC2ENHwWfp8v1WCMTZOyTZoe0qCGdjfi5eAmVKJM94nWcCBB7oT6Q6JHB4x25CyH/LF+Em4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719645983; c=relaxed/simple;
	bh=Yhv4V4jYlvb45WspBtsFq1YXldVmgo5nXVWN6NtzO6c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=uJUVBfb9pPZG5+pEWA33n2r/0GMsjUfmPChUVT1NAlCPicG8vftLOBeLkvyuqK2hiQiN2WH7nSjnX7a2tpNdUn1R+OhQAwed5hwohOBW6AFHlxFr7AUP5iW9wdUfV+vybAW6SMfof0vGQ27SLH7ptznLCU/bpjlNYXKVQi8DoTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XVHDtnbZ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240629072618epoutp04df4c295ef9a5c28e60ce6a78ff4ace82~daOgDkh840838608386epoutp04Z
	for <io-uring@vger.kernel.org>; Sat, 29 Jun 2024 07:26:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240629072618epoutp04df4c295ef9a5c28e60ce6a78ff4ace82~daOgDkh840838608386epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719645978;
	bh=siwQFkvMMgsqcBr1DyQIUmcarwCR5JknPLjS9ztEn1s=;
	h=From:To:Cc:Subject:Date:References:From;
	b=XVHDtnbZs3OAPLyLtqwsww98k9P2F0yAqCDWI6e9wgL3eh3dF8R9U7eXcA7Jm0KSf
	 p8Rnc5lUlpiJIUBM1kfWC4WXcPUHFZJFDuA+gX1z+DoNSnOmAqWfEnwEJ2cZNplbIr
	 NLTdodAUpJsXFJP33eqR9mqKxajtpYfsCW1KyeHM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240629072618epcas5p3b5096e16015aea62a585da91c3c967b0~daOfwQMvX1145611456epcas5p3P;
	Sat, 29 Jun 2024 07:26:18 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WB3kw6hVBz4x9Pt; Sat, 29 Jun
	2024 07:26:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.48.07307.817BF766; Sat, 29 Jun 2024 16:26:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240628084418epcas5p14c304761ca375a6afba3aa199c27f9e3~dHpURndTL1967619676epcas5p18;
	Fri, 28 Jun 2024 08:44:18 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240628084418epsmtrp17c26ef5df012a682e2f06e43692820f3~dHpULnwG_0724807248epsmtrp1Q;
	Fri, 28 Jun 2024 08:44:18 +0000 (GMT)
X-AuditID: b6c32a44-3f1fa70000011c8b-f3-667fb718e438
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.84.18846.2E77E766; Fri, 28 Jun 2024 17:44:18 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240628084416epsmtip160b1b12cf2f05a7524bf6d13a83bc615~dHpS8D0le0054500545epsmtip1t;
	Fri, 28 Jun 2024 08:44:16 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v5 0/3] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Fri, 28 Jun 2024 16:44:08 +0800
Message-Id: <20240628084411.2371-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmpq7E9vo0gyP7DSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7Iy7+94xFjTJVRxbfZy1gfG6RBcjJ4eEgInEmTlHWbsYuTiEBHYz
	Shz7fZcNJCEk8IlR4tnRLIgEkP3z2k0WmI4FZ0CKQBI7GSXO7XnLBOE0MUksal7MBFLFJqAj
	8XvFL7AOEQFtidePp4LZzAK7GCUWnpMCsYUFQiUaJi8FW8cioCrx7c0eMJtXwFri1I7v7BDb
	5CX2HzzLDBEXlDg58wnUHHmJ5q2zmUEWSwjcYpd4duQyI0SDi0TH3tdMELawxKvjW6AGSUm8
	7G8DsjmA7GKJZevkIHpbGCXev5sD1Wst8e/KHhaQGmYBTYn1u/QhwrISU0+tY4LYyyfR+/sJ
	1HheiR3zYGxViQsHt0GtkpZYO2ErM4TtIXFgZQ8rJEhjJV49ucY0gVF+FpJ3ZiF5ZxbC5gWM
	zKsYJVMLinPTU5NNCwzzUsvhEZucn7uJEZw0tVx2MN6Y/0/vECMTB+MhRgkOZiURXv7MujQh
	3pTEyqrUovz4otKc1OJDjKbAMJ7ILCWanA9M23kl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmk
	J5akZqemFqQWwfQxcXBKNTBV+24saE32ehL0jGXpz47j6ntuHPDNcqrSzxW/56xpmT7BSmUp
	y04fJs8TtvOPv3y+fv/5QvdXjcGMTOseWh7sWNPnMjncKcjcaH/8v74zB99sD4x56zV5upHZ
	kr8xmiv3zp21dMLFdesuKJr8evD38PxNm3PZmyovV0x3O/+V4aqIh9DhY9mLpgstknvUoj1P
	oYat0b554hy+xb92tfNeNC+OWGS/V17upn663PVTPmukkv5YeRv8uvwl/3+D2b4DmxfYWJXZ
	rxO1t++p7Z+8ebkjh2SWLmvgjHfzA65+Uz+27MOqjtDI2FNTTK59d5JxWf54ajXD2oKbu+yV
	d3rkzHjYtKLhiGWfX5XTtipvJZbijERDLeai4kQAZtgiPiMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnO6j8ro0gxdz2C2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxt197xgLmuQqjq0+ztrAeF2ii5GTQ0LA
	RGLBmbtsXYxcHEIC2xkleh9PYIdISEt0HGqFsoUlVv57zg5R1MAk0bzjOliCTUBH4veKXyxd
	jBwcIgK6Eo13FUBqmAUOMUo0b2hmBKkRFgiW6Py+nQXEZhFQlfj2Zg8biM0rYC1xasd3qAXy
	EvsPnmWGiAtKnJz5BKyeGSjevHU28wRGvllIUrOQpBYwMq1iFE0tKM5Nz00uMNQrTswtLs1L
	10vOz93ECA5craAdjMvW/9U7xMjEwQh0GAezkggvf2ZdmhBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVAOT6vTP0x51iCcq6vkIzrYxOvKn7dJll5vrYjad
	/B5TrlZWq6afsqJpO/dL7WVTp1RNPHJOfs2RNWz/dk/byH1yhsGrgx9D/r06Wh+7Nnit8pOu
	Yx8+8Qj45SrK8bBpbfIsXV0TUujbY7ye8aam7CYW9+ee7mwXlk0J/XH7h1HxxGDjFFHtsyEV
	/i7/8n3bznfMnjdHaSP7tXl+O76o/1v2Tnvv/8mSbww9Y91spV3ixQonMXI+3eU/8bLUlAvt
	QZ/Mpp60vfit6OFj+6nxm5PuLbz9hNfj07v4bZI/LDVvBvM6/hRVdVjT+aNmRUms8ZuZ60sb
	L72Mfs6yjU9oK4u4Tlh7tVhAeX2fg9WUTWu2KLEUZyQaajEXFScCAJbL3w3LAgAA
X-CMS-MailID: 20240628084418epcas5p14c304761ca375a6afba3aa199c27f9e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240628084418epcas5p14c304761ca375a6afba3aa199c27f9e3
References: <CGME20240628084418epcas5p14c304761ca375a6afba3aa199c27f9e3@epcas5p1.samsung.com>

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
5.88%				[k] __blk_rq_map_sg
3.98%		-3.95%		[k] dma_direct_map_sg
2.47%				[k] dma_pool_alloc
1.37%		-1.36%		[k] sg_next
                +0.28%		[k] dma_map_page_attrs

Perf diff of 8M fio randwrite test:

Before		After		Symbol
......................................................
2.80%				[k] __blk_rq_map_sg
1.74%				[k] dma_direct_map_sg
1.61%				[k] dma_pool_alloc
0.67%				[k] sg_next
		+0.04%		[k] dma_map_page_attrs

First two patches prepare for adding the multi-hugepage coalescing
into buffer registration, the 3rd patch enables the feature. 

-----------------
Changes since v4:

- Use a new compacted array of pages instead of the original one, 
  if buffer can be coalesced.
- Clear unnecessary loops after using the new page array.
- Remove the account and init helper for coalesced imu. Use the original
  path instead.
- Remove unnecessary nr_folios field in the io_imu_folio_data struct.
- Rearrange the helper functions.

v4 : https://lore.kernel.org/io-uring/aaad076c-af5b-46fa-9f74-0c1e8358715b@kernel.dk/T/#t

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

Chenliang Li (3):
  io_uring/rsrc: add hugepage fixed buffer coalesce helpers
  io_uring/rsrc: store folio shift and mask into imu
  io_uring/rsrc: enable multi-hugepage buffer coalescing

 io_uring/rsrc.c | 149 +++++++++++++++++++++++++++++++++++-------------
 io_uring/rsrc.h |  11 ++++
 2 files changed, 120 insertions(+), 40 deletions(-)


base-commit: 50cf5f3842af3135b88b041890e7e12a74425fcb
-- 
2.34.1



Return-Path: <io-uring+bounces-2515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9973932056
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 08:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDFCA1C20C11
	for <lists+io-uring@lfdr.de>; Tue, 16 Jul 2024 06:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A9C17C8B;
	Tue, 16 Jul 2024 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NTOCfoiE"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFBE2599
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721110543; cv=none; b=C8py1ws1of6Ni5nfTEBcCLisZK1mDlN3yQLk/0NjPjJhbik6TAI65ljkD1u8SGHHOmwlvtkBWJKUPRA1xARR4Z6ztzylbIljIAkg6n8yHkqd1JB06IDQnUDiPz/O7+nlbWb3CqpJfxo3pnJCv5lRCOWk28X7zMh/Lc/UUeA4RtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721110543; c=relaxed/simple;
	bh=hc9kXECyw9CYOPmGs6rWjyig1VsPpbr3HIoJdJ3HRV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=qWAiCCw8ss5KlR/2IV8X9ssq9WjE3/9WAYaFDLwochgVgecRJ4Dba/6uxCT84EuuzwLvvFjdw3LDnjf2+BDCX1h8Q2aD6brlPoJQRN0f0u1bv9P3ojrPU5nUyPaZrl4tBl2lDK4yU82IyK1dD9WNzipiNJT4TlhQyFG7CmkJ6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NTOCfoiE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240716061532epoutp038c300ab9a654137d421f666ebbfe6105~inOkCVwwO0579105791epoutp03N
	for <io-uring@vger.kernel.org>; Tue, 16 Jul 2024 06:15:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240716061532epoutp038c300ab9a654137d421f666ebbfe6105~inOkCVwwO0579105791epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721110532;
	bh=kA0+WH9haLLjCjiYLI7SSJGW6IW7Rf94GXpSTAb/pJ8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=NTOCfoiE+vQkSy4kKGUb6LGcBXH6bnGIyulKa2IaUyfZ4UlMcfVglKMT7wYjgQpBX
	 +e398UjSgeBJfISMK02+766gQqbIfoI7j8UvyU8IgTvMfhYi2K/4owdATEvk/WOPGP
	 9A2nBE8t9RQlo/fMQpBww6Xog1subchNOvQjHF6E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240716061531epcas5p111d41d5caec89f54aed9b5db6f39aa26~inOjpMA7v2854528545epcas5p1G;
	Tue, 16 Jul 2024 06:15:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WNTMQ0Ympz4x9Ps; Tue, 16 Jul
	2024 06:15:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	27.BD.06857.10016966; Tue, 16 Jul 2024 15:15:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240716060814epcas5p1af3b8ddba3f7bd951719854546a82278~inIMNI-u_2840328403epcas5p1u;
	Tue, 16 Jul 2024 06:08:14 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240716060814epsmtrp1a33136869a1271be4a7ed9ecc541b3a0~inIMMJqfg1538315383epsmtrp1R;
	Tue, 16 Jul 2024 06:08:14 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-28-66961001c8e2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E7.DC.18846.E4E06966; Tue, 16 Jul 2024 15:08:14 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240716060812epsmtip1c5a83162ae9fd5d7017204363e528150~inIKvDXsm2552125521epsmtip1t;
	Tue, 16 Jul 2024 06:08:12 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v6 0/2] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Tue, 16 Jul 2024 14:08:05 +0800
Message-Id: <20240716060807.2707-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmpi6jwLQ0g7WfzCyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IzFV1YxF3wSr5i67Qt7A+MEoS5GTg4JAROJNz/eMncxcnEICexm
	lJgxewoLhPOJUeLTm7+McM6m0xtYYVour30CldjJKDFpxz+oliYmiVu7ulhAqtgEdCR+r/gF
	ZosIaEu8fjwVzGYW2MUosfCcFIgtLBAqcXzxOrA4i4CqxPd188A28ApYS8xdfBhqm7zE/oNn
	mSHighInZz6BmiMv0bx1NtjhEgL32CVWPX8J1eAi0XDpKhuELSzx6vgWdghbSuJlfxuQzQFk
	F0ssWycH0dvCKPH+3RxGiBpriX9X9rCA1DALaEqs36UPEZaVmHpqHRPEXj6J3t9PmCDivBI7
	5sHYqhIXDm6DWiUtsXbCVmYI20Pi3sU1YHEhgViJdx8esE5glJ+F5J1ZSN6ZhbB5ASPzKkbJ
	1ILi3PTUYtMC47zUcnjMJufnbmIEp00t7x2Mjx580DvEyMTBeIhRgoNZSYR3AuO0NCHelMTK
	qtSi/Pii0pzU4kOMpsAwnsgsJZqcD0zceSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRm
	p6YWpBbB9DFxcEo1MIkun3wtOvlB41u7W7KHGltsr80+t898t6au02IJUUOBtO+u+zg22jUv
	3n7u+TyFrbUuCfF/lC7dWnDa4dBHj2NnEp//++Cb+WrulsVnnhQ7uXX9umj20WlB6MGH4p+X
	9W5O1vscs5RhElfq2Teds3es/O5a3iWacr/LbKqnwjlt3uDFM/zY/tqwhdqa/ls6V17thd5U
	49sXLxjlRzee6fpd9L+w584Uqfapen4v5e5ZnTq4Y/qc5vakS+pzupp8GV5m696f8Df9xWZt
	iaNmi499YTmbmrqeq+Lp/7+bNvyufn1mas2j7Yl3NJLX7/8saFn5U2Pegmr+88tjZ06Vroj1
	v2lSGsXPeuxbd6yizoeXSizFGYmGWsxFxYkA3RTqSSQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSnK4f37Q0gwkzeCyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuIrq5gLPolXTN32hb2BcYJQFyMnh4SA
	icTltU8Yuxi5OIQEtjNKLDyxgQ0iIS3RcaiVHcIWllj57zk7RFEDk8TvpjnMIAk2AR2J3yt+
	sXQxcnCICOhKNN5VAKlhFjjEKNG8oZkRJC4sECzxeJ8bSDmLgKrE93XzWEFsXgFribmLD7NC
	zJeX2H/wLDNEXFDi5MwnLCA2M1C8eets5gmMfLOQpGYhSS1gZFrFKJpaUJybnptcYKhXnJhb
	XJqXrpecn7uJERy2WkE7GJet/6t3iJGJgxHoLg5mJRHeCYzT0oR4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzKud0pggJpCeWpGanphakFsFkmTg4pRqYlO7nMH+cYf3u9Kvu9CT5Bf5pelubdm9Y
	mO+SNmXVlLo1l7T+BH98/GXFjugwyQNB6TXa69SqF5uuf+rNdUTp6S7hCQ1h6/mYUxTfNhtP
	VFrNnsD5v4ah6OeSSw2S6t/U321YVtoluTbQYqnlAo43zwvcguMWnFwi07HpEeM5ay6Nnkm/
	BSKOfjnva1D5NeLF98TXLSkHoi8u3Cj6y0XmudEvgdc7Ddap19TODywJOXWD9+djjXNcs7K+
	7U09knJQnIFTZc01c9arc/oyjWYpSvQazlt+XeLrQs4l8cufydXek2T0aQ2Zsp+ZXTFK7/a8
	ayq1lk+m9cbkhZ8/mKZQUbpLZ9llqeVLd1vI3zWLVmIpzkg01GIuKk4EAGovyxvKAgAA
X-CMS-MailID: 20240716060814epcas5p1af3b8ddba3f7bd951719854546a82278
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240716060814epcas5p1af3b8ddba3f7bd951719854546a82278
References: <CGME20240716060814epcas5p1af3b8ddba3f7bd951719854546a82278@epcas5p1.samsung.com>

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
5.88%                           [k] __blk_rq_map_sg
3.98%           -3.95%          [k] dma_direct_map_sg
2.47%                           [k] dma_pool_alloc
1.37%           -1.36%          [k] sg_next
                +0.28%          [k] dma_map_page_attrs

Perf diff of 8M fio randwrite test:

Before          After           Symbol
......................................................
2.80%                           [k] __blk_rq_map_sg
1.74%                           [k] dma_direct_map_sg
1.61%                           [k] dma_pool_alloc
0.67%                           [k] sg_next
                +0.04%          [k] dma_map_page_attrs

The first patch prepares for adding the multi-hugepage coalescing
by storing folio_shift and folio_mask into imu, the 2nd patch
enables the feature.

---

Changes since v5:
- Reshuffle the patchset to avoid unused funtion warnings.
- Store head page of the folio and use folio offset to get rid of
  branching on bvec setups.
- Add restrictions for non border-aligned folios.
- Remove unnecessary folio_size field in io_imu_folio_data struct.

v5 : https://lore.kernel.org/io-uring/20240708021426.2217-1-cliang01.li@samsung.com/T/#t

[1]
fio -iodepth=64 -rw=randread -direct=1 -ioengine=io_uring \
-bs=8M -numjobs=1 -group_reporting -mem=shmhuge -fixedbufs -hugepage-size=2M \
-filename=/dev/nvme0n1 -runtime=10s -name=test1

[2]
https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@samsung.com/T/#u

Chenliang Li (2):
  io_uring/rsrc: store folio shift and mask into imu
  io_uring/rsrc: enable multi-hugepage buffer coalescing

 io_uring/rsrc.c | 154 +++++++++++++++++++++++++++++++++++-------------
 io_uring/rsrc.h |  10 ++++
 2 files changed, 123 insertions(+), 41 deletions(-)


base-commit: ad00e629145b2b9f0d78aa46e204a9df7d628978
-- 
2.34.1



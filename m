Return-Path: <io-uring+bounces-2543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B849399B2
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 08:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 322E1282837
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 06:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7204713D245;
	Tue, 23 Jul 2024 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qMNbHyDg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5868213D896
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721716109; cv=none; b=c8spaNh7qmAKgdwv9oHcVQcdhk5mxv/LgXXAvZRr5iB/r33wtN1xaRao/1otiANyqtgETFfkbBYY7zVN90c/n5my8DXDQPLhSvOQdqjgJDC9J/iUpUy469+YJfmmOPC74oKespfDPSdoAQ5vzOhVJ440AW9O8oew0IWMfT/8ur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721716109; c=relaxed/simple;
	bh=6LkZIaV25Umepu3RRnLIZsTbE0rwUXA5LabWF/U3uGg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=O8nrP3TZJZzo/FqMI/uiR6uAVQuXBsbQdN7xiPY1H59l/SATFCrZCHWDZnihtTOrKVB5fG8qb4XnK9ZqTAa0ZtXj83nws5B+PuojVcB1i3WDvoOn4U9sFXWTLdwJj9L3l5Ut6+rXr9gVBay6IC2wXw/LPgKbQqHhMHTyrdzmA1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qMNbHyDg; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240723062823epoutp04efe991b712aa1cef67781fd541ad7b74~kw6yrt5HV0252602526epoutp04l
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 06:28:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240723062823epoutp04efe991b712aa1cef67781fd541ad7b74~kw6yrt5HV0252602526epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721716103;
	bh=j1D4fEg1q7yPUeRbmqYlSUXe4kun4IxB3DqUj70WMD8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=qMNbHyDgxPt/wYLHJXYNG9vBMUaOfE94OAVP/aHCzJBUVvFDQFAMMDZyF6mdPLkLy
	 MM96RIdIOXF83XyGu1ea2lB2tEuRhnuuqzLA2vqvmLeDJL4HwwUMDLbUvUju+hy7I2
	 I7i1FPUTckfRa6OQ1caeiD4aMIfz4PO+qwfC/K34=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240723062823epcas5p48344a3789f077a97c990c966e42779f1~kw6yU4eWp0854308543epcas5p4E;
	Tue, 23 Jul 2024 06:28:23 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WSnK163tLz4x9Pv; Tue, 23 Jul
	2024 06:28:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C3.82.09640.58D4F966; Tue, 23 Jul 2024 15:28:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240723055622epcas5p119f4befb453407a7ac756c1cee582ced~kwe1k00xm2316223162epcas5p1g;
	Tue, 23 Jul 2024 05:56:22 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240723055622epsmtrp1530250ae5b37d9f31b40fd2a7f8b2f6d~kwe1jqzZ41885118851epsmtrp1G;
	Tue, 23 Jul 2024 05:56:22 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-4b-669f4d85ca78
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.B3.07567.6064F966; Tue, 23 Jul 2024 14:56:22 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240723055621epsmtip244220963576750b738e948943c25ce61~kwe0LCEwF1406214062epsmtip2s;
	Tue, 23 Jul 2024 05:56:21 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [Patch v7 0/2] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Tue, 23 Jul 2024 13:56:14 +0800
Message-Id: <20240723055616.2362-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmpm6r7/w0g9YLmhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsamf7fYCj6JV1yYNJGlgXGCUBcjJ4eEgInE1fZ1zF2MXBxCArsZ
	JZ4ves4E4XxilDj5/TQzSJWQwDdGieYeY5iO7mnf2SCK9jJKzP1xAaq9iUli++1WJpAqNgEd
	id8rfrGA2CIC2hKvH08Fs5kFdjFKLDwnBWILC4RKrP7yGyzOIqAq0fFuHyOIzStgLfH7RRcz
	xDZ5if0HzzJDxAUlTs58AjVHXqJ562ywxRICj9glps1vZ4FocJGYe+MZVLOwxKvjW9ghbCmJ
	l/1tQDYHkF0ssWydHERvC6PE+3dzGCFqrCX+XdnDAlLDLKApsX6XPkRYVmLqqXVMEHv5JHp/
	P2GCiPNK7JgHY6tKXDi4DWqVtMTaCVuhTvCQuP5zERMkFGMl/n67yDiBUX4WkndmIXlnFsLm
	BYzMqxglUwuKc9NTi00LDPNSy+ERm5yfu4kRnDS1PHcw3n3wQe8QIxMH4yFGCQ5mJRHeJ6/m
	pgnxpiRWVqUW5ccXleakFh9iNAWG8URmKdHkfGDaziuJNzSxNDAxMzMzsTQ2M1QS533dOjdF
	SCA9sSQ1OzW1ILUIpo+Jg1OqgUlD8qB08tOnZoWf12h5bZfPm/5jr4OLUd5C5zU7hDbUvDDZ
	XKCfVz6VqWuFWRaHt3Ec377PboVR339cO7/iR6PA44jNBgsr/txc0JG97uV6GR/zlTNrauc+
	yVwsXyb1a1uM1YcT09pnG31h3tgU4jo7fZ8xb7nbepNsH+bzJjePKLhs639kXXNxp53GNo6j
	go21xi8fTPi9il3Z8FDRzt3C00L7ecX2MF2OWMihs1MtZLJB2p09kWWvm8TOn7zTl1TlavG3
	RZBZNDvdTCF2f3he5l3mp72y6trvXrO/WF3pFSpmqFleIHbtWcPhxsLWPQcK0u1MRL7n/1ng
	/7TVW99wbsac5UuOzaxme+z0XImlOCPRUIu5qDgRAKb0I7AjBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSvC6b2/w0g8ZphhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY9O/W2wFn8QrLkyayNLAOEGoi5GTQ0LA
	RKJ72ne2LkYuDiGB3YwS/f+mMUIkpCU6DrWyQ9jCEiv/PWeHKGpgkvi/4hBYEZuAjsTvFb9Y
	uhg5OEQEdCUa7yqA1DALHGKUaN7QDFYjLBAs8WvpI7BBLAKqEh3v9oHFeQWsJX6/6GKGWCAv
	sf/gWWaIuKDEyZlPWEBsZqB489bZzBMY+WYhSc1CklrAyLSKUTK1oDg3PTfZsMAwL7Vcrzgx
	t7g0L10vOT93EyM4gLU0djDem/9P7xAjEwcj0HEczEoivE9ezU0T4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkzms4Y3aKkEB6YklqdmpqQWoRTJaJg1OqgemYVe3bte752ZO+3ZBcVHUte/M6w+DV
	h/PUcxK8UtY9P2C9O2TjBw/bUzHG6Zejjv8Uzpst7Kw9w3ipcKP5gTsuM3e0nqwtYJz+uPiw
	uPNiqZWPsorl4oLWRF+e8k/U/c+/k3Up9ffYZabP+RjLq2K2d/LC/0VnPTaay61QW9NutStE
	jnWR+HfnAj4Vz9r52+Yv//k70lp75vOGu3wKYU4bVjh/Opt/9Pn+bVJtNx6kV6wRWTlX/f5N
	ny1nFb5zGO+vf24ouei82KSCKL5561czeGV/2Hevdv8vFie59frMPW6SUrsmbJionrJlqvor
	ba5WQakXruUu5VnGczv/8fltq6+UbLq98lG5qvkKgYtKLMUZiYZazEXFiQA1fOy9zwIAAA==
X-CMS-MailID: 20240723055622epcas5p119f4befb453407a7ac756c1cee582ced
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240723055622epcas5p119f4befb453407a7ac756c1cee582ced
References: <CGME20240723055622epcas5p119f4befb453407a7ac756c1cee582ced@epcas5p1.samsung.com>

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

 io_uring/rsrc.c | 149 +++++++++++++++++++++++++++++++++++-------------
 io_uring/rsrc.h |  10 ++++
 2 files changed, 118 insertions(+), 41 deletions(-)


base-commit: ad00e629145b2b9f0d78aa46e204a9df7d628978
-- 
2.34.1



Return-Path: <io-uring+bounces-1868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A86E8C2FD5
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 08:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB8CDB22089
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 06:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59188A41;
	Sat, 11 May 2024 06:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eJvfy8pB"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538D2380
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715409041; cv=none; b=uN3h4fnu3OLsnW+JmVSiAiopccY6GJWshma3ZUHVfqla9iUndXj11yE5XTHx59xYM7G14zGg5ZVy+5rb78NsxLDTKAETWOzTdumth2GfrThfOpt8XP2eFH91XR2e67H8E3o2oEOvoca/0m6RxS3nMAclpSA5xHwG5aWRSq2hnmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715409041; c=relaxed/simple;
	bh=0c5e9F9IU0lhyVAZXpwl6QLcPw/9LxkFCgcp2/yfeS0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=mWhY61HMi1Ym+4+6SGUA8GgG+OSZt+XLAutZaKBLYNcCzuH2SIKnaUnHozMkatsGmfM3VkXUw5gH2Vs7sx/80wM/VDW1ljtgvXesu7tRjivQo2DrlbCEvOaCh7bX41JeBvhk6ry3QoCrR3hgvjLDvMeTHni+Kj6P6RC7+Q7kQRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eJvfy8pB; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240511063035epoutp02ff4d25087ce0fde12d53132d5d34915a~OW2357Afx1486714867epoutp02e
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 06:30:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240511063035epoutp02ff4d25087ce0fde12d53132d5d34915a~OW2357Afx1486714867epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715409036;
	bh=H8t/yVo1kMlsgfVDlKFqXQf7UBry1l9JIdQF+tnTTxA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=eJvfy8pB6wAbJLCW2p2dUrIZyPcJdnOGEqlihzaAq9sd76DmSWYkgvpuGZMLjvqdh
	 J9YlyOE+guZLKKZx/ZWitvWt0Hn7yuhzTYofab/Spme+3N5Nk5BH1CNg8CuZcqZqCh
	 /aVk+cFNykz/SRyakLcYNvyiRQy0DCHfBwLVMOe0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240511063035epcas5p275cb6baa14695c5842e758fd82549ffc~OW23cksT93224332243epcas5p2p;
	Sat, 11 May 2024 06:30:35 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VbwqD63H8z4x9Pr; Sat, 11 May
	2024 06:30:32 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E0.82.08600.8801F366; Sat, 11 May 2024 15:30:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240511055242epcas5p46612dde17997c140232207540e789a2e~OWVyXwk0n2231022310epcas5p4k;
	Sat, 11 May 2024 05:52:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240511055242epsmtrp1c8326d74d291b69ebb808be4a4f425d3~OWVyV9ca_2071620716epsmtrp1R;
	Sat, 11 May 2024 05:52:42 +0000 (GMT)
X-AuditID: b6c32a44-921fa70000002198-ab-663f1088a4eb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5A.04.08924.AA70F366; Sat, 11 May 2024 14:52:42 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240511055241epsmtip1bf38fbb7d006ad7209583b21da960753~OWVxXQE7S0560305603epsmtip1Z;
	Sat, 11 May 2024 05:52:41 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Sat, 11 May 2024 13:52:25 +0800
Message-Id: <20240511055229.352481-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTQ7dDwD7NYGengcWcVdsYLVbf7Wez
	OP33MYvFzQM7mSzetZ5jsTj6/y2bxa/uu4wWW798ZbV4tpfT4uyED6wOXB47Z91l97h8ttSj
	b8sqRo/Pm+QCWKKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8
	AnTdMnOAzlFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWW
	WBkaGBiZAhUmZGcsu9LNXLBRsGLmzUusDYzreLsYOTkkBEwkVp+/ztjFyMUhJLCbUWL18+8s
	EM4nRolVC1YwglQJCXxjlJixR6WLkQOs4/jlDIiavYwSLw5PZoZwfjFK7HuyngWkgU1AR+L3
	il9gtoiAtsTrx1PBpjILLGGU2NW5HGyqsECoxIv1LUwgNouAqsTNSR1gcV4BW4kZzdOZIe6T
	l9h/8CwzRFxQ4uTMJ2BDmYHizVtng22WELjFLnH+1T1GiAYXiTXvP7FB2MISr45vYYewpSRe
	9rexQ7xQLLFsnRxEbwujxPt3c6B6rSX+XdnDAlLDLKApsX6XPkRYVmLqqXVMEHv5JHp/P2GC
	iPNK7JgHY6tKXDi4DWqVtMTaCVuh7veQ+HrwMRskFGMlTmx4yTaBUX4WkndmIXlnFsLmBYzM
	qxglUwuKc9NTk00LDPNSy+ERm5yfu4kRnCq1XHYw3pj/T+8QIxMH4yFGCQ5mJRHeqhrrNCHe
	lMTKqtSi/Pii0pzU4kOMpsAwnsgsJZqcD0zWeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQn
	lqRmp6YWpBbB9DFxcEo1MD3IWra15fKWW3t6y2U6BS3qpSamqHjGbuWW2fFB4qBW2PNIqeVf
	Nm/eZNpzasdr0RkBmqoMX5YEzmBNPy7XuM/z01ufZT+X/kp32l543zT/aeMiV88bqxwv1kzU
	SU28csJ1fWpx7t+X7xWSdWvUPpnzzwzfcLguxTG1d0HHbcl27oJ/KcuOsmpfPvSZ7erPGanT
	YryNL7zIlf5nPzltwl11kfvpf+q8pu6tN+TKDXo9PflO8PHV/JKHl7Tlcd6d0zehlK3R6vx+
	ttcF7nZX0wL274zddc3w3NKJMueEt0f5JNz1Z2xcuL5HriQz4N09noRcfyFv1v9S8+YcdM/u
	TfD+ob/xwqpZe7ad5K+v3qPEUpyRaKjFXFScCAByDlDnHgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnO4qdvs0g3+TOS3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlbHsSjdzwUbBipk3L7E2MK7j7WLk4JAQMJE4fjmj
	i5GLQ0hgN6PE/fZbzF2MnEBxaYmOQ63sELawxMp/z9khin4wSjS+XMACkmAT0JH4veIXC8gg
	EQFdica7CiA1zAKrGCWuvm9nBakRFgiWaPgyCayeRUBV4uakDkYQm1fAVmJG83SoZfIS+w+e
	ZYaIC0qcnPkErJ4ZKN68dTbzBEa+WUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L
	10vOz93ECA5aLc0djNtXfdA7xMjEwXiIUYKDWUmEt6rGOk2INyWxsiq1KD++qDQntfgQozQH
	i5I4r/iL3hQhgfTEktTs1NSC1CKYLBMHp1QDU07Ojg1Pfr59z/X7UdvL/q95Sp++9z+p1At5
	fPOJ9rPa0qJtO1ncDqx/mu4pnOFh87fV3jJdVe2LyIwbORUFbEFsSdvezL5aUSNl+mlHyTbO
	okC3Nr6qSE92zisr9h++/PmbjB/T3fa0hvNSMzs8E2qY2TTDr/pWXmZdaBjXOsOS6+27uWdT
	5BcfmVTt56jutta+y1p/gSuH+/frOYbh6z4+vZX5WOaxl/Nj25Uv6oVnn7GaGvcoL6WfU3bW
	KuuXyeuYgg9PFgn8qTGv5MutpQtmq8noCr6MU712f9Vbu++Kx3ccPb7X/GilUbCiTvV5vvmX
	fzEJsC5omH2zMvBJ+0aNqgVlx+L4982wPHi3QYmlOCPRUIu5qDgRABZGm9fJAgAA
X-CMS-MailID: 20240511055242epcas5p46612dde17997c140232207540e789a2e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240511055242epcas5p46612dde17997c140232207540e789a2e
References: <CGME20240511055242epcas5p46612dde17997c140232207540e789a2e@epcas5p4.samsung.com>

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
into buffer registration, the 4th patch enables the feature.

-----------------
Changes since v1:

- Split into 4 patches
- Fix code style issues
- Rearrange the change of code for cleaner look
- Add speciallized pinned page accounting procedure for coalesced
  buffers
- Reordered the newly add fields in imu struct for better compaction

v1 : https://lore.kernel.org/io-uring/20240506075303.25630-1-cliang01.li@samsung.com/T/#u

Chenliang Li (4):
  io_uring/rsrc: add hugepage buffer coalesce helpers
  io_uring/rsrc: store folio shift and mask into imu
  io_uring/rsrc: add init and account functions for coalesced imus
  io_uring/rsrc: enable multi-hugepage buffer coalescing

 io_uring/rsrc.c | 214 +++++++++++++++++++++++++++++++++++++++---------
 io_uring/rsrc.h |  12 +++
 2 files changed, 188 insertions(+), 38 deletions(-)


base-commit: 59b28a6e37e650c0d601ed87875b6217140cda5d
-- 
2.34.1



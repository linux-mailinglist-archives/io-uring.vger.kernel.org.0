Return-Path: <io-uring+bounces-2622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AF09429D4
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 11:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E021282361
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 09:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4A31CF93;
	Wed, 31 Jul 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aiWcGvUT"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5841A8C0D
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722416526; cv=none; b=ABTyg4/LOuwpmkabIJfGdscf1QREC8wDmEnX+hQv1CrwI+re3eUTcOVS4Qf+XW4RvToo+eylDNahkgO5JA6iipSz0Q+/Ik8Eaiy2Kl2jGedZ9TL62xRcDPTnbg0wnkRuKMolNEDJa/otTYt46FcHPD5N78cViVT5xTnWri9TjKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722416526; c=relaxed/simple;
	bh=Q9FWsmsC/xMdvibf1k4MzJT8MqYAEJeRgkihyrvxqC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=lH6EKKLvj1p9eDas0khqXUty/2ySWR/KjEq1dDp66wHCzWzom3p81nyWTOvXUGQQ8EPrNfA0nXvDRKGKv9jf4efBucjgwSccKovDcZFc3Fwhp8D1BCr3nWrZscgHD12lgK8/2Rk7jvRqf21pHDF7MEzRuuNnbpmJWAhSh+El5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aiWcGvUT; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240731090201epoutp0323db156376bbf9eb99faf78017f43d08~nQLNkyffb0032800328epoutp03Z
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 09:02:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240731090201epoutp0323db156376bbf9eb99faf78017f43d08~nQLNkyffb0032800328epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722416521;
	bh=yKNx43d1GoRQRk+DZ+nlOibMo9NxVZiybwPOI03/iQk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=aiWcGvUTeBuEyeXHr1X6z1rxdkALBXNiq9McPK9bJ35ts74yyirBU3k0Cw2/FM15/
	 DWFKw/uaU62v9rAPvQXcIePQySIL2Hj0uBOhiI/u6dfClvvzls8igejwBBlYGTa2yU
	 YPAKUqJCNW8N613Ffb6lbAzgJhY6C7GQfSTbnUVw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240731090201epcas5p358dcf8f4dc563a6728587d330ef2cd55~nQLM_yNr93108831088epcas5p3B;
	Wed, 31 Jul 2024 09:02:01 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WYmLZ7395z4x9Q7; Wed, 31 Jul
	2024 09:01:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.58.08855.58DF9A66; Wed, 31 Jul 2024 18:01:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240731090139epcas5p32e2fdac7e795a139ff9565d151dd2160~nQK5POHIx1718517185epcas5p3L;
	Wed, 31 Jul 2024 09:01:39 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240731090139epsmtrp2b38513d81f08f74c675d8581c9bdb05f~nQK5OMKHk2144521445epsmtrp2o;
	Wed, 31 Jul 2024 09:01:39 +0000 (GMT)
X-AuditID: b6c32a44-99ecda8000002297-40-66a9fd85881a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.77.19367.37DF9A66; Wed, 31 Jul 2024 18:01:39 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240731090138epsmtip1c74159391b63ec114601d2f94fafa0b0~nQK3ovKw52645726457epsmtip1k;
	Wed, 31 Jul 2024 09:01:38 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v8 0/2] io_uring/rsrc: coalescing multi-hugepage registered
 buffers
Date: Wed, 31 Jul 2024 17:01:31 +0800
Message-Id: <20240731090133.4106-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmum7r35VpBuuv81k0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2RkH33WyFRwWr+hovczWwPhZsIuRk0NCwERi3ex+pi5GLg4hgd2M
	EquOT2aBcD4xSqydOY0Nzmm6vIQdpuX7q0eMEImdjBKNT58yQzhNTBJbGqewglSxCehI/F7x
	iwXEFhHQlnj9eCqYzSywi1Fi4TkpEFtYIFRi+5LZTCA2i4CqxOYPy8FqeAWsJZ637IPaJi+x
	/+BZZoi4oMTJmU+g5shLNG+dDbZYQuAWu8SeOd+AFnMAOS4Sl29kQvQKS7w6vgVqjpTE53d7
	2SBKiiWWrZODaG1hlHj/bg4jRI21xL8re1hAapgFNCXW79KHCMtKTD21jgliLZ9E7+8nTBBx
	Xokd82BsVYkLB7dBrZKWWDthKzOE7SFx5c5tMFtIIFai6/th1gmM8rOQfDMLyTezEDYvYGRe
	xSiZWlCcm56abFpgmJdaDo/Y5PzcTYzgpKnlsoPxxvx/eocYmTgYDzFKcDArifAKnVyZJsSb
	klhZlVqUH19UmpNafIjRFBjEE5mlRJPzgWk7ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTE
	ktTs1NSC1CKYPiYOTqkGJuHpjyMfp70Wyjod2cXO7xS0gsfud8qDmYdOlhqd5GGSW9S+eu2P
	FTe2qpZx22podwffnrU3pizOZ8LlxTfOOHytWKAVeDPPL3TRo23qyw+YrDnyOuvZjZtNPfur
	zFeaxPacm/mCN+yrQM7muNl34grZbVs7cs01/D49X+rpcCr+hc6tovu7WfTuZJtGpL323cqT
	rp586I/ISsmAdROWdly2iRN4zNXyNl59aXDgtQpPXpbTX/O7cxfrNsoyiHps0JgpXPgmN8DL
	9hDbI9u6G4neV7UW9t/em/T6bOWb9UJGd+vLw1YuF5SIUNfOFsjdV9UfcMq3PWv543X/dcU0
	p6jlXMlLu9ypt2it0NW5SizFGYmGWsxFxYkAuZyzPSMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnG7x35VpBhvn6lg0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujIPvOtkKDotXdLReZmtg/CzYxcjJISFg
	IvH91SPGLkYuDiGB7YwSq/u+MUMkpCU6DrWyQ9jCEiv/PWeHKGpgknh0+ikTSIJNQEfi94pf
	LF2MHBwiAroSjXcVQGqYBQ4xSjRvaGYEqREWCJbY/6uDDcRmEVCV2PxhOQuIzStgLfG8ZR/U
	AnmJ/QfPMkPEBSVOznwCVsMMFG/eOpt5AiPfLCSpWUhSCxiZVjGKphYU56bnJhcY6hUn5haX
	5qXrJefnbmIEB65W0A7GZev/6h1iZOJgBDqMg1lJhFfo5Mo0Id6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6pBqb8sg62UN/UEB97xuX9RQmqi9TTvm6L4nU9
	djRwaUvs1Khr12vqvn47UuHgfXPdxBdcuZsXvdxgYfgoJ7yIL+n1fdc7D+s+rO81LDhQcsXB
	LJH5y1Unm2b1Xne2/Tt99hcU2v51ncS+SF2ooi0q+bf9plVP7jyp69H/x8HTuvyecUfOb43k
	VVYL1vhe2r40d9ffCTuXyf/tOxER2+9YPPvI/1M/Ixcbvd2/3q/jWHq8xf7u2j2XQrf2bWgN
	uXLa9rPd5gM7w4ztk9tSv3Z5SvVZvoi0ePuBXUrFvqZpvYxa6ecZKzg9Cm1mq8soXenQ0q3/
	wyyeU9s290f/X43Nm79yO7q9m7nsyRmJtuY6eSWW4oxEQy3mouJEAHRveFnLAgAA
X-CMS-MailID: 20240731090139epcas5p32e2fdac7e795a139ff9565d151dd2160
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240731090139epcas5p32e2fdac7e795a139ff9565d151dd2160
References: <CGME20240731090139epcas5p32e2fdac7e795a139ff9565d151dd2160@epcas5p3.samsung.com>

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
Changes since v7:
 - Rebase to io_uring-6.11

v7 : https://lore.kernel.org/io-uring/54ef8248-29ac-4c0e-b224-8515b4c604cc@gmail.com/T/#t

Changes since v6:
 - Remove the restriction on non-border-aligned single hugepage.
 - Code style issue.

v6 : https://lore.kernel.org/io-uring/20240716060807.2707-1-cliang01.li@samsung.com/T/#t

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


base-commit: c3fca4fb83f7c84cd1e1aa9fe3a0e220ce8f30fb
-- 
2.34.1



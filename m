Return-Path: <io-uring+bounces-1900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A09168C4D5C
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 09:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B2FEB20484
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 07:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E1914A8F;
	Tue, 14 May 2024 07:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uORn+RaH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D99C15E81
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673333; cv=none; b=P1Ge9/g8dJnfOzR2rfy3BuqNYDYp+zmMe0ZuPpOAJFJ9kbgcbvlCu/jAsJUjlmc/GzQ9jOuqo9iWcHocoxkhG/Z8G9QZoLsnmjvQnUshU79CAYoPPXH797dqXPvc/LjnTDf7UgamH5fH84QoSfhEevJxlI0tD/hroX9vFP3iHD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673333; c=relaxed/simple;
	bh=v98Mo+MpYBU0qzaAkf44WS1u6iYjnUbvkJq6cTR5f6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Tfv/YQd7NIdHXXMxtr+R4GRiyxAx4LM2AQPBQhrMkEoBmMi8/E74Xpl5lkrPCRDM0+kphZ0/Q2S+caPwZSrLFZkrFCe/RdjVMulGhbntTaNx3Adeuu1OhnsFg9nBmOoaWb7eGqiS7itk4bRgPQ16SbUKlLCfVc09D612PBwdzZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uORn+RaH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240514075528epoutp021b5d9cbc36297b007e630ac7d08d997a~PS81ojYMc0977909779epoutp02C
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 07:55:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240514075528epoutp021b5d9cbc36297b007e630ac7d08d997a~PS81ojYMc0977909779epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715673328;
	bh=9J3qY+gr/EQFxqtdizhx5LUqyyO9iMd1OdFM5PunXLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uORn+RaHFc7szSgjY9e//btRQiqCYpDrAoRZYtIK31AvMlD2UeFhJM/217YcynmNN
	 ILqqZZWAphsHdyTtcpbKX7IMwQaI8+LbAARh5O2KliGFRnBZfo7MgOWwNpvu/JPpyw
	 85U4ZHjtcTGQJFAki90xRx0YWMhPNBTPmpc1hq1s=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240514075528epcas5p37f4625815093feb52c2e374775a2e29d~PS81UL8Hl1697316973epcas5p37;
	Tue, 14 May 2024 07:55:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VdpYm2rDvz4x9Q3; Tue, 14 May
	2024 07:55:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	25.60.09688.CE813466; Tue, 14 May 2024 16:55:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075459epcas5p2275b4c26f16bcfcea200e97fc75c2a14~PS8aLx8PN2941229412epcas5p2T;
	Tue, 14 May 2024 07:54:59 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240514075459epsmtrp11afbd5a5a33b6e0e9aef108e7fbb025e~PS8aLFGfD0539705397epsmtrp1D;
	Tue, 14 May 2024 07:54:59 +0000 (GMT)
X-AuditID: b6c32a4a-837fa700000025d8-d6-664318ecba3d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CA.21.19234.3D813466; Tue, 14 May 2024 16:54:59 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240514075458epsmtip239b56869a032fb1900d326b2babb20ab~PS8ZHSVVf0426704267epsmtip2F;
	Tue, 14 May 2024 07:54:57 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com,
	Chenliang Li <cliang01.li@samsung.com>
Subject: [PATCH v4 2/4] io_uring/rsrc: store folio shift and mask into imu
Date: Tue, 14 May 2024 15:54:42 +0800
Message-Id: <20240514075444.590910-3-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514075444.590910-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmuu4bCec0g7c/RSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxT61cwFzzjqei/1sjYwDibq4uRk0NCwERi69b/TF2MXBxCArsZ
	JZ71n2eDcD4xShyfOo8Vzjl16xczTMv65nZ2iMRORonuGbuZQBJCAr8YJbbMMACx2QR0JH6v
	+MUCYosIaEu8fjwVzGYW2MUosfCcFIgtLOAlce/sYlYQm0VAVeL7rNtgC3gFbCVO3r3DCLFM
	XmL/wbNAcQ4OTgE7iVMzXCBKBCVOznwCNVJeonnrbGaQeyQEvrJLnL42kwmi10Xi+Z8+Fghb
	WOLV8S3sELaUxMv+NnaQmRICxRLL1slB9LYwSrx/Nwdqr7XEvyt7WEBqmAU0Jdbv0ocIy0pM
	PbWOCWIvn0Tv7ydQq3gldsyDsVUlLhzcBrVKWmLthK3QcPOQaO64wQIJt4mMEksXXGabwKgw
	C8k/s5D8Mwth9QJG5lWMkqkFxbnpqcWmBUZ5qeXwSE7Oz93ECE6mWl47GB8++KB3iJGJg/EQ
	owQHs5IIr0OhfZoQb0piZVVqUX58UWlOavEhRlNgeE9klhJNzgem87ySeEMTSwMTMzMzE0tj
	M0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGpjCJuQxqIkbs8w9pWPZFef6s2t/3VFGBd59
	EdHvlhye75vCkaCw5EW9u3lXVb9rQt32186yf3kkz+3/8VHjeteJe3WHwnTPNTw08Lia/Oaq
	4lWWVNETZ9R5pk1XUDN0yiia8vq6hYfU/53OqvfP/T26cPIeDT6xORMmdlyycFgb4Gf191tz
	U/66PZN/y7XdCff8MamlM7qh1j1DvfieHG/q6fNCMbuXR+5vtL/HKTj5TtKujenvDPba8Kzm
	rFJ03pfEveeIm/eF4Gpdk6WVPPMLdrxe95HTVGzS4gOlpy+2c3y4JJW+PPP9Jfvpmx8lZ5yS
	OMejdTe6vTr1mexmXd7zItwXZN/cqnP1VZrXK6DEUpyRaKjFXFScCAD4XtX1LwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvO5lCec0g+vHmS2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqn1K5gLnvFU9F9rZGxgnM3VxcjJISFg
	IrG+uZ29i5GLQ0hgO6PE86UtjBAJaYmOQ63sELawxMp/z6GKfjBKnOmexwySYBPQkfi94hdL
	FyMHh4iArkTjXQWQGmaBQ4wSzRuawQYJC3hJ3Du7mBXEZhFQlfg+6zZYL6+ArcTJu3eglslL
	7D94lhlkDqeAncSpGS4gYSGgks1/jrNDlAtKnJz5hAXEZgYqb946m3kCo8AsJKlZSFILGJlW
	MYqmFhTnpucmFxjqFSfmFpfmpesl5+duYgSHuVbQDsZl6//qHWJk4mAEupeDWUmE16HQPk2I
	NyWxsiq1KD++qDQntfgQozQHi5I4r3JOZ4qQQHpiSWp2ampBahFMlomDU6qBqUnqka37yS3i
	P41XlAg3dr4xuPGntu3L/Kk+ky5K7Z72RMrwp+2S1ed4HV0+iEZy9vBWNjvXaG19dLh/iZHp
	2YkXuXS9Vk+646jcn3E8bPUFnanztwdkulvUNzx+8tFOoD5grVwJ2xLp6edKtmtyR616+WrO
	ncMHO94yb3z3umfhvpmFFXs8fIs+LzzNe/5f+tTjdVUNTYtPWU3PWCe4M70gKeig7I7A8g06
	0zOOhC4WbPqy08tZV31q/5bHloH+GY9WcRTeXCMdeOODzuJq+WvyZx2XMjaY3PijcFxC/YWi
	h6e7alqLi8b7tqrvZyb+KdN6b5y5UNhoVtq/TaEy7WY7nm7efMn0GvtNeQPDDCWW4oxEQy3m
	ouJEAFGVSRjiAgAA
X-CMS-MailID: 20240514075459epcas5p2275b4c26f16bcfcea200e97fc75c2a14
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514075459epcas5p2275b4c26f16bcfcea200e97fc75c2a14
References: <20240514075444.590910-1-cliang01.li@samsung.com>
	<CGME20240514075459epcas5p2275b4c26f16bcfcea200e97fc75c2a14@epcas5p2.samsung.com>

Store the folio shift and folio mask into imu struct and use it in
iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
multi-hugepage buffer get coalesced.

Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 io_uring/rsrc.c | 6 ++++--
 io_uring/rsrc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d08224c0c5b0..578d382ca9bc 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1015,6 +1015,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->folio_shift = PAGE_SHIFT;
+	imu->folio_mask = PAGE_MASK;
 	*pimu = imu;
 	ret = 0;
 
@@ -1153,12 +1155,12 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 			/* skip first vec */
 			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
+			seg_skip = 1 + (offset >> imu->folio_shift);
 
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
 			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
+			iter->iov_offset = offset & ~imu->folio_mask;
 		}
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index b2a9d66b76dd..93da02e652bc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -46,7 +46,9 @@ struct io_mapped_ubuf {
 	u64		ubuf;
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
+	unsigned int	folio_shift;
 	unsigned long	acct_pages;
+	unsigned long	folio_mask;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
-- 
2.34.1



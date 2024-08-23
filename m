Return-Path: <io-uring+bounces-2905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C4D95CAC7
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB2A21C230C9
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E806B187336;
	Fri, 23 Aug 2024 10:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TxRIAD/l"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4B7187345
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410093; cv=none; b=ffUNhSLZkAaPHNelKu+USP+7MJQPp1A3eJYd/vn5boysilWTv74XLDKF9SibMxxzViM4w9adA3b1HBfgyuRBHT/PCdM3HSQOnUoyG9LP7UkL5T0Q/SQMgRb79/Tuwbh6YVRmxBrM+yKsiuC4jReqoUqIK2oNooEe5B55AOmzto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410093; c=relaxed/simple;
	bh=d7rXebeSEm18bCB7MKc526gnn9BA+iKBq0twd4J7e+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=TP8KmFw0HusfhAKsrzidovJtbyd3zBQrvEOTdwyJVCvXQof4FDQCE4mUxpDKVOa7etkCY2HOmBcZ///EgFovGdEV6+hTdxyGS230nI0pd4GZJPAmkDNF9cl+/325248e6Z/pcB25wGWx7bUDi9DurjnKs/EVtxfAobCjaJR1XC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TxRIAD/l; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240823104809epoutp04169ae235cc62f325cb3f0bcc9fab86eb~uVdcqNG7b1876118761epoutp04F
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240823104809epoutp04169ae235cc62f325cb3f0bcc9fab86eb~uVdcqNG7b1876118761epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410089;
	bh=jMx8UpUspdytnu+Xq0U/x/8sHusVPIVYMik9VsbX5dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxRIAD/l5b0q3HPoQ7KkF0/uffuQBLB8U/l7r0MenTiTr2snbit/wVL/gMcMAzTWc
	 LmlMq52YSbelFEa5g0yBDwa2zb3QnqHLyyfNHF7FzS62K9CtKS8PJxnruU+IwoCEar
	 RtlZYqrNHx+1NOpnKEnHBbGhGd+/B8sYX+P3i+vM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240823104806epcas5p365b10ec701f48979e49694b199d5fb7e~uVdZhIeMo0529105291epcas5p3Y;
	Fri, 23 Aug 2024 10:48:06 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WqxcN5H75z4x9Q1; Fri, 23 Aug
	2024 10:48:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3F.7A.19863.4E868C66; Fri, 23 Aug 2024 19:48:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1~uVbyr-QcC3268132681epcas5p4l;
	Fri, 23 Aug 2024 10:46:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240823104616epsmtrp19e122e7c3e3f792d82b6528df3ed01d6~uVbyrIHkr0200002000epsmtrp1i;
	Fri, 23 Aug 2024 10:46:16 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-de-66c868e41339
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7C.1B.08964.87868C66; Fri, 23 Aug 2024 19:46:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104614epsmtip227daa07025f3459d97df93b29cdc2537~uVbw0JSpS1442714427epsmtip2Y;
	Fri, 23 Aug 2024 10:46:14 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Fri, 23 Aug 2024 16:08:01 +0530
Message-Id: <20240823103811.2421-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmuu6TjBNpBs3b1C2aJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGZVtk5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0r5JCWWJOKVAoILG4
	WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2PT6ZVMBTu5
	KlZv2MXcwPiUo4uRk0NCwERi3tQTjCC2kMAeRomPC+q7GLmA7E+MEruWrGSFcL4xSqxb3s8M
	07Gr4ycjRGIvo8SxxUvYIdo/M0r8nAxWxCagLnHkeSvYWBGBSonnu36wgDQwC2xilPh1/RgT
	SEJYIE5i25EONhCbRUBV4tjcSWA2r4CFRNuO70wQ2+QlZl76DraAU8BSoml2AwtEjaDEyZlP
	wGxmoJrmrbOhrlvKIfG3LR/CdpF4dWYWO4QtLPHq+BYoW0riZX8blJ0u8ePyU6hdBRLNx/Yx
	Qtj2Eq2nQD7mAJqvKbF+lz5EWFZi6ql1TBBr+SR6fz+BauWV2DEPxlaSaF85B8qWkNh7rgHK
	9pB4cPYkNOB6GCX2zfvHOoFRYRaSd2YheWcWwuoFjMyrGKVSC4pz01OTTQsMdfNSy+GxnJyf
	u4kRnIa1AnYwrt7wV+8QIxMH4yFGCQ5mJRHepHtH04R4UxIrq1KL8uOLSnNSiw8xmgIDfCKz
	lGhyPjAT5JXEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwJSbMnPq
	g/uJM2WWf7Z/Xc2w6v3RsGsVXCXtlYJvOcv3S/I/XTn9iM/M4LjchUwnnOSWfNnKut59VrOl
	W5CZhl5y+vSXe6LXK0Tu8WJ4FhTmdmqh3C6VUxbcUld/diVHlL54v+Ga85WlV9viSgWSXM3Z
	td+sD7b6Fdr2o/nJzRTxiz4vs1bZqsdar7N9uLGwsrLab9aj1+aqGnkLXp3QqmDYJZm1otPk
	OHts5PnsvxdShLZmSGyLKXyrv6vsSIzR0tbNtU8C7uzu/dCpFnxz7tPjDs5Xis//m2Qsv+fI
	ZqWljHuP2XssbeTK231u+lfzir1HfNpXrnrPtknSNb8h6+TqhW9a56xqYpM8+fHtkVYlluKM
	REMt5qLiRADhX7GfTAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSvG5Fxok0g+fvWSyaJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mW
	WqRvl8CVsen0SqaCnVwVqzfsYm5gfMrRxcjJISFgIrGr4ydjFyMXh5DAbkaJHzNvskIkJCRO
	vVzGCGELS6z895wdougjo0TD8ulgRWwC6hJHnreCdYsINDJKbGn+wgLiMAvsYJRY92wxWLuw
	QIzE6r/rmEBsFgFViWNzJ7GB2LwCFhJtO74zQayQl5h56Ts7iM0pYCnRNLuBBcQWAqpZtvwM
	I0S9oMTJmU/A4sxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0
	veT83E2M4GjR0tzBuH3VB71DjEwcjIcYJTiYlUR4k+4dTRPiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOK/6iN0VIID2xJDU7NbUgtQgmy8TBKdXA1F5efsrGbrpTwYGC26/0aw2OuP29nzelvtPo
	cOHtAx1HBfpyi2fZ+WVwLPl+8s7e6a8DT3v+b7mx4Hzk/OhtknzJciu+PC3WuuZqtn7nklV+
	Xd+9KhR1e+VnT/jxlkF+8y+NvIUqyfp7l3Klc65JDRAzvjb/8rK7OdNX6Bi67zBUt5JT7a10
	8K1e3G1yj3HxiezU3ZOqvJjaLOUqWiR+/dvI/mAzU/qRhOmTXhq71X364K+WtiM9amVNQPKN
	dYJbHpmuMGfa/me9TczzoxdP6Gz5+V486cDXiwcPmfFMT+2VUZd+LvU9M+K4/numZQ9KH3/9
	edDOL5XB8iK/XNZm7a50uTNHnwd/S7+y5pj8EyWW4oxEQy3mouJEALYkjOYFAwAA
X-CMS-MailID: 20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1@epcas5p4.samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8d1fb38f745f..0b69f2b003c3 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -567,7 +567,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dd831c269e99..485d8a43017a 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,9 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 #define bip_for_each_vec(bvl, bip, iter)				\
-- 
2.25.1



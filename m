Return-Path: <io-uring+bounces-2906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D8C95CACB
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 12:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49D981C232ED
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 10:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4D5187347;
	Fri, 23 Aug 2024 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Bfbd4dcq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA76187339
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724410098; cv=none; b=GIAsTLGmZdZoqz+EC1gITbS9lTrQmUoFB/c1CWu89UqyVssxl3JhFC0ilmvf1w6BILQ1JNGPwkpAR+Nhs4RXv+ngPP3SZ1X6vCulmI4NE9IP2nFWF3DZH3AqW+gNy6BEwlFmL2JS9I/q0btaxPO8tp7Y6UZG8Wa59BTTeNwLZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724410098; c=relaxed/simple;
	bh=8xrCboqKX1/hsaIOvnjsh52EnC8Lbd1VxbhU5M3E8Tc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KpkB7nLsvaEaSPRWX7jxS3DQMRxb2BMAHuDt810Nk0IG6OxhWDIbRWYEiVvTmIRux3cY+WOkmoddujBm4qFAICiFwKxJta8XNs4yVycYY4AmKl26vlxKcRvocNITZP9lyjWNZ4em69bh6rAsp9st61LWHhLFjhVTlvfsG0UaIxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Bfbd4dcq; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240823104813epoutp04a5198a5b52c4e139982afef48903e4d8~uVdgWvkPP1659716597epoutp04W
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 10:48:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240823104813epoutp04a5198a5b52c4e139982afef48903e4d8~uVdgWvkPP1659716597epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724410093;
	bh=8jA6l5tMs++plw+N26Lk0rdh9tUDLvjEvpwEPgRSsMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bfbd4dcquQvzRBXt3rFZ1lPrq6fWhWV/tyaUVPFGI0iZsO6QkHYs9EX9tV+e9YxUc
	 ERGwPe2g3ZDgR3BA2f3OaNcyzwACiB5VflafQGfbTHgqu/lBU7WBW7qm5C2mh7Mbfl
	 PN/6o+8j1850HQaV2/qecUBPdrt23zrSmsiX89YU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240823104813epcas5p31e498e0c26224c6efcfc9b2222bc5a6b~uVdfzMXFK1288512885epcas5p3C;
	Fri, 23 Aug 2024 10:48:13 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WqxcW44ZWz4x9Pw; Fri, 23 Aug
	2024 10:48:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	60.F3.09640.BE868C66; Fri, 23 Aug 2024 19:48:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2~uVb0vhpeM1988919889epcas5p46;
	Fri, 23 Aug 2024 10:46:18 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240823104618epsmtrp2daca9994ff06c5d5736525680aef473b~uVb0uxG2Z0122301223epsmtrp2A;
	Fri, 23 Aug 2024 10:46:18 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-34-66c868eb61d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	21.6F.07567.A7868C66; Fri, 23 Aug 2024 19:46:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240823104616epsmtip206aa9085094eaa85cbf4914c5ff3b2b4~uVby08i-N1244412444epsmtip2j;
	Fri, 23 Aug 2024 10:46:16 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 02/10] block: introduce a helper to determine metadata
 bytes from data iter
Date: Fri, 23 Aug 2024 16:08:02 +0530
Message-Id: <20240823103811.2421-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240823103811.2421-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmuu7rjBNpBk/+yVo0TfjLbDFn1TZG
	i9V3+9ksbh7YyWSxcvVRJot3redYLCYdusZosf3MUmaLvbe0LeYve8pu0X19B5vF8uP/mBx4
	PHbOusvucflsqcemVZ1sHpuX1HvsvtnA5vHx6S0Wj74tqxg9Np+u9vi8SS6AMyrbJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkbnli6Wggdc
	Ff1vLjI1MH7l6GLk5JAQMJF4vmwbcxcjF4eQwG5GiV9XFkI5nxgl+nZ0s0I43xglfk7YxATT
	8u7/DVYQW0hgL6PEm5UuEEWfGSXanjWDJdgE1CWOPG9lBLFFBColnu/6wQJSxCywCWjH9WNg
	k4QFEiQ2zgZZzsnBIqAqcXr6bTCbV8BC4sChl1Db5CVmXvrODmJzClhKNM1uYIGoEZQ4OfMJ
	mM0MVNO8dTbY3RICSzkkultnMkM0u0jcfvGFBcIWlnh1fAs7hC0l8fndXjYIO13ix+WnUMsK
	JJqP7WOEsO0lWk/1A83hAFqgKbF+lz5EWFZi6ql1TBB7+SR6fz+BauWV2DEPxlaSaF85B8qW
	kNh7roEJZIyEgIfEtjOqkMDqYZRYv/U/2wRGhVlI3pmF5J1ZCJsXMDKvYpRMLSjOTU8tNi0w
	zEsth8dycn7uJkZwGtby3MF498EHvUOMTByMhxglOJiVRHiT7h1NE+JNSaysSi3Kjy8qzUkt
	PsRoCgzvicxSosn5wEyQVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMH
	p1QD0/zZMUzT3s9tkg3QK3qzdN7d1M0Xij7/6jPJuBj1/ceM98dVkpbuFU0Jul+nOe1t87Ej
	j9wEraM2XbQOvzdJ+vOH87uPbpSIClfWvehV+6MwlfurACvL2vOtr71X32xtqNV22bT23Vm5
	ipjFrxbfemvGbuySpOL2dNKWQolVz/5P5D/xOcpxm2F7p1yM8qOXG16q72aa1bvzf9CSwozu
	5HVMVXN/xWUUv63csGOOHsfZCYbHdiacK+XM/yp6e50j58zory/Y/b/UbpwfrHpYdeG3Zv7Q
	DzLb1i6f73J+1g5DfQ2+6jJu+/qYmx2rraKvGSo1vGy/dugJ6707Yod1tzeXW57gM5X/L7rd
	t0nc964SS3FGoqEWc1FxIgC0ceB3TAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvG5Vxok0g/YVvBZNE/4yW8xZtY3R
	YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFabD+zlNli7y1ti/nLnrJbdF/fwWax/Pg/Jgce
	j52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8eovFo2/LKkaPzaerPT5vkgvgjOKySUnNySxL
	LdK3S+DK6NzSxVLwgKui/81FpgbGrxxdjJwcEgImEu/+32AFsYUEdjNKfG4Ph4hLSJx6uYwR
	whaWWPnvOXsXIxdQzUdGiT0HV4E1sAmoSxx53soIkhARaGSU2NL8hQXEYRbYwSix7tlisHZh
	gTiJ0x+ugdksAqoSp6ffZgaxeQUsJA4ceskEsUJeYual7+wgNqeApUTT7AYWiJMsJJYtP8MI
	US8ocXLmE7A4M1B989bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PTfZsMAwL7Vcrzgxt7g0L10v
	OT93EyM4VrQ0djDem/9P7xAjEwfjIUYJDmYlEd6ke0fThHhTEiurUovy44tKc1KLDzFKc7Ao
	ifMazpidIiSQnliSmp2aWpBaBJNl4uCUamDyvqe2TWbqH8lFys5qb7Om6wd7KDWoBzoxW3tc
	Tzr73HfRw+nBe8I87mqpfHJLFdGbtXlNOLPqkqan995PX7Lj87+8R843O530tvgee+YmX7d/
	qVbrrtuWb7MzZP7skXgbsfxpvrdLzYRUTzeld12lB55u3eGTKWDsMvfHlp/ywW8/u2Zf5fE5
	OvFJoY+G5ZxTh8TrnALs3DMfX5m4QDlhm27aU/bbWR0R7I/tklqa2xY+fs/Bv2DC1V/zhP7v
	NF5iVtefGPVGdrGR/NYLp12mLrj28tDjpawn5S/e2Fa8Zl0Fv2BM1YZ98fJzQzatSLCa7LJw
	stHeGOuUu66pmqYL/UpDrktfqLAVStyXHXVHiaU4I9FQi7moOBEARZhMZAQDAAA=
X-CMS-MailID: 20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104618epcas5p4b9983678886dceed75edd9cbec9341b2@epcas5p4.samsung.com>

Introduce a new helper bio_iter_integrity_bytes to determine the number
of metadata bytes corresponding to data iter.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/blk-integrity.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index de98049b7ded..2ff65c933c50 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -76,6 +76,15 @@ static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 	return bio_integrity_intervals(bi, sectors) * bi->tuple_size;
 }
 
+/*
+ * Return the integrity bytes corresponding to data iter
+ */
+static inline unsigned int bio_iter_integrity_bytes(struct blk_integrity *bi,
+						    struct bvec_iter iter)
+{
+	return bio_integrity_bytes(bi, bvec_iter_sectors(iter));
+}
+
 static inline bool blk_integrity_rq(struct request *rq)
 {
 	return rq->cmd_flags & REQ_INTEGRITY;
@@ -132,6 +141,13 @@ static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 {
 	return 0;
 }
+
+static inline unsigned int bio_iter_integrity_bytes(struct blk_integrity *bi,
+						    struct bvec_iter iter)
+{
+	return 0;
+}
+
 static inline int blk_integrity_rq(struct request *rq)
 {
 	return 0;
-- 
2.25.1



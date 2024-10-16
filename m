Return-Path: <io-uring+bounces-3724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A37C9A09E4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C019228613F
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACDB208962;
	Wed, 16 Oct 2024 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qTxxlxP2"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F74E1DFF5
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082177; cv=none; b=MrjCtBxfZnVjvFKuwQDKTCoH32fwQV5qQH0TMTWXtZAERil+TlMzhV8woPZYAzhfiCeJzXAWOM0LIvcfFXot8CL0uELH3ar8KNBtolg3s3ReVvN7o/Qh4bawe8z0sn9wMhdTet3Wc1Q7+fymctCFGINLlzwH97XZe8IzOTOXGeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082177; c=relaxed/simple;
	bh=80iN9wH8fZxRyeNmWrkbWUyfZDLjnh4UxZJ8TgsMhwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EJLIuMP24Aqw7B2e4TXIJo9eOCxo6tTUx0tp2aYc0krfNZ/QwRT3UVpFMJh3lG/48Gqetu2O/hAEzCqMHWS+3miW50aZnWdC+/H5cH11fCb6tUnk3b5oP7hiRg/9fBJFeHvkdUIjbgsRTJhWBohqmH54i7nAEI6350+ncLPj2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qTxxlxP2; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241016123613epoutp04408584951879b76d9029ec4ab78a309f~_7xN4DcAJ1871218712epoutp04B
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241016123613epoutp04408584951879b76d9029ec4ab78a309f~_7xN4DcAJ1871218712epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082173;
	bh=j7kMMqrhvwE2U0rxzDSx84hS80YAqcLX62yw/e5POuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTxxlxP2uiHNWdOkVRzGlZtNl38clk5mvooKlLnQkWC/5wbfrM2AqcD0wvincuxeF
	 1csi7r0ovhI3r8H8YEpEs/AQza847ZdUrmHwAIEgJEno5GqOAFK9AgkwIIzkSc+VF0
	 d7r2B2LZluGqF+IvG0iktE7harLsRvv5No1QQvOA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241016123613epcas5p4fefeb190c8f152295a5cdf8c574aa8d7~_7xNa1bVV1646816468epcas5p4f;
	Wed, 16 Oct 2024 12:36:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XT9SC1Myxz4x9Px; Wed, 16 Oct
	2024 12:36:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E3.01.09770.B33BF076; Wed, 16 Oct 2024 21:36:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357~_6_CEFDD92628326283epcas5p3B;
	Wed, 16 Oct 2024 11:37:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113736epsmtrp23f19cc615b949554c87694a6229b48af~_6_CDSKot1555115551epsmtrp2e;
	Wed, 16 Oct 2024 11:37:36 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-c4-670fb33b0423
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.BA.08229.085AF076; Wed, 16 Oct 2024 20:37:36 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113734epsmtip176042ea87fdd663dbe664cf7e714eea5~_6_AIsgrp2871328713epsmtip12;
	Wed, 16 Oct 2024 11:37:34 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 02/11] block: copy back bounce buffer to user-space
 correctly in case of split
Date: Wed, 16 Oct 2024 16:59:03 +0530
Message-Id: <20241016112912.63542-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmuq71Zv50g6Xf2C0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOmLnyHFPBZbaKm8tDGxhPsHYxcnJICJhITNwzl6WLkYtDSGA3o8TLNb/ZQBJCAp8YJR6u
	8YdIfGOUmDX9InMXIwdYx7rdaRA1exklLp/Oh6j5zCjxYvJ3JpAEm4C6xJHnrYwgtojAJEaJ
	55dDQWxmgVOMEmt/KYDYwgLJEr3bH4PVswioSvRtPgFWzytgKdFyYT8bxHXyEjMvfWcHsTkF
	rCROnTvIDlEjKHFy5hMWiJnyEs1bZzODHCEhsIVD4vuu3+wQzS4SW9rmQw0Slnh1fAtUXEri
	87u9UPF0iR+XnzJB2AUSzcf2MULY9hKtp/rBHmYW0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXy
	SuyYB2MrSbSvnANlS0jsPdcAZXtINLR3MUECq5dRord9OesERoVZSP6ZheSfWQirFzAyr2KU
	TC0ozk1PLTYtMMpLLYdHcXJ+7iZGcFLW8trB+PDBB71DjEwcjIcYJTiYlUR4J3XxpgvxpiRW
	VqUW5ccXleakFh9iNAUG+ERmKdHkfGBeyCuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1
	OzW1ILUIpo+Jg1OqgSl1zsS3OcWpVm+EfY0nvD+sr9Ad6fKuwEZARmbGDJnUmQ+mPRF+pXG7
	wKdA131PDZ/1bL2PDuGTbqszibfYbhbr5r16Uj5h4zTdNTl9V0IbFCrbXqsHmDrEm3+4vfmn
	x8s/UU0ZM8s3q6+WZvff028ldOFw153FJyoP9J7uEo+q2Kv5+OJuTZd//xr3yvPP45HZ//bq
	zyMmaaIc+xJfX7urN+lD79IMq/vlFbkeeSm/cyfMuHU5+dUHXXueWt/L/zeFVnPbxfzLSJ2T
	+D6BPSLom05m9YvDuTMffXu5aHKfd+mfsC4l/6tHkuy8RB7u3ZH4RduyM9/xnzBf/ubsfbJ+
	5h0SM82uT5Zj+//xlRJLcUaioRZzUXEiAHslh1VTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSnG7DUv50gzUd4hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYTDp0jdFi+5mlzBZ7b2lbzF/2lN2i+/oONovl
	x/8xWZyfNYfdgc9j56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweH5/eYvHo27KK0WPz6WqPz5vk
	AjijuGxSUnMyy1KL9O0SuDJmrjzHVHCZreLm8tAGxhOsXYwcHBICJhLrdqd1MXJxCAnsZpSY
	1zYRKM4JFJeQOPVyGSOELSyx8t9zdoiij4wSz14cBkuwCahLHHneygiSEBGYxShxeNZ8JhCH
	WeACo8TVfc/YQVYICyRKTL0mCtLAIqAq0bf5BFgzr4ClRMuF/WwQG+QlZl76zg5icwpYSZw6
	dxDMFgKq+Tf5A1S9oMTJmU9YQGxmoPrmrbOZJzACbUVIzUKSWsDItIpRMrWgODc9t9iwwDAv
	tVyvODG3uDQvXS85P3cTIzh2tDR3MG5f9UHvECMTB+MhRgkOZiUR3kldvOlCvCmJlVWpRfnx
	RaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUamBo0Pc3vLkrkZF9S18HPcNCu
	oOdAkeNKiyUZ8vZaUovOzHOtu7jE25+xyTZ98rfU+LMSZxvPtp2sqbf9K/v3fktfyKk9aj0L
	D3dv9ZlXb3d2p7fgsw3r2+3C0rwWe75ef+xkJ/+O1luVbJKq+elndwUp7dXYfrGa6Xd6Xv8h
	nwNP1CeVfbOfGW9QeHXDr/cKnbfObUj3dtyhIVOS93nnYrXiE1kK3477x/M/1dh3bMt1YZ3G
	+n93C4PnZ1dfzj0w7bXRjab90oleuTN0N+18keH+KOvx5kk6+6Mv1EuprZ+isnSVV8XmhNCO
	mFvx61WOd5yw5Zjn/GmHQJzeMrEjR1WTBNmUw+IEChfa5r98p8RSnJFoqMVcVJwIACMVt0YM
	AwAA
X-CMS-MailID: 20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357@epcas5p3.samsung.com>

Copy back the bounce buffer to user-space in entirety when the parent
bio completes.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8c41a380f2bd..8948e635432d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -119,8 +119,8 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 {
 	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
-	struct bio_vec *copy = &bip->bip_vec[1];
-	size_t bytes = bip->bip_iter.bi_size;
+	struct bio_vec *copy = &bip->bip_vec[1], *bvec = &bip->bip_vec[0];
+	size_t bytes = bvec->bv_len;
 	struct iov_iter iter;
 	int ret;
 
-- 
2.25.1



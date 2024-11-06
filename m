Return-Path: <io-uring+bounces-4494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A12879BF03F
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30E761F2488C
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34B72038A8;
	Wed,  6 Nov 2024 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FAzQbwKs"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6CD202625
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903352; cv=none; b=BWhNA21AqBiQS8WLcXzgYoFHrFPARSJPNo/BBXDoBSCZatwsilQHNBDon41OxB8eRRbwBv84qD0WKAH7Hzhyu8p1SIhIhRT1lLQwALwJsmf4l7UVjp+R6VpXTv+PXBNEvaZeM9rUUkBSsh0CtYauGl2OOOnB162RQcjDscIL/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903352; c=relaxed/simple;
	bh=PPDNMGOuEvkJDIU7LllEytV2427zo9AzbP3ebXn9pJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=b1ZhnHCEED7QqTRjBE5HW7FuugsilkbmOhMQKY6DvlIE1FGolW6i3LpW0DxjzDeNrV2PB9DC0u60KTjjmPSFYMVYrof3nZpxfVpH+8/yY9LlfR5qpJWd7951lFqcDu9fkHKuQZ1XFgnNMsrxhZCcXMIgY4d/ysq8hGWZmo66IWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FAzQbwKs; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241106142909epoutp01bcf8bed281979614c0d6d3a65f97d067~FZ2zyM2FO1768117681epoutp01b
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241106142909epoutp01bcf8bed281979614c0d6d3a65f97d067~FZ2zyM2FO1768117681epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903349;
	bh=0Qev84oB/WNNKAORKgHjGWYS6Jca41BG3ZIzsvdmNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAzQbwKsTwvoJdhonO9VuNhMcbkLg2c8cKJVpdNlQ6CoscdrPap/OTJzYL5KiunFC
	 mZxwbMrEcYhjBLYrsHY9WG9ACUJqnQakqfp1wSzWA1F0e1pV9LlvACotab+GoEtB8t
	 NqbHHkFujtnpoqxbQ39h4UVzI6n3q4Kw4OV14Kyw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241106142907epcas5p4cd812cc8e7fc11874341fdc6f71c87ad~FZ2yc_mFs2211422114epcas5p43;
	Wed,  6 Nov 2024 14:29:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xk6yp2rNJz4x9Pp; Wed,  6 Nov
	2024 14:29:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C2.3F.09420.23D7B276; Wed,  6 Nov 2024 23:29:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241106122707epcas5p4569e1ddc2ded4de5da6663fb7ffc9464~FYMQt5zRh2745227452epcas5p4C;
	Wed,  6 Nov 2024 12:27:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241106122707epsmtrp2d7c95e110d83e1218218e7b8efeebd69~FYMQtC4LE2560925609epsmtrp2X;
	Wed,  6 Nov 2024 12:27:07 +0000 (GMT)
X-AuditID: b6c32a49-33dfa700000024cc-44-672b7d3224ca
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	28.01.35203.B906B276; Wed,  6 Nov 2024 21:27:07 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122704epsmtip17756c41bf463aa6063af90bb7e9c5a3f~FYMORbEts0844908449epsmtip1b;
	Wed,  6 Nov 2024 12:27:04 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v8 05/10] fs: introduce IOCB_HAS_METADATA for metadata
Date: Wed,  6 Nov 2024 17:48:37 +0530
Message-Id: <20241106121842.5004-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmlq5RrXa6wYLbIhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsba02sYC66wVqy/1cLYwHiNpYuRg0NCwETi6SPm
	LkYuDiGB3YwSP7o/MkI4nxgl+v93sUI43xglWs4vZe9i5ATr2H1tGlTLXkaJxQ9nskM4nxkl
	Xj1czQZSxSagLnHkeSvYLBGBPYwSvQtPs4A4zAIvGSWWrlrEAlIlLOAmcbN/EhOIzSKgKnFn
	SysziM0rYCHx4s1uVoh98hIzL30H280pYClx9vM2RogaQYmTM5+AzWEGqmneOhvsJgmBMxwS
	F3dcZ4R4z0Vi03xViDnCEq+Ob4H6QUri87u9bBB2usSPy0+ZIOwCieZj+xghbHuJ1lP9zCBj
	mAU0Jdbv0ocIy0pMPbWOCWItn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhJXVs2ChlYP
	o8SR5hVsExgVZiF5ZxaSd2YhrF7AyLyKUTK1oDg3PbXYtMAwL7UcHs3J+bmbGMFpXMtzB+Pd
	Bx/0DjEycTAeYpTgYFYS4fWP0k4X4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnATJJXEm9o
	YmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVANTE6fpuY3XYzx8aoJtK84/
	VaifduqSY1zhGbvNp08Z24ZukCtsTK/6Ov0Tc9CP1eb3Kiz9vv+yFnOdu9nB8mW6Vpzzx2RG
	3YwXndW/BNTawm53MOw/qGEdwOn77etHo7XbKt3SVsTvb/RaEac7e8nv32dii3Jn71xZtt/k
	2LK0PQ/leTzefp+/PtaWnfWb6eemhZzr/xfePJrxsm/Z44S1W3dvX9604uRu5/AV/c9XiKR/
	q5HYIFl5uEE2/Nnx5yHfJ0VIp+rFz683U/Kco3X39fkstoVaiYq3D9+ee+RNgsw+sQO/c4+s
	vOjqcNYo7ve+Lvb2NSetLnuUh+75xFKnfOaEgEnQrG9Pha6q2HLJKbEUZyQaajEXFScCAMEQ
	qb1sBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO7sBO10g9YlIhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoErY+3pNYwFV1gr1t9qYWxg
	vMbSxcjJISFgIrH72jTmLkYuDiGB3YwS5yc/ZIRISEicerkMyhaWWPnvOTtE0UdGiZVn54B1
	swmoSxx53gpWJCJwglFi/kQ3kCJmkKIJX2aDFQkLuEnc7J/EBGKzCKhK3NnSygxi8wpYSLx4
	s5sVYoO8xMxL39lBbE4BS4mzn7eBDRUCqvmzoA+qXlDi5MwnYDOZgeqbt85mnsAoMAtJahaS
	1AJGplWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMGRpqW5g3H7qg96hxiZOBgPMUpw
	MCuJ8PpHaacL8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCeWJKanZpakFoEk2Xi4JRq
	YCr8OanVlt/IluWG8vHrUn9nib493fUz5EzNK7kPDd379rXP//Va6vnSLsHgDLb9vze+m/tR
	Yerfa4pqF27t2GP1yK7r8a/K2HbhI1wp6ik5m5o9nd8tk/t40M+k9VhHmWKzUuCajgz2WxIK
	0tnqb95smaWQ4TMlfN22tr1ZN/s2F9ze8GLOG/snav/jCpozn/rJTk9+pzTXrmpPoCznwSbv
	P+8PXwr2MfD6Oi+8yMVoYmlyqKhReYOQMecD3ZQu1Q1KN2W+vAyxaVHY/GVhJWP+vz++Yjai
	09cq3ziSPF1B7ld34gUF1bp6m1llpezXf9kUJSdzqeSev6Mjk1NpVtBV9b9t+5Pkj5fUDcV3
	KLEUZyQaajEXFScCAEUlpbcjAwAA
X-CMS-MailID: 20241106122707epcas5p4569e1ddc2ded4de5da6663fb7ffc9464
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122707epcas5p4569e1ddc2ded4de5da6663fb7ffc9464
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122707epcas5p4569e1ddc2ded4de5da6663fb7ffc9464@epcas5p4.samsung.com>

Introduce an IOCB_HAS_METADATA flag for the kiocb struct, for handling
requests containing meta payload.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b5cad44a126..7f14675b02df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -346,6 +346,7 @@ struct readahead_control;
 #define IOCB_DIO_CALLER_COMP	(1 << 22)
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 23)
+#define IOCB_HAS_METADATA	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
-- 
2.25.1



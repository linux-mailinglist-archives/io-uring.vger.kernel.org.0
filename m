Return-Path: <io-uring+bounces-1196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7516887378
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 19:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E246B23392
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F54376900;
	Fri, 22 Mar 2024 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Jn0uj8hy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6C762D6
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133859; cv=none; b=uyt3vP50NRw7iUpmbt1UrDzYglTMNDsa7yDHMBYb1/IQ/s6UPRYaBjTTllM3i+fr9/AVZlcn6GLcheInEAZ3CbT5JkkcD45Pn0Pwz3oIA3SW4JwBbjP3uxXhLF6BDJeQJC+vH/qjTPhWaq7nhrcP4D2iEuh/s8gEA44yZ/4R+/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133859; c=relaxed/simple;
	bh=/SP/jJnUyBDiMYaQ9ijXfSzW7CRoMmzrlD+8HEWGV0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hqE2706AxVLCLtsG0QgO46tgcYSVJdkwXXwJTO3dGDP8qAkRrKJMiNlkPeKOm9ygnq9X5F707DxBXL/If5L+Ra/Xt/daqM4szCiXy0WzTb3SOHinAHtl/yLtf6LMOGewV6wvzbQ1/puJh3kh00PRUthj2ZYdPGYWsmMNze3GZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Jn0uj8hy; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240322185734epoutp0181891dfcc081821ae5ffd26ba2e3d6a4~-KyzAL5mH2534625346epoutp01K
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:57:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240322185734epoutp0181891dfcc081821ae5ffd26ba2e3d6a4~-KyzAL5mH2534625346epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711133854;
	bh=tBADbgXJvTUccByZhMHOUzX145TVT1OvGWukt8bDhNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn0uj8hyEcJ7YgupBa5LyEmMcGVtIJVk64DnkhZ1Qlns7eL46H06Exm98NwE1APIf
	 e1/PrOZaOPkZ0iRQeLmYQytOxUt9HYpiSMv/cwcOZJ1dZgtq2jYtQPvC+ifiiaApSX
	 vilSxSXgdbT6a7E3a9KFusS6wO6Kl9hdC3I9rrWo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240322185733epcas5p22970b83ba7f542afe09b77eae1126860~-Kyx1T-nP0149101491epcas5p2c;
	Fri, 22 Mar 2024 18:57:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4V1WmD1H83z4x9Pt; Fri, 22 Mar
	2024 18:57:32 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B0.BD.09665.C94DDF56; Sat, 23 Mar 2024 03:57:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240322185731epcas5p20fc525f793a537310f7b3ae5ba5bc75b~-Kyv5UzQI0149101491epcas5p2b;
	Fri, 22 Mar 2024 18:57:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240322185731epsmtrp21f882f0d89d52513af9c609747365eb5~-Kyv4lu2S0597405974epsmtrp25;
	Fri, 22 Mar 2024 18:57:31 +0000 (GMT)
X-AuditID: b6c32a4b-829fa700000025c1-e9-65fdd49ca9b5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.94.08924.B94DDF56; Sat, 23 Mar 2024 03:57:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240322185729epsmtip1d25fd2efd4ef6454c38b868def3ad50c~-KyudL0KY1491214912epsmtip1a;
	Fri, 22 Mar 2024 18:57:29 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: martin.petersen@oracle.com, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 1/4] io_uring/rw: Get rid of flags field in struct io_rw
Date: Sat, 23 Mar 2024 00:20:20 +0530
Message-Id: <20240322185023.131697-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTXXfOlb+pBu9ns1t8/PqbxaJpwl9m
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0rZYfvwfkwOHx85Zd9k9Lp8t9di0qpPNY/fNBjaP
	j09vsXj0bVnF6PF5k1wAe1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IxrN3kL2oUrDq42aWDcwN/FyMkhIWAicenaMmYQW0hgN6PEhelp
	XYxcQPYnRoknLS1sEM43Rolty3+xw3T83TWfHSKxl1Hi6KynrBDOZ6D2n9uBWjg42AQ0JS5M
	LgVpEBEIkHj6+xxYmFmgVGLzDEuQsLCAj8TN3UuYQcIsAqoSc965g4R5BSwl/k89yAqxSl5i
	5qXvYGs5Bawkrl/9yQJRIyhxcuYTMJsZqKZ562xmiPqf7BLPFhVA2C4Sv4+dZoGwhSVeHd8C
	db6UxOd3e9kg7GSJSzPPMUHYJRKP9xyEsu0lWk/1M0NcrCmxfpc+xCo+id7fT5hAwhICvBId
	bUIQ1YoS9yY9hbpYXOLhjCVQtofEpu5vLJCw6WWUWP3iEMsERvlZSD6YheSDWQjbFjAyr2KU
	TC0ozk1PLTYtMM5LLYdHaXJ+7iZGcKLU8t7B+OjBB71DjEwcjIcYJTiYlUR4d/z/kyrEm5JY
	WZValB9fVJqTWnyI0RQYwhOZpUST84GpOq8k3tDE0sDEzMzMxNLYzFBJnPd169wUIYH0xJLU
	7NTUgtQimD4mDk6pBqbzqaK/L1xeuM/Ezmv3oYZ+/XiVzzX+vb7lErZ5GT9vqpT753IcCb31
	8JIQW3/MveAvi0U/+2punf3glJnfX9sDK0QM9zJExR6+32CnN7VUw+pHivOeE1OepGtdrll8
	30bpdE4+d/nzmdXVps0Z6x65HK5WbaqO+NES6vBv45KQ2bvfeYbfSp1943+sC6d0fHugxzbx
	na6yxzSbihfxzL1xlpXnUM4HueaG7RETL3NKFX4XKmB9E/Xrs0BAoDPr5uD26XemRJb1q7d4
	/a2YmXBCJYTra7O2XNXTtIk28+acF3T7Nv0O26Xky31dTdFaR1vmSb3M+HmsJs9gTumTe9wR
	DoLBbnas9/huHz+eq8RSnJFoqMVcVJwIAGQb/qodBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnO7sK39TDQ5c57X4+PU3i0XThL/M
	Fqvv9rNZrFx9lMniXes5FotJh64xWuy9pW2x/Pg/JgcOj52z7rJ7XD5b6rFpVSebx+6bDWwe
	H5/eYvHo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujGs3eQvahSsOrjZpYNzA38XIySEhYCLx
	d9d89i5GLg4hgd2MEj03Z7BDJMQlmq/9gLKFJVb+ew5V9JFR4vqpG2xdjBwcbAKaEhcml4LU
	iAiESCxrncAMYjMLVEos2TwXrFdYwEfi5u4lzCDlLAKqEnPeuYOEeQUsJf5PPcgKMV5eYual
	72DlnAJWEtev/mQBsYWAaqY/X80KUS8ocXLmExaI8fISzVtnM09gFJiFJDULSWoBI9MqRsnU
	guLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgQNfS3MG4fdUHvUOMTByMhxglOJiVRHh3/P+T
	KsSbklhZlVqUH19UmpNafIhRmoNFSZxX/EVvipBAemJJanZqakFqEUyWiYNTqoFpYuSqRba/
	vV1Oxsp9Y9C8de/FrC5WOat12qESvvF+ujP5Xl+fdof34YMFj9Lc17aflXJf2L3QeyL3tRc6
	G/br856+uMn0UUxNv9EF3uZOK4FXHFnq+Y2JHJt0/r9Kbe/LmqM15UzxxZ/rl+zj3Kp151aX
	Yypz2qNWs+K8ss1hdxuvdx2Y65a3/SRLjFXq9+/bc/SExVkOh+5deNtOdcm++nMW/l/2KFo8
	rVjnkz+hY2VAETvH1OSM+bMk2+M2zP7owH+PKUTjw3/ZM98+1yXfvSb+KeTV47Ibl1xe1ShZ
	cBk8m1cwQyx667kDSRmTpLvOMm2zEZFZMH/p3UmsHa3HlU/uWFPWX22otCbiVvAMJZbijERD
	Leai4kQAd0Gv1eMCAAA=
X-CMS-MailID: 20240322185731epcas5p20fc525f793a537310f7b3ae5ba5bc75b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240322185731epcas5p20fc525f793a537310f7b3ae5ba5bc75b
References: <20240322185023.131697-1-joshi.k@samsung.com>
	<CGME20240322185731epcas5p20fc525f793a537310f7b3ae5ba5bc75b@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Get rid of the flags field in io_rw. Flags can be set in kiocb->flags
during prep rather than doing it while issuing the I/O in io_read/io_write.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rw.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 47e097ab5d7e..40f6c2a59928 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -27,7 +27,6 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u32				len;
-	rwf_t				flags;
 };
 
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
@@ -78,10 +77,16 @@ static int io_iov_buffer_select_prep(struct io_kiocb *req)
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct kiocb *kiocb = &rw->kiocb;
 	unsigned ioprio;
 	int ret;
 
-	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
+	kiocb->ki_flags = 0;
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		return ret;
+
+	kiocb->ki_pos = READ_ONCE(sqe->off);
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
 
@@ -91,15 +96,14 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (ret)
 			return ret;
 
-		rw->kiocb.ki_ioprio = ioprio;
+		kiocb->ki_ioprio = ioprio;
 	} else {
-		rw->kiocb.ki_ioprio = get_current_ioprio();
+		kiocb->ki_ioprio = get_current_ioprio();
 	}
-	rw->kiocb.dio_complete = NULL;
+	kiocb->dio_complete = NULL;
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
-	rw->flags = READ_ONCE(sqe->rw_flags);
 	return 0;
 }
 
@@ -720,7 +724,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	struct kiocb *kiocb = &rw->kiocb;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = req->file;
-	int ret;
 
 	if (unlikely(!(file->f_mode & mode)))
 		return -EBADF;
@@ -728,10 +731,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
-	if (unlikely(ret))
-		return ret;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
-- 
2.25.1



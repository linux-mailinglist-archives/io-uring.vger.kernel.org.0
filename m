Return-Path: <io-uring+bounces-7523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 633A5A920C4
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 17:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDE60188620B
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 15:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2B61A4F21;
	Thu, 17 Apr 2025 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cw1+ntgT"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA0826289
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744902322; cv=none; b=RO+EnYEK8O1/zhmIdrq7qi+6oeEu6MnmXX68bPstWb27wKEqwOaVmoHEie574UOqpF+pDCSqZ05SMO+4Wnr71EkKFFLRFEjlAL8ss6mdAOvnSr4sM3ZH39AUp8bdJm/YI6Pm2JlubCr4Gl1sSKqEOekpYa2J2k9GLIOwKSh5SWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744902322; c=relaxed/simple;
	bh=dJ67Yle79Bh4xzuljdGSxSQ1lTd+upiH/VCV9UUqEZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=JwU9uwAAiQxJfpYYuDCOHSaT1oDevuHKNlOj+DyK0HCNzAik2olIh1olDzt9Dm/N3uboFcV+KksxMLVsPL2acONcZpTUStad4uop3Yk0XlIOYx7xbfS7zZwZkumPBjch3q6fOMb7iPvQteXJM+E5zhgLO2iG4Z7/tHcXev1OJ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cw1+ntgT; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250417150517epoutp046e9b0a50206f23d628352832233cc746~3I2m6QgCT1020710207epoutp04H
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 15:05:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250417150517epoutp046e9b0a50206f23d628352832233cc746~3I2m6QgCT1020710207epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744902317;
	bh=+zsW3bGXuv86tJqCp2dlgg7hkdz9BMeaA2j5Au6PoRQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cw1+ntgTf+pMyF4+h7H1/MuKil95oQzzfh8wGQBFqCLLb6XRTjnxxXXf9o6Mc4HmC
	 weco5Huz2SXPj0TAfmprHBCuBA86k45/QS0pyMPdeXd3EbBngfL1yLQPiLxtoE9N6R
	 9aUCvby7qxbPGfWd+kSh6nZY9QpaWjUV1Ubgqb9w=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250417150517epcas5p22e2871c5c4ea555ce1a4be2212fe646a~3I2molDy12012220122epcas5p2S;
	Thu, 17 Apr 2025 15:05:17 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.176]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4Zdh5m05rlz2SSKX; Thu, 17 Apr
	2025 15:05:16 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250417140224epcas5p1f881e8a204df88d33365f3e8acba6a89~3H-siMm870919509195epcas5p1M;
	Thu, 17 Apr 2025 14:02:24 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417140224epsmtrp1e4d8f96cc55cfd8d371a7c9885bdb145~3H-shqUc30820608206epsmtrp1P;
	Thu, 17 Apr 2025 14:02:24 +0000 (GMT)
X-AuditID: b6c32a52-40bff70000004c16-ef-680109ef8484
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.67.19478.FE901086; Thu, 17 Apr 2025 23:02:24 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250417140223epsmtip28bdc19a7e5daf9babe5220e91f52fa2e~3H-r09l5x2510225102epsmtip2Q;
	Thu, 17 Apr 2025 14:02:23 +0000 (GMT)
Date: Thu, 17 Apr 2025 19:23:57 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Pavel Begunkov
	<asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: ensure segments counts are correct on
 kbuf buffers
Message-ID: <20250417135357.aiobpzii6mviujyu@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9c129aed-6e07-4f23-934b-951d3585cd5a@kernel.dk>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSvO4HTsYMg5M7GS3mrNrGaLH6bj+b
	xbvWcywOzB47Z91l97h8ttTj8ya5AOYoLpuU1JzMstQifbsEroxnWw6yFlzhq/j/fAt7A+MT
	7i5GTg4JAROJvme7mboYuTiEBLYzSrz6+IYNIiEpsezvEWYIW1hi5b/n7BBFjxglOu6vB0uw
	CKhKnHh6Bcjm4GAT0JY4/Z8DJCwioCDR83sl2BxmgSCJxqmdYLawQITEiaVTWUFsXqDF93d/
	B7OFBGwkHt1dxA4RF5Q4OfMJC0SvmcS8zQ/BxjMLSEss/wc2nlPAVmLpnS+sExgFZiHpmIWk
	YxZCxwJG5lWMoqkFxbnpuckFhnrFibnFpXnpesn5uZsYwSGqFbSDcdn6v3qHGJk4GA8xSnAw
	K4nwnjP/ly7Em5JYWZValB9fVJqTWnyIUZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXA
	JP50NavUYis7iR/Xu+butViUuk5KlYvv9Do1leVKbbyV/dt42zqOs767WPnkmoc1KytDgbaR
	7kGbgLUKT8pLlp00Xt96/uSUY33TlcTUWQ93q1otuq5rGLLiyFRDnrrs6RcWPLaIKfFfp5pd
	t2ue3DaDQhmZ9IUXzjBOETPhcTQ+6ZmsOmN6pdjvox5/NnTGrTPwF7vdPWXh950sh+PZt/mI
	i7Zsen9T4fE1m2cdXEWtCz/bM3646/f/++l1u6o+tjKt/PFzQVu4096YjbFa9za3eK74nem4
	NKhQ4Pn9P7Nd/u5bGdhnbSZ8+oFfy4KApW+jEr7Klp3Q2HDG7mqsw/t9Stv/VJ01S5znNSnK
	R4mlOCPRUIu5qDgRAPwOE6TAAgAA
X-CMS-MailID: 20250417140224epcas5p1f881e8a204df88d33365f3e8acba6a89
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_90f_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417140224epcas5p1f881e8a204df88d33365f3e8acba6a89
References: <9c129aed-6e07-4f23-934b-951d3585cd5a@kernel.dk>
	<CGME20250417140224epcas5p1f881e8a204df88d33365f3e8acba6a89@epcas5p1.samsung.com>

------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_90f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/04/25 06:29AM, Jens Axboe wrote:
>kbuf imports have the front offset adjusted and segments removed, but
>the tail segments are still included in the segment count that gets
>passed in the iov_iter. As the segments aren't necessarily all the
>same size, move importing to a separate helper and iterate the
>mapped length to get an exact count.
>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
>---
>
>Same as the one I sent out yesterday, but just for the kbuf part.
>
>diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>index 4099b8225670..04e19689d2f3 100644
>--- a/io_uring/rsrc.c
>+++ b/io_uring/rsrc.c
>@@ -1032,6 +1032,26 @@ static int validate_fixed_range(u64 buf_addr, size_t len,
> 	return 0;
> }
>
>+static int io_import_kbuf(int ddir, struct iov_iter *iter,
>+			  struct io_mapped_ubuf *imu, size_t len, size_t offset)
>+{
>+	size_t count = len + offset;
>+
>+	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, count);
>+	iov_iter_advance(iter, offset);
>+
>+	if (count < imu->len) {
>+		const struct bio_vec *bvec = iter->bvec;
>+
>+		while (len > bvec->bv_len) {
>+			len -= bvec->bv_len;
>+			bvec++;
>+		}
>+		iter->nr_segs = 1 + bvec - iter->bvec;
>+	}
>+	return 0;
>+}
>+
> static int io_import_fixed(int ddir, struct iov_iter *iter,
> 			   struct io_mapped_ubuf *imu,
> 			   u64 buf_addr, size_t len)
>@@ -1052,11 +1072,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>
> 	offset = buf_addr - imu->ubuf;
>
>-	if (imu->is_kbuf) {
>-		iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
>-		iov_iter_advance(iter, offset);
>-		return 0;
>-	}
>+	if (imu->is_kbuf)
>+		return io_import_kbuf(ddir, iter, imu, len, offset);
>
> 	/*
> 	 * Don't use iov_iter_advance() here, as it's really slow for
>
Looks good.

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_90f_
Content-Type: text/plain; charset="utf-8"


------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_90f_--


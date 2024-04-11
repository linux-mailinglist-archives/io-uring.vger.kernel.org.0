Return-Path: <io-uring+bounces-1501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDFC8A0801
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 08:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C649284952
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 06:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C6813C808;
	Thu, 11 Apr 2024 06:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sFSjJx4I"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCDF13C3F4
	for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712815533; cv=none; b=ncA4mKzDj9yoSja6TGcJMwtHJuMVjI2wpfNzL35i2fbsQZ77nqR3u6dJDKC+G+NHHSgjSy4sCciqDYL9uCvRQ8MUOhFPVKa20juwtD4pHitCT2rlAwqevmhWODs8o6w2TqDXCYLr99LW6u1gdSh4l1HLOlCChN5S6mYmPG8l4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712815533; c=relaxed/simple;
	bh=42veAAZ1dmk9QYrh+vn6lWmZlzNtZBuk69PshOdKmeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=TSMWTdKjAdve0SB9znUNSS7/iD7M3IyNxbG7MzAWPSuLVvdzRxYavfJ1O9zJL3GzjFWrxmUrVwm/iPAyPHMhdPsU7y3UvklB0PLgi7lUvtvUbrjXT+vaUVZ3fQcF/2P/e+WqhNRveqX081RCUFz3Q8NjIts9aEBeo3Tex2fGFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sFSjJx4I; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240411060528epoutp0471a59fa529741e3cddc7d3b37f45cbfd~FJKXypnRM1196611966epoutp04L
	for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 06:05:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240411060528epoutp0471a59fa529741e3cddc7d3b37f45cbfd~FJKXypnRM1196611966epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1712815528;
	bh=ueO3PHartKhKKBjiq1R8BXyfBbFyxQMwMGF45bNUZ4k=;
	h=From:To:Cc:Subject:Date:References:From;
	b=sFSjJx4ICisHNOtF/YWhS2C8kR6urN5PnLYicCOP9ULtOWxPQK3/IuzYSeMiS2gyy
	 OxF9g0W+3sRGqlQuGBH+wiu+9g73t9Aex7iMyHwIlp/Nfg+OM244VNZK1UOdSTFkD0
	 AQzSnKX7+qlvcAzDA7/ueO29o4tllym69IKwij/8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240411060528epcas5p3e596de18a8d9ae25ac6d4c40f712dad9~FJKXZo5CG1762317623epcas5p3_;
	Thu, 11 Apr 2024 06:05:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VFTh65dq9z4x9Pw; Thu, 11 Apr
	2024 06:05:26 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0F.3D.09688.6AD77166; Thu, 11 Apr 2024 15:05:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240411060014epcas5p1658ee85070dfc22544e4fbff9436cb46~FJFzZaKHd2631926319epcas5p1l;
	Thu, 11 Apr 2024 06:00:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240411060014epsmtrp2a06b907980456bcdf47db28310e25746~FJFzYkpx70880608806epsmtrp2o;
	Thu, 11 Apr 2024 06:00:14 +0000 (GMT)
X-AuditID: b6c32a4a-837fa700000025d8-ac-66177da6b5f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	90.D4.08924.E6C77166; Thu, 11 Apr 2024 15:00:14 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240411060013epsmtip2f3c98ab1d7d0a2b84e952df61d96a39b~FJFyTpV4Z2118521185epsmtip2R;
	Thu, 11 Apr 2024 06:00:13 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com,
	xue01.he@samsung.com
Subject: [PATCH] io_uring/timeout: remove duplicate initialization of the
 io_timeout list.
Date: Thu, 11 Apr 2024 13:59:53 +0800
Message-Id: <20240411055953.2029218-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTQ3dZrXiawZEmHYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hs3i2l9Piy+Hv7BZnJ3xgtei6cIrNgdNj56y77B6Xz5Z69G1Zxejx
	eZNcAEtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO
	0CVKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMj
	U6DChOyM2XdOMRecZq34e7qTsYHxDksXIyeHhICJxPHWE8xdjFwcQgK7GSVOTbwG5XxilGj/
	cwTK+cYo8eb0A3aYlu1PL7BCJPYySsz5cBfK+cEoseHIW0aQKjYBTYnLMxvAbBEBYYn9Ha0s
	IEXMArMZJa7+fMAKkhAWiJHYu3sTE4jNIqAqcfzSNLCreAVsJX6+f8YEsU5e4mbXfmaIuKDE
	yZlPwGqYgeLNW2eD3SchcIpd4tDVm1ANLhKLb59ghrCFJV4d3wJ1t5TE53d72boYOYDsYomH
	ffkQ4QZGiW2/6yBsa4l/V/awgJQwAz2wfpc+RFhWYuqpdUwQa/kken8/gdrEK7FjHoytIvF+
	xTsmmE3rW3dD2R4S/Sv6wa4REoiVeNF6n30Co/wsJN/MQvLNLITNCxiZVzFKphYU56anFpsW
	GOWllsNjNjk/dxMjOEVqee1gfPjgg94hRiYOxkOMEhzMSiK80lqiaUK8KYmVValF+fFFpTmp
	xYcYTYFBPJFZSjQ5H5ik80riDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi
	4JRqYOKI/TLrv5LhnfOf5k+eXXi/TzXnzqxrd1ed+Drpvml7dfGdwNOWaY+6/qjnBj9P+7dh
	SXLvgtwHP6Ve6Ed2Lu40qBY5OV33/HVJ3u410T+2rJx3+WTcErEg/rU1ovm7pJXYN91zE8sz
	P32LY8aznzXtGzX3MLAzXP3m8X0fn/y/b08l1z6a5S3TqFLb6K8zzfbjvigBiWCH32+qF5ZW
	/9YOOrtk/mWZy2t8H3ZIvX2yYsbDI449a5zyel58rj/qc2T5N9+5tqoe4j45y2unWktsW/Py
	wOz2OZJbhUMtl9m/nLpaqfyikEPD0/6CkrkfpY7WxKn9Y5ttu+9pg/0nD0WVnm8B5g/3ZFU5
	VBj73qlWYinOSDTUYi4qTgQAxIjo5RoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWy7bCSvG5ejXiaQetPMYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hs3i2l9Piy+Hv7BZnJ3xgtei6cIrNgdNj56y77B6Xz5Z69G1Zxejx
	eZNcAEsUl01Kak5mWWqRvl0CV8bsO6eYC06zVvw93cnYwHiHpYuRk0NCwERi+9MLrF2MXBxC
	ArsZJXr/vGCFSEhJ3Gw6xgRhC0us/PecHaLoG6NE5/VXjCAJNgFNicszG8BsEaCi/R2tYFOZ
	BRYySlyfpQBiCwtESTz6/xpsKIuAqsTxS9PAangFbCV+vn8GtUBe4mbXfmaIuKDEyZlPoObI
	SzRvnc08gZFvFpLULCSpBYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgoNVS3MH
	4/ZVH/QOMTJxMB5ilOBgVhLhldYSTRPiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6iN0VIID2x
	JDU7NbUgtQgmy8TBKdXAVPJ4wo1qlv2tTXKq2sEyAtvLXufHSwseYexKsPu0sVAreTpnPucZ
	vTcMJ5v9gpkKTP6dXCz/ebERm4uWWctcxsfP2Pa9ZpliVXGPgfGmzuJfH1Zl1al945X/vGxz
	xsJX0cZa0Q7L/shr+qqlbHogovj9/GGBGW8cdB+cm+ux91r30ZWaupn1KTM3FWcFp24K2q1h
	Lnl2P3/FMvEj1TIapjlL/2XILi2zP1+7xzq28P/PC+udzzOYuLE9DGNpZApZtW714R2n/Jwe
	H3iw/56AXZdx4K2DzT0cZueuCNQubLt7x06h51Pe1JbFIvYbF8kbM0zZXjjntuj2xbFXGaex
	+SuXfNB7FDRjSpxP89wVSizFGYmGWsxFxYkA57IzRMUCAAA=
X-CMS-MailID: 20240411060014epcas5p1658ee85070dfc22544e4fbff9436cb46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240411060014epcas5p1658ee85070dfc22544e4fbff9436cb46
References: <CGME20240411060014epcas5p1658ee85070dfc22544e4fbff9436cb46@epcas5p1.samsung.com>

In the __io_timeout_prep function, the io_timeout list is initialized
twice, removing the meaningless second initialization.

Signed-off-by: Ruyi Zhang <ruyi.zhang@samsung.com>
---
 io_uring/timeout.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 7fd7dbb211d6..93ff94e82fd4 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -541,7 +541,6 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
 		return -EINVAL;
 
-	INIT_LIST_HEAD(&timeout->list);
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 
-- 
2.40.1



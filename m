Return-Path: <io-uring+bounces-3010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4C9967F7B
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 08:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4763A1F228B9
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 06:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B03E77F11;
	Mon,  2 Sep 2024 06:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qVY2NEWQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A0B10F1
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725258632; cv=none; b=rRe2JIA/mhT0T8cQ787yGiBmvnL35ViTz3JawceyFlRLur9BO+ynZ6U2SumWHwL+ET1iblChHhnU5oWSBVYoqYb3vS5Tm0mw5QUvrhxadnNXzx9iOX8ef6JANWFdiYKWerFlbF9+yr3iFwRppokumdhgrEevopUohOGYzbXIwLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725258632; c=relaxed/simple;
	bh=8ufEzBtENkj3kcCCz5u45yOh6RgRHcr3BWBlDO+Pu/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=ja5X+rcgXWrFWio65s30J+sWz6iHUVf3XzbjUHpAgfbnMDKMkmO/FP7MvsoYfMwDvRrz9twPpgvZK/e4vbmq+bXBmE8FCHGqXInq6yr7ILhHsoXT/k+w9VkS531Lw2EYQxGDD7PS2X/qm3uX8we/AZ2GtULY5o+t3vEM66aeTzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qVY2NEWQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240902063026epoutp0260f57da83be9ea34edc288e1207fefd0~xWZR_Kous0955209552epoutp02-
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240902063026epoutp0260f57da83be9ea34edc288e1207fefd0~xWZR_Kous0955209552epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725258626;
	bh=L7zC6L2CbBbDppBF+3JJWuKcb0A+5VbMyWKE//19YAY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=qVY2NEWQj27oQ7kjmiMfs+3m5ZJDUEChesaXl5/d+AkvMEY61H8iZSuv3FoDASWw3
	 9GoyMU7O0c4/c8nrM40Aib1opfsmUUqKMlVWCEAACIreWhtSJWdKoD9yCyMkY0vhS0
	 6+i3PxBoDLHgEQezVP2nbgkIUewhQ37CfLA0egz4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240902063026epcas5p3b17b9ce30a3c4aad9f9fe9a5c2711921~xWZRuqj4l1666916669epcas5p3j;
	Mon,  2 Sep 2024 06:30:26 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WxzQS736Hz4x9Pt; Mon,  2 Sep
	2024 06:30:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5C.65.09642.08B55D66; Mon,  2 Sep 2024 15:30:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240902062908epcas5p334384250be037fb09463e5093c082b56~xWYJW9sI70716007160epcas5p3u;
	Mon,  2 Sep 2024 06:29:08 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902062908epsmtrp1e7ef31c7c15a0c1ce32e0bbafcb0b521~xWYJVs_Ol1087410874epsmtrp1u;
	Mon,  2 Sep 2024 06:29:08 +0000 (GMT)
X-AuditID: b6c32a4b-879fa700000025aa-ef-66d55b80c720
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CC.7F.19367.43B55D66; Mon,  2 Sep 2024 15:29:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902062907epsmtip23b26bae4794a01273c1391f2427aef19~xWYIgKgLc2047520475epsmtip2g;
	Mon,  2 Sep 2024 06:29:07 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v1 0/2] cleanup
Date: Mon,  2 Sep 2024 11:51:32 +0530
Message-Id: <20240902062134.136387-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmum5D9NU0g0urTCyaJvxltpizahuj
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgicq2yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
	Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzpj3cBVzwT2mivtPH7A2ME5g6mLk
	5JAQMJHYub6VrYuRi0NIYDejxMcftxkhnE+MEjsuLGaGc9pXtzLDtDw7fx+qZSejxKuPN5gg
	nM+MEju3z2YHqWITUJc48ryVEcQWEdCWeP14KguIzSxgL3Fu9Qew5cIC8hI/Xm4Bq2cRUJXY
	fXMiWD2vgJXE+u6PUNvkJWZe+s4OEReUODnzCdQceYnmrbOhalaxS0zqUYSwXSR2PnwG9Zyw
	xKvjEPMlBKQkXva3QdnpEj8uP4WqKZBoPraPEcK2l2g91Q80kwNovqbE+l36EGFZiamn1jFB
	rOWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kGKNtDYsaFJUwgI4UEYiXef9CYwCg/C8kzs5A8
	Mwth8QJG5lWMkqkFxbnpqcWmBcZ5qeXweE3Oz93ECE53Wt47GB89+KB3iJGJg/EQowQHs5II
	79I9F9OEeFMSK6tSi/Lji0pzUosPMZoCQ3gis5Rocj4w4eaVxBuaWBqYmJmZmVgamxkqifO+
	bp2bIiSQnliSmp2aWpBaBNPHxMEp1cCUZzBr3j77LXkbyjL6j0/sbF7/NqA2KP+dnoiR59kb
	lWmfstiS13Q9X15onNC5+P2hOcJHI6+XSqbfUretLNcJmrPZuyk58QnX6UnTHgbnB4Q2834S
	WTI5YgnX265D/uWyscaHuPs3ppU9nn1rStLzl5znJv5b9TVv6a5//pvirCeu9dU5s1zsQUCI
	x80H8tOXcZjK+D++UPCgceumzkhjxq9zvnK5G9y1N+Ro//Gm+/gSqwufd/+6OPdlnk+0uaQR
	wz3tGWtFn7Komk+78+jT/f/Xb9V5r/P4r2kaX/HVdeOpvsYDQut3nVr1fof78cJsGfUGxwP6
	u9n15G6mnchyKVneYjb/KvNPnnnr2c4tVmIpzkg01GIuKk4EAFCtmm4ABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsWy7bCSvK5J9NU0g8kTZC2aJvxltpizahuj
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmPdwFXPB
	PaaK+08fsDYwTmDqYuTkkBAwkXh2/j5bFyMXh5DAdkaJiesWsEMkJCROvVzGCGELS6z895wd
	ougjo8SmD+9YQBJsAuoSR563AhVxcIgI6Eo03lUACTMLOEpM3XANbI6wgLzEj5dbwGwWAVWJ
	3Tcngs3kFbCSWN/9kRlivrzEzEvf2SHighInZz5hgZgjL9G8dTbzBEa+WUhSs5CkFjAyrWIU
	TS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIDjmtoB2My9b/1TvEyMTBeIhRgoNZSYR36Z6LaUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1MYWJuCZUqbOde
	i2+3nFM1e8HM6Wnb9ZhTu18JVj0uPJKxKIdtWl3IsRXzuSYY2m/UEn/97HHAWx6ZrR7FYkb3
	H7xKznmTrdc8r4BpXdV/Fik3rVkJYdk2Km3LVmkvDNz4wG5u5Q71fEHT9bfuswmpmS09ItnU
	vrxwYoQf1wuVfctNnF2vub5Vn/B1Ukld6mqFZxctzj6JOnQtLOCn37ZCy9gFs9oDvuU9XsJ2
	YmmgJdvv/cJmDbtaXhUu+3b87gz9C0tvX9ph5SicaOnxS3XyAlPuvoPil8Tm7Xi2RTlio88F
	NVbexYH64gu+ZybZ7gjn/7B4fUsDL+/8ozt+xMtwp6xlsbf7uH/WhFdLyqfEKLEUZyQaajEX
	FScCAEaeyrioAgAA
X-CMS-MailID: 20240902062908epcas5p334384250be037fb09463e5093c082b56
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902062908epcas5p334384250be037fb09463e5093c082b56
References: <CGME20240902062908epcas5p334384250be037fb09463e5093c082b56@epcas5p3.samsung.com>

Two cleanups
First patch adds a new line after variable declaration.
Second patch removes a unused declaration.

Anuj Gupta (2):
  io_uring: add new line after variable declaration
  io_uring: remove unused rsrc_put_fn

 io_uring/eventfd.c | 1 +
 io_uring/rsrc.h    | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

-- 
2.25.1



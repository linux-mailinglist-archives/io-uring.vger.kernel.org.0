Return-Path: <io-uring+bounces-7524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B4AFA920C5
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 17:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39E14445D63
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 15:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBD31A4F21;
	Thu, 17 Apr 2025 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O5v+69Wr"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9326626289
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744902330; cv=none; b=jAVnnctJxBtEDlRH9gimJ7qGgZE3adgtNKaDoGgwxNjz8kcwg6LI+5qZk3RLP/1C7afqTRP2mdaR+LFQJXgMsG+n8ARTD3GgZ7hXi0WFomSUM+J5VL3Gobq4NLKlO8B1mFzikyWVk+wlTBoamG9TIQpaOY1UiVkS/cKvWUXFlOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744902330; c=relaxed/simple;
	bh=P3Un+mf/EyDOhk6DrKnJjhybQv56Pu9o9lwJa/KEuPg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=doPwx2P6ZTCLeach7fwd3ItXF1aUT1NUy5ySJR4ASyexjWuYvQlNA+WVTXtGbyf46ThJvU6ReeiSoiWaKfE2t14kUkovlr2Q359hetqzF97y465LFRX7/nWRhPX0QNhEoPgcf1LjsFOBV+DKHwti529vK6fmPxT+9fuFRoz4MlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O5v+69Wr; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250417150525epoutp02c44da83d0b5ac76a7fd73869693a38c5~3I2uUmf1e2861128611epoutp02K
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 15:05:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250417150525epoutp02c44da83d0b5ac76a7fd73869693a38c5~3I2uUmf1e2861128611epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744902325;
	bh=YQVm89m3iu03utvQOqrlmjRiaD0kkN6XIZr8CSubAdk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O5v+69WrWmFMmKUKWB9ecZfu0vxM2ziKbVNbttArvu7OWOE/PjwoSRO+Y9HIDtrzd
	 8Hb++lRtP7DQB97WpH+gANxS+hetsNkFcXO00vmFEuu1TuZcu695JCQLnePM18mudc
	 Wo/QLp5I+92Ht/Zoel6F8muz0Viyfibobger4Pp8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250417150525epcas5p20f45778a8960f69f7a10193e59f98843~3I2uHBXhe2012120121epcas5p2Z;
	Thu, 17 Apr 2025 15:05:25 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.181]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4Zdh5w4SC6z6B9m7; Thu, 17 Apr
	2025 15:05:24 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250417142334epcas5p36df55874d21c896115d92e505f9793fd~3ISLqv4YT0480104801epcas5p3q;
	Thu, 17 Apr 2025 14:23:34 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250417142334epsmtrp2294d89f81153ff89449466b77c7341b9~3ISLqIcpK0089300893epsmtrp2j;
	Thu, 17 Apr 2025 14:23:34 +0000 (GMT)
X-AuditID: b6c32a52-40bff70000004c16-a5-68010ee679ed
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A9.38.19478.6EE01086; Thu, 17 Apr 2025 23:23:34 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250417142333epsmtip284b7e489646a0160624ac391cd976f1c~3ISLEQn_G0309203092epsmtip2n;
	Thu, 17 Apr 2025 14:23:33 +0000 (GMT)
Date: Thu, 17 Apr 2025 19:45:06 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 0/4] io_import_fixed cleanups and optimisation
Message-ID: <20250417141506.e4z52q633j7gvfno@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1744882081.git.asml.silence@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSvO4zPsYMg+3LxS3mrNrGaPGu9RyL
	A5PHzll32T0+b5ILYIrisklJzcksSy3St0vgyvh0oZ+5YB1rxam+SUwNjDtZuhg5OSQETCTO
	n/vE3sXIxSEksJ1RoufkC2aIhKTEsr9HoGxhiZX/nkMVPWKU2NjSwQqSYBFQlTjVtRcowcHB
	JqAtcfo/B0hYBMh8ff0QO4jNLCAjMXnOZTBbWMBJYu/1rWwgNi/Q4nfLn4HNFxKwlFjfcZQF
	Ii4ocXLmExaIXjOJeZsfMoOMZxaQllj+D2w8p4CVxM05O5kmMArMQtIxC0nHLISOBYzMqxhF
	UwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCA1IraAfjsvV/9Q4xMnEwHmKU4GBWEuE9Z/4vXYg3
	JbGyKrUoP76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFqEUyWiYNTqoGJ29I84Fxx4eHI
	hr6MQ3aXFAUfhtpKu4Q3HZJafawruS/r5rkaiaroXY17j78p38KW1jj7WUpu3os5FRF3AtRW
	pGyK2dmimZQ5tTp3Rj9jyaGvMpIvvp2ce1ihMT39bkuvCEf1i9ufvcKNaq2z7Dw1BL6FMAUU
	uUp5ue5TX3Bm69Kzrm1sZmVyovsTl8lPOpciecG6eM2535XKNRetD7ra55q9XvIjMj+lnmFv
	cB3H2xedDSuuNqlEbNlw5Msz636nNoYsXa623RYl3iX3Xyrp3Yp7YGbBGTmb8wvH3DS2w68k
	OT4/vbB1sknc3VpjlaZtP7T2cr6Su3o97V+J5KmXb+PSphrOmsD+8I35DSWW4oxEQy3mouJE
	ALtsUyy3AgAA
X-CMS-MailID: 20250417142334epcas5p36df55874d21c896115d92e505f9793fd
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_9b2_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417142334epcas5p36df55874d21c896115d92e505f9793fd
References: <cover.1744882081.git.asml.silence@gmail.com>
	<CGME20250417142334epcas5p36df55874d21c896115d92e505f9793fd@epcas5p3.samsung.com>

------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_9b2_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/04/25 10:32AM, Pavel Begunkov wrote:
>io_import_fixed() cleanups topped with the nr segs optimisation
>patch from Nitesh. Doesn't have the kbuf part, assuming Jens will
>add it on top.
>
>Based on io_uring-6.15
>
>Nitesh Shetty (1):
>  io_uring/rsrc: send exact nr_segs for fixed buffer
>
>Pavel Begunkov (3):
>  io_uring/rsrc: don't skip offset calculation
>  io_uring/rsrc: separate kbuf offset adjustments
>  io_uring/rsrc: refactor io_import_fixed
>
> io_uring/rsrc.c | 74 ++++++++++++++++++++-----------------------------
> 1 file changed, 30 insertions(+), 44 deletions(-)
>
>-- 
>2.48.1
>
Reviewed and Tested by: Nitesh Shetty <nj.shetty@samsung.com>

------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_9b2_
Content-Type: text/plain; charset="utf-8"


------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_9b2_--


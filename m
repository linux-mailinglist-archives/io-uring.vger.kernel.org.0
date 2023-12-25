Return-Path: <io-uring+bounces-360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F23E181E4E1
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 05:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38E27282C7B
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 04:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF2C4B12A;
	Tue, 26 Dec 2023 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mz725qCh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C84AF76
	for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 04:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231226044740epoutp04e3b9d78e520a058dead12c68a5d7513b~kSE52dMgt1181211812epoutp04o
	for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 04:47:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231226044740epoutp04e3b9d78e520a058dead12c68a5d7513b~kSE52dMgt1181211812epoutp04o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1703566060;
	bh=8j9DBsIc6l+XgLoTDdFdxqqRZv0GeLuIzUymupSBwQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz725qChESt9zUe1DOMc523fzWn9rvsH3TfMtxcWiE8/yKW3e9AFNaFwrsYat9vGa
	 sI6RLFuTNcA0RxCkFcNP2jsNSvcxt99gNCFtnzlfaPvacYyaI1zhS2rqgiZdR06aTB
	 T9tw2DCZ32XQ+lUyQpU1ussZsvwCICDZmGmpbYL4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20231226044740epcas5p4fa3bee302730f2219fbfd02335377720~kSE5grEvH1534115341epcas5p4K;
	Tue, 26 Dec 2023 04:47:40 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Szj1l2JkZz4x9Pp; Tue, 26 Dec
	2023 04:47:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	96.B6.09634.6EA5A856; Tue, 26 Dec 2023 13:47:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20231225024445epcas5p1d0525b9595544d8fe7b8ea60f5741b58~j8wS0_5EL0992509925epcas5p1w;
	Mon, 25 Dec 2023 02:44:45 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231225024445epsmtrp20ba3ca75bef93593fb6980bb7f9fb50c~j8wS0POCa2381923819epsmtrp2P;
	Mon, 25 Dec 2023 02:44:45 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-e9-658a5ae6183e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.70.07368.D9CE8856; Mon, 25 Dec 2023 11:44:45 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231225024443epsmtip1a437a46a9f4bb30d0f8ce26ee6a3ff31~j8wRRxBKL2539125391epsmtip1m;
	Mon, 25 Dec 2023 02:44:43 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v5] io_uring: Statistics of the true utilization of
 sq threads.
Date: Sun, 24 Dec 2023 21:36:36 -0500
Message-ID: <20231225023636.38530-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <c4c2de2e-b816-41eb-8646-8e57b7ed7913@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmpu6zqK5Ug5kfBCzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFpd3zWGzeLaX0+LL4e/sFmcnfGC1mLplB5NFR8tlRgce
	j52z7rJ7XD5b6tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM2YcnMBecIC14lHzLaYGxtUsXYycHBICJhJHt/9j6mLk
	4hAS2M0oMXn3CzYI5xOjxJdj+xkhnG+MEuuOdrDCtPw//gYqsZdR4uqXmVAtXxkleq+0MoJU
	sQloS1xf1wXWISIgLLG/o5UFpIhZ4C+jxISXv5lBEsICkRK7ew6xg9gsAqoSJxtuAF3CwcEr
	YCOx4WQFxDZ5icU7loOVcwrYSrxb2A82k1dAUOLkzCdgTzAD1TRvnc0MMl9CoJVDonv7C2aI
	ZheJKXO/Qn0qLPHq+BZ2CFtK4vO7vWwQdrHEkZ7vrBDNDYwS029fhSqylvh3ZQ8LyEHMApoS
	63fpQ4RlJaaeWscEsZhPovf3EyaIOK/EjnkwtqrE6ksPofZKS7xu+A0V95B403KYBRJaExgl
	WrdtY5zAqDALyUOzkDw0C2H1AkbmVYySqQXFuempxaYFhnmp5fB4Ts7P3cQITq5anjsY7z74
	oHeIkYmD8RCjBAezkgivrGJHqhBvSmJlVWpRfnxRaU5q8SFGU2CAT2SWEk3OB6b3vJJ4QxNL
	AxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamDbulg0XS0/fkdSqc61+Y7Xi
	2i+er1arXu/fKFPkdmB7dWyDmGmCNf9kwaUcKrlVpjPWeAUWzfdMeFTpXCcS9O6Fdt0v0/OC
	6m8vNPZs9/Pctdzurk/JtCjBHcX61zPcVGaWicw+YCWp+Pc56wmbqafm/D+6u3eljczkeTof
	uluz+BfNc2lT8Ixe+/fjVl7NkOlrjn1xqzuu2J664F/suxmdyUwLYzg/51YvTjgl+UpWJSBx
	4vSkjIS1F3ZN612hJinCrfGW+euDP/dY2j+ZNZxadedyzO9fGWbtnD/U/vDsfl/Lf/Z40u7G
	x5Ji61TjVB8u1/kQ8mGa/NQZBz+ELn/+5Inlmim505avKF3cL6bEUpyRaKjFXFScCABahZoC
	NwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnO7cNx2pBqs3ylrMWbWN0WL13X42
	i3et51gsjv5/y2bxq/suo8XWL19ZLS7vmsNm8Wwvp8WXw9/ZLc5O+MBqMXXLDiaLjpbLjA48
	Hjtn3WX3uHy21KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgyZhycwF5wgLXiUfMtpgbG1Sxd
	jJwcEgImEv+Pv2HsYuTiEBLYzSjxrmkZaxcjB1BCWuLPn3KIGmGJlf+es0PUfGaUuN+6jhEk
	wSagLXF9XRcriC0CVLS/oxVsKLNAJ5PE6896ILawQLjEunlX2UBsFgFViZMNN5hA5vMK2Ehs
	OFkBMV9eYvGO5cwgNqeArcS7hf1gI4WASp7PusMEYvMKCEqcnPkEary8RPPW2cwTGAVmIUnN
	QpJawMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjOOy1NHYw3pv/T+8QIxMH4yFG
	CQ5mJRFeWcWOVCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGanphakFsFkmTg4
	pRqYlk4t4Dj3foqMb8lW5+epd+8wWKUf2fQgKPPOcZGUnjsxcbHdc9mz1oX87QnS8Hn8xmGJ
	ydnLRZ6KSpJ7Uhed8YufIeX5Nl077eZKQQadz5YMO1ROSU+2ETd8lTH1/stwoyDd6kYJMes/
	PHMYn7VzNN3S/iXY6exzyq5/z5moelWBqtdRfbHzRB9e8DtW+P3Pe4V9pt4lPx2KlORkixfw
	9np9DDy6To67dX5khl7/Lj1blg1/+QIOmeR+lrkz33RaD/un9q/Lb/ZkZd1eInHe8G7BzlNt
	Pzq3FW06mJMuqu7a9Vhif35znlL8tIC9v9crnrOSsCmeF3r0fDmr9SPu/laN3Q8txBMVtDZu
	LlBiKc5INNRiLipOBAC0caDv6gIAAA==
X-CMS-MailID: 20231225024445epcas5p1d0525b9595544d8fe7b8ea60f5741b58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231225024445epcas5p1d0525b9595544d8fe7b8ea60f5741b58
References: <c4c2de2e-b816-41eb-8646-8e57b7ed7913@kernel.dk>
	<CGME20231225024445epcas5p1d0525b9595544d8fe7b8ea60f5741b58@epcas5p1.samsung.com>

On 12/22/23 07:31 AM, Jens Axboe wrote:
> Yep that would work, just leave the stats calculation to the tool
> querying it. Which is really how it should be.
>
>> In addition, on register opcode - generally it is used for resource like
>> buffers, handles etc.. I am not sure how that can help here. If you have
>> something in mind, could you please elaborate in more detail?
>
> It's also a bit of a dumping ground for any kind of out-of-band
> mechanism, so it would work fine for something like this too. But since
> we already have fdinfo and with your idea of just logging work and total
> time, then we should probably just stick with that.

Thanks for explained. I'll send out a v6.


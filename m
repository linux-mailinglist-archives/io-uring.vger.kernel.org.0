Return-Path: <io-uring+bounces-5170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B7B9E1617
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 09:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 994431649DC
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 08:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85CDB7E591;
	Tue,  3 Dec 2024 08:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XNeITvS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75A72500C5
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 08:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733215518; cv=none; b=fVumxzShfqAlUnWMhwjgvxGh4GR0oHT+QTxj/Q32CyLkR8IA5WE4QSXctwhuNdJyYHPtFpRLBFX9c5FY3G9waEFFO1WnEyJmNymFRryQeYpNEyLaoCBgjvZT7D+0JOicUxLR0jFG3DCfqI9IUufsNkwcalvcLPLeuxfxXGEiHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733215518; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=dD0Ioyvmge3x9FVM6pQAnBbRw6QjT5iaHiHDZNlAdqo8onD/6Ss39WMqqRtPPTf9LeKr52sTHlpffUfwc4Ed6Y5xZmwM/z3wbcP1yYynZj36QErF1v2iSZkxR0YRWIvGSvxzwn0w6VCrpi75GRy8UOf8WZL+nM/Lh7IoMcCavxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XNeITvS8; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241203084513epoutp0283ac905fc572c0a171b4d7184a831319~NnlOcJgyD2631426314epoutp02A
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 08:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241203084513epoutp0283ac905fc572c0a171b4d7184a831319~NnlOcJgyD2631426314epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733215513;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=XNeITvS8bZAK8J0MBzrgp5jCG4GJ/lC6vCc3eTiYvDS4KZqCyReW8ItwQ3YpoVr7x
	 CcHZYw40F5c7dPTXM/2CvAj8HhNRa2kF3JDXaxXCzlHBa+LumFyerN83bxTgfIuyc3
	 4Pbg/G+0aLEFkRexgiudEmbe80oqT+tXR/myQg7E=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241203084513epcas5p49cee7003d9a7edcad7faca199f481547~NnlOONWLd1347513475epcas5p4u;
	Tue,  3 Dec 2024 08:45:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y2Z3X3ksfz4x9Q1; Tue,  3 Dec
	2024 08:45:12 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2A.90.19956.815CE476; Tue,  3 Dec 2024 17:45:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241203084512epcas5p1321a502962c3dc8c93c7c21dfc85eac1~NnlNGn0Sb0451404514epcas5p1E;
	Tue,  3 Dec 2024 08:45:12 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241203084512epsmtrp147c01e10536d9d4104882ec67db568b3~NnlNF_rvY0972609726epsmtrp1-;
	Tue,  3 Dec 2024 08:45:12 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-cd-674ec5185718
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	76.FD.33707.715CE476; Tue,  3 Dec 2024 17:45:11 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241203084511epsmtip2fabcc9a2499bf6fe35b4b771886f2819~NnlMKpCPm1900919009epsmtip2C;
	Tue,  3 Dec 2024 08:45:10 +0000 (GMT)
Message-ID: <b52e7abb-05de-4db9-8389-d1db88772deb@samsung.com>
Date: Tue, 3 Dec 2024 14:15:09 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Change res2 parameter type in
 io_uring_cmd_done
To: Bernd Schubert <bschubert@ddn.com>, Jens Axboe <axboe@kernel.dk>, Pavel
	Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, stable@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTU1fiqF+6weYDkhZzVm1jtFh9t5/N
	4uH7J2wW71rPsVgs2PiI0YHVY8rTPnaPnbPusntcPlvq8XmTXABLVLZNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr6dTVF+
	aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xqkdS5kKjCquze1jamDU
	7WLk5JAQMJH4ueosWxcjF4eQwG5GicaVO6CcT4wSFx59ZIVzds/ezwrTcmbRNqjETkaJnseb
	WCCct4wSi37cZgap4hWwk/h5bg1YB4uAisThH5tZIOKCEidnPgGzRQXkJe7fmsEOYgsLBEi8
	O9TGBGKLCORLNN3cAtbLDLTt0bWbTBC2uMStJ/OBbA4ONgFNiQuTS0HCnAL+EodO7mCGKJGX
	2P52DjPIPRICj9glFv+5xA5xtYvEkd5lLBC2sMSr41ug4lISL/vboOxsiQePHkDV1Ejs2NwH
	9bG9RMOfG6wge5mB9q7fpQ+xi0+i9/cTsHMkBHglOtqEIKoVJe5NegrVKS7xcMYSKNtD4umk
	bmZIUC1ilNi2dxH7BEaFWUihMgvJl7OQvDMLYfMCRpZVjJKpBcW56anFpgXGeanl8OhOzs/d
	xAhOk1reOxgfPfigd4iRiYPxEKMEB7OSCO/y9d7pQrwpiZVVqUX58UWlOanFhxhNgdEzkVlK
	NDkfmKjzSuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpgYqj1qD7H
	fGxK/v+fL5k+aRpGvTzj+C7s+AsejcYPGZf/TjhmdOLGievJllP/nCz5vn3nn8BI61mH/SW3
	L9rHN3k/l7v+idZs35sV8QfuaF/jvhYQFKx1rplL+uT76Za16xj/Tnvh9OBn6c8VH2c2fz7M
	bfg+f/LVBdZmy3h0p4fVrfsUUfvphMmyxiXaG3YUzsjLZD85l4vV0+aoseIPh+a4u3pzeObv
	z0gLXvZM9cumD6oSt529dv5f/OnruZl7TPttW+wVN3JJHPsmabrV3M9c9uRWCVfZU1/sfJ8n
	Sv9b4Jj2/cXfZ7OvTbz2fLvtyZzKIwtT+v7LKH7neDXNhjll6s+d+3/49Dz4Ztp8LTtbiaU4
	I9FQi7moOBEAIJsbuhwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK7EUb90g+28FnNWbWO0WH23n83i
	4fsnbBbvWs+xWCzY+IjRgdVjytM+do+ds+6ye1w+W+rxeZNcAEsUl01Kak5mWWqRvl0CV8ap
	HUuZCowqrs3tY2pg1O1i5OSQEDCROLNoG2sXIxeHkMB2Rom22T2MEAlxieZrP9ghbGGJlf+e
	s0MUvWaU+DdjEViCV8BO4ue5NawgNouAisThH5tZIOKCEidnPgGzRQXkJe7fmgFWLyzgJzFj
	8g6wehGBfImXV3uZQGxmoCseXbvJBLFgEaPExiufmSES4hK3nswHSnBwsAloSlyYXAoS5hTw
	lzh0cgdUiZlE19YuRghbXmL72znMExiFZiE5YxaSSbOQtMxC0rKAkWUVo2hqQXFuem5ygaFe
	cWJucWleul5yfu4mRnAkaAXtYFy2/q/eIUYmDsZDjBIczEoivMvXe6cL8aYkVlalFuXHF5Xm
	pBYfYpTmYFES51XO6UwREkhPLEnNTk0tSC2CyTJxcEo1MAl93drJmzpvwzn7HZmrz64TWHA6
	WTE8aZXwlx8vl7dx3T1fffVUjc6x1Nov9n//3H3YfdzHaw3LO5c3Gcaa2VbyO3ifWL8T7Nkw
	T03B45x0pZK13LRQWf71Z96YnpA6anHYIVCsfoWg0pLOdNWjf/teXxdQVpJsMsxLnCDebWXU
	aBE3e2Xy/17dB1oc5r4WD7ku33jwKjmiVYdh4h7OKbtrH7bs/WO4TOno0fXlM+75lsSz/1hd
	o//aZp3wWrs3YU1HfF51sGf3Ot7UFEsuevctfSHfT76rT9XErW+5Remppym9l6vr0Zy+55VF
	aaF5cZS+W1DyhdPSPH8KuUIXqS4Um/JibecHI6ujvUuPKrEUZyQaajEXFScCAAyXQPTzAgAA
X-CMS-MailID: 20241203084512epcas5p1321a502962c3dc8c93c7c21dfc85eac1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241202142239epcas5p14f5b07a60622673a93d6e3e6d91b35d6
References: <CGME20241202142239epcas5p14f5b07a60622673a93d6e3e6d91b35d6@epcas5p1.samsung.com>
	<20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


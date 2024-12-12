Return-Path: <io-uring+bounces-5461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C86FA9EE53F
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 12:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99767282535
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 11:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A57221129D;
	Thu, 12 Dec 2024 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AZExY53S"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815DB210F62
	for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 11:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734003601; cv=none; b=h0F/yU3Lydt60AZzBxrvu1pidBfo6M6V2W1DQXlWLp7BcGIzZ7v9pKRZ2H9KITJZDzmaHeIjSoEV08L2aSuIu34K7JUtSK07DjBQ0MDnEjT8vzR7A9GKJDy3G+WVXHdXbnA1UTTUp1Xb//7D1UKS1/ZW2PT9KQk8di4RA7YC5/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734003601; c=relaxed/simple;
	bh=gq5HIoLOaRrwWTFMhl4akmkUagye1PVMUPy8Br/WayU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=a31++B2NqUc4dKxXmKKJ7GvfOji688Bz+PCYyab3a6J+Ji8vgvE53uJ9QCg9z8NrRXL9qQHvtUpw+71/GPW9aQD+N78JIZjtFrd6m23P+n5VUuRJdEo1RiiJfMqFkPAEoRPS1Xo/ft0iKOpPGkdDhUa1h+iMxmUK+00iWGLGf24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AZExY53S; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241212113956epoutp04c0e668596474e0f5172f4691d6941453~QaxVk_KVf0982709827epoutp04O
	for <io-uring@vger.kernel.org>; Thu, 12 Dec 2024 11:39:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241212113956epoutp04c0e668596474e0f5172f4691d6941453~QaxVk_KVf0982709827epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1734003596;
	bh=gq5HIoLOaRrwWTFMhl4akmkUagye1PVMUPy8Br/WayU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=AZExY53StDExVRIy9il+SoWJcySMFVIAGu+MKUFU/uC87U4rv/5XfTFtzBxcnBaj3
	 qsQ4Tm7liNMXmXO1jyMfcrlqyLWprW0+RytxoY9RulaUCYpRjejNhLdrQt5eByflks
	 tXdA2DACaj9nPBf6yiG/nIZFisttvtdoS6heK/yc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241212113955epcas5p4ba3542ee4c4267058ee4f5bdc727415b~QaxUt9OAM2487724877epcas5p4l;
	Thu, 12 Dec 2024 11:39:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y89Vy0JxZz4x9Pt; Thu, 12 Dec
	2024 11:39:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.3B.19933.98BCA576; Thu, 12 Dec 2024 20:39:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241212113953epcas5p42a9eb3b5e449b08d18402016f6657ea8~QaxTPVz2S2487624876epcas5p4f;
	Thu, 12 Dec 2024 11:39:53 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241212113953epsmtrp2f2b12fd0c7e22158831e27899ce2d073~QaxTOa7wi2144721447epsmtrp2c;
	Thu, 12 Dec 2024 11:39:53 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-51-675acb897929
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	5F.F2.33707.98BCA576; Thu, 12 Dec 2024 20:39:53 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241212113951epsmtip1dbc895aaaa00061ddf03ca96691ec892~QaxRqadna2973429734epsmtip1i;
	Thu, 12 Dec 2024 11:39:51 +0000 (GMT)
Message-ID: <6cf38922-2dfc-4788-8cea-304f16d3abfc@samsung.com>
Date: Thu, 12 Dec 2024 17:09:50 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv14 00/11] block write streams with nvme fdp
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com, Keith
	Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241211183514.64070-1-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmpm7n6ah0g7f3rS2aJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxWLSoWuMFmeuLmSx2HtL22LP3pMsFvOXPWW3WPf6PYsDt8fOWXfZ
	Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5nHuYoVH35ZVjB6fN8kFcEZl22SkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaqkUJaYUwoUCkgsLlbSt7Mp
	yi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM5o+f2RuaCg4uXSi0wN
	jHFdjJwcEgImEmdP9bJ2MXJxCAnsZpT4tPgzM4TziVHi5uwpjHDOlXnzmWFadhyfxApiCwns
	ZJQ4ci8Eougto8TTTQdYQBK8AnYS3bs+MYHYLAKqEt3P3rJCxAUlTs58AlYjKiAvcf/WDHYQ
	W1jAXuL38xksIINEBHYwSnS+fArWzCyQKjHh53FmCFtc4taT+UBxDg42AU2JC5NLQcKcAqYS
	Xx7chyqRl9j+dg7YCxICezgkDn3oY4G42kXizvmLbBC2sMSr41vYIWwpic/v9kLFsyUePHoA
	VV8jsWNzHyuEbS/R8OcGK8heZqC963fpQ+zik+j9/QTsHAkBXomONiGIakWJe5OeQnWKSzyc
	sYQVosRDYuFNN0hQdTBK/DnSwDyBUWEWUqjMQvLkLCTfzEJYvICRZRWjZGpBcW56arFpgVFe
	ajk8tpPzczcxgpOxltcOxocPPugdYmTiYDzEKMHBrCTCe8M+Ml2INyWxsiq1KD++qDQntfgQ
	oykweiYyS4km5wPzQV5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxS
	DUyWTfcnuHQ+dkhM2uQr3/1/4UzLnu3J0cUnytb4PnsQU9LH9usf021Nk0k6hv7c1tH1rtdj
	t/c8+van9+7BS7s1Fukm72N5+Tcjd1KBwPSU6n8hE488i+XKCJ1YvEJ96xZBmeYHWzecuH9a
	uGGW95rVYbLLSpeELGJR3VJlI3Y4cPt8wZBKdX0fvjeFkn+fakl1xW39e0pp6Sz9WBe1h57m
	U/7N5LYJucrgtk3jSzenXMSCIobwnU+3a5ys7Tr3xa6Z79aVf5vL7hxd2tZUu+u0C5/W0wUz
	xD+qJp6QX7rCrFgm6ubpVpm0nkl2M8Sl/NRf3JPeNy3j8+ONn/Ofmep3SPcdjgrd9n2Lp8hT
	PTklluKMREMt5qLiRADFMo4TTwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSnG7n6ah0g6fTVCyaJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxWLSoWuMFmeuLmSx2HtL22LP3pMsFvOXPWW3WPf6PYsDt8fOWXfZ
	Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5nHuYoVH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVw
	ZbT8/shcUFDxculFpgbGuC5GTg4JAROJHccnsXYxcnEICWxnlNjwdDsbREJcovnaD3YIW1hi
	5b/n7BBFrxklXl+czQiS4BWwk+je9YkJxGYRUJXofvaWFSIuKHFy5hMWEFtUQF7i/q0ZYIOE
	Bewlfj+fwQIySERgB6PE/3U7wbYxC6RKzP64kA1iQwejxIFn09ghEuISt57MB9rAwcEmoClx
	YXIpSJhTwFTiy4P7zBAlZhJdW7sYIWx5ie1v5zBPYBSaheSOWUgmzULSMgtJywJGllWMoqkF
	xbnpuckFhnrFibnFpXnpesn5uZsYwVGnFbSDcdn6v3qHGJk4GA8xSnAwK4nw3rCPTBfiTUms
	rEotyo8vKs1JLT7EKM3BoiTOq5zTmSIkkJ5YkpqdmlqQWgSTZeLglGpgYlfe9aJPdbeh9/rr
	11JX/lE6lr3sd9rmy74JOpuqftjniugdDZQWLbMvblb0dK++Oc+k8/z+yT8t7J2mLnJbYH69
	+KXd31ldQkGsqxteLb/O9ebEAil2IS6FzyYfjAzKp7w7+GX7ibhfBdNMjfe9uu0d5PfYfeI1
	/rkLzseY5Hg4Rh4qTGyY+zt2y4/nTMZa1dU3n6e72SfPCSp5F8s0R7ar5/mafaXexvuMn/Kd
	b8ts+DtDfvrpBTfajj5KbcqP/ii4g2XBzur4suKNd7ligucraX14/kayjIF/r7PrP6mzPFJB
	H9Onfj0wIU+LYa7bkhnGJf+Fow4pLt+1puzdpDuHRNzfR9Wvrd/gsen3VCWW4oxEQy3mouJE
	AI0/9NApAwAA
X-CMS-MailID: 20241212113953epcas5p42a9eb3b5e449b08d18402016f6657ea8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241211190851epcas5p2a359c12000fc73df8920e4801563504c
References: <CGME20241211190851epcas5p2a359c12000fc73df8920e4801563504c@epcas5p2.samsung.com>
	<20241211183514.64070-1-kbusch@meta.com>

For
> 16 files changed, 341 insertions(+), 6 deletions(-)

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


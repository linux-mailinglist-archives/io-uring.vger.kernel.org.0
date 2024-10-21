Return-Path: <io-uring+bounces-3841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBFA9A5962
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 06:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4985281985
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 04:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC3A1CF5F0;
	Mon, 21 Oct 2024 04:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W2+IJxaw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA5B2BB15
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729483215; cv=none; b=AmwzouoRcKFKAbShBP1ln8pUGhxSeBNCyFuUz43OLyXFUrvTpCvSpXyZOY6Nzz7lde5wqf20QyKBHudQKObVsqcK6QlUsrazSNEnHohlXf4cf4IeHhcU9MeCt692Vjjmkb25O/xnQ9rwbEoRkabU3BeVkCOH3bnoJhIODOFjrEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729483215; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=OKyP5FeQEQSzJJDFZ08hTf1Upyo/Zbqt96TqW7Y5Kcb+USJ2FZJiKtSKrQOjTCjaKHFkNhS3o29AM44FK3dWa8U6Rze4JGb5JOWbcetIbBFyJjrNay7EoP/UtPIaacED122B9a4O5ddn/FciUmbayieStgOgIpvYYd1b7iOQ9u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W2+IJxaw; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241021035324epoutp038512b458a56aa330a6f8496eca31a664~AW3KemGJ80198701987epoutp03x
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 03:53:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241021035324epoutp038512b458a56aa330a6f8496eca31a664~AW3KemGJ80198701987epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729482804;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=W2+IJxawqzgcBChIlcNeNfk7coG8mvvD7lbnipymiNmSAScMciTYlAp3jDX8QTRE2
	 eYd+OsvRbWviuIlnM2mVW0UEVWuIIzdDB5wpwPwL7o7pXKfPi1bL3CEmU+lj8uyybZ
	 TPpJJTLNIKML89jrHHGzK3+HbWH29Xp/ByIbAXHI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241021035324epcas5p12ccdd5a52c15f6f360c65c17e64eb3be~AW3KSDTvY0089000890epcas5p1N;
	Mon, 21 Oct 2024 03:53:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XX1cg3HD7z4x9Pr; Mon, 21 Oct
	2024 03:53:23 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	14.A2.18935.330D5176; Mon, 21 Oct 2024 12:53:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241021035323epcas5p3b2390d405621dcf18735b547fee153b7~AW3JA_vPX0434004340epcas5p3M;
	Mon, 21 Oct 2024 03:53:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241021035323epsmtrp125ecbe8d902e2051cee4661eacde54bb~AW3JATGTO1039610396epsmtrp1k;
	Mon, 21 Oct 2024 03:53:23 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-f9-6715d033ad01
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	64.74.08227.330D5176; Mon, 21 Oct 2024 12:53:23 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241021035322epsmtip2c9daad8aed9690ef0a8bec70c8665986~AW3ITdVlF1271312713epsmtip2r;
	Mon, 21 Oct 2024 03:53:22 +0000 (GMT)
Message-ID: <9870b4ad-d140-47a0-9fe6-787128971069@samsung.com>
Date: Mon, 21 Oct 2024 09:23:21 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] nvme: use helpers to access io_uring cmd space
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmuq7xBdF0g1frxC3mrNrGaLH6bj+b
	xbvWcywWe29pO7B47Jx1l93j8tlSj8+b5AKYo7JtMlITU1KLFFLzkvNTMvPSbZW8g+Od403N
	DAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVIL
	UnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM07tWMpUYFRxbW4fUwOjbhcjJ4eEgInEo89/
	mUFsIYE9jBLnvrp3MXIB2Z8YJY6e3c0I4XxjlGg6fIMNpuPewmXMEIm9jBLtW+ayQThvGSVO
	dbwAynBw8ArYSWx6rQnSwCKgKjHhyAwmEJtXQFDi5MwnLCC2qIC8xP1bM9hBbGEBH4kjz4+y
	gbSKCLhKrPikAhJmFrCV+H3kKAuELS5x68l8JpASNgFNiQuTS0HCnAKxEu3z1jFBlMhLbH87
	B+w0CYFH7BJv9y1hhLjZReLDhsNQtrDEq+Nb2CFsKYmX/W1QdrbEg0cPWCDsGokdm/tYIWx7
	iYY/N1hB9jID7V2/Sx9iF59E7+8nYOdICPBKdLQJQVQrStyb9BSqU1zi4YwlULaHRMvKyYyQ
	cN7AKDHxbdwERoVZSGEyC8mTs5B8Mwth8QJGllWMUqkFxbnpqcmmBYa6eanl8LhOzs/dxAhO
	hVoBOxhXb/ird4iRiYPxEKMEB7OSCK9SiWi6EG9KYmVValF+fFFpTmrxIUZTYOxMZJYSTc4H
	JuO8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYRHd/X6/3/kOK
	/oKIvWW195Onf3dlaExnnb4kQdXUh/Wg65k+ZW2hzNT0k1Km/7yVlqx5NXe/NfeTlQ0rP1cF
	Xz5dYxfwc8nlZpUdybk9m3oF3v4w69+eLXJh79yWUm6f+u3V22ZN+BuX3RzoKbZ50VathZbd
	v7Kf1ekr8gZPYp5TuWmJyvnyOHmNGfOWM5768vQ/rz5HhdifYzl+hk5FCc+e+nuebehZ8DXu
	1E/X02sTp0xJdJ6ycbbztNbVe/MfaAtdXFSd15nfdiB085vjS+9ofNs4p/1rzaLTd/5cLVCd
	rcSWFn/o9uezqnut1N566IpZfXHu2ZN7Kl5Lxvzuc9mjkWLBKfNMpizgMrlyR4mlOCPRUIu5
	qDgRAFURnc4OBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSvK7xBdF0gw9H2S3mrNrGaLH6bj+b
	xbvWcywWe29pO7B47Jx1l93j8tlSj8+b5AKYo7hsUlJzMstSi/TtErgyTu1YylRgVHFtbh9T
	A6NuFyMnh4SAicS9hcuYuxi5OIQEdjNKLGg8zQyREJdovvaDHcIWllj57zk7RNFrRonHm4+y
	djFycPAK2Elseq0JUsMioCox4cgMJhCbV0BQ4uTMJywgtqiAvMT9WzPA5ggL+EgceX6UDaRV
	RMBVYsUnFZAws4CtxO8jR1kgxm9glHh96xojREJc4taT+Uwg9WwCmhIXJpeChDkFYiXa561j
	gigxk+ja2gVVLi+x/e0c5gmMQrOQXDELyaRZSFpmIWlZwMiyilEytaA4Nz232LDAKC+1XK84
	Mbe4NC9dLzk/dxMjOPC1tHYw7ln1Qe8QIxMH4yFGCQ5mJRFepRLRdCHelMTKqtSi/Pii0pzU
	4kOM0hwsSuK83173pggJpCeWpGanphakFsFkmTg4pRqYZsqeNWb5LxgZK/dIoV9cJZ331Yoe
	rY2Nmhwux+pjhZo5nnUm8Kh5VNf5HHeMC/jKt/TCZ9ni83NP2/Ze2Ore9uNb6cr3817ceMR2
	YHpXqsKtnvwjPyfmv1CtUGaJ1nStmMnTZ3R8rvlFjV8d19QulKhviZgVOz1EWDJ/+umU8Mne
	11gcQ0Klvh6SVl16Zkuq5QWN1pov/0uFW9kfL7KYWLjOy8hop9G5XwfiM0L/nvsbss3h2v5V
	3E+Db+pOs4rZ/3eb6pIXJ/7yTWEouWwrrjVVonFNru2Kz8JRDdquq2NsON9Jz3mQ/phxDuNp
	1n3V8j9mHmSqWjrDzsuj5rezcv+jY3mWp/fpvexnqT2qxFKckWioxVxUnAgAaDsCcusCAAA=
X-CMS-MailID: 20241021035323epcas5p3b2390d405621dcf18735b547fee153b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241018161636epcas5p43562d1c949f7e6ed0289a7ec213490ff
References: <CGME20241018161636epcas5p43562d1c949f7e6ed0289a7ec213490ff@epcas5p4.samsung.com>
	<c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


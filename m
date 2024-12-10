Return-Path: <io-uring+bounces-5401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35FCF9EAA2B
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 08:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E28DC1886D2D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 07:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A103622D4FA;
	Tue, 10 Dec 2024 07:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M76F21Ml"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C771A22D4D5
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733817570; cv=none; b=CKdVQJ8L5K8vnjrMUksc/oiSQ0tKvk3sK67gT/jxYcpBmQ+Velv/OjpCSu4/TQ/z2tTy6HZqQUzg1xug9ktuiBgczk4CILTH0dxLuOeVUXCoGTVeRPilmvf0TCapyTQwXDe+t5JYk97wMohrCoZZjptNnA8qSOwvW0TmEKYDd0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733817570; c=relaxed/simple;
	bh=h/3fWvhBo5ziPTr8sALnHcTet2dmKiQ09pXjyBQeOjg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=nyBvcwRUlCiiBmX7Ha1hRCzhNGhuEQvHSs0/mfEdaavIt4BN/mdBUHSJqWEIAWHPN56a4i0n/A1UQzyi14iehoB6KrN7FFRcwR+PS5qIuXySg8PvGkUBx1aDhLCD4iY43V3mde/qtYde+h7k9vrE/CdWTCKwLF3nLsEZbZoRJF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M76F21Ml; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241210075923epoutp025b8ca5769fa5346ee2f43a1b32c12b7c~PweNjKgTz3020030200epoutp02P
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:59:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241210075923epoutp025b8ca5769fa5346ee2f43a1b32c12b7c~PweNjKgTz3020030200epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733817563;
	bh=h/3fWvhBo5ziPTr8sALnHcTet2dmKiQ09pXjyBQeOjg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M76F21MlhD35AJeo0w2AiCWBJczhtwN5jVMVqtOrlUhs9QmM/MMohLtOzvEuHyPzt
	 9ldvQnO1kDPY5F5lsi2eCuckReglW1UDXUx+PtItPWBiqApDML/SfeHVyh2HigE2jF
	 ZLAhIgolVAM2H2kO+VyG/81Czn83h+ZHZhRNVfqU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241210075923epcas5p277add695cbad2d519247d666fd9c6721~PweNERR3Z2363723637epcas5p2x;
	Tue, 10 Dec 2024 07:59:23 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Y6rjP3JtYz4x9QG; Tue, 10 Dec
	2024 07:59:21 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E7.53.29212.9D4F7576; Tue, 10 Dec 2024 16:59:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241210075259epcas5p23bbb79cdb18ddbfad337d764d4fe75da~PwYn7_1Xi3210632106epcas5p24;
	Tue, 10 Dec 2024 07:52:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241210075259epsmtrp2f11746f760861303bbe9740b41ca0d4e~PwYn7JUK-0373703737epsmtrp27;
	Tue, 10 Dec 2024 07:52:59 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-fc-6757f4d9ed58
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0C.39.18729.B53F7576; Tue, 10 Dec 2024 16:52:59 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241210075257epsmtip2931b210b4f3f67f716b34a50372e4d50~PwYmHFXoC0235202352epsmtip2A;
	Tue, 10 Dec 2024 07:52:57 +0000 (GMT)
Date: Tue, 10 Dec 2024 13:15:05 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 05/12] block: introduce a write_stream_granularity
 queue limit
Message-ID: <20241210074450.otutruwtmy76y5jm@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241206221801.790690-6-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmpu7NL+HpBtOXSFg0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLda/fszjw
	eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHucuVnj0bVnF6PF5k1wAZ1S2TUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
	YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzdG+6wFexk
	rZjxZwNLA+Mzli5GTg4JAROJexP+M4PYQgJ7GCXe/QvuYuQCsj8xSuw+0sYEkfjGKNF9VA2m
	4dHdSywQRXsZJSbMW80K4TwBcg5sYeti5OBgEVCVuPGyGMRkE9CWOP2fA6RXREBR4jwwHEDK
	mQUmMkn8PtTEDpIQFgiX2LvpLlgrL9CC693aIGFeAUGJkzOfgB3KKWAmMX3KPmaQXgmBtRwS
	n2dfZYI4yEXi75GbbBC2sMSr41vYIWwpic/v9kLFyyVWTlnBBtHcwigx6/osRoiEvUTrqX6w
	95kFMiSe/J3JChGXlZh6ah0TRJxPovf3E6hlvBI75sHYyhJr1i+AWiApce17I5TtIdG0/A07
	JFC2Mkq0vNzBPIFRbhaSj2Yh2QdhW0l0fmgCsjmAbGmJ5f84IExNifW79Bcwsq5ilEotKM5N
	T002LTDUzUsth0dycn7uJkZwEtYK2MG4esNfvUOMTByMhxglOJiVRHg5vEPThXhTEiurUovy
	44tKc1KLDzGaAiNoIrOUaHI+MA/klcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQ
	WgTTx8TBKdXAxH04Jm/L/McnTzSX3HL/ccg4XJtj06p8b36pwny71Z7fxWrDM3t1jxas8lh0
	5XXN9IXHDszgy2c452v9mtl04/zgiTfnWTtduz/lAtcyE11fu6fb+WNidki/On1XdOOv811r
	hf/KfrnnP/3941nfX/9mq1pzyKNxXUPjrMP5e11n+gkvyWr76PDUYV5bW2Tf/19LOWetvOu/
	fp70weWJvI76KQ47Jpw2mfGJ0cdlwkb34jLrkLCzTj+dO66fvOoxvfeKnt7sa6FPJ1c+uzPV
	U0Vqp1iRx49V0j/XPbA533mwr/e6/JmC/j1vK/b7N22ofWMp/vFuft4qRlmjavcvb2a+m/Hp
	zNkc7/DAW7bHX1QosRRnJBpqMRcVJwIAq+z/40sEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvG705/B0g+VdRhZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYnH0/1s2i0mHrjFanLm6kMVi7y1tiz17T7JYzF/2lN1i3ev3LA48
	Hjtn3WX3OH9vI4vH5bOlHptWdbJ5bF5S77H7ZgObx7mLFR59W1YxenzeJBfAGcVlk5Kak1mW
	WqRvl8CV8WHRU5aC10wVy3tXsjYwbmLqYuTkkBAwkXh09xJLFyMXh5DAbkaJHxMmskEkJCWW
	/T3CDGELS6z895wdougRo8TW5V+BOjg4WARUJW68LAYx2QS0JU7/5wApFxFQlDgPdA1IObPA
	ZCaJ5zOPsYAkhAXCJfZuussGUs8LtPh6tzZIWEggUaJv5lZ2EJtXQFDi5MwnYOXMAmYS8zY/
	ZAYpZxaQllj+D2w8J1B4+pR9zBMYBWYh6ZiFpGMWQscCRuZVjJKpBcW56bnFhgWGeanlesWJ
	ucWleel6yfm5mxjBkaOluYNx+6oPeocYmTgYDzFKcDArifByeIemC/GmJFZWpRblxxeV5qQW
	H2KU5mBREucVf9GbIiSQnliSmp2aWpBaBJNl4uCUamDKV5EUVz7WsvDHOqE9Z+5ZxqhulYhd
	c0GI/dLL41xThTj/vzxzdUrqW2eVxU+mmC//cmeNKYfh6xvBV1679BRNVHp8pdHz7LYDd2Z9
	K2qXiLxt8tW63Kir5WtL+cf7nVkJwQ8y/ha17FL+vu7CzB08cw1VnCZyZ9Yv3/YtsO52yj8R
	id2XhC5UXLg5o95lXcj3wmv9zf9jU8TPq4iwaX5rdTnh37z3YfWRi33Gxzb1BD9tXboyN9Jy
	4f3Deh9Nz+4yW23l0yzDxZ7wtq9R/2Dw8kni2SsDow6z/3raXbb26MpD5zY5fXDJVqppKlpo
	uLW34Ibpvs96gcfSGVZE26fvNNS/L1Q45WqyslOuuL+/EktxRqKhFnNRcSIACwnopAsDAAA=
X-CMS-MailID: 20241210075259epcas5p23bbb79cdb18ddbfad337d764d4fe75da
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_7161d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241210075259epcas5p23bbb79cdb18ddbfad337d764d4fe75da
References: <20241206221801.790690-1-kbusch@meta.com>
	<20241206221801.790690-6-kbusch@meta.com>
	<CGME20241210075259epcas5p23bbb79cdb18ddbfad337d764d4fe75da@epcas5p2.samsung.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_7161d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/12/24 02:17PM, Keith Busch wrote:
>From: Christoph Hellwig <hch@lst.de>
>
>Export the granularity that write streams should be discarded with,
>as it is essential for making good use of them.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_7161d_
Content-Type: text/plain; charset="utf-8"


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_7161d_--


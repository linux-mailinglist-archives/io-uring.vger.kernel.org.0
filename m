Return-Path: <io-uring+bounces-204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3F28019E4
	for <lists+io-uring@lfdr.de>; Sat,  2 Dec 2023 03:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 307FD1F21161
	for <lists+io-uring@lfdr.de>; Sat,  2 Dec 2023 02:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DE846BB;
	Sat,  2 Dec 2023 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KYGrijg8"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E09F9
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 18:04:21 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231202020418epoutp01463aa6fc32500d8b7ed1fc4a3fbc90c7~c4XZ9ANpT2124021240epoutp01Q
	for <io-uring@vger.kernel.org>; Sat,  2 Dec 2023 02:04:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231202020418epoutp01463aa6fc32500d8b7ed1fc4a3fbc90c7~c4XZ9ANpT2124021240epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1701482658;
	bh=P5TDp1eFwhjr7q0Iypgf0mBYQviKb+chbTzPZKkIGrU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KYGrijg80ScXHYMnKpQp95OeZ0CfflvUvlAIvj1aT/v3HpwDvMEZxajRS2Dpsiq+z
	 6LpVxV3j5bCrWAX7Pp978hgWfvgPmNpj0XckV4N2AlDbReNizaT235jKIbq4T9SIrJ
	 lfrhCDjH+SX1ewwWdGrTim96xMVeZqG7U+i4/UCc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231202020417epcas5p3839d57574bf5dbd6c357b4a457d438c7~c4XY-PQVf1450414504epcas5p3m;
	Sat,  2 Dec 2023 02:04:17 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4ShtXH3hWDz4x9Pt; Sat,  2 Dec
	2023 02:04:15 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7A.9A.09634.F909A656; Sat,  2 Dec 2023 11:04:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20231202020415epcas5p1b81b1df4c3a05ce89c7371d538d6b4c3~c4XXH8RK60211902119epcas5p1T;
	Sat,  2 Dec 2023 02:04:15 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231202020415epsmtrp105b1d3663c3c07c55a9383c2b00d58f5~c4XXHOxRW1292012920epsmtrp1Y;
	Sat,  2 Dec 2023 02:04:15 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-55-656a909f3977
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.74.08817.F909A656; Sat,  2 Dec 2023 11:04:15 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231202020413epsmtip12cb9e212a10606e27250f6a34c403060~c4XVcgn7f1341613416epsmtip1F;
	Sat,  2 Dec 2023 02:04:13 +0000 (GMT)
Message-ID: <2fe7b3e3-3481-3a67-88f8-13e47ceba545@samsung.com>
Date: Sat, 2 Dec 2023 07:34:12 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv5 0/4] block integrity: directly map user space
 addresses
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org, hch@lst.de,
	martin.petersen@oracle.com, ming.lei@redhat.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ac5e99c6-7297-4c56-8f3c-98755c58092b@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmlu78CVmpBl/bZSxW3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfk8Whyc1MDpwel8+Wemxa1cnmsXlJvcfu
	mw1sHucuVnh8fHqLxeP9vqtsHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkp
	MCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzli49D9bQQtrxYIjS1gbGP8ydzFyckgImEjMWHKE
	pYuRi0NIYDejxIZnR5kgnE+MEnfvXIVyvjFKdE5eyQjT8mzudRYQW0hgL6PExsVSEEVvGSUe
	7fnGCpLgFbCT2NTzlQnEZhFQkeg9dZUNIi4ocXLmE7BmUYEkiV9X54ANFRbwl7j+9AKYzSwg
	LnHryXywXhEBR4mHf9rB7mMW2Mko8WPnRaBBHBxsApoSFyaXgtRwCthKPH7WwwrRKy+x/e0c
	ZpB6CYGVHBJP34BczQHkuEjcn6YG8YCwxKvjW9ghbCmJl/1tUHayxKWZ55gg7BKJx3sOQtn2
	Eq2n+plBxjADrV2/Sx9iFZ9E7+8nTBDTeSU62oQgqhUl7k16ygphi0s8nLEEyvaQuPDvOzMk
	qDYwSUzdsZ9xAqPCLKRQmYXk+1lIvpmFsHkBI8sqRsnUguLc9NRi0wLDvNRyeHwn5+duYgSn
	XC3PHYx3H3zQO8TIxMF4iFGCg1lJhPf60/RUId6UxMqq1KL8+KLSnNTiQ4ymwOiZyCwlmpwP
	TPp5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwTT/+7ye3aIlD
	tdtN6zL9P88cmq5yGV6oWXjQpzhzqu1Ejm0Jp97mKVSxcTz5eKOa+xxT+cFdLJxlzLvebKoT
	2MFY/i4ok984aelCvufN1ac04g/f3RCTt9Fg+mfBbzkbby2fGf5uTV2rjlD9QnMDtk9CbNN+
	eM5jrRJ8s4O95etXIdkpU1zeCB09djDwvOkJloof6f/SOZZ5L7gasNei5YiU3+mF52axTHPZ
	62D7/uj+i6f9j5SK/eu7s+714RCDsp8h1lr/BGbVHTV++jyT83hx4NQFvzdckZqY+mX/TJ5H
	y9NPKMxZaVQtvnty19Ijt+vTr1UWXfkcc4/p7+/wb4U/NZe87XeuXu843U2ct0yJpTgj0VCL
	uag4EQDxLJ7lQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJTnf+hKxUgyUtbBar7/azWaxcfZTJ
	4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyeLQ5GYmB06Py2dLPTat6mTz2Lyk3mP3
	zQY2j3MXKzw+Pr3F4vF+31U2j8+b5AI4orhsUlJzMstSi/TtErgyFi79z1bQwlqx4MgS1gbG
	v8xdjJwcEgImEs/mXmfpYuTiEBLYzShxp2U5E0RCXKL52g92CFtYYuW/5+wQRa8ZJebNvMQC
	kuAVsJPY1PMVrIFFQEWi99RVNoi4oMTJmU/AakQFkiT23G8EquHgEBbwlTixNREkzAw0/9aT
	+WCtIgKOEg//tIMdwSywk1Gio/s/G8SyDUwSHUv2M4M0swloSlyYXArSwClgK/H4WQ8rxCAz
	ia6tXYwQtrzE9rdzmCcwCs1CcsYsJPtmIWmZhaRlASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi
	0rx0veT83E2M4AjT0trBuGfVB71DjEwcjIcYJTiYlUR4rz9NTxXiTUmsrEotyo8vKs1JLT7E
	KM3BoiTO++11b4qQQHpiSWp2ampBahFMlomDU6qB6Vy9kovIj/cm6uaCF0Tmn42K91a/+v/C
	XNGXzyr74o5JOr96tkGp9+Oi3/aLNwQe3MX7YcJOubYHwqcedn05+ELJ5377VPXfIceuC4Ub
	W8b4fSh446mvu8KEa7/TNFardi+FWXXFLT621sxzlz7e5PZ1zeYdq5xnP/nRNPH0Xten3ae6
	BOoqu6OcgkKm292q/ql9Xk33eFr1msN+Gw4lqi06pur7XTvLW3PeWd9Nb4ujxQ68yYisT1y0
	50jBpj4Rr1nsay7s5jL1kq7zrdKfvUtz6YqGxx8+u9ywv16exDZho3hgrupn/66ijbYbHstX
	qLiIxa+cdW+NjDFLjRxPak70nfpFFj/PsjOL/2R0VmIpzkg01GIuKk4EAJ+ssKMfAwAA
X-CMS-MailID: 20231202020415epcas5p1b81b1df4c3a05ce89c7371d538d6b4c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c
References: <CGME20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c@epcas5p3.samsung.com>
	<20231130215309.2923568-1-kbusch@meta.com>
	<e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>
	<ZWopLQWBIUGBad3z@kbusch-mbp> <ZWpjBCF4KueqKlPN@kbusch-mbp>
	<ac5e99c6-7297-4c56-8f3c-98755c58092b@kernel.dk>

On 12/2/2023 7:01 AM, Jens Axboe wrote:
>> Jens already applied the latest series for the next merge. We can append
>> this or fold atop, or back it out and we can rework it for another
>> version. No rush; for your patch:
> I folded this into the original to avoid the breakage, even if it wasn't
> a huge concern for this particular issue. But it's close enough to
> merging, figured we may as well do that rather than have a fixup patch.
> 
> Please check the end result, both for-next and for-6.8/block are updated
> now.

Looks good to me.
May not matter now, so a symbolic
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>



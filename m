Return-Path: <io-uring+bounces-193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAE98008BB
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 11:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A9E6B212DC
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 10:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6B71F934;
	Fri,  1 Dec 2023 10:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QQgcLILF"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4513F10F1
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 02:43:55 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231201104352epoutp04df28081956ecf555de52846e043df8f8~crzwjC82G2508225082epoutp048
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 10:43:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231201104352epoutp04df28081956ecf555de52846e043df8f8~crzwjC82G2508225082epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1701427432;
	bh=egIVlxYXEj5QnAKhPNSwlLp6xcM1kV8clB570m+Tw8g=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QQgcLILFjMpQ1A/XSI1WBXDIw5ATsrgmoSM0DS6AKQ54o6SycIY8nSOXDVI6+u9O7
	 kQd1EZoISOC/AaaPBFB9xF3xAGKurLpYOuj0UOqF5XF3kytWsOaJv9tJ3zIoOzxRJv
	 Dt6dXflTUgLLniHt47SwswgPu+nADBL2/gQRE0wk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231201104351epcas5p114a813d9e6702b1162567bb4320c5e0a~crzwDLIXQ2725827258epcas5p17;
	Fri,  1 Dec 2023 10:43:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4ShV6D1WNVz4x9Px; Fri,  1 Dec
	2023 10:43:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EE.46.09634.4E8B9656; Fri,  1 Dec 2023 19:43:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231201104347epcas5p440b836f5c8c55ea7a21b51a14e27064a~crzsljt4e1349813498epcas5p4n;
	Fri,  1 Dec 2023 10:43:47 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231201104347epsmtrp12963b5d4f454e9b4bf8e9f0f862bbc04~crzsk7RPT1441014410epsmtrp1P;
	Fri,  1 Dec 2023 10:43:47 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-68-6569b8e4d305
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	72.28.18939.3E8B9656; Fri,  1 Dec 2023 19:43:47 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231201104346epsmtip2e2197d5ca067bf0872757e9181cd068d~crzrTU1ee0888808888epsmtip2W;
	Fri,  1 Dec 2023 10:43:46 +0000 (GMT)
Message-ID: <e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>
Date: Fri, 1 Dec 2023 16:13:45 +0530
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
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	ming.lei@redhat.com, Keith Busch <kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20231130215309.2923568-1-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmlu6THZmpBm9aOC1W3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfk8Whyc1MDpwel8+Wemxa1cnmsXlJvcfu
	mw1sHucuVnh8fHqLxeP9vqtsHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkp
	MCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzmh6eoOl4Bd3xfdHd9kbGG9zdDFyckgImEi8fdDO
	2sXIxSEksJtR4urnw8wQzidGiUnndzKCVIE5x9awwXRcuniPDaJoJ6PE/80zoDreMkp0nZ/M
	DlLFK2AnsenqKzCbRUBFYuHrg1BxQYmTM5+wgNiiAkkSv67OAdsgLOAvcf3pBTCbWUBc4taT
	+UwgtohAlUTftJ9sEPFiifsdu4Fu5eBgE9CUuDC5FCTMKWAu8eLZOnaIEnmJ7W/ngN0jIbCU
	Q2LR5PeMIPUSAi4SN3ZpQDwgLPHq+BZ2CFtK4mV/G5SdLHFp5jkmCLtE4vGeg1C2vUTrqX5m
	kDHMQGvX79KHWMUn0fv7CRPEdF6JjjYhiGpFiXuTnrJC2OISD2csgbI9JC78+w4NqS5GidmP
	u9knMCrMQgqUWUien4Xkm1kImxcwsqxilEwtKM5NTy02LTDMSy2HR3dyfu4mRnDC1fLcwXj3
	wQe9Q4xMHIyHGCU4mJVEeK8/TU8V4k1JrKxKLcqPLyrNSS0+xGgKjJ2JzFKiyfnAlJ9XEm9o
	YmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAPTbsvFX66df/z7A8dOG0+B
	pKJ7LZZ/595s27h94S2ja5/aS4QVt3xZd4D3vv8enq0JM6LLel/re0RulVh0zPzAURsLxoNB
	PnkZTIwlMk+ObvN2efvYLmZCWxf3X3mtTwyLlaJqC47O6crhZVVs++bK85QvVKqMa8V3hZsT
	W8QWWdUzbRL/ILfq9EPD7U2SyT919dZ+a1HdWRT9wPq9sImUt7ZYwgPhLxMezExrW3hPOL1n
	xappL1r/HVvydWqPLOOcsi67yEu/znd/nKhwcYeATOb82yVswf/2yVfkmL8ze7I8Qer7wtd7
	FXzttN4WTLjZ6xfJ8bDmopDnqzOqacvWbd788lFLFW+giLti1dLjSizFGYmGWsxFxYkAgWV7
	CEEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXvfxjsxUg9nndSxW3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfk8Whyc1MDpwel8+Wemxa1cnmsXlJvcfu
	mw1sHucuVnh8fHqLxeP9vqtsHp83yQVwRHHZpKTmZJalFunbJXBlND29wVLwi7vi+6O77A2M
	tzm6GDk5JARMJC5dvMfWxcjFISSwnVFi54u1rBAJcYnmaz/YIWxhiZX/nrNDFL1mlJhweCUz
	SIJXwE5i09VXYEUsAioSC18fZIeIC0qcnPmEBcQWFUiS2HO/kamLkYNDWMBX4sTWRJAwM9D8
	W0/mM4HYIgJVEvt/nAUrYRYolri52BJiVRejxNZvl1lA4mwCmhIXJpeClHMKmEu8eLaOHWKM
	mUTX1i5GCFteYvvbOcwTGIVmITliFpJts5C0zELSsoCRZRWjaGpBcW56bnKBoV5xYm5xaV66
	XnJ+7iZGcFRpBe1gXLb+r94hRiYOxkOMEhzMSiK815+mpwrxpiRWVqUW5ccXleakFh9ilOZg
	URLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUwRYlMr9vyXkPk4LcFF3c0haa+zF6fcXZiXsY+
	jQ1qmssa5B4aC81zFLwtWPlwZobCVGZtpe25K7tubjvRW9j1Z9+0lsDvC+5+P6ijqCbCqv9i
	/4m+7eVtwmdSDp5pYQ+1+PFLiL+JJcg5b933rVHbop7XRQpt1fh99a97+xeugFmzG/fZrZCJ
	/cn3a3VR6WoHWc3P8uUPAy3OFJ1WMW3Jf/NmA3vxGwW9hcU/a/ZyvPqj03W/uyDN/5T87KDz
	Rk+MDz24avVbM+fwim1i2nHV678KbayfNzcwyGfxNc8y4UXLz5R//P53laxg5H3VZbPm72uM
	P7rcRoXbVKb9xlnRa+/vsbPNe5fx58AZrQ1XVZVYijMSDbWYi4oTATvayTkZAwAA
X-CMS-MailID: 20231201104347epcas5p440b836f5c8c55ea7a21b51a14e27064a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c
References: <CGME20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c@epcas5p3.samsung.com>
	<20231130215309.2923568-1-kbusch@meta.com>

On 12/1/2023 3:23 AM, Keith Busch wrote:
> From: Keith Busch<kbusch@kernel.org>

This causes a regression (existed in previous version too).
System freeze on issuing single read/write io that used to work fine 
earlier:
fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -cmd_type=nvme 
-bs=4096 -numjobs=1 -size=4096 -filename=/dev/ng0n1 -md_per_io_size=8 
-name=pt

This is because we pin one bvec during submission, but unpin 4 on 
completion. bio_integrity_unpin_bvec() uses bip->bip_max_vcnt, which is 
set to 4 (equal to BIO_INLINE_VECS) in this case.

To use bip_max_vcnt the way this series uses, we need below patch/fix:

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 674a2c80454b..feef615e2c9c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -69,15 +69,15 @@ struct bio_integrity_payload 
*bio_integrity_alloc(struct bio *bio,

         memset(bip, 0, sizeof(*bip));

+       /* always report as many vecs as asked explicitly, not inline 
vecs */
+       bip->bip_max_vcnt = nr_vecs;
         if (nr_vecs > inline_vecs) {
-               bip->bip_max_vcnt = nr_vecs;
                 bip->bip_vec = bvec_alloc(&bs->bvec_integrity_pool,
                                           &bip->bip_max_vcnt, gfp_mask);
                 if (!bip->bip_vec)
                         goto err;
         } else {
                 bip->bip_vec = bip->bip_inline_vecs;
-               bip->bip_max_vcnt = inline_vecs;
         }

         bip->bip_bio = bio;


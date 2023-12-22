Return-Path: <io-uring+bounces-351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A52EE81C6C7
	for <lists+io-uring@lfdr.de>; Fri, 22 Dec 2023 09:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C6DB28585E
	for <lists+io-uring@lfdr.de>; Fri, 22 Dec 2023 08:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766C5101FF;
	Fri, 22 Dec 2023 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lu4DGMyn"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B45101E6
	for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 08:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231222084345epoutp01ef2a6351a06a2c347c6784d87fd7f6a5~jGt4aM84U0036600366epoutp017
	for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 08:43:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231222084345epoutp01ef2a6351a06a2c347c6784d87fd7f6a5~jGt4aM84U0036600366epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1703234625;
	bh=QLHE1NWjOSqv7IcomIQ0/EwcPB2puIgo8yJ3Dddp2Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu4DGMynHAQ9GSBxyvA+6cOspkaJAtQ9NvAdgXWrfTAUW1mJD1JN6phR051AQfA6Y
	 eVPMk14AncvjHy5f9ibfk8ekrlLfAajOwjQapq/lTJYdeEwESpCcQIUwbgrWjxtUjA
	 5vbUexHyOi0TQ/meTVfnkOdL7qqKD96oSLQWmMBg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231222084344epcas5p322b603419f8014a2912fd0f2a1e499d6~jGt30oR3Z3175031750epcas5p3h;
	Fri, 22 Dec 2023 08:43:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4SxLRz1srHz4x9QC; Fri, 22 Dec
	2023 08:43:43 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7C.83.10009.F3C45856; Fri, 22 Dec 2023 17:43:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20231222084334epcas5p10badfe3c82a6b8355c03f8d0aa192892~jGtuMQb7R0112901129epcas5p1j;
	Fri, 22 Dec 2023 08:43:34 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231222084334epsmtrp2cd814b82c44ad3152f22017b180248b5~jGtuLjEd53200432004epsmtrp2-;
	Fri, 22 Dec 2023 08:43:34 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-7d-65854c3fead8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	FB.26.18939.63C45856; Fri, 22 Dec 2023 17:43:34 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231222084332epsmtip11a985a5fde17393198ddc06dc8d1b5e1~jGtss24GQ2187121871epsmtip1N;
	Fri, 22 Dec 2023 08:43:32 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: Re: [PATCH v5] io_uring: Statistics of the true utilization of
 sq threads.
Date: Fri, 22 Dec 2023 16:35:30 +0800
Message-Id: <20231222083530.11051-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <c3995796-8aab-45e1-ad59-d970373a4fab@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmpq69T2uqwexzHBZzVm1jtFh9t5/N
	4l3rORaLo//fsln86r7LaLH1y1dWi8u75rBZPNvLafHl8Hd2i7MTPrBaTN2yg8mio+UyowOP
	x85Zd9k9Lp8t9ejbsorR4/MmuQCWqGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFJgV6
	xYm5xaV56Xp5qSVWhgYGRqZAhQnZGa/+rGYveMJd8anjLXsD4yrOLkZODgkBE4m+wx+ZQWwh
	gd2MEpN7i7sYuYDsT4wSP2fcZodz1i2axQrTsfbmXHaIjp2MErvXKUMUvWSUuLjsP9goNgFt
	ievrusAaRASEJfZ3tLKAFDEL/GWUmPDyN1iRsECkxO6eQ2CTWARUJW73/wSL8wrYSDQe/wi1
	TV5i/8GzYHFOAVuJd0ufskPUCEqcnPmEBcRmBqpp3jqbGWSBhMBPdomdl28xdTFyADkuEn+m
	80LMEZZ4dXwLO4QtJfH53V42CLtY4kjPd1aI3gZGiem3r0IVWUv8u7KHBWQOs4CmxPpd+hBh
	WYmpp9YxQezlk+j9/YQJIs4rsWMejK0qsfrSQxYIW1ridcNvqLiHxNevF6BBOoFRYtXqv8wT
	GBVmIflnFpJ/ZiGsXsDIvIpRMrWgODc9tdi0wCgvtRwey8n5uZsYwYlVy2sH48MHH/QOMTJx
	MB5ilOBgVhLhzddpSRXiTUmsrEotyo8vKs1JLT7EaAoM8InMUqLJ+cDUnlcSb2hiaWBiZmZm
	YmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5Mrc+uK2tjj87252KftDtCbKWmsdP7J
	WT6n47rc7Q1ZYuKLUh4ZpLkcuZl7zbBrf+PJkEq5qzl/K18nisgLWEzeleFwefuXt86qz1ck
	xU64dE2rUbtJqOvKBR8f64WL32fni3FUps9KfN4Zqp49n3e+gtyDyrJ/SxMcHXdkTnNmVdRY
	IP+gMnjPnAMOn/xYGJO4+r+6NlopN294sDsgR/+ixd2Niy6EfkoJeHNtFvv3+MnMc38ssVpd
	nbZ3okHcxWkGaw95PffdtulUReOW37fy3ux7UFnnu01GJEVMPWPHj/Amv7thPfYNryO3MJuE
	C7wX9WG7P7Nv+50pi3lEWqMFFV5Ge3gy3PacrhLzUYmlOCPRUIu5qDgRAFyss8Y1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSnK6ZT2uqwfV9fBZzVm1jtFh9t5/N
	4l3rORaLo//fsln86r7LaLH1y1dWi8u75rBZPNvLafHl8Hd2i7MTPrBaTN2yg8mio+UyowOP
	x85Zd9k9Lp8t9ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6MV39Wsxc84a741PGWvYFxFWcX
	IyeHhICJxNqbc9m7GLk4hAS2M0rMaDnB1MXIAZSQlvjzpxyiRlhi5b/nUDXPGSUmzPzFDJJg
	E9CWuL6uixXEFgEq2t/RygJiMwt0Mkm8/qwHYgsLhEusm3eVDcRmEVCVuN3/E6yXV8BGovH4
	R1aIBfIS+w+eBYtzCthKvFv6lB3EFgKqmfRhPitEvaDEyZlPoObLSzRvnc08gVFgFpLULCSp
	BYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCA14raAfjsvV/9Q4xMnEwHmKU4GBWEuHN
	12lJFeJNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamDidMy4
	3Lm2YmP81F3Ou8LeXkphr0ms9WA3v/n95t2c5Y4yOY6Tru8SzJ/zq9Xv/U0mvu8KzteWTlY4
	/IYv0vLk0tp5xSElQezTqn5ct2Bf/aVobrDAU2G19ReC/ad373fW+72nsL8mkEPmn7iWYzHf
	3ngl+WMTOAX8rsxZvZW1qLL8eTQDp7i2X+5Mm41fuPOyUm9vi3ZlnBW1tE/3xsf6p1528S0R
	Ypb/Tz1cd5Xd/rG1Qc7biB6NPmX+5YuajRpPuK0K7/+6wrG4758Zu/arvBf/fLsjrv08Y1Hp
	rfKEUcngVUvF362Tq9ZZbedYdTf0x6QoxVnxPI5HeMLuyM+/7PJZ3q8hY0VAValpshJLcUai
	oRZzUXEiAHE8fRfnAgAA
X-CMS-MailID: 20231222084334epcas5p10badfe3c82a6b8355c03f8d0aa192892
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231222084334epcas5p10badfe3c82a6b8355c03f8d0aa192892
References: <c3995796-8aab-45e1-ad59-d970373a4fab@kernel.dk>
	<CGME20231222084334epcas5p10badfe3c82a6b8355c03f8d0aa192892@epcas5p1.samsung.com>

On 12/18/23 15:53, Jens Axboe wrote:
> I think I'm convinced that the effectiveness of the chosen SQPOLL
> settings being exposed is useful, I'm just not sure fdinfo is the right
> place to do it. Is it going to be a problem that these are just
> perpetual stats, with no way to reset them? This means there's no way to
> monitor it for a period of time and get effectiveness for something
> specific, it'll always just count from when the ring was created.
> 
> We could of course have the act of reading the stat also reset it, but
> maybe that'd be a bit odd?
> 
> Alternatively, it could be exported differently, eg as a register opcode
> perhaps.
> 
> Open to suggestions...

I thought carefully about your proposed reset stat, and I think it can be 
achieved by outputting "work_time" and "total_time".
eg:
Output at time t1:
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
SqWorkTime: t1_work
SqTotalTime: t1_total

Output at time t2:
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
SqWorkTime: t2_work
SqTotalTime: t2_total

Then we can manually calculate the utilization rate from t1 to t2:
(t2_work - t1_work) / (t2_total - t1_total)

Not sure what you think, but if you think it doesn't work, I'll look into 
other good ways to add the ability to reset.

In addition, on register opcode - generally it is used for resource like
buffers, handles etc.. I am not sure how that can help here. If you have
something in mind, could you please elaborate in more detail?


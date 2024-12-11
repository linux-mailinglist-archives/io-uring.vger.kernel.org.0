Return-Path: <io-uring+bounces-5434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A780C9ECA58
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 11:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4A2F188C3E5
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 10:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6F61EC4FF;
	Wed, 11 Dec 2024 10:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="utvq977M"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C51A840C
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733913136; cv=none; b=iYOP8yRA/h75cHdBh4Y5rujKUd77Z3cpzpm3DuxPLaWxJcbfqKWq3/6ZHSBLs703c91qqWmHVZQ/AjMVFMIBl62vqktGoy/CoymXpanx/hHMByRmXg+VSeuDVjMDHWshbcavOr2w1ZBXOaL5K8kZeFOY+CMmUVOPQHD0iaOLeI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733913136; c=relaxed/simple;
	bh=Q0M/EXSX6ZCN0k4bPSo+RIoYM5u40sXoHZ0/51o97Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=OWJscZ7m1sFOcmgoTIwF8eO0KxjywteKWkdSMoiWbNfG547612ysB8SCc1hxRUiDfj1z7t/38vyXKNkTb7Q8NZdN8s0NlVQB1LEFDL5AcSks1OzbuoeSWuM8svU2HmXJ5Poc+F9IChOJpapILEd4FN2xKLdj6i7Li6WKVHvrcr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=utvq977M; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241211103211epoutp025c318aef82424bfce6b2177675bb40c8~QGM6OqDzI0924509245epoutp02W
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 10:32:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241211103211epoutp025c318aef82424bfce6b2177675bb40c8~QGM6OqDzI0924509245epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733913132;
	bh=C54pEWc4i7MkvBJwDO/T7iAa0SAKlIK9ErF/1+Nst2M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=utvq977MhpomYcX724wRP/kGSVVafRMcil+5rlV/wWEY8gS1PD/Ag7XiR4wMvzOMw
	 tGfaK+LdHMt6p+ux8ruawYyhbL4kxpdvolfX5bpxwLkXImfFxoCYyNLs2jRCvzyqUR
	 DWLOCodUCHh9Kkvw3nnwAUEKtSvna26+nF1m9qhY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241211103211epcas5p1b6b5bfec3f9890a2932fe6d041247422~QGM5zArVv0262302623epcas5p1T;
	Wed, 11 Dec 2024 10:32:11 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Y7X3G1cHBz4x9Pq; Wed, 11 Dec
	2024 10:32:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.5A.19933.A2A69576; Wed, 11 Dec 2024 19:32:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241211094357epcas5p377a4e20b47995f31fc4a8bd0cdf9b281~QFiyG9A6T2575625756epcas5p3n;
	Wed, 11 Dec 2024 09:43:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241211094357epsmtrp1b59afc3b205ebae305632feb0bc9635e~QFiyGJ2T_2183921839epsmtrp1Z;
	Wed, 11 Dec 2024 09:43:57 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-25-67596a2a77e8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.91.18729.CDE59576; Wed, 11 Dec 2024 18:43:56 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241211094354epsmtip11e81e3346a472c0d3d707cbacd587911~QFiwGGHWh2936729367epsmtip1p;
	Wed, 11 Dec 2024 09:43:54 +0000 (GMT)
Date: Wed, 11 Dec 2024 15:06:01 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Javier Gonzalez
	<javier.gonz@samsung.com>, Matthew Wilcox <willy@infradead.org>, Keith Busch
	<kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241211093549.n6dvl6c6xp4blccd@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7d06cc60-7640-4431-a1cb-043a959e2ff3@acm.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmpq5WVmS6wcPP7BbTPvxktli5+iiT
	xbvWcywWj+8AxY7+f8tmMenQNUaLM1cXsljsvaVtsWfvSRaL+cueslt0X9/BZrH8+D8mi98/
	5rA58HpcvuLtsXmFlsemVZ1sHpuX1HvsvtnA5nHuYoXHx6e3WDz6tqxi9Pi8SS6AMyrbJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZiWFssScUqBQ
	QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsajn2fZ
	C6aJVfxedYq9gXGRUBcjB4eEgIlE8xu3LkYuDiGB3YwSO5a9Z4JwPjFKbF/ey9jFyAnkfGOU
	eHsgGsQGafh5fzULRNFeRol15xayQzhPGCV+7L3LDlLFIqAqMW3+RVaQFWwC2hKn/3OAhEUE
	NCS+PVgO1swscI1FYu3nJWwgCWEBZ4meuXfBtvECbdhzdxqULShxcuYTFhCbU8BaYlHzArDz
	JAR2cEgsf76KGeIkF4n98y6yQ9jCEq+Ob4GypSRe9rdB2eUSK6esYINobmGUmHV9FiNEwl6i
	9VQ/2CBmgQyJ9auuskDEZSWmnlrHBBHnk+j9/YQJIs4rsWMejK0ssWb9AjYIW1Li2vdGKNtD
	ovVKJzRYPjBLnH60lG0Co9wsJB/NQrIPwraS6PzQxDoLGGLMAtISy/9xQJiaEut36S9gZF3F
	KJlaUJybnlpsWmCUl1oOj+Xk/NxNjOB0rOW1g/Hhgw96hxiZOBgPMUpwMCuJ8N6wj0wX4k1J
	rKxKLcqPLyrNSS0+xGgKjKGJzFKiyfnAjJBXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJ
	anZqakFqEUwfEwenVAPT9Erv45lL6l5fdFTPnRC+WdrS/fnDVV7T4qZkyP5mvigcMUXgWtaN
	3ssJX0Tm/bgm/6oqQm7J1RtHrjkYrL4aOWvjhqpvzpozgzwFNOTOCxxvbje+cOF9/YTjFlnZ
	3nYWXv8Df+a7MtXmSNZXq+TX5x7LZ855Ixb3rDBk50LmyZLP7sRlvGvfuaB714O3r9oEvnlk
	1KxreH+oXu2aalHGvAlzLPIz923lvDGzvNJ7gmXygZmbLbu0ouV4t4r3vViw69bM1aFal3Q1
	19+f+iLyKdNzPZ+u1TKyR0W8p77VOWYx7YhBpHJAsdr8dIHXbrONfwlodWz5uaL3vWpK5DKL
	3W+EvFaoSnzxYPhl571MiaU4I9FQi7moOBEAQphBr1AEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSnO6duMh0g2UnTCymffjJbLFy9VEm
	i3et51gsHt/5zG5x9P9bNotJh64xWpy5upDFYu8tbYs9e0+yWMxf9pTdovv6DjaL5cf/MVn8
	/jGHzYHX4/IVb4/NK7Q8Nq3qZPPYvKTeY/fNBjaPcxcrPD4+vcXi0bdlFaPH501yAZxRXDYp
	qTmZZalF+nYJXBm3ZixlKzghXPHgwnGWBsZ3/F2MnBwSAiYSP++vZuli5OIQEtjNKDFvxSoW
	iISkxLK/R5ghbGGJlf+es4PYQgKPgIpm54HYLAKqEtPmX2TtYuTgYBPQljj9nwMkLCKgIfHt
	wXKwmcwCt1gkXu5fCdYrLOAs0TP3LiOIzQu0eM/daYwQiz8wSxyasosdIiEocXLmE7AjmAXM
	JOZtfsgMsoBZQFpi+T+wBZwC1hKLmhcwTWAUmIWkYxaSjlkIHQsYmVcxSqYWFOem5xYbFhjm
	pZbrFSfmFpfmpesl5+duYgRHkZbmDsbtqz7oHWJk4mA8xCjBwawkwnvDPjJdiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOK/4i94UIYH0xJLU7NTUgtQimCwTB6dUA1P1jpXW5R0PP6dMy9V5UcVQ
	9qXh8cOqvR4xR2cdVe2/USoz/5/b9ftC8582/r1w6oEm28cFU248+9As29hyo0Kk2qrW/5TW
	rWtH3/+a8++6sL7R7vBtZ69PcuWz+xD/a8OcTa8kJURWmWXVvlRfZXavVPZhEpvrN8Ge1Y/0
	ldhNKiPN9k1dM0fuWAX3qW2KM5+/q7j48fG5zr8hfG4Ne1Yx3fjr7ZWtEzXrOM9fqcuWXr8V
	tsT0LBCf8jJ7Sv3Nzq9vH/y8/f/A3RLx9Vu0dBLv/dCqu6CnZey91/icx2n3ZQlS91wPK67+
	p1gbtip0i/VeGZcdwvPZf2R01MqyyG8wtXNfcvrC5OkX/+TeMFu6QImlOCPRUIu5qDgRACGa
	4jQRAwAA
X-CMS-MailID: 20241211094357epcas5p377a4e20b47995f31fc4a8bd0cdf9b281
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_77644_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1
References: <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
	<20241205080342.7gccjmyqydt2hb7z@ubuntu>
	<yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
	<d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
	<yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
	<7d06cc60-7640-4431-a1cb-043a959e2ff3@acm.org>

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_77644_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/12/24 11:41AM, Bart Van Assche wrote:
>On 12/9/24 6:20 PM, Martin K. Petersen wrote:
>>What would be the benefit of submitting these operations concurrently?
>
>I expect that submitting the two copy operations concurrently would 
>result in lower latency for NVMe devices because the REQ_OP_COPY_DST
>operation can be submitted without waiting for the REQ_OP_COPY_SRC
>result.
>
>>As I have explained, it adds substantial complexity and object lifetime
>>issues throughout the stack. To what end?
>
>I think the approach of embedding the ROD token in the bio payload would
>add complexity in the block layer. The token-based copy offload approach
>involves submitting at least the following commands to the SCSI device:
>* POPULATE TOKEN with a list identifier and source data ranges as
>  parameters to send the source data ranges to the device.
>* RECEIVE ROD TOKEN INFORMATION with a list identifier as parameter to
>  receive the ROD token.
>* WRITE USING TOKEN with the ROD token and the destination ranges as
>  parameters to tell the device to start the copy operation.
>
>If the block layer would have to manage the ROD token, how would the ROD
>token be provided to the block layer? Bidirectional commands have been
>removed from the Linux kernel a while ago so the REQ_OP_COPY_IN
>parameter data would have to be used to pass parameters to the SCSI
>driver and also to pass the ROD token back to the block layer. A
>possible approach is to let the SCSI core allocate memory for the ROD
>token with kmalloc and to pass that pointer back to the block layer
>by writing that pointer into the REQ_OP_COPY_IN parameter data. While
>this can be implemented, I'm not sure that we should integrate support
>in the block layer for managing ROD tokens since ROD tokens are a
>concept that is specific to the SCSI protocol.
>
Block layer can allocate a buffer and send this as part of copy
operation.
Driver can store token/custom info inside the buffer sent along with
REQ_OP_COPY_SRC and expect that block layer sends back this info/buffer
again in REQ_OP_COPY_DST ?
This will reduce the effort for block layer to manage the lifetime issues.
Is there any reason, why we cant store the info inside this buffer in
driver ?

This scheme will require sequential submission of SRC and DST
bio's. This might increase in latency, but allows to have simpler design.
Main use case for copy is GC, which is mostly a background operation.

--
Nitesh Shetty


------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_77644_
Content-Type: text/plain; charset="utf-8"


------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_77644_--


Return-Path: <io-uring+bounces-169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE37C7FDAFD
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 16:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A51C1C209A3
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 15:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D05374EE;
	Wed, 29 Nov 2023 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CIMD3gZq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A03C9
	for <io-uring@vger.kernel.org>; Wed, 29 Nov 2023 07:18:50 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231129151847epoutp04117f99715f523ddbac1de7725514dd79~cIROt3J4t1941819418epoutp044
	for <io-uring@vger.kernel.org>; Wed, 29 Nov 2023 15:18:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231129151847epoutp04117f99715f523ddbac1de7725514dd79~cIROt3J4t1941819418epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1701271127;
	bh=4WvZQlJKQWwe5V6ifxQTDiKTdRNLQS9jsVWt6sNngvM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=CIMD3gZqiPEXa4rMP/OeY9Lgp5ecai4A3+vH44spvdoTVcACqKGXxJrTlySbxIFSx
	 dTC1QQZYIrBr2kw1L+BWKIOvTrN6ApHAdd4au0o9ZXIcobKKspaNfpr0fZL4YBI3bH
	 BZKuj1c83/VCfa/4iQNsq2H4JkYqF1/wZKKLBCw8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231129151846epcas5p1553aa66fe005e2c707b0665a2dcedacf~cIRNrXxNR0861108611epcas5p1q;
	Wed, 29 Nov 2023 15:18:46 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4SgNJN5BDdz4x9Pt; Wed, 29 Nov
	2023 15:18:44 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.3D.09672.45657656; Thu, 30 Nov 2023 00:18:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231129151844epcas5p4695d8ac3b14714aa793b527259299144~cIRLXurN22405624056epcas5p4h;
	Wed, 29 Nov 2023 15:18:44 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231129151844epsmtrp1f71926f102ae5550208ce53dc9e0bf79~cIRLXDOyG0031600316epsmtrp1S;
	Wed, 29 Nov 2023 15:18:44 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-f8-6567565437d5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	65.89.07368.35657656; Thu, 30 Nov 2023 00:18:43 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231129151842epsmtip1126d0a3df825a035a24bb43f22f1e340~cIRJ-p-DB0302803028epsmtip1f;
	Wed, 29 Nov 2023 15:18:42 +0000 (GMT)
Message-ID: <249c59bb-794b-f8ec-c4e7-17308ecf7f2a@samsung.com>
Date: Wed, 29 Nov 2023 20:48:41 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv4 1/4] block: bio-integrity: directly map user buffers
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	ming.lei@redhat.com, Keith Busch <kbusch@kernel.org>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20231128222752.1767344-2-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmpm5IWHqqwbM+DYvVd/vZLFauPspk
	8a71HIvFpEPXGC3OXF3IYrH3lrbF/GVP2S2WH//HZHFocjOTA6fH5bOlHptWdbJ5bF5S77H7
	ZgObx7mLFR4fn95i8Xi/7yqbx+dNcgEcUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUC3KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIK
	TAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM26t28tcsI25onPHc6YGxntMXYwcHBICJhI7dtd2
	MXJxCAnsZpQ4NWstE4TziVFi+9L/LBDON0aJHx3vGbsYOcE6PnT9ZYVI7AVKtO+DannLKLHg
	0m2wubwCdhK7L7iDNLAIqEr0nfrADGLzCghKnJz5hAXEFhVIkvh1dQ7YUGEBL4nnWxaBxZkF
	xCVuPZnPBGKLCFRJ9E37yQYRL5a437GbFWQ8m4CmxIXJpSAmp4C5xNfWYogKeYntb+cwg1wj
	IbCSQ+L65TVQN7tIPPh9jhXCFpZ4dXwLO4QtJfGyvw3KTpa4NPMcE4RdIvF4z0Eo216i9VQ/
	M8guZqC163fpQ+zik+j9/QQaiLwSHW1CENWKEvcmPYXaJC7xcMYSVogSD4krW+wg4bSdUeLB
	hLNMExgVZiGFySwkv89C8s0shMULGFlWMUqmFhTnpqcWmxYY56WWwyM7OT93EyM42Wp572B8
	9OCD3iFGJg7GQ4wSHMxKIrx6H5NThXhTEiurUovy44tKc1KLDzGaAiNnIrOUaHI+MN3nlcQb
	mlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXA5J/yZoHb/ISG8r7c33fy
	LaMXXPHibbVTnFxU3J9o+fyOWI7WgS/fdsrcYnztFHFW8F3wAQfXQ877PkadrdbxZrz4NOHV
	sjp/7bBr8+pfXWer+2s9xdDFUfHLo2XOnxPmTDhzKULQs+ioa3VocurxZ30hLdvYmDjspDYr
	r/hXtKCDxSRTa1erWoyc65mUd85cZ5t7T07aLdCcHudpq7f838/XE+zuf+8Xu3PEwTFEsInX
	UvbKTEf29KeWYvv9sr9PPN6ziPt2a0bN7Q8/uoVSA2eJuPfrHGy/omYg8UpTc2Jd47vjX6W3
	VBu9+8K5NveHUaKnx99v7/PYON2DQpiypsYefGMsNfvpo67yX4ZKLMUZiYZazEXFiQBRkQ69
	PwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJTjc4LD3VYM0yM4vVd/vZLFauPspk
	8a71HIvFpEPXGC3OXF3IYrH3lrbF/GVP2S2WH//HZHFocjOTA6fH5bOlHptWdbJ5bF5S77H7
	ZgObx7mLFR4fn95i8Xi/7yqbx+dNcgEcUVw2Kak5mWWpRfp2CVwZt9btZS7YxlzRueM5UwPj
	PaYuRk4OCQETiQ9df1m7GLk4hAR2M0psXPaIDSIhLtF87Qc7hC0ssfLfczBbSOA1o8SS/aVd
	jBwcvAJ2ErsvuIOEWQRUJfpOfWAGsXkFBCVOznzCAmKLCiRJ7LnfCLZLWMBL4vmWRWBxZqDx
	t57MB4uLCFRJ7P9xlglkJLNAscTNxZYQ52xnlHjz5gUzSJxNQFPiwmSwrZwC5hJfW4shpphJ
	dG3tYoSw5SW2v53DPIFRaBaSI2YhWTYLScssJC0LGFlWMUqmFhTnpucmGxYY5qWW6xUn5haX
	5qXrJefnbmIER5aWxg7Ge/P/6R1iZOJgPMQowcGsJMKr9zE5VYg3JbGyKrUoP76oNCe1+BCj
	NAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5OqQYm5Xh1mZllqy8+KLJo0z3APdnwXdCUHcIz
	/L+Ez4hxkelYxKVi5TnxjueBOR2N4n0+f1mmyvi/PPWO5fG3//622wLc0mJ00ytrHRdNSM1W
	msIz32lH+gYmE/VT2uU5iVdXi79bLRt/ecHOTy3TlMovzFnUZNchKPK39Z8qd8rKib3MiyMe
	N88qC8tdqMXIGlNnurT1CNPznY+jl70Q+sj3493BvcfPfv7o//nPn5fVF4Qffuz/pFYYcjI/
	8MCetSFPl7z5ern0a20p2wKl8xXH5CS4HkaVpm3pnPLhlF7oJudZDb/2WPeXTfDkCpb++1Az
	SXrNxKuvQwwDjb4dmLHu/Yow571a1d1P38eUe7kFKLEUZyQaajEXFScCAKSpYlgbAwAA
X-CMS-MailID: 20231129151844epcas5p4695d8ac3b14714aa793b527259299144
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231128222827epcas5p19beb5067fa55290aef73f96dee91c4ec
References: <20231128222752.1767344-1-kbusch@meta.com>
	<CGME20231128222827epcas5p19beb5067fa55290aef73f96dee91c4ec@epcas5p1.samsung.com>
	<20231128222752.1767344-2-kbusch@meta.com>

On 11/29/2023 3:57 AM, Keith Busch wrote:
> If the user address can't directly be used for reason, like too many
> segments or address unalignement, fallback to a copy of the user vec
> while keeping the user address pinned for the IO duration so that it
> can safely be copied on completion in any process context.

The pinning requirement is only for read. But code keeps user-memory 
pinned for write too. Is there any reason?


Return-Path: <io-uring+bounces-4463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815E69BD29F
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 17:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFCB3B22E5C
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31BF1D9677;
	Tue,  5 Nov 2024 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="osPp7PHZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2681DD0F8
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824737; cv=none; b=ew+MDxfrsj1qXIF/2RyFcRPX2cG+qSVbfxwn+uklCbOrqvJzlW5Vj6EAQMYAauPPbTWAhx4jxNCuM9AnvXsNMXrlzHYWTsoq8FluXm2JnS9OaW+jW8T1a0+m7Bmqz13qYqqUfWa9d252dmQqFPiJxJixHs/o5RG7VFgr/WgExz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824737; c=relaxed/simple;
	bh=JZoeli1ekR1Ea3em7KTi06yOpUXiX1Nirv66M+wA1iA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Eig5WVZghciuL/EEYZ0tAu4lFaJqDbAjrofNm/m81fqIRM1KsIx4cL9SIiqGSjOO3o6/mb42twrKYdfA917d6esTWBqVOlQCYO/I6Pd+clrOyYS+gwzFBTMk+oG1Hi9Lzx3E8qwchA/DNhk1T/3qqWknc06qkVUHA2oJXX2xz04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=osPp7PHZ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241105163852epoutp02c258a4c390bccba7a3c0d07850ead7b6~FH_yY-heB0354303543epoutp020
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 16:38:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241105163852epoutp02c258a4c390bccba7a3c0d07850ead7b6~FH_yY-heB0354303543epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730824732;
	bh=018tCczGIWlDYFfcL/g7H7zKEzrYeq38C52P6ZKfViY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=osPp7PHZUAtkBm1wiwTZw/gOj2xcLI3y0MN3ZlTpaCHtLrINvymiQRtaO70usE5qo
	 vFbc30FAisaSI5QET7UdnXOTwLNjVBNDKI7hBYzHkuNgCfMEyzMIco5VvCvhV4XElH
	 q1gqAe0DR6D7ZYNHWtJ2gapqBTltpN5qEwalY0ds=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241105163852epcas5p478c4615e2673a5ae8b551bfaa82c5aa7~FH_x7KjzV2725427254epcas5p4c;
	Tue,  5 Nov 2024 16:38:52 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XjYty5FL4z4x9Pp; Tue,  5 Nov
	2024 16:38:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	71.E2.08574.A1A4A276; Wed,  6 Nov 2024 01:38:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241105163849epcas5p485baa527d07ca146440e9076ccb469fa~FH_vvB_mR2725427254epcas5p4Z;
	Tue,  5 Nov 2024 16:38:49 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241105163849epsmtrp232a800c9de2ecb017bee1d36bb0fcc95~FH_vuSlVD0962709627epsmtrp2h;
	Tue,  5 Nov 2024 16:38:49 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-19-672a4a1a7402
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	37.A9.18937.91A4A276; Wed,  6 Nov 2024 01:38:49 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241105163847epsmtip1afd91732e6a51e9aa25417fdf00c3856~FH_tY5x5r2948929489epsmtip1j;
	Tue,  5 Nov 2024 16:38:47 +0000 (GMT)
Message-ID: <51b67939-cbd8-4213-967a-9c6b2ecd5813@samsung.com>
Date: Tue, 5 Nov 2024 22:08:46 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj gupta <anuj1072538@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241105160051.GA7599@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmpq6Ul1a6wemrqhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbJr48YC65JVFyZu5u5gXG7cBcjJ4eEgInEld9v
	mLsYuTiEBHYzSixo/gDlfGKU2Lp5KxOcc/r8fnaYlm3dj9khEjsZJd7/uAvV8pZR4lffA2aQ
	Kl4BO4nTiz4xgdgsAioSzXPbmSDighInZz5hAbFFBeQl7t+aATZVWCBeYvnC42BxEQEliaev
	zjKCDGUWWMYs0fNiE1iCWUBc4taT+UCDODjYBDQlLkwuBQlzCmhLtN58ygpRIi+x/e0csIMk
	BD5wSBz6fAjqbBegTzuhbGGJV8e3QNlSEp/f7WWDsLMlHjx6wAJh10js2NzHCmHbSzT8ucEK
	spcZaO/6XfoQu/gken8/ATtHQoBXoqNNCKJaUeLepKdQneISD2csgbI9JFZuWMoGCauZzBLX
	L95jn8CoMAspWGYh+XIWkndmIWxewMiyilEytaA4Nz012bTAMC+1HB7jyfm5mxjByV3LZQfj
	jfn/9A4xMnEwHmKU4GBWEuGdl6qeLsSbklhZlVqUH19UmpNafIjRFBg/E5mlRJPzgfklryTe
	0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpnm+/V+jZ3Xc2bXeZ/61
	GSlzNfwdqrRntxe/Ofnszv3dSxZdiHc7Ixq5Yt8BmYspws8mhWz92SL2N0wi0v9NkPTdfW8s
	NjVrh2xmmmgb6FnrEVLHfbWxwfG2hkkYd3qWYfw9I/4/ItOmPFH51vZSJUzDfVnQGsOFenJX
	J0ldnv3+DjNz8/y+nQuOzIqp3nE++ujKaVd6NbI8J114P+3e1vOcp4U9zmSJbpRcYX9n4cZN
	KpnB8VvXn5u1ofD/5J65GiduvsjuzbGXtFPe9m8yQ/nGjjZ9/TlWu+233/Xo/Lqo5Ob7bW9b
	rU9czXkqvSb1+gbdu9P4LZWPzspba2Aulbj2yuJHD4tCHvBZOB+/eHqfEktxRqKhFnNRcSIA
	qKLg+ncEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSnK6kl1a6wf7nRhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEr4+TXR4wF1yQqrszdzdzA
	uF24i5GTQ0LARGJb92P2LkYuDiGB7YwSW5uuskAkxCWar/1gh7CFJVb+ew5V9JpR4sejiWBF
	vAJ2EqcXfWICsVkEVCSa57YzQcQFJU7OfAJWIyogL3H/1gywQcIC8RLNE5cwg9giAkoST1+d
	ZQQZyiywjFli6oy7TBAbZjJLvL75lxWkihnojFtP5gMlODjYBDQlLkwuBQlzCmhLtN58ClVi
	JtG1tYsRwpaX2P52DvMERqFZSO6YhWTSLCQts5C0LGBkWcUomlpQnJuem1xgqFecmFtcmpeu
	l5yfu4kRHMFaQTsYl63/q3eIkYmD8RCjBAezkgjvvFT1dCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8yjmdKUIC6YklqdmpqQWpRTBZJg5OqQamKWanM5je2Uwye9bk7qPXcNY6pDEzpuuCEm/K
	3d/XRQS2sJhaGb7sFCgL39q4J+S/x+Ev004uyWlX9E6M5L6/81vj3rJ1W1YKbz2jKiaUMf8g
	32fPrdHyp4wWf1XOSRKIluv9JHHkXfrL2za8DHkaD1pNhQ+KP/68vnoqp9b+1vubTp1+Wf34
	WmhYw/Fvj3xOFeTkdilZfFOpe+x2d855717tHdkT/IWtF89V2Sy5vuH+nl2uTTJFqhXCyy7H
	8Dy+35UTYeqwrL70gNLd470raxYGbuq6viqZadK98EM75y35HBAxMSt35td17AUtp8vSN0Yy
	HpLiKNmtdr/ezu27WrDkrger/dS7rBfE/5qoxFKckWioxVxUnAgAbBP0eE8DAAA=
X-CMS-MailID: 20241105163849epcas5p485baa527d07ca146440e9076ccb469fa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com>
	<20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de>
	<CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
	<20241105135657.GA4775@lst.de>
	<b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com>
	<20241105160051.GA7599@lst.de>

On 11/5/2024 9:30 PM, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 09:21:27PM +0530, Kanchan Joshi wrote:
>> Can add the documentation (if this version is palatable for Jens/Pavel),
>> but this was discussed in previous iteration:
>>
>> 1. Each meta type may have different space requirement in SQE.
>>
>> Only for PI, we need so much space that we can't fit that in first SQE.
>> The SQE128 requirement is only for PI type.
>> Another different meta type may just fit into the first SQE. For that we
>> don't have to mandate SQE128.
> 
> Ok, I'm really confused now.  The way I understood Anuj was that this
> is NOT about block level metadata, but about other uses of the big SQE.
> 
> Which version is right?  Or did I just completely misunderstand Anuj?

We both mean the same. Currently read/write don't [need to] use big SQE 
as all the information is there in the first SQE.
Down the line there may be users fighting for space in SQE. The flag 
(meta_type) may help a bit when that happens.

>> 2. If two meta types are known not to co-exist, they can be kept in the
>> same place within SQE. Since each meta-type is a flag, we can check what
>> combinations are valid within io_uring and throw the error in case of
>> incompatibility.
> 
> And this sounds like what you refer to is not actually block metadata
> as in this patchset or nvme, (or weirdly enough integrity in the block
> layer code).

Right, not about block metadata/pi. But some extra information 
(different in size/semantics etc.) that user wants to pass into SQE 
along with read/write.

>> 3. Previous version was relying on SQE128 flag. If user set the ring
>> that way, it is assumed that PI information was sent.
>> This is more explicitly conveyed now - if user passed META_TYPE_PI flag,
>> it has sent the PI. This comment in the code:
>>
>> +       /* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
>> +       union {
>>
>> If this flag is not passed, parsing of second SQE is skipped, which is
>> the current behavior as now also one can send regular (non pi)
>> read/write on SQE128 ring.
> 
> And while I don't understand how this threads in with the previous
> statements, this makes sense.  If you only want to send a pointer (+len)
> to metadata you can use the normal 64-byte SQE.  If you want to send
> a PI tuple you need SEQ128.  Is that what the various above statements
> try to express? 

Not exactly. You are talking about pi-type 0 (which only requires meta 
buffer/len) versus !0 pi-type. We thought about it, but decided to keep 
asking for SQE128 regardless of that (pi 0 or non-zero). In both cases 
user will set meta-buffer/len, and other type-specific flags are taken 
care by the low-level code. This keeps thing simple and at io_uring 
level we don't have to distinguish that case.

What I rather meant in this statement was - one can setup a ring with 
SQE128 today and send IORING_OP_READ/IORING_OP_WRITE. That goes fine 
without any processing/error as SQE128 is skipped completely. So relying 
only on SQE128 flag to detect the presence of PI is a bit fragile.


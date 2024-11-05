Return-Path: <io-uring+bounces-4464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0656C9BD2D8
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 17:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52EACB22459
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5252C1DC070;
	Tue,  5 Nov 2024 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="f34x1gIA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9731DC04C
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825452; cv=none; b=PlSeBN3ljx+Ke3uF5E8L5kfLaIdGqOaYmgB6h/csOQYCRQqVPioymliuGxe9HzXz0Ge7gpra7B8x55VhMUtCQIwZe0Wciu333VxIG+F40Lb3KHycJKetmUSwiaoRgSlcK+UUhGBA3I1N+pqU1DFW3FCRQLObudyEsJF5M78t8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825452; c=relaxed/simple;
	bh=TBHNa1mBwNztVqpf9vZSIGflr1LT65lmNTiFXHO2MjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=P5UZ1+g8gfAVStPQC7UvIL8osqYt9t9TGaxxaDTCpeLrq3QVqEERTL717A0mlkpTbL4jvbbMyhv1S1bkGO8iKYoh6tznChKuIqSmBKcJRCD1cdYQvZk5Tk3PnntQDJOMAHZXQTt6Z080x2W9BzzQiP9qolU9tErG3u43JJjJwyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=f34x1gIA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241105165047epoutp039998fa3be64cd3c459395be746452129~FIJMbp0AB1861818618epoutp03X
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 16:50:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241105165047epoutp039998fa3be64cd3c459395be746452129~FIJMbp0AB1861818618epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730825448;
	bh=9Oo01NJ+5BGBwgGuyg9+kxfl0D65gIoALN5fW4g3F0E=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=f34x1gIA2REbwQzBENPmzkTL0Bnj1XjfihidhR3I86+zE5m7CerZczFQaqj6yaT7N
	 LeNJSy63Q7opW2/EgP/D9jPHx/04B/O0g2UhLQ5pZf8x4JhMfPI/feNyalFJwHUBGQ
	 QUIpEA3VJhMt+hDYHAk3k4bob/n4CjBA6rJsQD5Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241105165047epcas5p20032739673366c1a2f4739483c360614~FIJL3a08r2130621306epcas5p2E;
	Tue,  5 Nov 2024 16:50:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XjZ8j47Njz4x9Pt; Tue,  5 Nov
	2024 16:50:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	76.26.09420.5EC4A276; Wed,  6 Nov 2024 01:50:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241105165044epcas5p174fe1869737e521eaa9c70f8ab45f803~FIJJj2BlM0806608066epcas5p1C;
	Tue,  5 Nov 2024 16:50:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241105165044epsmtrp2767f7f600e8cb8f825583a702e289a62~FIJJi63Kf1665016650epsmtrp2c;
	Tue,  5 Nov 2024 16:50:44 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-63-672a4ce59c07
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9E.E4.35203.4EC4A276; Wed,  6 Nov 2024 01:50:44 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241105165042epsmtip299babc66819b546d119798ffe0ff196b~FIJHFfUZx2499724997epsmtip2h;
	Tue,  5 Nov 2024 16:50:42 +0000 (GMT)
Message-ID: <2cebf7b9-b1e5-4118-ace0-ee18c4c19a25@samsung.com>
Date: Tue, 5 Nov 2024 22:20:41 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Anuj gupta <anuj1072538@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmhu5TH610g3UrZC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QO0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
	ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzGmV/YCrbIVsw4/ISlgfGXWBcjJ4eEgInEk1Mv
	GLsYuTiEBHYzSkzav4gdwvnEKPFkfhMzhPONUWJi/wUWmJZ/nyaxQST2MkpsO9nMDJIQEnjL
	KLHsngOIzStgJzFjxWk2EJtFQEWieXofM0RcUOLkzCdgg0QF5CXu35rBDmILC8RLLF94HCwu
	IuAs8bf3PBPIAmaBycwSV94tBUswC4hL3HoyHyjBwcEmoClxYXIpSJhTwF5i3ukfbBAl8hLb
	384Bu1pC4AuHxPUtT1ghrnaRuPt7ITOELSzx6vgWdghbSuLzu71sEHa2xINHD6C+rJHYsbkP
	qtdeouHPDVaQvcxAe9fv0ofYxSfR+/sJ2DkSArwSHW1CENWKEvcmPYXqFJd4OGMJlO0hsXLD
	Umi4nWOWWHbsJvMERoVZSMEyC8mXs5C8Mwth8wJGllWMkqkFxbnpqcWmBYZ5qeXwCE/Oz93E
	CE7tWp47GO8++KB3iJGJg/EQowQHs5II77xU9XQh3pTEyqrUovz4otKc1OJDjKbA+JnILCWa
	nA/MLnkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTCJf7q60Xzf
	4ndbOiruZ65adi3ic/63dQtLC2+cOmZYZWm0hdFMJmfyoTIWp6lT5t/REEisu3Hn3Wy713H2
	G+PPPHNdazxJsfWIn/W96//DfxUueGVvl639Kqd/CtObsB5H2x0X+fdPkeB29+r3NjNfrLLm
	6JTGvWeXblqSHGrTLzrtydb5Ah5brqTt0d79Xin13Jd7TMyPfJ+uOlc/rZTr8UTviXLN+zl+
	GSfu7/t1KetKTk5I98v9Lgd60rLXapjoibG8zdBZUyVbbfJrtkGASIPjW6Usp7/7Z9kcXMf5
	QvSw+Toe36QzrBI6Lwvt+DLXVwbqfb+65svfhv71n08r51rqLX5/+nzZ852Xar7GKLEUZyQa
	ajEXFScCAMA70Lh2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWy7bCSvO4TH610gxtn9Sw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXRuPML2wFW2QrZhx+wtLA
	+Eusi5GTQ0LAROLfp0lsXYxcHEICuxklXuxrYoJIiEs0X/vBDmELS6z895wdoug1o8SM3oks
	IAleATuJGStOs4HYLAIqEs3T+5gh4oISJ2c+AasRFZCXuH9rBtggYYF4ieaJS8BqRAScJf72
	nmcCGcosMJlZovlFH9SGc8wSK3d3g01lBjrj1pP5QFUcHGwCmhIXJpeChDkF7CXmnf4BVWIm
	0bW1ixHClpfY/nYO8wRGoVlI7piFZNIsJC2zkLQsYGRZxSiZWlCcm55bbFhgmJdarlecmFtc
	mpeul5yfu4kRHMlamjsYt6/6oHeIkYmD8RCjBAezkgjvvFT1dCHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK84i96U4QE0hNLUrNTUwtSi2CyTBycUg1MwUpXZDbMbWTVj3q/1Ge58rLDcrKyjqWK
	r9u0Cwz1UxlULcN5MvwS/VdM/zhf1ZeV02iW8r7UbT9EtPa3bfXPeOLw0lV0/QOP427d5yff
	yA5g9N+3ve1A6BXzC2LTY2W509bdOjevzkBrpVr1c8eN2l5ip1yDBf/xX7K+nbAgO/vY53+m
	kv7xz5s//IluezZzS/6XfbpVWdOWpW94G+nsrH7kbmU/s2m0qXvk91/vs22Ws79x5ziwMkrl
	lO2uzN3qU7dbr/NsEiv3+bo2eX59knJIK9eOvae61729cudrWbDM49l7917btlhtUqNkngzv
	7Irlb0W1DQJusv9L5lVy7fikqSe7Z7fuuZcFh/4qsRRnJBpqMRcVJwIAb2CzT1MDAAA=
X-CMS-MailID: 20241105165044epcas5p174fe1869737e521eaa9c70f8ab45f803
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
	<ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com>

On 11/5/2024 9:53 PM, Keith Busch wrote:
> On Tue, Nov 05, 2024 at 05:00:51PM +0100, Christoph Hellwig wrote:
>> On Tue, Nov 05, 2024 at 09:21:27PM +0530, Kanchan Joshi wrote:
>>> Can add the documentation (if this version is palatable for Jens/Pavel),
>>> but this was discussed in previous iteration:
>>>
>>> 1. Each meta type may have different space requirement in SQE.
>>>
>>> Only for PI, we need so much space that we can't fit that in first SQE.
>>> The SQE128 requirement is only for PI type.
>>> Another different meta type may just fit into the first SQE. For that we
>>> don't have to mandate SQE128.
>>
>> Ok, I'm really confused now.  The way I understood Anuj was that this
>> is NOT about block level metadata, but about other uses of the big SQE.
>>
>> Which version is right?  Or did I just completely misunderstand Anuj?
> 
> Let's not call this "meta_type". Can we use something that has a less
> overloaded meaning, like "sqe_extended_capabilities", or "ecap", or
> something like that.
>   

Right, something like that. We need to change it.
Seems a useful thing is not being seen that way because of its name.

>>> 2. If two meta types are known not to co-exist, they can be kept in the
>>> same place within SQE. Since each meta-type is a flag, we can check what
>>> combinations are valid within io_uring and throw the error in case of
>>> incompatibility.
>>
>> And this sounds like what you refer to is not actually block metadata
>> as in this patchset or nvme, (or weirdly enough integrity in the block
>> layer code).
>>
>>> 3. Previous version was relying on SQE128 flag. If user set the ring
>>> that way, it is assumed that PI information was sent.
>>> This is more explicitly conveyed now - if user passed META_TYPE_PI flag,
>>> it has sent the PI. This comment in the code:
>>>
>>> +       /* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
>>> +       union {
>>>
>>> If this flag is not passed, parsing of second SQE is skipped, which is
>>> the current behavior as now also one can send regular (non pi)
>>> read/write on SQE128 ring.
>>
>> And while I don't understand how this threads in with the previous
>> statements, this makes sense.  If you only want to send a pointer (+len)
>> to metadata you can use the normal 64-byte SQE.  If you want to send
>> a PI tuple you need SEQ128.  Is that what the various above statements
>> try to express?  If so the right API to me would be to have two flags:
>>
>>   - a flag that a pointer to metadata is passed.  This can work with
>>     a 64-bit SQE.
>>   - another flag that a PI tuple is passed.  This requires a 128-byte
>>     and also the previous flag.
> 
> I don't think anything done so far aligns with what Pavel had in mind.
> Let me try to lay out what I think he's going for. Just bare with me,
> this is just a hypothetical example.

I have the same example in mind.


>    This patch adds a PI extension.
>    Later, let's say write streams needs another extenion.
>    Then key per-IO wants another extention.
>    Then someone else adds wizbang-awesome-feature extention.
> 
> Let's say you have device that can do all 4, or any combination of them.
> Pavel wants a solution that is future proof to such a scenario. So not
> just a single new "meta_type" with its structure, but a list of types in
> no particular order, and their structures.
> 
> That list can exist either in the extended SQE, or in some other user
> address that the kernel will need copy.

That list is the meta_type bit-flags this series creates.

For some future meta_type there can be "META_TYPE_XYZ_INDIRECT" flag and 
that will mean extra-information needs to fetched via copy_from_user.


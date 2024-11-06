Return-Path: <io-uring+bounces-4476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9D69BDE74
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 07:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3880284F7B
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 06:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A951917D7;
	Wed,  6 Nov 2024 06:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gnnIi4F9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2603036D
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 06:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730872862; cv=none; b=QXQr5+JIMtJ71+lDS/YAxH+S0shvkQbtyjUTepa2av0Ssy2vEQi+4fNsvrX8RXwmfXBV9w78K/3J8U4K8GJgy+OkHoZ/r2YqMP5+Zlb17CSLhPCvI7Vk2YuDtzc46gQD6MocblymXBYZZAc4oaxJOByO/wjlCHAbicGHRid99x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730872862; c=relaxed/simple;
	bh=pXov4/G53nv+Wm8XtvOwxhiIdF4l1C0PwtxnOd3eXxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=CYkM3EnQiQskZhfFODLEs7gMc/c6WtnzDods85Lf2YkC95toCWPY3qPuh+1CbDGp3Psa86XTVfl0qk3pja5NgeAjeCjiZ6j7UIOBoEFZfs6JjhgGdB9EUlxR3+2jA4lOIHP3BDux4zo5iDRpFmmaSB9DgRnsg8GU6FuXiHUY8hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gnnIi4F9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241106060058epoutp028fc7b6e3b952b32abb175ecbba635eca~FS7G6AZAr0364103641epoutp02j
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 06:00:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241106060058epoutp028fc7b6e3b952b32abb175ecbba635eca~FS7G6AZAr0364103641epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730872858;
	bh=Ej6Ht9+9miGRbgcjcC3ciHKwZNbtnJU8DR829FdUow0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=gnnIi4F9+87Nh2XOC9OUvnywGUvlIERKFCkZcgeMZAojeqGPK032kci3zOPeuDXlK
	 c099CjY89t+AINFEyhgQqK+eVX6o+YdGdB3+MRZyOu+BopN6wOetca1yIm5HKv4Zk+
	 Zr1/JvFlYbRC6aKGWpkeumd2FQnFtqJ8Hs94jBe0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241106060053epcas5p23f3bd98c5f69651df7f7fd1b88ff0e66~FS7Cj_i_U1511915119epcas5p20;
	Wed,  6 Nov 2024 06:00:53 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XjvhK41Rpz4x9Pr; Wed,  6 Nov
	2024 06:00:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	95.91.08574.1160B276; Wed,  6 Nov 2024 15:00:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241106060048epcas5p2cca05f3995251a0b4050a61bcd8a5fcc~FS698rE7-1511915119epcas5p2h;
	Wed,  6 Nov 2024 06:00:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241106060048epsmtrp2001dbf7dcaeafdae0f52e0ee13a913f5~FS697q1s_2631626316epsmtrp2f;
	Wed,  6 Nov 2024 06:00:48 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-b4-672b06116618
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	07.0B.18937.0160B276; Wed,  6 Nov 2024 15:00:48 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106060046epsmtip1fdcae75ba11bf62dfc7538fe4fd2f588~FS67cmV3D3220232202epsmtip11;
	Wed,  6 Nov 2024 06:00:46 +0000 (GMT)
Message-ID: <e68f0127-a8a8-46da-8e68-7a2f3af73627@samsung.com>
Date: Wed, 6 Nov 2024 11:30:45 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Anuj gupta <anuj1072538@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241106052927.GA31192@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmhq4gm3a6wfxz0hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsa6+d+ZC95KVZy93MTSwHhPpIuRg0NCwETi667U
	LkZODiGB3YwSu/a6dTFyAdmfGCVuzz/LAucs6v7ABlIF0nDnSzczRGIno8TeX2ugqt4ySvy/
	fIMRpIpXwE5iz80NTCArWARUJN7OtIAIC0qcnPmEBcQWFZCXuH9rBjuILSwQL7F84XGwuIiA
	s8TXz1eZQGYyC0xmlrjybilYgllAXOLWk/lgM9kENCUuTC4FCXMK6Eg0TLjODFEiL7H97Ryw
	4yQEPnBI/Hx8GupqF4lju9tYIWxhiVfHt7BD2FISn9/tharJlnjw6AELhF0jsWNzH1S9vUTD
	nxusIHuZgfau36UPsYtPovf3EyZIKPJKdLQJQVQrStyb9BSqU1zi4YwlULaHxMoNS9kgQfWB
	WWL5ngtMExgVZiEFyywkX85C8s4shM0LGFlWMUqmFhTnpqcmmxYY5qWWw6M7OT93EyM4rWu5
	7GC8Mf+f3iFGJg7GQ4wSHMxKIrzzUtXThXhTEiurUovy44tKc1KLDzGaAqNnIrOUaHI+MLPk
	lcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXANP+OWcKnRzt3Rzk8
	+S13U/GJ6Y5Nt+fHtBmwyk98MHXdqtXztU6ZG7ae/3rqcahajJu35DSx3HfrGfj9b8w5couH
	b49GxAy12yyqv3OCUtLruduuNh7ce/DYzDM81dvfT+Ka/9N7/rRld2Wt54csU760L0+u/Ha2
	eKfGE/Y9QgFszH83Opz4/UPTd2tlx4Q/F7//bYl/c+tWvWUg38x1q9+wGapwXfS1efhjz7w+
	sQtz+ZYvLFxg9/tn+t3IbZnLd086v579pafVw7CzJVHfY5MmbeZZIev8K6a4kfH3NL9ez9tz
	XmhOOz0pg83soeoCJpHYJXPlFyjccZ56aePmyETPp0/8Ks8fzA5i7lL706ilxFKckWioxVxU
	nAgAvMKcBXQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWy7bCSnK4Am3a6waMF+hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoErY93878wFb6Uqzl5uYmlg
	vCfSxcjJISFgInHnSzdzFyMXh5DAdkaJVQuXsUEkxCWar/1gh7CFJVb+e84OUfSaUeLP6U4m
	kASvgJ3EnpsbgGwODhYBFYm3My0gwoISJ2c+YQGxRQXkJe7fmgE2R1ggXqJ54hJmEFtEwFni
	6+erTCAzmQUmM0s0v+iDWvCBWeLhiQ2MIFXMQFfcejIfbAGbgKbEhcmlIGFOAR2JhgnXmSFK
	zCS6tnZBlctLbH87h3kCo9AsJHfMQjJpFpKWWUhaFjCyrGIUTS0ozk3PTS4w1CtOzC0uzUvX
	S87P3cQIjl+toB2My9b/1TvEyMTBeIhRgoNZSYR3Xqp6uhBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVAOTdp2xcpegy/u3zyY/rvZp9WsruqzHz1ofKVC5
	+cilCJ45mye95T+wIrdyWe2rEB2uE5USzpW2Uy5E/JdpuuX6NHwez5kedp6rjQ1nitm4JGd3
	lG65J/pEYhnXTXeXM8+W9em0XHfaKHDsyaJjpqF2YnG3lzG0tsSf/W174NjX2/fsLGKr5yr8
	PqtQFjppHbN3m287+/OJU4stch+d153Yq1nmHKh/v07bOyXiUi2/++q5TxUNOUVeeHS+Z3n3
	i03zamnLwZ1yhbdvu+6/n7r37rWtGhPlYxiafFm70szNXFe6Ch5SPBH/+Kn/+g3aO7h6OJf4
	/WDV6L/Q87Z9sfD+5ZM2rT96KXsxr7zEvsdKLMUZiYZazEXFiQBMHopqTgMAAA==
X-CMS-MailID: 20241106060048epcas5p2cca05f3995251a0b4050a61bcd8a5fcc
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
	<20241106052927.GA31192@lst.de>

On 11/6/2024 10:59 AM, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 09:23:19AM -0700, Keith Busch wrote:
>>>> The SQE128 requirement is only for PI type.
>>>> Another different meta type may just fit into the first SQE. For that we
>>>> don't have to mandate SQE128.
>>>
>>> Ok, I'm really confused now.  The way I understood Anuj was that this
>>> is NOT about block level metadata, but about other uses of the big SQE.
>>>
>>> Which version is right?  Or did I just completely misunderstand Anuj?
>>
>> Let's not call this "meta_type". Can we use something that has a less
>> overloaded meaning, like "sqe_extended_capabilities", or "ecap", or
>> something like that.
> 
> So it's just a flag that a 128-byte SQE is used?

No, this flag tells that user decided to send PI in SQE. And this flag 
is kept into first half of SQE (which always exists). This is just 
additional detail/requirement that PI fields are kept into SQE128 (which 
is opt in).

>  Don't we know that
> implicitly from the sq?

Yes, we have a separate ring-level flag for that.

#define IORING_SETUP_SQE128             (1U << 10) /* SQEs are 128 byte */

>>>   - a flag that a pointer to metadata is passed.  This can work with
>>>     a 64-bit SQE.
>>>   - another flag that a PI tuple is passed.  This requires a 128-byte
>>>     and also the previous flag.
>>
>> I don't think anything done so far aligns with what Pavel had in mind.
>> Let me try to lay out what I think he's going for. Just bare with me,
>> this is just a hypothetical example.
>>
>>    This patch adds a PI extension.
>>    Later, let's say write streams needs another extenion.
>>    Then key per-IO wants another extention.
>>    Then someone else adds wizbang-awesome-feature extention.
>>
>> Let's say you have device that can do all 4, or any combination of them.
>> Pavel wants a solution that is future proof to such a scenario. So not
>> just a single new "meta_type" with its structure, but a list of types in
>> no particular order, and their structures.
> 
> But why do we need the type at all?  Each of them obvious needs two
> things:
> 
>   1) some space to actually store the extra fields
>   2) a flag that the additional values are passed

Yes, this is exactly how the patch is implemented. 'meta-type' is the 
flag that tells additional values (representing PI info) are passed.

> any single value is not going to help with supporting arbitrary
> combinations,

Not a single value. It is a u16 field, so it can represent 16 possible 
flags.
This part in the patch:

+enum io_uring_sqe_meta_type_bits {
+       META_TYPE_PI_BIT,
+       /* not a real meta type; just to make sure that we don't overflow */
+       META_TYPE_LAST_BIT,
+};
+
+/* meta type flags */
+#define META_TYPE_PI   (1U << META_TYPE_PI_BIT)

For future users, one can add things like META_TYPE_KPIO_BIT or 
META_TYPE_WRITE_HINT_BIT if they needed to send extra information in SQE.

Note that these users may not require SQE128. It all depends on how much 
of extra information is required. We still have some free space in first 
SQE.

  because well, you can can mix and match, and you need
> space for all them even if you are not using all of them.

mix-and-match can be detected with the above flags.
And in case two types don't go well together, that also. And for such 
types we can reuse the space.




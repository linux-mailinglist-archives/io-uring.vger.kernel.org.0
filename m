Return-Path: <io-uring+bounces-3410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8615F98FD9C
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04D541F21D7D
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684A213210D;
	Fri,  4 Oct 2024 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U2wAIc13"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FC16F305
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728025171; cv=none; b=NIJYPe4c7sFIVj0+fNqP77itZluqR9fD5PZI//tDc6C36JIzeBZsLr+q0GH2ppu2j0gPQO+DTqhyKXPas2v0MJU4e3HJE6+3d0BU0e0SJ9KTh1zPnuVj0Coclcp+UFVYB2/mjYiyYq+Gt07dAhoU+LxxCHHeOQSRL5AZ/WDdRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728025171; c=relaxed/simple;
	bh=SYN09Xbe0PYTJ9ppx0TFZKZbxwEzo13CyM8oiPI0iAw=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=JMz+SKmKMjr7qweHp2rKorsNh0OD0TArnPqSSNFUjvXnXkkbIOvNEvgEew9yy290NzaOZ2fN8R82y604dCnKrcLSrZXcWtgTr9sdowAIfoIH6DIXcDOCT/qPKxmxbxinHzBBc+8CzX2dZbHu6+Iv7LGM1AjZUrcrYyaANnluE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=U2wAIc13; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241004065927euoutp019ef1199cd6e8d6ed255896ef200f3ab2~7LbwW3lOh2648526485euoutp01p
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:59:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241004065927euoutp019ef1199cd6e8d6ed255896ef200f3ab2~7LbwW3lOh2648526485euoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728025167;
	bh=SYN09Xbe0PYTJ9ppx0TFZKZbxwEzo13CyM8oiPI0iAw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=U2wAIc13yrx/Yctii7AGAPt3xRg9kAJS7HluBrRYgFF7ADP9u+4Skf65ejl/ZyU8Y
	 VYUL84ar3zTvv52f3nPspIknxf10dwr9CYIymvh1/weHsMFZGSvXy8pnUEtOl6ZTfQ
	 W5iDtdspw+t886cF4l4pMlP+6cPWsjEv0nHp7eZA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241004065927eucas1p1e9b244cdb734ff657d36fa1743d0d817~7LbvtdUrD0035300353eucas1p1g;
	Fri,  4 Oct 2024 06:59:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 9B.95.09624.F429FF66; Fri,  4
	Oct 2024 07:59:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241004065926eucas1p15ba0fcb2cecce51f4006abd5569012d8~7LbvMpqz00873808738eucas1p10;
	Fri,  4 Oct 2024 06:59:26 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241004065926eusmtrp1159c38c63f2d07b201a490752a3e857c~7LbvLh1tG0471004710eusmtrp1d;
	Fri,  4 Oct 2024 06:59:26 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-02-66ff924f034f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id D5.F5.19096.E429FF66; Fri,  4
	Oct 2024 07:59:26 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241004065926eusmtip28a31675353c172ac8997699aa2c5014c~7Lbu01tpC0535105351eusmtip2Z;
	Fri,  4 Oct 2024 06:59:26 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 4 Oct 2024 07:59:24 +0100
Date: Fri, 4 Oct 2024 08:59:23 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>, <hare@suse.de>,
	<sagi@grimberg.me>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>,
	<jack@suse.cz>, <jaegeuk@kernel.org>, <bcrl@kvack.org>,
	<dhowells@redhat.com>, <asml.silence@gmail.com>,
	<linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-aio@kvack.org>, <gost.dev@samsung.com>, <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004065923.zddb4fsyevfw2n24@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004062415.GA14876@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZduznOV3/Sf/TDNZtZ7WYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	FJdNSmpOZllqkb5dAlfGrqMnmQuusVUcWPeSuYFxPWsXIyeHhICJxOLZ85hBbCGBFYwS048z
	djFyAdlfGCV2PHnBBuF8ZpR4evcCO0zH3s9vmSESyxklJr+8zghXtfHaO3YIZzOjxKm7B8Ba
	WARUJE6//MICYrMJ2EtcWnYLbKGIgJLE01dnwbqZBS6xSNy6eIYNJCEsYCDx/nsvkM3BwStg
	K7Fnui1ImFdAUOLkzCdgc5gFrCQ6PzSxgpQwC0hLLP/HARGWl2jeOhtsPKeAjsS3o6eYIK5W
	knj84i0jhF0rcWrLLSaQtRICfVwSe5p7oYpcJJbuegxVJCzx6vgWqJdlJE5P7mGBsKslGk6e
	gGpuYZRo7dgKdoSEgLVE35kciBpHiYOvfjNDhPkkbrwVhLiNT2LStulQYV6JjjahCYwqs5A8
	NgvJY7MQHpuF5LEFjCyrGMVTS4tz01OLDfNSy/WKE3OLS/PS9ZLzczcxAlPp6X/HP+1gnPvq
	o94hRiYOxkOMEhzMSiK887b/TRPiTUmsrEotyo8vKs1JLT7EKM3BoiTOq5oinyokkJ5Ykpqd
	mlqQWgSTZeLglGpgKnpbzWZ7fKfe35Bbb1/vv7/BQ0C68wULh8rf+0m7Ai+f9liRLv7XnKe8
	1PPOU+3cjizzkzP0nqs/YNMwvrrkmtHs3QsbD6YkF5+asnu1qMA//lLht7WZsWcso/mC0+TO
	mj5Jr8ttTvn/9YTrHElD/l5j9vX3FsWKnAkM/cYt8nBVz9zJ0y9tO+/0fs6OrHNzzrasNN2z
	zEjjn6tuM5vEsUrZ97s+fNlguK9gZ7R4/r8HbqvWOWvfCpuhL/fg6pVvc7xVd6l/WzldMyxv
	lvaLWdGmDb5aJ9JuKFcFBd61yH76PF7M3X/XiyrZ+ncnnyqebTiWWZIyO75re4zPntO8ERO2
	p+bF/tin8aZnd9FOVyWW4oxEQy3mouJEADqfXjwUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t/xe7p+k/6nGVyZKmMxZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2MXUdP
	MhdcY6s4sO4lcwPjetYuRk4OCQETib2f3zJ3MXJxCAksZZQ4v3EtVEJGYuOXq1C2sMSfa11s
	ILaQwEdGiYNfJSAaNjNKrFw5iR0kwSKgInH65RcWEJtNwF7i0rJbzCC2iICSxNNXZxlBGpgF
	LrFI3Lp4BmySsICBxPvvvUA2BwevgK3Enum2EENvM0vsO7sebCivgKDEyZlPwIYyC1hIzJx/
	nhGknllAWmL5Pw6IsLxE89bZYLs4BXQkvh09xQRxtJLE4xdvGSHsWonPf58xTmAUmYVk6iwk
	U2chTJ2FZOoCRpZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgalm27GfW3Ywrnz1Ue8QIxMH
	4yFGCQ5mJRHeedv/pgnxpiRWVqUW5ccXleakFh9iNAUG0URmKdHkfGCyyyuJNzQzMDU0MbM0
	MLU0M1YS52W7cj5NSCA9sSQ1OzW1ILUIpo+Jg1OqgUl+3dXGSscNq6Jrw49PPj2hsuOSvVPG
	ie9Z94/89HzDvHDqEwa1gwz79qz7GerrXndJcFZl7dtDVeXnexyezD3h+a1l+SxLJ4dLEduy
	n1rO91ra1bzvvFiZeuqq3Utat+l/EThkkC2TX3fmh3bxtDsuEz+3iS535uBfcH9myBmFOpF5
	f5Y8PJji+Ci9jNvbesKbkLPmf9PfJCntWuHEOyHim6Z8dmWZdue7FO9D/5YJmnJzH+gNCYk7
	paESYKNWdm/RQ4lTRmZsJe6ro2KWnL1//9u7V31f563Sj3tWFHD12d39j6z6hd7kCSgeWf1S
	Ze1awzuXwi5cf+Lyac9VnuR7azNErj+zrTH5kfIlsMpMiaU4I9FQi7moOBEAUqqfUb4DAAA=
X-CMS-MailID: 20241004065926eucas1p15ba0fcb2cecce51f4006abd5569012d8
X-Msg-Generator: CA
X-RootMTR: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
References: <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
	<20241002151344.GA20364@lst.de>
	<Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
	<a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
	<CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com>
	<20241003125516.GC17031@lst.de>
	<20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local>
	<20241004062415.GA14876@lst.de>

On 04.10.2024 08:24, Christoph Hellwig wrote:
>On Fri, Oct 04, 2024 at 08:21:29AM +0200, Javier González wrote:
>>> So I think some peoples bonuses depend on not understanding the problem
>>> I fear :(
>>>
>>
>> Please, don't.
>>
>> Childish comments like this delegitimize the work that a lot of people
>> are doing in Linux.
>
>It's the only very sarcastic explanation I can come up with to explain
>this discussion, where people from the exactly two companies where this
>might be bonus material love political discussion and drop dead when it
>turns technical.

FDP has authors from Meta, Google, Kioxia, Micron, Hynix, Solidigm,
Microship, Marvell, FADU, WDC, and Samsung.

The fact that 2 of these companies are the ones starting to build the
Linux ecosystem should not surprise you, as it is the way things work
normally.



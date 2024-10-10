Return-Path: <io-uring+bounces-3548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA46C997F33
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 10:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F28C286986
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 08:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC181CDFC6;
	Thu, 10 Oct 2024 07:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SZVU7Wud"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B5C1CEAC6
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 07:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544414; cv=none; b=CkL08BNNh8ZVUCQr7LRX4yMe37BkVUZiTfL8CW5lDTJbpVMsAXeJclf6rvqmm66oqQinbwF9YugyPzMykGV14xsazkFZhC/FWX4/Fcf6GdUQZ9P6FWSSMV2uyACzfkzsS6kP00SF+s7B0gGViOpfBb+LUrHrnkM8QSZgkwF3e0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544414; c=relaxed/simple;
	bh=OxGUsV0jzQGosZl0ileEUte6XOjyAWTdP9106v1boBg=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=O7z6o22ERusfEv6NnwvwN7Q9ZtU0XNBJRnIemcdJvWRTDGIfZJEAir+s6wwMhVXQRDo1sTo5AYtgDjCi50gNjxwBQ70MyKp3tt3fL/9vKgMvdRhB4xosqtKGi+9C5bxPl8gQ/OkkptBJJdZGVOpwqqIrqxIYSjXaLnWD5Y1F5bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SZVU7Wud; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241010071330euoutp01ffb4d9601c295696966b30dc815172cc~9Bfub5Gl21414714147euoutp01g
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 07:13:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241010071330euoutp01ffb4d9601c295696966b30dc815172cc~9Bfub5Gl21414714147euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728544410;
	bh=QfASOiGL/sHMm1sLI+jdF0Ss/rT4MNpLg87AmhGdOX4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=SZVU7Wud6PC3d8Tyf8TWebAHKO1HsFHMyhlb0RB79RswJq/e7EbiOBFOMs5x5U4dU
	 OBFGrXuz5DyJ8gcVO9zMuudWIT5BaLhiJI7uTb/XSaY21bLXzCzbLGxPzhL4n4IppG
	 WC3f/6b127a+kL+AqzreRmqEpwNdhrlITtFX1UVE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241010071329eucas1p2e723d8c64be11a8ea805aa0779cd3bcb~9BfuCO4h71136111361eucas1p2M;
	Thu, 10 Oct 2024 07:13:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 2F.26.09875.99E77076; Thu, 10
	Oct 2024 08:13:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241010071329eucas1p1245dd945659d177d4d3468b883460a37~9Bftm00fs2751927519eucas1p1p;
	Thu, 10 Oct 2024 07:13:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241010071329eusmtrp22b9e1a9fc574d891cc9755196159a054~9BftmD3gb2381623816eusmtrp2H;
	Thu, 10 Oct 2024 07:13:29 +0000 (GMT)
X-AuditID: cbfec7f4-131ff70000002693-a1-67077e9949af
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 8D.C5.14621.99E77076; Thu, 10
	Oct 2024 08:13:29 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010071329eusmtip239a13a265502c01e2dfc7156bbccee24~9BftXXQf-1553315533eusmtip2x;
	Thu, 10 Oct 2024 07:13:29 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 10 Oct 2024 08:13:28 +0100
Date: Thu, 10 Oct 2024 09:13:27 +0200
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Hans Holmberg <hans@owltronix.com>
CC: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "brauner@kernel.org"
	<brauner@kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>, "dhowells@redhat.com"
	<dhowells@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZduznOd2ZdezpBgvvqFvMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLOZOXc1qsWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Jh26xmgxZVoTo8XeW9oWe/aeZLGYv+wpu8Xy4/+YLNa9fs9icf7vcVYHEY/LV7w9ds66y+5x
	/t5GFo/LZ0s9Nq3qZPPY9GkSu8fmJfUeu282sHl8fHqLxePwpkWsHu/3XWXzOLPgCFDydLXH
	501yHpuevGUK4I/isklJzcksSy3St0vgyuj7s4el4LlfxYeVqQ2M6+26GDk5JARMJGZfOMnc
	xcjFISSwglFi88tWRgjnC6PE3RuT2CGcz4wSJ67dZIJpeXPhEwtEYjmjxMz5e9jgqjbvWsQK
	4WxhlGjed4sZpIVFQFWibctbsHY2AX2JVdtPMYLYIgJqEmdfdDCBNDALfGOXaF/QAZYQFjCQ
	eP+9lw3E5hWwlZg67xcThC0ocXLmExYQm1nASqLzQxPQNg4gW1pi+T8OiLC8RPPW2WB7OQUC
	Ja69Xs0McbaSxOMXbxkh7FqJU1tuge2VEJjLJbH782KohIvE9FkfWCFsYYlXx7ewQ9gyEv93
	zof6v1qi4eQJqOYWRonWjq1gR0gIWEv0ncmBqHGUeDX9JztEmE/ixltBiNv4JCZtm84MEeaV
	6GgTmsCoMgvJY7OQPDYL4bFZSB5bwMiyilE8tbQ4Nz212CgvtVyvODG3uDQvXS85P3cTIzDB
	nv53/MsOxuWvPuodYmTiYDzEKMHBrCTCq7uQNV2INyWxsiq1KD++qDQntfgQozQHi5I4r2qK
	fKqQQHpiSWp2ampBahFMlomDU6qBSUP1dOZXR8cJnFfFZ1u5RO7YrLDHYctT69fWCYtDQnNy
	p7gnWk99IsXQ0tvXZNyyvShKdmpIM3dizD1NV7G+6bvTmYxOpJ480jQlVDt9n3NwX/oik4yr
	T3zuzfmjvkbh/Yqe+8tKrq385PfgmrnsnfrIc1sdfO8Ep9geDd9edkhq+amJWTz8vwNurF0x
	YanpUv+TuoLW+nsll66NZC825jrw9qEq24v44ms98YtDuL0OeMwS1aycecMvu1firp3S2d9e
	Z/f8jslojhFY/cxxh5PW32VBB1O49k94aWHq8t7k28YL9u3m7kH+FQdPriz+XH/s6mKjDZ23
	rp1+cfby/Fd7sv/ySTN/dImI+f20VomlOCPRUIu5qDgRAJQONu8fBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t/xe7oz69jTDf7O4rKYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWMyduprVYs+iSUwWK1cfZbJ413qOxWL29GYmiyfrZzFb
	TDp0jdFiyrQmRou9t7Qt9uw9yWIxf9lTdovlx/8xWax7/Z7F4vzf46wOIh6Xr3h77Jx1l93j
	/L2NLB6Xz5Z6bFrVyeax6dMkdo/NS+o9dt9sYPP4+PQWi8fhTYtYPd7vu8rmcWbBEaDk6WqP
	z5vkPDY9ecsUwB+lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZ
	llqkb5egl9H3Zw9LwXO/ig8rUxsY19t1MXJySAiYSLy58Imli5GLQ0hgKaPErtvzWSASMhIb
	v1xlhbCFJf5c62KDKPrIKLG86w87SEJIYAujxI3JJSA2i4CqRNuWt0wgNpuAvsSq7acYQWwR
	ATWJsy86mECamQW+sUu0L+gASwgLGEi8/97LBmLzCthKTJ33iwliw0oWib8/f7FCJAQlTs58
	AnYSs4CFxMz554GaOYBsaYnl/zggwvISzVtnM4PYnAKBEtder2aGuFpJ4vGLt4wQdq3E57/P
	GCcwisxCMnUWkqmzEKbOQjJ1ASPLKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMD0s+3Yz807
	GOe9+qh3iJGJg/EQowQHs5IIr+5C1nQh3pTEyqrUovz4otKc1OJDjKbAMJrILCWanA9MgHkl
	8YZmBqaGJmaWBqaWZsZK4rxul8+nCQmkJ5akZqemFqQWwfQxcXBKNTD1vol8HsRy/kX2nmaZ
	bzJrj/eUOTpM39YpwNgq++eBSEazq/21V1GLi+zCeibuXdwRrTzzv+uuOqX4o21HTFfeFFg3
	n7tdZ4Lh5zWv1cS3crbuNIzf+Hdt15mE4sMZnw41zBPxC+qPjXsgtFDIIezMd57N6/z+C3Re
	UDi9f8V5k+akbf8D12aGvV2VMrGKge0Yd0LnsugJCVe2fxZ+de/pYzXlV2cnn23Sbkx1bIye
	WbDS6IyIoPJrI7+y8sSPNzr6bh3qcX7mo2NkKDopTu7IBpHqc4lPD7Wm9KnOn+5w9nfiokN8
	fjsYO279ULuqymDac5bt5dU1ReW1ov8kTLVWfW9n//Eo+U7k1yvyJxyUWIozEg21mIuKEwGq
	22/SyAMAAA==
X-CMS-MailID: 20241010071329eucas1p1245dd945659d177d4d3468b883460a37
X-Msg-Generator: CA
X-RootMTR: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
References: <CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
	<20241004053121.GB14265@lst.de>
	<20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
	<20241004062733.GB14876@lst.de>
	<20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
	<20241004123027.GA19168@lst.de>
	<20241007101011.boufh3tipewgvuao@ArmHalley.local>
	<CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com>
	<97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local>
	<CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com>

On 10.10.2024 08:40, Hans Holmberg wrote:
>On Wed, Oct 9, 2024 at 4:36 PM Javier Gonzalez <javier.gonz@samsung.com> wrote:
>>
>>
>>
>> > -----Original Message-----
>> > From: Hans Holmberg <hans@owltronix.com>
>> > Sent: Tuesday, October 8, 2024 12:07 PM
>> > To: Javier Gonzalez <javier.gonz@samsung.com>
>> > Cc: Christoph Hellwig <hch@lst.de>; Jens Axboe <axboe@kernel.dk>; Martin K.
>> > Petersen <martin.petersen@oracle.com>; Keith Busch <kbusch@kernel.org>;
>> > Kanchan Joshi <joshi.k@samsung.com>; hare@suse.de; sagi@grimberg.me;
>> > brauner@kernel.org; viro@zeniv.linux.org.uk; jack@suse.cz; jaegeuk@kernel.org;
>> > bcrl@kvack.org; dhowells@redhat.com; bvanassche@acm.org;
>> > asml.silence@gmail.com; linux-nvme@lists.infradead.org; linux-
>> > fsdevel@vger.kernel.org; io-uring@vger.kernel.org; linux-block@vger.kernel.org;
>> > linux-aio@kvack.org; gost.dev@samsung.com; vishak.g@samsung.com
>> > Subject: Re: [PATCH v7 0/3] FDP and per-io hints
>> >
>> > On Mon, Oct 7, 2024 at 12:10 PM Javier González <javier.gonz@samsung.com>
>> > wrote:
>> > >
>> > > On 04.10.2024 14:30, Christoph Hellwig wrote:
>> > > >On Fri, Oct 04, 2024 at 08:52:33AM +0200, Javier González wrote:
>> > > >> So, considerign that file system _are_ able to use temperature hints and
>> > > >> actually make them work, why don't we support FDP the same way we are
>> > > >> supporting zones so that people can use it in production?
>> > > >
>> > > >Because apparently no one has tried it.  It should be possible in theory,
>> > > >but for example unless you have power of 2 reclaim unit size size it
>> > > >won't work very well with XFS where the AGs/RTGs must be power of two
>> > > >aligned in the LBA space, except by overprovisioning the LBA space vs
>> > > >the capacity actually used.
>> > >
>> > > This is good. I think we should have at least a FS POC with data
>> > > placement support to be able to drive conclusions on how the interface
>> > > and requirements should be. Until we have that, we can support the
>> > > use-cases that we know customers are asking for, i.e., block-level hints
>> > > through the existing temperature API.
>> > >
>> > > >
>> > > >> I agree that down the road, an interface that allows hints (many more
>> > > >> than 5!) is needed. And in my opinion, this interface should not have
>> > > >> semintics attached to it, just a hint ID, #hints, and enough space to
>> > > >> put 100s of them to support storage node deployments. But this needs to
>> > > >> come from the users of the hints / zones / streams / etc,  not from
>> > > >> us vendors. We do not have neither details on how they deploy these
>> > > >> features at scale, nor the workloads to validate the results. Anything
>> > > >> else will probably just continue polluting the storage stack with more
>> > > >> interfaces that are not used and add to the problem of data placement
>> > > >> fragmentation.
>> > > >
>> > > >Please always mentioned what layer you are talking about.  At the syscall
>> > > >level the temperatur hints are doing quite ok.  A full stream separation
>> > > >would obviously be a lot better, as would be communicating the zone /
>> > > >reclaim unit / etc size.
>> > >
>> > > I mean at the syscall level. But as mentioned above, we need to be very
>> > > sure that we have a clear use-case for that. If we continue seeing hints
>> > > being use in NVMe or other protocols, and the number increase
>> > > significantly, we can deal with it later on.
>> > >
>> > > >
>> > > >As an interface to a driver that doesn't natively speak temperature
>> > > >hint on the other hand it doesn't work at all.
>> > > >
>> > > >> The issue is that the first series of this patch, which is as simple as
>> > > >> it gets, hit the list in May. Since then we are down paths that lead
>> > > >> nowhere. So the line between real technical feedback that leads to
>> > > >> a feature being merged, and technical misleading to make people be a
>> > > >> busy bee becomes very thin. In the whole data placement effort, we have
>> > > >> been down this path many times, unfortunately...
>> > > >
>> > > >Well, the previous round was the first one actually trying to address the
>> > > >fundamental issue after 4 month.  And then after a first round of feedback
>> > > >it gets shutdown somehow out of nowhere.  As a maintainer and review that
>> > > >is the kinda of contributors I have a hard time taking serious.
>> > >
>> > > I am not sure I understand what you mean in the last sentece, so I will
>> > > not respond filling blanks with a bad interpretation.
>> > >
>> > > In summary, what we are asking for is to take the patches that cover the
>> > > current use-case, and work together on what might be needed for better
>> > > FS support. For this, it seems you and Hans have a good idea of what you
>> > > want to have based on XFS. We can help review or do part of the work,
>> > > but trying to guess our way will only delay existing customers using
>> > > existing HW.
>> >
>> > After reading the whole thread, I end up wondering why we need to rush the
>> > support for a single use case through instead of putting the architecture
>> > in place for properly supporting this new type of hardware from the start
>> > throughout the stack.
>>
>> This is not a rush. We have been supporting this use case through passthru for
>> over 1/2 year with code already upstream in Cachelib. This is mature enough as
>> to move into the block layer, which is what the end user wants to do either way.
>>
>> This is though a very good point. This is why we upstreamed passthru at the
>> time; so people can experiment, validate, and upstream only when there is a
>> clear path.
>>
>> >
>> > Even for user space consumers of raw block devices, is the last version
>> > of the patch set good enough?
>> >
>> > * It severely cripples the data separation capabilities as only a handful of
>> >   data placement buckets are supported
>>
>> I could understand from your presentation at LPC, and late looking at the code that
>> is available that you have been successful at getting good results with the existing
>> interface in XFS. The mapping form the temperature semantics to zones (no semantics)
>> is the exact same as we are doing with FDP. Not having to change neither in-kernel  nor user-space
>> structures is great.
>
>No, we don't map data directly to zones using lifetime hints. In fact,
>lifetime hints contribute only a
>relatively small part  (~10% extra write amp reduction, see the
>rocksdb benchmark results).
>Segregating data by file is the most important part of the data
>placement heuristic, at least
>for this type of workload.

Is this because RocksDB already does seggregation per file itself? Are
you doing something specific on XFS or using your knoledge on RocksDB to
map files with an "unwritten" protocol in the midde?

    In this context, we have collected data both using FDP natively in
    RocksDB and using the temperatures. Both look very good, because both
    are initiated by RocksDB, and the FS just passes the hints directly
    to the driver.

I ask this to understand if this is the FS responsibility or the
application's one. Our work points more to letting applications use the
hints (as the use-cases are power users, like RocksDB). I agree with you
that a FS could potentially make an improvement for legacy applications
- we have not focused much on these though, so I trust you insights on
it.

>>
>> >
>> > * It just won't work if there is more than one user application per storage
>> >   device as different applications data streams will be mixed at the nvme
>> >   driver level..
>>
>> For now this use-case is not clear. Folks working on it are using passthru. When we
>> have a more clear understanding of what is needed, we might need changes in the kernel.
>>
>> If you see a need for this on the work that you are doing, by all means, please send patches.
>> As I said at LPC, we can work together on this.
>>
>> >
>> > While Christoph has already outlined what would be desirable from a
>> > file system point of view, I don't have the answer to what would be the overall
>> > best design for FDP. I would like to say that it looks to me like we need to
>> > consider more than more than the early adoption use cases and make sure we
>> > make the most of the hardware capabilities via logical abstractions that
>> > would be compatible with a wider range of storage devices.
>> >
>> > Figuring the right way forward is tricky, but why not just let it take the time
>> > that is needed to sort this out while early users explore how to use FDP
>> > drives and share the results?
>>
>> I agree that we might need a new interface to support more hints, beyond the temperatures.
>> Or maybe not. We would not know until someone comes with a use case. We have made the
>> mistake in the past of treating internal research as upstreamable work. I know can see that
>> this simply complicates the in-kernel and user-space APIs.
>>
>> The existing API is usable and requires no changes. There is hardware. There are customers.
>> There are applications with upstream support which have been tested with passthru (the
>> early results you mention). And the wiring to NVMe is _very_ simple. There is no reason
>> not to take this in, and then we will see what new interfaces we might need in the future.
>>
>> I would much rather spend time in discussing ideas with you and others on a potential
>> future API than arguing about the validity of an _existing_ one.
>>
>
>Yes, but while FDP support could be improved later on(happy to help if
>that'll be the case),
>I'm just afraid that less work now defining the way data placement is
>exposed is going to
>result in a bigger mess later when more use cases will be considered.

Please, see the message I responded on the other thread. I hope it is a
way to move forward and actually work together on this.


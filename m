Return-Path: <io-uring+bounces-3556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 805DA9985E1
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 14:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DED11B22C09
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 12:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5731C4611;
	Thu, 10 Oct 2024 12:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dBV47omE"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9991F1C4600
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 12:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728563260; cv=none; b=aiR3oJGC8Et+b9bNyIWDSkMDTzZEEFW8GujVsEeTJNMLWlzrDaMujkd069hVLmfUgdGDAIWAfh1GWwf2CU2i6pKxt1KRq0SfmL5her5FgU69Uaw6Ip7z/46P7l5oeA8hNAkD9+I0CaCG7Gh8scZmnF6zJAxcPvS644Aws5N8j6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728563260; c=relaxed/simple;
	bh=7pvSK7FROzKjPIY8zElnfb1QuG/2355drsy6CCiECso=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=moLdAhDU9s6zioxKh/n7b+YJlctuf0FTcLogolnlL1l7Z53NGA7xYC+VBTw388DiWbDWLUz+AG8jc0v1HqaZXM7ptArNU+VJ8/ujfXLVeeJivCq6EgXW1+TRge4o2gTliHfMPPW/x7+YdY44WIT1E5ROXV/sJ/klcCL2QqbLnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dBV47omE; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241010122735euoutp0128187b1608cd59bd60862d7657c01480~9Fx9vIF7O1315313153euoutp01j
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 12:27:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241010122735euoutp0128187b1608cd59bd60862d7657c01480~9Fx9vIF7O1315313153euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728563255;
	bh=V1EbV5RF/b+q3U2dC0GX22ZpwFGw23PkSeb0C1Oyig4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=dBV47omEWD58kuxIAFieVtXxWPhamRrpzvNA49enMArdBd1Mf/RQY3f/Iw2uRkfwD
	 GRNFFpWldbYRORZlU5EQ5Rdob2AG0Qe2IqlHoe/HUCXlFP+q7p26B1byCtW1uC2dGB
	 gKdqQKI3/VFN1Lhm7OlY2EAsVJhOnWfAIdcMT56g=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241010122735eucas1p21fafd7ad35f704835c1c1b899b3bea90~9Fx9RvEuB2400124001eucas1p2X;
	Thu, 10 Oct 2024 12:27:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 46.FA.09875.738C7076; Thu, 10
	Oct 2024 13:27:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1~9Fx8yf8QP2782427824eucas1p1v;
	Thu, 10 Oct 2024 12:27:34 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241010122734eusmtrp293fdbe95a7f364fbccd935d65aae8ce6~9Fx8xmmI71164111641eusmtrp2p;
	Thu, 10 Oct 2024 12:27:34 +0000 (GMT)
X-AuditID: cbfec7f4-131ff70000002693-32-6707c837571b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 7D.AE.14621.638C7076; Thu, 10
	Oct 2024 13:27:34 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010122734eusmtip26896dbfd46824c0cba0772db4b33fcf0~9Fx8mK87q1094610946eusmtip2Y;
	Thu, 10 Oct 2024 12:27:34 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 10 Oct 2024 13:27:33 +0100
Date: Thu, 10 Oct 2024 14:27:33 +0200
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
Message-ID: <20241010122733.bv7vxemqnxr573pz@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANr-nt2=Lee8B94DMPY6yDaGaBD=Lt9qdG2TzGhAwU=ddZxckg@mail.gmail.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0xTVxTHua+vr4+6lkdh80bcWLrhHzopM2O7ihVNUJ9xydiyGOPioJGX
	SixgWn5sssVCp6vdYE2RGopTapBiuyEUijRTlrRzhQpWEcbGgMwNMi1SoKCbE9tBX93473PO
	93zvOd/kkhxRFbGGzC8sZpSFMoWY4OOdPz72bXyrhydPq/6Ti85aOwGyjX1FIF2oA0dT7iBA
	xtnHHBSofIKjr2ttXHT1ggFDl2zXMRQ4cRNH9Wc0GJq4bOIgg+sngE4bKwG6NrIBXb3Wi6Pz
	TZM8ZPGEMNQyNYMj31MPd3sifWdwL+00jfFo33gbTt/pL6Ht1lMEbQ8aeHR743H6u1/UBD03
	OYLTbvsFLj3TPUTQfQ0/LIk3yul5+0u0fWIay447wN+axyjySxmlZFsu//DYlTB2VL/no1m/
	i1CDoc06EEtC6g3oGO0COsAnRVQzgNP373PYYgFA22J1tJgHsE59mXhmmR+6FBUsAJoe+PD/
	pm4OzBNs0bH02EI9b9mCUynwe/1FsMwEJYHWK94IJ1LrYP89LbZs4FCPePDzBm1ESKDS4Mxf
	VZF9AkoKbwcCHJbjYW/dBL7MHGoLPDVbydUBcomToCVEsu1kqHHUR8ZjqXdhQ+M4jz1bDP+4
	Nw1Y/hR6O0YieyFVx4dtNcaokAVDt91clhOg39MRNa+FYed5jOVyqO7tiZo/A/CE1hE5AlIZ
	sLpPwc7sgKEhK8G2hfDn6Xj2NiE0dJ7hsG0B1J4U6cGrphXBTCuCmf4PZloRrAHgVrCaKVEV
	yBnVpkKmLFUlK1CVFMpTDxUV2MHSj70R8ix0AYt/LtUFMBK4ACQ54kTBRjNXLhLkyT4+xiiL
	cpQlCkblAkkkLl4tSMlLZkSUXFbMHGGYo4zymYqRsWvUmGJ4/+LOGEFcVpE/ZrxdbXE0HWtP
	tqY0ZptH4z23FGTu83+TrWsz19ev89Tpyz54dFcpwcqSzsW1ZLqEvz3sf2dzc3XFVHvm6BfD
	0m8lDxy5B3yCc2Gp2qIpfntuX/Y+STN3j029bST9nyyH8/rsoSMf9kj3b38FfKLpCh4MWlsz
	wicHtItyh3lQ3rLr6a3jZ1OE+YZVjjLuaeJu6QtvOoM1rZu0oQ2lmRpfbVWieWfFVp0+5uDu
	91+WPvfrN0b3Q7EFk2TkgPJVZqpC/2K6cMdr7kDsQFtNuqp7Ekvbsiun22+86Bse3Pv77vf4
	Xq8hgfE21QSHn7RQfU7ll+FaRoyrDsteX89RqmT/Aml1LuUgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t/xe7pmJ9jTDf7M17CYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWMyduprVYs+iSUwWK1cfZbJ413qOxWL29GYmiyfrZzFb
	TDp0jdFiyrQmRou9t7Qt9uw9yWIxf9lTdovlx/8xWax7/Z7F4vzf46wOIh6Xr3h77Jx1l93j
	/L2NLB6Xz5Z6bFrVyeax6dMkdo/NS+o9dt9sYPP4+PQWi8fhTYtYPd7vu8rmcWbBEaDk6WqP
	z5vkPDY9ecsUwB+lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZ
	llqkb5egl3F3+3+mggmeFR9eHWJrYLxq2cXIySEhYCLx+epK5i5GLg4hgaWMEp2Nd5khEjIS
	G79cZYWwhSX+XOtigyj6yCjR0vWCBcLZwijxrbMNrIpFQFVi/4SljCA2m4C+xKrtp8BsEQE1
	ibMvOphAGpgFvrFLtC/oAEsICxhIvP/eywZi8wrYSlx89w7qjnUsEtefvGSCSAhKnJz5hAXE
	ZhawkJg5/zxQMweQLS2x/B8HRFheonnrbLCzOQUCJRYsuccOcbaSxOMXbxkh7FqJz3+fMU5g
	FJmFZOosJFNnIUydhWTqAkaWVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIEpaNuxn5t3MM57
	9VHvECMTB+MhRgkOZiURXt2FrOlCvCmJlVWpRfnxRaU5qcWHGE2BYTSRWUo0OR+YBPNK4g3N
	DEwNTcwsDUwtzYyVxHndLp9PExJITyxJzU5NLUgtgulj4uCUamDav804wMrB8X6Ljghn0tfQ
	K3dfbFzG92dfwWEGV4tnMqka51f5tgdWbhVYlf879FBe+U7umq1lsU2LbRf0fGPefWZFYuPi
	nHoe9bmWS2/XbFn3fpNBleTVT1N+qEwTLHtmnGUzc65N9xnN6H6pWV9CJQpC13R9Npm/5g3X
	nMXLlq7+sSg1e/0VjaVq203rjv6/HfPv5526OW7sr8qFLyYXHT5ldfxM4w69A5uZat75LWJf
	IOyes13yjSFH8v+0wtjTXz5esJ2vOHG1W/C8ydPOrI34WnSabdKBD6v3MvStFTG4weKevafk
	+K2T8m5P2w279BP0LrkbKv1YEThflUXtV3fu+ZqfFmVaRxwjJGe6KrEUZyQaajEXFScCAKRK
	f9jKAwAA
X-CMS-MailID: 20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1
X-Msg-Generator: CA
X-RootMTR: 20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1
References: <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
	<20241004062733.GB14876@lst.de>
	<20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
	<20241004123027.GA19168@lst.de>
	<20241007101011.boufh3tipewgvuao@ArmHalley.local>
	<CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com>
	<97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local>
	<CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com>
	<20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
	<CANr-nt2=Lee8B94DMPY6yDaGaBD=Lt9qdG2TzGhAwU=ddZxckg@mail.gmail.com>
	<CGME20241010122734eucas1p1e20a5263a4d69db81b50b8b03608fad1@eucas1p1.samsung.com>

On 10.10.2024 12:46, Hans Holmberg wrote:
>On Thu, Oct 10, 2024 at 9:13 AM Javier Gonzalez <javier.gonz@samsung.com> wrote:
>>
>> On 10.10.2024 08:40, Hans Holmberg wrote:
>> >On Wed, Oct 9, 2024 at 4:36 PM Javier Gonzalez <javier.gonz@samsung.com> wrote:
>> >>
>> >>
>> >>
>> >> > -----Original Message-----
>> >> > From: Hans Holmberg <hans@owltronix.com>
>> >> > Sent: Tuesday, October 8, 2024 12:07 PM
>> >> > To: Javier Gonzalez <javier.gonz@samsung.com>
>> >> > Cc: Christoph Hellwig <hch@lst.de>; Jens Axboe <axboe@kernel.dk>; Martin K.
>> >> > Petersen <martin.petersen@oracle.com>; Keith Busch <kbusch@kernel.org>;
>> >> > Kanchan Joshi <joshi.k@samsung.com>; hare@suse.de; sagi@grimberg.me;
>> >> > brauner@kernel.org; viro@zeniv.linux.org.uk; jack@suse.cz; jaegeuk@kernel.org;
>> >> > bcrl@kvack.org; dhowells@redhat.com; bvanassche@acm.org;
>> >> > asml.silence@gmail.com; linux-nvme@lists.infradead.org; linux-
>> >> > fsdevel@vger.kernel.org; io-uring@vger.kernel.org; linux-block@vger.kernel.org;
>> >> > linux-aio@kvack.org; gost.dev@samsung.com; vishak.g@samsung.com
>> >> > Subject: Re: [PATCH v7 0/3] FDP and per-io hints
>> >> >
>> >> > On Mon, Oct 7, 2024 at 12:10 PM Javier González <javier.gonz@samsung.com>
>> >> > wrote:
>> >> > >
>> >> > > On 04.10.2024 14:30, Christoph Hellwig wrote:
>> >> > > >On Fri, Oct 04, 2024 at 08:52:33AM +0200, Javier González wrote:
>> >> > > >> So, considerign that file system _are_ able to use temperature hints and
>> >> > > >> actually make them work, why don't we support FDP the same way we are
>> >> > > >> supporting zones so that people can use it in production?
>> >> > > >
>> >> > > >Because apparently no one has tried it.  It should be possible in theory,
>> >> > > >but for example unless you have power of 2 reclaim unit size size it
>> >> > > >won't work very well with XFS where the AGs/RTGs must be power of two
>> >> > > >aligned in the LBA space, except by overprovisioning the LBA space vs
>> >> > > >the capacity actually used.
>> >> > >
>> >> > > This is good. I think we should have at least a FS POC with data
>> >> > > placement support to be able to drive conclusions on how the interface
>> >> > > and requirements should be. Until we have that, we can support the
>> >> > > use-cases that we know customers are asking for, i.e., block-level hints
>> >> > > through the existing temperature API.
>> >> > >
>> >> > > >
>> >> > > >> I agree that down the road, an interface that allows hints (many more
>> >> > > >> than 5!) is needed. And in my opinion, this interface should not have
>> >> > > >> semintics attached to it, just a hint ID, #hints, and enough space to
>> >> > > >> put 100s of them to support storage node deployments. But this needs to
>> >> > > >> come from the users of the hints / zones / streams / etc,  not from
>> >> > > >> us vendors. We do not have neither details on how they deploy these
>> >> > > >> features at scale, nor the workloads to validate the results. Anything
>> >> > > >> else will probably just continue polluting the storage stack with more
>> >> > > >> interfaces that are not used and add to the problem of data placement
>> >> > > >> fragmentation.
>> >> > > >
>> >> > > >Please always mentioned what layer you are talking about.  At the syscall
>> >> > > >level the temperatur hints are doing quite ok.  A full stream separation
>> >> > > >would obviously be a lot better, as would be communicating the zone /
>> >> > > >reclaim unit / etc size.
>> >> > >
>> >> > > I mean at the syscall level. But as mentioned above, we need to be very
>> >> > > sure that we have a clear use-case for that. If we continue seeing hints
>> >> > > being use in NVMe or other protocols, and the number increase
>> >> > > significantly, we can deal with it later on.
>> >> > >
>> >> > > >
>> >> > > >As an interface to a driver that doesn't natively speak temperature
>> >> > > >hint on the other hand it doesn't work at all.
>> >> > > >
>> >> > > >> The issue is that the first series of this patch, which is as simple as
>> >> > > >> it gets, hit the list in May. Since then we are down paths that lead
>> >> > > >> nowhere. So the line between real technical feedback that leads to
>> >> > > >> a feature being merged, and technical misleading to make people be a
>> >> > > >> busy bee becomes very thin. In the whole data placement effort, we have
>> >> > > >> been down this path many times, unfortunately...
>> >> > > >
>> >> > > >Well, the previous round was the first one actually trying to address the
>> >> > > >fundamental issue after 4 month.  And then after a first round of feedback
>> >> > > >it gets shutdown somehow out of nowhere.  As a maintainer and review that
>> >> > > >is the kinda of contributors I have a hard time taking serious.
>> >> > >
>> >> > > I am not sure I understand what you mean in the last sentece, so I will
>> >> > > not respond filling blanks with a bad interpretation.
>> >> > >
>> >> > > In summary, what we are asking for is to take the patches that cover the
>> >> > > current use-case, and work together on what might be needed for better
>> >> > > FS support. For this, it seems you and Hans have a good idea of what you
>> >> > > want to have based on XFS. We can help review or do part of the work,
>> >> > > but trying to guess our way will only delay existing customers using
>> >> > > existing HW.
>> >> >
>> >> > After reading the whole thread, I end up wondering why we need to rush the
>> >> > support for a single use case through instead of putting the architecture
>> >> > in place for properly supporting this new type of hardware from the start
>> >> > throughout the stack.
>> >>
>> >> This is not a rush. We have been supporting this use case through passthru for
>> >> over 1/2 year with code already upstream in Cachelib. This is mature enough as
>> >> to move into the block layer, which is what the end user wants to do either way.
>> >>
>> >> This is though a very good point. This is why we upstreamed passthru at the
>> >> time; so people can experiment, validate, and upstream only when there is a
>> >> clear path.
>> >>
>> >> >
>> >> > Even for user space consumers of raw block devices, is the last version
>> >> > of the patch set good enough?
>> >> >
>> >> > * It severely cripples the data separation capabilities as only a handful of
>> >> >   data placement buckets are supported
>> >>
>> >> I could understand from your presentation at LPC, and late looking at the code that
>> >> is available that you have been successful at getting good results with the existing
>> >> interface in XFS. The mapping form the temperature semantics to zones (no semantics)
>> >> is the exact same as we are doing with FDP. Not having to change neither in-kernel  nor user-space
>> >> structures is great.
>> >
>> >No, we don't map data directly to zones using lifetime hints. In fact,
>> >lifetime hints contribute only a
>> >relatively small part  (~10% extra write amp reduction, see the
>> >rocksdb benchmark results).
>> >Segregating data by file is the most important part of the data
>> >placement heuristic, at least
>> >for this type of workload.
>>
>> Is this because RocksDB already does seggregation per file itself? Are
>> you doing something specific on XFS or using your knoledge on RocksDB to
>> map files with an "unwritten" protocol in the midde?
>
>Data placement by-file is based on that the lifetime of a file's data
>blocks are strongly correlated. When a file is deleted, all its blocks
>will be reclaimable at that point. This requires knowledge about the
>data placement buckets and works really well without any hints
>provided.

But we need hints to put files together. I believe you do this already,
as no placement protocol gives you unlimited separation.

>The life-time hint heuristic I added on top is based on rocksdb
>statistics, but designed to be generic enough to work for a wider
>range of workloads (still need to validate this though - more work to
>be done).

Maybe you can post some patches on the parts dedicated to the VFS level
and user-space API (syscall or uring)?

Following on the comment to Christoph, it would be good to have
something tangible to work together on for the next stage of this
support.

>
>>
>>     In this context, we have collected data both using FDP natively in
>>     RocksDB and using the temperatures. Both look very good, because both
>>     are initiated by RocksDB, and the FS just passes the hints directly
>>     to the driver.
>>
>> I ask this to understand if this is the FS responsibility or the
>> application's one. Our work points more to letting applications use the
>> hints (as the use-cases are power users, like RocksDB). I agree with you
>> that a FS could potentially make an improvement for legacy applications
>> - we have not focused much on these though, so I trust you insights on
>> it.
>
>The big problem as I see it is that if applications are going to work
>well together on the same media we need a common placement
>implementation somewhere, and it seems pretty natural to make it part
>of filesystems to me.

For FS users, makes a lot of sense. But we still need to cover
applications using raw block.



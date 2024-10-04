Return-Path: <io-uring+bounces-3405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7096098FD36
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 814761C22662
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E7C7581F;
	Fri,  4 Oct 2024 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AixW3yde"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA85856458
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728022699; cv=none; b=pleJORWo0JhQe2enIoYJm0U1F8MUXVA1tRmmz32aTVFrZPAM3VqWwYMbxKD/Pz0nrbB4Pygi60YRtOe8zJ186HVue+UhlUyqsxbqLST8pV7mJgXvrt8silvyu0vmvMsp1rr2sBWn+S4gurolW93Yy7A4PFwW53rERhSpSIi7dZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728022699; c=relaxed/simple;
	bh=LISMMfZsl3SzS4mMH6eteM95PV8y951IzxtydYD0/38=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=Md8xsD3PaMGlGygESPUEIacAk6SDWjAxGbYtzEpTf06pISkJ5AFeK0eXXkf4tX+A7bg/Esgqb2klXd961itQKA59dE0WLlVaTC29Ny3Sv3FhWMJCU0lF3Rq8f3hOlk8nhowpd8unnQP7ItOWgzsgs/2gcu9F1cFOGpGYqGqsDbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AixW3yde; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241004061814euoutp01290c756ebc7d9a8043dfa1efd30bd38a~7K3wtVfV61639016390euoutp01c
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:18:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241004061814euoutp01290c756ebc7d9a8043dfa1efd30bd38a~7K3wtVfV61639016390euoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728022694;
	bh=N8dITL1kHc6W8YX1UsmA9fL9b8U2xKIfDcf2sm4NReg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=AixW3ydeHfJXYRSV30nWIxmhUhtdC4m3337O0VixFSOhLqtYkKpa+MXacTmvSWj9j
	 A0Tg+bPa1/46h5+jBSoZSjgLcfSdYPe+LQhyb/RHLeqeHgaM4EkYEd0zh+YcNm/JnK
	 o0mmuHP36j+DIRwBI+3RJ8Xafoq8wfM/m3T34lAA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241004061813eucas1p1c39751fe563057a80554224b8a5838c7~7K3wUMbwv2159121591eucas1p17;
	Fri,  4 Oct 2024 06:18:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 85.72.09620.5A88FF66; Fri,  4
	Oct 2024 07:18:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241004061813eucas1p2ec0cfeb35f4e3572abbc2692b0f76475~7K3v08ro42040020400eucas1p2i;
	Fri,  4 Oct 2024 06:18:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241004061813eusmtrp2f8d3996791742922c0117f7d154a7851~7K3v0MKlI1357313573eusmtrp2I;
	Fri,  4 Oct 2024 06:18:13 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-2e-66ff88a5f2b5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 5F.5E.14621.5A88FF66; Fri,  4
	Oct 2024 07:18:13 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241004061813eusmtip14c2f886b84530a1b5d11c1f5f377d456~7K3vlZ0cO1746417464eusmtip1Z;
	Fri,  4 Oct 2024 06:18:13 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 4 Oct 2024 07:18:12 +0100
Date: Fri, 4 Oct 2024 08:18:11 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>, Kanchan Joshi
	<joshi.k@samsung.com>, <hare@suse.de>, <sagi@grimberg.me>,
	<brauner@kernel.org>, <viro@zeniv.linux.org.uk>, <jack@suse.cz>,
	<jaegeuk@kernel.org>, <bcrl@kvack.org>, <dhowells@redhat.com>,
	<bvanassche@acm.org>, <asml.silence@gmail.com>,
	<linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-aio@kvack.org>, <gost.dev@samsung.com>, <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <20241004053121.GB14265@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7djP87pLO/6nGSzvNbGYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	FJdNSmpOZllqkb5dAlfG9oWSBQ/FKhb3X2duYPwv2MXIySEhYCLR/e8+YxcjF4eQwApGifvv
	G5ggnC+MEhd2b2WFcD4zSiycMIcdpuX60tlQLcsZJXoXfkOomv1rN5SzmVHi0PulYC0sAioS
	m34tZgax2QTsJS4tuwVmiwgoSTx9dRZsFLPAIRaJLwfmgzUICxhIvP/eywZi8wrYSmw89gnK
	FpQ4OfMJC4jNLGAl0fmhCWgbB5AtLbH8HwdImFNAR+Lx6cesEKcqSTx+8ZYRwq6VOLXlFthz
	EgLfOCWWz/zCBpFwkVh4dBoThC0s8er4Fqg/ZST+75wPFa+WaDh5Aqq5hVGitWMr2GIJAWuJ
	vjM5EDWOEq+m/2SHCPNJ3HgrCHEmn8SkbdOZIcK8Eh1tQhDVahKr771hmcCoPAvJY7OQPDYL
	4bEFjMyrGMVTS4tz01OLjfNSy/WKE3OLS/PS9ZLzczcxApPm6X/Hv+5gXPHqo94hRiYOxkOM
	EhzMSiK887b/TRPiTUmsrEotyo8vKs1JLT7EKM3BoiTOq5oinyokkJ5YkpqdmlqQWgSTZeLg
	lGpgWvfV+5fEj2M9N0Oua1+siJl/TMN3tuKZxet4tk/WMtoY6sQdIN4l+8vpd9klG9Wfu9f/
	0783/Y7ipuiWyJUljxctnzG1eOLp/6q7dsyT5y/YqP45YQL7u9u/9l49vP7o9DXzLJzUXh7k
	c0pPdfJMjFmb8OHZfsvK3fFvQ18tniT+58beBWyV2/zOXJ5mtuzDiZIHL1dsvm3mabH9y38Z
	B31p2WMP+rdN2VHTGrLzw4/FH4/3VbqaL17Ls2+hg7vRzDkXbB773hCXbfunHSS0OulyJbvP
	/OvnbLOXf5py1ny+2DzbGrHyrWphKmxLHl8Ik1A7+n7rvdq0F54tnL6FSV7Tb/0w5L/0dPMr
	vXPn9MrMlViKMxINtZiLihMB183kfgkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t/xu7pLO/6nGcz+I2gxZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2M7Qsl
	Cx6KVSzuv87cwPhfsIuRk0NCwETi+tLZjF2MXBxCAksZJebfWsMEkZCR2PjlKiuELSzx51oX
	G0TRR0aJO2sOQTmbGSV6b61kB6liEVCR2PRrMTOIzSZgL3Fp2S0wW0RASeLpq7NgK5gFDrFI
	fDkwH6xBWMBA4v33XjYQm1fAVmLjsU9QU08zS2ztvcoCkRCUODnzCZjNLGAhMXP+eaBJHEC2
	tMTyfxwgYU4BHYnHpx9Dnaok8fjFW0YIu1bi899njBMYhWchmTQLyaRZCJMWMDKvYhRJLS3O
	Tc8tNtQrTswtLs1L10vOz93ECEwe24793LyDcd6rj3qHGJk4GA8xSnAwK4nwztv+N02INyWx
	siq1KD++qDQntfgQoykwLCYyS4km5wPTV15JvKGZgamhiZmlgamlmbGSOK/b5fNpQgLpiSWp
	2ampBalFMH1MHJxSDUzbrjhWnyzkrbt4qNA1eOqcn7VH23wFd0ZN9NZm1bE6dbz76o/e27MX
	fL7IcnxVQaDzqidLFtycfvLS6lV5mhZvr8vqGB7peHvydrn47y8rve44f3Yx2yDwYE2fREz4
	RLPbKm3ry59N5upN2Xe85Yn42/jEnDY3l4mXDbu3Hqq1ikmvc+jUb7g7c/oz646t8QuYo/JC
	f2yPLOW5P6N2yVq3xKQJ7x9UTC6yeFNcqvzC+4RQxZldXe5Cf2J1VlxYMfn8uZ35rnYf79pN
	ylJ2iDtaWX+bZUHx4vk/3F0fJj3reTlnmwNHiWKxhuOCFunCKXXsd6YvStgr5a5qoXFuV8ar
	DaXG1z5da3M07lWezPBNiaU4I9FQi7moOBEAO04AEqcDAAA=
X-CMS-MailID: 20241004061813eucas1p2ec0cfeb35f4e3572abbc2692b0f76475
X-Msg-Generator: CA
X-RootMTR: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
References: <20241002075140.GB20819@lst.de>
	<f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
	<20241002151344.GA20364@lst.de>
	<Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
	<20241003125400.GB17031@lst.de>
	<c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
	<CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
	<20241004053121.GB14265@lst.de>

On 04.10.2024 07:31, Christoph Hellwig wrote:
>On Thu, Oct 03, 2024 at 04:14:57PM -0600, Jens Axboe wrote:
>> On 10/3/24 6:54 AM, Christoph Hellwig wrote:
>> > For file: yes.  The problem is when you have more files than buckets on
>> > the device or file systems.  Typical enterprise SSDs support somewhere
>> > between 8 and 16 write streams, and there typically is more data than
>> > that.  So trying to group it somehow is good idea as not all files can
>> > have their own bucket.
>> >
>> > Allowing this inside a file like done in this patch set on the other
>> > hand is pretty crazy.
>>
>> I do agree that per-file hints are not ideal. In the spirit of making
>> some progress, how about we just retain per-io hints initially? We can
>> certainly make that work over dio. Yes buffered IO won't work initially,
>> but at least we're getting somewhere.
>
>Huh?  Per I/O hints at the syscall level are the problem (see also the
>reply from Martin).  Per file make total sense, but we need the file
>system in control.
>
>The real problem is further down the stack.  For the SCSI temperature
>hints just passing them on make sense.  But when you map to some kind
>of stream separation in the device, no matter if that is streams, FDP,
>or various kinds of streams we don't even support in thing like CF
>and SDcard, the driver is not the right place to map temperature hint
>to streams.  The requires some kind of intelligence.  It could be
>dirt simple and just do a best effort mapping of the temperature
>hints 1:1 to separate write streams, or do a little mapping if there
>is not enough of them which should work fine for a raw block device.
>
>But one we have a file system things get more complicated:
>
> - the file system will want it's own streams for metadata and GC
> - even with that on beefy enough hardware you can have more streams
>   then temperature levels, and the file system can and should
>   do intelligen placement (based usually on files)
>
>Or to summarize:  the per-file temperature hints make sense as a user
>interface.  Per-I/O hints tend to be really messy at least if a file
>system is involved.  Placing the temperatures to separate write streams
>in the driver does not scale even to the most trivial write stream
>>
>And for anyone who followed the previous discussions of the patches
>none of this should been new, each point has been made at least three
>times before.

Looking at the work you and Hans have been doing on XFS, it seems you
have been successful at mapping the semantics of the temperature to
zones (which has no semantics, just as FDP).

    What is the difference between the mapping in zones and for FDP?

The whole point is using an existing interface to cover the use-case of
people wanting hints in block. If you have a use-case for enabling hints
on file, let's work on this aftterwards.




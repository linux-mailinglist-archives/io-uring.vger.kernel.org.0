Return-Path: <io-uring+bounces-4297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F39849B8CE4
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 09:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E100B22D75
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 08:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262B1156C69;
	Fri,  1 Nov 2024 08:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nezja3Uy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED4A14D29B
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730449161; cv=none; b=sPE9uhoG1lrqPWb2gkPMA1ouBniH37sP+J1iVtUAcjOSjwuFYcUUuJYVKI07UeoNhtBy4P84BO9MrF6KOuHJMJFjGDzEHNxb5ougmuB8YgpV4OB8lJZrRFpGUKarXzHhmFYwsbbcrhRMyk5aByFMxyJ4KzVKKYc3I1awhheSMk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730449161; c=relaxed/simple;
	bh=IBxCMaTDMwMv7TecQhch3IN0C/Pthjqbj5pJgfI0Dyc=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=qni2sfU2Maxmtaem4g3SayDAp78/yrGgS5+2M5i+m/OGOwwcqWeqF+/4gUkAv4MGCnegLRPvuQ8ReWP5VsBMvRD72NgMgLIbfnTQuOYIQE1Q83fBCHOzG14La4FW6Jb1O+yRRY/TFsRC2nPSwSnl2vvxSwuq5cfdSni1kGtn03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nezja3Uy; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241101081915euoutp0162f9652cbbbe1a26e5a4737e192540d5~Dyla7A-OR1379213792euoutp01O
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 08:19:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241101081915euoutp0162f9652cbbbe1a26e5a4737e192540d5~Dyla7A-OR1379213792euoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730449155;
	bh=u0t4feekxOIswH/gya5PvM4rWukDuX0GEL28uYYRBHM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=nezja3UyPadsbJdJFB1BbxfY/LoWbOzC3yTYYCVFi039jTrjHEOildnT6DXmFGDbD
	 Nu03N73Hf3GUbuYoyYM4I5skLr/WSxhgAC6p59YfchgZhI3wbr8p1ZQ8wp9re0Yx3p
	 QjbL6r38IvQP4B9ogJn2SxY4kqrcX/WyWXgacEbk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241101081915eucas1p2c8a05e9da2bb94096e29e2c99dc460cc~DylapO37t0479604796eucas1p2O;
	Fri,  1 Nov 2024 08:19:15 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 72.23.20821.30F84276; Fri,  1
	Nov 2024 08:19:15 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241101081914eucas1p269f6f4d515aa0db81f4fb03cd3ae64d7~DylZ8gtLF3182931829eucas1p2Y;
	Fri,  1 Nov 2024 08:19:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241101081914eusmtrp24265f317813388cfa225d1254c009a9b~DylZ73QdP2944729447eusmtrp2G;
	Fri,  1 Nov 2024 08:19:14 +0000 (GMT)
X-AuditID: cbfec7f2-b09c370000005155-7a-67248f038fa3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 47.C0.19654.20F84276; Fri,  1
	Nov 2024 08:19:14 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241101081914eusmtip2b586a3684238513b723c7a4ad1e26a71~DylZxysUn0659906599eusmtip2a;
	Fri,  1 Nov 2024 08:19:14 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 1 Nov 2024 08:19:13 +0000
Date: Fri, 1 Nov 2024 09:19:12 +0100
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Hans Holmberg <hans@owltronix.com>
CC: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, "Keith
 Busch" <kbusch@meta.com>, <linux-block@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<joshi.k@samsung.com>, <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
Message-ID: <20241101081912.kvixtd6mattjemxk@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsWy7djPc7rM/SrpBrO2CVlM+/CT2WLu1NWs
	FnsWTWKyWLn6KJPFu9ZzLBaTDl1jtDhzdSGLxd5b2hZ79p5ksZi/7Cm7Rff1HWwO3B6Xr3h7
	bFrVyeaxeUm9x+6bDWwe5y5WeBzetIjVY/Ppao/Pm+QCOKK4bFJSczLLUov07RK4MjbO+c9W
	cJar4sFCqwbGvRxdjJwcEgImEh3LXrJ0MXJxCAmsYJTYfe4zlPOFUaL9xGlGCOczo8TCz8dZ
	YVr2XbvABpFYzihxaGoDC1zV/KvnoDKbGSWuv3zIDNLCIqAi0fdhPSOIzSZgL3Fp2S2wuIiA
	msTZFx1MIDazwFUmifcPwOLCAj4S29d/YgOxeQVsJc7f7WKFsAUlTs58wgJRbyXR+aEJKM4B
	ZEtLLP8H9hCnQKDE/6efmSEuVZJ4/OItI4RdK3Fqyy0mkNskBPo5JY4vPQtV5CLxoncRE4Qt
	LPHq+BZ2CFtG4v/O+VDxaomGkyegmlsYJVo7toItlhCwlug7kwNR4yix+tgvZogwn8SNt4IQ
	Z/JJTNo2HSrMK9HRJgRRrSax+t4blgmMyrOQPDYLyWOzEB5bwMi8ilE8tbQ4Nz212DAvtVyv
	ODG3uDQvXS85P3cTIzBNnf53/NMOxrmvPuodYmTiYDzEKMHBrCTC+6FAOV2INyWxsiq1KD++
	qDQntfgQozQHi5I4r2qKfKqQQHpiSWp2ampBahFMlomDU6qBKdZWWtn+1Ff+y2tmX3/axmx6
	8Er3ir0Fv190l55NOOv8+VH5bwvPlIeuVYxLtsetSsrzyQ89U/3nSEbrdM09LQGqD/4Kveq0
	+Pn6yStx6QfZtQ2ejpvZ9xgtUP21Yves18xP0o6pC+VLpOx9/7pFL/Nfm+6m8+E9k99Mszbh
	lvRP3hn9WOtBwNObEc/Fp1uypVUITWdWkT800adP5NOX/2eaJKdsqSj/8W3V20n6O+0d/s1b
	qHc3TqtS8IjyqclT+T7xnjeL4eCpsTF1qvjnZfuyc0e088HT76dM92DS9I5zii9LaL469YKc
	J8fzDGO39e4xp5vWei64tOYLW3aO+Hc9aat9al0FAVMOcKYfUmIpzkg01GIuKk4EAP8jPTfC
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7pM/SrpBpvblS2mffjJbDF36mpW
	iz2LJjFZrFx9lMniXes5FotJh64xWpy5upDFYu8tbYs9e0+yWMxf9pTdovv6DjYHbo/LV7w9
	Nq3qZPPYvKTeY/fNBjaPcxcrPA5vWsTqsfl0tcfnTXIBHFF6NkX5pSWpChn5xSW2StGGFkZ6
	hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6dgl6GRvn/GcrOMtV8WChVQPjXo4uRk4OCQET
	iX3XLrB1MXJxCAksZZSY/+koK0RCRmLjl6tQtrDEn2tdUEUfGSXWL7jMDOFsZpT4tmclE0gV
	i4CKRN+H9YwgNpuAvcSlZbeYQWwRATWJsy86wGqYBa4ySbx/ABYXFvCR2L7+ExuIzStgK3H+
	bhcrxNDFLBJvlm6GSghKnJz5hAWi2UJi5vzzQAs4gGxpieX/wF7gFAiU+P/0MzPEpUoSj1+8
	ZYSwayU+/33GOIFReBaSSbOQTJqFMGkBI/MqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwHjd
	duznlh2MK1991DvEyMTBeIhRgoNZSYT3Q4FyuhBvSmJlVWpRfnxRaU5q8SFGU2BQTGSWEk3O
	ByaMvJJ4QzMDU0MTM0sDU0szYyVxXrYr59OEBNITS1KzU1MLUotg+pg4OKUamMzvPHHZ/mia
	lfjvmkfnt3lxG99vKuJ4zOf9+UpJ+vbaOW++JV+Ycfu76/XcnWt9/zx1uf5WMfZpXWscy+2z
	Dqy8xeFnut5siHeo469RTs4QOzc3m+HewQv8vb9PS63lmbD2wewZ1XsS/7OsX/Ob16t2me+k
	4NWGQi8Ozducu2LtdNYIvVVrVJ49Eu9SmGJ7aMY+Zr0DDDvvpDKmmHp2Kz4tyF7Nlxm55uyX
	Ncc8X3vZ2uZ5bPA8ryEQWOye/blNnnuPzE69BbznNiyZ3KGw9nA019PshVp2k+dwT37z8/RK
	oys5Rt1eLgEnX03bUjOj4nKavmvSPJ2e3oiJRb5Zx+4Iz/moErPPsFu9M9Jt0jUlluKMREMt
	5qLiRABodThwYAMAAA==
X-CMS-MailID: 20241101081914eucas1p269f6f4d515aa0db81f4fb03cd3ae64d7
X-Msg-Generator: CA
X-RootMTR: 20241101071645eucas1p2a08b10cb2c9db427e809be6fa8809c9c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241101071645eucas1p2a08b10cb2c9db427e809be6fa8809c9c
References: <20241030154556.GA4449@lst.de>
	<ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com>
	<20241030155052.GA4984@lst.de>
	<ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com>
	<20241030165708.GA11009@lst.de>
	<ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com>
	<CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
	<ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
	<CGME20241101071645eucas1p2a08b10cb2c9db427e809be6fa8809c9c@eucas1p2.samsung.com>
	<CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>

On 01.11.2024 08:16, Hans Holmberg wrote:
>Locking in or not, to constructively move things forward (if we are
>now stuck on how to wire up fs support) I believe it would be
>worthwhile to prototype active fdp data placement in xfs and evaluate
>it. Happy to help out with that.

I appreciate you willingness to move things forward. I really mean it.

I have talked several times in this thread about collaborating in the
API that you have in mind. I would _very_ much like to have a common
abstraction for ZNS, ZUFS, FDP, and whatever people build on other
protocols. But without tangible patches showing this, we simply cannot
block this anymore.

>
>Fdp and zns are different beasts, so I don't expect the results in the
>presentation to be directly translatable but we can see what we can
>do.
>
>Is RocksDB the only file system user at the moment?
>Is the benchmark setup/config something that could be shared?

It is a YCSB workload. You have the scripts here:

    https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloada

If you have other standard workload you want us to run, let me know and
we will post the results in the list too.

We will post the changes to the L3 placement in RocksDB. I think we can
make them available somewhere for you to test before that. Let me come
back to you on this.


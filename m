Return-Path: <io-uring+bounces-3438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FFC992A32
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 13:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02FD01C22948
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 11:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D9B1D14EC;
	Mon,  7 Oct 2024 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bp6Ilodq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FE31AD401
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 11:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728300578; cv=none; b=FcRTnatVAlnLY3qE3mFdz+6jLUAE3g8IWRXSn81qF2Fi5uO97eRtS/H1YwcTQbSB92x4zDXawq9xua9qLSlfUA15A+8KPju03IOpmsqGEtC0IgLGwcff7E50S3sMjz+iIMWExwF2Onb3Lg2h/XmJOb3QJr9bRKuAdLxmv9RIFLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728300578; c=relaxed/simple;
	bh=mrOV2S6iIcjwy1I3D/RUjHT+r5hLPZ5Uu/mxHTTWUZI=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=GHaOUJxOqQC3NsSXx4cu3MFf4rvPMrr2Zdv4yk7qond80xICNX6HKVlk/gKt/lgPrHbSmqbpZ8UEKJJHAXiusB+FUcTEsbXiTxz4cgpwgbtFEZdF+lp7HxsGFFFlFJMKe3qTi71KcrNWxGmsZD0SF9AiNR08N9tB+/3G75eVgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bp6Ilodq; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241007112934euoutp010cbe502745242550b8e5d1333eb54103~8KDdIxZ9U0594605946euoutp01x
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 11:29:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241007112934euoutp010cbe502745242550b8e5d1333eb54103~8KDdIxZ9U0594605946euoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728300574;
	bh=D/cuLsTSJS5cack4J6ZJQb3O2sQ62YL1/KuYcxob1CI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bp6IlodqnpS25yUh16tBS8+5IiRO9/3PiFguOGLrOMXxDK3pafnaJkDcLb97iqIwH
	 XbgiTrFbd/NFeOwoP35R3szrorS9xbhCL8i2ljlAJEiBDApP8tThpAwWi4a8BRarpg
	 slkSpDbupy49z1IddFLjbrVNoJ26AJ1+iA8MvAtA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241007112934eucas1p28349c6841e27b99b605a19151b23ae7e~8KDcsWnrL2195821958eucas1p2K;
	Mon,  7 Oct 2024 11:29:34 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 82.F8.09624.E16C3076; Mon,  7
	Oct 2024 12:29:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241007112933eucas1p1fc9646cc40eba2fcb35128a1ece134c0~8KDcOACi62079720797eucas1p1H;
	Mon,  7 Oct 2024 11:29:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241007112933eusmtrp11c8f7c6913c9d0f70d680b969b084a8a~8KDcNTlOA2645626456eusmtrp1j;
	Mon,  7 Oct 2024 11:29:33 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-57-6703c61e9e64
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 4F.33.19096.D16C3076; Mon,  7
	Oct 2024 12:29:33 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241007112933eusmtip2f8765f614b14aa0d9aee8984cfa1627c~8KDb_eDaL1811718117eusmtip2Z;
	Mon,  7 Oct 2024 11:29:33 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 7 Oct 2024 12:29:32 +0100
Date: Mon, 7 Oct 2024 13:29:31 +0200
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
Message-ID: <20241007112931.afva6zzmipzdewm4@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004123206.GA19275@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTdxjld+/t7aWm5NKy8JtOlK6SRaHDSZZf3ByQYLhjM+geuJk9bMZN
	MbxMK5uOLXblkZbwrAqjdLOBjTpQcAWqZGJCQVkthawIal018ohdeQkuc4TZjPbWjf/Od75z
	vpyTfBQu0pAbqSMFx1hlgTxPQgoI6/WVkYSY67gi0fwkEhnbrAC1e2pIVOHvJtDswDJA9Y9W
	cLSgWSXQlWY9hn5qv4ahhbIRAjU1lGBoutOAI71tAqDT9RqA+tw70JU+O4HOts7wkXnIj6GO
	2UUCjT4d4qWImbGbbzG9Bg+fGb33M8GMOYsYS5uOZCzLej7T9cNJ5pc7apJZmnETzOLVcZIZ
	Ng2u8Y5i5rElhrFMz2P7Iw4JXs9m8458zipffuOwIKfU5CGPXuQf1/Y1k2qwyqsA4RSkk+Dg
	ZA9ZAQSUiD4HoPWel88NfwJocTYS3PAYwPPjOvDM0nGzN6QyA/jQ28D7TzWlq8e4oQvA0r+N
	RMBC0FLoczwM2kk6Gbpa3XgAR9ESOONzgoABp10EdP82TAYWYjoRLj6pWsMUJaT3QHOzKkAL
	6Uhob5wO3sTp3VD3SMMLSHB6EzT7KY7eAkt6moLnw+l4ODpu5HOpJXDKOx9q8DW80e0O5oR0
	tQC2unpDizT4e+01nMNi6BvqDplfgI5TlQSHi6Ha/mvIXApgmbYnGALSr8Hq4TxOkwr7fas4
	R0fA2/ORXLYIqLc2hGgh1JaLaoHUsK6YYV0xw//FDOuKmQDRBqLZIlW+glXtLGC/kKnk+aqi
	AoXss8J8C1h7U4d/aPky+M63JLMBjAI2AClcEiX84DxQiITZ8hNfssrCT5VFeazKBjZRhCRa
	uC17CyuiFfJjbC7LHmWVz7YYFb5RjUVnXCg31pk6wkx3JnO+YmuiNZkPXFs7709tqD21+a5N
	nCXobMk829gvw1C658yrlYrDVfGSv5JfSgcHtd5/wog9ilzP3kvEDUmi75u5/DR7ctaEesI/
	8FxG2eX3qkpOVjelqgbenow590B2fGLtYXfow/S7F+aso3Wx+xNWwMF3M611S59knb51QOpO
	zi18/sNbmP3jnvdbxO6a+DFXavrVC4ZdKVEbnF0/viOu2dci686I894e0IHKtHLpH94Tm6OK
	K/dJS3jaS1tb+ttHZrYteGa9B+ZelO+qTUjaHuuMS30aZix0fHtXklIlYAf31peXJRn5b77y
	ERMX+/3F++GHWAmhypHv3I4rVfJ/AT7C+T0VBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t/xe7qyx5jTDWZc1beYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	lJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl5Gy4K7
	bAUb2Cs69i5ia2D8zdrFyMkhIWAise7KTvYuRi4OIYGljBLrv0yGSshIbPxyFcoWlvhzrYsN
	ougjo8TUazehOjYzSjxZ0ghWxSKgIvHq9HNGEJtNwF7i0rJbzCC2iICSxNNXZxlBGpgFLrFI
	3Lp4hg0kISxgIPH+ey+QzcHBK2ArsXxRMcTQO8wSa5u2s4DU8AoISpyc+QTMZhawkJg5/zwj
	SD2zgLTE8n8cEGF5ieats8F2cQroSJy/Oocd4moliccv3jJC2LUSn/8+Y5zAKDILydRZSKbO
	Qpg6C8nUBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQKTzbZjP7fsYFz56qPeIUYmDsZD
	jBIczEoivBFrGNOFeFMSK6tSi/Lji0pzUosPMZoCg2gis5Rocj4w3eWVxBuaGZgamphZGpha
	mhkrifOyXTmfJiSQnliSmp2aWpBaBNPHxMEp1cAkUO4d0j85YLbBg0TVxHcmYud2sEl83aw2
	/1Fbm99Ek+txO5OqH77QL/EwKu6eVxy4utgzKed2gcr81cdWLG16f1O7bH6AQ+ysncvNZ/bP
	r0p9aeEusnev7p8IC/52dgZpHRWHmOdak463Xti6b5/z3Ig995y4dicFHau5I/h1+eaNQhM2
	nzumXpucHfF8zd6TS04zb17r8tXn9a2XfO94wvoOP3/tXXnj0NP3EalqJ6f//ar2T2/GvmPf
	1lVe2DslQbvW2/nzCbPGez0Cl17lVkwVkZ1cGD/n7SGlQzbqWcKnZJ1/Wb2a//rptHX7sxZs
	fXn+rOg6sZbU1ZLrToWyfHiy+vDxd8s/5i5TYIqTuKHEUpyRaKjFXFScCADVFv28vwMAAA==
X-CMS-MailID: 20241007112933eucas1p1fc9646cc40eba2fcb35128a1ece134c0
X-Msg-Generator: CA
X-RootMTR: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
References: <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
	<a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
	<CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com>
	<20241003125516.GC17031@lst.de>
	<20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local>
	<20241004062415.GA14876@lst.de>
	<20241004065923.zddb4fsyevfw2n24@ArmHalley.local>
	<20241004123206.GA19275@lst.de>

On 04.10.2024 14:32, Christoph Hellwig wrote:
>On Fri, Oct 04, 2024 at 08:59:23AM +0200, Javier González wrote:
>> FDP has authors from Meta, Google, Kioxia, Micron, Hynix, Solidigm,
>> Microship, Marvell, FADU, WDC, and Samsung.
>>
>> The fact that 2 of these companies are the ones starting to build the
>> Linux ecosystem should not surprise you, as it is the way things work
>> normally.
>
>That's not the point.  There is one company that drivers entirely pointless
>marketing BS, and that one is pretty central here.  The same company
>that said FDP has absolutely no іntent to work on Linux and fought my
>initial attempt to make the protocol not totally unusable ony layer system.
>And no, that's not Samsung.

So you had an interaction in the working group, your feedback was not
taking into consideration by the authors, and the result is that FDP
cannot be supported in Linux as a consequence of that? Come on...


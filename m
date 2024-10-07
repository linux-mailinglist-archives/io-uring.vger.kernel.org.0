Return-Path: <io-uring+bounces-3437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C26EA9928D4
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 12:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53EAD283816
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 10:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E151AA7A8;
	Mon,  7 Oct 2024 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fttvgpkt"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C818231CA9
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728295823; cv=none; b=TvP0bmV/ulbNcOyFiUAhp46RLfM4LK1QbDWC0Zh6sIX5bwSPl5ZJJy+aWidcnzUhtwvwAxhNKRQ47TnHUhRzOIPdAtX2IoLdQ0FrRLPHp3ZdM0EVft1Bnb47GUsi1ZRg3aiSD2A0OdracmLZ3Zk1I/0qHxqTzWi01Q6KC/RJev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728295823; c=relaxed/simple;
	bh=/qon21ZaisnOlLkY7R2OhoF5IXf7cHCKcZo4Pa5BJ2M=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=JnWxNRLTVr08XxwBQFHKs3C9jAwXVDOkxJ6crPaiianZw1tgu6oKPUtMg2fxprkw3JS0qKuf2bkJa/l9QviFJHCjIIl5FoEynpFjQaDctV5tnNj/UWR6hzqnsav6EQ0eXMNtHUcb1/PThwfu+rpeB5m9qjvNfiqM+XBKYleI674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fttvgpkt; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241007101014euoutp013a1e987b02e1f076c52d7c396f67d68f~8I_Le0ZyI1327713277euoutp01D
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 10:10:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241007101014euoutp013a1e987b02e1f076c52d7c396f67d68f~8I_Le0ZyI1327713277euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728295814;
	bh=Wrs5njHyhQsaY2qMFeXLDtqldIUMw8Cs3rLGXTGdDr0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=fttvgpktprywwOA+/0HlQCx5zxyylOxEABRZ9YUD3IhWKXU5yYU2eDkKER0RJM7pT
	 ey1PLMpk4QblRV/fzbUw4hTEBVVwayKRXKnbtN3Ez80dg7Fbyo1QBm0rnBdv+FbiFs
	 sJ7yDiDDDjYHQQotBbNXyjNfYX5/fqj9EhRtyKFw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241007101013eucas1p111022db7dfe721a110142c87b67de368~8I_LHGbUa1203412034eucas1p17;
	Mon,  7 Oct 2024 10:10:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 07.B8.09875.583B3076; Mon,  7
	Oct 2024 11:10:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241007101013eucas1p13db5988cea66fb961cbb06a99d2878c8~8I_Krfv4c1224012240eucas1p1R;
	Mon,  7 Oct 2024 10:10:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241007101013eusmtrp2e4e3882eb2a6277ce376cd99feffb5fa~8I_Kq0ipg2830128301eusmtrp2N;
	Mon,  7 Oct 2024 10:10:13 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-cd-6703b385af9f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 9B.A1.14621.583B3076; Mon,  7
	Oct 2024 11:10:13 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241007101013eusmtip1593046fbf475df26d943c475dd73c5ad~8I_KYi01k0296502965eusmtip1Y;
	Mon,  7 Oct 2024 10:10:13 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 7 Oct 2024 11:10:12 +0100
Date: Mon, 7 Oct 2024 12:10:11 +0200
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
Message-ID: <20241007101011.boufh3tipewgvuao@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004123027.GA19168@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7djPc7qtm5nTDV68NbKYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	FJdNSmpOZllqkb5dAlfGs6s7mQrOSFe83ZbTwPhXtIuRk0NCwERi+9sPLF2MXBxCAisYJZru
	NrJDOF8YJZ4/3cIK4XxmlOg58gUowwHWsuqsDER8OaNE45kVbCCjwIq+HxKDSGxmlDg65zM7
	SIJFQEXi58IPYEVsAvYSl5bdYgaxRQSUJJ6+OssI0sAscIhF4suB+WANwgIGEu+/97KBbOMV
	sJX4ddobJMwrIChxcuYTFhCbWcBKovNDEytICbOAtMTyfxwQYXmJ5q2zwcZzCuhIbL5zhhHi
	TSWJxy/eQtm1Eqe23GICWSsh0Mcl0ThxCztEwkWi91s/VJGwxKvjMHEZif875zNB2NUSDSdP
	QDW3MEq0dmxlhYSKtUTfmRyIGkeJV9N/QgOLT+LGW0GI2/gkJm2bzgwR5pXoaBOawKgyC8lj
	s5A8NgvhsVlIHlvAyLKKUTy1tDg3PbXYKC+1XK84Mbe4NC9dLzk/dxMjMI2e/nf8yw7G5a8+
	6h1iZOJgPMQowcGsJMIbsYYxXYg3JbGyKrUoP76oNCe1+BCjNAeLkjivaop8qpBAemJJanZq
	akFqEUyWiYNTqoHJw2pe+rcv03fFVURIC0/OnKQyT2v/EZv6ugff26RW/FSPSqvz1vc+V+Xn
	yr8h8Yvn9X8Xj7TkJSmahgX6TxWs9e1mVfm5+K3ljLu1lRdVcmR3K8kudxA8kqywf87M430i
	57RV9qSsV4/QnjDRSj5Vot8s9R9H2vXCu2nB3XOits+qdXD23BVRvTi3vOLKBU6vZeza/UJz
	fk/tkjDWsk3iKDaucVlfpl39aottwRb+8jjtei8r0+Jjid8WfjCRLXgkPH3Xpi13vNwk2ZQv
	zMrK9jxjf6Xop4P6yvO3rQV/aKvOTTbud2pgt7hjtb9f6MHPRROd3Wqntty/E33yh+/u5N/T
	HhXc+Zq+yu7fSSWW4oxEQy3mouJEAMwS+yASBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t/xu7qtm5nTDX5/FLGYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	lJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7Gs6s7
	mQrOSFe83ZbTwPhXtIuRg0NCwERi1VmZLkYuDiGBpYwSz/9eYuxi5ASKy0hs/HKVFcIWlvhz
	rYsNougjo8SM9feZIJzNjBLH151iBqliEVCR+LnwAxuIzSZgL3Fp2S2wuIiAksTTV2cZQRqY
	BQ6xSHw5MJ8dJCEsYCDx/nsvG8gZvAK2Er9Oe4OEhQROM0v8+S8MYvMKCEqcnPmEBcRmFrCQ
	mDn/PCNIObOAtMTyfxwQYXmJ5q2zwVZxCuhIbL5zBuoBJYnHL95C2bUSn/8+Y5zAKDILydRZ
	SKbOQpg6C8nUBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQLTzLZjPzfvYJz36qPeIUYm
	DsZDjBIczEoivBFrGNOFeFMSK6tSi/Lji0pzUosPMZoCQ2gis5Rocj4w0eWVxBuaGZgamphZ
	GphamhkrifO6XT6fJiSQnliSmp2aWpBaBNPHxMEp1cC0gTPWO75AXqPGeadQe+v3U+a3m1ie
	lnMvPZDbkHx/2c6grGZXv825hlsjN/1+ntEjXnF618PUIpklfGedPM8+bMvfMPvJ3DVmJ0+c
	PqNqI//6utWT/yt7tz5XFGhav/XElHlVHoWq36sF5xjvPCsv8ezsq5z3MwLX/9q04cb+My/1
	ZU3OdG7wOyIf5X/MOPvWrfyVBfpMr+vvtz5sFG76GrMqMOLf7KREX0F/+7nFcRd3CFnIzp1f
	YDDLcJX/ou/rzRuPaIrcSuDbuHCi95zTkSJSeQusdD+Z8pz2TD7x4UVF7zrRHzwWtYWh3T5X
	2ha2cXusEH6x1XjWqyPn7nvN/mAvfOLBn5a2f9I7Lv0UU2Ipzkg01GIuKk4EAHcvjMe8AwAA
X-CMS-MailID: 20241007101013eucas1p13db5988cea66fb961cbb06a99d2878c8
X-Msg-Generator: CA
X-RootMTR: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
References: <20241002151949.GA20877@lst.de>
	<yq17caq5xvg.fsf@ca-mkp.ca.oracle.com> <20241003125400.GB17031@lst.de>
	<c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
	<CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
	<20241004053121.GB14265@lst.de>
	<20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
	<20241004062733.GB14876@lst.de>
	<20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
	<20241004123027.GA19168@lst.de>

On 04.10.2024 14:30, Christoph Hellwig wrote:
>On Fri, Oct 04, 2024 at 08:52:33AM +0200, Javier González wrote:
>> So, considerign that file system _are_ able to use temperature hints and
>> actually make them work, why don't we support FDP the same way we are
>> supporting zones so that people can use it in production?
>
>Because apparently no one has tried it.  It should be possible in theory,
>but for example unless you have power of 2 reclaim unit size size it
>won't work very well with XFS where the AGs/RTGs must be power of two
>aligned in the LBA space, except by overprovisioning the LBA space vs
>the capacity actually used.

This is good. I think we should have at least a FS POC with data
placement support to be able to drive conclusions on how the interface
and requirements should be. Until we have that, we can support the
use-cases that we know customers are asking for, i.e., block-level hints
through the existing temperature API.

>
>> I agree that down the road, an interface that allows hints (many more
>> than 5!) is needed. And in my opinion, this interface should not have
>> semintics attached to it, just a hint ID, #hints, and enough space to
>> put 100s of them to support storage node deployments. But this needs to
>> come from the users of the hints / zones / streams / etc,  not from
>> us vendors. We do not have neither details on how they deploy these
>> features at scale, nor the workloads to validate the results. Anything
>> else will probably just continue polluting the storage stack with more
>> interfaces that are not used and add to the problem of data placement
>> fragmentation.
>
>Please always mentioned what layer you are talking about.  At the syscall
>level the temperatur hints are doing quite ok.  A full stream separation
>would obviously be a lot better, as would be communicating the zone /
>reclaim unit / etc size.

I mean at the syscall level. But as mentioned above, we need to be very
sure that we have a clear use-case for that. If we continue seeing hints
being use in NVMe or other protocols, and the number increase
significantly, we can deal with it later on.

>
>As an interface to a driver that doesn't natively speak temperature
>hint on the other hand it doesn't work at all.
>
>> The issue is that the first series of this patch, which is as simple as
>> it gets, hit the list in May. Since then we are down paths that lead
>> nowhere. So the line between real technical feedback that leads to
>> a feature being merged, and technical misleading to make people be a
>> busy bee becomes very thin. In the whole data placement effort, we have
>> been down this path many times, unfortunately...
>
>Well, the previous round was the first one actually trying to address the
>fundamental issue after 4 month.  And then after a first round of feedback
>it gets shutdown somehow out of nowhere.  As a maintainer and review that
>is the kinda of contributors I have a hard time taking serious.

I am not sure I understand what you mean in the last sentece, so I will
not respond filling blanks with a bad interpretation.

In summary, what we are asking for is to take the patches that cover the
current use-case, and work together on what might be needed for better
FS support. For this, it seems you and Hans have a good idea of what you
want to have based on XFS. We can help review or do part of the work,
but trying to guess our way will only delay existing customers using
existing HW.




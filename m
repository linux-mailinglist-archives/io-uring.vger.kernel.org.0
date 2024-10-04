Return-Path: <io-uring+bounces-3409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CC898FD88
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B6EF1C20947
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DDA26281;
	Fri,  4 Oct 2024 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MH7zdzIV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC217132106
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728024759; cv=none; b=J7lEZrE99fLZx4HL9/nzzLe5jN3qH/MkDRghsZzLldvh8FmnIXrhfq5aDUN1ESCxQF4IQTt9yEfIxh7OyfUuwc+GmojNHxux49z20vE5/FV3yYZ3V+60I01ZM5BljsHW7jdLChrIq84maeyz47jxeVLSSmjlbKDo44umZUZQwmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728024759; c=relaxed/simple;
	bh=4eq/fuIBDdbYh7Urv9+9/tFmFzYnb705DDsjr2gXdU4=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=G6daBzplQo7BL8G8uPkwvHTn0SxO5o3AQOEcn540fcG/RL/tgxmNgRBHz4jgcl2vAVtgS4BSZIndeQuDxQeFY4jo+bc0W11sFQZaKn+mPMGWNRMuKlVq7A3wQtXN4yN+wGnzDJYlq/zkZ86m1Zl3CCtbQEh+eBwIaKc8yS8kj04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MH7zdzIV; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241004065236euoutp011fbbe8cd319da6954b5f80f87b630435~7LVw3u5Hh2169021690euoutp01G
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:52:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241004065236euoutp011fbbe8cd319da6954b5f80f87b630435~7LVw3u5Hh2169021690euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728024756;
	bh=0eFNEuun/51sigt8I1IGkMHFvF9oS3OdSQuK/gZtlIw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=MH7zdzIVDjgABsfiX9kLixNYQzWuaUVJr+R9+48gPbOXKM+mI4eWQG2o/vJv6etzQ
	 /RI+xaZT6B4e0KiodSQSu6q2CmEP/y+5BbW34CNq0e23cCGZKtgfDCSO1C9fksiT/I
	 5c8n4HOfobpfJQMuSCkWvKaaFs/GjvO9tG7GjIkE=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241004065235eucas1p2985f211d5f3c64b317e37c43d118866a~7LVwiIpBo3244832448eucas1p2Q;
	Fri,  4 Oct 2024 06:52:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 25.97.09620.3B09FF66; Fri,  4
	Oct 2024 07:52:35 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241004065235eucas1p102ea903dc060b880ee9dd7137ae436dd~7LVwD71F51940419404eucas1p1S;
	Fri,  4 Oct 2024 06:52:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241004065235eusmtrp1b2a790e78aedd380db26f9caf681a26e~7LVwC2K6V0078200782eusmtrp1F;
	Fri,  4 Oct 2024 06:52:35 +0000 (GMT)
X-AuditID: cbfec7f5-d31ff70000002594-20-66ff90b3914f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id A6.E4.19096.3B09FF66; Fri,  4
	Oct 2024 07:52:35 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241004065235eusmtip222a3c0d6fe5a11c3e12e6292908b3360~7LVv3brZh2337823378eusmtip2R;
	Fri,  4 Oct 2024 06:52:35 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 4 Oct 2024 07:52:34 +0100
Date: Fri, 4 Oct 2024 08:52:33 +0200
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
Message-ID: <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241004062733.GB14876@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZduznOd3NE/6nGczYoW4xZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KC6blNSczLLUIn27BK6Mhzu2sBUskqxYO/0OWwPjZJEuRk4OCQETib4DK5lAbCGBFYwS/2ZE
	djFyAdlfGCVmth9hhnA+M0rsOPGEGabjTc9NdojEckaJC5c/ssJVHXzzASjDAeRsZpS4JgPS
	wCKgIjH9/w4WEJtNwF7i0rJbYINEBJQknr46ywjSyyxwiEXiy4H57CAJYQEDifffe9lAbF4B
	W4m29XcYIWxBiZMzn4ANYhawkuj80MQKsotZQFpi+T8OiLC8RPPW2WDzOQV0JBZsvs8CcbSS
	xOMXbxkh7FqJU1tuMYHslRDo4pL48WsH1GcuEgtfHGGHsIUlXh3fAmXLSJye3AM1qFqi4eQJ
	qOYWRonWjq1gR0gIWEv0ncmBqHGUeDX9JztEmE/ixltBiNv4JCZtm84MEeaV6GgTmsCoMgvJ
	Y7OQPDYL4bFZSB5bwMiyilE8tbQ4Nz212DgvtVyvODG3uDQvXS85P3cTIzCRnv53/OsOxhWv
	PuodYmTiYDzEKMHBrCTCO2/73zQh3pTEyqrUovz4otKc1OJDjNIcLErivKop8qlCAumJJanZ
	qakFqUUwWSYOTqkGJr8DXa0lUaqdHSrLIibar2GP3rxc3voRyyKr6+5fqidp2jw8ZPXIp6y+
	7sHVPoaVv5fl2Ccnpy5/0CPz65Nwa9zvGwXS6eKnGS7+2rE71o7tm963cpPrC47MjlWcdubO
	MT7fube/xxd2b59pOeNUReDLKYxbWblnyHn7nSu4q9y6N3TZvvnqeZvE+Ur1Qh696/YqYQ9V
	q3A5v/pYnPqXO8cO/JS2mSHpk99q/nYS47mYVW1TbG5N+3YvN6RcvLqjSDzSbU61y7GJ9Zcv
	Ghne3tW09vzLt0/4r26bbJvxoqY3/vCtt8wHcsofeDxI+Kz5LHhp1PHLn3lappkfjqtbz72e
	ecfvnzeWqOZYtipf3aLEUpyRaKjFXFScCAAMV0+WEwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t/xe7qbJ/xPM7jfxWUxZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2Mhzu2
	sBUskqxYO/0OWwPjZJEuRk4OCQETiTc9N9m7GLk4hASWMkrcu7KeESIhI7Hxy1VWCFtY4s+1
	LjaIoo+MEgtvz2GGcDYzSmx++Qesg0VARWL6/x0sIDabgL3EpWW3mEFsEQEliaevzjKCNDAL
	HGKR+HJgPjtIQljAQOL99142EJtXwFaibf0dRoipZ5gl3m3tY4RICEqcnPkEbCqzgIXEzPnn
	geIcQLa0xPJ/HBBheYnmrbPBlnEK6Egs2HyfBeJsJYnHL95CvVMr8fnvM8YJjCKzkEydhWTq
	LISps5BMXcDIsopRJLW0ODc9t9hIrzgxt7g0L10vOT93EyMw3Ww79nPLDsaVrz7qHWJk4mA8
	xCjBwawkwjtv+980Id6UxMqq1KL8+KLSnNTiQ4ymwDCayCwlmpwPTHh5JfGGZgamhiZmlgam
	lmbGSuK8bFfOpwkJpCeWpGanphakFsH0MXFwSjUw1eled5OI3XlGl9nK1elXwPbrM4VLm/+W
	3lXTTWt9xt1xXLW6dcvpZLbPMmFtdxyOTMr6+LOl86npupJFTF5hl2NSzM9VnbL8pNqTnJMV
	5yMifm+Rwh7PRXfMQj0+eK+8YyGYUf5kRewzAcEWaWmz71sTmJfF1jenZzsdyD477cGx2bO2
	+PBvtbGd7GtVfUzy7rraw0kvPA49vnjVPdZiwaKndo7/P7+pryoLvp/RvuP4747Alazchzgs
	C7+LWXSdr62pP5AjYKwsv11k/24lsWNH9EMXnk2V/sRqqK7IsGBpY9bxoC+28cL8x9057b52
	c2S5XtCxXFAloPHr74ySQqvTIRqrFLdH9qW/11JiKc5INNRiLipOBADL+ORQwAMAAA==
X-CMS-MailID: 20241004065235eucas1p102ea903dc060b880ee9dd7137ae436dd
X-Msg-Generator: CA
X-RootMTR: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b
References: <20241002151344.GA20364@lst.de>
	<Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
	<20241003125400.GB17031@lst.de>
	<c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
	<CGME20241004053129eucas1p2aa4888a11a20a1a6287e7a32bbf3316b@eucas1p2.samsung.com>
	<20241004053121.GB14265@lst.de>
	<20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
	<20241004062733.GB14876@lst.de>

On 04.10.2024 08:27, Christoph Hellwig wrote:
>On Fri, Oct 04, 2024 at 08:18:11AM +0200, Javier González wrote:
>>> And for anyone who followed the previous discussions of the patches
>>> none of this should been new, each point has been made at least three
>>> times before.
>>
>> Looking at the work you and Hans have been doing on XFS, it seems you
>> have been successful at mapping the semantics of the temperature to
>> zones (which has no semantics, just as FDP).
>>
>>    What is the difference between the mapping in zones and for FDP?
>
>Probably not much, except for all the pitfalls in the FDP not quite hint
>not madatory design.

It is too late to change the first version of FDP productas, and the
solution of "go back to NVMe and make it match SCSI" is not realistic.

We have drives from several companies out there supporting this version
of FDP. And we have customers that are actively using them. It is our
collective responsibility to support them.

So, considerign that file system _are_ able to use temperature hints and
actually make them work, why don't we support FDP the same way we are
supporting zones so that people can use it in production?

I agree that down the road, an interface that allows hints (many more
than 5!) is needed. And in my opinion, this interface should not have
semintics attached to it, just a hint ID, #hints, and enough space to
put 100s of them to support storage node deployments. But this needs to
come from the users of the hints / zones / streams / etc,  not from
us vendors. We do not have neither details on how they deploy these
features at scale, nor the workloads to validate the results. Anything
else will probably just continue polluting the storage stack with more
interfaces that are not used and add to the problem of data placement
fragmentation.

>
>> The whole point is using an existing interface to cover the use-case of
>> people wanting hints in block.
>
>And that's fine.  And that point all the way back for month is that
>doing a complete dumb mapping in the driver for that is fundamentally
>wrong.  Kanchan's previous series did about 50% of the work to get
>it rid, but then everyone dropped dead and played politics.

The issue is that the first series of this patch, which is as simple as
it gets, hit the list in May. Since then we are down paths that lead
nowhere. So the line between real technical feedback that leads to
a feature being merged, and technical misleading to make people be a
busy bee becomes very thin. In the whole data placement effort, we have
been down this path many times, unfortunately...

At LPC, we discussed about the work you did in XFS and it became clear
that coming back to the first version of the patches was the easiest way
to support the use-case that current customers have. It is a pity you
did not attend the conference and could make a point against this line
of thought there.

So summarizing, all folks in this thread are asking is for a path to
move forward for solving the block use-case, which is the only one that
I am aware of requiring kernel support. This has been validated with
real workloads, so it is very specific and tangible.



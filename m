Return-Path: <io-uring+bounces-3547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0EA997F17
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 10:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1E7B1F21F30
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 08:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC691CBE99;
	Thu, 10 Oct 2024 07:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J7kTWwcK"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55511CBE97
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 07:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728544062; cv=none; b=Neq+F0VJjizbW29x6T2mIABmVYbHq3nKD9kLmPFb+FSL1Hm5dS1Dp/TPUeN6s1OejeGMGuJrcK1ya7MtvQfh9lokkOmFSrwPUFZyKmdUtLuX82lCq4rWW+B0Zq0suQ68GhV8X42+APfB6mW4vKoEiHLn9ZadtvIg9RN6k3OQVZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728544062; c=relaxed/simple;
	bh=K6vdFDIvcDrVQd1O40WIw+BX/ym2dNz1BdSpGM/icNw=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=QXC5iGyAUHJz2thrEEGpbGtVMBUorU2WXceTWEfziI5yRsLhJTJ7JGQ1Sg/ZjDrh/WuvrtiLTrf1NtJeGuA2ay1ukANu67wwDuLRIDeLbveop1yZoKVL8MV7Iwc0WmYqkk4FV4VRmuHeostTRergLDqcwRj5G3+DtJ1gy5ay8CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=J7kTWwcK; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241010070739euoutp0213bea607e30903bef7cd03c14c949c07~9BanmISbE1888918889euoutp02G
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 07:07:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241010070739euoutp0213bea607e30903bef7cd03c14c949c07~9BanmISbE1888918889euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728544059;
	bh=StVMKmOJcIwxuQzbeuZ+cLCKqlEiL352deXD6ZMYmC8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=J7kTWwcKr4TApqrK8MffgNIk1f993fg/q2h7cCsknjCaGAeQaKSKEEDQmz7WjgTvl
	 iK3kKnz+Z7vttNIPK1ZZqXiiru2CSAIDKq6VK20Z6+TOhu+ghP00Hcwd/W9I90JG59
	 m+DeFaWNFtdetMUfELkUBn1/lKKct6IaOnmldB+M=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241010070738eucas1p291db7fda9d14fa7dbbeeefeafffcfd87~9BanO7Pds2688826888eucas1p2q;
	Thu, 10 Oct 2024 07:07:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 0E.59.09620.A3D77076; Thu, 10
	Oct 2024 08:07:38 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed~9Bam3XpnY1998919989eucas1p2F;
	Thu, 10 Oct 2024 07:07:38 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241010070738eusmtrp16abc92c224e3a7d798813adfea8d2849~9Bam2IjWN0501605016eusmtrp1c;
	Thu, 10 Oct 2024 07:07:38 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-21-67077d3a2cd5
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 34.D4.14621.A3D77076; Thu, 10
	Oct 2024 08:07:38 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010070738eusmtip2a1fc76e3f2596c182319347692f89b5d~9BamrDguh0964709647eusmtip22;
	Thu, 10 Oct 2024 07:07:38 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 10 Oct 2024 08:07:37 +0100
Date: Thu, 10 Oct 2024 09:07:36 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Keith Busch <kbusch@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
	<hare@suse.de>, <sagi@grimberg.me>, <brauner@kernel.org>,
	<viro@zeniv.linux.org.uk>, <jack@suse.cz>, <jaegeuk@kernel.org>,
	<bcrl@kvack.org>, <dhowells@redhat.com>, <bvanassche@acm.org>,
	<asml.silence@gmail.com>, <linux-nvme@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-aio@kvack.org>,
	<gost.dev@samsung.com>, <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010070736.de32zgad4qmfohhe@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <Zwab8WDgdqwhadlE@kbusch-mbp>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7djPc7pWtezpBk9P6FvMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLPYsmsRksXL1USaLd63nWCxmT29msniyfhazxaRD1xgt
	pkxrYrTYe0vbYs/ekywW85c9ZbdYfvwfk8W61+9ZLM7/Pc7qIOxx+Yq3x85Zd9k9zt/byOJx
	+Wypx6ZVnWwemz5NYvfYvKTeY/fNBjaPj09vsXi833eVzePMgiNA8dPVHp83yXlsevKWKYAv
	issmJTUnsyy1SN8ugStj2+VnLAXdIhXr515mamBsE+hi5OSQEDCR+HBsG3sXIxeHkMAKRok5
	ky6xQThfGCWWfzgO5XxmlLh34QtTFyMHWMu7tSIQ8eWMErPmzmaHK9q06ggjhLOFUWL+s5Ps
	IEtYBFQlzm2ewQpiswnYS1xadosZxBYRUJa4O38mK0gDs8BBFokDP5aygCSEBQwk3n/vZQOx
	eQVsJdbM6GOEsAUlTs58AlbDLGAl0fmhiRXkJGYBaYnl/zhAwpwCWhLL2n8xQjynJPH4xVso
	u1bi1JZbTCC7JAR+cUocmzWFFSLhInFi5iEWCFtY4tXxLewQtozE6ck9UPFqiYaTJ6CaWxgl
	Wju2skLCwlqi70wORI2jROO8uWwQYT6JG28FIc7kk5i0bTozRJhXoqNNCKJaTWL1vTcsExiV
	ZyF5bBaSx2YhPLaAkXkVo3hqaXFuemqxcV5quV5xYm5xaV66XnJ+7iZGYNI8/e/41x2MK159
	1DvEyMTBeIhRgoNZSYRXdyFruhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe1RT5VCGB9MSS1OzU
	1ILUIpgsEwenVAOTiaVV1sHXb+s+5+lpbjV7FffTPsj7U5H6V4UV3uWxt5uEPPvn8+3yEj65
	c6+dUtOLTRbJ4e+5eyfz/pzg+Es3i110h07rJQ35Kj6dRUd+W3o5T4lx61jgqC3Z8ycjpdXf
	sO/3qc+rJpsWawad55mp77mz0M/y1Jnw+MM+D6Y+qXrl59lgWel/TWTRCeViLSbzzx/Cblzj
	4EhiaCrvVvTIYxX69kS3lf1b6L2ofJW9m7vat5Qln5csmtL5/pXzM4MZz1gE3XbMf3RbZVNI
	dVmY/O8TbX/73vmYh1XcXyCct+uh8Grp7xW1/05aNOYKnHqx8JbojAVdLeKbMw6+PVd4+pjb
	yusdFyep3Nt0zkaJpTgj0VCLuag4EQB+kvMICQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t/xe7pWtezpBvvviFnMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLPYsmsRksXL1USaLd63nWCxmT29msniyfhazxaRD1xgt
	pkxrYrTYe0vbYs/ekywW85c9ZbdYfvwfk8W61+9ZLM7/Pc7qIOxx+Yq3x85Zd9k9zt/byOJx
	+Wypx6ZVnWwemz5NYvfYvKTeY/fNBjaPj09vsXi833eVzePMgiNA8dPVHp83yXlsevKWKYAv
	Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9j2+Vn
	LAXdIhXr515mamBsE+hi5OCQEDCReLdWpIuRi0NIYCmjxOun21i7GDmB4jISG79chbKFJf5c
	62KDKPrIKLH/5nxmCGcLo8SGYxcZQapYBFQlzm2eAdbBJmAvcWnZLWYQW0RAWeLu/JmsIA3M
	AgdZJKZtP8sGkhAWMJB4/70XzOYVsJVYM6OPEWJqP7PE7HXLWCESghInZz5hAbGZBSwkZs4/
	zwhyN7OAtMTyfxwgYU4BLYll7b8YIU5Vknj84i2UXSvx+e8zxgmMwrOQTJqFZNIshEkLGJlX
	MYqklhbnpucWG+oVJ+YWl+al6yXn525iBCaPbcd+bt7BOO/VR71DjEwcjIcYJTiYlUR4dRey
	pgvxpiRWVqUW5ccXleakFh9iNAWGxURmKdHkfGD6yiuJNzQzMDU0MbM0MLU0M1YS53W7fD5N
	SCA9sSQ1OzW1ILUIpo+Jg1OqgWk+c2uQ+evkWxOE3SYdcd77cdH273urez9NmV0auO64m2HV
	7FM39e4sZ00+2rzj4Em2Dbs6o2S4+lcUxtrcvHIm8P+OGOMTT/N2zVc63LEzRXAP52LvOU95
	xGebSW3qcZ928MjnxtXNuz9+kS0/9Kq5bKVRy/lHu5NsGCc9b4vpXlYxQW3LtUaGREEBg4NL
	DpyV49BJD21/pPf1cEnQ1ffsM3++DKsqDlW9sUiys89527F05+92Bgut7B8nve82dbhy53Xk
	BQ21lhxBoIm7DZM23t5y18CvId2D6QbX9JZ+I4NlESc+e/efeX4yJj1K6n3tffXGRvfV396J
	2hnNWJumWFjCpXy8W3+PfVv6RiWW4oxEQy3mouJEAHG/Lt2nAwAA
X-CMS-MailID: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
X-Msg-Generator: CA
X-RootMTR: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
References: <20241004053121.GB14265@lst.de>
	<20241004061811.hxhzj4n2juqaws7d@ArmHalley.local>
	<20241004062733.GB14876@lst.de>
	<20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
	<20241004123027.GA19168@lst.de>
	<20241007101011.boufh3tipewgvuao@ArmHalley.local>
	<20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp>
	<20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
	<CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com>

On 09.10.2024 09:06, Keith Busch wrote:
>On Wed, Oct 09, 2024 at 11:28:28AM +0200, Christoph Hellwig wrote:
>> On Tue, Oct 08, 2024 at 08:44:28AM -0600, Keith Busch wrote:
>> > Then let's just continue with patches 1 and 2. They introduce no new
>> > user or kernel APIs, and people have already reported improvements using
>> > it.
>>
>> They are still not any way actually exposing the FDP functionality
>> in the standard though.  How is your application going to align
>> anything to the reclaim unit?  Or is this another of the cases where
>> as a hyperscaler you just "know" from the data sheet?
>
>As far as I know, this is an inconsequential spec detail that is not
>being considered by any applications testing this. And yet, the expected
>imrpovements are still there, so I don't see a point holding this up for
>that reason.

I am re-reading the thread to find a common ground. I realize that my
last email came sharper than I intended. I apologize for that Christoph.

Let me summarize and propose something constructive so that we can move
forward.

It is clear that you have a lot of insight on how a FS API should look
like to unify the different data placement alternatives across
protocols. I have not seen code for it, but based on the technical
feedback you are providing, it seems to be fairly clear in your mind.

I think we should attempt to pursue that with an example in mind. Seems
XFS is the clear candidate. You have done work already in enable SMR
HDDs; it seems we can get FDP under that umbrella. This will however
take time to get right. We can help with development, testing, and
experimental evaluation on the WAF benefits for such an interface.

However, this work should not block existing hardware enabling an
existing use-case. The current patches are not intrusive. They do not
make changse to the API and merely wire up what is there to the driver.
Anyone using temperaturs will be able to use FDP - this is a win without
a maintainance burden attached to it. The change to the FS / application
API will not require major changes either; I believe we all agree that
we cannot remove the temperatures, so all existing temperature users
will be able to continue using them; we will just add an alternative for
power users on the side.

So the proposal is to merge the patches as they are and commit to work
together on a new, better API for in-kernel users (FS), and for
applications (syscall, uring).

Christoph, would this be a viable way to move forward for you?

Thanks,
Javier


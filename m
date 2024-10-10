Return-Path: <io-uring+bounces-3554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C3F998567
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 13:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA5E61C234E6
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 11:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD961C3315;
	Thu, 10 Oct 2024 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XL1pnZkX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FF1C32FE
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728561561; cv=none; b=XtVFnFIgqvZVMDtj5/9Xyo3nH2M3Zw11NIGch2x/tyF5YosP5Gl/TKxn0tyofWuJUeKnY1HFsR5m3dbTJAXHa4lfioJ3Xzti2FLBMFvZ/QE4oLAUO8IlPOngMwoKpZoOl7bFcfmcXSI90B0RztmHfGgYO/uhnEgZYB6NSVxp8WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728561561; c=relaxed/simple;
	bh=lBMUS92MVVtE7WiHhkv0jphZISUiUSE63Ndqqdn0Ymc=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=Xn6zbA5XgcJJDgoI45bWj7+7Kjw5hgCAPTJ3kENmoXy4eRnDSXE4Kow0wpbAJMJMdTdm52Qv2cOWMlNXlnqscGbeqaxa9tn1EzlwkV7BEKSaVKFASiSuUqylKrHcfxDDICZiEZ19SDo18ymUXcUtdDgqLDlT7s7OmAjU6ButWes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XL1pnZkX; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241010115917euoutp01644c35cadf048a546a13f15ff9e1761b~9FZQA0yJ71028410284euoutp01Z
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 11:59:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241010115917euoutp01644c35cadf048a546a13f15ff9e1761b~9FZQA0yJ71028410284euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728561557;
	bh=JFEhzwh6TFy7gvh/V/VQmA/6x9Ll3Q64Srgane2R0MQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XL1pnZkXbNczuaKGwxP91VvRZ7FOW4inqyck6JzuRK9JuKVTYAP9UT2xKwrKQkak9
	 rFP3WD9/N6+ia8kM3GeGClGlkty7Iy4QdKJpV46Xb3LFzj5qBN0WBHNr4WZ+Qnh5Lk
	 9kkWMrSNhDDcs4KxS35NAI+RMDesuD4W/cXNUgDY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241010115917eucas1p2757edd597fadf0f760e3f85610ca750c~9FZPqgj941778717787eucas1p2L;
	Thu, 10 Oct 2024 11:59:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id F0.F2.09624.491C7076; Thu, 10
	Oct 2024 12:59:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241010115916eucas1p2272fa345ed2f4067a87015053a4c6c62~9FZPKNGKH0910509105eucas1p2p;
	Thu, 10 Oct 2024 11:59:16 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241010115916eusmtrp2af96e45c8f6377270b9d9ac331b31951~9FZPJa4On2762327623eusmtrp2h;
	Thu, 10 Oct 2024 11:59:16 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-a3-6707c1944c7c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id E3.69.14621.491C7076; Thu, 10
	Oct 2024 12:59:16 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241010115916eusmtip1fde37d975993fb9831462fd30399f3f8~9FZO8D_3y2016220162eusmtip1e;
	Thu, 10 Oct 2024 11:59:16 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 10 Oct 2024 12:59:15 +0100
Date: Thu, 10 Oct 2024 13:59:14 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi
	<joshi.k@samsung.com>, <hare@suse.de>, <sagi@grimberg.me>,
	<brauner@kernel.org>, <viro@zeniv.linux.org.uk>, <jack@suse.cz>,
	<jaegeuk@kernel.org>, <bcrl@kvack.org>, <dhowells@redhat.com>,
	<bvanassche@acm.org>, <asml.silence@gmail.com>,
	<linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-aio@kvack.org>, <gost.dev@samsung.com>, <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241010091333.GB9287@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7djP87pTDrKnGxz7aWExZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KC6blNSczLLUIn27BK6MYzM/sRe8Eq448T+rgfEJfxcjJ4eEgInE1KYWxi5GLg4hgRWMEgv7
	b7JAOF8YJV7s+skK4XxmlFizbDIzTMudjj1MEInljBKz9kIkwKpW7SmHSGxhlPh/ZQVQFQcH
	i4CqxI93siA1bAL2EpeW3QKrFxFQknj66izYbmaBQywSh1btZwNJCAsYSLz/3gtm8wrYSuxe
	/5gRwhaUODnzCQuIzSxgJdH5oYkVZD6zgLTE8n8cEGF5ieats8HmcwpoS5yZOpMR4mgliccv
	3kLZtRKnttxigrC7uCT+dwVB2C4Svd9/QT0pLPHq+BZ2CFtG4v/O+VD11RINJ0+APS8h0MIo
	0dqxFewGCQFrib4zORA1jhKN8+ayQYT5JG68FYQ4jU9i0rbpzBBhXomONqEJjCqzkPw1C8lf
	sxD+moXkrwWMLKsYxVNLi3PTU4sN81LL9YoTc4tL89L1kvNzNzEC0+jpf8c/7WCc++qj3iFG
	Jg7GQ4wSHMxKIry6C1nThXhTEiurUovy44tKc1KLDzFKc7AoifOqpsinCgmkJ5akZqemFqQW
	wWSZODilGpga/f0vBlmEVHI2J3x7GFo+65bB5NvsKuq+SeGfpp7a5Wq8+kTPyqrPkz/+ttCe
	f9cgOyrocKrJ2mpfsdc2nIbnC5bnPq07sVhjVW/AhydrJC9WsKsEPvjGvarGJTKr+8+i44KL
	46wqe8zU+0O9w3qTj+Q33/yt1Oj05bbrnQ3TVJU7e8v7/2WJrX/AdMZy9fs54vXbWgQ/TEkP
	87rsWJZ61OVRQd3L/f5/TD+LqGiocx2bdSwp60nVg6xVa2dMs9/4fmWxfEypLOeey5pvWWe9
	ci298Oi3Vsj0G1M/WX0ouRa4x2Lb7rOHW5smLvF2t17OFdFZNfdlrOEnroisC+t3R0WwaLbE
	6kvVPtTJZFRiKc5INNRiLipOBAB7Epm1EgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t/xu7pTDrKnG/w4IGYxZ9U2RovVd/vZ
	LLr+bWGxeH34E6PFtA8/mS3eNf1msdizaBKTxcrVR5ks3rWeY7GYPb2ZyeLJ+lnMFpMOXWO0
	mDKtidFi7y1tiz17T7JYzF/2lN1i+fF/TBbrXr9nsTj/9zirg7DH5SveHjtn3WX3OH9vI4vH
	5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9VNo8zC44AxU9Xe3zeJOex6clbpgC+
	KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2MYzM/
	sRe8Eq448T+rgfEJfxcjJ4eEgInEnY49TF2MXBxCAksZJV6cf8cCkZCR2PjlKiuELSzx51oX
	G0TRR0aJVXPeQ3VsYZToWbcQqIqDg0VAVeLHO1mQBjYBe4lLy24xg9giAkoST1+dZQSpZxY4
	xCKxpHcXE0hCWMBA4v33XjYQm1fAVmL3+seMEEMPMEtMbJnDApEQlDg58wmYzSxgITFz/nlG
	kGXMAtISy/9xQITlJZq3zgZbximgLXFm6kxGiKuVJB6/eAtl10p8/vuMcQKjyCwkU2chmToL
	YeosJFMXMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECEw124793LyDcd6rj3qHGJk4GA8x
	SnAwK4nw6i5kTRfiTUmsrEotyo8vKs1JLT7EaAoMoonMUqLJ+cBkl1cSb2hmYGpoYmZpYGpp
	Zqwkzut2+XyakEB6YklqdmpqQWoRTB8TB6dUA1PNXMlfm9PXWdY4Je351q2g/2NpzdlAPpZN
	MVd//bn+erLLLJ1Uw3blyG6LrgtufdPaAw518/y9/GpX6G7LykXLzN8zsnmsXqTy2WCdwswT
	NgXpUhu/GrjLmsju1Cp8di47JTQkfrNlcInq64+6x1deVn72ZUWC8b6cy7bSjiskxNU2Z136
	dKNkd5y0RdrTnEMrRIvLVPdP57zdO7PlvN8M+ZqU6T8qzr274cozaamF+DPGfVcM2DZ0ajU/
	z82TfXjjDHuX6eatWU0Of9d9T8hM2Po59Xqr26p3/NLH0mTy0gpVVeZ8WiVn5hbR4qXzRlx6
	k314aJTOwdelH0/MOxf1r/dMiHTTnh3rN/Iu8FJiKc5INNRiLipOBACcPTZuvgMAAA==
X-CMS-MailID: 20241010115916eucas1p2272fa345ed2f4067a87015053a4c6c62
X-Msg-Generator: CA
X-RootMTR: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
References: <20241004065233.oc5gqcq3lyaxzjhz@ArmHalley.local>
	<20241004123027.GA19168@lst.de>
	<20241007101011.boufh3tipewgvuao@ArmHalley.local>
	<20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp>
	<20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
	<CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com>
	<20241010070736.de32zgad4qmfohhe@ArmHalley.local>
	<20241010091333.GB9287@lst.de>

On 10.10.2024 11:13, Christoph Hellwig wrote:
>On Thu, Oct 10, 2024 at 09:07:36AM +0200, Javier González wrote:
>> I think we should attempt to pursue that with an example in mind. Seems
>> XFS is the clear candidate. You have done work already in enable SMR
>> HDDs; it seems we can get FDP under that umbrella. This will however
>> take time to get right. We can help with development, testing, and
>> experimental evaluation on the WAF benefits for such an interface.
>
>Or ZNS SSDs for that matter.

Maybe. I do not see much movement on this.

>
>> However, this work should not block existing hardware enabling an
>> existing use-case. The current patches are not intrusive. They do not
>> make changse to the API and merely wire up what is there to the driver.
>> Anyone using temperaturs will be able to use FDP - this is a win without
>> a maintainance burden attached to it. The change to the FS / application
>> API will not require major changes either; I believe we all agree that
>> we cannot remove the temperatures, so all existing temperature users
>> will be able to continue using them; we will just add an alternative for
>> power users on the side.
>
>As mentioned probably close to a dozen times over this thread and it's
>predecessors:  Keeping the per-file I/O hint API and mapping that to
>FDP is fine.  Exposing the overly-simplistic hints to the NVMe driver
>through the entire I/O stack and locking us into that is not.

I don't understand the "locking us into that" part.

>> So the proposal is to merge the patches as they are and commit to work
>> together on a new, better API for in-kernel users (FS), and for
>> applications (syscall, uring).
>
>And because of that the whole merge it now and fix it later unfortunately
>doesn't work, as a proper implementation will regress behavior for at
>least some users that only have the I/O hints API but try to emulate
>real stream separation with it.  With the per-I/O hints in io_uring that
>is in fact almost guaranteed.

I do not thing this argument is valid. These patches are not a merge now,
fix later. It is ma: use the current interface, work together on a new
one, if needed.

The new interface you are talking about is not clear to me, at all. If
you could share some patches on how that would look like, then it would
give a much clearer idea of what you have in mind. The whole idea of
let's not cover an existing use-case because we might be able to do
something in the future is not very tangible.


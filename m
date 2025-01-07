Return-Path: <io-uring+bounces-5747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B17A049D2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 20:04:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56FDE3A582B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BE818C937;
	Tue,  7 Jan 2025 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Sq52CCdp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hFNKskRK"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02A82594BF;
	Tue,  7 Jan 2025 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276643; cv=none; b=CXRfTuK3gFDtZWLj/kIFcm4DczjRJQcG4Hu1gw4haFgQlATN8Zb+VYWMn6i4hs4JqhmqI5zgOYaIXbGGTh0GKLed8YLvJTabfxIHj2Oh8lWCRJsEng6BAePuiZYZlExixEJqZkcNknyY74PPitmtYkWez2NFXNYtbbxkdG5AD2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276643; c=relaxed/simple;
	bh=B0v5Wf1J9g8T2rsckSgr9tOH+kSnSlQnBA8G0ByaFSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LG+xisUmKA53lX5ej3J0CLCmATKrazsCnEYueodyVlXY0XTfbDJW3HxDkCtxtLtwZnHtT7pm1L8xwvwuPcNDrOdS7c9+6aya3bQw/+pyqH4o78oDNCc8wtHqbVCmwZe8P1DxP9ZYmaKE4KXI4rw8JedPVtJAN0IJ+hbtbzz6mbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Sq52CCdp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hFNKskRK; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D17B8114018C;
	Tue,  7 Jan 2025 14:03:59 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 07 Jan 2025 14:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1736276639;
	 x=1736363039; bh=LNlu29SBoT4cO06+asoL/bU8Mvs0dktvMs3JhJ6uGs0=; b=
	Sq52CCdpUXcVsW7/kylLf3nloQZtQ1K4iAwwkoVh+SgRSJv+MlgPIlm0dqnQON7w
	VLZ9mbDV/h8ydFsFA6IDQZDMJmbOXaTyaz4p1CEpTjTxT5myvC0kVYHtBlnwotaV
	ttx0TRae8eh968qADpdrwsUYZDQNFYdE3/pdUnZwwO2td3Ln8mBKudj72Cvpe8Q0
	BRv7H0XfkBtV/52F+fbznUptVICESoQKroXaoQA45R+2ibpvty+jEqDgpa4XxAjM
	XXyInbm+u0SxG0dsY8o//4KTf4FHAMLhBFZ3KOTGLIOUTlXP9REbl30b/MDz14lN
	i79HJOQCq5lcxgeUldSscA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736276639; x=
	1736363039; bh=LNlu29SBoT4cO06+asoL/bU8Mvs0dktvMs3JhJ6uGs0=; b=h
	FNKskRKlHv50ldCLZuxiI744YiYz4xwcYND74tA0MzAeI2OFJOCB1IxcyK0zRICR
	8GJfu32Q9FOOnbYMbl/lIg58Ul8KD61r0dwOxaXKAvC3fq6Zm+RactPfNvMx1zyK
	nzv4qshp+7cf9tGH6a+5rk2IZPAuqdYHM9bdDeS3C0LEbhyef4mrn/jjcxzwNv19
	0dnHNhTDJ93DtHWL8HP/UNYk1JEuD7pRThreBkeJ4rDpFHr3iRYsGYrYXg0w9+za
	J37uRVlTR2SFCWLz2OxuUkwQ4nk4t99jOAT8GUnH/t6dtKKaZ8qJaInZ3CuQ8v2A
	cUA/F05wIzO2WXEcea6qA==
X-ME-Sender: <xms:n3p9Zw1wHpzT9lFJy7hOqWbswpi7I5i0GD8Nx9fcqCVjJZ_SZMHjyQ>
    <xme:n3p9Z7F_k6sytSs8EvvTLYnCG0qmVfp_gJQQZxvywqiMCF_Z0v1lZSQWr09V_Is6P
    PXKVJZP7AD7mnuh>
X-ME-Received: <xmr:n3p9Z468Er9bNUSL_3e5QYfETS7paC9nTAiqVUSgJplISuttJjdqHeX56z2aWcu_KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudegvddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehluhhishesih
    hgrghlihgrrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdp
    rhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsg
    hovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhm
    rghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:n3p9Z51ILWx7MbNr0v6WSFTCMtTrrqmiUoaGe16vuDV1qVcF6_Ug2g>
    <xmx:n3p9ZzG9hBEgeDq9hneQckYZWjThc9ardu1XwYwWMs3tL-qhBKEYtQ>
    <xmx:n3p9Zy8wkR-uuvnlSiBNkSq9UtHwggQJ37DyK7AFPoUARupgcdHvZw>
    <xmx:n3p9Z4lPDYIx2BAORdU1ZPbpUKHyx_-BM4AP3iBL6UwTOxODYHEYbA>
    <xmx:n3p9ZydEwDD_egn8vs50Yb_TCAcLHq21KqfP-qjfCbf_-2F4wvxeavVJ>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jan 2025 14:03:57 -0500 (EST)
Message-ID: <48e6311c-b5ea-41d6-87b8-dbd782e9f6f5@bsbernd.com>
Date: Tue, 7 Jan 2025 20:03:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/17] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
 <8734hu38ko.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US
In-Reply-To: <8734hu38ko.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/25 17:14, Luis Henriques wrote:
> On Tue, Jan 07 2025, Bernd Schubert wrote:
> 
>> When the fuse-server terminates while the fuse-client or kernel
>> still has queued URING_CMDs, these commands retain references
>> to the struct file used by the fuse connection. This prevents
>> fuse_dev_release() from being invoked, resulting in a hung mount
>> point.
>>
>> This patch addresses the issue by making queued URING_CMDs
>> cancelable, allowing fuse_dev_release() to proceed as expected
>> and preventing the mount point from hanging.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>   fs/fuse/dev.c         |  2 ++
>>   fs/fuse/dev_uring.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++++++---
>>   fs/fuse/dev_uring_i.h |  9 +++++++
>>   3 files changed, 79 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index afafa960d4725d9b64b22f17bf09c846219396d6..1b593b23f7b8c319ec38c7e726dabf516965500e 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -599,8 +599,10 @@ static int fuse_request_queue_background(struct fuse_req *req)
>>   	}
>>   	__set_bit(FR_ISREPLY, &req->flags);
>>   
>> +#ifdef CONFIG_FUSE_IO_URING
>>   	if (fuse_uring_ready(fc))
>>   		return fuse_request_queue_background_uring(fc, req);
>> +#endif
> 

Oh sorry, I had tried to remove the ifdef in v9, but didn't succeed
and added back in the wrong patch.


Thanks,
Bernd


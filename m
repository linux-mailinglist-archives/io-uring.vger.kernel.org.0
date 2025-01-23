Return-Path: <io-uring+bounces-6058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B54A1A4D7
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3FEA16A0A3
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 13:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFB720F989;
	Thu, 23 Jan 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Hr4c5Ny+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nolWJ9j5"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C41E20F07B;
	Thu, 23 Jan 2025 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737638690; cv=none; b=op0aV9NQNxXo9egx6Ljt0jh3aJMk0PBCPiZZYVrOqyg81YowTz68M0QBbBatK/no13r5PRN0IPMNJXjv6ZNo42djjhZmklL2czI7qhN1l2ltnnuKycCXufrnQZEi8L68DK6x5XE8/za5+E4y0iYIBn9BrBx4zdBf2pKK5hsRq80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737638690; c=relaxed/simple;
	bh=uHpFUE8IirztlIdUESRCVcC+ji0J+CxSdbMwcMv2k4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMPT7iZCV3XCfaoMP6JSLi+fK3IgBDxw0h1EtnnKEpFxVRl4u0ezVy8R5tTxUEnbb8obZFSFyA3N72+X5N1GPU8Pf/lRGXBF5i+HFtG66V/PLoDUvIKkpFo3n4AtWYg/eBXiwhjhTb6ciwp3W/0tSLw6BlrzvduSRiGJnhnW5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Hr4c5Ny+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nolWJ9j5; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 7911E1380193;
	Thu, 23 Jan 2025 08:24:47 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 23 Jan 2025 08:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737638687;
	 x=1737725087; bh=DgQm8nSx1FyUSjMxNSHlnTh4J3z9CNv03MlJfWOOlLk=; b=
	Hr4c5Ny+nyfTmgatXpR6BLsmy6ziqbw5mX69lYaac2bOHzC/uhkfG+objgWLdyCn
	wKVwrInNXDsqRzQ45mFTOK07Kgoyb8PLpDOgd+XBWF5C/MtCUGFTY2zc/fQ6Hyxf
	jLyDImUNmdusaf+t/fsttyTo3CppYKSfJgywKUIYQhimQS71HRNLZFLD0Uj4Y22+
	ipxB8R1HJNUFSl0/ewt0uqp9auI80qobi38iZ7XKp4pzT5LOKaR+S4gibO5t17/g
	feng3vnoOeBcXUJHIvnDxmK3fs9NSWNgo5O0rmy7iCLyFprNYV0POvFGpISuSyZt
	V1RPATXMggNud1YyJlSFpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737638687; x=
	1737725087; bh=DgQm8nSx1FyUSjMxNSHlnTh4J3z9CNv03MlJfWOOlLk=; b=n
	olWJ9j5zbKas5auNLW1Cja8pXhD9YIR0Xd1SX+iZCZg+rUjxDyKSNbuRE/RvfWpa
	mZwo8G2USti+QTiF5akQYwaHIiAJ0kahPYNHBDBxys2ZaGLksHY4rCvYl5eBA7NF
	BB6QKRDYWliNhm7j7gB8GI19mykvKSU6zfKDPzd3KzAwPd85UeygO1l9XH95NnBE
	afRdrSLSQKCZdI0rKcK40YoCJDCVtpEV91Z9YZ0ve/FVTG6IxNEZ4mGKvc2PlkCd
	DpG7yp/5AFK9QljktL54DslFSFynGNZA43t5uEaAdHgDbfZds/0jf6T/ciO8hdWv
	PB0SfI6dVlzBCdZHTwu4Q==
X-ME-Sender: <xms:H0OSZ-jd7AeREq275EBaL2aNKtMVbwGgQHknqirviY6W8wbdJnZn6A>
    <xme:H0OSZ_AHDzkHE41sCYmXr1hzM7E7k8rijY5EZXC4wEEwmtUFB6UJWtGcyVDX_8kID
    Zuaw0d0lDknmNuE>
X-ME-Received: <xmr:H0OSZ2FZKDV0SH76aTWFx9ekFmLwIx6GjA1FqpNXNqqlIBHPlp1xKeITLDcfSTcsCYwyMmofWQxTh1J1ATEI8nrtExXYzELj9a7Y6u4J6jX7Sdgw_Y4I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejgedgudejjecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:H0OSZ3SgyqoFbLgyPkcv2njbsswlh3UXOt0Y5SdzRQJ0XnGVKWxcvQ>
    <xmx:H0OSZ7xNooMjFJRPS7YOc2IYJiE5o1UfTYZczFhAyEi1hcW7jVXAAw>
    <xmx:H0OSZ16dKBAsUpUX5RjboHVI3ii2wMe3YZkKN0vs_Q_zYrTQJP3GFA>
    <xmx:H0OSZ4wG82dlYzUl9XqcwboYfqHHShh5rcDrAu5hAQIoLuF8GEkCOw>
    <xmx:H0OSZ-rB3WjHXBXRJ0u2ZCmk4nmEXokbx-jT_1x9CuvDoqsDdMG7uyJD>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jan 2025 08:24:45 -0500 (EST)
Message-ID: <6a2dd294-da76-4dd1-b73f-283a628f78b4@bsbernd.com>
Date: Thu, 23 Jan 2025 14:24:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/17] fuse: {io-uring} Make hash-list req unique
 finding functions non-static
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
 <20250120-fuse-uring-for-6-10-rfc4-v10-9-ca7c5d1007c0@ddn.com>
 <87y0z2etb9.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <87y0z2etb9.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/22/25 16:56, Luis Henriques wrote:
> On Mon, Jan 20 2025, Bernd Schubert wrote:
> 
>> fuse-over-io-uring uses existing functions to find requests based
>> on their unique id - make these functions non-static.
>>
> 
> Single comment below.
> 
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
>> ---
>>  fs/fuse/dev.c        | 6 +++---
>>  fs/fuse/fuse_dev_i.h | 6 ++++++
>>  fs/fuse/fuse_i.h     | 5 +++++
>>  fs/fuse/inode.c      | 2 +-
>>  4 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 8b03a540e151daa1f62986aa79030e9e7a456059..aa33eba51c51dff6af2cdcf60bed9c3f6b4bc0d0 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -220,7 +220,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
>>  }
>>  EXPORT_SYMBOL_GPL(fuse_get_unique);
>>  
>> -static unsigned int fuse_req_hash(u64 unique)
>> +unsigned int fuse_req_hash(u64 unique)
>>  {
>>  	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
>>  }
>> @@ -1910,7 +1910,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
>>  }
>>  
>>  /* Look up request on processing list by unique ID */
>> -static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
>> +struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
>>  {
>>  	unsigned int hash = fuse_req_hash(unique);
>>  	struct fuse_req *req;
>> @@ -1994,7 +1994,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
>>  	spin_lock(&fpq->lock);
>>  	req = NULL;
>>  	if (fpq->connected)
>> -		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
>> +		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
>>  
>>  	err = -ENOENT;
>>  	if (!req) {
>> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
>> index 4a8a4feb2df53fb84938a6711e6bcfd0f1b9f615..599a61536f8c85b3631b8584247a917bda92e719 100644
>> --- a/fs/fuse/fuse_dev_i.h
>> +++ b/fs/fuse/fuse_dev_i.h
>> @@ -7,6 +7,7 @@
>>  #define _FS_FUSE_DEV_I_H
>>  
>>  #include <linux/types.h>
>> +#include <linux/fs.h>
> 
> Looking at these changes, it seems like this extra include isn't really
> necessary.  Is it a leftover from older revs?

Hmm, right, I don't remember anymore why it ended up there. Not even
needed for later patches, so yeah, probably a left-over.


Thanks,
Bernd


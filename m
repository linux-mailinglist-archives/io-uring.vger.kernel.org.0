Return-Path: <io-uring+bounces-10449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9768FC41CD0
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 23:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 42B504E4490
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 22:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7F525D1F7;
	Fri,  7 Nov 2025 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="PDP331MB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Zw1q/CWt"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E62E03E6;
	Fri,  7 Nov 2025 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762553811; cv=none; b=e/IoQNe0lLp7l5tydfCTIkKqPHxjF2YYx8yxN19yc2vjgRKXp79s2DamqGNi71jPdfeK3rl76BvKRw11phFycbPD4ikTWW9oJyzeGsB3ykcXaiN8bCFfZfvUXKszPS3Yp0CNion4PM4EPiJKLVJVyJsdKwX15mQEatTIPkA48zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762553811; c=relaxed/simple;
	bh=c7DfJjmeginOD2WI/S55Pwe+0t5eQ/3CVSYCttbD+ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IAUSCj4Mg5afftUJexfaxcRUY9CTWW8aM96Far29eGAQ+nwhdfL4z2hDaXjbzevW5gcwmgjc0cjMCcXcJe3eXvoul9vQEq5AQnTcu25htwnTQbqFg/HUmYJNEr1A5jG2StyRuWJYAdMPew675LVkOyxqCgQiELSMeBP5nfCMwjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=PDP331MB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Zw1q/CWt; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 2E522EC01D8;
	Fri,  7 Nov 2025 17:16:48 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 07 Nov 2025 17:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762553808;
	 x=1762640208; bh=P93bNvi3KkFHaGknodroYnoML/yzPRSy6Qtc5/9T5wE=; b=
	PDP331MBzBKzL2GLb6styaVJhEYOF1V6AslQoLPPLGtnUO5+rovP1cP4RvTi6/zg
	KDYB3pe2xLWgKhyZXxTdTPnv64lwYDbQftn35M7ICuuZyftY7JgfmOBcpJlO2H96
	FhP4I5JlT1IWRhTu/Ejd0lwtZeEsPMSym6jnliB+9b34wB8qVX5q74KVMzDf0Hpw
	Ht8zMIZKMngq3Mi/04BAYoo3yJt8UJ6pe+cXNRMpcVphpProyQcdcIBZmA/oduNT
	lhPVQ4IxO1udkv8fp91WwY0dybnHLrguO19nwmHoBvaBqhnQ9syG4GiUTn3tf4iy
	vfFNQajIpeoLa0rHZd8Ulg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762553808; x=
	1762640208; bh=P93bNvi3KkFHaGknodroYnoML/yzPRSy6Qtc5/9T5wE=; b=Z
	w1q/CWtACWyWp0HyuhunLBnl25ADvNCesg7ZBpFxWXvkIuvy0Rb2i5OKI9GhsNGc
	M8KLqURxU1deQ90CJ8IHJu2azEIzUPVXHY7I4k4vJ8YTWuauqrX6vZdWtetJKa/N
	aD5TNyuy6eXT9ZSz5MUWUwaIXAYVw2KySD+FDcrs6uRoNqlh3/OxuK5oDapwMalF
	NIJoZ3tUxx72o9vYIcQINyytMSCIDFS2wVySQqcnw/XaAYxOc+rDWC50ialIloOD
	IhHuYkQaPq6w3YnJ9Tr1vyC/m6axbDuqdG7FkM6ygTLh9afEhbiGSrQ//7sQKRBb
	ApZ2/tZ9YsSDM9GDfG8Tg==
X-ME-Sender: <xms:z28OaT7roqY7_WNFNC0B6UmiQfa3L4Tz-gm-FGs_X3B0dCxH8ql2iw>
    <xme:z28Oab_eVCSLG1aoirUYFYR_S3WLAPn4bcDg3U5JEwI9wRKDr50h8C0N53Vi-syux
    Y_DHR6nMs7DCGa_P3bSQIZ04MYNi6aQmRCBXsabUSlP7c-BuYbT>
X-ME-Received: <xmr:z28OaVFJdA7FMyeC61_jVhijPFrIe7Ld7Q8tLjq5SV-tp2TGipi2eW9dVBPQnfoRN_U2FFiVpXRG4sHdbv7WNXoC113jCaPdMRrgGyJOR0u_jYPCERyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduledtkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpedtuedvueduledtudekhfeuleduudeijedvveevveetuddvfeeuvdekffej
    leeuueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtgho
    mhdpnhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehmihhklhho
    shesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukh
    dprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhope
    grshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehiohdquhhr
    ihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeigihgrohgsihhngh
    drlhhisehsrghmshhunhhgrdgtohhmpdhrtghpthhtoheptghsrghnuggvrhesphhurhgv
    shhtohhrrghgvgdrtghomh
X-ME-Proxy: <xmx:z28OaQV1EE_Qx25Yg9YoZp3sMiO9erkWiB8uJFtWqQmRnN22YIyRQw>
    <xmx:z28OaR-6gD2zicvyj6VKOwi6ljMgl-VyGOmSVXQ0qo8BJbU4nbP1lA>
    <xmx:z28Oad4pDRBo0-z_houVEtILfME1HfJkcu5UPcIF1iVPGuRZjJ2vDw>
    <xmx:z28OaakJW0-29u575RVL0OVxGshL3zEQc8wJV5iITYouD7IQyaKetw>
    <xmx:0G8OacCmZ4Q7fnml_4x15oYAjumqMNmTQe7cLyJYb0cfueuBiN9QCx-B>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Nov 2025 17:16:46 -0500 (EST)
Message-ID: <bf239433-741b-4af1-ae72-ee5dbb1f5834@bsbernd.com>
Date: Fri, 7 Nov 2025 23:16:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com>
 <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
 <CAJnrk1YPEDUbOu2N0EjfrkwK3Ge2XrNeaCY0YKL+E1t7Z8Xtvg@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1YPEDUbOu2N0EjfrkwK3Ge2XrNeaCY0YKL+E1t7Z8Xtvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/7/25 00:09, Joanne Koong wrote:
> On Thu, Nov 6, 2025 at 11:48 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> On 10/27/25 23:28, Joanne Koong wrote:
>>> Add support for io-uring registered buffers for fuse daemons
>>> communicating through the io-uring interface. Daemons may register
>>> buffers ahead of time, which will eliminate the overhead of
>>> pinning/unpinning user pages and translating virtual addresses for every
>>> server-kernel interaction.
>>>
>>> To support page-aligned payloads, the buffer is structured such that the
>>> payload is at the front of the buffer and the fuse_uring_req_header is
>>> offset from the end of the buffer.
>>>
>>> To be backwards compatible, fuse uring still needs to support non-registered
>>> buffers as well.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++---------
>>>  fs/fuse/dev_uring_i.h |  27 +++++-
>>>  2 files changed, 183 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>> index c6b22b14b354..f501bc81f331 100644
>>> --- a/fs/fuse/dev_uring.c
>>> +++ b/fs/fuse/dev_uring.c
>>>
>>> +/*
>>> + * Prepare fixed buffer for access. Sets up the payload iter and kmaps the
>>> + * header.
>>> + *
>>> + * Callers must call fuse_uring_unmap_buffer() in the same scope to release the
>>> + * header mapping.
>>> + *
>>> + * For non-fixed buffers, this is a no-op.
>>> + */
>>> +static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
>>> +{
>>> +     size_t header_size = sizeof(struct fuse_uring_req_header);
>>> +     struct iov_iter iter;
>>> +     struct page *header_page;
>>> +     size_t count, start;
>>> +     ssize_t copied;
>>> +     int err;
>>> +
>>> +     if (!ent->fixed_buffer)
>>> +             return 0;
>>> +
>>> +     err = io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->cmd, 0);
>>
>> This seems to be a rather expensive call, especially as it gets
>> called twice (during submit and fetch).
>> Wouldn't be there be a possibility to check if the user buffer changed
>> and then keep the existing iter? I think Caleb had a similar idea
>> in patch 1/8.
> 
> I think the best approach is to get rid of the call entirely by
> returning -EBUSY to the server if it tries unregistering the buffers
> while a connection is still alive. Then we would just have to set this
> up once at registration time, and use that for the lifetime of the
> connection. The discussion about this with Pavel is in [1] - I'm
> planning to do this as a separate follow-up.
> 
> [1] https://lore.kernel.org/linux-fsdevel/9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com/

Hmm, I had seen this discussion, but I don't find anything about
preventing unregistration?


Thanks,
Bernd


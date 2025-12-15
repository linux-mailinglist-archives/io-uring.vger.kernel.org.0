Return-Path: <io-uring+bounces-11041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D67CBC9F5
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 07:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0104E300F89E
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 06:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73D02192FA;
	Mon, 15 Dec 2025 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hPE5PTzg"
X-Original-To: io-uring@vger.kernel.org
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E0D15E97
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 06:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765779973; cv=none; b=uyhDsJ5S2VmLqe+6813H3TPOadCtAkFB2JlAt7l7oTm+MdCGUCEVVV+TcAuvnf3AaXXNSOoJ4VI+IFLq/c3rs+wQFUvb4peDc5S2CMG58WQAj/SnwBGelEggWgY45zec3c8njNN3N3vwf2M0Zhb0sYZZouG6WiaeTVHpD4GDcKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765779973; c=relaxed/simple;
	bh=7wH+fa5DQSu9kNNYXzyR4uCQBuqvXzQ46EkqFn5zQoc=;
	h=To:Cc:From:Subject:Content-Type:References:In-Reply-To:Date:
	 Mime-Version:Message-Id; b=pE3dCPcf+qkkAAraa8D6e2/sIEUlmmVhhUWtRfL5z27kzbqZVcM1MkRbc8x3Z1/pVxxRGDaHaQfMROeXXfHb4hsh4AGn+KSwZPJt5dlWO9j8TrHsvKI+UAW39/g1aGIXXt73dm2fz8lOqYlMzAJCWtmc0dY9HhuRWUT6XVEy/4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hPE5PTzg; arc=none smtp.client-ip=118.26.132.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1765779957; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=2t9FrE6uqzjNLLvyAQ5DR2hG8fjnMOwX78vgU44pPoE=;
 b=hPE5PTzg4tiRw7nFFISWEtVePjeCoLLf1bAh5GocyOOC5kBGTcmtcHh35kHqlqs5kZSm9i
 3hH6Xb5ysUAA9pSmF8CFo7tR3jAdJe8b+Yun7ChBse7CyYAYfxAd9uQP36rNpUvLhrsYl+
 gJXIbTiggg3hFD/9zyYuKRMD4OQkd0tL9ciSogdpMAL1o8pgDWVlSj9ek5W2LoioT1NlH9
 3aan4nK0LmxQWigduPguuXae84GRxBZS9FVdMPnJW8HrwzWlpv0JMrVHWX3rRMCXfzeYaT
 TcSUhsqwbj0nT51W7TRUx7ICCvL1ufWF5ffR1zxoZP6Bxwr2vqwk7tUPWlfpNw==
User-Agent: Mozilla Thunderbird
To: "Jens Axboe" <axboe@kernel.dk>, "Fengnan Chang" <fengnanchang@gmail.com>, 
	<asml.silence@gmail.com>, <io-uring@vger.kernel.org>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
From: "Diangang Li" <lidiangang@bytedance.com>
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
References: <20251210085501.84261-1-changfengnan@bytedance.com> <20251210085501.84261-3-changfengnan@bytedance.com> <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk> <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk> <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com> <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk> <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk> <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com> <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk> <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com> <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk> <b640d708-6270-4946-916d-350d323f1678@bytedance.com> <95358f2c-d739-4dc1-b423-6ac3cbd96225@kernel.dk>
X-Lms-Return-Path: <lba+2693fa9f3+fe2e0d+vger.kernel.org+lidiangang@bytedance.com>
In-Reply-To: <95358f2c-d739-4dc1-b423-6ac3cbd96225@kernel.dk>
X-Original-From: Diangang Li <lidiangang@bytedance.com>
Date: Mon, 15 Dec 2025 14:25:44 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Message-Id: <0ee133c7-d78d-45fc-afb2-0f398cb159ef@bytedance.com>

On 2025/12/13 04:09, Jens Axboe wrote:
> On 12/12/25 6:32 AM, Diangang Li wrote:
>>> @@ -1327,17 +1326,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool =
force_nonspin)
>>>    	if (ctx->poll_multi_queue || force_nonspin)
>>>    		poll_flags |=3D BLK_POLL_ONESHOT;
>>>   =20
>>> +	/*
>>> +	 * Loop over uncompleted polled IO requests, and poll for them.
>>> +	 */
>>>    	list_for_each_entry(req, &ctx->iopoll_list, iopoll_node) {
>>>    		int ret;
>>>   =20
>>> -		/*
>>> -		 * Move completed and retryable entries to our local lists.
>>> -		 * If we find a request that requires polling, break out
>>> -		 * and complete those lists first, if we have entries there.
>>> -		 */
>>> -		if (READ_ONCE(req->iopoll_completed))
>>> -			break;
>>
>> Suggest keeping iopoll_completed here to avoid unnecessary subsequent
>> polling and to process IRQ-completed requests promptly.
>=20
> There should not be any IRQ completed requests in here. The block layer
> used to allow that, but that should no longer be the case. If it's a
> polled request, then it will by definition end up in a polled queue and
> need iopoll completion. Or it'll sit for a while and be completed by a
> timeout. If someone is still allowing polled IO with IRQ completions
> then that should be fixed, and there's no reason why we should try and
> catch those cases here. Will not happen with NVMe, for example.
>=20

Hi Jens,

Before commit 958148a6ac06 ("block: check BLK_FEAT_POLL under=20
q_usage_count"), if IORING_SETUP_IOPOLL was set, IO would still proceed=20
even with zero poll queue. It would be redirected to default queues and=20
still linked to ctx->iopoll_list. After that commit, these cases return=20
BLK_STS_NOTSUPP.

While tests show the split path still exits: a split clears REQ_POLLED=20
and sends the child to the default queue, yet the IO remains on=20
iopoll_list. Is this the situation you=E2=80=99re referring to previously i=
n our=20
original patch with doubly-linked lists, that it's not necessarily safe=20
to manipulating the list in io_complete_rw_iopoll?

> For the other point, there's no way for ->iopoll_completed to be set
> before iob.complete(&iob) has been called to invoke the callback, which
> in turn sets it. Hence there's no way for us to end up in this loop and
> have ->iopoll_completed set.
>=20

Also, blk_mq_add_to_batch may return false for various reasons, so it's=20
possible that the IO may complete earlier before we end up poll loop.

> So no, I don't think we need it, and honestly it wasn't even really
> needed the posted changes either.
>=20



Best,
Diangang


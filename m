Return-Path: <io-uring+bounces-6038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9939CA1892F
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AF533A29FF
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D138EED8;
	Wed, 22 Jan 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="duLGifmA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ID3Wy9qG"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF468EAC6;
	Wed, 22 Jan 2025 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507349; cv=none; b=ZKoDnbURf5KnQWQcn+N2KVh8dCe8jPugXhGQVPAI8gzCBpf7ovo8yZddo6e4oM2GrCMc4q7lT1//k7QH7mxUUquYGwQPtaQ2MX5TkTHdyYlTpypGapMII7tkJRPatFLQgXK43wtMC3nmdU5n6vunxn63j0/YgfHRmSbM3idKL7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507349; c=relaxed/simple;
	bh=R2hyMqeSnE54JubRGXTsDXr5iG+s6MJw53dPfMaQGg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sUIC57mqY0o5Rnx4FLdQMHkqTUemprjy7WN/5+taOAcCZDkV6Yp+r3L40DOZ6f5KovLXgyJlmtth/mWj4RMNDT3MU6G+THy7ocojYNTs5W4pibLq00efl3mE2FOL3L484ZH97piyCEaQDfTfDT/mye4ofzV4VadaQdOaqRilz5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=duLGifmA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ID3Wy9qG; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B3A622540232;
	Tue, 21 Jan 2025 19:55:45 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 21 Jan 2025 19:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737507345;
	 x=1737593745; bh=lrB0JFurcrxnnMrHJrVO/GO7PI7eoSyF2/GvO1TnIHw=; b=
	duLGifmA4CO4KjMj8ggSVcWHSl5pBc/GEnfYSzDGmY/1wX3hxa1lmhFcn7jjIRS/
	QPk1uOwb5tL6mHl1gtOU7OusBtVi2XLu7+8knLvAjgsDywb4TvoR4yCI2B8COY9h
	5DlMjKOhRqTUQdZbBQcYphCVcFhDkOCNwASOqQTrUH0MEHPrvDF/MnAMk5d/LG6m
	IlFnjw2OSVhrZqHBjyJb3jHHWGEem2pjUdAvDqGzRKPGf7Zc9TcumAQpqC/f+6Fo
	xn2L+f8QA7j2ggv/XHxQlr//hfnbG1G/B95sZQJLB90oAjfIBXDDneKLs2Iva8lo
	SdvVhNggQ/sGmgD/fBL0zA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737507345; x=
	1737593745; bh=lrB0JFurcrxnnMrHJrVO/GO7PI7eoSyF2/GvO1TnIHw=; b=I
	D3Wy9qGLZS57Q7eqZew36PTrsWqOflht2oyPBA7xclbC6cfJq9IlkOga19zZ1JDj
	R4dA3qXhP3HGF72GiTSvlw7Pv5imrOsj/HSjEb3PzWP51wz1+wd9pN+/ooOiq90H
	pJ5YNlZwZwwMc+SkaWqIN81jOl/4XG1oGn2rqd+Ln78N2sgN6qP+7+0iTbWUYtfQ
	UXrpHdUTobonoDt7ejpC79eAKAMRCPz0yY53QNpj1ObztqufeuXpvjTaoMJ+7zpo
	3cUNHC9fEA/droAOfO3+CKwZ33Y75zpK0usUPr/w6IXSVBLtbd2KF7WPUpICjRVm
	Sygyz6OURjLvSmG0xkD4w==
X-ME-Sender: <xms:EUKQZ9LYRhzsVoUu0fEwIpXLkPbrNIhQZoiyyt3B2PhZ1xgYVeo1Yw>
    <xme:EUKQZ5IZhfacHyw6qiwfe23R3zJHY2u8mLiIxo8BwLHBC5vNvBamCEZCTmdqemBeU
    rlCE2QGUblnxxKb>
X-ME-Received: <xmr:EUKQZ1tnnbF8ooicKMyEmTDDzW8woDmpZqLeOTpYclhF_gfnNpqBzL_1TuaN4416afZAj3K7ngEqbLhEYA6Wbl_IqYbhG0BfkMnTLXU8Hr9cB5Zy6NHF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffeh
    udejvdfgteevvddtfeeiheeflefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlh
    hkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggu
    nhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpth
    htoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgv
    nhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnug
    grrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:EUKQZ-YvqIEVg6lBLSOmFHsneSGy5Ph6Yrf8JmzEjIHyAQLhGcKPDA>
    <xmx:EUKQZ0bN8CeMs8Wgms-WAKqEZ_hX8VPqqI46p-aL1k3Da8znZJ3UyA>
    <xmx:EUKQZyDnYssX5igJ2FeFfjRHs54gRBpXztSfJAt5LCj0IBCFpBi6_g>
    <xmx:EUKQZya64LjYMvpUE1Q74ur8UHJAAvwDkBwbyHAHs_BLFyCCgm_KbQ>
    <xmx:EUKQZ-ABAWPBO4DT2cbrKVkytQ9Kq5L7X-Hj2CBODXuMqBQsqv7oZTBB>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jan 2025 19:55:43 -0500 (EST)
Message-ID: <2ccdb79c-fb2a-46be-8e3d-ac92a19e32f1@bsbernd.com>
Date: Wed, 22 Jan 2025 01:55:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
 <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com>
 <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
 <605815bc-40ca-49c1-a727-a36f961b8ad6@bsbernd.com>
 <CAJnrk1bg_ZwuV1w8x6to50_LYk+o6=HAzC_eQ_U4QGLkyXVwsA@mail.gmail.com>
 <48989a7f-0536-496b-8880-71bfc5da5c19@bsbernd.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <48989a7f-0536-496b-8880-71bfc5da5c19@bsbernd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/22/25 01:49, Bernd Schubert wrote:
> 
> 
> On 1/22/25 01:45, Joanne Koong wrote:
>> On Tue, Jan 21, 2025 at 4:18 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>>
>> ...
>>>>>
>>>>>>
>>>>>>> +
>>>>>>> +       err = fuse_ring_ent_set_commit(ring_ent);
>>>>>>> +       if (err != 0) {
>>>>>>> +               pr_info_ratelimited("qid=%d commit_id %llu state %d",
>>>>>>> +                                   queue->qid, commit_id, ring_ent->state);
>>>>>>> +               spin_unlock(&queue->lock);
>>>>>>> +               return err;
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       ring_ent->cmd = cmd;
>>>>>>> +       spin_unlock(&queue->lock);
>>>>>>> +
>>>>>>> +       /* without the queue lock, as other locks are taken */
>>>>>>> +       fuse_uring_commit(ring_ent, issue_flags);
>>>>>>> +
>>>>>>> +       /*
>>>>>>> +        * Fetching the next request is absolutely required as queued
>>>>>>> +        * fuse requests would otherwise not get processed - committing
>>>>>>> +        * and fetching is done in one step vs legacy fuse, which has separated
>>>>>>> +        * read (fetch request) and write (commit result).
>>>>>>> +        */
>>>>>>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
>>>>>>
>>>>>> If there's no request ready to read next, then no request will be
>>>>>> fetched and this will return. However, as I understand it, once the
>>>>>> uring is registered, userspace should only be interacting with the
>>>>>> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
>>>>>> where no request was ready to read, it seems like userspace would have
>>>>>> nothing to commit when it wants to fetch the next request?
>>>>>
>>>>> We have
>>>>>
>>>>> FUSE_IO_URING_CMD_REGISTER
>>>>> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
>>>>>
>>>>>
>>>>> After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
>>>>> requests and waiting. After it gets a request assigned and handles it
>>>>> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
>>>>> miss that _CMD_REGISTER will already have it waiting?
>>>>>
>>>>
>>>> Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
>>>> it seems possible that there is no fuse request waiting until a later
>>>> time? This is the scenario I'm envisioning:
>>>> a) uring registers successfully and fetches request through _CMD_REGISTER
>>>> b) server replies to request and fetches new request through _COMMIT_AND_FETCH
>>>> c) server replies to request, tries to fetch new request but no
>>>> request is ready, through _COMMIT_AND_FETCH
>>>>
>>>> maybe I'm missing something in my reading of the code, but how will
>>>> the server then fetch the next request once the request is ready? It
>>>> will have to commit something in order to fetch it since there's only
>>>> _COMMIT_AND_FETCH which requires a commit, no?
>>>>
>>>
>>> The right name would be '_COMMIT_AND_FETCH_OR_WAIT'. Please see
>>> fuse_uring_next_fuse_req().
>>>
>>> retry:
>>>         spin_lock(&queue->lock);
>>>         fuse_uring_ent_avail(ent, queue);           --> entry available
>>>         has_next = fuse_uring_ent_assign_req(ent);
>>>         spin_unlock(&queue->lock);
>>>
>>>         if (has_next) {
>>>                 err = fuse_uring_send_next_to_ring(ent, issue_flags);
>>>                 if (err)
>>>                         goto retry;
>>>         }
>>>
>>>
>>> If there is no available request, the io-uring cmd stored in ent->cmd is
>>> just queued/available.
>>
>> Could you point me to where the wait happens?  I think that's the part
>> I'm missing. In my reading of the code, if there's no available
>> request (eg queue->fuse_req_queue is empty), then I see that has_next
>> will return false and fuse_uring_next_fuse_req() /
>> fuse_uring_commit_fetch() returns without having fetched anything.
>> Where does the "if there is no available request, the io-uring cmd is
>> just queued/available" happen?
>>
> 
> You need to read it the other way around, without "has_next" the 
> avail/queued entry is not removed from the list - it is available 
> whenever a new request comes in. Looks like we either need refactoring 
> or at least a comment.

It also not the current task operation that waits - that happens in
io-uring with 'io_uring_submit_and_wait' and wait-nr > 0. In fuse is is
really just _not_ running io_uring_cmd_done() that make ent->cmd to be
available.

Does it help?


Thanks,
Bernd


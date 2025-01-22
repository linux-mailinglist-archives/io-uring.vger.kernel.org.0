Return-Path: <io-uring+bounces-6037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F1AA1892C
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A8601888238
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BE3EAC6;
	Wed, 22 Jan 2025 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="QQqMql3a";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Z6eTEGW8"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D83815AF6;
	Wed, 22 Jan 2025 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737506981; cv=none; b=IrcoN+Rlk4CpMRr9uo0Pb+FJtPuknSXDrYxUFpT8oQBF5zmmb34/9/pPlZnP1iJj/hWuRjlXoZwfCNXqi+YXGGwAgr7XShxC1YqtDDTR3wOBWIpIaOJJD2hBk7HhuUeeVgDiMakxd0NP7x1SQibdcJa9d0MrmYjUr8UYjrAlSBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737506981; c=relaxed/simple;
	bh=/jB3RrevZsKVpwarwDvxdu0KqfxhQKrO63ViejvmuyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lrezryhi/gHNI+p7kZh4+nCk51HlY4QKQ/EuWpq6Kwr9cQJZqyDDP0pH3t43lbKS4pWuwJMe8KPHAcQS5bo8EZscJv5bfz+hKybPOiNrEQxPcdZqAUWU95dBZjtRgAncP5RJGasTKRYaU/MJzUOSO/9NlzedU0WKidpTIxILLZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=QQqMql3a; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Z6eTEGW8; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id D202011401F5;
	Tue, 21 Jan 2025 19:49:37 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 21 Jan 2025 19:49:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737506977;
	 x=1737593377; bh=jw+p8XHyrc/k/kq2s1CViowDb9c049fBOGN+vcWqqgI=; b=
	QQqMql3aeW0Qt0+In0AiCDL+ZM7wOySBXURbr+wWgy63wMkfqDcP7Aa/6u5MIl2S
	LuMJctGVJbMTSfB0TvCaDHDX3ZZNZBkfmpVVEILZbedsp2LiY3pKjDGGKbVQXBIQ
	YmE78ZjZ5aESvmXUFEzTCWo4M1otNXkwD2Upqdhoo4KIMWf4XBX94BJpY+chuoVU
	ljxoB4iFKeHBtiUYMK6pUQ5ZWplfurct2y3G1QAS+OPDbMJrxxfPbuiY3OqjZB4+
	0dx0ys6H86Q4Qkt6GBbPK3P/4PPBsLnwoq3OhHRdinbncnQAzhyHphdEF2iAH/qv
	0Dji4FDzdxeOeURGisFnkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737506977; x=
	1737593377; bh=jw+p8XHyrc/k/kq2s1CViowDb9c049fBOGN+vcWqqgI=; b=Z
	6eTEGW88zDf7zMWNYHFEcZMDv3kgk5qyr9cXErNFjckfxA1xCgtoRbxp/L/9r/+g
	LE4Fzw3lZmr9HT4Wp7HfuMxbCARvFt0f0Qxuvn4DTd9HTpc2ut3KZombbVUQqCMB
	fO4FTv82q0svzI2nnowcj6cO+/WauVGe8fSsM0zUa0xX0mnm2RNlhQRxldZj986N
	yT07NCKTcaC80EMt218smt31G/XaaKaG3oG7Wt0mJrQVdvw3O/fpSt+Yr704DHst
	BXnX7oCDEGiL8CFTVOnkYmCklCq+DYFn9FdpcP3eFKwQNraaOaCW5RgqG+XkfjPT
	jAEY8NDQbcfKHa7UacZ2w==
X-ME-Sender: <xms:oECQZ1ws7QHU6BlEgQO9lKBXXPYwtMWY0YA3aqxqakkxGcKzq_SdoA>
    <xme:oECQZ1SnnNyQBM7m1VdG3nAVlwHTxotsJyli5lwQ8QxS2pgk9U2KL8sDtwkgpQxUj
    EpY5SwZTI9AHIym>
X-ME-Received: <xmr:oECQZ_UO2b3A1aBQGSPf_yS_mk0sRDIW5tKxVjQW-YAlBk4GSjAlE2L8AiwAojtQOjeSgBacyC7zXNgxhIoEFX1wlW8v3pA5NxlJXbLq0-RVBMBYjRRJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgvdeiucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:oECQZ3joml1wxozh5uH0nIM9Y-nN4skOySSaSB54jq1DCA5U2LDVQQ>
    <xmx:oECQZ3CPtKIEanIii5fPAbeloAdu_ENHlKTYZyRBP0m4QGgjCQf7BQ>
    <xmx:oECQZwJP5ltzmLqV3u5crTT7Q6ZtDAfEmK3Uqb4_5tzMqe0vuTmD0w>
    <xmx:oECQZ2ABgRD8Zgao5gjMqnYvR3smnTYZ65s0Db1QsPSSqJDi9lT_JQ>
    <xmx:oUCQZ0Imlu35E0nfHAdA_RTvVhVN0N60Oa4WmGwrlHhRAf1RQY-Ar7qi>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jan 2025 19:49:35 -0500 (EST)
Message-ID: <48989a7f-0536-496b-8880-71bfc5da5c19@bsbernd.com>
Date: Wed, 22 Jan 2025 01:49:34 +0100
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
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1bg_ZwuV1w8x6to50_LYk+o6=HAzC_eQ_U4QGLkyXVwsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/22/25 01:45, Joanne Koong wrote:
> On Tue, Jan 21, 2025 at 4:18 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
> ...
>>>>
>>>>>
>>>>>> +
>>>>>> +       err = fuse_ring_ent_set_commit(ring_ent);
>>>>>> +       if (err != 0) {
>>>>>> +               pr_info_ratelimited("qid=%d commit_id %llu state %d",
>>>>>> +                                   queue->qid, commit_id, ring_ent->state);
>>>>>> +               spin_unlock(&queue->lock);
>>>>>> +               return err;
>>>>>> +       }
>>>>>> +
>>>>>> +       ring_ent->cmd = cmd;
>>>>>> +       spin_unlock(&queue->lock);
>>>>>> +
>>>>>> +       /* without the queue lock, as other locks are taken */
>>>>>> +       fuse_uring_commit(ring_ent, issue_flags);
>>>>>> +
>>>>>> +       /*
>>>>>> +        * Fetching the next request is absolutely required as queued
>>>>>> +        * fuse requests would otherwise not get processed - committing
>>>>>> +        * and fetching is done in one step vs legacy fuse, which has separated
>>>>>> +        * read (fetch request) and write (commit result).
>>>>>> +        */
>>>>>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
>>>>>
>>>>> If there's no request ready to read next, then no request will be
>>>>> fetched and this will return. However, as I understand it, once the
>>>>> uring is registered, userspace should only be interacting with the
>>>>> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
>>>>> where no request was ready to read, it seems like userspace would have
>>>>> nothing to commit when it wants to fetch the next request?
>>>>
>>>> We have
>>>>
>>>> FUSE_IO_URING_CMD_REGISTER
>>>> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
>>>>
>>>>
>>>> After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
>>>> requests and waiting. After it gets a request assigned and handles it
>>>> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
>>>> miss that _CMD_REGISTER will already have it waiting?
>>>>
>>>
>>> Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
>>> it seems possible that there is no fuse request waiting until a later
>>> time? This is the scenario I'm envisioning:
>>> a) uring registers successfully and fetches request through _CMD_REGISTER
>>> b) server replies to request and fetches new request through _COMMIT_AND_FETCH
>>> c) server replies to request, tries to fetch new request but no
>>> request is ready, through _COMMIT_AND_FETCH
>>>
>>> maybe I'm missing something in my reading of the code, but how will
>>> the server then fetch the next request once the request is ready? It
>>> will have to commit something in order to fetch it since there's only
>>> _COMMIT_AND_FETCH which requires a commit, no?
>>>
>>
>> The right name would be '_COMMIT_AND_FETCH_OR_WAIT'. Please see
>> fuse_uring_next_fuse_req().
>>
>> retry:
>>         spin_lock(&queue->lock);
>>         fuse_uring_ent_avail(ent, queue);           --> entry available
>>         has_next = fuse_uring_ent_assign_req(ent);
>>         spin_unlock(&queue->lock);
>>
>>         if (has_next) {
>>                 err = fuse_uring_send_next_to_ring(ent, issue_flags);
>>                 if (err)
>>                         goto retry;
>>         }
>>
>>
>> If there is no available request, the io-uring cmd stored in ent->cmd is
>> just queued/available.
> 
> Could you point me to where the wait happens?  I think that's the part
> I'm missing. In my reading of the code, if there's no available
> request (eg queue->fuse_req_queue is empty), then I see that has_next
> will return false and fuse_uring_next_fuse_req() /
> fuse_uring_commit_fetch() returns without having fetched anything.
> Where does the "if there is no available request, the io-uring cmd is
> just queued/available" happen?
>

You need to read it the other way around, without "has_next" the 
avail/queued entry is not removed from the list - it is available 
whenever a new request comes in. Looks like we either need refactoring 
or at least a comment.


Thanks,
Bernd





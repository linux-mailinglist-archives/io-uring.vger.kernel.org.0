Return-Path: <io-uring+bounces-13190-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDx/MJKJ82md4wEAu9opvQ
	(envelope-from <io-uring+bounces-13190-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 18:55:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E31244A615A
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 18:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 478A5300ED8F
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 16:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2A33644C5;
	Thu, 30 Apr 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="eGoW59UF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BC3ODFMR"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470132D7DCF
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777568144; cv=none; b=CqzcJwLPqI4QqIcgLhTysdEO28LIF6d9ZLD3NkrOIeKtEBnLMbTDGyuHnKQ8Ujj5O9kZPC6FdCWUJmozhLUpeLLMZNgyS1fYbqzMimr/PohSSSWesMNuv51wWVWpF7Q5v6WvN1mSNbWaUeabiq++tH3+b5eyuCiKyY8hS/h2XYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777568144; c=relaxed/simple;
	bh=GRRMzWA4EJa9O3DE6AgldsLnCCey/2uDpFP4O71jXDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKeAzpMizoeqg2PmIzV2PTzRdBf1KCXt+nUHHnOB3XbIOx2yJ618EWBQYuqCVosf0Zz1NyeYYX8WZs/QHpE9b0aI7oMrVeiRQ+K+Mm/OxrTk3PPh/lcoNtiR2HuXQlNF5yusGnAYqqSJZPUujROTm4yuE4TemilEaZNGmIPWsg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=eGoW59UF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BC3ODFMR; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 8566DEC00BC;
	Thu, 30 Apr 2026 12:55:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 30 Apr 2026 12:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777568141;
	 x=1777654541; bh=lShF5DSPw0lg0kJ9hoCpdJtx8Yly6TKrspn74m0tQws=; b=
	eGoW59UFttuenmQIKCScBDi1m9ksrG8HLy5jIU3RQbCTczbvOnsuJdXPCxRVETCw
	g1qR6E0h0CsTrrnLPWJmdOLZ2YUjGSn66FLg9oJYvdDLmYBMMGX+sPrYZw1AOtLO
	q+3GnfSBWYc3RaeVwW7WvEpSs6S6Ajn/6kdLmFvYR6iSqrGgXKFnT1LU5DQPWVnt
	Zyt0ITktAX1lWZ1zwWVGvEnxuh2f+i0Kw+9qZ6HDJNQu8yqVIFTU8F+mpK9nsyDS
	6q4UQryJcAM4pGaDV+OlqLDP2xqDYZAv/Guta8N3gp6IIUXk98XX/kHnHkiTL1WU
	kFBFM1IGatKAg0nwhFLfjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777568141; x=
	1777654541; bh=lShF5DSPw0lg0kJ9hoCpdJtx8Yly6TKrspn74m0tQws=; b=B
	C3ODFMRa1OKGZ5PSpSLxV2Qyx5oRtGOWQZsYqp+bAQQxQ6OtuqgC6GjVRaCZ9hZz
	v4v+0kLcmrTM2Br32bFSl2sFp6KS7kAqcWzr8tD8S1vvZfNcnwG/wredQR5cukYx
	G0ZDM4mGOHZWnfilOxeQc4KuEdMx0t26IMw/5Ii+uE9Qhwz9GoGlrl3H09ddF+v9
	cjWhZBUzpSgykUtW7kztzKtOQlMjF3cdfeDupa9crttF9WOmri3FxfrLzvCOsWws
	0HU6XvbtRwqY6HumkEAiduSHLsfcNXmw717eKcui1WyH/RD1Jn48L86XdTQIwEjS
	P+Ils/qNf2rr8QAczHjSg==
X-ME-Sender: <xms:jInzaUNK6LqupovFB44y0jpnaNz9xaOGh791XTOauzBY1UyG28OsZQ>
    <xme:jInzaU_uTEwwazMiK3BhAS5ETWU5eHqvjITfQCOBU8S3eyS_LhjwYMDqz78dYmuU4
    ny2ZXQF179Qj0HwBo9qurAsGnOc7RY5lGQ9DLMUUI4kc3p9EdoM>
X-ME-Received: <xmr:jInzaR4A7_VB-3-hhKAWGstR0EoFExyQNhq22a2_f5PDSvTzaISD7o0RikGVqz_0_1avZjf7S77lcFq1zd-OtttoZ4k9jxKW3uZPdBPFBkCuTAAZDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnheptdeuvdeuudeltddukefhueeludduieejvdevveevteduvdefuedvkeffjeel
    ueeunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhm
    pdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjoh
    grnhhnvghlkhhoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehmihhnghdrlhgv
    ihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfhhushgvqdguvghvvghlsehlihhsth
    hsrdhlihhnuhigrdguvghvpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtph
    htthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehm
    ihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtohepthhomhdrlhgvihhmihhngh
    esghhmrghilhdrtghomh
X-ME-Proxy: <xmx:jInzaa7-PXFg4kDzJLmyOD2_9bJzPHPZdLl5OzE-NcIJm2jlKK1MCQ>
    <xmx:jInzaaoUYRnN7DTEajS4AwTaW3IXWwGIOMLGe4jrtO_5r20nFxs2fA>
    <xmx:jInzabNoUrIa508sdn9w2P0GyWQ9Tnq5PmWGfZNjUiFHuVs-AxslfQ>
    <xmx:jInzaS07ST1583ORYVEc5aQuKN6VNoSRdKUw7SYR8tsZ9WK2CUKlTQ>
    <xmx:jYnzaVmiSndZ87seVQftrxZhMXgt4Ul_tf4bLUVsdtlwBDOdW30fxpq3>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 12:55:39 -0400 (EDT)
Message-ID: <ce972429-cd32-48d1-9dd0-02a0d511939f@bsbernd.com>
Date: Thu, 30 Apr 2026 18:55:38 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fuse/io-uring: Proposal to support pBuf in additon to kBuf
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, fuse-devel@lists.linux.dev,
 io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
 "Lei, Ming" <tom.leiming@gmail.com>
References: <18936160-308a-4817-a295-54eef43707a3@niova.io>
 <CAFj5m9LeM4S82QEsRQ0uQiXj1eWCFAW3v2fLTxUj1YM7UO-V9g@mail.gmail.com>
 <fcad39e2-37b5-46a9-a280-2315e0397985@niova.io>
 <CAJnrk1Yw3=z7W_my4pLG6avBeDZkUp3j1LZk-RVpGv2vAsw-ZA@mail.gmail.com>
 <b2037b8f-466c-47d4-b74b-fe5b8f38fbc4@bsbernd.com>
 <CAJnrk1aOTdDCOY-3F_urPbasRMFy+0DDLADWU2zss=D+8xaonQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <CAJnrk1aOTdDCOY-3F_urPbasRMFy+0DDLADWU2zss=D+8xaonQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E31244A615A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,szeredi.hu];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13190-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,niova.io:email]



On 4/30/26 17:20, Joanne Koong wrote:
> On Wed, Apr 29, 2026 at 11:09 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> Hi Joanne,
>>
>> sorry my terribly late reply, takes about 30 min to reply for these
>> complex discussions and finding that time is currently a bit hard.
> 
> No worries, thanks for taking the time to reply.
> 
>>
>> On 4/17/26 23:02, Joanne Koong wrote:
>>> On Thu, Apr 16, 2026 at 7:46 AM Bernd Schubert <bernd@niova.io> wrote:
>>>>
>>>> Hi Ming,
>>>>
>>>> On 4/16/26 15:49, Ming Lei wrote:
>>>>> Hi Bernd,
>>>>>
>>>>> On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
>>>>>>
>>>>>> And my current primary goal is to let ublk to support multiple buffer
>>>>>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
>>>>>
>>>>> Ublk server is just one liburing application, and it supports all generic
>>>>> io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
>>>>> in theory.
>>>>>
>>>>> It really depends on how your ublk server is implemented.
>>>>>
>>>>> Maybe you can share your motivation first before discussing kbuf/pbuf support.
>>>>> If it is for DMA,  there are other candidates too, such as hugepage,
>>>>> recent added
>>>>> UBLK_U_CMD_REG_BUF, ...
>>>> Joanne had actually removed kBuf and switched to pBuf alone and that
>>>> simiplifies things a bit.
>>>
>>> Hi Bernd,
>>>
>>>>
>>>> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
>>>> saturate streaming bandwidth, but still want to get smaller IOs through,
>>>> for these smaller IOs you don't want to assign the 1MB buffer for each
>>>> queue entry / tag.
>>>
>>> Have you considered having separate rings take separate payload sizes
>>> instead of having each ring support multiple different payload sizes?
>>> I think this gives a few non-trivial benefits over per-ring
>>> multi-buffer-size support:
>>>
>>> * less head-of-line blocking - with a single ring, the large io
>>> requests can block smaller metadata requests until the io completes,
>>> since fuse processes cqes sequentially from a single ring. Separate
>>
>> I think blocking is a pure libfuse implementation issue. All
>> example/passthrough* file sytems take the buffers and write it out in
>> blocking mode. However, they could use non-blocking IO like io-uring
>> themselves and act on completion. Processing what fuse-client/kernel
>> provides would then be rather fast. Same applies to network IO, which is
>> implementation wise probably already async, except that we do not have
>> an example yet. I'm currently creating a small benchtool for my main
>> work to test different io-uring options (mostly network related) - I can
>> use that as template later on a libfuse example.
>>
>> I.e. my argument here is that we should not make the kernel more
>> complex, just because libfuse is not ready yet.
> 
> This is exactly my argument :) I think we should try to keep the
> kernel side logic as simple and as efficient as possible.
> 
> With regards to head-of-line blocking, processing IO server-side in an
> async nonblocking way make work in some cases but there are plenty in
> which this is not feasible. Using non-blocking IO like going through
> io-uring requires the backend to expose the raw file descriptor but
> many real fuse servers don't talk to backends that expose this, eg
> custom rpc/networking libraries, database client libraries, in-memory
> filesystems, etc.
> 
> While I agree that the passthrough examples could be improved, I don't
> think we can assume most fuse servers can adopt an asynchronous
> io-uring-like model for issuing backend I/O.
> 
>>
>> As soon as the sync FUSE_INIT series is merged into libfuse (and
>> obviosuly also need to take care of Darrick series) I will start to work
>> on a reactor/coroutine libfuse interface - the daemon is then the ring
>> owner - daemon can set up the ring as it wants, use or for backend IO, etc.
>>
>>> rings would allow smaller requests to proceed independently of io
>>> * makes kernel-side request dispatching more efficient + simpler  - if
>>> for example there's 10 different rings and each of them supports 4
>>> categories of buffer sizes, imo it gets non-trivially complicated to
>>> find an available ring that supports the payload size that needs to be
>>> sent, if there's lots of parallel requests going on. In the worst
>>> case, we would have to check each of the 10 rings' various categories
>>> of buffer sizes to see if there's a slot that's big enough.
>>
>> I don't get that - let's say we have several pBuf rings - it could
>> always check the next (rouned up) size? One could have an option to
>> search for available slots in larger pBufs, but I'm not sure if that
>> would be wanted. Let's say we would have two pBuf rings, 4K and 1M. The
>> 4k pBufs then could be use 1MB memory - place for 128 small requests -
>> why should small requests then switch to the next larger buffer pool, if
>> their own pool is exhausted? In my opinion large pools should be
>> reserved for large requests.
> 
> I think this would be suboptimal. I don't think small requests should
> stall when larger buffers are sitting idly.
> 
> I think this also adds more nontrivial kernel-side complexity, eg the
> kernel now needs to have per-pool wait queue management on top of the
> existing per-queue entry management, whereas with having separate
> queues each with its own payload size, we can just use the existing
> "queue has no available entries" logic and not have to deal with doing
> extra bookkeeping / pool management.

My counter argument is that it is simple to have many small requests and
large requests are precious :)

> 
>>
>>> * simpler kernel-side buffer management - keeping track of the payload
>>> buffers in the ring becomes a lot simpler, since there's just one
>>> buffer size the ring supports
>>
>> Personally I don't think it makes a difference. Instead of having
>> multiple pBuf rings you now have to deal with multiple IO size io-uring
>> rings. Maybe I mis-understand your itend, though.
>>
>>> * more dynamic / deterministic scalability - I think you mentioned on
>>> another thread you were interested in dynamically adding ents to
>>> rings. Having separate rings for separate payload sizes would make
>>> independently scaling queues based on workload characteristics a lot
>>> easier. for example if there were 10 rings that each support 4
>>> different buffer sizes, one question I would have is which ring would
>>> the extra entry be added to? It kind of seems like at request dispatch
>>> time, it would have to do that non-trivial ent searching logic across
>>> all rings mentioned earlier to find that extra ent?
>>
>> And entry would always go into its own fuse-io-uring queue. Without pBuf
> 
> That is the point I was trying to make - with the entry going into its
> own fuse-io-uring queue, it's not efficient for dynamically scaling up
> capacity because the server doesn't know which queue should have the
> added ent. For example if there are 10 queues that each support 4
> different buffer sizes and the server wants to add an extra ent for a
> 16k buffer size, which queue should they add it to? If small requests
> wait on a queue when its full pool is saturated and don't search
> across pools, then this becomes even more suboptimal. Whereas with a
> queue that's dedicated to a 16k buffer size, that entry would be
> available to any matching request, rather than only to requests that
> happen to land on the specific queue the server added it to
> 
> imo the multi-buf-size-per-queue design suboptimally
> distributes/fragments buffers. With separate payload-size queues, all
> 4k buffers are in one pool - any small request can use any of them.
> With multi-buf-per-queue, the 4k buffers are fragmented across queues,
> so a small request can only use the 4k buffers in its specific queue
> even if other queues have idle 4k buffers.
> 
>> I would have added these entries to a size sorted ent_avail_queue[]
>> array, with pBuf the entry doesn't have a payload itself anymore, but
>> only the pBuf rings have.
>>
>> Here I had suggested to convert the arg size to an order and then to do
>> an O(1) lookup for the right buf ring
>>
>> https://lore.kernel.org/r/ff596299-38c1-4c5a-8f1d-14931dd84ef0@bsbernd.com
>>
>>     struct fuse_bufring {
>> ...
>>         /* lookup: order (req size) pool */
>>         struct fuse_bufring_pool *order_map[FUSE_URING_NR_ORDERS];
>> }
>>
>> struct fuse_bufring_pool *pool = order_map[get_order(fuse_len_args())];
>>
>> Without pBuf it would be the same, except that ring entries would have
>> their payload size and would be sorted by payload order size into their
>> ent_avail_queue[].
> 
> I think doing this without bufring makes it even more complicated
> kernel-side with having to keep the array in sorted order
> 
>>
>>>
>>> These are just my 2 cents, but it kind of seems t o me that having
>>> separate rings take separate payload sizes could be more scalable for
>>> your use case?
>>
>> I don't think so - more rings just create more syscall overhead from my
>> point of view. And more rings are harder to handle with coroutines.
> 
> I disagree with this, as there will already be multiple queues per
> server. I don't think this would lead to more queues. (using "queues"
> here instead of "rings" as it gets confusing with there being 1
> overall "ring" per server, but multiple "ringqueues" inside the 1
> ring)
> 
> I think it's clear we disagree on this and an in-person conversation
> might be more useful for getting this hashed out :) Maybe a good topic
> for next week at lsf and Miklos can weigh in with what he prefers?


[ Right now no time answer to all the other parts ].

I definitely agree that we disagree here :)

Yeah, I think it would be good to discuss this in person and also in the
afternoon session on Wednesday.


Thanks,
Bernd


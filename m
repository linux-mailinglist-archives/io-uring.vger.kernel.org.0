Return-Path: <io-uring+bounces-13170-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMvHFOPY8Wm3kgEAu9opvQ
	(envelope-from <io-uring+bounces-13170-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 12:09:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5A04929AE
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 12:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 825E8301BEE7
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 10:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7E33C3433;
	Wed, 29 Apr 2026 10:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="DFc2X5kN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eJLTeSR5"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A24C2EA498
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 10:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777457360; cv=none; b=a/r0Jk1myPMDL+pBdr7J1HCaOv0vQsntm1Yg4W2S8afIYA4MhZKh/8Q1igPW59S8sjKeQ8kZjaeQ6OkclOGgwCAemWMRP2MrFWS+DEiD6xiK3q3AjeC+aWgQXrFEdHX7zE5O8mLhIExwNiBzzQpWX8kvQ6t0mG+Y99OQS8cMeAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777457360; c=relaxed/simple;
	bh=Wr0Icnd+V80tVJWCWV2TvuszEf+GVgfpQ5K6c7Sys7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noNAgx0jW6NRzE/jYgsACUDfWxYl0mxSSP/b5AalMRJihDdc93bIvFrQjfP9ta/vGXAbbbD6f7J1hjrBr8Cva+CnZkgFXYnN7zM/v/Cn/BXZJ8OdZPO35c2KjjXZ8cN85e/gYWQSaTG7TPmpke7D7SZUqxTkjQDcxnEasPfW5EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=DFc2X5kN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eJLTeSR5; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 6529BEC0187;
	Wed, 29 Apr 2026 06:09:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 29 Apr 2026 06:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777457355;
	 x=1777543755; bh=jChTQ1WFfHi+FUb6QlfSmPhLflXWkXU6xxr/jnnNJjk=; b=
	DFc2X5kNuzluWtpgz2TyV9ydLdIS9EJozwxxQdCysxjEQuoE5f5OxVjVw24/4r5U
	DNAnNz8K+sZm/hH+y4vjnsSD+QT4XHTx5+4YY0qnuAPSFurdGEyb44PFFDLQqdZI
	z5kIVEo1EKQMUPkjeuk/lJ2tZlaCpxUw3k3A1KY0Sd9WHpxuIgIf2J2A5hLQiBnC
	cihkhbsn2MAV7AWvFkWbZ8Ez59gniiAFAO7L4jBNQbHSAYdOwaaw73Mqce7Z/KEN
	4xkpNKVp25+SCoV2DcLEIXAWwW0ah/viw/KYuMIDwpK/sbR/AVHny+fksQIqTPzs
	g+j2BJGIDnH/F4Xb/GYOFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777457355; x=
	1777543755; bh=jChTQ1WFfHi+FUb6QlfSmPhLflXWkXU6xxr/jnnNJjk=; b=e
	JLTeSR5VBEnsz4QXNUqMljDrb8G9HMxEM7Aluhc8sYVLcJeUSSgMT4EGmf2dTGs5
	qL2AdsLcZENGresiVaYxdJv9QRtFC3P5xpbMtXMBgG/VNDgZpKzxkQVjZwh4YNSk
	7qkYljfmy4onWKdvjzmolkt0iWYRHIrm9zkJ7x4QMUD7go/4JMKMqckMBfj/WWO/
	BIRi/EQ68WcsTOKT8/u1U4FYkwGCXHcxCzEz+/xpMJHe2TlYMuTJMe/gl3dglR/5
	gRPaAKTN0ySXqMs5ixkHYpGWrM5+bqZLtKbqMG2WNwd2pGx0sW3T46lXikudwj/C
	Rv1P4e536ameBtitlcUCA==
X-ME-Sender: <xms:ytjxaQElCR260lWCYS47xyUh3MBIbcDSQYSjY00p3RBDpQ6Yi-ufow>
    <xme:ytjxaTXF-AMIho-2m48VaLBVSWSdApBN4oVXl47HQsyh59EQn3tC-VFReOC56BaPZ
    MtTrTT5J589v6-LGTcAiG-yZth_NnMaK_Z1Dq2WhjQ4ciPGk3nj>
X-ME-Received: <xmr:ytjxaQwkNB2B_htoLPLJlLzIza5RTnoJH5PvGMThWNW4Op1sNMb1-_6jWpRM-8zHOSofMzE-jNG6qOyVBVWuoyO-WM8DJQuQXpvfkYTmZCZakM4Zig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeduiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:ytjxaQQfXsuTm3bI7ERGbR-UVoypP_9Kor59YDmWyhasP12BRYSYnQ>
    <xmx:ytjxaUgdZLmoB8JS1RytEtJYxB_EkHIQuotbXTsa6gfbSkbufEsMmA>
    <xmx:ytjxafkHA4Mrk7KckYjyN1-Wt9bqaGH3es2szVaA1qbRtf4VnrU0tA>
    <xmx:ytjxafvvHVA_pmKCHvsF4jMg2RUmeM8z1vp7okRXM-SvETuo5IMSug>
    <xmx:y9jxaZK4Ux1eqknzbt9EAXD2W8l0Ya0YzU0PNAHPqjbFOclnBxzFQMIW>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Apr 2026 06:09:13 -0400 (EDT)
Message-ID: <b2037b8f-466c-47d4-b74b-fe5b8f38fbc4@bsbernd.com>
Date: Wed, 29 Apr 2026 12:09:12 +0200
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
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr
In-Reply-To: <CAJnrk1Yw3=z7W_my4pLG6avBeDZkUp3j1LZk-RVpGv2vAsw-ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F5A04929AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,lists.linux.dev,vger.kernel.org,kernel.dk,gmail.com,szeredi.hu];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13170-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bsbernd.com:dkim,bsbernd.com:mid]

Hi Joanne,

sorry my terribly late reply, takes about 30 min to reply for these
complex discussions and finding that time is currently a bit hard.

On 4/17/26 23:02, Joanne Koong wrote:
> On Thu, Apr 16, 2026 at 7:46 AM Bernd Schubert <bernd@niova.io> wrote:
>>
>> Hi Ming,
>>
>> On 4/16/26 15:49, Ming Lei wrote:
>>> Hi Bernd,
>>>
>>> On Tue, Apr 14, 2026 at 5:33 AM Bernd Schubert <bernd@niova.io> wrote:
>>>>
>>>> And my current primary goal is to let ublk to support multiple buffer
>>>> sizes - ublk would also need to get support for kBuf/pBuf and I'm
>>>
>>> Ublk server is just one liburing application, and it supports all generic
>>> io_uring buffer types, so kbuf/pbuf should be fine for your ublk server
>>> in theory.
>>>
>>> It really depends on how your ublk server is implemented.
>>>
>>> Maybe you can share your motivation first before discussing kbuf/pbuf support.
>>> If it is for DMA,  there are other candidates too, such as hugepage,
>>> recent added
>>> UBLK_U_CMD_REG_BUF, ...
>> Joanne had actually removed kBuf and switched to pBuf alone and that
>> simiplifies things a bit.
> 
> Hi Bernd,
> 
>>
>> Motivation is to reduce memory usage. Let's say you need 4 IOs of 1MB to
>> saturate streaming bandwidth, but still want to get smaller IOs through,
>> for these smaller IOs you don't want to assign the 1MB buffer for each
>> queue entry / tag.
> 
> Have you considered having separate rings take separate payload sizes
> instead of having each ring support multiple different payload sizes?
> I think this gives a few non-trivial benefits over per-ring
> multi-buffer-size support:
> 
> * less head-of-line blocking - with a single ring, the large io
> requests can block smaller metadata requests until the io completes,
> since fuse processes cqes sequentially from a single ring. Separate

I think blocking is a pure libfuse implementation issue. All
example/passthrough* file sytems take the buffers and write it out in
blocking mode. However, they could use non-blocking IO like io-uring
themselves and act on completion. Processing what fuse-client/kernel
provides would then be rather fast. Same applies to network IO, which is
implementation wise probably already async, except that we do not have
an example yet. I'm currently creating a small benchtool for my main
work to test different io-uring options (mostly network related) - I can
use that as template later on a libfuse example.

I.e. my argument here is that we should not make the kernel more
complex, just because libfuse is not ready yet.

As soon as the sync FUSE_INIT series is merged into libfuse (and
obviosuly also need to take care of Darrick series) I will start to work
on a reactor/coroutine libfuse interface - the daemon is then the ring
owner - daemon can set up the ring as it wants, use or for backend IO, etc.

> rings would allow smaller requests to proceed independently of io
> * makes kernel-side request dispatching more efficient + simpler  - if
> for example there's 10 different rings and each of them supports 4
> categories of buffer sizes, imo it gets non-trivially complicated to
> find an available ring that supports the payload size that needs to be
> sent, if there's lots of parallel requests going on. In the worst
> case, we would have to check each of the 10 rings' various categories
> of buffer sizes to see if there's a slot that's big enough.

I don't get that - let's say we have several pBuf rings - it could
always check the next (rouned up) size? One could have an option to
search for available slots in larger pBufs, but I'm not sure if that
would be wanted. Let's say we would have two pBuf rings, 4K and 1M. The
4k pBufs then could be use 1MB memory - place for 128 small requests -
why should small requests then switch to the next larger buffer pool, if
their own pool is exhausted? In my opinion large pools should be
reserved for large requests.

> * simpler kernel-side buffer management - keeping track of the payload
> buffers in the ring becomes a lot simpler, since there's just one
> buffer size the ring supports

Personally I don't think it makes a difference. Instead of having
multiple pBuf rings you now have to deal with multiple IO size io-uring
rings. Maybe I mis-understand your itend, though.

> * more dynamic / deterministic scalability - I think you mentioned on
> another thread you were interested in dynamically adding ents to
> rings. Having separate rings for separate payload sizes would make
> independently scaling queues based on workload characteristics a lot
> easier. for example if there were 10 rings that each support 4
> different buffer sizes, one question I would have is which ring would
> the extra entry be added to? It kind of seems like at request dispatch
> time, it would have to do that non-trivial ent searching logic across
> all rings mentioned earlier to find that extra ent?

And entry would always go into its own fuse-io-uring queue. Without pBuf
I would have added these entries to a size sorted ent_avail_queue[]
array, with pBuf the entry doesn't have a payload itself anymore, but
only the pBuf rings have.

Here I had suggested to convert the arg size to an order and then to do
an O(1) lookup for the right buf ring

https://lore.kernel.org/r/ff596299-38c1-4c5a-8f1d-14931dd84ef0@bsbernd.com

    struct fuse_bufring {
...
        /* lookup: order (req size) pool */
        struct fuse_bufring_pool *order_map[FUSE_URING_NR_ORDERS];
}

struct fuse_bufring_pool *pool = order_map[get_order(fuse_len_args())];

Without pBuf it would be the same, except that ring entries would have
their payload size and would be sorted by payload order size into their
ent_avail_queue[].

> 
> These are just my 2 cents, but it kind of seems t o me that having
> separate rings take separate payload sizes could be more scalable for
> your use case?

I don't think so - more rings just create more syscall overhead from my
point of view. And more rings are harder to handle with coroutines.

Thanks,
Bernd


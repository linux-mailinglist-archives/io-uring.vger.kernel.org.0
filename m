Return-Path: <io-uring+bounces-11964-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGmYB1J8emka7AEAu9opvQ
	(envelope-from <io-uring+bounces-11964-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 22:14:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C34A9036
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 22:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DDC0430074AA
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 21:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DABD3783A8;
	Wed, 28 Jan 2026 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="Cw4FKDwh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="w0mFwtk6"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDF7376BFD;
	Wed, 28 Jan 2026 21:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769634893; cv=none; b=FSY44HivDXkVT0vymBXcx31lrJ4tJnYDOzY2Ho0WDk/Z4osKGrTSSEcdO7EmUgIiUAPVH2/Ozh/X2S+oisTWjrkZDe++ePE9XXpzGl2NUbH8mHqYktetq9FiIv68ZBpR2Zh98YloBVGCqDubgvICZDU9ZfCQbsoTkjZh6SYmmV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769634893; c=relaxed/simple;
	bh=y3nWOVaLspatkNC/G3jqcAfpY++QHJJhun0LP+5pJ+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWNDycM6CxQhyagPlS66WxOizOIwfyFCgkTGvAYVGL9FokX3r4u0Djl0q9V08Nvef8CCWbk2JK5MrE5x+yRmPuCpDFXeigU/iWNfSTgpTWZiU9B0I99PH28a6/ZaGsn5MbZOrQCj97lzslWvD87BGrLWVJoNdGmWoL+6FiLBrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=Cw4FKDwh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=w0mFwtk6; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F30377A007B;
	Wed, 28 Jan 2026 16:14:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 28 Jan 2026 16:14:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1769634887;
	 x=1769721287; bh=ibzcGPKq4hBXogV1V0bNOXxHlIUu7PQmkV8WqBqGn2Y=; b=
	Cw4FKDwhPk29dpSTeocxLCx1sxrfqOsZIGtwZv8HzeXLQU4EdUG5Bf5PqjlMUe1w
	LElE573A+KaHAvmuhn3AQfjXz52LvEAPtPysuokh9QRjuQIUtTWDcp6t9vbD3SJT
	LO89+ybjMx8HzDyLGajRAJqvWoJWGVAYgQhXlliqxxFIoUyEKPlFvtclC62ZKJI0
	PS08GYoDJDB2rwpFWFB2j0G54H90RzYN7C8MjLdZI3wAHAXtTojAKvCDC9vVzSyv
	oaebhgKCfEkjCKMHJn+bqQAhJTSYAhLrwP4LfBbay9cQHHT9S4HXVPgBcbRVg8zt
	R3DQE9lczzZYGzCxvsgr6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1769634887; x=
	1769721287; bh=ibzcGPKq4hBXogV1V0bNOXxHlIUu7PQmkV8WqBqGn2Y=; b=w
	0mFwtk6//qXorJFyWnqNrsDJQ4WexfoddyeRzR7tqr9bLm6hxT4GbmhTnjiY/bE2
	VAlP2roJU1GKt4aHiXwLIZp+xRHp71gF35ePCSM5+XsmJ9QfLgxtugXx//v6BmuY
	tDRpLlcHHctQxT72XQj549lzNcZDd9uhCXosW1V0pBpHNQiXdRtBK5uuKVCJ3F66
	xD3eHEw3rpB8Z9gAATpeGvGXLjPSP64PMMUlamUmmxcpMbrECihoAqEosLoYpev5
	KU3N/dXxKCIoi8/L/XuAjGpWg2sUb++b6B7Ff41j5RLZNAPpW91oDnv+37wo8GcQ
	f4uFKO+LwIKyGp8NRyoCA==
X-ME-Sender: <xms:R3x6aZH7Bem2Ry1aKB8nU3wYZY_SCYsabYxVjxCafBAkqRpJJ4Ub5Q>
    <xme:R3x6aW-mijbUB0RQroUdSr1QsUwetyvsvKCv71lCkfb7dHFzDICIHNZGXhsYEQDgN
    gRxa7grUATqMkLnPDroA5SITiBqQFtm4zP0UPJHfV7iyZko3KM->
X-ME-Received: <xmr:R3x6aSlqyXFdgPzexY8W5jy-LYAd-zhSvAAwjkK_-szKWHHgJ9sHGThHiNx6ZibusPkcLTFhtfJGQM_Baw5SOaVlAT-zYKnIDUi5hpBW9W9DsLQDBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieegfeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeduuddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthho
    pegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepmhhikhhlohhssehsiigvrh
    gvughirdhhuhdprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgt
    ohhmpdhrtghpthhtohepkhhrihhsmhgrnhesshhushgvrdguvgdprhgtphhtthhopehioh
    dquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrshhmlhdr
    shhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopeigihgrohgsihhnghdrlh
    hisehsrghmshhunhhgrdgtohhm
X-ME-Proxy: <xmx:R3x6aZAkuqO02DithKOKJe1UB1-eqWftyttoGcwE_rogiS13GWYKyg>
    <xmx:R3x6aTVcDEUcOpbeq3FVUGKQ5MGKxS9a7GB3xYcu2Fiv7aOc6a80XQ>
    <xmx:R3x6af8ZSECzzIA_KaFGODjE_Q694HYxJXMeiik6Ps0SW79Jg4I7rQ>
    <xmx:R3x6adRo0HFnpDDlJvZ211yNxEYw_QT1-KGXjv-fvBU679e_2Oc1Hw>
    <xmx:R3x6aax4EfFpbfYfjucBJGTd70IQ2nlbbCM6egBwlbEefqAh0TX3Z9hX>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 16:14:45 -0500 (EST)
Message-ID: <be475a3b-fe3f-43b2-ace6-3a7158d4d96c@bsbernd.com>
Date: Wed, 28 Jan 2026 22:14:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/25] fuse: support buffer copying for kernel
 addresses
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com,
 krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com,
 xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-19-joannelkoong@gmail.com>
 <68b3ff9d-ebcf-45c9-a50a-b5a59d332f4c@ddn.com>
 <CAJnrk1bn6A2i4Kr-W=VTUVqeewhR-eVNZXoQtDi8v4=Qyme6DQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1bn6A2i4Kr-W=VTUVqeewhR-eVNZXoQtDi8v4=Qyme6DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm1,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,ddn.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11964-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ddn.com:email,bsbernd.com:email,bsbernd.com:dkim,bsbernd.com:mid,messagingengine.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B6C34A9036
X-Rspamd-Action: no action



On 1/28/26 01:23, Joanne Koong wrote:
> On Tue, Jan 27, 2026 at 3:40 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> On 1/17/26 00:30, Joanne Koong wrote:
>>> This is a preparatory patch needed to support kernel-managed ring
>>> buffers in fuse-over-io-uring. For kernel-managed ring buffers, we get
>>> the vmapped address of the buffer which we can directly use.
>>>
>>> Currently, buffer copying in fuse only supports extracting underlying
>>> pages from an iov iter and kmapping them. This commit allows buffer
>>> copying to work directly on a kaddr.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  fs/fuse/dev.c        | 23 +++++++++++++++++------
>>>  fs/fuse/fuse_dev_i.h |  7 ++++++-
>>>  2 files changed, 23 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>>> index 6d59cbc877c6..ceb5d6a553c0 100644
>>> --- a/fs/fuse/dev.c
>>> +++ b/fs/fuse/dev.c
>>> @@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, bool write,
>>>  /* Unmap and put previous page of userspace buffer */
>>>  void fuse_copy_finish(struct fuse_copy_state *cs)
>>>  {
>>> +     if (cs->is_kaddr)
>>> +             return;
>>> +
>>>       if (cs->currbuf) {
>>>               struct pipe_buffer *buf = cs->currbuf;
>>>
>>> @@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
>>>       struct page *page;
>>>       int err;
>>>
>>> +     if (cs->is_kaddr)
>>> +             return 0;
>>> +
>>>       err = unlock_request(cs->req);
>>>       if (err)
>>>               return err;
>>> @@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
>>>  {
>>>       unsigned ncpy = min(*size, cs->len);
>>>       if (val) {
>>> -             void *pgaddr = kmap_local_page(cs->pg);
>>> -             void *buf = pgaddr + cs->offset;
>>> +             void *pgaddr, *buf;
>>> +             if (!cs->is_kaddr) {
>>> +                     pgaddr = kmap_local_page(cs->pg);
>>> +                     buf = pgaddr + cs->offset;
>>> +             } else {
>>> +                     buf = cs->kaddr + cs->offset;
>>> +             }
>>>
>>>               if (cs->write)
>>>                       memcpy(buf, *val, ncpy);
>>>               else
>>>                       memcpy(*val, buf, ncpy);
>>> -
>>> -             kunmap_local(pgaddr);
>>> +             if (!cs->is_kaddr)
>>> +                     kunmap_local(pgaddr);
>>>               *val += ncpy;
>>>       }
>>>       *size -= ncpy;
>>> @@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>>>       }
>>>
>>>       while (count) {
>>> -             if (cs->write && cs->pipebufs && folio) {
>>> +             if (cs->write && cs->pipebufs && folio && !cs->is_kaddr) {
>>>                       /*
>>>                        * Can't control lifetime of pipe buffers, so always
>>>                        * copy user pages.
>>> @@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>>>                       } else {
>>>                               return fuse_ref_folio(cs, folio, offset, count);
>>>                       }
>>> -             } else if (!cs->len) {
>>> +             } else if (!cs->len && !cs->is_kaddr) {
>>>                       if (cs->move_folios && folio &&
>>>                           offset == 0 && count == size) {
>>>                               err = fuse_try_move_folio(cs, foliop);
>>> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
>>> index 134bf44aff0d..aa1d25421054 100644
>>> --- a/fs/fuse/fuse_dev_i.h
>>> +++ b/fs/fuse/fuse_dev_i.h
>>> @@ -28,12 +28,17 @@ struct fuse_copy_state {
>>>       struct pipe_buffer *currbuf;
>>>       struct pipe_inode_info *pipe;
>>>       unsigned long nr_segs;
>>> -     struct page *pg;
>>> +     union {
>>> +             struct page *pg;
>>> +             void *kaddr;
>>> +     };
>>>       unsigned int len;
>>>       unsigned int offset;
>>>       bool write:1;
>>>       bool move_folios:1;
>>>       bool is_uring:1;
>>> +     /* if set, use kaddr; otherwise use pg */
>>> +     bool is_kaddr:1;
>>>       struct {
>>>               unsigned int copied_sz; /* copied size into the user buffer */
>>>       } ring;
>>
>>
>> I'm confused here, how cs->len will get initialized. So far that was
>> done from fuse_copy_fill?
> 
> With kaddrs, cs->len is initialized when the copy state is set up (in
> setup_fuse_copy_state()) before we do any copying to/from the ring.
> The changes for that are in the later patch that adds the ringbuffer
> logic ("fuse: add io-uring kernel-managed buffer ring"). The kaddr and
> len correspond to the address and length of the buffer that was
> selected from the ring buffer (in fuse_uring_select_buffer()).



Maybe we could add a sanity check into fuse_copy_do() or even into
fuse_copy_fill in the cs->is_kaddr condition that cs->len is > 0?

Otherwise looks good.

Reviewed-by: Bernd Schubert <bernd@bsbernd.com>


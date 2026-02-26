Return-Path: <io-uring+bounces-12442-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WBQWAOKRoGllkwQAu9opvQ
	(envelope-from <io-uring+bounces-12442-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 19:33:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D12E1ADB4E
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 19:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 02DA130BBC68
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD973290D4;
	Thu, 26 Feb 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="roZ+vNt6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sRVsOAT9"
X-Original-To: io-uring@vger.kernel.org
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA63859FB;
	Thu, 26 Feb 2026 18:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130077; cv=none; b=sVRra5aOttwZxkyyL1iY/aiElMzPWmZDTwNxpFC/8mtW5TI4l8BamUEBZsBZxvjBdpAYU2krHZq0a29qwkmTDSsLKqgJmH8X4ImnHsihFwa4isVYf9OR3MLLaJkWbE6NQMSUbTiLP+qoUty5uF9wapyZlEh4VosC/RmnWQRnACQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130077; c=relaxed/simple;
	bh=0760ZwAb8gP27bNWhrqS7T+pszXz5ydGwfCzeHtsqX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E3RGg15i9bnmU6xNb8irjCUNconRGAjZ71q7QhlX2sBQj6lWKxdkFN0QqZn6iJWt+y+WV05l8SV5h/ZoIyIdDE5Jq7jmx/H/LqI5BxLPpebT9PUZ/Am6GAY4aOpft24esoms07vvlMUQ1QxGMCNqdrK/9g0KdlYlFl9B54yLV1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=roZ+vNt6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sRVsOAT9; arc=none smtp.client-ip=103.168.172.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id ABB381380157;
	Thu, 26 Feb 2026 13:21:14 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 26 Feb 2026 13:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1772130074;
	 x=1772137274; bh=zkqCOdOrNzRqBUjjik6XUnLzVjkT1f4fb6bQWYuvWeM=; b=
	roZ+vNt6O0pKpy3C0TJ5JVOTwJg9bw9OA7E0NPkbFoe1x9cpqRw5U0g1lAY7Xc7u
	ppD4jAIvztq+MxSRgqJeHbNxSROVHr+WNR8IV+cGvgkjyErVLUgB9oqNE1ON9Abo
	3PMBcSM5zCfvIlkk03yLt0LBLBgAsv1qEiM2Dj2qTo9w9zn0oujgGc3Ip8Oi9fbU
	YhdW6GrwEEWC/SURlBQebhjydLgOdW0IWy1rya7VLsCA0hbwkDG7P6FZ1j+/4L+k
	uw6xD6B/n0BEJse9vEjpadXpPvTpheZRI7pOJXTHlyGP31ycOqXwrS1WtMRBQBNP
	vrkMg7AKIlleK9B66xD2cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772130074; x=
	1772137274; bh=zkqCOdOrNzRqBUjjik6XUnLzVjkT1f4fb6bQWYuvWeM=; b=s
	RVsOAT9S1glR6g5J9MnE8SKJqEUGIG3cwcc3jeZSxB2OfkjJzCDDYhCW9P6R9D0m
	/8w0QMBYhfb0yXWZwRHWFyLJ7sj5nZrBxf4ZnBmfDgxGtHJsEStP1MlewlfQivqv
	HSCuSVWmDiHTNAii4Tz5dnG4rwODwhIZ7XGaozobeEzxntaqpW0SEDa4XXtzBAjY
	TyfV3OWO5IP9B5C6mSP+lIrjIPFUgBW7bZQWBEU7yJewfP9OphneZtlSngIHR0mb
	1r5csWJoI6qqrjq6nsr6ZJdHLgRQVhY3u35PbGuJXqm3a7XSDxhUmbEMk2LNr1tr
	0ugkdp8qOTdyzBtrOwInQ==
X-ME-Sender: <xms:Go-gaZpj0HzDPP2PrtPtfGcVBPcROnQK9ZcZFPORFr9XKBDBbKg4hA>
    <xme:Go-gaevFo-zzBnUIice71VVgv7UPhb7GB6fiLOApgvx7G9faLDT5uHImcghWUnNnB
    6N1QkL01U45iBT4mfWN4kfDBL68Gb_3HTjIA6HjxScHJA7D8iNm>
X-ME-Received: <xmr:Go-gaQ0_ToDed-g1EyRQ2zMMcJpY21oLkiom_Z7LkIRYa8rM_VrVs7sEovp67lw9-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeeijeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehm
    ihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheptghsrghnuggvrhesphhurh
    gvshhtohhrrghgvgdrtghomhdprhgtphhtthhopehkrhhishhmrghnsehsuhhsvgdruggv
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    gihirghosghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtphhtthhopehsrghfih
    hnrghskhgrrhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:Go-gaRH-9CzWb_3I47yR4X86kLR1WbdI76w-oavozHA24jjMuq780A>
    <xmx:Go-gaTvc_8nyLZ0aAGdXTliaDpdaGV2C1NsLB_CVWYAgNnFm4eyzfQ>
    <xmx:Go-gacrXo9QLcuGVA-vtSbAeTTs7s49n3Swa8qi3noos2Af2IYk_Nw>
    <xmx:Go-gaSUfVWGL3oO3doHXKvlE6ZLAbQVfAQWiQ578quuR0GWW4bPJcQ>
    <xmx:Go-gaSJHV0uwWHvOwJXtgr956xvuSvPgXLjV8rkuqcBlChPp6v0F6nTc>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 13:21:10 -0500 (EST)
Message-ID: <cb5bfa20-447d-4392-b7a5-8f7d49d70157@bsbernd.com>
Date: Thu, 26 Feb 2026 19:21:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com,
 krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com,
 xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com>
 <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
 <7ccf7574-42d4-4094-9b84-eb223e73188e@bsbernd.com>
 <CAJnrk1b6z2oar_Zw89N275zfyU2+oZJwtozSdTPFw49x38FCOA@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1b6z2oar_Zw89N275zfyU2+oZJwtozSdTPFw49x38FCOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bsbernd.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[bsbernd.com:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12442-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bsbernd.com:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bernd@bsbernd.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,messagingengine.com:dkim,bsbernd.com:mid,bsbernd.com:dkim,bsbernd.com:email]
X-Rspamd-Queue-Id: 3D12E1ADB4E
X-Rspamd-Action: no action



On 2/26/26 00:42, Joanne Koong wrote:
> On Wed, Feb 25, 2026 at 9:55 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>> On 1/28/26 22:44, Bernd Schubert wrote:
>>> On 1/17/26 00:30, Joanne Koong wrote:
>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>> @@ -940,6 +1188,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>>>      unsigned int qid = READ_ONCE(cmd_req->qid);
>>>>      struct fuse_pqueue *fpq;
>>>>      struct fuse_req *req;
>>>> +    bool send;
>>>>
>>>>      err = -ENOTCONN;
>>>>      if (!ring)
>>>> @@ -990,7 +1239,12 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>>>
>>>>      /* without the queue lock, as other locks are taken */
>>>>      fuse_uring_prepare_cancel(cmd, issue_flags, ent);
>>>> -    fuse_uring_commit(ent, req, issue_flags);
>>>> +
>>>> +    err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
>>>> +    if (err)
>>>> +            fuse_uring_req_end(ent, req, err);
>>>> +    else
>>>> +            fuse_uring_commit(ent, req, issue_flags);
>>>>
>>>>      /*
>>>>       * Fetching the next request is absolutely required as queued
>>>> @@ -998,7 +1252,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>>>       * and fetching is done in one step vs legacy fuse, which has separated
>>>>       * read (fetch request) and write (commit result).
>>>>       */
>>>> -    if (fuse_uring_get_next_fuse_req(ent, queue))
>>>> +    send = fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
>>>> +    fuse_uring_headers_cleanup(ent, issue_flags);
>>>> +    if (send)
>>>>              fuse_uring_send(ent, cmd, 0, issue_flags);
>>>>      return 0;
>>
>>
>> Hello Joanne,
>>
>> couldn't it call fuse_uring_headers_cleanup() before the
>> fuse_uring_get_next_fuse_req()? I find it a bit confusing that it firsts
>> gets the next request and then cleans up the buffer from the previous
>> request.
> 
> Hi Bernd,
> 
> Thanks for taking a look.
> 
> The fuse_uring_headers_cleanup() call has to happen after the
> fuse_uring_get_next_fuse_req() call because
> fuse_uring_get_next_fuse_req() copies payload to the header, so we
> can't yet relinquish the refcount on the headers buffer / clean it up
> yet. I can add a comment about this to make this more clear.

I only found time right now and already super late (or early) here.

I guess that is fuse_uring_copy_to_ring -> copy_header_to_ring, but why
can it then call fuse_uring_headers_cleanup() ->
io_uring_fixed_index_put(). I.e. doesn't it put buffer it just copied
to? Why not the sequence of

err = fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
fuse_uring_commit(ent, req, issue_flags);
fuse_uring_headers_cleanup(ent, issue_flags);

And then fuse_uring_get_next_fuse_req() does another
fuse_uring_headers_prep() with ITER_DEST?


> 
>>
>> As I understand it, the the patch basically adds the feature of 0-byte
>> payloads. Maybe worth mentioning in the commit message?
> 
> Hmm I'm not really sure I am seeing where the 0-byte payload gets
> added. On the server side, they don't receive payloads that are
> 0-bytes. If there is no next fuse request to send, then nothing gets
> sent. But maybe I'm not interpreting your comment about 0-byte
> payloads correctly?

There is fuse_uring_req_has_payload() and
fuse_uring_select_buffer()/fuse_uring_next_req_update_buffer() using
that function. When a request doesn't have a payload the ring entries
runs without a payload - effectively that introduces 0-byte payloads,
doesn't it?

> 
>> I also wonder if it would be worth to document as code comment that
>> fuse_uring_ent_assign_req / fuse_uring_next_req_update_buffer are
>> allowed to fail for a buffer upgrade (i.e. 0 to max-payload). At least
> 
> Good idea, I'll add a comment about this.
> 
>> the current comment of  "Fetching the next request is absolutely
>> required" is actually not entirely true anymore.
>>
> 
> I don't think this patch introduces new behavior on this front.
> fuse_uring_get_next_fuse_req() is still called to fetch the next
> request AFAICS.
> 

It still does, but if the request didn't have a payload it might not
have a buffer and if it didn't have a buffer and doesn't manage to get a
buffer, it doesn't handle a request - that a bit change of
'commit-and-fetch always fetches a new request if there is any request
queued'.


Thanks,
Bernd


Return-Path: <io-uring+bounces-939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C13287B550
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 00:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0B95283C69
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 23:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0485D72B;
	Wed, 13 Mar 2024 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cWZybiFZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jH+YdP/6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cWZybiFZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jH+YdP/6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1105B20F
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710373402; cv=none; b=hKsTAhVm8vJiXRsero96H80Lv6dx1SuiWfr4FyBaGKMj89b9Q9OSZ6HG9M9SM15IOGCtLXtP9XeNSjryIPSRQMT9Zn9Ro06WtQgk/RgFe1HcLxmXzLTNAsdMXpnMQvBRT+wm97xQxVNKWSGNzdwYGwuaad0oFMEkbXWW6OSXYfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710373402; c=relaxed/simple;
	bh=z62cA5DbtJRbr2Pywo2LCrXHrCaKs0QuGVoexLBDt30=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=md8DqU6O6urzagVdHYOFLGOJ+kkK+fRvvsOWKZiO8LT50Wnp7ebw6WayOwN14/6jbXs3sA/XrjXXouMS7EadofYPxlSFS0wUx3/q7wqpTOGzyZAjpUHgt+gGelOZ/bxspEDplBM3LHT93BFf4AoxEyxu1y4e+196CPVeLYpwxWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cWZybiFZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jH+YdP/6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cWZybiFZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jH+YdP/6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 078EC1F7F5;
	Wed, 13 Mar 2024 23:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710373399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tafNtRNG21c3kpe7wBxGZFVwqts6ODFCRlnCkWhyyWs=;
	b=cWZybiFZKdM+WV+5j3Oix1MQg0+TULQJrg0AoaLMHaQKLSifqXwINaWTYoqRz9sCkk9clG
	gu68cCM58fGf47FmaREMhrn7dpkplJsF0su+vThOQCNrl5O10UX6OHOXC05PQcs/BC5N5J
	YRH3qitS0Pb5npCPppt4xs/bnds0yGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710373399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tafNtRNG21c3kpe7wBxGZFVwqts6ODFCRlnCkWhyyWs=;
	b=jH+YdP/67MgExLe32Xu2gJT3JTbPDSlF7cBUZBHuQPIX1CqnrpdeBhatGzAVze05nDFNY6
	1f5LvKs9EIW5ayBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710373399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tafNtRNG21c3kpe7wBxGZFVwqts6ODFCRlnCkWhyyWs=;
	b=cWZybiFZKdM+WV+5j3Oix1MQg0+TULQJrg0AoaLMHaQKLSifqXwINaWTYoqRz9sCkk9clG
	gu68cCM58fGf47FmaREMhrn7dpkplJsF0su+vThOQCNrl5O10UX6OHOXC05PQcs/BC5N5J
	YRH3qitS0Pb5npCPppt4xs/bnds0yGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710373399;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tafNtRNG21c3kpe7wBxGZFVwqts6ODFCRlnCkWhyyWs=;
	b=jH+YdP/67MgExLe32Xu2gJT3JTbPDSlF7cBUZBHuQPIX1CqnrpdeBhatGzAVze05nDFNY6
	1f5LvKs9EIW5ayBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C16741397F;
	Wed, 13 Mar 2024 23:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GHwBKRY68mX9DAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 13 Mar 2024 23:43:18 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,  io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
In-Reply-To: <4146d3a9-3f88-4ef5-8925-8782ae5aa90e@kernel.dk> (Jens Axboe's
	message of "Wed, 13 Mar 2024 17:24:40 -0600")
Organization: SUSE
References: <cover.1710343154.git.asml.silence@gmail.com>
	<ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
	<87plvxkbjp.fsf@mailhost.krisman.be>
	<4146d3a9-3f88-4ef5-8925-8782ae5aa90e@kernel.dk>
Date: Wed, 13 Mar 2024 19:43:17 -0400
Message-ID: <87a5n1k8a2.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-0.19 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 URIBL_BLOCKED(0.00)[kernel.dk:email];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_DN_SOME(0.00)[];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.09)[64.60%]
X-Spam-Score: -0.19
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> On 3/13/24 4:32 PM, Gabriel Krisman Bertazi wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>> 
>>> io_mem_alloc() returns a pointer on success and a pointer-encoded error
>>> otherwise. However, it can only fail with -ENOMEM, just return NULL on
>>> failure. PTR_ERR is usually pretty error prone.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  io_uring/io_uring.c | 14 +++++---------
>>>  io_uring/kbuf.c     |  4 ++--
>>>  2 files changed, 7 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index e7d7a456b489..1d0eac0cc8aa 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -2802,12 +2802,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>>>  void *io_mem_alloc(size_t size)
>>>  {
>>>  	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>>> -	void *ret;
>>>  
>>> -	ret = (void *) __get_free_pages(gfp, get_order(size));
>>> -	if (ret)
>>> -		return ret;
>>> -	return ERR_PTR(-ENOMEM);
>>> +	return (void *) __get_free_pages(gfp, get_order(size));
>>>  }
>>>  
>>>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
>>> @@ -3762,8 +3758,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>>  	else
>>>  		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
>>>  
>>> -	if (IS_ERR(rings))
>>> -		return PTR_ERR(rings);
>>> +	if (!rings)
>>> +		return -ENOMEM;
>>>
>> 
>> Sorry, I started reviewing this, got excited about the error path quick
>> fix, and didn't finish the review before it got it.
>> 
>> I think this change is broken for the ctx->flags & IORING_SETUP_NO_MMAP
>> case, because io_rings_map returns ERR_PTR, and not NULL.  In addition,
>> io_rings_map might fail for multiple reasons, and we want to propagate
>> the different error codes up here.
>
> Yeah, see my reply from some hours ago. I dropped it back then.

ah, thanks.  I've configured lei to fetch the io_uring list every few
hours. This ended up fetching part of the thread at first, and I only saw
it dropped in the next fetch, after I sent the email. sorry for the noise.

-- 
Gabriel Krisman Bertazi


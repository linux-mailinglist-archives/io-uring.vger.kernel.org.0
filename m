Return-Path: <io-uring+bounces-1190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77ECA885F95
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 18:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4FC6282C54
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 17:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDB485280;
	Thu, 21 Mar 2024 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Bm7Irzo/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i565fqV4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H7ktCD5m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n6OzWtK0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCEC132C36
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711041623; cv=none; b=JxPFqOihrPnTd/8jxoXusjWgpmy5gVG6m4/uscOdip0A32xqgrDjJsQ4wD+hwUqNr2yhTnFH7eee5ky3at8jvBYsl3cbYFdIwJJJ6WISn+rvunudHsJahNnMmTMawHoK+eg00SIrfaJfk1ECTlAeJ9hUo223ZoBZk/PeBIityXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711041623; c=relaxed/simple;
	bh=19+qpEmo3dJ8BV3L3WJLyzxTHwyGK2X/JgljQrDLs9U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BcUMN09/+B2RjwhYSoXyBIW4jQwbeiX5yubSU80es7cgkKbJxD6r3Wr9laTBtr5PqFonUew3043RK0cPzzfFjdA3IuTJGEOHd2Y90xpLTqxAnK528+bNY59aT+ArPWc0RPqmB7TcOuO3ORpGotKe6I1NBKWe1BDCZ/CmLOaUUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Bm7Irzo/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i565fqV4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H7ktCD5m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n6OzWtK0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F0E6F5D1D8;
	Thu, 21 Mar 2024 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711041618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmGcWe2WJ5eewwXCHg3MilRjsyan60N8tAXtGyHw/3M=;
	b=Bm7Irzo/5yHB02zFhPiiBVTua9o+xsowv0ifh/yDAfeXGXV4+BL/ITKvE47fGYyRzBvM2f
	kmRWMngp8mFoOm2IZS7McOvdItxo/9GbszxZ/UF9uHmmEqtxskyaMEVBMXjG22j3Q5gANp
	A1EIUFXu9wpUYqACH6d5L+AHUsS+q/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711041618;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmGcWe2WJ5eewwXCHg3MilRjsyan60N8tAXtGyHw/3M=;
	b=i565fqV4xv1dZjivhXcPzZRK565oMqZSvDOGR8+yEckTq0ZVjHsnwKzAriUct5vrefs4zv
	8mdh6VIHs3gtn8BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711041617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmGcWe2WJ5eewwXCHg3MilRjsyan60N8tAXtGyHw/3M=;
	b=H7ktCD5m2EW5u/m6MT6w3FejHkfLwkr3RgMVraew/+8AfoyhLgzHOQmte41B+LsPIlGqwY
	7R4f1TC9BWLAEixghpyLNnCutD27z7Oly4PjizAe/2qQuzGpbpUmpNalyEypSCu9EcVKdF
	frxK5x1Me15JddkaMultH8jo2ATwfkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711041617;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmGcWe2WJ5eewwXCHg3MilRjsyan60N8tAXtGyHw/3M=;
	b=n6OzWtK0aE2JltL03Rm3qUNpVxQQyHvnDoQ8bomScUsNmH+rQ3yGzgJa507XvP0lzfWsBr
	e+zhMb+iO1yA9aBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8291136AD;
	Thu, 21 Mar 2024 17:20:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2AfRJlFs/GUQKwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 21 Mar 2024 17:20:17 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 17/17] io_uring/alloc_cache: switch to array based caching
In-Reply-To: <20f95e13-85af-4316-b167-160571f09369@kernel.dk> (Jens Axboe's
	message of "Thu, 21 Mar 2024 10:38:37 -0600")
Organization: SUSE
References: <20240320225750.1769647-1-axboe@kernel.dk>
	<20240320225750.1769647-18-axboe@kernel.dk>
	<87frwja83n.fsf@mailhost.krisman.be>
	<20f95e13-85af-4316-b167-160571f09369@kernel.dk>
Date: Thu, 21 Mar 2024 13:20:16 -0400
Message-ID: <878r2ba4dr.fsf@mailhost.krisman.be>
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
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H7ktCD5m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=n6OzWtK0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.51 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_DKIM_ARC_DNSWL_HI(-1.00)[];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 MX_GOOD(-0.01)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_IN_DNSWL_HI(-1.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Score: -6.51
X-Rspamd-Queue-Id: F0E6F5D1D8
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> On 3/21/24 9:59 AM, Gabriel Krisman Bertazi wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> Currently lists are being used to manage this, but lists isn't a very
>>> good choice for as extracting the current entry necessitates touching
>>> the next entry as well, to update the list head.
>>>
>>> Outside of that detail, games are also played with KASAN as the list
>>> is inside the cached entry itself.
>>>
>>> Finally, all users of this need a struct io_cache_entry embedded in
>>> their struct, which is union'ized with something else in there that
>>> isn't used across the free -> realloc cycle.
>>>
>>> Get rid of all of that, and simply have it be an array. This will not
>>> change the memory used, as we're just trading an 8-byte member entry
>>> for the per-elem array size.
>>>
>>> This reduces the overhead of the recycled allocations, and it reduces
>>> the code we have to support recycling.
>> 
>> Hi Jens,
>> 
>> I tried applying the entire to your for-6.10/io_uring branch to test it
>> and only this last patch failed to apply. The tip of the branch I have
>> is 22261e73e8d2 ("io_uring/alloc_cache: shrink default max entries from
>> 512 to 128").
>
> Yeah it has some dependencies that need unraveling. The easiest is if
> you just pull:
>
> git://git.kernel.dk/linux io_uring-recvsend-bundle
>
> into current -git master, and then just test that. That gets you pretty
> much everything that's being tested and played with.
>
> Top of tree is d5653d2fcf1383c0fbe8b64545664aea36c7aca2 right now.

thanks, I'll test with that.

>
>>> -static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
>>> +static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>>>  {
>>> -	if (cache->list.next) {
>>> -		struct io_cache_entry *entry;
>>> +	if (cache->nr_cached) {
>>> +		void *entry = cache->entries[--cache->nr_cached];
>>>  
>>> -		entry = container_of(cache->list.next, struct io_cache_entry, node);
>>>  		kasan_mempool_unpoison_object(entry, cache->elem_size);
>>> -		cache->list.next = cache->list.next->next;
>>> -		cache->nr_cached--;
>>>  		return entry;
>>>  	}
>>>  
>>>  	return NULL;
>>>  }
>>>  
>>> -static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
>>> -				       unsigned max_nr, size_t size)
>>> +static inline int io_alloc_cache_init(struct io_alloc_cache *cache,
>>> +				      unsigned max_nr, size_t size)
>>>  {
>>> -	cache->list.next = NULL;
>>> +	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
>>> +	if (!cache->entries)
>>> +		return -ENOMEM;
>>>  	cache->nr_cached = 0;
>>>  	cache->max_cached = max_nr;
>>>  	cache->elem_size = size;
>>> +	return 0;
>>>  }
>>>  
>>>  static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>>> -					void (*free)(struct io_cache_entry *))
>>> +				       void (*free)(const void *))
>> 
>> Minor, but since free is supposed to free the entry, const doesn't
>> make sense here.  Also, you actually just cast it away immediately in
>> every usage.
>
> It's because then I can use kfree() directly for most cases, only two of
> them have special freeing functions. And kfree takes a const void *. I
> should add a comment about that.

TIL. For the record, I was very puzzled on why kfree receives a const
pointer just to cast it away immediately too. Then I found Linus
discussing it at https://yarchive.net/comp/const.html

Anyway, in this case, we are actually modifying it in io_rw_cache_free,
and we don't need to explicitly cast from non-const to const , so I still
think you can avoid the comment and drop the const.  But that is just
a nitpick that i won't insist.

Thanks!

-- 
Gabriel Krisman Bertazi


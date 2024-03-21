Return-Path: <io-uring+bounces-1188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E29FE885CD1
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 17:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E25828476A
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 16:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AA912BF14;
	Thu, 21 Mar 2024 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kR4ZeNeQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kErNzTJ4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sK3jFZyr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1q1EFdw0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149AD12BF15
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036801; cv=none; b=j0yLVMrrtepr8LsvXUGULXrW2GPCIo1m2JQY1u+nIF73YiYmiQTWznUITxCdMTsqzs3FNx27QvE1JWvuyF8NT+8ZOWb4eVptSx4q9H6whL8ViyqzMLaIS8zflVtrTEMpuohk+2q5vK4HJDPIE+M3vJrB/I040kjL7mkKG7q3weA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036801; c=relaxed/simple;
	bh=AljBtoFQ3gL3cmJXF9jI3u7O9eKGddbTUTmqAoeskd4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Xoy5NYwF1XaXOZSns8rhepf5JOorQM00vZRcQgtg3JKzdqm//SE7gICs6VMABAfQDCGPVoCfzc0Rs1q4Wr8+d0YopzcQZLjcm/3Bje3l5uwsaI/FV+n0BjRenj2IRzedz4nu2F+HwZ2q0qQfBfLHxj+sC6i9WyLkilJ8r//3Mws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kR4ZeNeQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kErNzTJ4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sK3jFZyr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1q1EFdw0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F292A5D0CA;
	Thu, 21 Mar 2024 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711036798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CaRMqfCN5Kqlb2/JBTAIbvwkoEsz1wit8OqRsMPyWVs=;
	b=kR4ZeNeQVO28v1QuguSXjpMsdjMk8eu0NWWSI0RS6hTmu32ixmJ7hHb/Ud2wRfsTkWdN9Y
	9WR2qup8hU7hGwGxpKlbAplPxv65K6cYDo73Ge/Cy03WAVMd4+9z9wcRdNFRKZ0yZNqtzF
	G6EXwGx/rPFHc1zvPNNV/g02GXJMpJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711036798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CaRMqfCN5Kqlb2/JBTAIbvwkoEsz1wit8OqRsMPyWVs=;
	b=kErNzTJ4BI4ID/sqvmwXXCI0o06ykY0VfVrUmDN/B/2XQElM4qXwex7BkrgdYc/RSfmcEC
	+mLpfpkUSj3X17Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711036797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CaRMqfCN5Kqlb2/JBTAIbvwkoEsz1wit8OqRsMPyWVs=;
	b=sK3jFZyryuy0nojfc772dE1Gw54NMuU9s5uzgoDvh2QqSZ8GuEUh5BIilrOov34qLL1QUG
	/yR/Yj9uDYyS9WjPw8brhIYE7MHgQVhr0dbNFvX+ZnvY1yPuu1QZxc5+JxkqKOVeA8iuaB
	p4T+H17aZs8pLolSfKfkUCf/KgfseIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711036797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CaRMqfCN5Kqlb2/JBTAIbvwkoEsz1wit8OqRsMPyWVs=;
	b=1q1EFdw0ZCIVdGr7d4MzT7sOPxuCQ8YFaB5wwcdEyKmpn2J9i9HGaSlLRL/Ryqt1Hj7jY4
	ZjxplvsCA2M09HBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAD43138A1;
	Thu, 21 Mar 2024 15:59:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3VTuJ31Z/GWFEAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 21 Mar 2024 15:59:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 17/17] io_uring/alloc_cache: switch to array based caching
In-Reply-To: <20240320225750.1769647-18-axboe@kernel.dk> (Jens Axboe's message
	of "Wed, 20 Mar 2024 16:55:32 -0600")
References: <20240320225750.1769647-1-axboe@kernel.dk>
	<20240320225750.1769647-18-axboe@kernel.dk>
Date: Thu, 21 Mar 2024 11:59:56 -0400
Message-ID: <87frwja83n.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWO(0.00)[2];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[14.12%]
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> Currently lists are being used to manage this, but lists isn't a very
> good choice for as extracting the current entry necessitates touching
> the next entry as well, to update the list head.
>
> Outside of that detail, games are also played with KASAN as the list
> is inside the cached entry itself.
>
> Finally, all users of this need a struct io_cache_entry embedded in
> their struct, which is union'ized with something else in there that
> isn't used across the free -> realloc cycle.
>
> Get rid of all of that, and simply have it be an array. This will not
> change the memory used, as we're just trading an 8-byte member entry
> for the per-elem array size.
>
> This reduces the overhead of the recycled allocations, and it reduces
> the code we have to support recycling.

Hi Jens,

I tried applying the entire to your for-6.10/io_uring branch to test it
and only this last patch failed to apply. The tip of the branch I have
is 22261e73e8d2 ("io_uring/alloc_cache: shrink default max entries from
512 to 128").

> -static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
> +static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>  {
> -	if (cache->list.next) {
> -		struct io_cache_entry *entry;
> +	if (cache->nr_cached) {
> +		void *entry = cache->entries[--cache->nr_cached];
>  
> -		entry = container_of(cache->list.next, struct io_cache_entry, node);
>  		kasan_mempool_unpoison_object(entry, cache->elem_size);
> -		cache->list.next = cache->list.next->next;
> -		cache->nr_cached--;
>  		return entry;
>  	}
>  
>  	return NULL;
>  }
>  
> -static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
> -				       unsigned max_nr, size_t size)
> +static inline int io_alloc_cache_init(struct io_alloc_cache *cache,
> +				      unsigned max_nr, size_t size)
>  {
> -	cache->list.next = NULL;
> +	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
> +	if (!cache->entries)
> +		return -ENOMEM;
>  	cache->nr_cached = 0;
>  	cache->max_cached = max_nr;
>  	cache->elem_size = size;
> +	return 0;
>  }
>  
>  static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
> -					void (*free)(struct io_cache_entry *))
> +				       void (*free)(const void *))

Minor, but since free is supposed to free the entry, const doesn't make
sense here.  Also, you actually just cast it away immediately in every usage.

-- 
Gabriel Krisman Bertazi


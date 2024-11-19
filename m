Return-Path: <io-uring+bounces-4831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A47B9D29A4
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A95528143A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 15:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7C71CEAC8;
	Tue, 19 Nov 2024 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FTGsyYER";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yEaafJXf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FTGsyYER";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yEaafJXf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37A31CEAA6
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030244; cv=none; b=PxafndHKaxvjHM/1qUWJVZVjmK2H6D/5ElcpIdzLt46/eBI4Qi8g2tVR/L8cYX+pLc4ABt7qza3+2I8ANIXQfNZ+GJQf371HUiP5voBILvYozbQHBVKsdaCk9QZxs/jWBi20DymFWqT7JiYiI6kl2ywJtmXI1xrZ3vQgN/rsP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030244; c=relaxed/simple;
	bh=Ph5qUdHdoNyl1JmMZt6/dJ/5BeML+bRghBAe2RH9vvE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iLQXVPypUuSplLMa2LV+TnNTzQuJ5hEPga6rZhqyLjWZv0zr83Q0zM1fj65oGz8zwD1bD1j5+4xL+urlBSLbO8BymqdxxR07XgFCzGhKGkUEct7CwhctIwkZVyOa1fcmTpWyCj+Gz16qjKhETCb/Tyl+tXbBgRsz9jJb9jm9D0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FTGsyYER; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yEaafJXf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FTGsyYER; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yEaafJXf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CD34219F4;
	Tue, 19 Nov 2024 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732030240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vbOgxAEMRm8dGF9Zz3eXQUDyeJV2WTNLGJVX6FQEWA=;
	b=FTGsyYERxDc1PbJsN+fPfF45LpjhAHbz6OZ5O+a8F026OtxYg5+KPrgns797x6wa4aX0Ze
	+gcMvi3JCinr0X6RxWr7+JwJpw2op0jzYZvSevJxi6Ck+0r7m50jfJwhptYyhd/joSgKiy
	wFrMXcen8wredO2SKdKO+Q3hYMyqoFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732030240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vbOgxAEMRm8dGF9Zz3eXQUDyeJV2WTNLGJVX6FQEWA=;
	b=yEaafJXfkHxv20zuE4e6Gk1hSDMLb1sls2sR4s5UjkmnwaUI4HV+sgCXFroPuD5o8L+hzk
	BOad4BYxxzd4zwDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732030240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vbOgxAEMRm8dGF9Zz3eXQUDyeJV2WTNLGJVX6FQEWA=;
	b=FTGsyYERxDc1PbJsN+fPfF45LpjhAHbz6OZ5O+a8F026OtxYg5+KPrgns797x6wa4aX0Ze
	+gcMvi3JCinr0X6RxWr7+JwJpw2op0jzYZvSevJxi6Ck+0r7m50jfJwhptYyhd/joSgKiy
	wFrMXcen8wredO2SKdKO+Q3hYMyqoFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732030240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vbOgxAEMRm8dGF9Zz3eXQUDyeJV2WTNLGJVX6FQEWA=;
	b=yEaafJXfkHxv20zuE4e6Gk1hSDMLb1sls2sR4s5UjkmnwaUI4HV+sgCXFroPuD5o8L+hzk
	BOad4BYxxzd4zwDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFA4513736;
	Tue, 19 Nov 2024 15:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gQmlIh+vPGctIwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 19 Nov 2024 15:30:39 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com,  io-uring@vger.kernel.org
Subject: Re: [PATCH 1/9] io_uring: Fold allocation into alloc_cache helper
In-Reply-To: <4e679f16-7da9-47c7-959c-d4636e5117b2@kernel.dk> (Jens Axboe's
	message of "Mon, 18 Nov 2024 19:02:01 -0700")
Organization: SUSE
References: <20241119012224.1698238-1-krisman@suse.de>
	<20241119012224.1698238-2-krisman@suse.de>
	<4e679f16-7da9-47c7-959c-d4636e5117b2@kernel.dk>
Date: Tue, 19 Nov 2024 10:30:38 -0500
Message-ID: <87ttc3nsv5.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,kernel.dk:email]
X-Spam-Flag: NO
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> On 11/18/24 6:22 PM, Gabriel Krisman Bertazi wrote:
>> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
>> index b7a38a2069cf..6b34e491a30a 100644
>> --- a/io_uring/alloc_cache.h
>> +++ b/io_uring/alloc_cache.h
>> @@ -30,6 +30,13 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>>  	return NULL;
>>  }
>>  
>> +static inline void *io_alloc_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
>> +{
>> +	if (!cache->nr_cached)
>> +		return kzalloc(cache->elem_size, gfp);
>> +	return io_alloc_cache_get(cache);
>> +}
>
> I don't think you want to use kzalloc here. The caller will need to
> clear what its needs for the cached path anyway, so has no other option
> than to clear/set things twice for that case.

Hi Jens,

The reason I do kzalloc here is to be able to trust the value of
rw->free_iov (io_rw_alloc_async) and hdr->free_iov (io_msg_alloc_async)
regardless of where the allocated memory came from, cache or slab.  In
the callers (patch 6 and 7), we do:

+	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req);
+	if (!hdr)
+		return NULL;
+
+	/* If the async data was cached, we might have an iov cached inside. */
+	if (hdr->free_iov) {

An alternative would be to return a flag indicating whether the
allocated memory came from the cache or not, but it didn't seem elegant.
Do you see a better way?

I also considered that zeroing memory here shouldn't harm performance,
because it'll hit the cache most of the time.

-- 
Gabriel Krisman Bertazi


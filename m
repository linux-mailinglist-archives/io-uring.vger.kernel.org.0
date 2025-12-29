Return-Path: <io-uring+bounces-11321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9875ECE8480
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 23:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93530302BA88
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 22:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABEF26ED3A;
	Mon, 29 Dec 2025 22:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UX/0pSC9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5rLJ4eK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UX/0pSC9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u5rLJ4eK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87EA2253EE
	for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767046859; cv=none; b=mAZ4R2UXTRYiWEq0SkVot916yhbF3riYFfFARhuLjNggu5F3WUHc8DeeVlBbE316KSQFYXCbmPdrMOix4IfxQQDqEZ24PCS4dYx5CJiZFCSXQrnZIg80cfe+1+Kq9lujOvLOaBQ0BoyGr2D6fw4KkkJaRwVBpYQJe4rTxAijbQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767046859; c=relaxed/simple;
	bh=JavaibQ7QAtuvEU/Il9FKlLfWNtSRdYn0/TRVrhcsOw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YSF0prTnK++Wz4+mBoBcAED0GtS927FRQcTD6TPf7oSbfh6VkSvh709W6Hs2YQKimLCcqGRC+zZ6E6UPjP1q0FTHV9mM9G0Y+0J6FJFyten3d/BpRa6PTNoS8wX2LgfHcE7hDwlCP0EUqfI2t9dcfNBVUZ7NHWBqgkLLX3b09gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UX/0pSC9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5rLJ4eK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UX/0pSC9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u5rLJ4eK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7365D336BA;
	Mon, 29 Dec 2025 22:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767046853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=grl4rNS1I96r5uXy9DTxId5MOhS2SHzfmtfw88cYwgI=;
	b=UX/0pSC9qjBI+2b2ujrAbGB3MCqpVEqwZpzNXwJ4N3cyVdZNa3LbKXgaC7qA0lyEPKx3M0
	ZA1hjpAFcR5YyVZSFxA6+dXwuFXKpzfN2qIwrynDJK6S/FmPeEpkfypWeYL/JRCLuIxV8X
	89LPcT9kfZ/35VCH1CEYjlWs7YuR99c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767046853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=grl4rNS1I96r5uXy9DTxId5MOhS2SHzfmtfw88cYwgI=;
	b=u5rLJ4eKPGqecVpVurpdLpgtnB8LOm2Skjj7w1xorlS7KBBqtZdo4qtiqOgy3agpoELmqZ
	NRvI2GAgWFYo+WAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="UX/0pSC9";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5rLJ4eK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767046853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=grl4rNS1I96r5uXy9DTxId5MOhS2SHzfmtfw88cYwgI=;
	b=UX/0pSC9qjBI+2b2ujrAbGB3MCqpVEqwZpzNXwJ4N3cyVdZNa3LbKXgaC7qA0lyEPKx3M0
	ZA1hjpAFcR5YyVZSFxA6+dXwuFXKpzfN2qIwrynDJK6S/FmPeEpkfypWeYL/JRCLuIxV8X
	89LPcT9kfZ/35VCH1CEYjlWs7YuR99c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767046853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=grl4rNS1I96r5uXy9DTxId5MOhS2SHzfmtfw88cYwgI=;
	b=u5rLJ4eKPGqecVpVurpdLpgtnB8LOm2Skjj7w1xorlS7KBBqtZdo4qtiqOgy3agpoELmqZ
	NRvI2GAgWFYo+WAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2544813A8F;
	Mon, 29 Dec 2025 22:20:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 47MJAsX+Umk7cAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 29 Dec 2025 22:20:53 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu,  axboe@kernel.dk,  bschubert@ddn.com,
  asml.silence@gmail.com,  io-uring@vger.kernel.org,
  csander@purestorage.com,  xiaobing.li@samsung.com,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel
 managed buffer rings
In-Reply-To: <87tsx9ymm9.fsf@mailhost.krisman.be> (Gabriel Krisman Bertazi's
	message of "Mon, 29 Dec 2025 17:00:30 -0500")
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
	<20251223003522.3055912-8-joannelkoong@gmail.com>
	<87tsx9ymm9.fsf@mailhost.krisman.be>
Date: Mon, 29 Dec 2025 17:20:36 -0500
Message-ID: <87ms31ylor.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 7365D336BA
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,mailhost.krisman.be:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,ddn.com,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> Joanne Koong <joannelkoong@gmail.com> writes:
>
>> Add an interface for buffers to be recycled back into a kernel-managed
>> buffer ring.
>>
>> This is a preparatory patch for fuse over io-uring.
>>
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>> ---
>>  include/linux/io_uring/cmd.h | 13 +++++++++++
>>  io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
>>  io_uring/kbuf.h              |  3 +++
>>  io_uring/uring_cmd.c         | 11 ++++++++++
>>  4 files changed, 69 insertions(+)
>>
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index 424f071f42e5..7169a2a9a744 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
>>  			      unsigned issue_flags, struct io_buffer_list **bl);
>>  int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
>>  				unsigned issue_flags);
>> +
>> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
>> +				  unsigned int buf_group, u64 addr,
>> +				  unsigned int len, unsigned int bid,
>> +				  unsigned int issue_flags);
>>  #else
>>  static inline int
>>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> @@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd,
>>  {
>>  	return -EOPNOTSUPP;
>>  }
>> +static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
>> +						unsigned int buf_group,
>> +						u64 addr, unsigned int len,
>> +						unsigned int bid,
>> +						unsigned int issue_flags)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>>  #endif
>>  
>>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 03e05bab023a..f12d000b71c5 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
>>  	req->kbuf = NULL;
>>  }
>>  
>> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
>> +		     unsigned int len, unsigned int bid,
>> +		     unsigned int issue_flags)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_uring_buf_ring *br;
>> +	struct io_uring_buf *buf;
>> +	struct io_buffer_list *bl;
>> +	int ret = -EINVAL;
>> +
>> +	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
>> +		return ret;
>> +
>> +	io_ring_submit_lock(ctx, issue_flags);
>> +
>> +	bl = io_buffer_get_list(ctx, bgid);
>> +
>> +	if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
>> +	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
>> +		goto done;
>
> Hi Joanne,
>
> WARN_ONs are not supposed to be reached by the user, but I think that is
> possible here, i.e. by passing the bgid of legacy provided buffers.

But now I see this is never exposed to userspace as an io_uring_cmd
command itself, it is only used internally by other fuse operations.
Nevertheless, it's implemented as an io_uring_cmd by
io_uring_cmd_kmbuffer_recycle.

Is it eventually going to be exposed as operations to userspace? If not,
I'd suggest to stay out of the io_uring_cmd namespace (perhaps call
io_kmbuf_recycle directly from fs/fuse).  Do we need to have this
io_uring_cmd abstraction for some reason I'm missing?

Thanks,

-- 
Gabriel Krisman Bertazi


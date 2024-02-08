Return-Path: <io-uring+bounces-586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A649384E960
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 21:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E841F2671A
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 20:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EC6381CD;
	Thu,  8 Feb 2024 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B7mBHQJu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/IY0ia7U";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bkQuBwdG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UQzGMoL8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD63637711
	for <io-uring@vger.kernel.org>; Thu,  8 Feb 2024 20:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707422919; cv=none; b=g+ROVcgNL3z61ikAqZe6Zc1mAdwNf9+Me+bZFogZPb2MW2mK9WuW4S98OAWlWYzXx8eWH3LvUXsVjm3zWmAAmw0X32quo9VepgFeKp1c7y0x68SaT/b0c1xDkm0qBBymc5S8udRQ2TUUEAzOfMT2o0MRHS9hasIXUrwzpG9BHrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707422919; c=relaxed/simple;
	bh=szNc0EQSO70N/Ldf19GF5brvRuWEg0DPhp1tsh0LrQ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lhHu778eqerT3yb5zH8HMWk7d1IqPIqWMz6dSL85aqfFpInvJBtjTERfmxTmc9XQzqIcxUFom+p2r8sAhUHSPKwRWPUcI8qtGi2AE1MYZd3DKy3oaQXS0mBRsWWxI0dYmDm2SHmW9Zau8G1KrH1NczR9DkTXlmFDmuNdJ00H25c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B7mBHQJu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/IY0ia7U; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bkQuBwdG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UQzGMoL8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BFBB41FD06;
	Thu,  8 Feb 2024 20:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707422915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mqh65lBnapslPI+xBbS6WRpalypgfp1BRhyShhY2fiM=;
	b=B7mBHQJuOPM9bzcHyg6vhcvewKS0l6+I1iDN3M3mnlBujo0wLGw43nUttIzUwr7+HbAgtA
	smrEmZGb5+0MQOfyPvls00grQt53g6KMpOQVxTqMYuyEZDuQq1Jo3wpjQm/d2pKBVw/7KN
	pA43aDl1ncrL8sDT5675WW6LxnsJcy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707422915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mqh65lBnapslPI+xBbS6WRpalypgfp1BRhyShhY2fiM=;
	b=/IY0ia7Udin7SQB7rtr7Az8PIwyjJ7dfQsHqHVLIqJjkzP6FN6WUKnQVctRtYNAPypRWze
	cfefmyqG09cl78AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707422914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mqh65lBnapslPI+xBbS6WRpalypgfp1BRhyShhY2fiM=;
	b=bkQuBwdGzvxZwrYP1afe5qe1wpnvTLUisgNeUjX+0u9PCAzfAp0liNgQman3URMPX7qNDT
	IA3VEwRjXmbBIvIj0+iPLUYBXf5X0L9AU/XkPEFXdQekgA80AySGJ9Nu0+jxINPoH7QBUI
	4StnZCcsP/3NfXLZvDtH3ZkvexCNbQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707422914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mqh65lBnapslPI+xBbS6WRpalypgfp1BRhyShhY2fiM=;
	b=UQzGMoL8rpCX9OICv8IsBNSVz2D7F7hCzrEiSThuUWJgAtA7mDJzaP1hrBtpjoYAPGU6DB
	XsDKa3YRYjpemvAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8356A13984;
	Thu,  8 Feb 2024 20:08:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zXrYGcI0xWURSQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 08 Feb 2024 20:08:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to 64-bits
In-Reply-To: <20240207171941.1091453-2-axboe@kernel.dk> (Jens Axboe's message
	of "Wed, 7 Feb 2024 10:17:35 -0700")
References: <20240207171941.1091453-1-axboe@kernel.dk>
	<20240207171941.1091453-2-axboe@kernel.dk>
Date: Thu, 08 Feb 2024 15:08:29 -0500
Message-ID: <87cyt6vhvm.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bkQuBwdG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UQzGMoL8
X-Spamd-Result: default: False [-2.31 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BFBB41FD06
X-Spam-Level: 
X-Spam-Score: -2.31
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:


> -	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, %s queue, work %p",
> +	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%lx, %s queue, work %p",
>  		__entry->ctx, __entry->req, __entry->user_data,
> -		__get_str(op_str),
> -		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
> +		__get_str(op_str), (long) __entry->flags,

Hi Jens,

Minor, but on 32-bit kernel the cast is wrong since
sizeof(long)==4. Afaik, io_uring still builds on 32-bit archs.

If you use (unsigned long long), it will be 64 bit anywhere.

> +		__entry->rw ? "hashed" : "normal", __entry->work)
>  );
>  
>  /**
> @@ -378,7 +378,7 @@ TRACE_EVENT(io_uring_submit_req,
>  		__field(  void *,		req		)
>  		__field(  unsigned long long,	user_data	)
>  		__field(  u8,			opcode		)
> -		__field(  u32,			flags		)
> +		__field(  io_req_flags_t,	flags		)
>  		__field(  bool,			sq_thread	)
>  
>  		__string( op_str, io_uring_get_opcode(req->opcode) )
> @@ -395,10 +395,10 @@ TRACE_EVENT(io_uring_submit_req,
>  		__assign_str(op_str, io_uring_get_opcode(req->opcode));
>  	),
>  
> -	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
> +	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%lx, "
>  		  "sq_thread %d", __entry->ctx, __entry->req,
>  		  __entry->user_data, __get_str(op_str),
> -		  __entry->flags, __entry->sq_thread)
> +		  (long) __entry->flags, __entry->sq_thread)

likewise.

>  );
>  
>  /*
> diff --git a/io_uring/filetable.h b/io_uring/filetable.h
> index b47adf170c31..b2435c4dca1f 100644
> --- a/io_uring/filetable.h
> +++ b/io_uring/filetable.h
> @@ -17,7 +17,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
>  int io_register_file_alloc_range(struct io_ring_ctx *ctx,
>  				 struct io_uring_file_index_range __user *arg);
>  
> -unsigned int io_file_get_flags(struct file *file);
> +io_req_flags_t io_file_get_flags(struct file *file);
>  
>  static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
>  {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cd9a137ad6ce..b8ca907b77eb 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1768,9 +1768,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
>  	}
>  }
>  
> -unsigned int io_file_get_flags(struct file *file)
> +io_req_flags_t io_file_get_flags(struct file *file)
>  {
> -	unsigned int res = 0;
> +	io_req_flags_t res = 0;
>  
>  	if (S_ISREG(file_inode(file)->i_mode))
>  		res |= REQ_F_ISREG;
> @@ -2171,7 +2171,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	/* req is partially pre-initialised, see io_preinit_req() */
>  	req->opcode = opcode = READ_ONCE(sqe->opcode);
>  	/* same numerical values with corresponding REQ_F_*, safe to copy */
> -	req->flags = sqe_flags = READ_ONCE(sqe->flags);
> +	sqe_flags = READ_ONCE(sqe->flags);

Did you consider that READ_ONCE won't protect from load tearing the
userspace value in 32-bit architectures? It builds silently, though, and
I suspect it is mostly fine in the current code, but might become a bug
eventually.

Thanks,

-- 
Gabriel Krisman Bertazi


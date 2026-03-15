Return-Path: <io-uring+bounces-12680-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 3n93JasktmnY9wAAu9opvQ
	(envelope-from <io-uring+bounces-12680-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 04:16:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D517C28FD11
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 04:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B94E304D964
	for <lists+io-uring@lfdr.de>; Sun, 15 Mar 2026 03:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EA542A9D;
	Sun, 15 Mar 2026 03:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u+c7e7ir";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1BxsF6X4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kfiNInCp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QHIFMe9X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ADC335BA
	for <io-uring@vger.kernel.org>; Sun, 15 Mar 2026 03:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773544616; cv=none; b=JhUWRgW9WJxGaDTqEthIzlw5lOLKzjXx/VJBk7rC7XKRWu4TayloVlGV2Vuj8vl55xnQIQV5t9Fp72k/rPOFOo/SzOWiGetRXzBU/aT04yjutxKF1k69nkimiwxgsWNDk5qFhLSx6DNbliaD2Tq3bMMIUanpijbzwn537EiYaoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773544616; c=relaxed/simple;
	bh=vfoZpYe/XhUxSKhImh05ClhsWz7Kj6FSj7tUdMm+85w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kI3fhPfmgKIOtZffGL/bEa+Toy6ot/nE7fLWv5FcGUMK7U2HqWZR/r8Zfri/UMPIU0hDk0WAPuhcC/K/p2EawiFwFPLWaDDuFquEoenSe5E42a7Q1j7Z0o7vqa3hmbIEGIZHruuTH8HKOXhKT6XI+g8WunDsQaKZoKKfvqcOan4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u+c7e7ir; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1BxsF6X4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kfiNInCp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QHIFMe9X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F24594D20F;
	Sun, 15 Mar 2026 03:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773544607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkkBoUB41r/mBy/TIQ+28CuaeSFc1Ytd7CxuJqFsV/k=;
	b=u+c7e7irrTNKJN5bT16CLXNBSqCY76ZQDQVG+5dsU1TsZP60qLVY16sX0qBUVPK8ZQSMfv
	U0Ozu376nVVnGkLjKYS2tQALCB54Dpg+42ILtDB1YEYiJBvNZ278D4+ZTZEreuxn6KRyTj
	e3JCr6SgKyDRYH3VS+SoJkdHekDS2S8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773544607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkkBoUB41r/mBy/TIQ+28CuaeSFc1Ytd7CxuJqFsV/k=;
	b=1BxsF6X4JQpe61d55gmHrdCVCATcaJqJJKa2pzPdGAOor+11TE5v4H+3D9g/Mdzqwzf93m
	LWwd0DrJcsqv4QDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773544606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkkBoUB41r/mBy/TIQ+28CuaeSFc1Ytd7CxuJqFsV/k=;
	b=kfiNInCpH+bMp2lned0qNVB3i0fXE0pQ/Q53S4UTSvbXJtOpKyKytXypDLdrSnfl+6PEXu
	+mSet3GudItejT3o56M8Zh9WcZVMkWc6vUTXGOn9j8sSwziGqeD/SFpxEFNlUKJjeLWXDe
	H8QM49d8DjsBbg3lXNCXXxLDV0dm6co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773544606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkkBoUB41r/mBy/TIQ+28CuaeSFc1Ytd7CxuJqFsV/k=;
	b=QHIFMe9XJUc4pNWhKA88PUBIYt3Tf9LpkxuccXYeoqkf2zOGomwIWorzvN8ITtf7lSZioB
	nPa1r8ybbZrZ8LCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1D2A4273B;
	Sun, 15 Mar 2026 03:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mtTLIZ4ktmn4LgAAD6G6ig
	(envelope-from <krisman@suse.de>); Sun, 15 Mar 2026 03:16:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: switch struct io_ring_ctx internal
 bitfields to flags
In-Reply-To: <20260314145920.86796-2-axboe@kernel.dk> (Jens Axboe's message of
	"Sat, 14 Mar 2026 08:58:05 -0600")
References: <20260314145920.86796-1-axboe@kernel.dk>
	<20260314145920.86796-2-axboe@kernel.dk>
Date: Sat, 14 Mar 2026 23:16:44 -0400
Message-ID: <87sea1wzmr.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12680-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: D517C28FD11
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Jens Axboe <axboe@kernel.dk> writes:

> Bitfields cannot be set and checked atomically, and this makes it more
> clear that these are indeed in shared storage and must be checked and
> set in a sane fashion. This is in preparation for annotating a few of
> the known racy, but harmless, flags checking.
>
> No intended functional changes in this patch.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h | 32 +++++++------
>  io_uring/eventfd.c             |  4 +-
>  io_uring/io_uring.c            | 82 +++++++++++++++++-----------------
>  io_uring/io_uring.h            |  9 ++--
>  io_uring/msg_ring.c            |  2 +-
>  io_uring/register.c            |  8 ++--
>  io_uring/rsrc.c                |  8 ++--
>  io_uring/tctx.c                |  2 +-
>  io_uring/timeout.c             |  4 +-
>  io_uring/tw.c                  |  2 +-
>  10 files changed, 80 insertions(+), 73 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index dd1420bfcb73..b84576374c7b 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -268,24 +268,28 @@ struct io_alloc_cache {
>  	unsigned int		init_clear;
>  };
>  
> +enum {
> +	IO_RING_F_DRAIN_NEXT		= BIT(0),
> +	IO_RING_F_OP_RESTRICTED		= BIT(1),
> +	IO_RING_F_REG_RESTRICTED	= BIT(2),
> +	IO_RING_F_OFF_TIMEOUT_USED	= BIT(3),
> +	IO_RING_F_DRAIN_ACTIVE		= BIT(4),
> +	IO_RING_F_HAS_EVFD		= BIT(5),
> +	/* all CQEs should be posted only by the submitter task */
> +	IO_RING_F_TASK_COMPLETE		= BIT(6),
> +	IO_RING_F_LOCKLESS_CQ		= BIT(7),
> +	IO_RING_F_SYSCALL_IOPOLL	= BIT(8),
> +	IO_RING_F_POLL_ACTIVATED	= BIT(9),
> +	IO_RING_F_DRAIN_DISABLED	= BIT(10),
> +	IO_RING_F_COMPAT		= BIT(11),
> +	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
> +};
> +
>  struct io_ring_ctx {
>  	/* const or read-mostly hot data */
>  	struct {
>  		unsigned int		flags;
> -		unsigned int		drain_next: 1;
> -		unsigned int		op_restricted: 1;
> -		unsigned int		reg_restricted: 1;
> -		unsigned int		off_timeout_used: 1;
> -		unsigned int		drain_active: 1;
> -		unsigned int		has_evfd: 1;
> -		/* all CQEs should be posted only by the submitter task */
> -		unsigned int		task_complete: 1;
> -		unsigned int		lockless_cq: 1;
> -		unsigned int		syscall_iopoll: 1;
> -		unsigned int		poll_activated: 1;
> -		unsigned int		drain_disabled: 1;
> -		unsigned int		compat: 1;
> -		unsigned int		iowq_limits_set : 1;
> +		unsigned int		int_flags;

Jens,

What does the int prefix means in this context?

-- 
Gabriel Krisman Bertazi


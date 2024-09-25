Return-Path: <io-uring+bounces-3297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 482649852AE
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 07:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A7361C21036
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 05:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6283843AD7;
	Wed, 25 Sep 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ciPMTx17";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yaVQlpLx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uG6VMXJG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vKfFh61h"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADD5647;
	Wed, 25 Sep 2024 05:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727243858; cv=none; b=IDkljU5H7OvorDbGRHMInz9Q+SlYJcugyyo+TFuTXId/ndtbRcVBo+DoYpSoQDkcseZtpBELq6pLkrtPgPgoo+7PQNlXsXMlRHVIW0AX9L5WaL0Qbli+4+8mIeHlRTBehGNmpvdJ8N8ZJlsJqeEqvV/wGaE/wdRTPnYrfy/aYe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727243858; c=relaxed/simple;
	bh=QMnvkHrnX6DpOPIUvO7BNl1mwT3AgkjCUdRtDwNRGws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aaLVLXNWeI9u/6OHQmIHyjleRJUFqN5Jd6/neliR5Tu8+ajbbQlAAoMB+yrjwW9vIeRclNX91eEjWGolUwh321yHh8OWwMfqu+zdtVADD57EBvvWEVxk5mpOJBBUT2obZNZ+NJUx3KPCFVe0PxAKpq8wuNuXen4ZcAFk1rZ1iWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ciPMTx17; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yaVQlpLx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uG6VMXJG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vKfFh61h; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 718C11F7F9;
	Wed, 25 Sep 2024 05:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+OcrvMk2e5Vhorb1JynJI09OAStj38QG4ipQBl6gow=;
	b=ciPMTx172C9peh0vYN2hMc57lcq5V4u3kcCrS2+26HDvcZpfj6riY29AHezOvtIvIzpZ90
	m3eFr70JerEItyewKxevGeyLYUF1fhqKBlPft+bqpec8GstQcSYgQerUGGjrRB9gs4hGpw
	VkygvxjKttWUKcObwZI9haGMD1c8NAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+OcrvMk2e5Vhorb1JynJI09OAStj38QG4ipQBl6gow=;
	b=yaVQlpLxIpJG2brkAZLxlk/r3EaGCQDvk18lvMOp8ZsH15hGSX8vabbOnM9gZX+jQWTKI7
	K4F/HKuXBmLNkjDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uG6VMXJG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vKfFh61h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727243853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+OcrvMk2e5Vhorb1JynJI09OAStj38QG4ipQBl6gow=;
	b=uG6VMXJGhMTjaEFTDmq/JjqCTRNhtZIMBBrDc0S7EB1p28CN0jrt7MAZ24FhKeNHtGNGWa
	FFNWqAuF375eH1cWJ9iaTFYerihUbcHTWzf+Skhd7OiiS7z363U+B0KWze0rDR1SKyZRIE
	lgqkS4iWiGSxQ5keyR1gsfodCQfGIOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727243853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+OcrvMk2e5Vhorb1JynJI09OAStj38QG4ipQBl6gow=;
	b=vKfFh61hx0+kGpTjpgTuXLR5MM46JZxoVUTf2GTIcO0YpI6rLDe7ezOa25xWSwo0pLFPbK
	kJCKEDgMb1zvuiCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DF3213A6A;
	Wed, 25 Sep 2024 05:57:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sHrsOEqm82YBVwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 25 Sep 2024 05:57:30 +0000
Message-ID: <28419703-681c-4d8c-9450-bdc2aff19d56@suse.de>
Date: Wed, 25 Sep 2024 07:57:31 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] io_uring: enable per-io hinting capability
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>
References: <20240924092457.7846-1-joshi.k@samsung.com>
 <CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>
 <20240924092457.7846-4-joshi.k@samsung.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240924092457.7846-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 718C11F7F9
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	FREEMAIL_TO(0.00)[samsung.com,kernel.dk,kernel.org,lst.de,grimberg.me,oracle.com,zeniv.linux.org.uk,suse.cz,kvack.org,redhat.com,acm.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 9/24/24 11:24, Kanchan Joshi wrote:
> With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
> all the subsequent writes on the file pass that hint value down.
> This can be limiting for large files (and for block device) as all the
> writes can be tagged with only one lifetime hint value.
> Concurrent writes (with different hint values) are hard to manage.
> Per-IO hinting solves that problem.
> 
> Allow userspace to pass the write hint type and its value in the SQE.
> Two new fields are carved in the leftover space of SQE:
> 	__u8 hint_type;
> 	__u64 hint_val;
> 
> Adding the hint_type helps in keeping the interface extensible for future
> use.
> At this point only one type TYPE_WRITE_LIFETIME_HINT is supported. With
> this type, user can pass the lifetime hint values that are currently
> supported by F_SET_RW_HINT fcntl.
> 
> The write handlers (io_prep_rw, io_write) process the hint type/value
> and hint value is passed to lower-layer using kiocb. This is good for
> supporting direct IO, but not when kiocb is not available (e.g.,
> buffered IO).
> 
> In general, per-io hints take the precedence on per-inode hints.
> Three cases to consider:
> 
> Case 1: When hint_type is 0 (explicitly, or implicitly as SQE fields are
> initialized to 0), this means user did not send any hint. The per-inode
> hint values are set in the kiocb (as before).
> 
> Case 2: When hint_type is TYPE_WRITE_LIFETIME_HINT, the hint_value is
> set into the kiocb after sanity checking.
> 
> Case 3: When hint_type is anything else, this is flagged as an error
> and write is failed.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>   fs/fcntl.c                    | 22 ----------------------
>   include/linux/rw_hint.h       | 24 ++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h | 10 ++++++++++
>   io_uring/rw.c                 | 21 ++++++++++++++++++++-
>   4 files changed, 54 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 081e5e3d89ea..2eb78035a350 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -334,28 +334,6 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
>   }
>   #endif
>   
> -static bool rw_hint_valid(u64 hint)
> -{
> -	BUILD_BUG_ON(WRITE_LIFE_NOT_SET != RWH_WRITE_LIFE_NOT_SET);
> -	BUILD_BUG_ON(WRITE_LIFE_NONE != RWH_WRITE_LIFE_NONE);
> -	BUILD_BUG_ON(WRITE_LIFE_SHORT != RWH_WRITE_LIFE_SHORT);
> -	BUILD_BUG_ON(WRITE_LIFE_MEDIUM != RWH_WRITE_LIFE_MEDIUM);
> -	BUILD_BUG_ON(WRITE_LIFE_LONG != RWH_WRITE_LIFE_LONG);
> -	BUILD_BUG_ON(WRITE_LIFE_EXTREME != RWH_WRITE_LIFE_EXTREME);
> -
> -	switch (hint) {
> -	case RWH_WRITE_LIFE_NOT_SET:
> -	case RWH_WRITE_LIFE_NONE:
> -	case RWH_WRITE_LIFE_SHORT:
> -	case RWH_WRITE_LIFE_MEDIUM:
> -	case RWH_WRITE_LIFE_LONG:
> -	case RWH_WRITE_LIFE_EXTREME:
> -		return true;
> -	default:
> -		return false;
> -	}
> -}
> -
>   static long fcntl_get_rw_hint(struct file *file, unsigned int cmd,
>   			      unsigned long arg)
>   {
> diff --git a/include/linux/rw_hint.h b/include/linux/rw_hint.h
> index 309ca72f2dfb..f4373a71ffed 100644
> --- a/include/linux/rw_hint.h
> +++ b/include/linux/rw_hint.h
> @@ -21,4 +21,28 @@ enum rw_hint {
>   static_assert(sizeof(enum rw_hint) == 1);
>   #endif
>   
> +#define	WRITE_LIFE_INVALID	(RWH_WRITE_LIFE_EXTREME + 1)
> +
> +static inline bool rw_hint_valid(u64 hint)
> +{
> +	BUILD_BUG_ON(WRITE_LIFE_NOT_SET != RWH_WRITE_LIFE_NOT_SET);
> +	BUILD_BUG_ON(WRITE_LIFE_NONE != RWH_WRITE_LIFE_NONE);
> +	BUILD_BUG_ON(WRITE_LIFE_SHORT != RWH_WRITE_LIFE_SHORT);
> +	BUILD_BUG_ON(WRITE_LIFE_MEDIUM != RWH_WRITE_LIFE_MEDIUM);
> +	BUILD_BUG_ON(WRITE_LIFE_LONG != RWH_WRITE_LIFE_LONG);
> +	BUILD_BUG_ON(WRITE_LIFE_EXTREME != RWH_WRITE_LIFE_EXTREME);
> +
> +	switch (hint) {
> +	case RWH_WRITE_LIFE_NOT_SET:
> +	case RWH_WRITE_LIFE_NONE:
> +	case RWH_WRITE_LIFE_SHORT:
> +	case RWH_WRITE_LIFE_MEDIUM:
> +	case RWH_WRITE_LIFE_LONG:
> +	case RWH_WRITE_LIFE_EXTREME:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   #endif /* _LINUX_RW_HINT_H */
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 1fe79e750470..e21a74dd0c49 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,11 @@ struct io_uring_sqe {
>   			__u64	addr3;
>   			__u64	__pad2[1];
>   		};
> +		struct {
> +			/* To send per-io hint type/value with write command */
> +			__u64	hint_val;
> +			__u8	hint_type;
> +		};
Why is 'hint_val' 64 bits? Everything else is 8 bytes, so wouldn't it
be better to shorten that? As it stands the new struct will introduce
a hole of 24 bytes after 'hint_type'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich



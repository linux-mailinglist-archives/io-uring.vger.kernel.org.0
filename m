Return-Path: <io-uring+bounces-2308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A348A911AE8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFE78B225F8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B273F13BC05;
	Fri, 21 Jun 2024 06:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s07WWul/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ms6fmZMo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s07WWul/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ms6fmZMo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F0512F365;
	Fri, 21 Jun 2024 06:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950191; cv=none; b=QH/F32C311vsoBWMj8rMehWDN+LsocRBK6JPNRmEkUDP1kHqqFdwt1g9Vt1MnLtjg6mKofxgeH5GWZgtQNcgJwwiKFQB+68NM/TlfsgUMFaPCvmr4r/Yd4gnfy0rD+5Gy3OrE5UGRFmG8GIwM4ugkv5W1PemaqncxN3r898z53Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950191; c=relaxed/simple;
	bh=fZAT5KCGeVpWRYH2hi6UMTji/DFcVU1ml36We20Vzvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpJKF2ot+V2D55D77bQxWNVhI2uP2Yrc5bNQRBSK7+5BbCuLV5pP8OB2x+9ROqEq4556EQU5RmNfBLFfbW5U7MJA4KewtdPSlq/yLEWnE5jZy2paRTV3fgWyF7YCKtIxg6TWzK9IilvSlEzSDBd8bzftZMyoVNNsK8MN+bjZR1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s07WWul/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ms6fmZMo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s07WWul/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ms6fmZMo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FFA121A2D;
	Fri, 21 Jun 2024 06:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XI3w5JE8nUss82JXbM0IMAdRMptSmIQ6B6J/AdsEAg0=;
	b=s07WWul/CjJ2d6uhpM+qZIm3J/Vok23QwTF5r1v56lQUOUVpx/T+L9bu7a0G8/iQWC6gWz
	7Ya2vGmVJD7yVUWyCP4Zm2Q43bmWakS7my3xNkDee5hu4x0FQIjoOs+u6pqfmPRmwIBy5c
	+l5N6JuMnj8eRViPiJLoLzrPPCAI9rE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XI3w5JE8nUss82JXbM0IMAdRMptSmIQ6B6J/AdsEAg0=;
	b=Ms6fmZMoMwlVCzXrdAfijlWUjuwA7oJsAaeAhNx04tYVJpBMNnx38BWvZFAiaGwB7gLnQp
	vKaj9GEpmUmS8UDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s07WWul/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ms6fmZMo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XI3w5JE8nUss82JXbM0IMAdRMptSmIQ6B6J/AdsEAg0=;
	b=s07WWul/CjJ2d6uhpM+qZIm3J/Vok23QwTF5r1v56lQUOUVpx/T+L9bu7a0G8/iQWC6gWz
	7Ya2vGmVJD7yVUWyCP4Zm2Q43bmWakS7my3xNkDee5hu4x0FQIjoOs+u6pqfmPRmwIBy5c
	+l5N6JuMnj8eRViPiJLoLzrPPCAI9rE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XI3w5JE8nUss82JXbM0IMAdRMptSmIQ6B6J/AdsEAg0=;
	b=Ms6fmZMoMwlVCzXrdAfijlWUjuwA7oJsAaeAhNx04tYVJpBMNnx38BWvZFAiaGwB7gLnQp
	vKaj9GEpmUmS8UDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50E1313ABD;
	Fri, 21 Jun 2024 06:09:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o0rjDisZdWbEewAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:09:47 +0000
Message-ID: <222b6963-4728-4005-871f-40d761e133bd@suse.de>
Date: Fri, 21 Jun 2024 08:09:46 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 05/10] block: Add core atomic write support
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 dchinner@redhat.com, jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
 linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
 linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com,
 ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
 Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-6-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FFA121A2D
X-Spam-Score: -3.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev,oracle.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL7q43nzpr7is614unuocxbefr)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/20/24 14:53, John Garry wrote:
[ .. ]
> +/*
> + * Returns max guaranteed bytes which we can fit in a bio.
> + *
> + * We request that an atomic_write is ITER_UBUF iov_iter (so a single vector),
> + * so we assume that we can fit in at least PAGE_SIZE in a segment, apart from
> + * the first and last segments.
> + */
> +static
> +unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
> +{
> +	unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
> +	unsigned int length;
> +
> +	length = min(max_segments, 2) * lim->logical_block_size;
> +	if (max_segments > 2)
> +		length += (max_segments - 2) * PAGE_SIZE;
> +
> +	return length;
> +}
> +
Now you got me confused.

Why is the length of an atomic write two times the logical block size?
And even if it does, shouldn't an atomic write be aligned to the logical 
block size, so why would you need to add two additional PAGE_SIZE worth
of length?
And even if _that_ would be okay, why PAGE_SIZE? We're trying really 
hard to get away from implicit PAGE_SIZE assumptions when doing I/O ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich



Return-Path: <io-uring+bounces-2312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C94911B4E
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 08:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0451C224C3
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 06:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE0C16D4F9;
	Fri, 21 Jun 2024 06:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="F+rL0Gn+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3tc0/dT5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Lbq3GVVD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cKLugUhC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC7153580;
	Fri, 21 Jun 2024 06:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718950564; cv=none; b=XEBpZ4D2Xwu+Q77NE5t5+pEZzIcVBZg4LHfpyR4Hfzrm+IZDuKxJnoUFiBmkq5wn8jwhqp1FOIyZUl4C+dImzqwz3zBXUhgjSB8TR5RYymKfuz4ncM4m2X/uEV/ZAiyiFz7Q480p0F70fZXpyC6W7T3cDLt+6K+6HHtHrPk6e4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718950564; c=relaxed/simple;
	bh=K8njNEkJlHP1dW8n5uIPEzdz0eYwgn5OsKMv6AuVNbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ft4plCJlAFTsA9EbHeror2SZhwby6McnlwUoaXgn1EeCwnb8JWhDzue/axAtM+NHbGUpoCga82JMv2ZtGLKubqRfnH7yAp/0mOKheUgmi7Kf9iCturr0Yl3/WjCcKgNlay+qfxaSZK6APVk4sw4/G5fDirbk9MxPHREkPjbC5eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=F+rL0Gn+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3tc0/dT5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Lbq3GVVD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cKLugUhC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B3721FB4E;
	Fri, 21 Jun 2024 06:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tN4ivRLOJvdsi6A1Azz8+51sUsLN6tHsYHLb/nafu1k=;
	b=F+rL0Gn+ddsFnW9jWe4IgRydpKj17zedr9GD6Zw2WnmjxViw9nrp9n4+BCl6W+bkyEIeVH
	UETf7JsuOtDEldTF4Gh9fRa7P/F6xpx3Ssi8sUlmE7sT2wnp0QEg0WStxaIH3iO2Ac7687
	hRGyzZju8zzpChA+rjgkAQKeRASxaGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tN4ivRLOJvdsi6A1Azz8+51sUsLN6tHsYHLb/nafu1k=;
	b=3tc0/dT5IrG47kflHRs2TZ9IUywNV3213aDEoyl+BFR+c3sFvtFE/a6bQHjQ7t7K2rDGvA
	iGBI6aUrHIhaHlCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718950560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tN4ivRLOJvdsi6A1Azz8+51sUsLN6tHsYHLb/nafu1k=;
	b=Lbq3GVVDW89VKCcmlSbFR1LVt5R8DBgzzYe/XmPybarPYxReLB10Kj1LcJqd3cV5DsDDwm
	IUqr6MDMA6D0wTYpa/T1heRuK8L0rYigpc4NX+KLW9FOPx4jnx7wKqGznyMRETGk5UPG8i
	PwC41JeKRJzlIEakGMKYcKWa3COFcoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718950560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tN4ivRLOJvdsi6A1Azz8+51sUsLN6tHsYHLb/nafu1k=;
	b=cKLugUhCP7+wm7ysLbf99J7jta9PHMsKximFoiv/F5VDP95MNASe4X9+p8M0AFdKBCdngC
	KVUZELZH7lTtDKBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA5DD13ABD;
	Fri, 21 Jun 2024 06:15:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WBn+MJ4adWbDfAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Jun 2024 06:15:58 +0000
Message-ID: <141c769a-1642-424c-bae1-1d19441a115a@suse.de>
Date: Fri, 21 Jun 2024 08:15:58 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 09/10] scsi: scsi_debug: Atomic write support
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
 snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-10-john.g.garry@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240620125359.2684798-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,lists.infradead.org,mit.edu,google.com,linux.ibm.com,kvack.org,gmail.com,infradead.org,redhat.com,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,oracle.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 

On 6/20/24 14:53, John Garry wrote:
> Add initial support for atomic writes.
> 
> As is standard method, feed device properties via modules param, those
> being:
> - atomic_max_size_blks
> - atomic_alignment_blks
> - atomic_granularity_blks
> - atomic_max_size_with_boundary_blks
> - atomic_max_boundary_blks
> 
> These just match sbc4r22 section 6.6.4 - Block limits VPD page.
> 
> We just support ATOMIC WRITE (16).
> 
> The major change in the driver is how we lock the device for RW accesses.
> 
> Currently the driver uses a per-device lock for accessing device metadata
> and "media" data (calls to do_device_access()) atomically for the duration
> of the whole read/write command.
> 
> This should not suit verifying atomic writes. Reason being that currently
> all reads/writes are atomic, so using atomic writes does not prove
> anything.
> 
> Change device access model to basis that regular writes only atomic on a
> per-sector basis, while reads and atomic writes are fully atomic.
> 
> As mentioned, since accessing metadata and device media is atomic,
> continue to have regular writes involving metadata - like discard or PI -
> as atomic. We can improve this later.
> 
> Currently we only support model where overlapping going reads or writes
> wait for current access to complete before commencing an atomic write.
> This is described in 4.29.3.2 section of the SBC. However, we simplify,
> things and wait for all accesses to complete (when issuing an atomic
> write).
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_debug.c | 588 +++++++++++++++++++++++++++++---------
>   1 file changed, 454 insertions(+), 134 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich



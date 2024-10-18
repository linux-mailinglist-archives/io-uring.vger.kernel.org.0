Return-Path: <io-uring+bounces-3809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7196E9A3513
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 08:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC5401F25F63
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 06:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8215017BB34;
	Fri, 18 Oct 2024 06:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WmG5hHju";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DZvkMGtL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WmG5hHju";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DZvkMGtL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B020E30C;
	Fri, 18 Oct 2024 06:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231427; cv=none; b=FkktCQdDqluAjovxEuSUR57SPKkuhPQEdIfLNt95yyfcBAZm64gFuqShPHly3vvQhQNETLjIERzK2uEDzr6PFoeasAlNxdiT0L5e276CIXogMuFX/pMnCtFFSHIcnXQ/vCDPwoBcRhC08TNtrzuMVUm54uAvwbYE6atI6wjzWcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231427; c=relaxed/simple;
	bh=3Pc5B9k2Yu6Bz7cqzdyRm60n3qQYMjT6ZtRgRh5KS4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oe9V5DIlmI7z7zrHqRaZZUBl03FoZWWhKHSncG8PVmQi8sRVHCxvPwInFDp06TLIuMCIBCSbM4laDfLv6f0DfDDR7BOsDTuWgyR8SbuOfeeOIz8zb+1HbVFQSaLwvx1ISbTSsLExOB6T8abPzqbEy0LoBg+GcKVz/Djp3qLHpo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WmG5hHju; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DZvkMGtL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WmG5hHju; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DZvkMGtL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22F321FD95;
	Fri, 18 Oct 2024 06:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXzwlPFkcgwlpkHju4Sd2T8xIwl3ThYFl+oOkaTK9oA=;
	b=WmG5hHju+D85BM0oQGeSxZsh/RrU4wW3evRG7YJNAhupjwDY0/3+dFkBAbS6a1Ws7hQeNb
	mmG3Yy/iBU61bBDgnSUw+Hlpvo7MNUlObvfp6C295KuelPtU+mmGBZEaoqQJZQ7X6PO7Eq
	1yJI+raN5ZhSyfbN7ICf/4gMbuml47c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXzwlPFkcgwlpkHju4Sd2T8xIwl3ThYFl+oOkaTK9oA=;
	b=DZvkMGtLGOWIhpFDZEUwf8Vv8GLPmIT3fZL3UnW+ZzOx+L9TCI/3IICOQbnCwK+emH8l9C
	r5eZZWBz+FfU5VBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WmG5hHju;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DZvkMGtL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXzwlPFkcgwlpkHju4Sd2T8xIwl3ThYFl+oOkaTK9oA=;
	b=WmG5hHju+D85BM0oQGeSxZsh/RrU4wW3evRG7YJNAhupjwDY0/3+dFkBAbS6a1Ws7hQeNb
	mmG3Yy/iBU61bBDgnSUw+Hlpvo7MNUlObvfp6C295KuelPtU+mmGBZEaoqQJZQ7X6PO7Eq
	1yJI+raN5ZhSyfbN7ICf/4gMbuml47c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXzwlPFkcgwlpkHju4Sd2T8xIwl3ThYFl+oOkaTK9oA=;
	b=DZvkMGtLGOWIhpFDZEUwf8Vv8GLPmIT3fZL3UnW+ZzOx+L9TCI/3IICOQbnCwK+emH8l9C
	r5eZZWBz+FfU5VBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACD6413680;
	Fri, 18 Oct 2024 06:03:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o95aKD/6EWcIHQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 18 Oct 2024 06:03:43 +0000
Message-ID: <3a4c8e27-9d45-4f73-9440-252547a3fadf@suse.de>
Date: Fri, 18 Oct 2024 08:03:43 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 5/6] io_uring: enable per-io hinting capability
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
 Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-6-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241017160937.2283225-6-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 22F321FD95
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,samsung.com:email,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/17/24 18:09, Keith Busch wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
> all the subsequent writes on the file pass that hint value down. This
> can be limiting for block device as all the writes can be tagged with
> only one lifetime hint value. Concurrent writes (with different hint
> values) are hard to manage. Per-IO hinting solves that problem.
> 
> Allow userspace to pass additional metadata in the SQE.
> 
> 	__u16 write_hint;
> 
> This accepts all hint values that the file allows.
> 
> The write handlers (io_prep_rw, io_write) send the hint value to
> lower-layer using kiocb. This is good for upporting direct IO, but not
> when kiocb is not available (e.g., buffered IO).
> 
> When per-io hints are not passed, the per-inode hint values are set in
> the kiocb (as before). Otherwise, per-io hints  take the precedence over
> per-inode hints.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/uapi/linux/io_uring.h |  4 ++++
>   io_uring/rw.c                 | 11 +++++++++--
>   2 files changed, 13 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


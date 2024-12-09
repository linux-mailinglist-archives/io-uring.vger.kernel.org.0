Return-Path: <io-uring+bounces-5307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A82C69E8D70
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91EA7163EB6
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C4614A4CC;
	Mon,  9 Dec 2024 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LHDKWUng";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5ZxMqnzp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LHDKWUng";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5ZxMqnzp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D3112CDAE;
	Mon,  9 Dec 2024 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733080; cv=none; b=YG37RWTugDWyAuHw7+K+g8YFIhufX9i/b0ZsYmW2/GNDpPlKX3QnCrUvIx4KA1aPvMpcjHPKfaXR9kn0oyDLIyFl2OtNZPnu6bkR8x4Ww2pZUUchmq4TytnteCBdBY5BxTyYIhFw8gsFHQX2daQFIdkJ6IeQ8KPb57QHlLf/S2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733080; c=relaxed/simple;
	bh=gP9E9vhGauN21ggXPPvmu4ndSSJhDSY/QLoo7k7LKIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5PrGH/1pFhDemrtW+oQF0yM5hw8feHsxJoAkWcupHY368ZyVHJKUzLNVjS4Vyc/EaGXoBo6hvcXlZzq+QK3Q/SsfqnL6Zvp4FOWwx8aEbH0UfS5Pv1N4QFkY6+JCHnKTUDLboGOViBROh9kjkPfTm2wrwYSGFXumFNa4tIYd70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LHDKWUng; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5ZxMqnzp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LHDKWUng; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5ZxMqnzp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA495211B8;
	Mon,  9 Dec 2024 08:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecFxS/bnPGsNngQFtB/79KGUXtsUek/Qt1T2kNoz5bg=;
	b=LHDKWUngQ5BPC6UrogXTvvLxEatwqnExvNgu8LplW+RPYdDP2AF2193EUF0R+jbpQBY1jv
	l01kBEyO5En0ArSBOBq5urlh23CTS95rVc/QwmZ6CGeFbuWa9sNyeuZdcCwRvkU2ClIe3h
	cvP61eXe3huEEkfirCsp9CoaTB3X7VU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecFxS/bnPGsNngQFtB/79KGUXtsUek/Qt1T2kNoz5bg=;
	b=5ZxMqnzp9OVvfYWqYIfA9kIJK6t79zHBuMhoB8rA87l1xBrYx+IjpJH2YiCyO3BJoL9NLw
	TJC6JTTVqepz64Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LHDKWUng;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5ZxMqnzp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecFxS/bnPGsNngQFtB/79KGUXtsUek/Qt1T2kNoz5bg=;
	b=LHDKWUngQ5BPC6UrogXTvvLxEatwqnExvNgu8LplW+RPYdDP2AF2193EUF0R+jbpQBY1jv
	l01kBEyO5En0ArSBOBq5urlh23CTS95rVc/QwmZ6CGeFbuWa9sNyeuZdcCwRvkU2ClIe3h
	cvP61eXe3huEEkfirCsp9CoaTB3X7VU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecFxS/bnPGsNngQFtB/79KGUXtsUek/Qt1T2kNoz5bg=;
	b=5ZxMqnzp9OVvfYWqYIfA9kIJK6t79zHBuMhoB8rA87l1xBrYx+IjpJH2YiCyO3BJoL9NLw
	TJC6JTTVqepz64Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 338F613B18;
	Mon,  9 Dec 2024 08:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tqCrCtWqVmeJDgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:31:17 +0000
Message-ID: <8ca78f55-1758-4059-b542-41ad7c7db7a4@suse.de>
Date: Mon, 9 Dec 2024 09:31:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 07/12] io_uring: enable per-io write streams
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-8-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-8-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA495211B8
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Allow userspace to pass a per-I/O write stream in the SQE:
> 
>        __u8 write_stream;
> 
> The __u8 type matches the size the filesystems and block layer support.
> 
> Application can query the supported values from the statx
> max_write_streams field. Unsupported values are ignored by file
> operations that do not support write streams or rejected with an error
> by those that support them.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/uapi/linux/io_uring.h | 4 ++++
>   io_uring/io_uring.c           | 2 ++
>   io_uring/rw.c                 | 1 +
>   3 files changed, 7 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


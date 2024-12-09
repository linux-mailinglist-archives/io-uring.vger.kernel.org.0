Return-Path: <io-uring+bounces-5312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B9C9E8D90
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63017280F07
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8028512CDAE;
	Mon,  9 Dec 2024 08:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Olx8+tJU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="my/7kNub";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Olx8+tJU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="my/7kNub"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87214A4CC;
	Mon,  9 Dec 2024 08:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733274; cv=none; b=pT62LXbxSaU7NXm8CCajMeHh3O42GnrrCG1XFyt21iaQg6UgnnNT9tcccytJtccH10bFIxg3p6McnV18J/YUvIwIMFh8tMgSy7sEhKPAGTdS3p0xdIMsAVd9+ooV8DyJE7oYgBtSZJez/YNsKoS9aOE/PlDuMrXjgE3htSjHFmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733274; c=relaxed/simple;
	bh=VvDWbSCE7cM4b3GiARTJ7x5GpdKTF6hkZRBYXSsJmjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WjI3j6HMNaJymeSqlO6hdG8B7VkT09R1LgUOLgv1/dhTGmBALL/r0R7o47P5mEy7zJTlxpPZf8AcHtvAKNGpPVfm5Aidk2MoSr+FKsqPQ1RXcOTGm2jlNOaHdtbAxRs+2Wq/lDncfAsnQe7+tBkTY6D9Tnsy3hT3qLDV4WcDRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Olx8+tJU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=my/7kNub; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Olx8+tJU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=my/7kNub; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3016C211B3;
	Mon,  9 Dec 2024 08:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dj5x3mHt8FXGvvu975XdGMwQyh65AbA9IBqFMRubbQc=;
	b=Olx8+tJUNAoOXkjXPc8sr1zYHSRYlJ+vq3tOCni9iX/zX0vgcT0X+4dnJJQgv2cL++dmMx
	B6yruBpAs1DSh9ib6MNxipiA2lCXTgb9nVy0xZduIMnGdnjqsu8E3mJzSOwry0W0IlXy0R
	pjuNVmvmjqJ3GH5v5AqvHXjxLeD+KqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dj5x3mHt8FXGvvu975XdGMwQyh65AbA9IBqFMRubbQc=;
	b=my/7kNubhK8+hdoqWAeTf3UVwTSq1Ee5Rat8Icd9I8KoQWpC1kRuXFUg5ZMHHo3EqZHWH4
	kwST8O55zYwicvCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Olx8+tJU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="my/7kNub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dj5x3mHt8FXGvvu975XdGMwQyh65AbA9IBqFMRubbQc=;
	b=Olx8+tJUNAoOXkjXPc8sr1zYHSRYlJ+vq3tOCni9iX/zX0vgcT0X+4dnJJQgv2cL++dmMx
	B6yruBpAs1DSh9ib6MNxipiA2lCXTgb9nVy0xZduIMnGdnjqsu8E3mJzSOwry0W0IlXy0R
	pjuNVmvmjqJ3GH5v5AqvHXjxLeD+KqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dj5x3mHt8FXGvvu975XdGMwQyh65AbA9IBqFMRubbQc=;
	b=my/7kNubhK8+hdoqWAeTf3UVwTSq1Ee5Rat8Icd9I8KoQWpC1kRuXFUg5ZMHHo3EqZHWH4
	kwST8O55zYwicvCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEA9413B35;
	Mon,  9 Dec 2024 08:34:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GGEeKZarVmd3DwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:34:30 +0000
Message-ID: <a801e9e0-ff0f-43a6-915d-11190297ba37@suse.de>
Date: Mon, 9 Dec 2024 09:34:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 12/12] nvme: use fdp streams if write stream is
 provided
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-13-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-13-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3016C211B3
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On 12/6/24 23:18, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Maps a user requested write stream to an FDP placement ID if possible.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 32 +++++++++++++++++++++++++++++++-
>   drivers/nvme/host/nvme.h |  1 +
>   2 files changed, 32 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


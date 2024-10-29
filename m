Return-Path: <io-uring+bounces-4092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D39D69B42D4
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 08:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B52A71C210A0
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 07:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59837200BB7;
	Tue, 29 Oct 2024 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rP0HPVL8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Mq4EpQzi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rP0HPVL8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Mq4EpQzi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9395A8821;
	Tue, 29 Oct 2024 07:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730185820; cv=none; b=lekqG8DQZGJ4QHY+LML1NTxjhdJODYUDGdC9YjeyRq7HRFpu7srPQhSGXJhlpJYx23dfcoqjtgDA5GmfkiIpkJ6Y7GUPRn+HylNghQPBfQPWfGmZuriVj6r1x5UTpGQgUQnST6dmlhROw+Mw9P7bRT9skUOSCXbV30vntvSCrv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730185820; c=relaxed/simple;
	bh=GM8SwVn5bwtNv0nbmAxwmZTORJT73kBrM80HseA6IX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOSVUChWi0wc2AAGU5LjDhUl/EyQgl0gnJRQhImZSx6VwlpdtOOOStnZnTMOp4TmQ4yo2HkT+NoJ4e/uSGI7AbB4+hDcYAurGkDVUjkFtD8Rq6EoFeojDbpvUJRGVgp3Bf2USwOjaOYZPyaOojQlGYpVAco+2tMcb9QijFqaWJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rP0HPVL8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Mq4EpQzi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rP0HPVL8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Mq4EpQzi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2BC01FE41;
	Tue, 29 Oct 2024 07:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730185815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9XfqwrRteTneCnjhgeI86O38AxJQje6fZ6MqhejA+s=;
	b=rP0HPVL8jbXJ5HQq3HIYRygN5a9S75GUK2anEyhnEUBygoB31PsT3n/KI7r2GImgx/DuoC
	o5isNJMDiwPExsK2kFpyioxvsfK5SOzhGeshSaj3B0Vmm4LyMd10EP+ZYQ0NLmK3mG2ZVu
	RN3FXSkUcFtBtgWCMeo4XrSJ8jnj2u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730185815;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9XfqwrRteTneCnjhgeI86O38AxJQje6fZ6MqhejA+s=;
	b=Mq4EpQziMcMuD8h0m3qhHHiKcTVi4vP4nH/ECSVaevf2TxzG7Nf/gNTXbVY8MbYS5ib+Az
	as2x7vXvF865+bCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730185815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9XfqwrRteTneCnjhgeI86O38AxJQje6fZ6MqhejA+s=;
	b=rP0HPVL8jbXJ5HQq3HIYRygN5a9S75GUK2anEyhnEUBygoB31PsT3n/KI7r2GImgx/DuoC
	o5isNJMDiwPExsK2kFpyioxvsfK5SOzhGeshSaj3B0Vmm4LyMd10EP+ZYQ0NLmK3mG2ZVu
	RN3FXSkUcFtBtgWCMeo4XrSJ8jnj2u4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730185815;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9XfqwrRteTneCnjhgeI86O38AxJQje6fZ6MqhejA+s=;
	b=Mq4EpQziMcMuD8h0m3qhHHiKcTVi4vP4nH/ECSVaevf2TxzG7Nf/gNTXbVY8MbYS5ib+Az
	as2x7vXvF865+bCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3405B136A5;
	Tue, 29 Oct 2024 07:10:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eAZTCleKIGe2cgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Oct 2024 07:10:15 +0000
Message-ID: <c7a36219-bfe2-4be4-83ba-5af7f33b4a98@suse.de>
Date: Tue, 29 Oct 2024 08:10:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 7/7] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
 javier.gonz@samsung.com, bvanassche@acm.org, Keith Busch <kbusch@kernel.org>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-8-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241025213645.3464331-8-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.976];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 10/25/24 23:36, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The block limits exports the number of write hints, so set this limit if
> the device reports support for the lifetime hints. Not only does this
> inform the user of which hints are possible, it also allows scsi devices
> supporting the feature to utilize the full range through raw block
> device direct-io.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/scsi/sd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ca4bc0ac76adc..235dd6e5b6688 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3768,6 +3768,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   		sd_config_protection(sdkp, &lim);
>   	}
>   
> +	lim.max_write_hints = sdkp->permanent_stream_count;
> +
>   	/*
>   	 * We now have all cache related info, determine how we deal
>   	 * with flush requests.
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


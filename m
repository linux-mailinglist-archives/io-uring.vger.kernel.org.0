Return-Path: <io-uring+bounces-5435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADDE9ECAFF
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 12:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230D42868BE
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 11:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BBE2309A7;
	Wed, 11 Dec 2024 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WAvYLrox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xs02xlGX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WAvYLrox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xs02xlGX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F392210ED;
	Wed, 11 Dec 2024 11:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733916189; cv=none; b=TXf5xHyDjT8SDKH2AdSI6Jng70hDiYVk/t5ZVscuR26iiim/C6lfjb5Ih7UyVEal1nmvMCi4wsx+LrMAgU5wiYkqqS3UepQEgS/Ytr72ZKrXczmUiJLAY1lyghdFl71JrF9X6C2+4JZi8ZbBJcl6dznaKKja7paJyeZ2s6JMN6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733916189; c=relaxed/simple;
	bh=z2kEI0HDsxMJ8XaK1/cC8nVrYlPqpszVI84IQA3bx4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYuVzw/6pBQR6MCtf7Ltchmi8zs+yQgYUCjJTIkCmHBUUPdJehBw7ndaxqdxNUB03+sfGKihN63Oyv286y3DE5PFkDfZ8EQeS9CIv55NWXV3NkT6K7qe5fXFxh35T/3eg7CLZ2sZU5HQvCTX99XvnFLIsNywb59TGY4cXAT+jk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WAvYLrox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xs02xlGX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WAvYLrox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xs02xlGX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17C8521108;
	Wed, 11 Dec 2024 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733916186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnyySqDaqsMNdy15Z6UepiWBpe3bOImyGNWYxOLlQzE=;
	b=WAvYLrox8P0MVvhgbYZZg6iVtYLBMUx8Pmah8cwn3kICukGX8pQoXKy5+tbyLnN6XJUE2Q
	P3Zl1VoJXz3W14HU622GK72pQ42M5ArbdgcWlQiwJn1mplzp5NehL9aSYdRq7bCJ7PVYxZ
	B6DuBPkQ7UI78HSlvy6Fen+Mh88z8oI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733916186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnyySqDaqsMNdy15Z6UepiWBpe3bOImyGNWYxOLlQzE=;
	b=Xs02xlGXHITVQbEuO25tJwBR8p2Jl8osy2PAXaUp1uDZbGqgIEG8ac6QCcxRYIh+y+XY3P
	e6CL1QrcHVlGXFBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WAvYLrox;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Xs02xlGX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733916186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnyySqDaqsMNdy15Z6UepiWBpe3bOImyGNWYxOLlQzE=;
	b=WAvYLrox8P0MVvhgbYZZg6iVtYLBMUx8Pmah8cwn3kICukGX8pQoXKy5+tbyLnN6XJUE2Q
	P3Zl1VoJXz3W14HU622GK72pQ42M5ArbdgcWlQiwJn1mplzp5NehL9aSYdRq7bCJ7PVYxZ
	B6DuBPkQ7UI78HSlvy6Fen+Mh88z8oI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733916186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnyySqDaqsMNdy15Z6UepiWBpe3bOImyGNWYxOLlQzE=;
	b=Xs02xlGXHITVQbEuO25tJwBR8p2Jl8osy2PAXaUp1uDZbGqgIEG8ac6QCcxRYIh+y+XY3P
	e6CL1QrcHVlGXFBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E01AB13983;
	Wed, 11 Dec 2024 11:23:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T89GNhl2WWdRbwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 11 Dec 2024 11:23:05 +0000
Message-ID: <0ad3587f-8b3d-438c-b542-0daf48b04633@suse.de>
Date: Wed, 11 Dec 2024 12:23:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241210194722.1905732-1-kbusch@meta.com>
 <20241210194722.1905732-11-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241210194722.1905732-11-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17C8521108
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/10/24 20:47, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Register the device data placement limits if supported. This is just
> registering the limits with the block layer. Nothing beyond reporting
> these attributes is happening in this patch.
> 
> Merges parts from a patch by Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/linux-nvme/20241119121632.1225556-15-hch@lst.de/
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 139 +++++++++++++++++++++++++++++++++++++++
>   drivers/nvme/host/nvme.h |   2 +
>   2 files changed, 141 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index c2a3585a3fa59..f7aeda601fcd6 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -38,6 +38,8 @@ struct nvme_ns_info {
>   	u32 nsid;
>   	__le32 anagrpid;
>   	u8 pi_offset;
> +	u16 endgid;
> +	u64 runs;
>   	bool is_shared;
>   	bool is_readonly;
>   	bool is_ready;
> @@ -1613,6 +1615,7 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
>   	info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
>   	info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
>   	info->is_ready = true;
> +	info->endgid = le16_to_cpu(id->endgid);
>   	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
>   		dev_info(ctrl->device,
>   			 "Ignoring bogus Namespace Identifiers\n");
> @@ -1653,6 +1656,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvme_ctrl *ctrl,
>   		info->is_ready = id->nstat & NVME_NSTAT_NRDY;
>   		info->is_rotational = id->nsfeat & NVME_NS_ROTATIONAL;
>   		info->no_vwc = id->nsfeat & NVME_NS_VWC_NOT_PRESENT;
> +		info->endgid = le16_to_cpu(id->endgid);
>   	}
>   	kfree(id);
>   	return ret;
> @@ -2147,6 +2151,127 @@ static int nvme_update_ns_info_generic(struct nvme_ns *ns,
>   	return ret;
>   }
>   
> +static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
> +				      struct nvme_ns_info *info, u8 fdp_idx)
> +{
> +	struct nvme_fdp_config_log hdr, *h;
> +	struct nvme_fdp_config_desc *desc;
> +	size_t size = sizeof(hdr);
> +	int i, n, ret;
> +	void *log;
> +
> +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +			       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "FDP configs log header status:0x%x endgid:%x\n", ret,
> +			 info->endgid);
> +		return ret;
> +	}
> +
> +	size = le32_to_cpu(hdr.sze);

size should be bounded to avoid overly large memory allocations when the 
header is garbled.

> +	h = kzalloc(size, GFP_KERNEL);
> +	if (!h) {
> +		dev_warn(ctrl->device,
> +			 "failed to allocate %lu bytes for FDP config log\n",
> +			 size);
> +		return -ENOMEM;
> +	}
> +
> +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +			       NVME_CSI_NVM, h, size, 0, info->endgid);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "FDP configs log status:0x%x endgid:%x\n", ret,
> +			 info->endgid);
> +		goto out;
> +	}
> +
> +	n = le16_to_cpu(h->numfdpc) + 1;
> +	if (fdp_idx > n) {
> +		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
> +			 fdp_idx, n);
> +		/* Proceed without registering FDP streams */
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	log = h + 1;
> +	desc = log;
> +	for (i = 0; i < fdp_idx; i++) {
> +		log += le16_to_cpu(desc->dsze);
> +		desc = log;

Check for the size of 'h' to ensure that you are not
falling over the end ...


Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


Return-Path: <io-uring+bounces-5302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FC29E8D53
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2981D1884E64
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5D3215187;
	Mon,  9 Dec 2024 08:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NFhzLYAX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Zu2NKWEh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D0yOgNNS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NrJfCWKQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76AE1C2DA2;
	Mon,  9 Dec 2024 08:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732756; cv=none; b=pU1u9ps4GPeMx5nn1g48Eq1frFwKbNZa2fHYMkOC9HeQEhTN8gfXrLcmM4HvHNpoYG27S4MzpkiJSS4YubL2D58odqxM7ft5Arp8xajhLpYyhFe2KqfkeHqD9Ubk4zAyLpKVHqbOFdgdA/jepFnDIMddtu1Q2jllCDGekanCSBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732756; c=relaxed/simple;
	bh=viC3dmfHHI1MC3//q+FzkpK2uXwhCI20GHXfJn+cnLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sv8jPI05yrgNysK9Sl1Nk2Ek+kLJ2xsGVVXxPD8NI4zkxC/gMSlbkBr7lj/DyN7TINHpcZFIIqGv88jKD5r6mbZqM5uxM/ixDP2LxPesXmHM1gntM/UTHzbxujlWGw/sZyVKsI5wAh/WXiARyoMpl/+2CQSkn8GBDvIDJEjNR7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NFhzLYAX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Zu2NKWEh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D0yOgNNS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NrJfCWKQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9CBF81F456;
	Mon,  9 Dec 2024 08:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vm8qZWU8AOcY3cu3JeUyl+vbkkpG88RD+5WijpwV+H4=;
	b=NFhzLYAXv/UhwhnjlPtGt5Kgxr+fX3hSdQORDEIkjFMpkuQ8b65WP9WsV7TcLYT/JUi9xC
	DPG/ty2Q2/7LFQuRF61vajvnRN03p4TCquVQ+vpErAGYto9XihcXFtl2olC0+20sN6sOAa
	wYaevZ9XOUOvV0yVIxqp3WrKUdyZ4xI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vm8qZWU8AOcY3cu3JeUyl+vbkkpG88RD+5WijpwV+H4=;
	b=Zu2NKWEhPjlYH1v9Ivfsj21abnEIWPVU6mvlkwSi7HxleusUhsgJklEDay8dQtg2oEuoyg
	nnx+9gMcWozXtODQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D0yOgNNS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NrJfCWKQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vm8qZWU8AOcY3cu3JeUyl+vbkkpG88RD+5WijpwV+H4=;
	b=D0yOgNNS67k9xrj8gMCdu/knF2CUXY9KWSpXw2zCdplZ8yGEfsSkga/Q/WGctjkd9kRn11
	c3JzdZv7iHxD0HfA1I7/KVPnzzknSrVe9IOljtvUkxkHHf8iJZP/cu6NIGcazz3pDZ9c3H
	sIBQ6AnWWL7S3vUn6v5dFpo7l35NEIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vm8qZWU8AOcY3cu3JeUyl+vbkkpG88RD+5WijpwV+H4=;
	b=NrJfCWKQC4yXMEjCZ2r6yEVqsvt7+av26/q3b/Nz0X3Er7cLc5ZUFQ9Fg039RdONzLScp3
	9x2u+IXUrqM37VDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 362F8138D2;
	Mon,  9 Dec 2024 08:25:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZnxvC4+pVmeODAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:25:51 +0000
Message-ID: <17a0bc55-12bc-4d67-bcde-7761549fc434@suse.de>
Date: Mon, 9 Dec 2024 09:25:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 02/12] fs: add a write stream field to the kiocb
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-3-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CBF81F456
X-Spam-Level: 
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid,lst.de:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Prepare for io_uring passthrough of write streams. The write stream
> field in the kiocb structure fits into an existing 2-byte hole, so its
> size is not changed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/fs.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2cc3d45da7b01..26940c451f319 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -373,6 +373,7 @@ struct kiocb {
>   	void			*private;
>   	int			ki_flags;
>   	u16			ki_ioprio; /* See linux/ioprio.h */
> +	u8			ki_write_stream;
>   	union {
>   		/*
>   		 * Only used for async buffered reads, where it denotes the

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


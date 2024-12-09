Return-Path: <io-uring+bounces-5303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4009E8D56
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF37A163D2D
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4086D2156F3;
	Mon,  9 Dec 2024 08:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tlvkL7u5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BM5IquwJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tlvkL7u5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BM5IquwJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAE2156E2;
	Mon,  9 Dec 2024 08:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732818; cv=none; b=ZQL1SrMARXsrk2Jg8In6fYt2CydmkglDI3GY6EtLZYYhZIuyZ92s1MG0zMCNiyxmS6GbmFMYnAd/P+59coHt/YUC1AS2j83qTIhb8Qs9jWnx04WC2bIphHRzAoI7kCfuQqr0zWlaA67xM3HwB/wEuekSN8fi43tWhlSDi0uQjpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732818; c=relaxed/simple;
	bh=vXm4JX8pZw90uEYHQlB1/O9ck8PzKZfLGnnR9Edaw0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nuXLjBzScWq8kO2Mm2XK/dWqx15Rsq1q8+CT8TcfmNEjmXwUNebU9B7PmRw/lNZQaa4eT+ozHkjIoDuPQ5M49ColG9kVZWQ0e9eVxAx0Q6Pt/1mqED6/YkQVcAzvpVDDU838jAEERTsqb11VbP34HfAsjgL4UHbYEuVgFTR3T38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tlvkL7u5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BM5IquwJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tlvkL7u5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BM5IquwJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 98EB021160;
	Mon,  9 Dec 2024 08:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhaWdpfYyWqKrZIeB5sGAT5UpES883pFZ9Kk0WdmWcs=;
	b=tlvkL7u5uUUmgIfcqT9q4PLqUDm29O8tDj1cfTY5pnrPEPei4Idm9ldjW+ppL+iv9/28/L
	bbhwsPZAWh4KQeAoG2xC8ir1WrxibAaRMkx8qrKpS/IfqppfKTBVmby9xCGSjikNibicO5
	FmEo1eI7cfwECqPzgbPYDdgAiVSID7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhaWdpfYyWqKrZIeB5sGAT5UpES883pFZ9Kk0WdmWcs=;
	b=BM5IquwJu5j7yC8EDIrnEHmVJza3J7cKBu3SsuimQFbpesRu6mLEDa3YCrO18l1yph+/W6
	owyhXSKHkxvSO6CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733732814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhaWdpfYyWqKrZIeB5sGAT5UpES883pFZ9Kk0WdmWcs=;
	b=tlvkL7u5uUUmgIfcqT9q4PLqUDm29O8tDj1cfTY5pnrPEPei4Idm9ldjW+ppL+iv9/28/L
	bbhwsPZAWh4KQeAoG2xC8ir1WrxibAaRMkx8qrKpS/IfqppfKTBVmby9xCGSjikNibicO5
	FmEo1eI7cfwECqPzgbPYDdgAiVSID7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733732814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhaWdpfYyWqKrZIeB5sGAT5UpES883pFZ9Kk0WdmWcs=;
	b=BM5IquwJu5j7yC8EDIrnEHmVJza3J7cKBu3SsuimQFbpesRu6mLEDa3YCrO18l1yph+/W6
	owyhXSKHkxvSO6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26D04138D2;
	Mon,  9 Dec 2024 08:26:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4wLbBs6pVmf/DAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:26:54 +0000
Message-ID: <3cb409f1-cfc8-452b-b10b-a0755117bdab@suse.de>
Date: Mon, 9 Dec 2024 09:26:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 03/12] block: add a bi_write_stream field
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-4-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add the ability to pass a write stream for placement control in the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/bio.c                 | 2 ++
>   block/blk-crypto-fallback.c | 1 +
>   block/blk-merge.c           | 4 ++++
>   block/bounce.c              | 1 +
>   include/linux/blk_types.h   | 1 +
>   5 files changed, 9 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


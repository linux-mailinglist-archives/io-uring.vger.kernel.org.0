Return-Path: <io-uring+bounces-5310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F271A9E8D8A
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 299341882507
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04260215188;
	Mon,  9 Dec 2024 08:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MH83HXq0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JdLVv0Qd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MH83HXq0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JdLVv0Qd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43D21519F;
	Mon,  9 Dec 2024 08:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733214; cv=none; b=Ja9P6Q2tw9eehGs8kau0D3uavYgwl8Cdvg7wND2AW5c5Jp5hKfPldWL8Vw82KccvwCx/lhLrxNxQdq+SD4lYPpykibsheojp3EJCDVqvmivsyaB+OaeQ7KLU6/631YGgavX19RDRALJyEX80n2Qn4eOB+N45MLDMzSlsmi+7JyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733214; c=relaxed/simple;
	bh=KmMwyrO21ZZKFSRTpbXZzmyEHmjHHVaB3KoT7axoK1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHaVMhdWPa0HCeI/ERj95kTxwxGMIW+eLNYuwsbO8EuvBxVEulMOKlifkI/rieDrfWPTrG/mGjsgTAmR4MCt5DwUM+Uf50fCfT/xlQX1z67zWSSXwwRmI6/PXfMr7CNlRKkVEu5pdp1wQk8QI+sgmvspvRvmqN2lkX+MC3q6Tm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MH83HXq0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JdLVv0Qd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MH83HXq0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JdLVv0Qd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A69EB1F74A;
	Mon,  9 Dec 2024 08:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3eNA3hRD/YIW3yLrVH3YYj2NEgLCvcTYt7qLx7blmU=;
	b=MH83HXq02b+P3Y0PxvFwNdY/clxQfrqYU4WRgJf1NuSqH+BBmRGmfux+ZxLutYOtJ6a/bf
	ECkE5B1ckto9RYoihFucEFfS+ZvUFoFogHiwGm9LkCrBRZs28XwVjPx+zyBV0jJcywnJIR
	CMLvaaWb4CdZ2VyPnL37Zqj8o71oC3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3eNA3hRD/YIW3yLrVH3YYj2NEgLCvcTYt7qLx7blmU=;
	b=JdLVv0Qd+YY6QHLv8zYMj4b8IC5LZqspu8K9atO+2IoL65C+HagfG6Vf8Vc7gN0HASMGBl
	8tB8z4EWMT7jPUCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3eNA3hRD/YIW3yLrVH3YYj2NEgLCvcTYt7qLx7blmU=;
	b=MH83HXq02b+P3Y0PxvFwNdY/clxQfrqYU4WRgJf1NuSqH+BBmRGmfux+ZxLutYOtJ6a/bf
	ECkE5B1ckto9RYoihFucEFfS+ZvUFoFogHiwGm9LkCrBRZs28XwVjPx+zyBV0jJcywnJIR
	CMLvaaWb4CdZ2VyPnL37Zqj8o71oC3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3eNA3hRD/YIW3yLrVH3YYj2NEgLCvcTYt7qLx7blmU=;
	b=JdLVv0Qd+YY6QHLv8zYMj4b8IC5LZqspu8K9atO+2IoL65C+HagfG6Vf8Vc7gN0HASMGBl
	8tB8z4EWMT7jPUCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 369FB13B35;
	Mon,  9 Dec 2024 08:33:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FnGtC1urVmcuDwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:33:31 +0000
Message-ID: <35e86972-4fd8-45b0-9ec6-5dab9eda8ec1@suse.de>
Date: Mon, 9 Dec 2024 09:33:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 10/12] nvme.h: add FDP definitions
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-11-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-11-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:email,suse.de:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add the config feature result, config log page, and management receive
> commands needed for FDP.
> 
> Partially based on a patch from Kanchan Joshi <joshi.k@samsung.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [kbusch: renamed some fields to match spec]
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/nvme.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 77 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


Return-Path: <io-uring+bounces-5311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 400649E8D8E
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBF1628126A
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7661215077;
	Mon,  9 Dec 2024 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yU8IysRR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Gf+rWPV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yU8IysRR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Gf+rWPV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97712CDAE;
	Mon,  9 Dec 2024 08:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733250; cv=none; b=Ze7gb4Kp+SM58PJFldVQalxprClyLeukBeRJmaf4Z1SQERkSeAvxsqi0nRaMpT5uR1Uut6fCFyl7X4jVXSMYsjLLO17B+UKMuK0oSz/0Qt3oBJ0iWHIkoZk911MarWg0YJgPqZg/g+eiLkIZGuwHXSxwiKiuwb3lJ1ecGOwDVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733250; c=relaxed/simple;
	bh=Lj96Xxo6L7OqokPTUrnDSKgFNZE6NwC4Q/xJJ0dPyRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXF1OOwyXCjwRgbz5d7qoIPT6zM56gaKw4Zh6wYqMG08RDUxNTXSwfJfVjCoRen5CPkkdeQPpXT7ZpRhNGLP6iU0iV/R1TIYPVBaD1h4/EHj7T8IPCwVMjdNhV6YpM02UYucOVAsAf3Jjxq3cTkKDp2h4qOudcotnHSMvIwIU48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yU8IysRR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Gf+rWPV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yU8IysRR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Gf+rWPV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 599EA211B3;
	Mon,  9 Dec 2024 08:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q674GERQT/Yuga/kRSM/uZR0E043dDMBdq7o2ipN3/g=;
	b=yU8IysRRDrNsQNviAqJDz7bn/nSGk5kJrmYlmifsspn8wHNyfKI3G9PPoXUOtMwa/AVWis
	w0wvR0xx2xIFfnpL64svsn2ahQ3V/Ozibdq5aNMxcX3irokxLyS4S7vUrHLJ1ZMuUNhRWF
	A/nJ+KbP9uKoqdtijtujJ/jRNjua5jA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q674GERQT/Yuga/kRSM/uZR0E043dDMBdq7o2ipN3/g=;
	b=/Gf+rWPVfngHfLCW6R3c73r/5HvI23ufiau0WdWwoFTFNBprxSHdNFfvRDte0/8KoiBm4k
	C8j3JtbcB5uVbRDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q674GERQT/Yuga/kRSM/uZR0E043dDMBdq7o2ipN3/g=;
	b=yU8IysRRDrNsQNviAqJDz7bn/nSGk5kJrmYlmifsspn8wHNyfKI3G9PPoXUOtMwa/AVWis
	w0wvR0xx2xIFfnpL64svsn2ahQ3V/Ozibdq5aNMxcX3irokxLyS4S7vUrHLJ1ZMuUNhRWF
	A/nJ+KbP9uKoqdtijtujJ/jRNjua5jA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q674GERQT/Yuga/kRSM/uZR0E043dDMBdq7o2ipN3/g=;
	b=/Gf+rWPVfngHfLCW6R3c73r/5HvI23ufiau0WdWwoFTFNBprxSHdNFfvRDte0/8KoiBm4k
	C8j3JtbcB5uVbRDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E130313B38;
	Mon,  9 Dec 2024 08:34:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i2RdNX6rVmdfDwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:34:06 +0000
Message-ID: <cd388aa1-32e6-4427-958e-041f7d6a73ac@suse.de>
Date: Mon, 9 Dec 2024 09:34:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 11/12] nvme: register fdp parameters with the block
 layer
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-12-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-12-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 12/6/24 23:18, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Register the device data placement limits if supported. This is just
> registering the limits with the block layer. Nothing beyond reporting
> these attributes is happening in this patch.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 112 +++++++++++++++++++++++++++++++++++++++
>   drivers/nvme/host/nvme.h |   4 ++
>   2 files changed, 116 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


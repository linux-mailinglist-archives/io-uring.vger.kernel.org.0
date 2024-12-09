Return-Path: <io-uring+bounces-5308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB56D9E8D74
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6FFE281269
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938521C0DED;
	Mon,  9 Dec 2024 08:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DyeU2wEr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X9WJwQRq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DyeU2wEr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="X9WJwQRq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C3D12CDAE;
	Mon,  9 Dec 2024 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733108; cv=none; b=fPwjrF9UPd5cRh2WSjzL/ncHMqphOELquSznNWae1P+2MRJLpLZQtS24WVra6yaNPPmaVmrnxFqjbGgqlk39WYrGC8FXtFJ+xmr+uhQW3q0GJK04FzEXD3HaJPbH304+GdnCSE69KpjUB7MLmgkwQCYPHpA9uuCBY1PpZWfvL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733108; c=relaxed/simple;
	bh=b37xeSZ4m5gYscW1+EOsk2tkvuLiLM6ug8sd6Pob/JI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUcrA5+VmmDajpDhc34298WCKudeE1a8VM4qDYVmkaT3MA1dK6hMX1DLvZDMD18UEGnknePQChz72Rrnvf2hMJLRk+KEclQi4RuPYIpjNKVTB/lPb+YWJSHmBr40VL9ghLLStMk4azUTKxz8xKxcVEqWoAqDjmDwLwlhv0+E2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DyeU2wEr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X9WJwQRq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DyeU2wEr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=X9WJwQRq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1167B2117D;
	Mon,  9 Dec 2024 08:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XciBx5JQqOy8otQtfbjtsWC7snD6BVW72v5a25fVgp4=;
	b=DyeU2wEryp63rF62eUTqW/HlvDON+aqSji/SQHCgKRVDYeNZYhwK+dMaG7Yychdv0f4b04
	1zKeSnuyTSDSTazoWW2GPTWHYpR7TYwmSK1gh54AH/UVv1F+ySTjPcmWp/iHgmF3MnBVgO
	XkLbf1ucsU0b3d+cEmX4Mjy3CCFkr0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XciBx5JQqOy8otQtfbjtsWC7snD6BVW72v5a25fVgp4=;
	b=X9WJwQRqWK6IGXu/aurAuhRS9Ft05Ixn056HzofdK752M1cHHuTHOOMJVHTzaJf11ywNYg
	Lnv2gpzXeWs7aFDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XciBx5JQqOy8otQtfbjtsWC7snD6BVW72v5a25fVgp4=;
	b=DyeU2wEryp63rF62eUTqW/HlvDON+aqSji/SQHCgKRVDYeNZYhwK+dMaG7Yychdv0f4b04
	1zKeSnuyTSDSTazoWW2GPTWHYpR7TYwmSK1gh54AH/UVv1F+ySTjPcmWp/iHgmF3MnBVgO
	XkLbf1ucsU0b3d+cEmX4Mjy3CCFkr0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XciBx5JQqOy8otQtfbjtsWC7snD6BVW72v5a25fVgp4=;
	b=X9WJwQRqWK6IGXu/aurAuhRS9Ft05Ixn056HzofdK752M1cHHuTHOOMJVHTzaJf11ywNYg
	Lnv2gpzXeWs7aFDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC9D613B24;
	Mon,  9 Dec 2024 08:31:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EaSGKPCqVmevDgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:31:44 +0000
Message-ID: <1d954d51-6662-46c4-a773-b4bce4cf304d@suse.de>
Date: Mon, 9 Dec 2024 09:31:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 08/12] nvme: add a nvme_get_log_lsi helper
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-9-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-9-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> For log pages that need to pass in a LSI value, while at the same time
> not touching all the existing nvme_get_log callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


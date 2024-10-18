Return-Path: <io-uring+bounces-3807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A76D9A3506
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 08:02:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB7DEB242D3
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 06:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DEE14B941;
	Fri, 18 Oct 2024 06:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="srfCAdV5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wgx3cIE0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="srfCAdV5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wgx3cIE0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C5420E30C;
	Fri, 18 Oct 2024 06:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231313; cv=none; b=fX0LaP39Nw3V2M9c4bC7IfZ2dOGbkbq2F4RH8JVBNaZA2Sr5y3nXYgkeZuB4eR6wW+yJVTCFY3ftoJS2Zzdp/ghLhcjktaekw2Wm9nHrkMkuaP4z3n69HOXPQC2TxEB3lWvYYrjeQMQKJmUoaGc3M7j3sMPwKv/v5bO+jsjlZl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231313; c=relaxed/simple;
	bh=BTEVbikKY66kI6F/lY+akyg9dmv3qCM1gbOidMmjEus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SgBH/BFO3dlLGMON44EMTMbKfmrxjD6ZiHS87bCVUEJfhYD8zArDlJRQ3tSWWorZDAtLVPxqds3FqYxCOsLHUvrgi2p0JFGJ2mAuRlb2hXcTN0WeoTQ87Em1H17wlHEhNZOFixrgzKt/7lmZn9e9hrJS0YnJd2bH6pUZM61JMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=srfCAdV5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wgx3cIE0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=srfCAdV5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wgx3cIE0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F21BB1FD95;
	Fri, 18 Oct 2024 06:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRbyrh0emkn3PCn7Sp6Y+fmB2AWP1Y6F5J5cmvTafCo=;
	b=srfCAdV5596BQwIfyBC2Rit9YPCLT1PxObrkQw/2/GDfL00m+Vq21QbVn7qPRRQ9Jc5jz0
	DeNu+f4ilo6kzcxbUQEICzMnAlnzIlEQaTk+yM1E2eRAuZr9o9TP0zpKyTymXSbrvyP7DQ
	DY5kifjafBKWXG2XREzhv3jAFnPPgcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231310;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRbyrh0emkn3PCn7Sp6Y+fmB2AWP1Y6F5J5cmvTafCo=;
	b=wgx3cIE0+5mwOO5Jl8A4NDjWb6rhFq5GK3D14td4Vj0UP4qnTEjJF+WHF3cv+pRSNH2Lle
	5nRYRNgwJguiRXAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRbyrh0emkn3PCn7Sp6Y+fmB2AWP1Y6F5J5cmvTafCo=;
	b=srfCAdV5596BQwIfyBC2Rit9YPCLT1PxObrkQw/2/GDfL00m+Vq21QbVn7qPRRQ9Jc5jz0
	DeNu+f4ilo6kzcxbUQEICzMnAlnzIlEQaTk+yM1E2eRAuZr9o9TP0zpKyTymXSbrvyP7DQ
	DY5kifjafBKWXG2XREzhv3jAFnPPgcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231310;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRbyrh0emkn3PCn7Sp6Y+fmB2AWP1Y6F5J5cmvTafCo=;
	b=wgx3cIE0+5mwOO5Jl8A4NDjWb6rhFq5GK3D14td4Vj0UP4qnTEjJF+WHF3cv+pRSNH2Lle
	5nRYRNgwJguiRXAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9667413680;
	Fri, 18 Oct 2024 06:01:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 718lI835EWeWHAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 18 Oct 2024 06:01:49 +0000
Message-ID: <92c52cda-3075-4aff-ab91-9cf6206522b8@suse.de>
Date: Fri, 18 Oct 2024 08:01:49 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 3/6] block: introduce max_write_hints queue limit
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-4-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241017160937.2283225-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 10/17/24 18:09, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Drivers with hardware that support write hints need a way to export how
> many are available so applications can generically query this.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   Documentation/ABI/stable/sysfs-block |  7 +++++++
>   block/blk-settings.c                 |  3 +++
>   block/blk-sysfs.c                    |  3 +++
>   block/fops.c                         |  2 ++
>   include/linux/blkdev.h               | 12 ++++++++++++
>   5 files changed, 27 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


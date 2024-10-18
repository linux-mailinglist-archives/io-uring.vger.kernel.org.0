Return-Path: <io-uring+bounces-3806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F5A9A34FD
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 08:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 590641C21093
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 06:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80FF17BB34;
	Fri, 18 Oct 2024 06:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q3fIyHMw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DiH4oTCv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q3fIyHMw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DiH4oTCv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4C17C208;
	Fri, 18 Oct 2024 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231236; cv=none; b=QiDCnGrx1HAGAbb9nT3Rph3L0hZSTYyYfBdbx8pd98IbpOKoZFQ1yXOe6+0tVoUEc/kJK6KJsD4Dv3FeWBaEJw57vU9GQHotXeC7LGWHapaW/cgDWtPPTvrRRRZbtBA+TV4DtDaUbMI/CLpNhRGALJMqrcxdadiU9R/kAFIfkD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231236; c=relaxed/simple;
	bh=waacE1aNzly4Zeegu4vMR/kx+Om1s2GEvbc+aKtV0lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3bYwD+GNg6ntl9pzAN76pFm7YDhi3BGdAI4YAUVLIa2IhNMPms9+3A4xbKJn+pil2a0AMV3sWnGZiZJ0RQxQaHWoZwpl8d4f/HVfdbuylvqZqTgKFgUQmgFAJdqYOm+gMNhhm+v1B6uLBmalokF3EPHFRkZIivu+MZ3OREVGrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q3fIyHMw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DiH4oTCv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q3fIyHMw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DiH4oTCv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0F4D121CAE;
	Fri, 18 Oct 2024 06:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+oslvyFtthRvpncpsf7JPay8w219Y8jbNyo3l4F2C4=;
	b=q3fIyHMw/HUWzunQLYMGZmQt0iNaciSFjoWsqVK4tilkPJ5I3aEJWqDi5LtWz64QKvrVwS
	g7mP+/u0aE5uiYSkNQ8CxnJ1915M8Y2Y3Je13XUDFPTbtGV5e+jv+CwZvNhRl3jtwXrTG5
	1+QYbHiU63y6m6/jn9AFFN2EsmwfhXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+oslvyFtthRvpncpsf7JPay8w219Y8jbNyo3l4F2C4=;
	b=DiH4oTCviugsvt9iGnPCXUdMSQfFGxO+2Kjw870TbAbKpBh23whYE6HopAWVYU1kpkJkcS
	YV6T9fPi+ZQqdMAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q3fIyHMw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DiH4oTCv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+oslvyFtthRvpncpsf7JPay8w219Y8jbNyo3l4F2C4=;
	b=q3fIyHMw/HUWzunQLYMGZmQt0iNaciSFjoWsqVK4tilkPJ5I3aEJWqDi5LtWz64QKvrVwS
	g7mP+/u0aE5uiYSkNQ8CxnJ1915M8Y2Y3Je13XUDFPTbtGV5e+jv+CwZvNhRl3jtwXrTG5
	1+QYbHiU63y6m6/jn9AFFN2EsmwfhXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+oslvyFtthRvpncpsf7JPay8w219Y8jbNyo3l4F2C4=;
	b=DiH4oTCviugsvt9iGnPCXUdMSQfFGxO+2Kjw870TbAbKpBh23whYE6HopAWVYU1kpkJkcS
	YV6T9fPi+ZQqdMAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F8E613680;
	Fri, 18 Oct 2024 06:00:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bYtPJX/5EWcmHAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 18 Oct 2024 06:00:31 +0000
Message-ID: <658d5b7a-7bdc-4642-b683-58965d3e791d@suse.de>
Date: Fri, 18 Oct 2024 08:00:31 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 2/6] block: use generic u16 for write hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-3-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241017160937.2283225-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F4D121CAE
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/17/24 18:09, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is still backwards compatible with lifetime hints. It just doesn't
> constrain the hints to that definition.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/blk-mq.h    | 3 +--
>   include/linux/blk_types.h | 2 +-
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


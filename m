Return-Path: <io-uring+bounces-3808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B16329A350C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 08:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FB2C2822FE
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 06:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA20A17B439;
	Fri, 18 Oct 2024 06:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wA7LwORP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+iSKMZb/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wA7LwORP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+iSKMZb/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CB917A5A4;
	Fri, 18 Oct 2024 06:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729231390; cv=none; b=p5q6aCbC5KxqJIhQnSdryy6GnMEtDHppypHkVld8k8WxAKuA8BLFrcoCnfoyAxORTTalzV0H+GaG2zIIPpPXnj4E6uBaxc6uXTtpXNcRqGLPUSgwDwszwE5jWkT53em7l9eqqBPS5BPHjplJ7A9Sk6M5YeKDtKaZoj0NBmhheMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729231390; c=relaxed/simple;
	bh=x46FoN+/A230ZE9NyX7OFa8WHS0MPQS5mDM5pJQCEEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PyJaPviREGcRidIiMWgbWnz8TCw60rS8/FcSWXJZrZpaVz4xpRRJjWRLvNvnCAyp68IG2DfyCyES6shXVlAwix5DofRw5CT0ouX2tBNB763m/s4CbHVlqlgjd0aiLKZZ+/c50DrtNlxgXCkTHmLE6xLflmvfrbPYNvnV4+cnG8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wA7LwORP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+iSKMZb/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wA7LwORP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+iSKMZb/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21FA71FD95;
	Fri, 18 Oct 2024 06:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxjZYDm5Sal3TUEKTCPWe6UuJfYo/CaIotpuIZcHjQc=;
	b=wA7LwORPmt0YgtSGCykW67fZojpam67J/6r+9UIEHG2+3xlQSog7YgGtA64FlF1LiV36XI
	NXcycda+B/SAhfSnO09qo+aAA+CoiM8gvvVWHc/ZPbacWSaa8wU6F3fIYwAZY6MWkc0T9M
	rfFqEwLTYsiTj9Vp9CUOXVIheKuVopk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxjZYDm5Sal3TUEKTCPWe6UuJfYo/CaIotpuIZcHjQc=;
	b=+iSKMZb/oOFPIihIhNGIyIFKAxbonL2mvNTkQufH/7pfDCufmtUkA+tUOBw+4qaWBRP7Y5
	SdqR9SljN+g2SKCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wA7LwORP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="+iSKMZb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729231387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxjZYDm5Sal3TUEKTCPWe6UuJfYo/CaIotpuIZcHjQc=;
	b=wA7LwORPmt0YgtSGCykW67fZojpam67J/6r+9UIEHG2+3xlQSog7YgGtA64FlF1LiV36XI
	NXcycda+B/SAhfSnO09qo+aAA+CoiM8gvvVWHc/ZPbacWSaa8wU6F3fIYwAZY6MWkc0T9M
	rfFqEwLTYsiTj9Vp9CUOXVIheKuVopk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729231387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WxjZYDm5Sal3TUEKTCPWe6UuJfYo/CaIotpuIZcHjQc=;
	b=+iSKMZb/oOFPIihIhNGIyIFKAxbonL2mvNTkQufH/7pfDCufmtUkA+tUOBw+4qaWBRP7Y5
	SdqR9SljN+g2SKCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B229C13680;
	Fri, 18 Oct 2024 06:03:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z/nRKRr6EWfeHAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 18 Oct 2024 06:03:06 +0000
Message-ID: <a56e6324-ea8c-488e-85b5-28c77d2d326d@suse.de>
Date: Fri, 18 Oct 2024 08:03:06 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 4/6] fs: introduce per-io hint support flag
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-5-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241017160937.2283225-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21FA71FD95
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 10/17/24 18:09, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A block device may support write hints on a per-io basis. The raw block
> file operations can effectively use these, but real filesystems are not
> ready to make use of this. Provide a file_operations flag to indicate
> support, and set it for the block file operations.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/fops.c       | 2 +-
>   include/linux/fs.h | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


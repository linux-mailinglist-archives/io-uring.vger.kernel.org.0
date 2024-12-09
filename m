Return-Path: <io-uring+bounces-5306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED169E8D69
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 09:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11DDB188538E
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 08:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B12C136357;
	Mon,  9 Dec 2024 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NUquCVYS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="On7iiMl4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NUquCVYS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="On7iiMl4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBF122C6E8;
	Mon,  9 Dec 2024 08:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733043; cv=none; b=SYWe5Fps999OxgyvKDYPfmEGAdgW26KgXXIS/QIZPcGcRIryC0tjKpFNaB5e4SmfSOmqJAs3CYFkOULaQMgel9McCPbhsqUzkYlk82HVPtJ9wZ+g0eRzy9BBL9xRjN2So/DbXM2O/uNmuJFOtEA16flojpfyTtJSGsq73fbJs4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733043; c=relaxed/simple;
	bh=NFcRUC8+MSvyGqAva1FTu1X67G2uJOuqBGs6LqmMSc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ho9VJw57JtEgkEA3jFSvjZN4Q/kbeXvpGF2bfbLlbs6U402SeS06efq83wbvpX3vFcP+rtavloTjq3mie0ym9BDGfKVdWUXCA2UCmzQb1ibnnRBOYOhTZgRP9kPNxqyrkP1Ne2VNS4FgO2NWhLFlWiweefFqAeTSG0t+JkUcO8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NUquCVYS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=On7iiMl4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NUquCVYS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=On7iiMl4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B6666211B1;
	Mon,  9 Dec 2024 08:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKJvD79VdhLBsaQqLM8iMQtAhruR+9b3JIxtKWIyneo=;
	b=NUquCVYSmI9qe2DLJRsp37faxcpG0yt3nNI/AQIudSVngDPvLX2ElYXYbIAej/higs2e7S
	Y7uUYmPzVeLOVrOvT1+ohNmCaaTuFiLEuX8L3aaSCyztbbKAUhT6JpLVxCwp4pG2RUsIlX
	LyRIvH2VeGQGWY+NxF2orO+jheTr9Co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKJvD79VdhLBsaQqLM8iMQtAhruR+9b3JIxtKWIyneo=;
	b=On7iiMl4WqkGbBIT6EJS4lxtfC9x07G49VPmAiDlAbN5iqFlRgDYCXRXFK7cLC/sDfCCCT
	GbEFvaJg8NCvYDDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NUquCVYS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=On7iiMl4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733733039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKJvD79VdhLBsaQqLM8iMQtAhruR+9b3JIxtKWIyneo=;
	b=NUquCVYSmI9qe2DLJRsp37faxcpG0yt3nNI/AQIudSVngDPvLX2ElYXYbIAej/higs2e7S
	Y7uUYmPzVeLOVrOvT1+ohNmCaaTuFiLEuX8L3aaSCyztbbKAUhT6JpLVxCwp4pG2RUsIlX
	LyRIvH2VeGQGWY+NxF2orO+jheTr9Co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733733039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKJvD79VdhLBsaQqLM8iMQtAhruR+9b3JIxtKWIyneo=;
	b=On7iiMl4WqkGbBIT6EJS4lxtfC9x07G49VPmAiDlAbN5iqFlRgDYCXRXFK7cLC/sDfCCCT
	GbEFvaJg8NCvYDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F1D713B08;
	Mon,  9 Dec 2024 08:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rUKUEa+qVmdVDgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Dec 2024 08:30:39 +0000
Message-ID: <e5949ceb-02d8-42a5-a3b9-ac04ed407f25@suse.de>
Date: Mon, 9 Dec 2024 09:30:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv12 06/12] block: expose write streams for block device
 nodes
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-7-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241206221801.790690-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6666211B1
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
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
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/6/24 23:17, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Export statx information about the number and granularity of write
> streams, use the per-kiocb write hint and map temperature hints
> to write streams (which is a bit questionable, but this shows how it is
> done).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/bdev.c |  6 ++++++
>   block/fops.c | 23 +++++++++++++++++++++++
>   2 files changed, 29 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


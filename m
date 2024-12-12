Return-Path: <io-uring+bounces-5462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D272A9EE78F
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 14:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6E21188891C
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 13:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFC5209F5F;
	Thu, 12 Dec 2024 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gtWBHBP+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kwzDA7ab";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gtWBHBP+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kwzDA7ab"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6A0213E84;
	Thu, 12 Dec 2024 13:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734009256; cv=none; b=C3+OhEo1tOAEsGQu2bNzdoEvJQag17sHO48AvC3grNiY9HoShyFvBMpje0YC0r+4lmcyiEujDZTTU9r0jXPlV/k+L1tiePyABJRedSlvSdr45dazMIB3nHc+xrGDeMc0XARVyyPu7K/a1xVYMjJXyNK/MKI7sxEKL+lg2R9CMQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734009256; c=relaxed/simple;
	bh=VdsrmDh/jsl2Cx7SgccfTdErXAO6t50Y02RJzT/pqbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eih2NZHViVR7/Mo7tXuxWNUwxI0UNpvaG1j5B9r7UWOMCQPn85YGwoMVg96o1tdfYkblx+lnXhrMLXEw+rkZ0tk79T10Sby66miE2xyoGjG7ZxYyyDn/uhd4IdcWrG3msP6GocmyrwdNr2hs/LlzKnC4pm5757dUXBIw6SBzdlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gtWBHBP+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kwzDA7ab; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gtWBHBP+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kwzDA7ab; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B7BF1F383;
	Thu, 12 Dec 2024 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734009252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvKJQCY4UAGhGZ5rWD6wzbX/j5iNZb8I49LUPn4nhpY=;
	b=gtWBHBP+YtqrUAN3iawUKFdx0R9yJ0QDJ3JxPhvdy19qazHC2MmwZDzXsu5jWgKXOUN2Mw
	tpAQdQiBdVqqhat8HZbstu01mU1SB982ml2xxS69csoaOHr99Yb0ovhPT23C1PBOCgITrJ
	ZT7cp0a6GTq8zl7abbk5tf+5uV7N2xI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734009252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvKJQCY4UAGhGZ5rWD6wzbX/j5iNZb8I49LUPn4nhpY=;
	b=kwzDA7ab2xM2vAay11d3F+S8hk7ft4K1IePIdVEv67PGeCoGEgC3uXNlCjPpR2gQiqbT5H
	om4zqWXEs3X2kiAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gtWBHBP+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kwzDA7ab
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734009252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvKJQCY4UAGhGZ5rWD6wzbX/j5iNZb8I49LUPn4nhpY=;
	b=gtWBHBP+YtqrUAN3iawUKFdx0R9yJ0QDJ3JxPhvdy19qazHC2MmwZDzXsu5jWgKXOUN2Mw
	tpAQdQiBdVqqhat8HZbstu01mU1SB982ml2xxS69csoaOHr99Yb0ovhPT23C1PBOCgITrJ
	ZT7cp0a6GTq8zl7abbk5tf+5uV7N2xI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734009252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvKJQCY4UAGhGZ5rWD6wzbX/j5iNZb8I49LUPn4nhpY=;
	b=kwzDA7ab2xM2vAay11d3F+S8hk7ft4K1IePIdVEv67PGeCoGEgC3uXNlCjPpR2gQiqbT5H
	om4zqWXEs3X2kiAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F04713508;
	Thu, 12 Dec 2024 13:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h63/CqThWmeGVwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 12 Dec 2024 13:14:12 +0000
Message-ID: <b796253f-73f3-4a05-ad88-1fb118e0171f@suse.de>
Date: Thu, 12 Dec 2024 14:14:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv14 10/11] nvme: register fdp parameters with the block
 layer
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
 joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241211183514.64070-1-kbusch@meta.com>
 <20241211183514.64070-11-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241211183514.64070-11-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B7BF1F383
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[grimberg.me,gmail.com,samsung.com,kernel.org];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 12/11/24 19:35, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Register the device data placement limits if supported. This is just
> registering the limits with the block layer. Nothing beyond reporting
> these attributes is happening in this patch.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/nvme/host/core.c | 145 +++++++++++++++++++++++++++++++++++++++
>   drivers/nvme/host/nvme.h |   2 +
>   2 files changed, 147 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


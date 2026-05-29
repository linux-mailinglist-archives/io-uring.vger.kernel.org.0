Return-Path: <io-uring+bounces-13558-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO5mMF8vGWrmsAgAu9opvQ
	(envelope-from <io-uring+bounces-13558-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:17:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9B65FDD11
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 492163047C90
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 06:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735193A7586;
	Fri, 29 May 2026 06:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qfb4o4xO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55Xr3bsa";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qfb4o4xO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="55Xr3bsa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2331F3A4F26
	for <io-uring@vger.kernel.org>; Fri, 29 May 2026 06:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035384; cv=none; b=NhkMa7npSqj/zv1tgi0MC5LkiZ3kT1eoVvADbbWRIa0JTdTsRgNQy35pVoZpl/2/8fwDmP8Jhf8+RU3jQBRS4Y8WPh5sCF9vXYFcj9smfAFOXH852Ru29jth8SPo66qDWw4C2nxhOYL1rUBVQlozFP79WnIXJI/3oNSS1ZuM5rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035384; c=relaxed/simple;
	bh=a/p6mC0VGmPi6Fagw1ram42LV4IrVQ5DjVDWjEDRfxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UbpCYaXz0pbl1Wwfu0iKHhHBMhp3cziUss4MpZF1iIall+bbhL7EdhFCnzJwlVBSDKzaTNMEk6q6Tm84e06BGh7hd0RG4rVelpBd3V3kHn1oKsMe7Y3IGEuuDYpFrtJfHc7k3thvB/XRVhNQIwm8R/ziMzCmfUogtvGyz3Lgk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qfb4o4xO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55Xr3bsa; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qfb4o4xO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=55Xr3bsa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37B4267235;
	Fri, 29 May 2026 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=Qfb4o4xO+07ViaKys2o47r7MyhBBn7VCldgc9aQMA42RDxzWNTpNhgKGMNEgnYu8lXaIdo
	YGegcOh6sqXcjlRR/2FPXVCtdmJyS50aFeGNBATUIr78i4YycGZMuUnTX8Cf4IkTAA7/e7
	fcgvXf4f6pnlidprw+PAtvlYWhOAO2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=55Xr3bsauaj3J+QpR1BRYMOqu6SWpjBvG17MEHVnmQEd6/NwhnVm19X4Em4G9FdR9o2rGj
	PNd6mlV+kKrMNqBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=Qfb4o4xO+07ViaKys2o47r7MyhBBn7VCldgc9aQMA42RDxzWNTpNhgKGMNEgnYu8lXaIdo
	YGegcOh6sqXcjlRR/2FPXVCtdmJyS50aFeGNBATUIr78i4YycGZMuUnTX8Cf4IkTAA7/e7
	fcgvXf4f6pnlidprw+PAtvlYWhOAO2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=55Xr3bsauaj3J+QpR1BRYMOqu6SWpjBvG17MEHVnmQEd6/NwhnVm19X4Em4G9FdR9o2rGj
	PNd6mlV+kKrMNqBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F097D5B1C4;
	Fri, 29 May 2026 06:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gzPiODMvGWpfEwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 29 May 2026 06:16:19 +0000
Message-ID: <36673080-f216-4c85-a9f6-ad9395dbd56e@suse.de>
Date: Fri, 29 May 2026 08:16:19 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] block: Add bvec_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-2-willy@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528175905.1102280-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13558-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hare@suse.de,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,suse.de:email,suse.de:mid,suse.de:dkim]
X-Rspamd-Queue-Id: 6B9B65FDD11
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/28/26 19:59, Matthew Wilcox (Oracle) wrote:
> This is a simple helper which replaces page_folio(bvec->bv_page).
> Minor improvement in readability, but the real motivation is to reduce
> the number of references to bvec->bv_page so that it can be changed
> with less work.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> ---
>   block/bio.c          |  6 +++---
>   include/linux/bio.h  |  2 +-
>   include/linux/bvec.h | 15 +++++++++++++++
>   io_uring/rsrc.c      |  2 +-
>   mm/page_io.c         |  4 ++--
>   5 files changed, 22 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


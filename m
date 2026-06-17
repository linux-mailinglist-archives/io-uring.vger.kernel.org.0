Return-Path: <io-uring+bounces-13772-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id QxJWD1rrMmqg7gUAu9opvQ
	(envelope-from <io-uring+bounces-13772-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 20:45:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3A169BFDB
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 20:45:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1xw8jzqu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7HtMHfbG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1xw8jzqu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7HtMHfbG;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13772-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13772-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 371BD3006930
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 18:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DF23783D5;
	Wed, 17 Jun 2026 18:45:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0AB365A14
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 18:45:39 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781721940; cv=none; b=rROJgczAuLQprJHVguSx25FhWqeTZ2PYXoz+H+Kv4zlAab7pkWMxRjXJ6kBSL+y+w+2SqWMWDyFJRZGrzzMn+oFZLymezii+OTBz6lNjF/6Q1uPDkeShIi38sq+TEruU23xALR0ITNVfMOlRVL+mK1SbCzF5UsvmujleRTIHeLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781721940; c=relaxed/simple;
	bh=5ga8iWH6X69BV6Yr7e0iCV3Uo3gvt9E9GtJdSIMn++A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oOncIjY5G9xQ00Nxxd1QIOJelqRHkhofVDl+BGOKKAnXM6M6+91OSWumaLytmjcrn16euRuYwLYhp8lpriBmeEh4IuIYeYm8qg3YjnYUG+pTuJ8VTmhiHZvnB013Q24dEHfnuHSkRuU8K9THZEEx7S88FWoq028U28M+fFS1TGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1xw8jzqu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7HtMHfbG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1xw8jzqu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7HtMHfbG; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D90B56C26D;
	Wed, 17 Jun 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781721937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9H3rBRsjIb5KWdXoxyNRNBq8YTHLtH5ARZMf5xlOmMI=;
	b=1xw8jzqu4+bVnQ8K6GBXj/tg7qicXbrS8TFHQEI44q76nip6OGm7/dHRx+D5rnjjKLQkND
	7zmo5pRwprrtCZ20j089+BJZ4tSYVDeV5tF7gUXc6LH7dvCH1nWKmSJAV29HTmk14kDYyA
	yiMwgF3VzXw4IW1IlPq7kBw8SJ3GRaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781721937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9H3rBRsjIb5KWdXoxyNRNBq8YTHLtH5ARZMf5xlOmMI=;
	b=7HtMHfbGhU0GaKKpqVR/YmGmMr2eYKjjQAVXhPQky5r7RRfvpLOeHrC6IGnHOggintays5
	51rFA0RhWk9k+sBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781721937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9H3rBRsjIb5KWdXoxyNRNBq8YTHLtH5ARZMf5xlOmMI=;
	b=1xw8jzqu4+bVnQ8K6GBXj/tg7qicXbrS8TFHQEI44q76nip6OGm7/dHRx+D5rnjjKLQkND
	7zmo5pRwprrtCZ20j089+BJZ4tSYVDeV5tF7gUXc6LH7dvCH1nWKmSJAV29HTmk14kDYyA
	yiMwgF3VzXw4IW1IlPq7kBw8SJ3GRaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781721937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9H3rBRsjIb5KWdXoxyNRNBq8YTHLtH5ARZMf5xlOmMI=;
	b=7HtMHfbGhU0GaKKpqVR/YmGmMr2eYKjjQAVXhPQky5r7RRfvpLOeHrC6IGnHOggintays5
	51rFA0RhWk9k+sBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89671779A8;
	Wed, 17 Jun 2026 18:45:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mlJLGlHrMmrAHwAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 17 Jun 2026 18:45:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.18.y] io_uring/net: Avoid msghdr on
 op_connect/op_bind async data
In-Reply-To: <87zf0tdn7r.fsf@mailhost.krisman.be>
References: <20260617175102.2976716-1-krisman@suse.de>
 <2026061727-thirsty-sculptor-1e6f@gregkh>
 <87zf0tdn7r.fsf@mailhost.krisman.be>
Date: Wed, 17 Jun 2026 14:45:31 -0400
Message-ID: <87v7bhdn04.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:gregkh@linuxfoundation.org,m:stable@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13772-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:from_mime,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2D3A169BFDB

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> The backports are slightly different, so they were sent separately. The bug
> exists since 6.12.

6.12: https://lore.kernel.org/stable/20260617175158.2977825-1-krisman@suse.de/T/#u
7.1: https://lore.kernel.org/stable/20260617174947.2975419-1-krisman@suse.de/T/#u

Do you need 7.0 too?  I assumed 7.0 was EOL after the 7.1 release, if not LTS.

-- 
Gabriel Krisman Bertazi


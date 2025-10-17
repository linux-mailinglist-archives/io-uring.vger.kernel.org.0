Return-Path: <io-uring+bounces-10054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67418BEBC71
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 23:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F14203AC5CD
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 21:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA96E225760;
	Fri, 17 Oct 2025 21:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Lfn17V6Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W+veCwUs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Lfn17V6Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W+veCwUs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D76354ADC
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760734925; cv=none; b=Uxqip49+MhumWQPqakZMH9+q8zzpBteJbUMN/x+luftpbPsDxxmQK+Sv/Vej0q2LEW6ZpsuR4pRrVw6FnQCMnPCBEXOCE/tCglSUKesSockeAiw4krSzNdLv8bqa/3PzEgJW2zoffLGM1TxR+JTRvokjHXI7CsWai9nrEn8cbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760734925; c=relaxed/simple;
	bh=WP5ZYnJCmauGgaEkQWu6RKR/d7cVswAhEwUS6NfgVL0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KgKljweUzEOD5gzDHNzDLyFseSxisePDOh2SMtapwutCFHYW0fvCG8wijY7n41Wj0D+BYnWZITjKeoLejBCmgchvNE8A3nLa5p1luDXqJVVTj/OoM6C0LSmM8j4kGRQC07in1MAh6UyXF6KIGGL2b8xrpoSMVtcxeHnISO2fU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Lfn17V6Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W+veCwUs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Lfn17V6Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W+veCwUs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B5691FF4E;
	Fri, 17 Oct 2025 21:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760734921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tiZmFdSE9i7lAGPPZNdheoH6Hu/aaBeRCdugLASIKxo=;
	b=Lfn17V6Ybu52A0vXK7KqXAa6VpyoKEP+8qRjFDRpWIHBehLVUNMoA8oi3xrCJLu+K3ga9D
	EhvLWwGlgS9FM5PkKMPqwVeb5ydK7NDtr13KoyYE9LEY0rlm18oJh4KCbY2PJ3eGDBIcWB
	t+BhDPXQm6ODWQW0NPbateow41AMPA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760734921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tiZmFdSE9i7lAGPPZNdheoH6Hu/aaBeRCdugLASIKxo=;
	b=W+veCwUsGbTwERv6TzUrLWlpfjg/2Nzaw4vUos85goKInnvZ00oPEqUwIvJzWwgQ3EFnxP
	zFRLghcH4d8BQ9Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760734921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tiZmFdSE9i7lAGPPZNdheoH6Hu/aaBeRCdugLASIKxo=;
	b=Lfn17V6Ybu52A0vXK7KqXAa6VpyoKEP+8qRjFDRpWIHBehLVUNMoA8oi3xrCJLu+K3ga9D
	EhvLWwGlgS9FM5PkKMPqwVeb5ydK7NDtr13KoyYE9LEY0rlm18oJh4KCbY2PJ3eGDBIcWB
	t+BhDPXQm6ODWQW0NPbateow41AMPA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760734921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tiZmFdSE9i7lAGPPZNdheoH6Hu/aaBeRCdugLASIKxo=;
	b=W+veCwUsGbTwERv6TzUrLWlpfjg/2Nzaw4vUos85goKInnvZ00oPEqUwIvJzWwgQ3EFnxP
	zFRLghcH4d8BQ9Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40DBB13A71;
	Fri, 17 Oct 2025 21:02:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hpWzA8mu8mjsRwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 17 Oct 2025 21:02:01 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 0/7] random region / rings cleanups
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com> (Pavel Begunkov's
	message of "Thu, 16 Oct 2025 14:23:16 +0100")
References: <cover.1760620698.git.asml.silence@gmail.com>
Date: Fri, 17 Oct 2025 17:01:55 -0400
Message-ID: <875xcdi6nw.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30

Pavel Begunkov <asml.silence@gmail.com> writes:

> Random stuff that will my future changes simpler but flushing it out
> as it looks like a fine cleanup series. It also replaces
> io_create_region_mmap_safe() calls with non-mmap version where
> it's possible, and removes the helper in Patch 7 while handling
> io_register_mem_region() a bit more gracefully.
>
> Pavel Begunkov (7):
>   io_uring: deduplicate array_size in io_allocate_scq_urings
>   io_uring: sanity check sizes before attempting allocation
>   io_uring: use no mmap safe region helpers on resizing
>   io_uring: remove extra args from io_register_free_rings
>   io_uring: don't free never created regions
>   io_uring/kbuf: use io_create_region for kbuf creation
>   io_uring: only publish fully handled mem region

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
>  io_uring/io_uring.c | 26 ++++++++++++--------------
>  io_uring/kbuf.c     |  2 +-
>  io_uring/memmap.c   | 21 ---------------------
>  io_uring/memmap.h   | 12 ++++++++++++
>  io_uring/register.c | 29 ++++++++++++++---------------
>  5 files changed, 39 insertions(+), 51 deletions(-)

-- 
Gabriel Krisman Bertazi


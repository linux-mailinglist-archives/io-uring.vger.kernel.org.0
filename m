Return-Path: <io-uring+bounces-14005-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3E1CFtFhVmrZ4QAAu9opvQ
	(envelope-from <io-uring+bounces-14005-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:20:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A44756E07
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:20:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CvNVFHw5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A89coq75;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CvNVFHw5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A89coq75;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14005-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14005-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2FA4C300E298
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 16:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F76F481226;
	Tue, 14 Jul 2026 16:20:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D2360EF2
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 16:20:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046031; cv=none; b=CATsQXFWiCLAD7tUoYa2WaARuNLnLHtTfADDG1NeJP9gYwb4KK5LvrLK126gls0FBuJsl2DLEWc2UnIaKyropDab+IYGy5lT/ZjNKZz/UYyUvcGAiaWGH02KSWMenU6MHYopw5RO9pmxqpxQ/fSMhHNZYl+DVbp3bt5qim7IfC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046031; c=relaxed/simple;
	bh=TXBvVYv/jbMd7LIGpT06h4zeFKgjfvvhCU/Uwo8DwvQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YFJxNmGtZR8C/f9n/G98pL87xF943hvByXf5yxS9Ru06ruTBXbcF7b9bzUacSa5+tLdYBLuo0N42ue+lFN/fQkAyG41DI2SvgzdyvniRftt8Ow45PATiC3YY3kzkpw05TRTILVigWkjfPesCPZMQ+cDtRbvy2eiYvZS/0F3VORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CvNVFHw5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=A89coq75; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CvNVFHw5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=A89coq75; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A938A3E24;
	Tue, 14 Jul 2026 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784046027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE8ssZbbzFi2zGlMesQ9KxVdmZLbkI+xtPm/VzS3cZg=;
	b=CvNVFHw5WwhT9bgp+OreDnrJXbBWkC6z4wiqWx4RE87G48KYZHo35miT46uhpOe6Hn79Hn
	eYoFZSOAjPdqjwwWkCLiGu2q4HMpy/2NkBWe4FQJ2sJ1xgso/eBmKjv3RYnbK9RLew5R14
	N6lglEudONShlTgbZdM9oKeADCplaiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784046027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE8ssZbbzFi2zGlMesQ9KxVdmZLbkI+xtPm/VzS3cZg=;
	b=A89coq75GaV6lyyigfhM0AtiOWNh69LWvX3xDx4PynL3aKChSzqNOY3a/LmAzaGgYnSUUo
	yTU+BMulSvcPutAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784046027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE8ssZbbzFi2zGlMesQ9KxVdmZLbkI+xtPm/VzS3cZg=;
	b=CvNVFHw5WwhT9bgp+OreDnrJXbBWkC6z4wiqWx4RE87G48KYZHo35miT46uhpOe6Hn79Hn
	eYoFZSOAjPdqjwwWkCLiGu2q4HMpy/2NkBWe4FQJ2sJ1xgso/eBmKjv3RYnbK9RLew5R14
	N6lglEudONShlTgbZdM9oKeADCplaiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784046027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE8ssZbbzFi2zGlMesQ9KxVdmZLbkI+xtPm/VzS3cZg=;
	b=A89coq75GaV6lyyigfhM0AtiOWNh69LWvX3xDx4PynL3aKChSzqNOY3a/LmAzaGgYnSUUo
	yTU+BMulSvcPutAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B3B9779AE;
	Tue, 14 Jul 2026 16:20:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iP/LCMthVmptDQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 14 Jul 2026 16:20:27 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Prateek <kprateek283@gmail.com>, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, Prateek <kprateek283@gmail.com>
Subject: Re: [PATCH 2/2] test/timeout-swallow: verify -ETIME is not swallowed
In-Reply-To: <20260712221222.535794-1-kprateek283@gmail.com>
Organization: SUSE
References: <20260712221049.534729-1-kprateek283@gmail.com>
 <20260712221222.535794-1-kprateek283@gmail.com>
Date: Tue, 14 Jul 2026 12:20:25 -0400
Message-ID: <87cxwp4k6u.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14005-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kprateek283@gmail.com,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,s:lists@lfdr.de];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mailhost.krisman.be:mid,vger.kernel.org:from_smtp,suse.de:from_mime,suse.de:email,suse.de:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B5A44756E07

Prateek <kprateek283@gmail.com> writes:

> Regression test for the previous commit. Submits an SQE and waits with a
> zero timeout for more completions than can arrive; the result must be
> -ETIME, not the positive submit count. Covers the normal EXT_ARG wait
> path and the registered-wait path, each skipped gracefully where
> unsupported.
>
> Signed-off-by: Prateek <kprateek283@gmail.com>
> ---
>  test/Makefile          |   1 +
>  test/timeout-swallow.c | 117 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 118 insertions(+)
>  create mode 100644 test/timeout-swallow.c
>
> diff --git a/test/Makefile b/test/Makefile
> index d6358a93..ae23ef6d 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -293,6 +293,7 @@ test_srcs := \
>  	timerfd-short-read.c \
>  	timeout.c \
>  	timeout-new.c \
> +	timeout-swallow.c \
>  	timestamp.c \
>  	timestamp-bug.c \
>  	truncate.c \
> diff --git a/test/timeout-swallow.c b/test/timeout-swallow.c
> new file mode 100644
> index 00000000..9fb4ab01
> --- /dev/null
> +++ b/test/timeout-swallow.c
> @@ -0,0 +1,117 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: tests that io_uring_wait_cqes() and variants do not swallow 
> + *              -ETIME when loop-fetching CQEs if some SQEs were submitted.
> + */
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <sys/time.h>
> +#include "liburing.h"
> +#include "helpers.h"
> +
> +/*
> + * Test the normal -ETIME swallow path. (line 118 in queue.c)

This type of comment is useless as line number changes.  Better to refer to
function name in the API and describe the situation or not have anything
at all.  Other than that,


Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>




-- 
Gabriel Krisman Bertazi


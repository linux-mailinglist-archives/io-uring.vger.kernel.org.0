Return-Path: <io-uring+bounces-13914-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FKACOOocTWomvQEAu9opvQ
	(envelope-from <io-uring+bounces-13914-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 17:36:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 255E371D57A
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 17:36:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I2+kHaZ1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6SB4wjR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I2+kHaZ1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6SB4wjR;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13914-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13914-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 18F6B321DE7B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 15:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41D23E63A2;
	Tue,  7 Jul 2026 15:20:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47911428498
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 15:20:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783437622; cv=none; b=YYzXHhzmw52pU+oEPJErdEeDoCB35Przu1gnoaHYOnippdUGzrr6YHD7H4A4v/fxHD/1I3oih1m8dobm2lqyg6w5uHSDwDsooAI8DBB/TfbadNxD/ttko/G9fLePwJZnOd1/hvfTB5Vjwtf7qL3uLCVkqalxEFKWeYR/G8wTreg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783437622; c=relaxed/simple;
	bh=3eNjHpwy9JisRAkxxBNYA60rUaNopUgbyeiXR2K2eT4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BAzxMZpH4hbkcELo0DoeZEHVVZc0A5FYpOQbSmSqkX9pjyWEGqhFxdYwAH4GI2o41kyX+f49QQVly8U0GEXPz7KXQtXKvVUNpwQ6NTBzP+j251zKcJKLrPCOVmdpyqSNaCyZF6iKny8obgYZWA4kQHpyXJXqywMjyU5gVzOuvqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I2+kHaZ1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o6SB4wjR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I2+kHaZ1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o6SB4wjR; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 07FD975983;
	Tue,  7 Jul 2026 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783437613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMskEH+KOx0YUOWAU4SXW8WAGjaxdQFZHshzlBPcbKk=;
	b=I2+kHaZ1vnaYejGouH90ZcaO2CKbcVezzKzlM+KFclUoxkkDkAxtYCaWSMO0vukOBxaQmE
	Rn9P/5mhnO6+EksrlCcYJshiKxKam2Jw+TfNJgT/mJ8b76x8GidOFeoJ4LB26QiVUB0qZr
	eVGk1eQvlxXFsOaM0wc5CsmjOvDiXlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783437613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMskEH+KOx0YUOWAU4SXW8WAGjaxdQFZHshzlBPcbKk=;
	b=o6SB4wjR3/s2QYgfgFpSF34vFOzxRHczh8KopWnD/KnAxl7POlCg0Txmvg0fdjnFjDmxSC
	+q6yFymXwW8lkrCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783437613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMskEH+KOx0YUOWAU4SXW8WAGjaxdQFZHshzlBPcbKk=;
	b=I2+kHaZ1vnaYejGouH90ZcaO2CKbcVezzKzlM+KFclUoxkkDkAxtYCaWSMO0vukOBxaQmE
	Rn9P/5mhnO6+EksrlCcYJshiKxKam2Jw+TfNJgT/mJ8b76x8GidOFeoJ4LB26QiVUB0qZr
	eVGk1eQvlxXFsOaM0wc5CsmjOvDiXlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783437613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMskEH+KOx0YUOWAU4SXW8WAGjaxdQFZHshzlBPcbKk=;
	b=o6SB4wjR3/s2QYgfgFpSF34vFOzxRHczh8KopWnD/KnAxl7POlCg0Txmvg0fdjnFjDmxSC
	+q6yFymXwW8lkrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD2B2779AE;
	Tue,  7 Jul 2026 15:20:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rr1SHiwZTWrCHQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 07 Jul 2026 15:20:12 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, ammarfaizi2@gnuweeb.org
Subject: Re: [PATCH liburing 0/3] Convert manpages to markdown
In-Reply-To: <x49fr1vvvbe.fsf@segfault.usersys.redhat.com>
Organization: SUSE
References: <20260706214132.2841060-1-krisman@suse.de>
 <x49fr1vvvbe.fsf@segfault.usersys.redhat.com>
Date: Tue, 07 Jul 2026 11:20:07 -0400
Message-ID: <87y0fmhlnc.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13914-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:jmoyer@redhat.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:ammarfaizi2@gnuweeb.org,s:lists@lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,mailhost.krisman.be:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 255E371D57A

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Gabriel,
>
> Gabriel Krisman Bertazi <krisman@suse.de> writes:
>
>> This obviously adds a build dependency on pandoc, which is already
>> packaged by any sane distro out there.  The configure file is updated to
>> check for that.
>
> I guess RHEL is not a sane distribution, then.  :)  pandoc was abandoned
> in favor of ghc-pandoc, and RHEL does not ship a haskell compiler.

Oh, that is a bummer!

> It would make RHEL packaging considerably easier if the generated man
> pages continued to be part of the upstream git tree.  If that's not
> acceptable, then I can work around the problem, but it will be a pain.

I suppose we'll have to keep them in-tree, no way around that.
RHEL is unlikely to be the only problematic distro.

The question is whether we want to do the md conversion at all and have
both in-tree or just drop this entirely.  On the bright side, Markdown
is much easier to write, but duplicating the sources can make them go
out of sync.

> At the very least, please make generation of the man pages optional
> via configure.

> Thanks!
> Jeff
>

-- 
Gabriel Krisman Bertazi


Return-Path: <io-uring+bounces-11884-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLB6EMxacmn5iwAAu9opvQ
	(envelope-from <io-uring+bounces-11884-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:13:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A223B6AF29
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B82B3249CB5
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 16:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA573F4B76;
	Thu, 22 Jan 2026 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TPuPTEvF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0Si4R5U/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CLSeoj1O";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qlWPT1Fp"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6338C369980
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098742; cv=none; b=fG3emQ5gvzZ5l2Xv1LaT/wRetVg4HyNxBNLUry+YZHF73U2l8fHrjYwBlFBfeZdoE2xM2m0sC1SlY8VM/Ll0ixgrSDTgS+pNQrzogZijNr9dW754tZyJGiJvAunk0VqN+DmAb9orD1+uMvVN+JIILFEKBQzgNkzyTcXbEiC2/JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098742; c=relaxed/simple;
	bh=EJmEQofWtPuAqnBS87bygmbfKL9ufDdu1z4q2VCMigU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EKq4PuBhL8bK2b2G85CdCWMscwB4UrchvSQt1hRBodCnbwJXK5pR1/rKc9g86ODEz9Ac5DskithioO9KyQZlnyyvaKuN74fEEVw/5RDcIeDaf1PQBElu/EUxS55MQDODjq966nt9hgOEFsZzMl9LJZpB02vd/dp9vcsVcofdp9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TPuPTEvF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0Si4R5U/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CLSeoj1O; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qlWPT1Fp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1E365BCCF;
	Thu, 22 Jan 2026 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769098728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSgT6D/kAUC2Gd08IaKov+wokUvWK1UwZZWEB+RSEh8=;
	b=TPuPTEvF8RULWt453AY3gSyddTY+Gg7cQXPIG7ywBSCUM7okWDIw5JTAnwpX6WfU8ZtSyR
	OASUi/c+A9LmxTV/okCcbhklsf6LRmHVAELpLxnD1/a5ecEkwDP/rCQR5yl/Up2G/7UgN6
	ZcK+5VZdeMyV+DDNNWA0jJGsXZnufGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769098728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSgT6D/kAUC2Gd08IaKov+wokUvWK1UwZZWEB+RSEh8=;
	b=0Si4R5U/A6hEF9cILNR4phjpXqI35nyZ7VeYf7C0sEl4hgCFcxVQI02AQnTjyaFsQCwJgw
	kpyrtrBp3etEfIBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CLSeoj1O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qlWPT1Fp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769098727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSgT6D/kAUC2Gd08IaKov+wokUvWK1UwZZWEB+RSEh8=;
	b=CLSeoj1OSr2PwZN0lb0zsuPg2TmfAW/q/iiP8twSV98iJu0bW+hdUGFynWGBK1dDirQIEH
	RM93eNCkRk2ucjvJ3/LZywc/Au9EsTZIWnJBfh966ouJtCprfRe1k30hUT4OUK+AeFSbmv
	C7quO1V66u20sYdJIYGyjMO9YCsdBho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769098727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSgT6D/kAUC2Gd08IaKov+wokUvWK1UwZZWEB+RSEh8=;
	b=qlWPT1FpfZPZpLmQuXO8Z9P1MpMTVnTZrFfW8YNqUjW9btig/ATVIDFOUbkrByUD7VVydz
	d7OkRbVFVj+XdlDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 928FA13533;
	Thu, 22 Jan 2026 16:18:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tdYkGOdNcmmjFAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 22 Jan 2026 16:18:47 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,  axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] io_uring: introduce non-circular SQ
In-Reply-To: <80368e4b-9148-40d0-bd52-1507fef68055@gmail.com> (Pavel
	Begunkov's message of "Wed, 21 Jan 2026 21:55:18 +0000")
References: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
	<87a4y6esjj.fsf@mailhost.krisman.be>
	<80368e4b-9148-40d0-bd52-1507fef68055@gmail.com>
Date: Thu, 22 Jan 2026 11:18:41 -0500
Message-ID: <87ldhpd3j2.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11884-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.de:dkim]
X-Rspamd-Queue-Id: A223B6AF29
X-Rspamd-Action: no action

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 1/21/26 18:20, Gabriel Krisman Bertazi wrote:

>> and immediately some fixed data, etc.  When I want to run it, I push a
>> SQE OP_EXECUTE pointing to this buffer to the "main" ring and io_uring
>> will queue everything in this pre-registered buffer.
>> I imagine it would save nothing beyond SQ initialization. just curious
>> if you see a use case for something like this?
>
> You already can do it with the sq array. Never heard of anyone
> using it, but liburing never exposed it to users either.

Thanks for the explanation. make sense! 

-- 
Gabriel Krisman Bertazi


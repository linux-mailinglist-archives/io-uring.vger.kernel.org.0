Return-Path: <io-uring+bounces-1922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 431AD8C8CF0
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 21:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7AC1B230DA
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 19:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6158140363;
	Fri, 17 May 2024 19:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NZyjjPCH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cgl8a+ZL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NZyjjPCH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cgl8a+ZL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD260B9C
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715975058; cv=none; b=KkTidBo+jdEwhMRbMp1UCmH1nCJZ3y+UhcwK1Ct6f0EhvLQFYDPow2yb7qKKhZ/Nr/8ekl3bQrqVDwU+8VWknwAipLSMyKQgYUZS2JiXu6iRjfYspXISOnj1QEfNRQfnDhpAonVYprw8I+J0Iulc58V9FpIxv1/b5Q7WABl1r28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715975058; c=relaxed/simple;
	bh=st4lj9vZvW38xU6jc+861Kc0k37kNuu0KGU4b5A9C7k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gHjvsof/lTaI51nvJfr+pauArZw+RqS6hxeDv5BDgxBZ/rTGc5dwOea8bCXs+rF0+ghkplx+ksZPW9kEHIoF55g18IuejSpFdXKvPh8wo3QA+6yMSsRMjg6v5cTe8XZB758Bxm/8jxB63rMz/l0PWhrmH2RSd4ZjSoVH3wuP/fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NZyjjPCH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cgl8a+ZL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NZyjjPCH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cgl8a+ZL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F358D5D738;
	Fri, 17 May 2024 19:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715975055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VITR6k6Afm2AKiQt+xFQz7DmCU6XnG6docN75sYSNx0=;
	b=NZyjjPCHYENvtf+hkuQHYvdyPcdJBXgDEM+cxSHFq9U6xKCbbXpcnac/rZONASJZXPqKjI
	6CChLVqw2HS3XE2G5m2lennqgLlaG8FxEDJ47B6WLuVMxp8eEZGto/IsgAVn/YL7/QzE1v
	z7ykc6Dzofe0jAORRdSktFPr8n9zyz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715975055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VITR6k6Afm2AKiQt+xFQz7DmCU6XnG6docN75sYSNx0=;
	b=Cgl8a+ZLRCt51YD1g8RJEQpT9noPWIXPHwrtxbL3ruFUhuow+FVR3Zeq5oryS849vmAMSA
	lMLM0mkOf3glNRDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715975055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VITR6k6Afm2AKiQt+xFQz7DmCU6XnG6docN75sYSNx0=;
	b=NZyjjPCHYENvtf+hkuQHYvdyPcdJBXgDEM+cxSHFq9U6xKCbbXpcnac/rZONASJZXPqKjI
	6CChLVqw2HS3XE2G5m2lennqgLlaG8FxEDJ47B6WLuVMxp8eEZGto/IsgAVn/YL7/QzE1v
	z7ykc6Dzofe0jAORRdSktFPr8n9zyz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715975055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VITR6k6Afm2AKiQt+xFQz7DmCU6XnG6docN75sYSNx0=;
	b=Cgl8a+ZLRCt51YD1g8RJEQpT9noPWIXPHwrtxbL3ruFUhuow+FVR3Zeq5oryS849vmAMSA
	lMLM0mkOf3glNRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B107013991;
	Fri, 17 May 2024 19:44:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id obIJJY6zR2Y9PwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 17 May 2024 19:44:14 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [Announcement] io_uring Discord chat
In-Reply-To: <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk> (Jens Axboe's
	message of "Fri, 17 May 2024 13:09:16 -0600")
Organization: SUSE
References: <8734qguv98.fsf@mailhost.krisman.be>
	<f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
Date: Fri, 17 May 2024 15:44:08 -0400
Message-ID: <87y188te9j.fsf@mailhost.krisman.be>
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
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> Is it public - and if not, can it be? Ideally I'd love to have something
> that's just open public (and realtime) discussion, ideally searchable
> from your favorite search engine. As the latter seems
> difficult/impossible, we should at least have it be directly joinable
> without an invite link. Or maybe this is not how discord works at all,
> and you need the invite link? If so, as long as anyone can join, then
> that's totally fine too I guess.

It is as public as it can be right now with existing discord rules.  It
can not be made discoverable without a link yet, since it needs to be at
least 8 weeks old for that, from what I see.  I'm looking into that.

The invitation link doesn't expire and doesn't require any approvals. We can
safely place it in liburing documentation.  I mentioned it is revokable,
but that is a safeguard against spammers and needs to be done explicitly.

Let me know if you join. I'll add you as an admin.

-- 
Gabriel Krisman Bertazi


Return-Path: <io-uring+bounces-10894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 54206C9D598
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 00:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 872D04E4959
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 23:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF732FC02D;
	Tue,  2 Dec 2025 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VLS58nIA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AONODLIe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VLS58nIA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AONODLIe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D529221F0C
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764718649; cv=none; b=dLbqJ3yKh4JmYVNeRZRK5PTixbd/7+erTW20TB6hYmt4mIp9UFWmEkzVE89Dz2atzE9TfkE/RVwx1E3iQLdC26iQrX43cSIH0Bknrxx9WKKtlP0MS+ogy4gJBlB2J1IbPA/qKmByBgfnKN3yFTHvFzCbAWiReHB1QwikZIiopgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764718649; c=relaxed/simple;
	bh=TS3CFCuzKmNgHw5Pw4jXbM/WFhXgvMlQM2v7bkQYgic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OkZ2ZIotp80bW7J2gD7uk1p9p0dpHlrZ9e+caSakyflTf5/yYWh9yLfbQ2YoE8D0h+ZVvoKlwIFbUB4Wrmb/OLL7IQ4s2KudjyakVSHIZsKeimw3/fGl9r2lZWx9j4r8sxkyBsfCBwo6cM82GG1Tig2Pa3iv4IwO3vcLZbbZKYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VLS58nIA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AONODLIe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VLS58nIA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AONODLIe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 828935BCDD;
	Tue,  2 Dec 2025 23:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764718645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rYDIaopWtnc3hzcQbMHysLUK6R90yL83/EPbCNuBPDM=;
	b=VLS58nIAv5qv+6b/P/Toe2HtRP+4uE3tHNRWw5tiaB4HNhB/7qRz7dmW88Echn2wod2vnW
	VY6ySX/NatPPrizSMBuyFIXuhyp2UXjlgl/mR6cp9/C83S8XQ0MGJ6fJSWJiYEZX/xzdND
	8QWABOLDGNP4u6JeGR0g2Az6v7E+3uE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764718645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rYDIaopWtnc3hzcQbMHysLUK6R90yL83/EPbCNuBPDM=;
	b=AONODLIe55WvhJV2Od6YGGYMn7u8SVMWGYMFfKdJo4/0ZB0PFbWaXq1N71Y0BiTUN8d0+g
	y4kRWjIbUqC0E8CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VLS58nIA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AONODLIe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764718645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rYDIaopWtnc3hzcQbMHysLUK6R90yL83/EPbCNuBPDM=;
	b=VLS58nIAv5qv+6b/P/Toe2HtRP+4uE3tHNRWw5tiaB4HNhB/7qRz7dmW88Echn2wod2vnW
	VY6ySX/NatPPrizSMBuyFIXuhyp2UXjlgl/mR6cp9/C83S8XQ0MGJ6fJSWJiYEZX/xzdND
	8QWABOLDGNP4u6JeGR0g2Az6v7E+3uE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764718645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rYDIaopWtnc3hzcQbMHysLUK6R90yL83/EPbCNuBPDM=;
	b=AONODLIe55WvhJV2Od6YGGYMn7u8SVMWGYMFfKdJo4/0ZB0PFbWaXq1N71Y0BiTUN8d0+g
	y4kRWjIbUqC0E8CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 419843EA63;
	Tue,  2 Dec 2025 23:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n80ZCTV4L2m1XQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 02 Dec 2025 23:37:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  csander@purestorage.com
Subject: Re: [PATCH liburing v2 2/4] test/bind-listen.t: Use ephemeral port
In-Reply-To: <b8d9117f-7875-4b12-a747-5ee80eb5e1e3@kernel.dk> (Jens Axboe's
	message of "Wed, 26 Nov 2025 13:49:47 -0700")
References: <20251125212715.2679630-1-krisman@suse.de>
	<20251125212715.2679630-3-krisman@suse.de>
	<b8d9117f-7875-4b12-a747-5ee80eb5e1e3@kernel.dk>
Date: Tue, 02 Dec 2025 18:37:22 -0500
Message-ID: <87sedsh2vh.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mailhost.krisman.be:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,kernel.dk:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 828935BCDD
X-Spam-Flag: NO
X-Spam-Score: -4.51

Jens Axboe <axboe@kernel.dk> writes:

> On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
>> This test fails if port 8000 is already in use by something else.  Now
>> that we have getsockname with direct file descriptors, use an ephemeral
>> port instead.
>
> How is this going to work on older kernels? Probably retain the old
> behavior, even if kind of shitty, on old kernels. Otherwise anything
> pre 6.19 will now not run the bind-listen test at all.

Do you have a suggestion on how to check getsockname without doing the
whole socket setup just to probe, considering this is a uring_cmd?
Perhaps checking a feature that was merged at the same time?

If not, I'll come with something and send the v4 early tomorrow so you
can cut the new version still this week.

-- 
Gabriel Krisman Bertazi


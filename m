Return-Path: <io-uring+bounces-5639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA959FEB99
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 00:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D0E61882501
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 23:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F377191F74;
	Mon, 30 Dec 2024 23:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vuouggaf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WTNuz6/Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vuouggaf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WTNuz6/Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C50B154BE4
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 23:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735599774; cv=none; b=FVXDUwXCUC7kxm45+JVx3aH1cG0a74m09tc7UXb6ExfwLEJ0YDfxDwhu5H+oU3U9KbybSbCEp8UbyOcGZAjnMgE97EVw9+Og8CQXqxLoTPHQQYnNAk6tOLWLjhRKgRh29Jm+SM+AZLp5Fa3a3y3SVLaiY+ZCApvKv1OkJJR1IUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735599774; c=relaxed/simple;
	bh=OwQvp2AV1cJ4VC8xCCTZX8jHLnl+HsnvyQWsL1uwmh0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O0zIRE3T52qMiZgilqFIvGy3xVODW02daZ1079NgslWr5i+yfwPehZVo1NPUf4vwqvotq1cRrGKormSq+ic5Pyp7Hj/0Q9/wRt8FDFmidVmdBlcHq/G+1kyoGu8ABJOzuPCx2SWOo2zxnoVEvT5S4RB06UIHFkpQbdoNKzcDpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vuouggaf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WTNuz6/Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vuouggaf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WTNuz6/Q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1312F1F37C;
	Mon, 30 Dec 2024 23:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735599770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFtLkmd4lifn9CaV9i8VvyVyz+rL8G1GdlRvIjxD7Qs=;
	b=vuouggafFKGY1utK8CpwuG6Y8VVemcHHyqH4nwsfSGD1nO1mP7C2zBP08b3StCOxtudF4U
	ltgMkdK+C6mEgI0roO8YmdyLvJoMKHMfNEv7FMO4QilAGhdod9XvNDxnAthVnxoj6Rx9+5
	GiFGKhpq2bBqC6APPsZiz+e6yHk1YjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735599770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFtLkmd4lifn9CaV9i8VvyVyz+rL8G1GdlRvIjxD7Qs=;
	b=WTNuz6/QFVbglfPVpAyXG9gMZvST9AaSARm2VU8k19zuu3NAsOx8FdZr7UoCF1bv610v3d
	z5ZChRXUnm/fwtBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735599770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFtLkmd4lifn9CaV9i8VvyVyz+rL8G1GdlRvIjxD7Qs=;
	b=vuouggafFKGY1utK8CpwuG6Y8VVemcHHyqH4nwsfSGD1nO1mP7C2zBP08b3StCOxtudF4U
	ltgMkdK+C6mEgI0roO8YmdyLvJoMKHMfNEv7FMO4QilAGhdod9XvNDxnAthVnxoj6Rx9+5
	GiFGKhpq2bBqC6APPsZiz+e6yHk1YjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735599770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFtLkmd4lifn9CaV9i8VvyVyz+rL8G1GdlRvIjxD7Qs=;
	b=WTNuz6/QFVbglfPVpAyXG9gMZvST9AaSARm2VU8k19zuu3NAsOx8FdZr7UoCF1bv610v3d
	z5ZChRXUnm/fwtBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BECBD13A30;
	Mon, 30 Dec 2024 23:02:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xFdcIpkmc2fXCQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 30 Dec 2024 23:02:49 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: always clear ->bytes_done on io_async_rw
 setup
In-Reply-To: <394c611c-4089-4137-b690-939bf544e6a8@kernel.dk> (Jens Axboe's
	message of "Mon, 30 Dec 2024 09:58:18 -0700")
Organization: SUSE
References: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk>
	<87wmfh6tlz.fsf@mailhost.krisman.be>
	<394c611c-4089-4137-b690-939bf544e6a8@kernel.dk>
Date: Mon, 30 Dec 2024 18:02:47 -0500
Message-ID: <87seq47p0o.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> On 12/30/24 9:08 AM, Gabriel Krisman Bertazi wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> A previous commit mistakenly moved the clearing of the in-progress byte
>>> count into the section that's dependent on having a cached iovec or not,
>>> but it should be cleared for any IO. If not, then extra bytes may be
>>> added at IO completion time, causing potentially weird behavior like
>>> over-reporting the amount of IO done.
>> 
>> Hi Jens,
>> 
>> Sorry for the delay.  I went completely offline during the christmas
>> week.
>
> No worries, sounds like a good plan!
>
>> Did this solve the sysbot report?  I'm failing to understand how it can
>> happen.  This could only be hit if the allocation returned a cached
>> object that doesn't have a free_iov, since any newly kmalloc'ed object
>> will have this field cleaned inside the io_rw_async_data_init callback.
>> But I don't understand where we can cache the rw object without having a
>> valid free_iov - it didn't seem possible to me before or now.
>
> Not sure I follow - you may never have a valid free_iov, it completely
> depends on whether or not the existing rw user needed to allocate an iov
> or not.

> Hence it's indeed possible that there's a free_iov and the user
> doesn't need or use it, or the opposite of there not being one and the
> user then allocating one that persists.
>
> In any case, it's of course orthogonal to the issue here, which is that
> ->bytes_done must _always_ be initialized, it has no dependency on a
> free_iovec or not. Whenever someone gets an 'rw', it should be pristine
> in that sense.

I see. In addition, I was actually confusing rw->free_iov_nr with
rw->bytes_done when writing my previous message.  The first needs to
have a valid value if ->free_iov is valid. Thanks for the explanation
and making me review this code.

The fix looks good to me now, obviously.

Thanks,
-- 
Gabriel Krisman Bertazi


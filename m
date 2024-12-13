Return-Path: <io-uring+bounces-5491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADC99F174A
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 21:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79944161532
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 20:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA29118C907;
	Fri, 13 Dec 2024 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q8hH6rHe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nj+NoSIO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q8hH6rHe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nj+NoSIO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04AD18C928
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 20:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734120821; cv=none; b=eUz/rHXu/OmhYc9mAG0zyFJ123Z/xpCDs6CipHR1URiQD9fgrTjznZ8TW8h1f9uEhS6ls4IPQOsMwcJhVdoef3L9OImKG4l3gBvLl28LeMbegh1qriMOSMbcd4BCsCm5NvLdLvtWOG+2FzOCQe2LbyDCY9DpIW/ZsvyDccB3SxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734120821; c=relaxed/simple;
	bh=9FTINzvg6CAVBzNV/0TVj+dMyKyp2xHBnyI+iFBjVoU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=a5kiAswi5FMHJXVQGQkPOJf4GwCFQc5KQNhkYhLiK/fKjauv+xagFMe5IFoUf7c+3jI6/Lag4x/dRQIPAcTep2ETGpRVycgyIaY+tp/Lukfz3zvbUq6C/JmmmmqenWU/j3KNT4hk0e+mznhrQeytU4Y0VEHK6KlIp1YsqQN1yRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q8hH6rHe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nj+NoSIO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q8hH6rHe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nj+NoSIO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03E74211A3;
	Fri, 13 Dec 2024 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734120818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL1YpWqN2MtGbJx7oSG08/56s2FtbsM0ut3B0qAc6ro=;
	b=Q8hH6rHe3K4+lEkzYKPtNnUxw//g1nBDH/BC8BiRJFBk/yD67THwS77pJymcRvKG7TBfa9
	2EDuKUf9kzfBbwcvTt7fAi6uVbMniYNK9WQU4HjehMeOfPzZRLpGflTckci/GormlDD1cn
	NI+hPybuGmoO2BiJiZ0OHyIZrtafbYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734120818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL1YpWqN2MtGbJx7oSG08/56s2FtbsM0ut3B0qAc6ro=;
	b=nj+NoSIOmjoLzD73lZSbp2xGWk/Cbl3wJDrVuUTnh4pUbYBPEoEI3pvXg8DC4easLpJmrR
	SxU8JkXCpGMPXPDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q8hH6rHe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nj+NoSIO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734120818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL1YpWqN2MtGbJx7oSG08/56s2FtbsM0ut3B0qAc6ro=;
	b=Q8hH6rHe3K4+lEkzYKPtNnUxw//g1nBDH/BC8BiRJFBk/yD67THwS77pJymcRvKG7TBfa9
	2EDuKUf9kzfBbwcvTt7fAi6uVbMniYNK9WQU4HjehMeOfPzZRLpGflTckci/GormlDD1cn
	NI+hPybuGmoO2BiJiZ0OHyIZrtafbYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734120818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YL1YpWqN2MtGbJx7oSG08/56s2FtbsM0ut3B0qAc6ro=;
	b=nj+NoSIOmjoLzD73lZSbp2xGWk/Cbl3wJDrVuUTnh4pUbYBPEoEI3pvXg8DC4easLpJmrR
	SxU8JkXCpGMPXPDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC89B137CF;
	Fri, 13 Dec 2024 20:13:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E6jyJ3GVXGfBFwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 13 Dec 2024 20:13:37 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk,  io-uring@vger.kernel.org,  josh@joshtriplett.org
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
In-Reply-To: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com> (Pavel
	Begunkov's message of "Wed, 11 Dec 2024 14:02:14 +0000")
Organization: SUSE
References: <20241209234316.4132786-1-krisman@suse.de>
	<fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Fri, 13 Dec 2024 15:13:36 -0500
Message-ID: <87wmg3tk7j.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 03E74211A3
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
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 


Hi Pavel,

Pavel Begunkov <asml.silence@gmail.com> writes:
> On 12/9/24 23:43, Gabriel Krisman Bertazi wrote:

> Sorry to say but the series is rather concerning.
>
> 1) It creates a special path that tries to mimick the core
> path, but not without a bunch of troubles and in quite a
> special way.

I fully agree this is one of the main problem with the series.  I'm
interested in how we can merge this implementation into the existing
io_uring paths.  My idea, which I hinted in the cover letter, is to have
a flavor of io-wq that executes one linked sequence and then terminates.
When a work is queued there, the newly spawned worker thread will live
only until the end of that link.  This wq is only used to execute the
link following a IORING_OP_CLONE and the user can pass CLONE_ flags to
determine how it is created.  This allows the user to create a detached
file descriptor table in the worker thread, for instance.

It'd allows us to reuse the dispatching infrastructure of io-wq, hide
io_uring internals from the OP_CLONE implementation, and
enable, if I understand correctly, the workarounds to execute
task_works.  We'd need to ensure nothing from the link gets
executed outside of this context.

> 2) There would be a special set of ops that can only be run
> from that special path.

There are problems with cancellations and timeouts, that I'd expect to
be more solvable when reusing the io-wq code.  But this task is
executing from a cloned context, so we have a copy of the parent
context, and share the same memory map.  It should be safe to do IO to
open file descriptors, wake futexes and pretty much anything that
doesn't touch io_uring itself.  There are oddities, like the fact the fd
table is split from the parent task while the io_uring direct
descriptors are shared.  That needs to be handled with more sane
semantics.

> At this point it raises a question why it even needs io_uring
> infra? I don't think it's really helping you. E.g. why not do it
> as a list of operation in a custom format instead of links? That
> can be run by a single io_uring request or can even be a normal
> syscall.
>
> struct clone_op ops = { { CLONE },
>         { SET_CRED, cred_id }, ...,
>         { EXEC, path }};
>
>
> Makes me wonder about a different ways of handling. E.g. why should
> it be run in the created task context (apart from final exec)? Can
> requests be run as normal by the original task, each will take the
> half created and not yet launched task as a parameter (in some form),
> modify it, and the final exec would launch it?

A single operation would be a very complex operation doing many things
at once , and much less flexible.  This approach is flexible: you
can combine any (in theory) io_uring operation to obtain the desired
behavior.

-- 
Gabriel Krisman Bertazi


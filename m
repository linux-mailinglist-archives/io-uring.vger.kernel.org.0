Return-Path: <io-uring+bounces-5641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D959FEBAA
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 00:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426E43A1FA4
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 23:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E0F19CD17;
	Mon, 30 Dec 2024 23:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="znI0uN0h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mQp575EL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wgumitoJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zjL89gwV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7EF199EB0
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 23:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735601919; cv=none; b=hl6k487k5w/lBeO+fwGjr6KduDAHMaz5e6g4yGTzX7YiJ5tbWyLKzRomW1N+bQPQCVHsO/84OvBwAtwwe+wjomk6IfSUFduPuSVvfe3wPa3kfkOwso6K5REAwjd0BDII1KpbDMHSgjlUBN7DQAAdH2r5cArmdYf++V9184LLpNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735601919; c=relaxed/simple;
	bh=YafW0xp/BlQ7Cwbq5GMq0BVjocqz2SjYaYQek0ezoBo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FmyvaGwQbU2GKtHMJLYHlEARplt/0DrF3tQS3IXEQh53DP6mpIjIh6H0aEiuLqcjRYZtjZNKn5C4tUHSEJo6lQaaGcF/VhZ6sl6HFbT3DNhG/7khv7WH6zkduofVm2OXeKI77Kz5Uk0iHN/BB+/bk3eFzaVYzc/1mDI2SRYxzls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=znI0uN0h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mQp575EL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wgumitoJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zjL89gwV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AE0F1F37E;
	Mon, 30 Dec 2024 23:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735601915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HE502r3E28Qb+k1IZ8mFXwtk4GtlvcLUzTaBNPFkuU0=;
	b=znI0uN0hoJ232Wy3yaaxGl9gtI4RuIqvwB6RvtL2rkd3vd9zXbpgN/EZihMQdH93WXFNE/
	V2iaOHab73QteSUpL01/o4xPUr+awtZfDJkOFfkZmJrzymy3gt9xpeXvz0cUUewKFyPMWz
	qQSX5MExr5L6elQZhwLztwQ3JHlv3As=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735601915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HE502r3E28Qb+k1IZ8mFXwtk4GtlvcLUzTaBNPFkuU0=;
	b=mQp575EL+JkYzYs3JlwQ59PsHlius+bdWGU6Cr2Job0WBOoZYH84YIU9xGqaXRjbOuS506
	GztlyQH4DUsYTqDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wgumitoJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zjL89gwV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735601914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HE502r3E28Qb+k1IZ8mFXwtk4GtlvcLUzTaBNPFkuU0=;
	b=wgumitoJxGPQO9+ANFCgzfQLJ63e0HZhSZDCa/OsDlQBOpPcHkfEIp6b+Mp9Ebohqqa/6h
	I2u/vcdZXMtUFr0XszZEoeoEImLBe7GgZt5RpUdBHT3iiMKRqodl8rDQhIe8lfqCv8tcRO
	kzJBiVD6vO1FA31Uhp+r3s8PsZe54v8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735601914;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HE502r3E28Qb+k1IZ8mFXwtk4GtlvcLUzTaBNPFkuU0=;
	b=zjL89gwVRNYWLK7truqCPb43LPpA/NoCLo27RAjd+rBqpTNCo2u0qQsA2kMizOczd0mG3b
	AqIPpklbFKnvLPAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBAFE13A30;
	Mon, 30 Dec 2024 23:38:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id haFhLfkuc2fmEAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 30 Dec 2024 23:38:33 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk,  io-uring@vger.kernel.org,  josh@joshtriplett.org
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
In-Reply-To: <1ae79f05-1a07-40aa-acf7-8af98b14b94f@gmail.com> (Pavel
	Begunkov's message of "Tue, 17 Dec 2024 16:10:39 +0000")
Organization: SUSE
References: <20241209234316.4132786-1-krisman@suse.de>
	<fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
	<87wmg3tk7j.fsf@mailhost.krisman.be>
	<1ae79f05-1a07-40aa-acf7-8af98b14b94f@gmail.com>
Date: Mon, 30 Dec 2024 18:38:32 -0500
Message-ID: <87jzbg7nd3.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4AE0F1F37E
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,mailhost.krisman.be:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Pavel Begunkov <asml.silence@gmail.com> writes:

Hi Pavel,

Sorry for the delay. I took the chance to stay offline for a while on
the christmas week.

>> I fully agree this is one of the main problem with the series.  I'm
>> interested in how we can merge this implementation into the existing
>> io_uring paths.  My idea, which I hinted in the cover letter, is to have
>> a flavor of io-wq that executes one linked sequence and then terminates.
>> When a work is queued there, the newly spawned worker thread will live
>> only until the end of that link.  This wq is only used to execute the
>> link following a IORING_OP_CLONE and the user can pass CLONE_ flags to
>> determine how it is created.  This allows the user to create a detached
>> file descriptor table in the worker thread, for instance.
>> It'd allows us to reuse the dispatching infrastructure of io-wq, hide
>> io_uring internals from the OP_CLONE implementation, and
>> enable, if I understand correctly, the workarounds to execute
>> task_works.  We'd need to ensure nothing from the link gets
>> executed outside of this context.
>
> One problem with io-wq is that it's not guaranteed that it's able to
> serve all types of requests. Though it's limited to multishots atm,
> which you might not need, but the situation might change. And there
> is no guarantee that the request is completed by the time it returns
> from ->issue(), it might even change hands from inside the callback
> via task_work or by any other mean.

Multishot is the least of my concerns for this feature, tbh.  I don't
see how it could be useful in the context of spawning a new thread, so
in terms of finding sane semantics, we could just reject them at
submission time if linked from a CLONE.
>
> It also sounds like you want the cloned task to be a normal
> io_uring submmiter in terms of infra even though it can't
> initiate a syscall, which also sounds a bit like an SQPOLL task.
>
> And do we really need to execute everything from the new task
> context, or ops can take a task as an argument and run whenever
> while final exec could be special cased inside the callback?

Wouldn't this be similar to the original design of the io-wq/sqpoll, which
attempted to impersonate the submitter task and resulted in some issues?
Executing directly from the new task is much simpler than trying to do the
operations on the context of another thread.

>>> requests be run as normal by the original task, each will take the
>>> half created and not yet launched task as a parameter (in some form),
>>> modify it, and the final exec would launch it?
>> A single operation would be a very complex operation doing many things
>> at once , and much less flexible.  This approach is flexible: you
>> can combine any (in theory) io_uring operation to obtain the desired
>> behavior.
>
> Ok. And links are not flexible enough for it either. Think of
> error handling, passing results from one request to another and
> more complex relations. Unless chains are supposed to be very
> short and simple, it'd need to be able to return back to user
> space (the one issuing requests) for error handling.

We are posting the completions to the submitter ring.  If a request
fails, we kill the context, but the user is notified of what operation
failed and need to resubmit the entire link with a new spawn.

We could avoid links by letting the spawned task linger, and provide a
way for the user to submit more operations to be executed by this
specific context.  The new task exists until an op to kill the worker is
issued or when the execve command executes.  This would allow the user
to keep multiple partially initialized contexts around for quick
userspace thread dispatching.  we could provide a mechanism to clone
these pre-initialized tasks.

Perhaps it is a stupid idea, but not new - i've seen it discussed
before: I'm thinking of a workload like a thread scheduler in userspace
or a network server.  It could keep a partially initialized worker
thread that never and, when needed, the main task would duplicate it with
another uring command and make the copy return to userspace, mitigating
the cost of copying and reinitializing the task.

-- 
Gabriel Krisman Bertazi


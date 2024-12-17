Return-Path: <io-uring+bounces-5521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCAE9F50CA
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 17:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4293816E043
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 16:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07161FA151;
	Tue, 17 Dec 2024 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbvzZZhG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9FC1FA159
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451788; cv=none; b=fYw7Uuxn1WaHrDeUh1w+BazSVKeJYzjlLOHfc80dhvcUM9pJcCtaxEkJlX9xnhPhEkn/scg1BDlyGtpUCzNSkzDk2/aBn588OzN2+axZQ50/yRY4hNn6F3gWsHPjjUmBYrKU5I14L+fnvj8JM/acfDo7jOS0/r1n4Wnb5FVpGmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451788; c=relaxed/simple;
	bh=D9tXdPFCIP5ckN8Ralf3fUxc1KCEG8Ylfe1f2tyX2SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qI5LYFa+5eSwxvK328zb2r19BXtwtiIcdqphgjo+vScasJtwGETIpVPOf2ggkfVg/nSzxik/isB5JCIfqQikJ5ZtqpA6KtMEujX6b29KQkNyBidIuHl9ENO1Q+Z6HcuCFKQqRbEbMJeGLyq77vW+5RsJv7H7mQW5iR+kF44+rR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gbvzZZhG; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3ea065b79so695927a12.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 08:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734451785; x=1735056585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3n95+5IvlDqxUhINEJTcr5XcyR2eLPnRXIU4XAzL6SU=;
        b=gbvzZZhGzeqYh5h27xi/l59TlPFk4J15SFBuwsCnrr2u7nBHYdxL9JIYwEjCA/OkdQ
         gne1Ph6tVdJogYXDm4OkMAJSpCOBAZvF3/C79Sg/byI7wAKNGxdVZ9We2pJzVU/k+/oc
         dIn4rnjMr1THxuK4+NAr+6fzyu/SEX4oewNkXOsTvryqsG5HtzncxgRMcH9MBJ9NH6mB
         PNBF96OjVmBxmCzho/Y1oEJv93DkI6baEoxp0pjvduHjLmsFdfbsFxf4cL1KGU5FmRbM
         HPXYWDvqU4Uj7lvjOnoDUJdN0D/JiErObe+KolpMl0mUYD35Y1plzZD483yHlO/cDaBH
         aC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734451785; x=1735056585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3n95+5IvlDqxUhINEJTcr5XcyR2eLPnRXIU4XAzL6SU=;
        b=ilImlKou+ca+ams7dDpOV1fK9KVla34tUiapkghTVkVk00/9FCMQQF0hXH+FXAT0dH
         70f4EsbbGSwZQ8TGNWfSkf1EX3R9uorhe1SKOaMTxYN9bdGk4vUZ6AszzAunm4LKTcgv
         tLzTqcC2+DWwyCNQxKLmDgZZfxw1P3epj7aieC6+V8qMUkxugMEIB64lsKqprh9kByrw
         JsfmRO4KR5+nuKrXY8po2KaU1svORY8I77CGkyKuMPHXmFhfNvLqFrAYEBwy7X25RfxB
         q1ebuyXooBelikIjpI0pzr+7EFR39dPaGaNimO++uWo1RLBFVnCidqud9zJ/LAB71/4x
         Bmfg==
X-Forwarded-Encrypted: i=1; AJvYcCXieh45XoncAheAYjQVyys8S0LaAAhLJVN5PauyAde89RyPL3S+IXctyrH4u7iRJIANF95T1XL0QA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkJpoQ3djtkd80YLBpPbgxFCo985JFvzC9sAT/a0P5isZgjW+i
	pnEBW4kTDcUKlUeC3IduSuFve6C+GnVWSr5T1rVAMg2np4a08dI5
X-Gm-Gg: ASbGncunHYxcc4rM1DXAEzegb4CpzSb72mpfhn5bK5rJN8SnvzEQZ4W2jpAAbAJbxb+
	xtYZuDQzhGTlrMBoadzaw0SjynXKouc800/61FrzVV/v/J1zVJ5Q+BplyOM5J1+wvX8nMePjj3H
	/4lyX+Cr4dqdrLqWjr+kkVJddjvyGYmz25CgnpCgA81aOsz61o+1Ebzh7sojL8w/VpGa/2Op9/C
	SbnVbJQHCCYL0NaxZaTYSh6yd6pXlAFIBJ8iBRhLZum9AjMtzwwb7/W0+iZKyLAA5pg
X-Google-Smtp-Source: AGHT+IGzc+VM7/E0SHSOdOLLI4hkmMX3+tea4Byxxhjh23+UwIp7b/SRFhx2NcBHXamfmlgVrluD0g==
X-Received: by 2002:a17:906:31c1:b0:aa6:8935:ae71 with SMTP id a640c23a62f3a-aab778c1e2dmr1546567266b.12.1734451785066;
        Tue, 17 Dec 2024 08:09:45 -0800 (PST)
Received: from [192.168.42.180] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab95d813afsm463537366b.0.2024.12.17.08.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 08:09:44 -0800 (PST)
Message-ID: <1ae79f05-1a07-40aa-acf7-8af98b14b94f@gmail.com>
Date: Tue, 17 Dec 2024 16:10:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, josh@joshtriplett.org
References: <20241209234316.4132786-1-krisman@suse.de>
 <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <87wmg3tk7j.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87wmg3tk7j.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 20:13, Gabriel Krisman Bertazi wrote:
> 
> Hi Pavel,
> 
> Pavel Begunkov <asml.silence@gmail.com> writes:
>> On 12/9/24 23:43, Gabriel Krisman Bertazi wrote:
> 
>> Sorry to say but the series is rather concerning.
>>
>> 1) It creates a special path that tries to mimick the core
>> path, but not without a bunch of troubles and in quite a
>> special way.
> 
> I fully agree this is one of the main problem with the series.  I'm
> interested in how we can merge this implementation into the existing
> io_uring paths.  My idea, which I hinted in the cover letter, is to have
> a flavor of io-wq that executes one linked sequence and then terminates.
> When a work is queued there, the newly spawned worker thread will live
> only until the end of that link.  This wq is only used to execute the
> link following a IORING_OP_CLONE and the user can pass CLONE_ flags to
> determine how it is created.  This allows the user to create a detached
> file descriptor table in the worker thread, for instance.
> 
> It'd allows us to reuse the dispatching infrastructure of io-wq, hide
> io_uring internals from the OP_CLONE implementation, and
> enable, if I understand correctly, the workarounds to execute
> task_works.  We'd need to ensure nothing from the link gets
> executed outside of this context.

One problem with io-wq is that it's not guaranteed that it's able to
serve all types of requests. Though it's limited to multishots atm,
which you might not need, but the situation might change. And there
is no guarantee that the request is completed by the time it returns
from ->issue(), it might even change hands from inside the callback
via task_work or by any other mean.

It also sounds like you want the cloned task to be a normal
io_uring submmiter in terms of infra even though it can't
initiate a syscall, which also sounds a bit like an SQPOLL task.

And do we really need to execute everything from the new task
context, or ops can take a task as an argument and run whenever
while final exec could be special cased inside the callback?


>> 2) There would be a special set of ops that can only be run
>> from that special path.
> 
> There are problems with cancellations and timeouts, that I'd expect to
> be more solvable when reusing the io-wq code.  But this task is
> executing from a cloned context, so we have a copy of the parent
> context, and share the same memory map.  It should be safe to do IO to
> open file descriptors, wake futexes and pretty much anything that
> doesn't touch io_uring itself.  There are oddities, like the fact the fd
> table is split from the parent task while the io_uring direct
> descriptors are shared.  That needs to be handled with more sane
> semantics.
> 
>> At this point it raises a question why it even needs io_uring
>> infra? I don't think it's really helping you. E.g. why not do it
>> as a list of operation in a custom format instead of links? That
>> can be run by a single io_uring request or can even be a normal
>> syscall.
>>
>> struct clone_op ops = { { CLONE },
>>          { SET_CRED, cred_id }, ...,
>>          { EXEC, path }};
>>
>>
>> Makes me wonder about a different ways of handling. E.g. why should
>> it be run in the created task context (apart from final exec)? Can
>> requests be run as normal by the original task, each will take the
>> half created and not yet launched task as a parameter (in some form),
>> modify it, and the final exec would launch it?
> 
> A single operation would be a very complex operation doing many things
> at once , and much less flexible.  This approach is flexible: you
> can combine any (in theory) io_uring operation to obtain the desired
> behavior.

Ok. And links are not flexible enough for it either. Think of
error handling, passing results from one request to another and
more complex relations. Unless chains are supposed to be very
short and simple, it'd need to be able to return back to user
space (the one issuing requests) for error handling.

-- 
Pavel Begunkov



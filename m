Return-Path: <io-uring+bounces-2028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3015F8D56C7
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 02:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EE06B23856
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 00:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BB3360;
	Fri, 31 May 2024 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kZKlEY2x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1E6FC2
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 00:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717114301; cv=none; b=Kw4v7cEr2utiLs7jASa3gc/phsS6zT2QUTtni6qQ8EF7ZtV0JETaV7Y78I8ujxIyj49o+JStdeluYn2vueq0zmptDXshEy3BWgnSlSRWr+0tLCmAt3K1wlKLRjcWgKAASj9oYazV9Evm2Ia3v72tfm2fbdkLLO8c+brPoEv8l7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717114301; c=relaxed/simple;
	bh=F1pimjkwQFfPMHfDPuuzuchzyxWRYnwUUWjGb4zqUxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h67phO5Y5v9uIB+/ERsD23JVUU/mLDdH5lkQxrmfRDfDhN1ytSUtPnuK3fAgBrXYyL5ZXFL2HhKuB2lwDUsw+PPl019rWWB1KzxqFJC5DFc8+D5XNYuCpXmo78ou/xRMUJEDJ32iAjh8Vebt+q9G4cKBPQ2tYY+2j0BEFEt21sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kZKlEY2x; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6bfb8de8c0fso143120a12.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 17:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717114298; x=1717719098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x+Q5rwADOv1SccD11XnV6cMTVC3y6YZSS73humMpm2I=;
        b=kZKlEY2x4+eeK0+M9nr0lgtA0eY48tV1wCv+ksIXH+pcKBRlp42+FMvCaR6V6oek2m
         KRReuREVWvBuzzi/NBiDff73tOcemq1Q6xzZdP2cJ0JO7rgdXVtf20DBl2P0uXSc65XQ
         ogbrcyW7PXbD98QqHYSWW0V9bHYWkh9e8VROTzq3ExemV+K0oLgJnj87XP3s0M/VnbA9
         drhuAqCB+wv4YxGmyzYHbs0Y3uwhJhLmct0un9um481Sv9F1ppvrW4n7DO69lMbPhgRu
         Lmu0te+i+kZX0GdvdD8GjSHnpA9ORyCv/gF9t08GW297H0VOgR4xdQ4OB5CQchBzy388
         3T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717114298; x=1717719098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x+Q5rwADOv1SccD11XnV6cMTVC3y6YZSS73humMpm2I=;
        b=XOVjbpwr8MgvP9K/p7vomBaLu9/yqzdo6Bq44igrBatlYLdlveMi6qmSFi24+45uWB
         Y/KdmUyw7VtmPqaJLjvg9b/NqYuCd/dFR+Be8B9+WvLsUT0dHCS2cBJCFFzFRHONeSLO
         14RCseOCqmwTgLhWXlsfL3SyE3I/OeIVFoD8sp6BZI2qyJHSo1g4s6iYF6YFJzvufJ1o
         NasHzYLMB2L21KB1HCzL8wF3i8MbT1PsWkIXVE5nM95oEq0vMSe8A1KZJzjFpSIf7d+p
         tyjzU/w34Q5mheV5OUpNyv1B72qK5vR+yPFpdgQmZiHA9ZErUnxI8Vv447xA2k5q6nfe
         Pe/A==
X-Forwarded-Encrypted: i=1; AJvYcCVNqfPCueOYnfZATWvuQ05RbLSUitdJjLZNS5bYqyfhO7Qb+BVJZPBRJAxsMl0Lbe+xOftfVDpT4X+WqaMPY/H3L7Uodkw6JqI=
X-Gm-Message-State: AOJu0Yz5HNbpGffZYkOP/9VThNnKZrpbdaKLSy3fyQHpnF5jb1yxZST9
	5B58RDEZJpOCiceAwht3CFla3TRIPvGNGWxM5rIn5AFbC8YqE//ggZNC57SSsJQ=
X-Google-Smtp-Source: AGHT+IF5x/34I7WbJeUtv+0V5TACS331y0UbTct4r1DQoZ3pfj2+W5N4rp7HSAUj0BIsrlfgsweE7w==
X-Received: by 2002:a05:6a21:271c:b0:1b0:219d:79a6 with SMTP id adf61e73a8af0-1b26f30e7cbmr462849637.5.1717114297617;
        Thu, 30 May 2024 17:11:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423c6fb4sm298338b3a.16.2024.05.30.17.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 17:11:36 -0700 (PDT)
Message-ID: <13dbaee6-6129-486f-ade3-3e6b6b8295c5@kernel.dk>
Date: Thu, 30 May 2024 18:11:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org,
 Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
 <tpdo6jfuhouew6stoy7y7sy5dvzphetqic2tzf74c47vr7s5qi@c5ttwxatvwbi>
 <360b1a11-252d-48d9-a680-eda879b676a5@kernel.dk>
 <ioqqlwed5pzaucsfwbnroun5rd2l3loqo53slmc5vos2ha5njm@5aqt6kglccx4>
 <ed8f667b-7aa3-41b8-bb98-3f52a674d765@kernel.dk>
 <q7amewjey3o7sntjsgn4caq4cr7eyhinmomo7gpt2rp6zdhnku@wctr6h3653at>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <q7amewjey3o7sntjsgn4caq4cr7eyhinmomo7gpt2rp6zdhnku@wctr6h3653at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/24 1:35 PM, Kent Overstreet wrote:
> On Thu, May 30, 2024 at 12:48:56PM -0600, Jens Axboe wrote:
>> On 5/30/24 11:58 AM, Kent Overstreet wrote:
>>> On Thu, May 30, 2024 at 11:28:43AM -0600, Jens Axboe wrote:
>>>> I have addressed it several times in the past. tldr is that yeah the
>>>> initial history of io_uring wasn't great, due to some unfortunate
>>>> initial design choices (mostly around async worker setup and
>>>> identities).
>>>
>>> Not to pick on you too much but the initial history looked pretty messy
>>> to me - a lot of layering violations - it made aio.c look clean.
>>
>> Oh I certainly agree, the initial code was in a much worse state than it
>> is in now. Lots of things have happened there, like splitting things up
>> and adding appropriate layering. That was more of a code hygiene kind of
>> thing, to make it easier to understand, maintain, and develop.
>>
>> Any new subsystem is going to see lots of initial churn, regardless of
>> how long it's been developed before going into upstream. We certainly
>> had lots of churn, where these days it's stabilized. I don't think
>> that's unusual, particularly for something that attempts to do certain
>> things very differently. I would've loved to start with our current
>> state, but I don't think years of being out of tree would've completely
>> solved that. Some things you just don't find until it's in tree,
>> unfortunately.
> 
> Well, the main thing I would've liked is a bit more discussion in the
> early days of io_uring; there are things we could've done differently
> back then that could've got us something cleaner in the long run.

No matter how much discussion would've been had, there always would've
been compromises or realizations that "yeah that thing there should've
been done differently". In any case, pointless to argue about that, as
the only thing we can change is how things look in the present and
future. At least I don't have a time machine.

> My main complaints were always
>  - yet another special purpose ringbuffer, and
>  - yet another parallel syscall interface.

Exactly how many "parallel syscall interfaces" do we have?

> We've got too many of those too (aio is another), and the API

Like which ones? aio is a special case async interface for O_DIRECT IO,
that's about it. It's not a generic IO interface. It's literally dio
only. And yes, then it has the option of syncing a file, and poll got
added some years ago as well. But for the longest duration of aio, it
was just dio aio. The early versions of io_uring actually added on top of
that, but I didn't feel like it belonged there.

> fragmentation is a real problem for userspace that just wants to be able
> to issue arbitrary syscalls asynchronously. IO uring could've just been
> serializing syscall numbers and arguments - that would have worked fine.

That doesn't work at all. If all syscalls had been designed with
issue + wait semantics, then yeah that would obviously be the way that
it would've been done. You just add all of them, and pass arguments,
done. But that's not reality. You can do that if you just offload to a
worker thread, but that's not how you get performance. And you could
very much STILL do just that, in fact it'd be trivial to wire up. But
nobody would use it, because something that just always punts to a
thread would be awful for performance. You may as well just do that
offload in userspace then.

Hence the majority of the work for wiring up operations that implement
existing functionality in an async way is core work. The io_uring
interface for it is the simplest part, once you have the underpinnings
doing what you want. Sometimes that's some ugly "this can't block, if it
does, return -EAGAIN", and sometimes it's refactoring things a bit so
that you can tap into the inevitable waitqueue. There's no single
recipe, it all depends on how it currently works.

> Given the history of failed AIO replacements just wanting to shove in
> something working was understandable, but I don't think those would have
> been big asks.

What are these failed AIO replacements? aio is for storage, io_uring was
never meant to be a storage only interface. The only other attempt I can
recall, back in the day, was the acall and threadlet stuff that Ingo and
zab worked on. And even that attempted to support async in a performant
way, by doing work inline whenever possible. But hard to use, as you'd
return as a different pid if the original task blocked.

>>> I'd also really like to see some more standardized mechanisms for "I'm a
>>> kernel thread doing work on behalf of some other user thread" - this
>>> comes up elsewhere, I'm talking with David Howells right now about
>>> fsconfig which is another place it is or will be coming up.
>>
>> That does exist, and it came from the io_uring side of needing exactly
>> that. This is why we have create_io_thread(). IMHO it's the only sane
>> way to do it, trying to guesstimate what happens deep down in a random
>> callstack, and setting things up appropriately, is impossible. This is
>> where most of the earlier day io_uring issues came from, and what I
>> referred to as a "poor initial design choice".
> 
> Thanks, I wasn't aware of that - that's worth highlighting. I may switch
> thread_with_file to that, and the fsconfig work David and I are talking
> about can probably use it as well.
> 
> We really should have something lighter weight that we can use for work
> items though, that's our standard mechanism for deferred work, not
> spinning up a whole kthread. We do have kthread_use_mm() - there's no
> reason we couldn't do an expanded version of that for all the other
> shared resources that need to be available.

Like io-wq does for io_uring? That's why it's there. io_uring tries not
to rely on it very much, it's considered the slow path for the above
mentioned reasons of why thread offload generally isn't a great idea.
But at least it doesn't require a full fork for each item.

> This was also another blocker in the other aborted AIO replacements, so
> reusing clone flags does seem like the most reasonable way to make
> progress here, but I would wager there's other stuff in task_struct that
> really should be shared and isn't. task_struct is up to 825 (!) lines
> now, which means good luck on even finding that stuff - maybe at some
> point we'll have to get a giant effort going to clean up and organize
> task_struct, like willy's been doing with struct page.

Well that thing is an unwieldy beast and has been for many years. So
yeah, very much agree that it needs some tender love and care, and we'd
be better off for it.

>>>> Those have since been rectified, and the code base is
>>>> stable and solid these days.
>>>
>>> good tests, code coverage analysis to verify, good syzbot coverage?
>>
>> 3x yes. Obviously I'm always going to say that tests could be better,
>> have better coverage, cover more things, because nothing is perfect (and
>> if you think it is, you're fooling yourself) and as a maintainer I want
>> perfect coverage. But we're pretty diligent these days about adding
>> tests for everything. And any regression or bug report always gets test
>> cases written.
> 
> *nod* that's encouraging. Looking forward to the umount issue being
> fixed so I can re-enable it in my tests...

I'll pick it up again soon enough, I'll let you know.

-- 
Jens Axboe



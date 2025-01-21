Return-Path: <io-uring+bounces-6028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20044A17698
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 05:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50520169B15
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 04:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6170D1898F2;
	Tue, 21 Jan 2025 04:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzH0fJKd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B533BBE5
	for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 04:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737434343; cv=none; b=pQjJ9kqesqlhmfuQr5GEGv77x1w0m4ouEmwyxvx39Wik6YvD+BJo4mRQJNPo3NpudMUhcrvyxnNet++u5iazIS8rR6z1A7EwZFlJSQ66rvV+v5iw0N9+p9MfaoghkbbwTSprVSRAlPdG084bI9Q5jTwnTpWP8gu4fpzI/hZYbps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737434343; c=relaxed/simple;
	bh=IfyJTs6KoRi9rbdzeG+wn8U+/0qZzzBNAIlrb2jcwfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EnEnC+6lxceCho6Udtc9X7IWCpK8ycC6HSHaOvZbmXTlOrVciN8wB1h/LaHb4U+qUTJoviF4hBCO4EhjmGCIj9XvrdOytIJU+gEhB/JRw/zfhqyTaU/IHA1c//3rDNL1nRIdrwDIaNqDINLSTxHegEW/wEYP/Xzzp7e8nyiUul0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzH0fJKd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aaec111762bso983347266b.2
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 20:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737434339; x=1738039139; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xVGFBxlRHH5FfVYldV19D9OSbOoSo+nsf2h3DVBE6Lk=;
        b=MzH0fJKd77XIGv1okPQn7HybUE+MOgY4dlUdsCLJar3Ts+giJdWkEii5LZoMLSAMrR
         741BSx/5OZt5BowzdLkVzXXO9vBT4GcYx/yV3LlMv3bc//YnDRET85l0rejSrzJqlYsT
         KbE5uXYIpPqABj9irtxT0kh8/z41O9iW8GzBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737434339; x=1738039139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xVGFBxlRHH5FfVYldV19D9OSbOoSo+nsf2h3DVBE6Lk=;
        b=NMmwmWRUjsM73FixHkbvGE43A1O12Baz6xuZ7mwn0auj9HbXTg4ruYI8DwqKsQ9Hmq
         Cy12FEfpby05z1xltUV6Wb3+3DlrWo11rpTY1A+256VysF7Y+vyvTC4cmokcLXQiKF0X
         4EFW0qSGdsPcvhMe5ZjF3X3AH+KKUspfN5Wyu+68CE3ba8rnTpJmTenO+grwNMsRff3o
         QXflBXBwNvhtBl/KaSYCiC17NyywPBDueqxuHMJaso3m3VYk6CP6BhCMjd9XmRDXHkE0
         N7z2WnDBClQ7bAskmF5147KqbRoZ1qpfkwXMJ66lme7juQ5wv4NBpaqc76HSEZa0Vvv8
         JovA==
X-Gm-Message-State: AOJu0Yy/wEoyHVuPOrrcezGp//jMmqAPp1q/BFEq/WkL/IxOS9zLvC+4
	/CuWW5snM7BhNtDTuHTqn3go48t6sL1aEOzo8ut46HdS7a/6Fd1zr6AumgryDOsB1KyAHeWUwwG
	1uvBr7w==
X-Gm-Gg: ASbGncs4Yjr5YaViqgNuvKlG+3f1jipYIL8weX3NWndexmx+/i4JaDeoQtKHnmZF5nz
	sowmxTe/GVo3ifomVEjKn3My6xupqlhs8BSUlb6xOidBX8JYiR0/D+XkSYlM9Ruq/mZaCQVltEe
	Tu+RWrEwDN3g7hhDPnB8sMxRxi268EWvW5cSDchMWjODGRXP+mUX43IfQr7bGGdW6ES6K9isXZi
	51VaaN7a+BOrqmW/zsgBMNZ4NUeKN6UDMnxY9eKGq3xgByMPlgftayYIbNkv4iECGc7JuTTCUHR
	dHStUNs7+HfuHjFKgDnFmAwXhuTIsINEz9HJZdxWT66Y
X-Google-Smtp-Source: AGHT+IGvUHoXw/ehpfRiVFcNKdoz+ki4GM0NMeQP/oR0eI1vkVLCLhxxA5z0dRBiGr0HFRnBOtdxRQ==
X-Received: by 2002:a17:907:3da4:b0:aa6:7933:8b31 with SMTP id a640c23a62f3a-ab38b3707bdmr1591880066b.46.1737434338759;
        Mon, 20 Jan 2025 20:38:58 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384fceb0dsm696911466b.185.2025.01.20.20.38.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 20:38:57 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa68b513abcso958108766b.0
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 20:38:56 -0800 (PST)
X-Received: by 2002:a17:907:3fa3:b0:aa6:841a:dff0 with SMTP id
 a640c23a62f3a-ab38b167b65mr1227924966b.32.1737434336108; Mon, 20 Jan 2025
 20:38:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
In-Reply-To: <1481b709-d47b-4346-8802-0222d8a79a7e@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Jan 2025 20:38:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjuucatTzRy6b8Jh6pvHrZ9_LXbz6G-gjBYLAurzanPjQ@mail.gmail.com>
X-Gm-Features: AbW1kvazRWVn4oQJSFDh-ReGAmLl2yvR5sRq8noNY7jW5RzG5rEzM4tv6rdvkRQ
Message-ID: <CAHk-=wjuucatTzRy6b8Jh6pvHrZ9_LXbz6G-gjBYLAurzanPjQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 6.14-rc1
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jan 2025 at 07:05, Jens Axboe <axboe@kernel.dk> wrote:
>
> Note that this will throw a merge conflict, as there's a conflict
> between a fix that went into mainline after 6.13-rc4. The
> io_uring/register.c one is trivial, the io_uring/uring_cmd.c requires a
> small addition. Here's my resolution [..]

Ok, so while doing this merge, I absolutely *hate* your resolution in
both files.

The READ_ONCE/WRITE_ONCE changes during resize operations may not
actually matter, but the way you wrote things, it does multiple
"READ_ONCE()" operations. Which is kind of against the whole *point*.

So in io_uring/register.c, after the loop that copies the old ring contents with

        for (i = old_head; i < tail; i++) {

I changed the

        WRITE_ONCE(n.rings->sq.head, READ_ONCE(o.rings->sq.head));
        WRITE_ONCE(n.rings->sq.tail, READ_ONCE(o.rings->sq.tail));

to instead just *use* the original READ_ONCE() values, and thus do

        WRITE_ONCE(n.rings->sq.head, old_head);
        WRITE_ONCE(n.rings->sq.tail, tail);

instead (and same for the 'cq' head/tail logic)

Otherwise, what's the point of reading "once", when you then read again?

Now, presumably (and hopefully) this doesn't actually matter, and
nobody should even have access to the old ring when it gets resized,
but it really bothered me.

And it's also entirely possible that I have now screwed up royally,
and I actually messed up. Maybe I just misunderstood the code. But the
old code really looked nonsensical, and I felt I couldn't leave it
alone.

Now, the other conflict didn't look nonsensical, and I *did* leave it
alone, but I still do hate it even if I did it as you did. Because I
hate that pattern.

There are now three cases of 'use the init_once callback" for
io_uring_alloc_async_data(), and all of them just clear out a couple
of fields.

Is it really worth it?

Could we not get rid of that 'init_once' pattern completely, and
replace it with just always using 'kzalloc()' to clear the *whole*
allocation initially?

From what I can tell, all those things are fairly small structures.
Doing a simple 'memset()' is *cheaper* than calling an indirect
function pointer that then messes up the cache by setting just one or
two fields (and has to do a read-for-ownership in order to do so).

Are there cases where the allocations are so big that doing a
kmalloc() and then clearing one field (using an indirect function
pointer) really is worth it?

Anyway, I left that logic alone, because my hatred for it may run hot
and deep, but the pattern goes beyond just the conflict.

So please tell me why I'm wrong, and please take a look at the
WRITE_ONCE() changes I *did* do, to see if I might be confused there
too.

               Linus


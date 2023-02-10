Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E5C69235E
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBJQeS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 11:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBJQeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 11:34:17 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194971BDB
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:34:16 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qb15so15279638ejc.1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fhLS95sVAPuPLSt4s3QNipINWEX9MBrZr6+OBYHbgx0=;
        b=cL0mkbQIbHTogr8+gARmzk7nOJyD+7SQmmdWptCXTxvc58+uY1vnr+O3VA6IXM3pTE
         xBSu3S98ypYKJ1ws4c6sOhAicybJKFwvsEqJZZr3hDlVubO2y7LscipiJbUntT3Fcny5
         cCGhMNw2tXB30dK1JJMm5hbi0YDzOdQMqBrds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fhLS95sVAPuPLSt4s3QNipINWEX9MBrZr6+OBYHbgx0=;
        b=G6YxrWXqiJjLAplKt+UQEuws6KLUTlXmmFOYbfOmMAebMvq3EXxCRpDbBZKR45aiqn
         IHhyNX80R6M+y6/ayx37BCcZC9SEFONBg0COP8RnVdmWRDDSUxJ5adWsi6kUWgVqy7lt
         k+jJe9NJeWOUxQiBTavYG9eEdx8W7MA0QypnyPB1PWZd1AK4p0GHiAtZU5BiBuDnr5N+
         v+dow3HOu77J7PEBa03hDJSjlmjSGIWsyi0QLSc+hFs2mlYjAvQDvWbfIM3dVCYZVHYz
         w6ucUbU/rmWCI0mOlfuJdHiznk2OgR/8nZ4zBX1fjqzOHBw0FpQKK56RyhkoR/IIMCK8
         vw+g==
X-Gm-Message-State: AO0yUKW2kk/hghtT3Y8s/+GeYlXkR9KAyuAW/6Xq8YINgTaK2tQklSw3
        LpXHfqoXzj1kPS77D2tehqRjYRoy0pkysR8ipIU=
X-Google-Smtp-Source: AK7set8FJ6CVD845lWGm+3CKnNmKwRYgjcvjwR7zlFvgio/YnknnVbl9/tXxh5zmOkeufJ9D3q5vaQ==
X-Received: by 2002:a17:907:7d93:b0:8af:33d2:787c with SMTP id oz19-20020a1709077d9300b008af33d2787cmr7601299ejc.13.1676046854311;
        Fri, 10 Feb 2023 08:34:14 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id v1-20020a50a441000000b004aab66d34c7sm2470452edb.7.2023.02.10.08.34.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 08:34:13 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id qw12so17397737ejc.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:34:13 -0800 (PST)
X-Received: by 2002:a17:906:4e46:b0:87a:7098:ca09 with SMTP id
 g6-20020a1709064e4600b0087a7098ca09mr3021239ejw.78.1676046853351; Fri, 10 Feb
 2023 08:34:13 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
In-Reply-To: <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 08:33:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
Message-ID: <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 7:15 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> Frankly, I really don't like having non-immutable data in a pipe.

That statement is completely nonsensical.

A pipe is a kernel buffer. If you want the buffer to be immutable, you
do "read()" and "write()" on it. End of story.

In contrast, "splice()" is literally the "map" operation. It's
"mmap()", without the "m", because it turns out that memory mapping
has a few problems:

 (a) mmap fundamentally only works on a page granularity

 (b) mmap has huge setup and teardown costs with page tables and TLB's

and so splice() is just basically "strange mmap with that kernel
buffer that is pipe"

Really. That is what spice *is*. There's absolutely no question about it.

It has some advantages over mmap, in that because it's a software
mapping, we can "map" partial pages, which means that you can also map
data that might not be in full pages (it might be an incoming network
buffer, for example).

It has a lot of disadvantages over mmap too, of course. Not using
hardware means that it doesn't really show up as a linear mapping, and
you don't get the nice hardware lookup accelerations - but it also
means that you don't have the downsides (ie TLB costs etc).

So I'm not saying that it is the same thing as "mmap", but I very much
_am_ saying that there's a very real and direct similarity. There are
three fundamental IO models in Unix: read, write, and mmap. And mmap()
is very much a "you get a direct window into something that can change
under you".  And splice() is exactly that same thing.

It was literally designed to be "look, we want zero-copy networking,
and we could do 'sendfile()' by mmap'ing the file, but mmap - and
particularly munmap - is too expensive, so we map things into kernel
buffers instead".

So saying "I really don't like having non-immutable data in a pipe" is
complete nonsense. It's syntactically correct English, but it makes no
conceptual sense.

You can say "I don't like 'splice()'". That's fine. I used to think
splice was a really cool concept, but I kind of hate it these days.
Not liking splice() makes a ton of sense.

But given splice, saying "I don't like non-immutable data" really is
complete nonsense.

If you want a stable buffer, use read() and write(). It's that simple.
If you want to send data from a file to the network, and want a stable
buffer in between the two, then "read()" and "write()" is *exactly*
what you should do.

With read and write, there's no mmap()/munmap() overhead of the file,
and you already have the buffer (iwe call it "user address space").
The only downside is the extra copy.

So if  you want to send stable, unchanging file contents to the
network, there is absolutely *no* reason to ever involve a pipe at
all, and you should entirely ignore splice().

The *only* reason to ever use splice() is because you don't want to
copy data, and just want a reference to it, and want to keep it all in
kernel space, because the kernel<->user boundary ends up either
requiring copies, or that page alignment, and is generally fairly
expensive.

But once you decide to go that way, you need to understand that you
don't have "immutable data". You asked for a reference, you got a
reference, and it *will* change.

That's not something specific to "splice()". It's fundamental to the
whole *concept* of zero-copy. If you don't want copies, and the source
file changes, then you see those changes.

So saying "I really don't like having non-immutable data in a pipe"
really is nonsense. Don't use splice. Or do, and realize that it's a
*mapping*.

Because that is literally the whole - and ONLY - reason for splice in
the first place.

              Linus

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C97F6917A6
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 05:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBJEr3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 23:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBJEr2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 23:47:28 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDC24C98
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 20:47:26 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l12so3890331edb.0
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 20:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cvwfcddns9wEYGMGsoiElla/fMiugMdLW+ZU2vKhB7Q=;
        b=M9jqvy9vqZ7GIvN6X0r0tJPRyNR5XsTBKWs09APkXPouATgMG65O1fuTD3jATxsfcO
         Gysz8LgLqGc+GXmEgZ5girBmCfhrAfMolnWCqDSAvI42pkfVsZE28km43Yn3Tgr1ltQY
         uAos7n6XK3oEQ5ve/fwxQ53u1Uz9Wz2cNjh+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cvwfcddns9wEYGMGsoiElla/fMiugMdLW+ZU2vKhB7Q=;
        b=PIIkkJCfXWz7b65J8W0sI5RiBzh8DmquUsd/qX2Wb6sbiFhqP5R/pQFLuzX0lsg1KZ
         Ic4lJD6ruSxe/ouLroRIse4cHV0TNtXKBFGcRymovNh5muSJwKQbASu7hqckXVwTlMTR
         g3PrX8BDCfSnqSbLBjQGsgcVsiU8lR5mdrlKNQtPdCAMV/5VTz4PivAyRH87DdaowVmO
         Ii0mxfay/EoGP3nY1G9WHEy00nq204Y5jD950a6Y7J93TQuN1FBiCDDZjCRBKD2JPRpJ
         R8msZiMkq1DLcowjHAbhchA6YMv1Wm25po35vFATp1PCFCYXiUmrodLdtom9EXdDv3HB
         KwQQ==
X-Gm-Message-State: AO0yUKW07w5b0xqEOQFCMD5sWOSjyZi1zwefGT5B/nWJtninpjhaMqml
        e+0LDGp8S49VguE0jl+kvy9aphYy5/j0D36FH3I=
X-Google-Smtp-Source: AK7set+efBSsxGJ4L8GphIKXdqDHtdmvAVjrJe/jQAiJehqF8LRB7G5bEXOsUAHCwt4KiZJsobU6DA==
X-Received: by 2002:a50:ce13:0:b0:4a0:b7d6:57db with SMTP id y19-20020a50ce13000000b004a0b7d657dbmr15203735edi.33.1676004445203;
        Thu, 09 Feb 2023 20:47:25 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id qq8-20020a17090720c800b0088e7fe75736sm1837946ejb.1.2023.02.09.20.47.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 20:47:24 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id v13so3781392eda.11
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 20:47:24 -0800 (PST)
X-Received: by 2002:a50:cc99:0:b0:4ab:66f:6de0 with SMTP id
 q25-20020a50cc99000000b004ab066f6de0mr2073831edi.5.1676004444332; Thu, 09 Feb
 2023 20:47:24 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
In-Reply-To: <20230210040626.GB2825702@dread.disaster.area>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Feb 2023 20:47:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wip9xx367bfCV8xaF9Oaw4DZ6edF9Ojv10XoxJ-iUBwhA@mail.gmail.com>
Message-ID: <CAHk-=wip9xx367bfCV8xaF9Oaw4DZ6edF9Ojv10XoxJ-iUBwhA@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Dave Chinner <david@fromorbit.com>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
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

On Thu, Feb 9, 2023 at 8:06 PM Dave Chinner <david@fromorbit.com> wrote:
>>
> So while I was pondering the complexity of this and watching a great
> big shiny rocket create lots of heat, light and noise, it occurred
> to me that we already have a mechanism for preventing page cache
> data from being changed while the folios are under IO:
> SB_I_STABLE_WRITES and folio_wait_stable().

No, Dave. Not at all.

Stop and think.

splice() is not some "while under IO" thing. It's *UNBOUNDED*.

Let me just give an example: random user A does

   fd = open("/dev/passwd", O_RDONLY);
   splice(fd, NULL, pipefd, NULL, ..);
   sleep(10000);

and you now want to block all writes to the page in that file as long
as it's being held on to, do you?

So no.

The above is also why something like IOMAP_F_SHARED is not relevant.
The whole point of splice is to act as a way to communicate pages
between *DIFFERENT* subsystems. The only thing they have in common is
the buffer (typically a page reference, but it can be other things)
that is getting transferred.

A spliced page - by definition - is not in some controlled state where
one filesystem (or one subsystem like networking) owns it, because the
whole and only point of splice is to act as that "take data from one
random source and feed it in to another random destination", and avoid
the N*M complexity matrix of N sources and M destinations.

So no. We cannot block writes, because there is no bounded time for
them. And no, we cannot use some kind of "mark this IO as shared",
because there is no "this IO".

It is also worth noting that the shared behavior (ie "splice acts as a
temporary shared buffer") might even be something that people actually
expect and depend on for semantics. I hope not, but it's not entirely
impossible that people change the source (could be file data for the
above "splice from file" case, but could be your own virtual memory
image for "vmsplice()") _after_ splicing the source, and before
splicing it to the destination.

(It sounds very unlikely that people would do that for file contents,
but vmsplice() might intentionally use buffers that may be "live").

Now, to be honest, I hope nobody plays games like that. In fact, I'm a
bit sorry that I was pushing splice() in the first place. Playing
games with zero-copy tends to cause problems, and we've had some nasty
security issues in this area too.

Now, splice() is a *lot* cleaner conceptually than "sendfile()" ever
was, exactly because it allows that whole "many different sources,
many different destinations" model. But this is also very much an
example of how "generic" may be something that is revered in computer
science, but is often a *horrible* thing in reality.

Because if this was just "sendfile()", and would be one operation that
moves file contents from the page cache to the network buffers, then
your idea of "prevent data from being changed while in transit" would
actually be valid.

Special cases are often much simpler and easier, and sometimes the
special cases are all you actually want.

Splice() is not a special case. It's sadly a very interesting and very
generic model for sharing buffers, and that does cause very real
problems.

            Linus

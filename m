Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07440692A37
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjBJWfe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjBJWfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:35:33 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40F91733
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:35:31 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id c26so14662977ejz.10
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sgPQEqmErKQB0wG6VWCF+VmnzkMKfRqkz/sIKfZqL68=;
        b=gQz1/9xmHREGXPA2JXH0RsK7JsUhn7vHa15D/69fCSK/vZzwlw4bq85T8mRYkpJplP
         EegJvrfeGBLxDkz18RvpvK6JB/6GDTuCoFw9pDlWGUVTnbp7FP4QCEiSxJ0txMWl8p8y
         bbKRpYKHkKD8w9mPOUGxJllCwuJhuHiNZ3ZP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgPQEqmErKQB0wG6VWCF+VmnzkMKfRqkz/sIKfZqL68=;
        b=WvxUZSmRolni187rVH+bFE09EBKunEJvwFAcioC+gjnufpiF+wIup1lOvwq/hXdWK7
         GXWK3i092UXdsoTur+Ib0RMvJgBxvhLT0ip22WSgibr7KywsRQbmXwrzCzkS6hMBhODw
         V+ZD4a+/k2T2aKWuf1UKWan72zPAQTc2gRodA0m0e9FadE+HXDJ8R638qmJJAu74PITM
         X4F0eR5QNj3B7eRRcpX6QbrVdUZlwuNnQLc8TNdlB+qPKU8TCbV5JhnF1Q/Su8YMDMjP
         0qYbB2is66EcvHKKgCRmSzVXDnKeHWgoeI6Xu/QBid5R1uEyvimiq8+HSy3IOePH2+FJ
         MU/Q==
X-Gm-Message-State: AO0yUKXaBRqOD6WvP9WPI30p44lYA9B/0sNfMkByrfCaiiXX9wacygZr
        1mvdxYXY9rIEIPdP7o4nyjXf3LOqy5qFcZ3rmmE=
X-Google-Smtp-Source: AK7set/oZjYHSglv1w1zsg9/zGr8Yk1ab14OzEZ5laWWGt0vgKpWhZvX6qy6nUWoAMIb7JT/4sq0SA==
X-Received: by 2002:a17:907:62a1:b0:86f:64bb:47eb with SMTP id nd33-20020a17090762a100b0086f64bb47ebmr23923441ejc.3.1676068530130;
        Fri, 10 Feb 2023 14:35:30 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id h7-20020a170906584700b008a9e585786dsm2946030ejs.64.2023.02.10.14.35.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:35:29 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id jg8so19454038ejc.6
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:35:29 -0800 (PST)
X-Received: by 2002:a17:906:fad2:b0:88d:d304:3424 with SMTP id
 lu18-20020a170906fad200b0088dd3043424mr1693934ejb.0.1676068528950; Fri, 10
 Feb 2023 14:35:28 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk> <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk> <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk> <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk> <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com> <824fa356-7d6e-6733-8848-ab84d850c27a@kernel.dk>
In-Reply-To: <824fa356-7d6e-6733-8848-ab84d850c27a@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 14:35:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg3gLL-f6XkQo4vw42Q+ySPrMdprNL1dxNrr3RGHzhnrw@mail.gmail.com>
Message-ID: <CAHk-=wg3gLL-f6XkQo4vw42Q+ySPrMdprNL1dxNrr3RGHzhnrw@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
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

On Fri, Feb 10, 2023 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > (I actually suspect that /dev/zero no longer works as a splice source,
> > since we disabled the whole "fall back to regular IO" that Christoph
> > did in 36e2c7421f02 "fs: don't allow splice read/write without
> > explicit ops").
>
> Yet another one... Since it has a read_iter, should be fixable with just
> adding the generic splice_read.

I actually very consciously did *not* want to add cases of
generic_splice_read() "just because we can".

I've been on a "let's minimize the reach of splice" thing for a while.
I really loved Christoph's patches, even if I may not have been hugely
vocal about it. His getting rid of set/get_fs() got rid of a *lot* of
splice pain.

And rather than try to make everything work with splice that used to
work just because it fell back on read/write, I was waiting for actual
regression reports.

Even when splice fails, a lot of user space then falls back on
read/write, and unless there is some really fundamental reason not to,
I think that's always the right thing to do.

So we do have a number of "add splice_write/splice_read" commits, but
they are hopefully all the result of people actually noticing
breakage.

You can do

     git log --grep=36e2c7421f02

to see at least some of them, and I really don't want to see them
without a "Reported-by" and an actual issue.

Exactly because I'm not all that enamoured with splice any more.

                 Linus

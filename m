Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876C0690E84
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBIQl0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 11:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBIQlY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 11:41:24 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D706032B
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 08:41:22 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m14so2352340wrg.13
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 08:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fy6WnIEU71GZIY+z6R8euSa0ykjzlE8UhDlJ4MZussw=;
        b=BE70cdxkY3AgPoEHUcFgMZpAC9ic7dlcWAKhGi3scRl1Pn7eiBcymtvC9zINwVF5N5
         itL5ACiOnUl+CIZkJGJ3QdHdvojuUGU7zpNOTC1z9XWJfGk2fkuZ0eCKWQsNGKhKiawJ
         x/XSTLzMhoiVWMdPVv3WV8MzmMnSahA8b0lYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fy6WnIEU71GZIY+z6R8euSa0ykjzlE8UhDlJ4MZussw=;
        b=eCdvfKAGO+DZzYYHTKeJWPgXOHXQkMO9fZWDrb+KPMT/+I4aeXltXybsxYAy5jOC+E
         VC+LGYTPvsfLZJi6YITmOTtjiMfLBaiezaNGUkWyO9t/h0ZNKEX6AwrTIJtLpxWQ4iFY
         iNQgDbTjRsfa0nYayVVevhSR8m9YECJXqYLr81h8oECbZ1HFFmrtg40dZpc9IRzZ8TMw
         7Ak7zwqq7dmpFK20Y1v81SOHNkhx4WqvC4EG/9Fj36yzS+L8be/SuGMtoWBjD2nOMjAh
         B8E377GJReR3RWWXpNY+ic+uZtURXdNinkiUT49kQVxGksSz355L1aFNrW/xsSf8VZY2
         a9NA==
X-Gm-Message-State: AO0yUKUpDGIt7KT0wuPWIwBU/o6YXJP3vhjUG4FUNWYfPxfctPBNun1S
        vtnwHkItpegY3OpoZ13OOUYzNDu4aX8DxA52ELk=
X-Google-Smtp-Source: AK7set8qSFzlIMFapqGQqJL+GNMEoDY/BPjPFX/TY9bJp3EpUmgt7DqTjx/doX6V4ZS7NQauW486Yg==
X-Received: by 2002:a5d:5949:0:b0:2bf:e9dc:5536 with SMTP id e9-20020a5d5949000000b002bfe9dc5536mr11129075wri.45.1675960880972;
        Thu, 09 Feb 2023 08:41:20 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id f3-20020a056000128300b002c3e600d1a8sm1638050wrx.95.2023.02.09.08.41.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 08:41:20 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id ml19so8287964ejb.0
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 08:41:20 -0800 (PST)
X-Received: by 2002:a17:906:4e46:b0:87a:7098:ca09 with SMTP id
 g6-20020a1709064e4600b0087a7098ca09mr2346945ejw.78.1675960879649; Thu, 09 Feb
 2023 08:41:19 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
In-Reply-To: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Feb 2023 08:41:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
Message-ID: <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
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

Adding Jens, because he's one of the main splice people. You do seem
to be stepping on his work ;)

Jens, see

  https://lore.kernel.org/lkml/0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org

On Thu, Feb 9, 2023 at 5:56 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> So we have two cases:
>
> 1. network -> socket -> splice -> pipe -> splice -> file -> storage
>
> 2. storage -> file -> splice -> pipe -> splice -> socket -> network
>
> With 1. I guess everything can work reliable [..]
>
> But with 2. there's a problem, as the pages from the file,
> which are spliced into the pipe are still shared without
> copy on write with the file(system).

Well, honestly, that's really the whole point of splice. It was
designed to be a way to share the storage data without having to go
through a copy.

> I'm wondering if there's a possible way out of this, maybe triggered by a new
> flag passed to splice.

Not really.

So basically, you cannot do "copy on write" on a page cache page,
because that breaks sharing.

You *want* the sharing to break, but that's because you're violating
what splice() was for, but think about all the cases where somebody is
just using mmap() and expects to see the file changes.

You also aren't thinking of the case where the page is already mapped
writably, and user processes may be changing the data at any time.

> I looked through the code and noticed the existence of IOMAP_F_SHARED.

Yeah, no. That's a hacky filesystem thing. It's not even a flag in
anything core like 'struct page', it's just entirely internal to the
filesystem itself.

> Is there any other way we could archive something like this?

I suspect you simply want to copy it at splice time, rather than push
the page itself into the pipe as we do in copy_page_to_iter_pipe().

Because the whole point of zero-copy really is that zero copy. And the
whole point of splice() was to *not* complicate the rest of the system
over-much, while allowing special cases.

Linux is not the heap of bad ideas that is Hurd that does various
versioning etc, and that made copy-on-write a first-class citizen
because it uses the concept of "immutable mapped data" for reads and
writes.

Now, I do see a couple of possible alternatives to "just create a stable copy".

For example, we very much have the notion of "confirm buffer data
before copying". It's used for things like "I started the IO on the
page, but the IO failed with an error, so even though I gave you a
splice buffer, it turns out you can't use it".

And I do wonder if we could introduce a notion of "optimistic splice",
where the splice works exactly the way it does now (you get a page
reference), but the "confirm" phase could check whether something has
changed in that mapping (using the file versioning or whatever - I'm
hand-waving) and simply fail the confirm.

That would mean that the "splice to socket" part would fail in your
chain, and you'd have to re-try it. But then the onus would be on
*you* as a splicer, not on the rest of the system to fix up your
special case.

That idea sounds fairly far out there, and complicated and maybe not
usable. So I'm just throwing it out as a "let's try to think of
alternative solutions".

Anybody?

               Linus

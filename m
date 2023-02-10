Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C2069277B
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjBJT4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbjBJT4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:56:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BAB35B1
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3B761E5D
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B881EC433D2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 19:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676058959;
        bh=/rbtwGkm6KjNDPlncngu4DRJNGQVNjUWrQ5+Z6JNEmg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dkQHuiF8P/dgaBGd5YJx4xzu3r7trh3/L6g9QQyiESG614aE8kO0FveBLQhhbngZc
         cGqz0YYE/tUmjT5Z7If+FDBH2GXkOmkpN5WxsYX0iyP1MK29A+AHro0b+C6MjvppY+
         Ht7bV5kq+1S33oRfw2XZ7R0ZzWHldTquToqimapb+Bl8ynj9Bltw8tb/b39/FKpKqZ
         b/k5TZdVIY2s71ynKKWU0tm0QWgB/GexCz4DWX753hq69rDox9qbLhyQzrEj4ey6aH
         3DlBRy1q/1yPEMO7TN3aElallOhM3pOp+KDzw3JMdKFKavBSJnHTGY5GuNnN82OsOi
         wwO4sQ8qOtRzQ==
Received: by mail-ed1-f54.google.com with SMTP id a10so5671750edu.9
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:55:59 -0800 (PST)
X-Gm-Message-State: AO0yUKW2yJ/Q3SVpdqFoEKByjX2RYAnbAhLMx6yoau9AADc77L6Ha7VM
        CcSB4nOM4R7jOYAvv0r9EfbcnwB5+kp8eq0KHtQE5g==
X-Google-Smtp-Source: AK7set8T+tp2IZwVFvcjeL5tlcMarKtooKEDf9AGe53UI8xtD8A+U4cxUUUA2tv3tXXGolmJnsFOG8/Tj0Yb/wcb2uQ=
X-Received: by 2002:a50:ba8d:0:b0:4ab:1c64:a9ed with SMTP id
 x13-20020a50ba8d000000b004ab1c64a9edmr1535489ede.2.1676058958001; Fri, 10 Feb
 2023 11:55:58 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com> <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 10 Feb 2023 11:55:45 -0800
X-Gmail-Original-Message-ID: <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
Message-ID: <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 11:18 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Feb 10, 2023 at 11:02 AM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > Second, either make splice more strict or add a new "strict splice"
> > variant.  Strict splice only completes when it can promise that writes
> > to the source that start after strict splice's completion won't change
> > what gets written to the destination.
>
> The thing ius, I think your "strict splice" is pointless and wrong.
>
> It's pointless, because it simply means that it won't perform well.
>
> And since the whole point of splice was performance, it's wrong.
>
> I really think the whole "source needs to be stable" is barking up the
> wrong tree.
>
> You are pointing fingers at splice().
>
> And I think that's wrong.
>
> We should point the fingers at either the _user_ of splice - as Jeremy
> Allison has done a couple of times - or we should point it at the sink
> that cannot deal with unstable sources.
>
> Because that whole "source is unstable" is what allows for that higher
> performance. The moment you start requiring stability, you _will_ lose
> it. You will have to lock the page, you'll have to umap it from any
> shared mappings, etc etc.  And even if there are no writers, or no
> current mappers, all that effort to make sure that is the case is
> actually fairly expensive.

...

> Because I really think that your "strict splice" model would just mean
> that now the kernel would have to add not just a memcpy, but also a
> new allocation for that new stable buffer for the memcpy, and that
> would all just be very very pointless.
>
> Alternatively, it would require some kind of nasty hard locking
> together with other limitations on what can be done by non-splice
> users.

I could be wrong, but I don't think any of this is necessary.  My
strict splice isn't intended to be any more stable than current splice
-- it's intended to complete more slowly and more informatively.  Now
maybe I'm wrong and the impleentation would be nasty, but I think that
the only bookkeeping needed is to arrange strict-splice to not
complete until the kernel is done with the source's page cache.  The
use of the source is refcounted already, and a bit of extra work might
be needed to track which strict-splice the reference came from, but
unless I've missed something, it's not crazy.

Looking at the current splice implementaiton, a splice that isn't
"strictly completed" is sort of represented by a struct pipe_buffer (I
think).  The actual implementation of strict-splice might consist of
separating pipe_buffer out from a pipe and adding an io_kiocb* and a
refcount to it.  Or maybe even just adding an io_kiocb* and making the
existing refcouting keep also track the io_kiocb*, but that might be
complicated.  This all boils down to tracking an actual splice all the
way through its lifecycle and not reporting it as done until it's all
the way done.  Anything else is icing on the cake, no?

There is absolutely no need to lock files or make page-cache pages
immutable or anything like that.

i think this is almost exactly what Jeremy and Stefan are asking for
re: notification when the system is done with a zero-copy send:

> What might be helpful in addition would be some kind of
notification that all pages are no longer used by the network
layer, IORING_OP_SENDMSG_ZC already supports such a notification,
maybe we can build something similar.

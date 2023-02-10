Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002A9692570
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 19:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjBJShZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 13:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjBJShY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 13:37:24 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467D72D177
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 10:37:22 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y1so5949714wru.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 10:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=45HS3XcRsfRS5VbZ2TiXDHQBLKSDRISNQErTXQPnH+g=;
        b=fA28mHicQVXU0rc9eizNL3RpJL4UanQ9gfQOBZ57SNqi5RpYK6zoS094B9dEWMLQUJ
         VDR5+QKCsCoY483JdS84PYO+YawCsU7ivhQXQygIuTrEgqYgXEUqNL9o00YmCoBr4cj0
         8loINQ8lMH5qSDzADuKONPbLiCHUOVpr3CWx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45HS3XcRsfRS5VbZ2TiXDHQBLKSDRISNQErTXQPnH+g=;
        b=pL5rNVQmNA5aXBy8gAkq2Qhx0IvBIaHQkj5awF0i/TiE4AbJFUMyYFcSipYWN1a5HP
         V0Tk7ypKFVCtwV/S76tslCletBN5ZTm68uPzdxftWdL+xfN0NfTnOSdnDvPthRHHgDt8
         oqhFuhJhdul0vRXBSHEajOubxrGtZJFIsPc/BEPtAMOmMo5joGqtFdqpkBWl3iW/jq37
         IHRRAGVk4+QSPUvl2iSn4DcG6KgC1C+E96AZWg1Og/AGkrR8bXny53/K41lDx4BYl00H
         965DFyj5qnVb6kMlTCGghlSkbRFzKUA0lwZ0q1SogJN9sgaE/AygxqQVkopVl/6gCjJ5
         N8rw==
X-Gm-Message-State: AO0yUKVmaOZMdd+NOd1r5ViyqJl7SSLbCbU7do1xb+8UWVbeJ9oRQyMg
        RoE3ZUvZu1XjuelfMtP+PU166d3bO3fqonREcOU=
X-Google-Smtp-Source: AK7set/NmxgjiEZOFkqY4Re9vqB1kvnA1eiZhYTp/uCbrub/4tePtnRMVUK5AfCGK11hySDDdYgHdQ==
X-Received: by 2002:adf:f484:0:b0:2c3:e34d:a331 with SMTP id l4-20020adff484000000b002c3e34da331mr15542124wro.36.1676054240418;
        Fri, 10 Feb 2023 10:37:20 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id v5-20020adfe4c5000000b002c549b91c54sm2223899wrm.52.2023.02.10.10.37.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 10:37:19 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id r3so5386234edq.13
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 10:37:19 -0800 (PST)
X-Received: by 2002:a50:f61e:0:b0:4ab:168c:dbd7 with SMTP id
 c30-20020a50f61e000000b004ab168cdbd7mr1816109edn.5.1676054239147; Fri, 10 Feb
 2023 10:37:19 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org> <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com> <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
In-Reply-To: <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 10:37:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
Message-ID: <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
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

On Fri, Feb 10, 2023 at 9:57 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> I am saying exactly what I meant.  Obviously mutable data exists.  I'm
> saying that *putting it in a pipe* *while it's still mutable* is not
> good.  Which implies that I don't think splice() is good.  No offense.

No offense at all. As mentioned, I have grown to detest splice over the years.

That said, in defense of splice(), it really does solve a lot of
conceptual problems.

And I still think that conceptually it's absolutely lovely in *theory*.

And part of it is very much the fact that pipes are useful and have
the infrastructure for other things. So you can mix regular read/write
calls with splice, and it actually makes sense. One of the design
goals was for things like static http, where you don't really send out
just file contents, there's a whole header to it as well.

So it's not just a specialized "send file contents to network", it's a
"you can do a write() call to start filling the pipe buffer with the
http header, then a splice() to start filling the file data".

And it was also designed to allow other sources, notably things like
video capture cards etc. And very much multiple destinations (again,
media accelerators).

So it all "makes sense" conceptually as a generic pipe (sic) between
different sources and sinks. And again, using a pipe as the mechanism
then also makes perfect sense in a historical Unix context of
"everything is a pipe".

But.

The above just tries to make sense of the design, and excuses for it.
I want to re-iterate that I think it's all lovely and coherent
conceptually. But in practice, it's just a huge pain.

The same way "everything is a pipeline of processes" is very much
historical Unix and very useful for shell scripting, but isn't
actually then normally very useful for larger problems, splice()
really never lived up to that conceptual issue, and it's just really
really nasty in practice.

But we're stuck with it.

I'm not convinced your suggestion of extending io_uring with new
primitives is any better in practice, though.

          Linus

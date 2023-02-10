Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D144F6928F8
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 22:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjBJVPE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 16:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjBJVPD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 16:15:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B30635B2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 13:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3121B61EAA
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 21:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C3AC433AC
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 21:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676063701;
        bh=drRLjPO4W8+vobf8j+babenJwUZfGHrCgtm3IJwcsus=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AGLnYFgLKy+YhfCfkM1bGCROGcCQSbUArwTWq/wrlakc11E9Us9MyNRJmPAa8be4D
         lbFY/87EwlQ+YO6rgQhZyF/JooJyUJxk32Sh+J2j8x/twmDH8GVy4iJB/+x42bO3qX
         d+k/JfTTH460RskhUBu8sqM+xDiV2ENLb4D/PU6HSt/JzgV8mHDD04/8VdDqaPmxqG
         LRPKsNv+dmazkmpKNFF+bbg9DHFNNp1JR/jE1Ke2R0qxATHDQNTpiCSa8shiMYc00u
         hjkyYF1hrmZ8jtEXwnqFhpcNDb+wZqB4WJB0GhoDeaIJ/x/M3fjnqvDIxn4e8GqfMj
         TPU2pvEAZAYUw==
Received: by mail-ej1-f54.google.com with SMTP id ml19so19228801ejb.0
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 13:15:01 -0800 (PST)
X-Gm-Message-State: AO0yUKX/H3YSex4D8ifMTyMosdgWN5erhhHobvXvSSFRrshlDjSRW6cS
        S7kINK141IuY5CBEZpMAXsazwmwcmEfO0eM/CLXJnw==
X-Google-Smtp-Source: AK7set9sEOO5ys4u7C/tRckoglukBzYmZj+BAQtrVtXnjQZf+0QEmL4y7t7SUVX2wYHEoZAGGzrKjZLjFthvZi/MV4U=
X-Received: by 2002:a17:906:fad2:b0:878:1431:2d03 with SMTP id
 lu18-20020a170906fad200b0087814312d03mr1667395ejb.0.1676063699709; Fri, 10
 Feb 2023 13:14:59 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <20230210040626.GB2825702@dread.disaster.area> <Y+XLuYh+kC+4wTRi@casper.infradead.org>
 <20230210065747.GD2825702@dread.disaster.area> <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk> <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk> <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
In-Reply-To: <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 10 Feb 2023 13:14:46 -0800
X-Gmail-Original-Message-ID: <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
Message-ID: <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 12:50 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/10/23 1:44=E2=80=AFPM, Linus Torvalds wrote:
> > On Fri, Feb 10, 2023 at 12:39 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Right, I'm referencing doing zerocopy data sends with io_uring, using
> >> IORING_OP_SEND_ZC. This isn't from a file, it's from a memory location=
,
> >> but the important bit here is the split notifications and how you
> >> could wire up a OP_SENDFILE similarly to what Andy described.
> >
> > Sure, I think it's much more reasonable with io_uring than with splice =
itself.
> >
> > So I was mainly just reacting to the "strict-splice" thing where Andy
> > was talking about tracking the page refcounts. I don't think anything
> > like that can be done at a splice() level, but higher levels that
> > actually know about the whole IO might be able to do something like
> > that.
> >
> > Maybe we're just talking past each other.
>
> Maybe slightly, as I was not really intending to comment on the strict
> splice thing. But yeah I agree on splice, it would not be trivial to do
> there. At least with io_uring we have the communication channel we need.
> And tracking page refcounts seems iffy and fraught with potential
> issues.
>

Hmm.

Are there any real-world use cases for zero-copy splice() that
actually depend on splicing from a file to a pipe and then later from
the pipe to a socket (or file or whatever)?  Or would everything
important be covered by a potential new io_uring operation that copies
from one fd directly to another fd?

Maybe I'm getting far ahead of myself.

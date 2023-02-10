Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E181B69264E
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjBJT2E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbjBJT2C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:28:02 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FB17E012;
        Fri, 10 Feb 2023 11:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=mJvEE36AdMeH3sIvvfWubmnVmU4slCx5aMtae9s80iE=; b=LJ8QZ6feDCvHew+AkUbWfDtlfl
        8RJc5UUKLvvifcHrKLNJbFZat0vqwYMk0bCk7Nwo6Cy43H+crmjQEw8Ape5Jq8863KK8RgysL4ESx
        muytWsRWCZj8CxUOlJTe/7xgt606cvWzuwZdDleIwAdgyflErcUJbYwIxjNNkQbRjbV+6H+6ehU+q
        LJh1BSLmMphQ90H9RTgiS3GDcdFqGoWczJKRTnQl0iQ5r2KJ+dLoD+d5e7QiTpQxG5K64GMzc9jn7
        tbIdHKP7WDLKnArjHAUdbmX4nDUasTDhtDI4GjwwQwP8CePGbLMoNIAQ2se2Dfqj24squHpcIUj9G
        IXkLS4Cd3oufwE3FRrpTSczWBdq4DfD8rj0rUU5lVqXMV/d/BdlKO4jV8qtnglT9K4opAKFtxQsdu
        kRr9aNZ2QgQMRCydDY2SO5AiWCB5suKDBd2kNlHbb0H8FSG4jecDa2mS1OHFRggws53Hro/BdBCdn
        aMjb7mbgBYd6ypqeubyWIgkz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQZ3r-00D3HT-6F; Fri, 10 Feb 2023 19:27:55 +0000
Date:   Fri, 10 Feb 2023 11:27:51 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+aat8sggTtgff+A@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org>
 <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <CAHk-=wjQZWMeQ9OgXDNepf+TLijqj0Lm0dXWwWzDcbz6o7yy_g@mail.gmail.com>
 <CALCETrWuRHWh5XFn8M8qx5z0FXAGHH=ysb+c6J+cqbYyTAHvhw@mail.gmail.com>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 11:18:05AM -0800, Linus Torvalds via samba-technical wrote:
>
>We should point the fingers at either the _user_ of splice - as Jeremy
>Allison has done a couple of times - or we should point it at the sink
>that cannot deal with unstable sources.
> ....
> - it sounds like the particular user in question (samba) already very
>much has a reasonable model for "I have exclusive access to this" that
>just wasn't used

Having said that, I just had a phone discussion with Ralph Boehme
on the Samba Team, who has been following along with this in
read-only mode, and he did point out one case I had missed.

1). Client opens file with a lease. Hurrah, we think we can use splice() !
2). Client writes into file.
3). Client calls SMB_FLUSH to ensure data is on disk.
4). Client reads the data just wrtten to ensure it's good.
5). Client overwrites the previously written data.

Now when client issues (4), the read request, if we
zero-copy using splice() - I don't think theres a way
we get notified when the data has finally left the
system and the mapped splice memory in the buffer cache
is safe to overwrite by the write (5).

So the read in (4) could potentially return the data
written in (5), if the buffer cache mapped memory has
not yet been sent out over the network.

That is certainly unexpected behavior for the client,
even if the client leased the file.

If that's the case, then splice() is unusable for
Samba even in the leased file case.

>   Maybe this thread raised some awareness of it for some people, but
>more realistically - maybe we can really document this whole issue
>somewhere much more clearly

Complete comprehensive documentation on this would
be extremely helpful (to say the least :-).

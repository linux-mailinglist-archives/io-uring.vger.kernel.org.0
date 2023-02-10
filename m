Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657D5692776
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjBJTyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjBJTys (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:54:48 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4291035B1;
        Fri, 10 Feb 2023 11:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=wB8iUoyhTPPw8oIGfgHrdWKWpi/z3O0LRA1cmDT3sZo=; b=kQ7wtexyyluIKMpJXEYni4zogw
        Gl052DWbYm6IHhH7ViW6onVe8MYr6F+LQe3xtv4K6dwve6EQOuKcSTBHCzYsGaDwtOeUK5QBm87Co
        RPyDA6DgflNAyXWUF/B1fIvBufxjdkG5ZGdUvKcOAcn0vMUVK+k+WFVljCfUSPdqkfkrxMGJ0JyJI
        Lg1/GSCbF3gsnK4v9OTqvsWIrfiMBFX1IpuStcFZivHg7KOOlZXs92ydH68VIUIH6vlFbT+P9k+wD
        EZACJFHjP639uSdqZb6BHTXtWiZCQ7iflJ6lmWfzhJGJGyygGrGil7X8P6u4HgtvxeB/3b9nEN8zs
        xABsYnIJQu7OCwXHGz5dTqUQ+A3rcpgHh8rgb5aN8auUeN6/ZS1TItFwQzZPSnItiej6tkPWlctLx
        PgIAEMzVjI0OOZKXINCMFKYM6XAIV/K+QWOsAKyD5XRvvfg7iSJO6ymfXBtXTqQ9Q1sQXmYnT3CWo
        MwFNWVSfcA3xbZCa5ecs880Y;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQZTo-00D3dc-HN; Fri, 10 Feb 2023 19:54:44 +0000
Message-ID: <e83b7763-daa7-af7f-ae4f-2886598ad9b0@samba.org>
Date:   Fri, 10 Feb 2023 20:54:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Allison <jra@samba.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
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
 <Y+aat8sggTtgff+A@jeremy-acer>
 <CAHk-=wgztjawo+nPjnJJdOe8rHcTYznD6u34TBzdstuTjpotbg@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAHk-=wgztjawo+nPjnJJdOe8rHcTYznD6u34TBzdstuTjpotbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 10.02.23 um 20:42 schrieb Linus Torvalds:
> On Fri, Feb 10, 2023 at 11:27 AM Jeremy Allison <jra@samba.org> wrote:
>>
>> 1). Client opens file with a lease. Hurrah, we think we can use splice() !
>> 2). Client writes into file.
>> 3). Client calls SMB_FLUSH to ensure data is on disk.
>> 4). Client reads the data just wrtten to ensure it's good.
>> 5). Client overwrites the previously written data.
>>
>> Now when client issues (4), the read request, if we
>> zero-copy using splice() - I don't think theres a way
>> we get notified when the data has finally left the
>> system and the mapped splice memory in the buffer cache
>> is safe to overwrite by the write (5).
> 
> Well, but we know that either:
> 
>   (a) the client has already gotten the read reply, and does the write
> afterwards. So (4) has already not just left the network stack, but
> actually made it all the way to the client.
> 
> OR
> 
>   (b) (4) and (5) clearly aren't ordered on the client side (ie your
> "client" is not one single thread, and did an independent read and
> overlapping write), and the client can't rely on one happening before
> the other _anyway_.
>
> So if it's (b), then you might as well do the write first, because
> there's simply no ordering between the two.  If you have a concurrent
> read and a concurrent write to the same file, the read result is going
> to be random anyway.

I guess that's true, most clients won't have a problem.

However in theory it's possible that client uses a feature
called compounding, which means two requests are batched on the
way to the server they are processed sequentially and the responses
are batched on the way back again.

But we already have detection for that and the existing code also avoids
sendfile() in that case.

metze

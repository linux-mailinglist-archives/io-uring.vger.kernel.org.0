Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6469271B
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjBJTny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjBJTnp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:43:45 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D43770C;
        Fri, 10 Feb 2023 11:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=CbB3d2PjMe4L8HXRGPzj+z4SVKmNX8v3M7gr2hTK0UQ=; b=cyijFghPs/6fu47ULVexryV74P
        XVSei/aSlTama2pxp80JLpfs/yMxuGC/l/3WpPKpfcM2cSPP2ond3dKQjM8QzxWgRWXErQ2UhfRcu
        DawxeXk9+wofZQ5eFkq/kcYlxOFurTfmV/97Bl+tFSNsSFbBIBZgtaHqJ/LWsbgZXcJkK9jwQpUZR
        0xvYUv0BjPgEJHsqo4/Ruj9AotCY9y0K7TB9HVe31thCtHHe2wZ3dWLQPEi7qfSfuLg6C1YQuRpZo
        xRJAuJ85JCElNv3kZczMSFzH/vKGjpfwLpiW7eP7FJARJ+r0p+RW/QdGT8p/OWkyqbcj+VOqOfO6o
        jVR/YtzQWqEdipqO0Va30ex/ZH0K+CKb50ky6s6B20ZbmtTTtvRgggjMGboFuEbzhrVvtcX5y64dN
        uiUKFAI0JOkuGtuh4+/BObBF5dE6X/p0bQWgwuYqYIuNPtHOV6X1gLRPDjOYEvsRziR87/l4vSqPO
        1L4vT94nl9IbdcNZeIjCuKvo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQZHZ-00D3Ui-V3; Fri, 10 Feb 2023 19:42:06 +0000
Message-ID: <58e7e5d1-c231-a9cf-6d72-47a96c4285b3@samba.org>
Date:   Fri, 10 Feb 2023 20:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
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
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Y+aat8sggTtgff+A@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 10.02.23 um 20:27 schrieb Jeremy Allison:
> On Fri, Feb 10, 2023 at 11:18:05AM -0800, Linus Torvalds via samba-technical wrote:
>>
>> We should point the fingers at either the _user_ of splice - as Jeremy
>> Allison has done a couple of times - or we should point it at the sink
>> that cannot deal with unstable sources.
>> ....
>> - it sounds like the particular user in question (samba) already very
>> much has a reasonable model for "I have exclusive access to this" that
>> just wasn't used
> 
> Having said that, I just had a phone discussion with Ralph Boehme
> on the Samba Team, who has been following along with this in
> read-only mode, and he did point out one case I had missed.
> 
> 1). Client opens file with a lease. Hurrah, we think we can use splice() !
> 2). Client writes into file.
> 3). Client calls SMB_FLUSH to ensure data is on disk.
> 4). Client reads the data just wrtten to ensure it's good.
> 5). Client overwrites the previously written data.
> 
> Now when client issues (4), the read request, if we
> zero-copy using splice() - I don't think theres a way
> we get notified when the data has finally left the
> system and the mapped splice memory in the buffer cache
> is safe to overwrite by the write (5).
> 
> So the read in (4) could potentially return the data
> written in (5), if the buffer cache mapped memory has
> not yet been sent out over the network.
> 
> That is certainly unexpected behavior for the client,
> even if the client leased the file.
> 
> If that's the case, then splice() is unusable for
> Samba even in the leased file case.

I think we just need some coordination in userspace.

What might be helpful in addition would be some kind of
notification that all pages are no longer used by the network
layer, IORING_OP_SENDMSG_ZC already supports such a notification,
maybe we can build something similar.

>>   Maybe this thread raised some awareness of it for some people, but
>> more realistically - maybe we can really document this whole issue
>> somewhere much more clearly
> 
> Complete comprehensive documentation on this would
> be extremely helpful (to say the least :-).

Yes, good documentation is always good :-)

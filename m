Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56535691116
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjBITRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 14:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjBITRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 14:17:14 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D3093F9;
        Thu,  9 Feb 2023 11:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=uyuS50vZlHGk1xF8iynXmse5jo9/UIHiJy4O4eY3ZgY=; b=if8hFpG9EdXiPs0+56kdShigN0
        m07Oxr9hsWdLL1IgEA7zbrDUNQNH93MPtMFlfyuUduoqhzUIdok9lVzpfLYOc1OJApHeLMMrzyd9T
        pfHqcvasAnxr0JSvNozSSHeo4CfyZDdh8QoiPd+0iLrUtTjvl8qqlx0LmVGNydWQHr13HSjDjD/HC
        Jvm+RoDceZrLi8mL2Xu5ZWacU5Onyz1ktUaqz5TfUIJ9s/9rsHKIeCHCn5ly7EhsIvDVFAoZo5DQl
        BdDJKc6yyOPvuGw7ZCdXx36W4hnuzlESLA1zsdWzUilFX1PaE/FzAwMJv3k2DIb0mKL4HY2qdIKNJ
        6rzb7DL2RGQlybkez6OcRxe8/NNnfopXrURMkNkjZKb8JlY0q/E5DV6L+GB2uEMFYcd4640Z9onzo
        hYkOZxGGSEIfq6laocAMCjKzmnpEnCASwMjUwblNuSiKVwHV6LB5DDPbmf8T5mRQJMR60sR3yk4uc
        2sJi2tZt8YacNuC/nhSTbN3U;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQCPp-00CrYI-JG; Thu, 09 Feb 2023 19:17:05 +0000
Message-ID: <f6c6d42e-337a-bbab-0d36-cfcc915d26c6@samba.org>
Date:   Thu, 9 Feb 2023 20:17:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
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

Hi Linus,

> Adding Jens, because he's one of the main splice people. You do seem
> to be stepping on his work ;)
> 
> Jens, see
> 
>    https://lore.kernel.org/lkml/0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org

Ok, thanks! Maybe Jens should apear in the output of:

scripts/get_maintainer.pl fs/splice.c

> On Thu, Feb 9, 2023 at 5:56 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> So we have two cases:
>>
>> 1. network -> socket -> splice -> pipe -> splice -> file -> storage
>>
>> 2. storage -> file -> splice -> pipe -> splice -> socket -> network
>>
>> With 1. I guess everything can work reliable [..]
>>
>> But with 2. there's a problem, as the pages from the file,
>> which are spliced into the pipe are still shared without
>> copy on write with the file(system).
> 
> Well, honestly, that's really the whole point of splice. It was
> designed to be a way to share the storage data without having to go
> through a copy.


>> I'm wondering if there's a possible way out of this, maybe triggered by a new
>> flag passed to splice.
> 
> Not really.
> 
> So basically, you cannot do "copy on write" on a page cache page,
> because that breaks sharing.
> 
> You *want* the sharing to break, but that's because you're violating
> what splice() was for, but think about all the cases where somebody is
> just using mmap() and expects to see the file changes.
> 
> You also aren't thinking of the case where the page is already mapped
> writably, and user processes may be changing the data at any time.

I do because we're using that in our tdb library, but I hoped there would be
a way out...

>> I looked through the code and noticed the existence of IOMAP_F_SHARED.
> 
> Yeah, no. That's a hacky filesystem thing. It's not even a flag in
> anything core like 'struct page', it's just entirely internal to the
> filesystem itself.

Ok, I guess it's used for shared blocks in the filesystems,
in order to support things like cow support in order to allow
snapshots, correct?

>> Is there any other way we could archive something like this?
> 
> I suspect you simply want to copy it at splice time, rather than push
> the page itself into the pipe as we do in copy_page_to_iter_pipe().
> 
> Because the whole point of zero-copy really is that zero copy. And the
> whole point of splice() was to *not* complicate the rest of the system
> over-much, while allowing special cases.
> 
> Linux is not the heap of bad ideas that is Hurd that does various
> versioning etc, and that made copy-on-write a first-class citizen
> because it uses the concept of "immutable mapped data" for reads and
> writes.

Ok, thanks very much for the detailed feedback!

> Now, I do see a couple of possible alternatives to "just create a stable copy".
> 
> For example, we very much have the notion of "confirm buffer data
> before copying". It's used for things like "I started the IO on the
> page, but the IO failed with an error, so even though I gave you a
> splice buffer, it turns out you can't use it".
> 
> And I do wonder if we could introduce a notion of "optimistic splice",
> where the splice works exactly the way it does now (you get a page
> reference), but the "confirm" phase could check whether something has
> changed in that mapping (using the file versioning or whatever - I'm
> hand-waving) and simply fail the confirm.
> 
> That would mean that the "splice to socket" part would fail in your
> chain, and you'd have to re-try it. But then the onus would be on
> *you* as a splicer, not on the rest of the system to fix up your
> special case.
> 
> That idea sounds fairly far out there, and complicated and maybe not
> usable. So I'm just throwing it out as a "let's try to think of
> alternative solutions".

That sounds complicated and still racy.

Any comment about the idea of having a preadv2() flag that
asks for a dma copy with something like async_memcpy() instead
of the default that ends up in copy_user_enhanced_fast_string()?
If that would be possible, a similar flag would also be possible
for splice() in order to dma copy the pages into the pipe.

metze

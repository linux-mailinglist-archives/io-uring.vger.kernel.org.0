Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA78574E8D4
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjGKIRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 04:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjGKIRX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 04:17:23 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA9EE6A
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 01:17:22 -0700 (PDT)
Message-ID: <7b47fd90-5db5-ec52-8ac2-59ac54c38acb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689063439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AslcQWlNvQ734Fm57fmSpyEgWucxQ3TgbSH4k4BXqJI=;
        b=MDxkELzVKjJJclg/hkISwerR8TPB+gZ9HOWYycPfDwXoo7tVwVF6rlncreKHLLKlXT7dvM
        tFGRpJtvHAKhtJB1SQXivk6aVWfvwAOzE/wbKkVMN4eJw3088Hlcdm4P8wwHLV2QA6/fKr
        3mnAO1TNpjaWtji73nnx6cUsbawdAQk=
Date:   Tue, 11 Jul 2023 16:17:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
References: <ZG0slV2BhSZkRL_y@codewreck.org> <ZG0qgniV1DzIbbzi@codewreck.org>
 <20230524-monolog-punkband-4ed95d8ea852@brauner>
 <ZG6DUfdbTHS-e5P7@codewreck.org>
 <20230525-funkanstalt-ertasten-a43443d045c8@brauner>
 <ZG8_su9Pq1oI-t5s@codewreck.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZG8_su9Pq1oI-t5s@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/23 19:00, Dominique Martinet wrote:
> Christian Brauner wrote on Thu, May 25, 2023 at 11:22:08AM +0200:
>>> What was confusing is that default_llseek updates f_pos under the
>>> inode_lock (write), and getdents also takes that lock (for read only in
>>> shared implem), so I assumed getdents also was just protected by this
>>> read lock, but I guess that was a bad assumption (as I kept pointing
>>> out, a shared read lock isn't good enough, we definitely agree there)
>>>
>>>
>>> In practice, in the non-registered file case io_uring is also calling
>>> fdget, so the lock is held exactly the same as the syscall and I wasn't
>>
>> No, it really isn't. fdget() doesn't take f_pos_lock at all:
>>
>> fdget()
>> -> __fdget()
>>     -> __fget_light()
>>        -> __fget()
>>           -> __fget_files()
>>              -> __fget_files_rcu()
> 
> Ugh, I managed to not notice that I was looking at fdget_pos and that
> it's not the same as fdget by the time I wrote two paragraphs... These
> functions all have too many wrappers and too similar names for a quick
> look before work.
> 
>> If that were true then any system call that passes an fd and uses
>> fdget() would try to acquire a mutex on f_pos_lock. We'd be serializing
>> every *at based system call on f_pos_lock whenever we have multiple fds
>> referring to the same file trying to operate on it concurrently.
>>
>> We do have fdget_pos() and fdput_pos() as a special purpose fdget() for
>> a select group of system calls that require this synchronization.
> 
> Right, that makes sense, and invalidates everything I said after that
> anyway but it's not like looking stupid ever killed anyone.
> 
> Ok so it would require adding a new wrapper from struct file to struct
> fd that'd eventually take the lock and set FDPUT_POS_UNLOCK for... not
> fdput_pos but another function for that stopping short of fdput...
> Then just call that around both vfs_llseek and vfs_getdents calls; which
> is the easy part.
> 
> (Or possibly call mutex_lock directly like Dylan did in [1]...)
> [1] https://lore.kernel.org/all/20220222105504.3331010-1-dylany@fb.com/T/#m3609dc8057d0bc8e41ceab643e4d630f7b91bde6
> 
> 
> 
> I'll be honest though I'm thankful for your explanations but I think
> I'll just do like Stefan and stop trying for now: the only reason I've
> started this was because I wanted to play with io_uring for a new toy
> project and it felt awkward without a getdents for crawling a tree; and
> I'm long past the point where I should have thrown the towel and just
> make that a sequential walk.
> There's too many "conditional patches" (NOWAIT, end of dir indicator)
> that I don't care about and require additional work to rebase
> continuously so I'll just leave it up to someone else who does care.
> 
> So to that someone: feel free to continue from these branches (I've
> included the fix for kernfs_fop_readdir that Dan Carpenter reported):
> https://github.com/martinetd/linux/commits/io_uring_getdents
> https://github.com/martinetd/liburing/commits/getdents
> 
> Or just start over, there's not that much code now hopefully the
> baseline requirements have gotten a little bit clearer.
> 
> 
> Sorry for stirring the mess and leaving halfway, if nobody does continue
> I might send a v3 when I have more time/energy in a few months, but it
> won't be quick.
> 

Hi Dominique,

I'd like to take this if you don't mind.

Regards,
Hao


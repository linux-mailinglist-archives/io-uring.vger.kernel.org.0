Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186C675171D
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 06:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjGMEFR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 00:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjGMEFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 00:05:15 -0400
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E26C11D
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 21:05:12 -0700 (PDT)
Message-ID: <bb89b1f8-dfdc-8912-b874-d552bc4b5f9d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689221110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ph9Ck/PuFebLrZhoZJHiE3YNA72DjZg/eGCYgzyMfNA=;
        b=CddY4VDjuBYecZAVuxPDV38zFdG57nne3BZPdfEZGLlMb+IU/IR84ivcMthAZ+3iTsjt1d
        bz13OVyRe0C6VYcIX1aUelqPgXO8mUetLZsjG6f7IbrHFmTczPmPn0neNbAO6G9s8E269O
        ZhuplWJIPHgAsrvI17tm1I1IG53Wg1w=
Date:   Thu, 13 Jul 2023 12:05:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev> <ZK1H568bvIzcsB6J@codewreck.org>
 <858c3f16-ffb3-217e-b5d6-fcc63ef9c401@linux.dev>
 <ZK7QgRyUIHNC8Nk6@codewreck.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK7QgRyUIHNC8Nk6@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 7/13/23 00:10, Dominique Martinet wrote:
> Hao Xu wrote on Wed, Jul 12, 2023 at 03:53:24PM +0800:
>>>> +		if (file_count(file) > 1)
>>> I was curious about this so I found it's basically what __fdget_pos does
>>> before deciding it should take the f_pos_lock, and as such this is
>>> probably correct... But if someone can chime in here: what guarantees
>>> someone else won't __fdget_pos (or equivalent through this) the file
>>> again between this and the vfs_getdents call?
>>> That second get would make file_count > 1 and it would lock, but lock
>>> hadn't been taken here so the other call could get the lock without
>>> waiting and both would process getdents or seek or whatever in
>>> parallel.
>>>
>> This file_count(file) is atomic_read, so I believe no race condition here.
> I don't see how that helps in the presence of another thread getting the
> lock after we possibly issued a getdents without the lock, e.g.
>
> t1 call io_uring getdents here
> t1 sees file_count(file) == 1 and skips getting lock
> t1 starts issuing vfs_getdents [... processing]
> t2 calls either io_uring getdents or getdents64 syscall
> t2 gets the lock, since it wasn't taken by t1 it can be obtained
> t2 issues another vfs_getdents
>
> Christian raised the same issue so I'll leave this to his part of the
> thread for reply, but I hope that clarified my concern.


Hi Dominique,

Ah, I misunderstood your question, sorry. The thing is f_count is 
init-ed to be 1,

and normal uring requests do fdget first, so I think it's ok for normal 
requests.

What Christian points out is issue with fixed file, that is indeed a 
problem I think.


>
> -----
>
> BTW I forgot to point out: this dropped the REWIND bit from my patch; I
> believe some form of "seek" is necessary for real applications to make
> use of this (for example, a web server could keep the fd open in a LRU
> and keep issuing readdir over and over again everytime it gets an
> indexing request); not having rewind means it'd need to close and
> re-open the fd everytime which doesn't seem optimal.
>
> A previous iteration discussed that real seek is difficult and not
> necessarily needed to I settled for rewind, but was there a reason you
> decided to stop handling that?
>
> My very egoistical personal use case won't require it, so I can just say
> I don't care here, but it would be nice to have a reason explained at
> some point


Yes, like Al pointed out, getdents with an offset is not the right way 
to do it,

So a way to do seek is a must. But like what I said in the cover-letter, 
I do think the right thing is to

import lseek/llseek to io_uring, not increment the complex of getdents.


Thanks,

Hao



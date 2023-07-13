Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B845D751738
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 06:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjGMENE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 00:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjGMEND (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 00:13:03 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044882114
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 21:13:01 -0700 (PDT)
Message-ID: <57d4290a-af9a-a89e-65ba-ff40128dd28b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689221580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvnNbbg1uOPl7q8YQ68OFUhq3BAunFk1oOhFS//Nlyc=;
        b=o5szIK81hkeLKLUiZMEwuujMWKxfXWe7a4I1wsTMK6lwEqz18v2ZWEOuJoDURwVVMomFCS
        4fCTvp+mOnGwvJ1Z6l0+LM/sr77I97ZM9KOqITYBub1/j3VCaXkQxzKzUQbEF2IOW0ex+a
        V1phJ+8gYimTyeBCxCCSHczv3U8drhA=
Date:   Thu, 13 Jul 2023 12:12:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] vfs_getdents/struct dir_context: add flags field
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-3-hao.xu@linux.dev>
 <20230712-halbleiter-weder-35e042adcb30@brauner>
 <ZK7OeEmsHAU7xSxQ@codewreck.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK7OeEmsHAU7xSxQ@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Hi Christian and Dominique,


On 7/13/23 00:02, Dominique Martinet wrote:
> (replying as that was my code)
>
> Christian Brauner wrote on Wed, Jul 12, 2023 at 01:31:57PM +0200:
>> On Tue, Jul 11, 2023 at 07:40:26PM +0800, Hao Xu wrote:
>>> diff --git a/fs/readdir.c b/fs/readdir.c
>>> index 9592259b7e7f..b80caf4c9321 100644
>>> --- a/fs/readdir.c
>>> +++ b/fs/readdir.c
>>> @@ -358,12 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
>>>    * @file    : pointer to file struct of directory
>>>    * @dirent  : pointer to user directory structure
>>>    * @count   : size of buffer
>>> + * @flags   : additional dir_context flags
>> Why do you need that flag argument. The ->iterate{_shared}() i_op gets
>> passed the file so the filesystem can check
>> @file->f_mode & FMODE_NOWAIT, no?
> As far as I understand it, it's not because the fd is capable of NOWAIT
> that uring will call it in NOWAIT mode:
> - if the first getdents call returned -EAGAIN it'll also fall back to
> waiting in a separate thread (there's no "getdents poll" implementation,
> so there's no other way of rescheduling a non-blocking call)
> - it's also possible for the user to specify it wants IOSQE_ASYNC in the
> sqe->flags (admitedly I'm not sure why would anyone do this, but that's
> useful for benchmarks at least -- it skips the initial NOWAIT call
> before falling back to threaded waiting call)
>
> Even outsides of io_uring, a call to getdents64 should block, so even if
> the filesystem supports non-blocking it should be explicitely required
> by the caller.


Hi Christian,

My understanding of FMODE_NOWAIT is "this file support nowait IO". Just 
like what Dominique

said, io_uring issue a request two rounds(let's simplify it here since 
no apoll or task work involved),

and the first round is  a nowait/nonblock try, the second one is an 
offload-ed block try. So besides

a "ability" flag(FMODE_NOWAIT), we still need a "one-round" flag to 
point out that "we do need to

do nowait IO this time".


>
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -1719,8 +1719,16 @@ typedef bool (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64,
>>>   struct dir_context {
>>>   	filldir_t actor;
>>>   	loff_t pos;
>>> +	unsigned long flags;
>>>   };
>>>   
>>> +/*
>>> + * flags for dir_context flags
>>> + * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
>>> + *                       (requires file->f_mode & FMODE_NOWAIT)
>>> + */
>>> +#define DIR_CONTEXT_F_NOWAIT	(1 << 0)
>> Even if this should be needed, I don't think this needs to use a full
>> flags field.
> I also got a request to somehow pass back "are there more entries to
> read after this call" to the caller in my v1, and I had done this as a
> second flag -- in general my understanding was that it's better to add
> flags than a specific boolean for extensibility but I have no opinon
> here.


I've no strong opinion here, I kept it here as a flag variable to make it

more extendable in the future.


Thanks,

Hao


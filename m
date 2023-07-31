Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73A4768EEC
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjGaHgT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 03:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjGaHgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 03:36:05 -0400
Received: from out-89.mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D723A1AE
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 00:35:00 -0700 (PDT)
Message-ID: <226c7361-4bea-c7e6-dd5c-9c6c3f2c3134@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690788898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNwA0lOJA1yVDPpYoCCWcFCqvM0VcrljMUoZbllsh7w=;
        b=ssQz+YchmAJneDWQdy7a9egTe9bBkzTfYhPMqefz3BhOVRAsTPVPcHq8BzjlNgtilhTvem
        BjwhtOCDY/5ecSLGdPIVgIbmU8VgakMeUAJScXTUPdRB2t8LUj2vZAud/SXv3DKUeb4JML
        ZcN0h313j9bafxT5Y4L1PGyY26lKTjA=
Date:   Mon, 31 Jul 2023 15:34:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, djwong@kernel.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        josef@toxicpanda.com
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
 <20230727-westen-geldnot-63435c2f65ad@brauner>
 <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
 <20230727-daran-abtun-4bc755f668ad@brauner>
 <ZMcVWj9GfcHol3xG@dread.disaster.area>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZMcVWj9GfcHol3xG@dread.disaster.area>
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

On 7/31/23 09:58, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 06:28:52PM +0200, Christian Brauner wrote:
>> On Thu, Jul 27, 2023 at 05:17:30PM +0100, Pavel Begunkov wrote:
>>> On 7/27/23 16:52, Christian Brauner wrote:
>>>> On Thu, Jul 27, 2023 at 04:12:12PM +0100, Pavel Begunkov wrote:
>>>> It would also solve it for writes which is what my kiocb_modified()
>>>> comment was about. So right now you have:
>>>
>>> Great, I assumed there are stricter requirements for mtime not
>>> transiently failing.
>>
>> But I mean then wouldn't this already be a problem today?
>> kiocb_modified() can error out with EAGAIN today:
>>
>>            ret = inode_needs_update_time(inode, &now);
>>            if (ret <= 0)
>>                    return ret;
>>            if (flags & IOCB_NOWAIT)
>>                    return -EAGAIN;
>>
>>            return __file_update_time(file, &now, ret);
>>
>> the thing is that it doesn't matter for ->write_iter() - for xfs at
>> least - because xfs does it as part of preparatory checks before
>> actually doing any real work. The problem happens when you do actual
>> work and afterwards call kiocb_modified(). That's why I think (2) is
>> preferable.
> 
> This has nothing to do with what "XFS does". It's actually an
> IOCB_NOWAIT API design constraint.
> 
> That is, IOCB_NOWAIT means "complete the whole operation without
> blocking or return -EAGAIN having done nothing".  If we have to do
> something that might block (like a timestamp update) then we need to
> punt the entire operation before anything has been modified.  This
> requires all the "do we need to modify this" checks to be done up
> front before we start modifying anything.
> 
> So while it looks like this might be "an XFS thing", that's because
> XFS tends to be the first filesystem that most io_uring NOWAIT
> functionality is implemented on. IOWs, what you see is XFS is doing
> things the way IOCB_NOWAIT requires to be done. i.e. it's a
> demonstration of how nonblocking filesystem modification operations
> need to be run, not an "XFS thing"...
> 
>>>> I would prefer 2) which seems cleaner to me. But I might miss why this
>>>> won't work. So input needed/wanted.
>>>
>>> Maybe I didn't fully grasp the (2) idea
>>>
>>> 2.1: all read_iter, write_iter, etc. callbacks should do file_accessed()
>>> before doing IO, which sounds like a good option if everyone agrees with
>>> that. Taking a look at direct block io, it's already like this.
>>
>> Yes, that's what I'm talking about. I'm asking whether that's ok for xfs
>> maintainers basically. i_op->write_iter() already works like that since
>> the dawn of time but i_op->read_iter doesn't and I'm proposing to make
>> it work like that and wondering if there's any issues I'm unaware of.
> 
> XFS already calls file_accessed() in the DIO read path before the
> read gets issued. I don't see any problem with lifting it to before

Hi Dave,

Here I've a question, in DIO read path, if we update the time but
later somehow got errors before actual reading, e.g. return -EAGAIN
from the xfs_ilock_iocb(), shouldn't we revert the time update since
we actually doesn't read the file? We can lazily update the time but
on the contrary a false update sounds weird to me.

Thanks,
Hao

> the copy-out loop in filemap_read() because it is run regardless of
> whether any data is read or any error occurred.  Hence it just
> doesn't look like it matters if it is run before or after the
> copy-out loop to me....
> 
> -Dave.


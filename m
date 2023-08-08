Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41320774061
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbjHHRCb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 13:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbjHHRBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 13:01:38 -0400
Received: from out-90.mta1.migadu.com (out-90.mta1.migadu.com [IPv6:2001:41d0:203:375::5a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F750618F
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 09:01:06 -0700 (PDT)
Message-ID: <aa13ae23-6774-47e5-2ec1-df318b3ec631@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691471914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1hLwhbgMiB46VRsdK6ZPDpF2fD9phVWFMSg/BLZBAs=;
        b=kulgTEcepp/+Y11Ckr3dDvaa8kfPhiPuZWdvf33hlsJtIZ7PkTLpLE9KByVnYSC3vwXgrP
        T6SihFJ/MFuxS9stHNXf/cZZz8Uk2a94JLPN5cBA/Z4zcDQtP9pFBLUxfGqTFGo4KGNi3Z
        3nyMLPIbxv3A+0UDPjmjr7bkTwvoL3c=
Date:   Tue, 8 Aug 2023 13:18:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
 <588ede3c-3de0-5469-735e-8c9fe4d52b6a@linux.dev>
In-Reply-To: <588ede3c-3de0-5469-735e-8c9fe4d52b6a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/23 12:34, Hao Xu wrote:
> On 8/1/23 08:28, Jens Axboe wrote:
>> On 7/31/23 9:26?AM, Darrick J. Wong wrote:
>>> I've watched quite a bit of NOWAIT whackamole going on over the past 
>>> few
>>> years (i_rwsem, the ILOCK, the IO layer, memory allocations...).  IIRC
>>> these filesystem ios all have to run in process context, right?  If so,
>>> why don't we capture the NOWAIT state in a PF flag?  We already do that
>>> for NOFS/NOIO memory allocations to make sure that /all/ reclaim
>>> attempts cannot recurse into the fs/io stacks.
>>
>> I would greatly prefer passing down the context rather than capitulating
>> and adding a task_struct flag for this. I think it _kind of_ makes sense
>> for things like allocations, as you cannot easily track that all the way
>> down, but it's a really ugly solution. It certainly creates more churn
>> passing it down, but it also reveals the parts that need to check it.
>> WHen new code is added, it's much more likely you'll spot the fact that
>> there's passed in context. For allocation, you end up in the allocator
>> anyway, which can augment the gfp mask with whatever is set in the task.
>> The same is not true for locking and other bits, as they don't return a
>> value to begin with. When we know they are sane, we can flag the fs as
>> supporting it (like we've done for async buffered reads, for example).
>>
>> It's also not an absolute thing, like memory allocations are. It's
>> perfectly fine to grab a mutex under NOWAIT issue. What you should not
>
> Hi Jens,
> To make sure, I'd like to ask, for memory allocation, GFP_NOIO semantics
> is all we need in NOWAIT issue, GFP_NOWAIT is not necessary, do I
> understand it right?
>
> Thanks,
> Hao


Trying to find a lock in mem allocation process that GFP_NOIO holds it while

other normal GFP_* like GFP_KERNEL also holds it and does IO.

Failed to find one such lock.  So I guess though GFP_NOIO may cause sleep

but won't wait on IO.





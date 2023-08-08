Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BFF773E9C
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjHHQdV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 12:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjHHQcL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 12:32:11 -0400
Received: from out-99.mta1.migadu.com (out-99.mta1.migadu.com [IPv6:2001:41d0:203:375::63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A573531013
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 08:51:56 -0700 (PDT)
Message-ID: <588ede3c-3de0-5469-735e-8c9fe4d52b6a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691469264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnHMX10bH6+mrf/dzTR81KlSjnm22TOl66PKR/tiy0Q=;
        b=nH5luNlLih8wuBeN5jkwDvqcSsBXrJhkU5ThzE1kc7gNo6M81QPNk+4ah62SFjwxeP/3qG
        6qbpsuhXxL7PveukVbwqqTi4cOtDrCBbz0ScuBIcQb1j5Oo56LVXdL5b48loDnTFetSkVj
        q0jURjOYP1350zbhjEzLMF6ceEu8TX4=
Date:   Tue, 8 Aug 2023 12:34:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 8/1/23 08:28, Jens Axboe wrote:
> On 7/31/23 9:26?AM, Darrick J. Wong wrote:
>> I've watched quite a bit of NOWAIT whackamole going on over the past few
>> years (i_rwsem, the ILOCK, the IO layer, memory allocations...).  IIRC
>> these filesystem ios all have to run in process context, right?  If so,
>> why don't we capture the NOWAIT state in a PF flag?  We already do that
>> for NOFS/NOIO memory allocations to make sure that /all/ reclaim
>> attempts cannot recurse into the fs/io stacks.
> 
> I would greatly prefer passing down the context rather than capitulating
> and adding a task_struct flag for this. I think it _kind of_ makes sense
> for things like allocations, as you cannot easily track that all the way
> down, but it's a really ugly solution. It certainly creates more churn
> passing it down, but it also reveals the parts that need to check it.
> WHen new code is added, it's much more likely you'll spot the fact that
> there's passed in context. For allocation, you end up in the allocator
> anyway, which can augment the gfp mask with whatever is set in the task.
> The same is not true for locking and other bits, as they don't return a
> value to begin with. When we know they are sane, we can flag the fs as
> supporting it (like we've done for async buffered reads, for example).
> 
> It's also not an absolute thing, like memory allocations are. It's
> perfectly fine to grab a mutex under NOWAIT issue. What you should not

Hi Jens,
To make sure, I'd like to ask, for memory allocation, GFP_NOIO semantics
is all we need in NOWAIT issue, GFP_NOWAIT is not necessary, do I
understand it right?

Thanks,
Hao

> do is grab a mutex that someone else can grab while waiting on IO. This
> kind of extra context is only available in the code in question, not
> generically for eg mutex locking.
> 
> I'm not a huge fan of the "let's add a bool nowait". Most/all use cases
> pass down state anyway, putting it in a suitable type struct seems much
> cleaner to me than the out-of-band approach of just adding a
> current->please_nowait.
> 


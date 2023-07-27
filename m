Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BC076536C
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjG0MSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 08:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjG0MSC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 08:18:02 -0400
Received: from out-94.mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425502D49
        for <io-uring@vger.kernel.org>; Thu, 27 Jul 2023 05:18:01 -0700 (PDT)
Message-ID: <ed5666f3-49bb-ea61-11fa-76933b83a20c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690460279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqZT7zoGfJAAPTxEP/DcDR8PWtA/DAK/DiY9d4IhqPc=;
        b=KVpyyqnAHDP1o6gwlzyV9EVtWyuH2FH2lKQsPUn36E28aCX0xvsIVSY6uKDQ8nhUUPlont
        jgEuEqwprTq10jQCihXBxA3twIWK7u6KtrCexJoDFjpXfoL0iMOvDFgrfeCjkoBULEbicT
        pijpsXtgKMckojXCHCsU0FgYPqCfox0=
Date:   Thu, 27 Jul 2023 20:17:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] xfs: add nowait support for xfs_seek_iomap_begin()
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-3-hao.xu@linux.dev>
 <ZMGWYyNz6SUTdRef@dread.disaster.area>
 <20230726221440.GB11352@frogsfrogsfrogs>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230726221440.GB11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/23 06:14, Darrick J. Wong wrote:
> On Thu, Jul 27, 2023 at 07:55:47AM +1000, Dave Chinner wrote:
>> On Wed, Jul 26, 2023 at 06:25:58PM +0800, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> To support nowait llseek(), IOMAP_NOWAIT semantics should be respected.
>>> In xfs, xfs_seek_iomap_begin() is the only place which may be blocked
>>> by ilock and extent loading. Let's turn it into trylock logic just like
>>> what we've done in xfs_readdir().
>>>
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> ---
>>>   fs/xfs/xfs_iomap.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>>> index 18c8f168b153..bbd7c6b27701 100644
>>> --- a/fs/xfs/xfs_iomap.c
>>> +++ b/fs/xfs/xfs_iomap.c
>>> @@ -1294,7 +1294,9 @@ xfs_seek_iomap_begin(
>>>   	if (xfs_is_shutdown(mp))
>>>   		return -EIO;
>>>   
>>> -	lockmode = xfs_ilock_data_map_shared(ip);
>>> +	lockmode = xfs_ilock_data_map_shared_generic(ip, flags & IOMAP_NOWAIT);
>>
>> What does this magic XFS function I can't find anywhere in this
>> patch set do?

Sorry, forgot to say, It was xfs_ilock_for_readdir() in io_uring
getdents patchset, I changed the name since it is now used for
lseek as well.

> 
> It's in (iirc) the io_uring getdents patchset that wasn't cc'd to
> linux-xfs and that I haven't looked at yet.
> 

Hi Darrick, I forwarded the xfs related patch in that series. Forgot to
cc xfs list at the beginning. I'll make xfs list be Cc-ed when sending
next version. Sorry for inconvenience.

Regards,
Hao

> --D
> 
>> -Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com

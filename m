Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F774FD9E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 05:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjGLDTP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 23:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjGLDTO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 23:19:14 -0400
Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC1A133
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 20:19:13 -0700 (PDT)
Message-ID: <27a718a5-f769-0b4d-ee59-7a4cb5b6c7ae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689131952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIkiaq2uLiM5bxojEf+Ng11I346EHe3gbxPIFNkD3u8=;
        b=mbP31bvM6Wu+9dXSHfUmJ7uvnMh3S4suFcoq3Izo2SAtDOdebsDTLuxlBJ1YIj8CjSYZpk
        h5tdd82gphH2SvNL5VTKrjqgs3JtRL6Wq43mBXzibtQvte8Rgn+ErM4bQ4jWN1GiBHNflb
        xOm7B75r0zgKp6F8Mab2f5cqzyLHUek=
Date:   Wed, 12 Jul 2023 11:19:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/3] io_uring getdents
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 07:47, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 07:40:24PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> This series introduce getdents64 to io_uring, the code logic is similar
>> with the snychronized version's. It first try nowait issue, and offload
>> it to io-wq threads if the first try fails.
>>
>>
>> v2->v3:
>>   - removed the kernfs patches
>>   - add f_pos_lock logic
>>   - remove the "reduce last EOF getdents try" optimization since
>>     Dominique reports that doesn't make difference
>>   - remove the rewind logic, I think the right way is to introduce lseek
>>     to io_uring not to patch this logic to getdents.
>>   - add Singed-off-by of Stefan Roesch for patch 1 since checkpatch
>>     complained that Co-developed-by someone should be accompanied with
>>     Signed-off-by same person, I can remove them if Stefan thinks that's
>>     not proper.
>>
>>
>> Dominique Martinet (1):
>>    fs: split off vfs_getdents function of getdents64 syscall
>>
>> Hao Xu (2):
>>    vfs_getdents/struct dir_context: add flags field
>>    io_uring: add support for getdents
> 
> So what filesystem actually uses this new NOWAIT functionality?
> Unless I'm blind (quite possibly) I don't see any filesystem
> implementation of this functionality in the patch series.
> 
> I know I posted a prototype for XFS to use it, and I expected that
> it would become part of this patch series to avoid the "we don't add
> unused code to the kernel" problem. i.e. the authors would take the
> XFS prototype, make it work, add support into for the new io_uring
> operation to fsstress in fstests and then use that to stress test
> the new infrastructure before it gets merged....
> 
> But I don't see any of this?
> 
> -Dave.

Hi Dave,
You are right, currently no real filesystem supports that from my 
investigation, I saw the xfs prototype, I'd like to make it work first.
That may cause some time.

Thanks,
Hao

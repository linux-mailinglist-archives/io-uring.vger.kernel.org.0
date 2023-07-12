Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCF74FD80
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 05:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjGLDMg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 23:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjGLDMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 23:12:33 -0400
Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [IPv6:2001:41d0:1004:224b::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626B710E3
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 20:12:32 -0700 (PDT)
Message-ID: <2e2afc83-ac1d-ab52-79c5-cb7c537cfcd9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689131550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLrNEUYM50f2mtC0bFeVJy+/kJ1y6MmF0pi4RVU6gNo=;
        b=K7TTDt29BV35qWoI2LUYGU9VqXNVmACuwUQ5VDr0LP3QPC2Gvr479NW1JnkwPumkMAv2Qy
        R2KiY+ZhQygHFziStt160BpjhJ+XBhCMcxR5TGBXDac2NhnBXOzbMQb8FXHQs96kyoDqJ+
        dc1TqKTouM/pAw0hr27kZ2KUZfRy1wQ=
Date:   Wed, 12 Jul 2023 11:12:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/3] io_uring getdents
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
 <5264f776-a5fd-4878-1b4c-7fe9f9a61b51@kernel.dk>
 <ZK35dZN7pYg0VuF0@codewreck.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK35dZN7pYg0VuF0@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 08:53, Dominique Martinet wrote:
> Jens Axboe wrote on Tue, Jul 11, 2023 at 05:51:46PM -0600:
>>> So what filesystem actually uses this new NOWAIT functionality?
>>> Unless I'm blind (quite possibly) I don't see any filesystem
>>> implementation of this functionality in the patch series.
> 
> I had implemented this for kernfs and libfs (so sysfs, debugfs, possibly
> tmpfs/proc?) in v2
> 
> The patch as of v2's mail has a bug, but my branch has it fixed as of
> https://github.com/martinetd/linux/commits/io_uring_getdents

I see, I'll try this, those in v2 causes issues when I boot my VM with them.

> 
> (I guess these aren't "real" enough though)
> 
>>> I know I posted a prototype for XFS to use it, and I expected that
>>> it would become part of this patch series to avoid the "we don't add
>>> unused code to the kernel" problem. i.e. the authors would take the
>>> XFS prototype, make it work, add support into for the new io_uring
>>> operation to fsstress in fstests and then use that to stress test
>>> the new infrastructure before it gets merged....
>>>
>>> But I don't see any of this?
>>
>> That would indeed be great if we could get NOWAIT, that might finally
>> convince me that it's worth plumbing up! Do you have a link to that
>> prototype? That seems like what should be the base for this, and be an
>> inspiration for other file systems to get efficient getdents via this
>> (rather than io-wq punt, which I'm not a huge fan of...).
> 
> the xfs poc was in this mail:
> https://lore.kernel.org/all/20230501071603.GE2155823@dread.disaster.area/
> 
> I never spent time debugging it, but it should definitely be workable
> 


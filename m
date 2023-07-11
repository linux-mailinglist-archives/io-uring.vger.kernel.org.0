Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EBC74FBF0
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 01:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGKXvu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 19:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGKXvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 19:51:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1A1711
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:51:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6831a5caf75so155489b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689119508; x=1689724308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o4REq7kilpHXiZpneOffBsYplM616hc32CrvrubBDsA=;
        b=lJQuhWctpXfnk3/dPLtuwqQRRtzHvulpWdsRoE5e1sGdkuVUhyMP27ho1JO5WKYZfr
         LvZxq6ukui/HDKzqb1J2PNxzmZlJTFEXtikeYFcf1MV1GM990MOE4d7+5U8/KJ9g2D2J
         4+CseTW4/mwHflK+17QWrvAvnejV/I7APZbaxR4eb7LrWpI/M1p4AGKbNdezCr+LWGiX
         RkX0QKD1ymuvlECC5EEkBV5Cv5NbDeg1PjZG83C/SUlcUTJe6N1gLO0GdT7J1UjAsFEz
         qS7/XsngvZaxOl0Nk7hJvxozPu11bUb9s9l44Kb1oV77yTE04suCwE7GyeeHJmU8Ot4V
         OG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689119508; x=1689724308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4REq7kilpHXiZpneOffBsYplM616hc32CrvrubBDsA=;
        b=fFsP1/1C1iAu2gAehSWNzwDoKVfgKRfrjGD0XYLCqsyfWQHEll+wUN9s8c1cdd8XM+
         OScu+9b39vO58+9ElLN9w4XOKYsAnt7MQVrcQFZsJs1wCmPJPbqDkCJp2NyGmMNRfoyt
         VtEqy9LVppxTM5DPjNROuALb1v2UeQ1DNIp6Z5r0SD0Ejdu5y64A0uHOeh0ufPcmZEiU
         pfnhk2YQ3D0l3dKVG+wGRWEXA8bb3PCJ+K3i/dZx207aRc5N/QJn79SF4T7yzXtkAi4L
         w8clPhTzKU7LMFQHiJe+l99zT3teMqkZq96smLbeV8fGQrChWxmZWCrPtBEjZrucvXSQ
         e0PA==
X-Gm-Message-State: ABy/qLapql8QKuGQ+ggJAyAzu18PMZEMjd7r5Wu1dJQy6Br9FpwNQHdI
        PQXqKmjTm3zxpmOnEZAdedZ6PQ==
X-Google-Smtp-Source: APBJJlGX71mOrsz5bbLV2nGS3M8gY110o8WgLxw97ns0uPO+jI0SsQoZpa0MafnlqqpYlJJkOyHe5g==
X-Received: by 2002:a05:6a00:1d96:b0:679:a1f1:a5f8 with SMTP id z22-20020a056a001d9600b00679a1f1a5f8mr18055360pfw.3.1689119508672;
        Tue, 11 Jul 2023 16:51:48 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c2-20020aa78c02000000b00673e652985bsm2255189pfd.118.2023.07.11.16.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 16:51:48 -0700 (PDT)
Message-ID: <5264f776-a5fd-4878-1b4c-7fe9f9a61b51@kernel.dk>
Date:   Tue, 11 Jul 2023 17:51:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 0/3] io_uring getdents
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 5:47?PM, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 07:40:24PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> This series introduce getdents64 to io_uring, the code logic is similar
>> with the snychronized version's. It first try nowait issue, and offload
>> it to io-wq threads if the first try fails.
>>
>>
>> v2->v3:
>>  - removed the kernfs patches
>>  - add f_pos_lock logic
>>  - remove the "reduce last EOF getdents try" optimization since
>>    Dominique reports that doesn't make difference
>>  - remove the rewind logic, I think the right way is to introduce lseek
>>    to io_uring not to patch this logic to getdents.
>>  - add Singed-off-by of Stefan Roesch for patch 1 since checkpatch
>>    complained that Co-developed-by someone should be accompanied with
>>    Signed-off-by same person, I can remove them if Stefan thinks that's
>>    not proper.
>>
>>
>> Dominique Martinet (1):
>>   fs: split off vfs_getdents function of getdents64 syscall
>>
>> Hao Xu (2):
>>   vfs_getdents/struct dir_context: add flags field
>>   io_uring: add support for getdents
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

That would indeed be great if we could get NOWAIT, that might finally
convince me that it's worth plumbing up! Do you have a link to that
prototype? That seems like what should be the base for this, and be an
inspiration for other file systems to get efficient getdents via this
(rather than io-wq punt, which I'm not a huge fan of...).

-- 
Jens Axboe


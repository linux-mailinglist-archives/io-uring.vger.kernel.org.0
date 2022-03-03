Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE034CC016
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 15:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiCCOhY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 09:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCCOhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 09:37:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC9618E41D
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 06:36:36 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id i1so4728136plr.2
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 06:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=7ha2vhYe4SlEUQPeZK8kubFrNEZ0JONdVksqeeye0po=;
        b=3D40VKgldclwRE+fBoW4RrKjtR4e8cZgVI4EKVIbyQPLFL7xaWjlQdFO7z0X4efFmu
         WF3KvdqiL6u1wPeN2Dept448T1iL8Z8TtwFGMZ5IQIo1uqYTDpHrE3RBf99sH/WPiIVj
         rxHZDyrGSx1vi+4rBiK58i0tzy4+aXz/nOgNhz6Gc8khpZWLY5oHj67nI63Fh8nFJs9z
         qnIJjTUz7CScwnjZcN5mKueNwU6MeCCwrtWi0K61M43RM0zN7+H8GEi0s/z3s/oPNSe7
         uf5RvAWO7X5Fw1zwUtWrpiKJ9onE0QWLbR82FePTNve+hrkhZj8NfewDq9AUWLGuDBcx
         4iTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7ha2vhYe4SlEUQPeZK8kubFrNEZ0JONdVksqeeye0po=;
        b=RuubrDfD5U3UJ4oG+uu35U3YNGu3y6CiNniGwx/pLDdRXTE40rKvojXjYcrq6ls8Gj
         r1nL+UfFm/m72+RXzYJFah0MIdzgQMEwPgE7X7I5Zu/BLecoJoKgq17YmxuU8L4xBIMl
         XalBONinDqPErTNB8TNkkE9DEMtu2/EsFXSn4sEn4jGwp0Vp2h4kS/Xm5/deCUib/Ly3
         uEmTp44dmcnNgXcVgczRUvH0u6zwwuoQNhWzivuTAPbeV+Assk6R9OybLWS90lxt7Dln
         O2rXmXzseZtLF6cu13HjRSppHif59J67c8O6QNKJFABhWJLSTRF2ya5B3ksRCjp54yq/
         mvuQ==
X-Gm-Message-State: AOAM533b3ng2DCCAQzGMGOkEwpYwePzBa7oYrdQOgfWya0mnnhKBTrD4
        gU9Dd3K38lT/6ADPWENd8CTBHNhiV2mmKg==
X-Google-Smtp-Source: ABdhPJw2D1IEzCsyYnDr1BKzo30MkcO+gTJ+2bfrG8X6Dgvdw1v9/bFxj6h5tRPFxbzNcybJ4WyrDg==
X-Received: by 2002:a17:90b:3e8c:b0:1bf:1170:3d with SMTP id rj12-20020a17090b3e8c00b001bf1170003dmr2408326pjb.191.1646318196076;
        Thu, 03 Mar 2022 06:36:36 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm2336516pgj.85.2022.03.03.06.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 06:36:35 -0800 (PST)
Message-ID: <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
Date:   Thu, 3 Mar 2022 07:36:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
In-Reply-To: <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 6:38 AM, Jens Axboe wrote:
> On 3/2/22 10:28 PM, Xiaoguang Wang wrote:
>> IORING_REGISTER_FILES is a good feature to reduce fget/fput overhead for
>> each IO we do on file, but still left one, which is io_uring_enter(2).
>> In io_uring_enter(2), it still fget/fput io_ring fd. I have observed
>> this overhead in some our internal oroutine implementations based on
>> io_uring with low submit batch. To totally remove fget/fput overhead in
>> io_uring, we may add a small struct file cache in io_uring_task and add
>> a new IORING_ENTER_FIXED_FILE flag. Currently the capacity of this file
>> cache is 16, wihcih I think it maybe enough, also not that this cache is
>> per-thread.
> 
> Would indeed be nice to get rid of, can be a substantial amount of time
> wasted in fdget/fdput. Does this resolve dependencies correctly if
> someone passes the ring fd? Adding ring registration to test/ring-leak.c
> from the liburing repo would be a useful exercise.

Seems to pass that fine, but I did miss on first read through that you
add that hook to files_cancel() which should break that dependency.

Since I think this is a potentially big win for certain workloads, maybe
we should consider making this easier to use? I don't think we
necessarily need to tie this to the regular file registration. What if
we instead added a SETUP flag for this, and just return the internal
offset for that case? Then we don't need an enter flag, we don't need to
add register/unregister opcodes for it.

This does pose a problem when we fill the array. We can easily go beyond
16 here, that's just an arbitrary limit, but at some point we do have to
handle the case where SETUP_REGISTERED (or whatever we call it) can't
get a slot. I think we just clear the flag and setup the fd normally in
that case. The user doesn't need to know, all the application needs to
are about is that it can use the passed back 'fd' to call the other
io_uring functions.

The only potential oddity here is that the fd passed back is not a
legitimate fd. io_uring does support poll(2) on its file descriptor, so
that could cause some confusion even if I don't think anyone actually
does poll(2) on io_uring.

What do you think?

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B1A50A1F3
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389085AbiDUOTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 10:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389099AbiDUOTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 10:19:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B07A3BBD6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 07:16:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so5341809pjf.0
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 07:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=rhYRlMJdKbatlOGE9qE2j3pT+oa7XCZ+FesqjZZD180=;
        b=E/lCbAmvgwuqZQL+YZzoIZftDhKM/oGvSDDe3bSwaT80j1ruxhPlSywB2J7/bDk8rq
         2zGbEYi+JNnI3vy/qL5dsYHmEXv7McjpQhTAf7GGoXjP0NFxtKyEWg6BIezwTrVTU204
         DXGH7XS9IqD2gCeVb+CUN2pRQvjI7T6Rbw01L8DzaPNy1Ak8hDlGRf10J2MHHvGnDHKK
         W9yS0WvTK+vNlnNrUNmJ543gGosJZxnWmJz1yfHi9cL78Li/6wX+VrIzsrBHzIyWKnW4
         4gzxjr0wnzGIjFsHK5fL29jmGWEWIc2hz+0iZJJlDTeqCHPR9BAjUBThk/aCzS09yarc
         uC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rhYRlMJdKbatlOGE9qE2j3pT+oa7XCZ+FesqjZZD180=;
        b=atqDl91T5wSdhT+e0zNiXWQZSMX+FQwbinNL1Mh/6c9GZm4+bNie3KjfFZm5uWn8d+
         6NNTGOhVOS+huL2Y7FwAOonfPxaNS0E8Af6XEDr7rJHgRlNVeh6ZirjO2bRr3p8mjvqh
         DUPPWpkZHRP8HIFMXnptRL73InehrdaBzy3QO7t5h16ZYl5+YvidqEW7WpkJVK1tjZRi
         yE38uTHfRWKqoiJlY5AopkFEGxr0/xIcnp/jLjv0PNT0JPtxYI3NtTeVa3Sz3+h3zZFs
         EKeRlGxPbGGr2dsqsn7ltgg6/oOz2HCQCj3JKRUEOOmTIesjWDmRc6rcJ8xVC1i4op+6
         6uHQ==
X-Gm-Message-State: AOAM532krt8w7QxFG/n6k+wF66fKfnPufziuI8cI9hbsy46qJ+8Gm8R9
        gbvsa8AvUhEMfSL+UJxIJrM=
X-Google-Smtp-Source: ABdhPJyLaY6ozjJYTtr+w4xIMVmuDjxcxd7nCvacagjgGZwO18H95MiUoopmmiacg0steuDI42Px0w==
X-Received: by 2002:a17:902:d543:b0:15a:4629:791b with SMTP id z3-20020a170902d54300b0015a4629791bmr4294409plf.40.1650550589895;
        Thu, 21 Apr 2022 07:16:29 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f771b48736sm25458536pfj.194.2022.04.21.07.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 07:16:29 -0700 (PDT)
Message-ID: <1ec0bd06-09bf-6f36-503e-46eb579d5736@gmail.com>
Date:   Thu, 21 Apr 2022 22:16:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

在 3.3.22 下午10:36, Jens Axboe 写道:
> On 3/3/22 6:38 AM, Jens Axboe wrote:
>> On 3/2/22 10:28 PM, Xiaoguang Wang wrote:
>>> IORING_REGISTER_FILES is a good feature to reduce fget/fput overhead for
>>> each IO we do on file, but still left one, which is io_uring_enter(2).
>>> In io_uring_enter(2), it still fget/fput io_ring fd. I have observed
>>> this overhead in some our internal oroutine implementations based on
>>> io_uring with low submit batch. To totally remove fget/fput overhead in
>>> io_uring, we may add a small struct file cache in io_uring_task and add
>>> a new IORING_ENTER_FIXED_FILE flag. Currently the capacity of this file
>>> cache is 16, wihcih I think it maybe enough, also not that this cache is
>>> per-thread.
>> Would indeed be nice to get rid of, can be a substantial amount of time
>> wasted in fdget/fdput. Does this resolve dependencies correctly if
>> someone passes the ring fd? Adding ring registration to test/ring-leak.c
>> from the liburing repo would be a useful exercise.
> Seems to pass that fine, but I did miss on first read through that you
> add that hook to files_cancel() which should break that dependency.
>
> Since I think this is a potentially big win for certain workloads, maybe
> we should consider making this easier to use? I don't think we
> necessarily need to tie this to the regular file registration. What if
> we instead added a SETUP flag for this, and just return the internal
> offset for that case? Then we don't need an enter flag, we don't need to
> add register/unregister opcodes for it.
[1]
>
> This does pose a problem when we fill the array. We can easily go beyond
> 16 here, that's just an arbitrary limit, but at some point we do have to
> handle the case where SETUP_REGISTERED (or whatever we call it) can't
> get a slot. I think we just clear the flag and setup the fd normally in
> that case. The user doesn't need to know, all the application needs to
> are about is that it can use the passed back 'fd' to call the other
> io_uring functions.
>
> The only potential oddity here is that the fd passed back is not a
> legitimate fd. io_uring does support poll(2) on its file descriptor,
[2]
> so
> that could cause some confusion even if I don't think anyone actually
> does poll(2) on io_uring.
>
> What do you think?

Can we use something like a heap based on the registered_rings arrray so 
that we can return the

real fd to the userspace meanwhilely. The disadvantage is the time cost 
is O(lgn) for each fd

registration/searching. Then we can achieve [1] and avoid [2].


Regards,

Hao

>

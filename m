Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A6460E62E
	for <lists+io-uring@lfdr.de>; Wed, 26 Oct 2022 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiJZRJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Oct 2022 13:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiJZRI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Oct 2022 13:08:58 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EB9F6C0E
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 10:08:56 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n191so4108370iod.13
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 10:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lYZpE8lGnFpdCamBUGvNH6rEk6rbs2VVHXMxMEt2jkY=;
        b=GyGnRMJ4jADBJT/vXAsPkcvHEvFwYF3hKiJOoUbzqkzhKAK8kWjqW1wZLznlQ2eoMQ
         AbTZ4HOXw55e7ggAOaHW6HGNg5Yit5TIMUuX/bxOO/HPNb44LhmXu6tlfUIW9JSK1VCR
         SIfCVQY+hTNiS1oywEEBhptTjdVCwjAwGLYtvi6XQsTKhVUWC1ElhmAQjJcL1Jg/jIaN
         U/UAN6g7lw3sLK4k5Jieg1jMIHMSW2JU0FjNrsjoofFdg6Ape9hxWvewATCGXdsFdDOp
         XoZAKc5ieVQsKvlF/+UFuQ63n9ePHkTXgEdINoDsaANqz8+3aIeSHeI1reK5UkP0Q9Qv
         njoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYZpE8lGnFpdCamBUGvNH6rEk6rbs2VVHXMxMEt2jkY=;
        b=JDyWF38r6zHz29HAcskTgROgvj7+3JVh5laNRJaiKLP+4EbnSJa2N85sKrPR7n0Zpb
         1SOeVPwtkheGC/Pb1p7b/HBKTdk2wNEMhGfYEDW9Sl4eIkvby0rQUoNP/ut+f3IYsjHM
         MLrV1OTUDY6dIoZihZiEeXdPx40QRdZQjXHJDON2HBrlGMwlB8XKBPgKMf2QWrEF5JTo
         6cu+9ItRUwqO1aAuHmWuulzNiZeAfY8OXmJggLsqR7HXXdk0vyLgjSlQelzv1Ahg2fjq
         dK83Am59PNOLsQPChgykxlzC0qXcpFnenPO3cHHWteEIGlJJsOvjwKThFOz9Z8/ojmvl
         LO9g==
X-Gm-Message-State: ACrzQf3SadiqDdSmhE9EIdBcE81YvHOwClFQ0tWt5MgAZiedj5lD4CYm
        8Au+UVSwXoUxCubaoMb6KNxY4A==
X-Google-Smtp-Source: AMsMyM6tT3iVUILrjNpi91sxVXY8ST7Hons8zyrag5CjVfH0/oTSQ6so1fRiYJK08b9KuZjDXKLEbg==
X-Received: by 2002:a05:6638:480c:b0:363:aed5:ed3c with SMTP id cp12-20020a056638480c00b00363aed5ed3cmr27088649jab.207.1666804136084;
        Wed, 26 Oct 2022 10:08:56 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b002ffcf2e2e05sm2194671ilg.58.2022.10.26.10.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 10:08:55 -0700 (PDT)
Message-ID: <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
Date:   Wed, 26 Oct 2022 11:08:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: Problems replacing epoll with io_uring in tevent
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/26/22 10:00 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> 9. The above works mostly, but manual testing and our massive automated regression tests
>>     found the following problems:
>>
>>     a) Related to https://github.com/axboe/liburing/issues/684 I was also wondering
>>        about the return value of io_uring_submit_and_wait_timeout(),
>>        but in addition I noticed that the timeout parameter doesn't work
>>        as expected, the function will wait for two times of the timeout value.
>>        I hacked a fix here:
>>        https://git.samba.org/?p=metze/samba/wip.git;a=commitdiff;h=06fec644dd9f5748952c8b875878e0e1b0000d33
> 
> Thanks for doing an upstream fix for the problem.

No problem - have you been able to test the current repo in general? I want to
cut a 2.3 release shortly, but since that particular change impacts any kind of
cqe waiting, would be nice to have a bit more confidence in it.

>>     b) The major show stopper is that IORING_OP_POLL_ADD calls fget(), while
>>        it's pending. Which means that a close() on the related file descriptor
>>        is not able to remove the last reference! This is a problem for points 3.d,
>>        4.a and 4.b from above.
>>
>>        I doubt IORING_ASYNC_CANCEL_FD would be able to be used as there's not always
>>        code being triggered around a raw close() syscall, which could do a sync cancel.
>>
>>        For now I plan to epoll_ctl (or IORING_OP_EPOLL_CTL) and only
>>        register the fd from epoll_create() with IORING_OP_POLL_ADD
>>        or I keep epoll_wait() as blocking call and register the io_uring fd
>>        with epoll.
>>
>>        I looked at the related epoll code and found that it uses
>>        a list in struct file->f_ep to keep the reference, which gets
>>        detached also via eventpoll_release_file() called from __fput()
>>
>>        Would it be possible move IORING_OP_POLL_ADD to use a similar model
>>        so that close() will causes a cqe with -ECANCELED?
> 
> I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
> flag that can be passed to POLL_ADD. With that we'll register
> the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
> Then we only get a real reference to the file during the call to
> vfs_poll() otherwise we drop the fget/fput reference and rely on
> an io_uring_poll_release_file() (similar to eventpoll_release_file())
> to cancel our registered poll request.

Yes, this is a bit tricky as we hold the file ref across the operation. I'd
be interested in seeing your approach to this, and also how it would
interact with registered files...

>>     c) A simple pipe based performance test shows the following numbers:
>>        - 'poll':               Got 232387.31 pipe events/sec
>>        - 'epoll':              Got 251125.25 pipe events/sec
>>        - 'samba_io_uring_ev':  Got 210998.77 pipe events/sec
>>        So the io_uring backend is even slower than the 'poll' backend.
>>        I guess the reason is the constant re-submission of IORING_OP_POLL_ADD.
> 
> Added some feature autodetection today and I'm now using
> IORING_SETUP_COOP_TASKRUN, IORING_SETUP_TASKRUN_FLAG,
> IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_DEFER_TASKRUN if supported
> by the kernel.
> 
> On a 6.1 kernel this improved the performance a lot, it's now faster
> than the epoll backend.
> 
> The key flag is IORING_SETUP_DEFER_TASKRUN. On a different system than above
> I'm getting the following numbers:
> - epoll:                                    Got 114450.16 pipe events/sec
> - poll:                                     Got 105872.52 pipe events/sec
> - samba_io_uring_ev-without-defer_taskrun': Got  95564.22 pipe events/sec
> - samba_io_uring_ev-with-defer_taskrun':    Got 122853.85 pipe events/sec

Any chance you can do a run with just IORING_SETUP_COOP_TASKRUN set? I'm
curious how big of an impact the IPI elimination is, where it slots in
compared to the defer taskrun and the default settings.

>>        My hope would be that IORING_POLL_ADD_MULTI + IORING_POLL_ADD_LEVEL
>>        would be able to avoid the performance problem with samba_io_uring_ev
>>        compared to epoll.
> 
> I've started with a IORING_POLL_ADD_MULTI + IORING_POLL_ADD_LEVEL prototype,
> but it's not very far yet and due to the IORING_SETUP_DEFER_TASKRUN
> speedup, I'll postpone working on IORING_POLL_ADD_LEVEL.

OK

-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109D160E51F
	for <lists+io-uring@lfdr.de>; Wed, 26 Oct 2022 18:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiJZQAg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Oct 2022 12:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiJZQAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Oct 2022 12:00:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CAC1CB1A
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 09:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=fVzsQ/n3xidCgHOgggbTsOzSs8w9KN0nQUS0HrYlBgA=; b=Y8bVgwhYQP2zf846Miyd/M02WF
        uRZqnBHxeRg7DTN5bSuN9SlnNfTuPE9SK7SjjolOhFrH/f1gP0rSudYAMNUv2qFbb6GChGXgRH/gX
        KWFyoP1NCMBk52r7adj3viUqL4WAd2qMee0jejK4AkHLpuZf4XC6NNUPCgQoqOd3Ccf38oDUHGW2a
        aHkANGMzskRHtbHLjyKWoj0VX8pN24GRkMmVJq4nBqD73RtgE9nPTRHsXDYWZKCtQCg130Zh9icEE
        AUQepqyo2keepLaD8y+hhJhzN717qVFc11TKxWehorRw+tv+8wtaFTY+Ebum4GYiRvfS4QFryMrin
        WGeBzl02NnYOZDnSS8Jotjo1iPJkHsJtLIln6/eRx8pRLGQHjvCxYh17xRI1q4jqAFK7zIjQ9rcnd
        XiHEyPPZ+UunQAReIkAW+/V8zSi5Ohe0CLsIWQ+AtjfeuA90j/EOxZiPFHYv8CU0p19ZvaM2BWBwx
        ugViLVU+VbW5cnrmQtuaH1Zb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1onipB-005tvB-7k; Wed, 26 Oct 2022 16:00:13 +0000
Message-ID: <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
Date:   Wed, 26 Oct 2022 18:00:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
In-Reply-To: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> 9. The above works mostly, but manual testing and our massive automated regression tests
>     found the following problems:
> 
>     a) Related to https://github.com/axboe/liburing/issues/684 I was also wondering
>        about the return value of io_uring_submit_and_wait_timeout(),
>        but in addition I noticed that the timeout parameter doesn't work
>        as expected, the function will wait for two times of the timeout value.
>        I hacked a fix here:
>        https://git.samba.org/?p=metze/samba/wip.git;a=commitdiff;h=06fec644dd9f5748952c8b875878e0e1b0000d33

Thanks for doing an upstream fix for the problem.

>     b) The major show stopper is that IORING_OP_POLL_ADD calls fget(), while
>        it's pending. Which means that a close() on the related file descriptor
>        is not able to remove the last reference! This is a problem for points 3.d,
>        4.a and 4.b from above.
> 
>        I doubt IORING_ASYNC_CANCEL_FD would be able to be used as there's not always
>        code being triggered around a raw close() syscall, which could do a sync cancel.
> 
>        For now I plan to epoll_ctl (or IORING_OP_EPOLL_CTL) and only
>        register the fd from epoll_create() with IORING_OP_POLL_ADD
>        or I keep epoll_wait() as blocking call and register the io_uring fd
>        with epoll.
> 
>        I looked at the related epoll code and found that it uses
>        a list in struct file->f_ep to keep the reference, which gets
>        detached also via eventpoll_release_file() called from __fput()
> 
>        Would it be possible move IORING_OP_POLL_ADD to use a similar model
>        so that close() will causes a cqe with -ECANCELED?

I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
flag that can be passed to POLL_ADD. With that we'll register
the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
Then we only get a real reference to the file during the call to
vfs_poll() otherwise we drop the fget/fput reference and rely on
an io_uring_poll_release_file() (similar to eventpoll_release_file())
to cancel our registered poll request.

>     c) A simple pipe based performance test shows the following numbers:
>        - 'poll':               Got 232387.31 pipe events/sec
>        - 'epoll':              Got 251125.25 pipe events/sec
>        - 'samba_io_uring_ev':  Got 210998.77 pipe events/sec
>        So the io_uring backend is even slower than the 'poll' backend.
>        I guess the reason is the constant re-submission of IORING_OP_POLL_ADD.

Added some feature autodetection today and I'm now using
IORING_SETUP_COOP_TASKRUN, IORING_SETUP_TASKRUN_FLAG,
IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_DEFER_TASKRUN if supported
by the kernel.

On a 6.1 kernel this improved the performance a lot, it's now faster
than the epoll backend.

The key flag is IORING_SETUP_DEFER_TASKRUN. On a different system than above
I'm getting the following numbers:
- epoll:                                    Got 114450.16 pipe events/sec
- poll:                                     Got 105872.52 pipe events/sec
- samba_io_uring_ev-without-defer_taskrun': Got  95564.22 pipe events/sec
- samba_io_uring_ev-with-defer_taskrun':    Got 122853.85 pipe events/sec

>        My hope would be that IORING_POLL_ADD_MULTI + IORING_POLL_ADD_LEVEL
>        would be able to avoid the performance problem with samba_io_uring_ev
>        compared to epoll.

I've started with a IORING_POLL_ADD_MULTI + IORING_POLL_ADD_LEVEL prototype,
but it's not very far yet and due to the IORING_SETUP_DEFER_TASKRUN
speedup, I'll postpone working on IORING_POLL_ADD_LEVEL.

metze


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9C60E6B2
	for <lists+io-uring@lfdr.de>; Wed, 26 Oct 2022 19:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiJZRoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Oct 2022 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiJZRoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Oct 2022 13:44:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D2EC4C04
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 10:44:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k8so19003198wrh.1
        for <io-uring@vger.kernel.org>; Wed, 26 Oct 2022 10:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=djNJPhyCF40mAPLpkb5E0vWB+lLyHx0YKRSX5SSwvZ0=;
        b=BV8fAUXw04o73/ox4n8ggEwOQmeZ1privLxCaNjmAiNCZzZ7XE+U1Mb5ZTLKMJnCiX
         8cnwu6wX87hoKQOYVIm9XtnSOgHHeisfgj1JMg4O30fcD1HqXgse2EQrWzM3D7xNeVTq
         v4ZP4J4rOpm/rI0gES2oPz1SkWwihneOOYM/HVb9oMeI9tl+qn1xtxOVAPnczB41XoNI
         aDzJNtAPtYK2B57XdiCJhTjrJKfpLlALM8H56A1f/o8paTwApJ3A3FaCq1hLa4XKT/73
         48azE/fCmN3lNh/4EMAxELST8d2eAZl/HJb5Xs7f/qZ9ABEkdkopKE6UxcguWHp2L4HE
         vqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djNJPhyCF40mAPLpkb5E0vWB+lLyHx0YKRSX5SSwvZ0=;
        b=KRA+B5udx/l7gRLtaUaHeZIHbRvmcNVhph/E8xOfzbBxp7Azz8Qht40foChwZ/1Ld4
         3RYhMha9at2a0nuT3PA15hZDf3UmtwQ5TmPZ4YV/2+aAQFBEm0DxGaWg09UGlncsszSn
         JUbFdyhLKH1EKXQUcbaMe6iqUIsKBd7ZAbRSQ5hcEUQ9iiEK04dHFDmUPVD4zSrnRCLy
         K6vElbi1Mm9BD9hlR5pUfErGphu/LCakxzqeKJr/xERfvBtW0pF+mwQeew9Tsd02VeSk
         iNrdrbM6igb2f44ZAkZ4XpXbbF6J0nTOp/hsz5pgIaqIWTZnN4EaCiYuf1FggctWb+8J
         C9Bg==
X-Gm-Message-State: ACrzQf0N+XDTSyYvnsfJW9ZQpNm45pvuWAQi/dPpRLjdNFqY6WzCQrYL
        cTJ2bcqKWCMc5B+orV8bpnhGkrciEbNFUQ==
X-Google-Smtp-Source: AMsMyM4n39E2ACQhvh3tZ4nsLHfhL2Xn9RItGEH7ARF8hPvrNNGXGrZ0JIWPbBsf1/FU2WjQ9HkPgQ==
X-Received: by 2002:a05:6000:684:b0:236:839f:9276 with SMTP id bo4-20020a056000068400b00236839f9276mr5916911wrb.586.1666806238558;
        Wed, 26 Oct 2022 10:43:58 -0700 (PDT)
Received: from [10.10.42.20] (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c3ba900b003b4a699ce8esm2895086wms.6.2022.10.26.10.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 10:43:58 -0700 (PDT)
Message-ID: <063b631b-19a7-fb24-23e7-65cbcc141554@gmail.com>
Date:   Wed, 26 Oct 2022 18:41:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Problems replacing epoll with io_uring in tevent
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/26/22 18:08, Jens Axboe wrote:
> On 10/26/22 10:00 AM, Stefan Metzmacher wrote:
>> Hi Jens,
[...]
>>>      b) The major show stopper is that IORING_OP_POLL_ADD calls fget(), while
>>>         it's pending. Which means that a close() on the related file descriptor
>>>         is not able to remove the last reference! This is a problem for points 3.d,
>>>         4.a and 4.b from above.
>>>
>>>         I doubt IORING_ASYNC_CANCEL_FD would be able to be used as there's not always
>>>         code being triggered around a raw close() syscall, which could do a sync cancel.
>>>
>>>         For now I plan to epoll_ctl (or IORING_OP_EPOLL_CTL) and only
>>>         register the fd from epoll_create() with IORING_OP_POLL_ADD
>>>         or I keep epoll_wait() as blocking call and register the io_uring fd
>>>         with epoll.
>>>
>>>         I looked at the related epoll code and found that it uses
>>>         a list in struct file->f_ep to keep the reference, which gets
>>>         detached also via eventpoll_release_file() called from __fput()
>>>
>>>         Would it be possible move IORING_OP_POLL_ADD to use a similar model
>>>         so that close() will causes a cqe with -ECANCELED?
>>
>> I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
>> flag that can be passed to POLL_ADD. With that we'll register
>> the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
>> Then we only get a real reference to the file during the call to
>> vfs_poll() otherwise we drop the fget/fput reference and rely on
>> an io_uring_poll_release_file() (similar to eventpoll_release_file())
>> to cancel our registered poll request.
> 
> Yes, this is a bit tricky as we hold the file ref across the operation. I'd
> be interested in seeing your approach to this, and also how it would
> interact with registered files...

Not sure I mentioned before but shutdown(2) / IORING_OP_SHUTDOWN
usually helps. Is there anything keeping you from doing that?
Do you only poll sockets or pipes as well?


>>>      c) A simple pipe based performance test shows the following numbers:
>>>         - 'poll':               Got 232387.31 pipe events/sec
>>>         - 'epoll':              Got 251125.25 pipe events/sec
>>>         - 'samba_io_uring_ev':  Got 210998.77 pipe events/sec
>>>         So the io_uring backend is even slower than the 'poll' backend.
>>>         I guess the reason is the constant re-submission of IORING_OP_POLL_ADD.
>>
>> Added some feature autodetection today and I'm now using
>> IORING_SETUP_COOP_TASKRUN, IORING_SETUP_TASKRUN_FLAG,
>> IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_DEFER_TASKRUN if supported
>> by the kernel.
>>
>> On a 6.1 kernel this improved the performance a lot, it's now faster
>> than the epoll backend.
>>
>> The key flag is IORING_SETUP_DEFER_TASKRUN. On a different system than above
>> I'm getting the following numbers:
>> - epoll:                                    Got 114450.16 pipe events/sec
>> - poll:                                     Got 105872.52 pipe events/sec
>> - samba_io_uring_ev-without-defer_taskrun': Got  95564.22 pipe events/sec
>> - samba_io_uring_ev-with-defer_taskrun':    Got 122853.85 pipe events/sec
> 
> Any chance you can do a run with just IORING_SETUP_COOP_TASKRUN set? I'm
> curious how big of an impact the IPI elimination is, where it slots in
> compared to the defer taskrun and the default settings.

And if it doesn't take too much time to test, it would also be interesting
to see if there is any impact from IORING_SETUP_SINGLE_ISSUER alone,
without TASKRUN flags.

-- 
Pavel Begunkov

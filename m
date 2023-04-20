Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC36E9833
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjDTPUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 11:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjDTPUY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 11:20:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E7F1BE3
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:20:23 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u3so7088776ejj.12
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682004021; x=1684596021;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+QcaUIi3XYK4BfvNc7mNTw2YBrl/jU13ZTgp4QRQOM=;
        b=gENl9Wv4Tq325Dm5t9/BiraEAaYRsgksVFXK9lN99hSAtFSsy1Y3rlDPwNYZiiIbGx
         jltosgH0eptHfMMrW7NDFulyNa1evNn00JXEBR+1guH0OQ5M7fuC8dqyMls2adL310OB
         8PuV3JHhihZeVFdudOhEYC60WqevnatxWvx65FFnmf8W0pOdhL660el4LSp+7uDTVCM2
         Gf6tLQW4vzyF6FJHswHuKduySFjKUcZ59RL/ML+M4wMwQPKHbLuYbLB3sPMNBCXOPhUj
         Ncpa6j9Teq0w7AduJJS+52NysGaOj1LSJvOy+9rpCNRBf5R+jCZceZlx+nx2spJvJI5Q
         Mt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682004021; x=1684596021;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R+QcaUIi3XYK4BfvNc7mNTw2YBrl/jU13ZTgp4QRQOM=;
        b=gsXMgWCujWzPPOKzIIoyOcm3WRjbapoGKbF8hGQCSvAj/CZZyOrAcR1pk/o39vmWKn
         zU0XW2Gya2hTKwgaZYcoz2dRS0ycLDWGWfSA3gUtClCydW4gUD4wlUHqKkwX3SL5yEYh
         ge9LeJcx3m96ZehCEyld9180dVNxslyWZ/lIIEaWutfOl07X2HJYYnlKwZ+BYO7ga0ss
         02hm+lioUabf895lOcFPt8Q8XgILo9eSvMWvi7WKtTVOcvcbsOHQrSYSfgy5UH/++oVf
         2olZznuudUxHcct9ZHKVoPgxdME7ePknxvSEiOyitKx1S2xW9LQS69LJL0PPegIHyx/6
         KHOg==
X-Gm-Message-State: AAQBX9eOzpHn5Q5YBeD00wxxF/++uOVE8yvQrRdnWkxcTNBY+d1O+3GA
        iFKMkpLacX+G/wYtYFej4z/9w3rwglY=
X-Google-Smtp-Source: AKy350accNDkzEv2J5Mbbww+nJMiiPUnOZeB5EdtUu9lp2PtDgC/p8NxYLO4FxsHOlv1jGTX+wfAEQ==
X-Received: by 2002:a17:906:3019:b0:8aa:a9fe:a3fc with SMTP id 25-20020a170906301900b008aaa9fea3fcmr2302054ejz.8.1682004021517;
        Thu, 20 Apr 2023 08:20:21 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7db2])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906828b00b0094f23480619sm846066ejx.172.2023.04.20.08.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:20:21 -0700 (PDT)
Message-ID: <21a48320-8a79-5e78-1848-667078aa5838@gmail.com>
Date:   Thu, 20 Apr 2023 16:16:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/6] io_uring: add support for NO_OFFLOAD
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
References: <20230419162552.576489-1-axboe@kernel.dk>
 <20230419162552.576489-4-axboe@kernel.dk>
 <bf3d6256-1f98-3f31-d845-40b84be4a09f@gmail.com>
 <49ab98af-dbfe-c25e-f49d-444def9a3489@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49ab98af-dbfe-c25e-f49d-444def9a3489@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/23 16:03, Jens Axboe wrote:
> On 4/19/23 7:01?PM, Pavel Begunkov wrote:
>> On 4/19/23 17:25, Jens Axboe wrote:
>>> Some applications don't necessarily care about io_uring not blocking for
>>> request issue, they simply want to use io_uring for batched submission
>>> of IO. However, io_uring will always do non-blocking issues, and for
>>> some request types, there's simply no support for doing non-blocking
>>> issue and hence they get punted to io-wq unconditionally. If the
>>> application doesn't care about issue potentially blocking, this causes
>>> a performance slowdown as thread offload is not nearly as efficient as
>>> inline issue.
>>>
>>> Add support for configuring the ring with IORING_SETUP_NO_OFFLOAD, and
>>> add an IORING_ENTER_NO_OFFLOAD flag to io_uring_enter(2). If either one
>>> of these is set, then io_uring will ignore the non-block issue attempt
>>> for any file which we cannot poll for readiness. The simplified io_uring
>>> issue model looks as follows:
>>>
>>> 1) Non-blocking issue is attempted for IO. If successful, we're done for
>>>      now.
>>>
>>> 2) Case 1 failed. Now we have two options
>>>         a) We can poll the file. We arm poll, and we're done for now
>>>         until that triggers.
>>>          b) File cannot be polled, we punt to io-wq which then does a
>>>         blocking attempt.
>>>
>>> If either of the NO_OFFLOAD flags are set, we should never hit case
>>> 2b. Instead, case 1 would issue the IO without the non-blocking flag
>>> being set and perform an inline completion.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    include/linux/io_uring_types.h |  3 +++
>>>    include/uapi/linux/io_uring.h  |  7 +++++++
>>>    io_uring/io_uring.c            | 26 ++++++++++++++++++++------
>>>    io_uring/io_uring.h            |  2 +-
>>>    io_uring/sqpoll.c              |  3 ++-
>>>    5 files changed, 33 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 4dd54d2173e1..c54f3fb7ab1a 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -403,6 +403,7 @@ enum {
>>>        REQ_F_APOLL_MULTISHOT_BIT,
>>>        REQ_F_CLEAR_POLLIN_BIT,
>>>        REQ_F_HASH_LOCKED_BIT,
>>> +    REQ_F_NO_OFFLOAD_BIT,
>>>        /* keep async read/write and isreg together and in order */
>>>        REQ_F_SUPPORT_NOWAIT_BIT,
>>>        REQ_F_ISREG_BIT,
>>> @@ -475,6 +476,8 @@ enum {
>>>        REQ_F_CLEAR_POLLIN    = BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
>>>        /* hashed into ->cancel_hash_locked, protected by ->uring_lock */
>>>        REQ_F_HASH_LOCKED    = BIT_ULL(REQ_F_HASH_LOCKED_BIT),
>>> +    /* don't offload to io-wq, issue blocking if needed */
>>> +    REQ_F_NO_OFFLOAD    = BIT_ULL(REQ_F_NO_OFFLOAD_BIT),
>>>    };
>>>      typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 0716cb17e436..ea903a677ce9 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -173,6 +173,12 @@ enum {
>>>     */
>>>    #define IORING_SETUP_DEFER_TASKRUN    (1U << 13)
>>>    +/*
>>> + * Don't attempt non-blocking issue on file types that would otherwise
>>> + * punt to io-wq if they cannot be completed non-blocking.
>>> + */
>>> +#define IORING_SETUP_NO_OFFLOAD        (1U << 14)
>>> +
>>>    enum io_uring_op {
>>>        IORING_OP_NOP,
>>>        IORING_OP_READV,
>>> @@ -443,6 +449,7 @@ struct io_cqring_offsets {
>>>    #define IORING_ENTER_SQ_WAIT        (1U << 2)
>>>    #define IORING_ENTER_EXT_ARG        (1U << 3)
>>>    #define IORING_ENTER_REGISTERED_RING    (1U << 4)
>>> +#define IORING_ENTER_NO_OFFLOAD        (1U << 5)
>>>      /*
>>>     * Passed in for io_uring_setup(2). Copied back with updated info on success
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 9568b5e4cf87..04770b06de16 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1947,6 +1947,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>        if (unlikely(!io_assign_file(req, def, issue_flags)))
>>>            return -EBADF;
>>>    +    if (req->flags & REQ_F_NO_OFFLOAD &&
>>> +        (!req->file || !file_can_poll(req->file)))
>>> +        issue_flags &= ~IO_URING_F_NONBLOCK;
>>> +
>>>        if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
>>>            creds = override_creds(req->creds);
>>>    @@ -2337,7 +2341,7 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
>>>    }
>>>      static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>> -             const struct io_uring_sqe *sqe)
>>> +             const struct io_uring_sqe *sqe, bool no_offload)
>>>        __must_hold(&ctx->uring_lock)
>>>    {
>>>        struct io_submit_link *link = &ctx->submit_state.link;
>>> @@ -2385,6 +2389,9 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>>            return 0;
>>>        }
>>>    +    if (no_offload)
>>> +        req->flags |= REQ_F_NO_OFFLOAD;
>>
>> Shouldn't it be a part of the initial "in syscall" submission
>> but not extended to tw? I'd say it should, otherwise it risks
>> making !DEFER_TASKRUN totally unpredictable. E.g. any syscall
>> can try to execute tw and get stuck waiting in there.
> 
> Yeah, it should probably be ignore outside of off io_uring_enter(2)
> submissions. If we do that, we could drop the flag too (and the flags
> extension).

issue_flags instead of req->flags might be a better place for it

-- 
Pavel Begunkov

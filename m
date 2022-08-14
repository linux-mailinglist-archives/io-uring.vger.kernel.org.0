Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFE2592011
	for <lists+io-uring@lfdr.de>; Sun, 14 Aug 2022 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiHNOOP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Aug 2022 10:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239830AbiHNONz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Aug 2022 10:13:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD59FEC
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 07:13:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so4448726plr.8
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=n69QyxxWBb37ef4CRAVWuBwhMvdNUi5oXQTNT1cKda4=;
        b=tCtmLeReM0/ff9Sg5dd2P+J5/PxvoDCgmb7T4ReGv5foKSCrjFrGn2CMnKUqFPaD4K
         0v9H7yLLqOF7vxhA+NMK/RVEXq4X9zXKD8dE8J0jc1vc5EI7tJsR5MsA84k5xn2TSK8G
         LK5NVa1FMhGXrj4VE/Dlqi9leBOrylQx8IXGmgP6Xn0b/xuDCAYVvJpJOYMJ0QOwl/JI
         e7aTYc/zR0MJouQAhbuUyvNs3L3C+/29C51wYlxjcsJJbTiMYjfjqxcU7SMP8oBKeSp1
         AY6qQ0o/Q0wuXz9QJILCVCLmUxWAYMZKhhsTuKz3V/n93GnUaLEvaeysoj9+xMYRWkQC
         JVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=n69QyxxWBb37ef4CRAVWuBwhMvdNUi5oXQTNT1cKda4=;
        b=gDs+18Pb9TgvJryTUpmYqy0aesciZWTAps4u+DgCPZwnPt47zxbVkO32/aNfWVtjn2
         ip1gFcgoNm8M+97QpVEZCPvaPmGaxxnkQmlhdr03fPxBeeOd5VGTMp/npt55pBy7oZBJ
         CVJwU0oSipeqjHeY/+fIHYwRKXxWYBkXYY6WHr48ELf1em9AAM2ZPJbjOWKGSq7fMsLO
         /NUeKRujPOMn3CC0JjDJJJzaZ7+ajsAVy7CESLNau3ByNPqJTWkQPURql7Qa3fwCi5n6
         FYWewUgfZHtOty0jYtpOVylsUdRB6NbrvXDd058RnqKhVyvXqvquWoewyg/BbHTzpJGI
         jLgQ==
X-Gm-Message-State: ACgBeo2x9nWvNkkOQDNfxqzY+A+E78CLWgQCAFF121DqQUuqnKNMmCe0
        2nFHf9hQIIRP17zs/pcqo0atHQ==
X-Google-Smtp-Source: AA6agR6ZXIMcRCe762qwg4vx8+wvIM9DKLwoqgQxXe36SkRqUIahJ6tw6ZodG6ggztx2BLPZnXYXAA==
X-Received: by 2002:a17:90b:390a:b0:1f5:db3:2817 with SMTP id ob10-20020a17090b390a00b001f50db32817mr22826478pjb.64.1660486431269;
        Sun, 14 Aug 2022 07:13:51 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n5-20020a622705000000b0052ea306a1e8sm5157145pfn.210.2022.08.14.07.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 07:13:48 -0700 (PDT)
Message-ID: <8d91ba5e-5b28-5ec0-b348-7eebd1edf2dd@kernel.dk>
Date:   Sun, 14 Aug 2022 08:13:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] io_uring/net: send retry for zerocopy
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
 <064b4920-5441-1ae2-b492-cb75f7796d8d@samba.org>
 <14283cb1-11b3-2847-4f48-9ea30c48c1bf@kernel.dk>
 <6357d22c-2fcc-ccc9-882c-9ebf83add50d@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6357d22c-2fcc-ccc9-882c-9ebf83add50d@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/22 8:11 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>>> io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
>>>> is set, however new zerocopy send is inconsistent in this regard, which
>>>> might be confusing. Handle short sends.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    io_uring/net.c | 20 +++++++++++++++++---
>>>>    1 file changed, 17 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index 32fc3da04e41..f9f080b3cc1e 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -70,6 +70,7 @@ struct io_sendzc {
>>>>        unsigned            flags;
>>>>        unsigned            addr_len;
>>>>        void __user            *addr;
>>>> +    size_t                done_io;
>>>>    };
>>>>      #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
>>>> @@ -878,6 +879,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>          zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>>>        zc->addr_len = READ_ONCE(sqe->addr_len);
>>>> +    zc->done_io = 0;
>>>>      #ifdef CONFIG_COMPAT
>>>>        if (req->ctx->compat)
>>>> @@ -1012,11 +1014,23 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>>>        if (unlikely(ret < min_ret)) {
>>>>            if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>>>>                return -EAGAIN;
>>>> -        return ret == -ERESTARTSYS ? -EINTR : ret;
>>>> +        if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
>>>> +            zc->len -= ret;
>>>> +            zc->buf += ret;
>>>> +            zc->done_io += ret;
>>>> +            req->flags |= REQ_F_PARTIAL_IO;
>>>
>>> Don't we need a prep_async function and/or something like
>>> io_setup_async_msg() here to handle address?
>>
>> I don't think so, it's a non-vectored interface, so all the state is
>> already in io_sendzc.
> 
> This has support for sockaddr address compared to io_send(),
> if the caller need to keep io_sendzc->addr valid until the qce arrived,
> then we need to clearly document that, as that doesn't match the common practice
> of other opcodes. Currently everything but data buffers can go after the sqe is
> submitted.

Good point, it's not just the 'from' address. Pavel?

-- 
Jens Axboe


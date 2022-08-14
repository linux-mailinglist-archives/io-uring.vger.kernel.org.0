Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0673591FFF
	for <lists+io-uring@lfdr.de>; Sun, 14 Aug 2022 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiHNOGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Aug 2022 10:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiHNOGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Aug 2022 10:06:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6755B3
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 07:06:19 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q16so4630499pgq.6
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Nj+utIODgYeqU0l3xmuGAL+FGlaa2lu0rKoTYUVupco=;
        b=wgJTqEeiZq25ZdasSBZNzjgGORigudfc7wYITNJ6rqhhzbEFcr8U/BXJTX9DA5PREM
         ocG2hkQ8022CIra/DfgmGMO4kN4MpUZoaVDvtP8G/rSG8phmnAYvXYgUxmRecnA8YU6T
         t5Zu0jFRQi8Ngp7pJwLYehKYUj4hkptqnH4PmS65RQqxkCy5stXuPtjRFDzirqhmU+r5
         e+ppjfo4BzlgyTPnOkXCtuHFOEmIWTBOmbz+9CQkBlh2xfGTSOeV7JGV9wKaL04hjSqe
         jdMDPC/picjhWe935W/4tKvrFe2XgQHXRnJfZczexXrmtCb1mFmyeWbH2zkLaHFxINaT
         96FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Nj+utIODgYeqU0l3xmuGAL+FGlaa2lu0rKoTYUVupco=;
        b=rcBexHG0mKUAsM5CBnzqSMVlZOTFjL63YvPGUyfG5eRlwGZzrXTqmTPgn1hXiVelPh
         FBw9uq4hsenghRCFqtLHmU9J1mEpoZxow7RkdDtG1uwlcUVzNoipidJTo3ru6wg6QQPC
         peCYp2nRMOItgBKO37YSuNMRukghuPD8W0/PAAXmu25jVaIDrbiR5C5Wzvk5YYWCZ6te
         gpdzK2xvq72ZX184nxYk1n386t5zkbg+hjk0UcCMbb7nCC6suBOruNxagivyEkJvvPnN
         H7QVZLixANNtGYYmHhMSba9pzMwyrhQP07eI0qVRVGid82mC6Si1Kuj7YyQDM4WQBtG/
         CdLg==
X-Gm-Message-State: ACgBeo1OIHRG/v2lmRjhRsS65jTAMqMYBDvQ/LzR0TSsaCN+cwyds8EO
        XRbw8A/6Q4XNRqyLJfo6stO9oA==
X-Google-Smtp-Source: AA6agR6EgScKkxZD+vyiD9CpGUvaDJZqaKwn145XElRUSvo3IIMOs4NbWWNhWSeS4nuj9trSpE/eHg==
X-Received: by 2002:a63:7847:0:b0:41c:9e74:21e2 with SMTP id t68-20020a637847000000b0041c9e7421e2mr10567309pgc.455.1660485979132;
        Sun, 14 Aug 2022 07:06:19 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x10-20020a62860a000000b0052e6d5ee183sm5113497pfd.129.2022.08.14.07.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 07:06:06 -0700 (PDT)
Message-ID: <14283cb1-11b3-2847-4f48-9ea30c48c1bf@kernel.dk>
Date:   Sun, 14 Aug 2022 08:05:51 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <064b4920-5441-1ae2-b492-cb75f7796d8d@samba.org>
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

On 8/14/22 3:31 AM, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
>> is set, however new zerocopy send is inconsistent in this regard, which
>> might be confusing. Handle short sends.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/net.c | 20 +++++++++++++++++---
>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 32fc3da04e41..f9f080b3cc1e 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -70,6 +70,7 @@ struct io_sendzc {
>>       unsigned            flags;
>>       unsigned            addr_len;
>>       void __user            *addr;
>> +    size_t                done_io;
>>   };
>>     #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
>> @@ -878,6 +879,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>         zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>       zc->addr_len = READ_ONCE(sqe->addr_len);
>> +    zc->done_io = 0;
>>     #ifdef CONFIG_COMPAT
>>       if (req->ctx->compat)
>> @@ -1012,11 +1014,23 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>       if (unlikely(ret < min_ret)) {
>>           if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>>               return -EAGAIN;
>> -        return ret == -ERESTARTSYS ? -EINTR : ret;
>> +        if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
>> +            zc->len -= ret;
>> +            zc->buf += ret;
>> +            zc->done_io += ret;
>> +            req->flags |= REQ_F_PARTIAL_IO;
> 
> Don't we need a prep_async function and/or something like
> io_setup_async_msg() here to handle address?

I don't think so, it's a non-vectored interface, so all the state is
already in io_sendzc.

-- 
Jens Axboe


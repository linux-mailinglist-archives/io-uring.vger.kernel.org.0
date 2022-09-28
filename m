Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED3E5EE4B3
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 21:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiI1TAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiI1TAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 15:00:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DA950718
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 11:59:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n10so21152859wrw.12
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 11:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Eh21pY6XJNvlRi4m3QG4kC7ckPuj3cMT3/D5fT8/lDI=;
        b=nyQz739Yq8foSN1+S6CU05bTXVwhnnPNCgUYCV7ThDZIG9wikagcCLZWCJc1JMM1g8
         uC0lju1xkI+eA5ryBK6GH+NJSIRir5H7p7gQNRRw1UHbdVQKuaeCF2GaGjCkznq0/QPD
         94r+QSVF3wNcBJG0JJiMh90WTMWaF4NWD/QQ2dolIhBGNSLvXANgN+YksSpzdghU/eGG
         jtiYN7G8OcG+wtUDguZV5ODl9DawEffOosviRTZsArjkSaNb7wB3PZiIlOlG4cTVUaJM
         csuam2ROxYqZMVRjEOtqH0nyRSZNOdpZKUVSRfwwroYXMQZ1DfY9bsoqIyxyHpGwDvl5
         ghCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Eh21pY6XJNvlRi4m3QG4kC7ckPuj3cMT3/D5fT8/lDI=;
        b=7ageQJTZwVw+yUy1cB7sJ5muwr7m7l3i+3OHekTTuJCue6FdokGDqsYVekNY6jUK6l
         QMfKaQf8n12MTlrsGmWcDg8VguwMC63fvcfCnuljBf60Br1lNqvXdQvElUdDe0WFQG/5
         0qr9OyzOCVbWdi+g0nLHb3lSliNdcR9mTop/Bp2zzutAjWUjgSj52P7HQa2aKKLJFzZV
         6Ml9fDIristikSAoEzhiX/3r4wxKAUgtN6t0Tf/y4i0o5hQ2xT3ovEToH6ymVoKcwbrF
         AbjddVkHZfGmjs7gj9CMmKQZ8WKNXa30pEseDwxm7HyGblvM5cTmcGPkDT7oSqAzQzTS
         f70Q==
X-Gm-Message-State: ACrzQf114+VXbfpe2uXDOD372DUdgkMCCT6zDa3mjg+fHbD01WsA6DC+
        jXIXvFvjfHj2y6vH38VEpymYOKYJSuw=
X-Google-Smtp-Source: AMsMyM6AA7kRoEsvxRx0VDpn7AXhCotpCSB2mDd2BH0cfC8aCKo28qo0UhnAKYrkk5jfd0J8+nrjOg==
X-Received: by 2002:adf:d202:0:b0:22c:c3fb:3452 with SMTP id j2-20020adfd202000000b0022cc3fb3452mr5264744wrh.366.1664391597298;
        Wed, 28 Sep 2022 11:59:57 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id q17-20020adff511000000b002253fd19a6asm6147862wro.18.2022.09.28.11.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 11:59:56 -0700 (PDT)
Message-ID: <ed921108-c4d1-8bc5-9eb3-e6364d2b64f6@gmail.com>
Date:   Wed, 28 Sep 2022 19:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-6.1] io_uring/net: don't skip notifs for failed
 requests
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
 <ba8eafce-c4cb-6993-7902-1db17168d37b@samba.org>
 <31a0a8b5-2915-4a4a-e19b-a347a5d7dad9@gmail.com>
In-Reply-To: <31a0a8b5-2915-4a4a-e19b-a347a5d7dad9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 17:56, Pavel Begunkov wrote:
> On 9/28/22 16:23, Stefan Metzmacher wrote:
>> Just as reference, this was the version I was testing with:
>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=7ffb896cdb8ccd55065f7ffae9fb8050e39211c7
>>
>>>   void io_sendrecv_fail(struct io_kiocb *req)
>>>   {
>>>       struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
>>> -    int res = req->cqe.res;
>>>       if (req->flags & REQ_F_PARTIAL_IO)
>>> -        res = sr->done_io;
>>> +        req->cqe.res = sr->done_io;
>>> +
>>>       if ((req->flags & REQ_F_NEED_CLEANUP) &&
>>> -        (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
>>> -        /* preserve notification for partial I/O */
>>> -        if (res < 0)
>>> -            sr->notif->flags |= REQ_F_CQE_SKIP;
>>> -        io_notif_flush(sr->notif);
>>> -        sr->notif = NULL;
>>
>> Here we rely on io_send_zc_cleanup(), correct?

Right

>> Note that I hit a very bad problem during my tests of SENDMSG_ZC.
>> BUG(); in first_iovec_segment() triggered very easily.
>> The problem is io_setup_async_msg() in the partial retry case,
>> which seems to happen more often with _ZC.
>>
>>         if (!async_msg->free_iov)
>>                 async_msg->msg.msg_iter.iov = async_msg->fast_iov;
>>
>> Is wrong it needs to be something like this:
>>
>> +       if (!kmsg->free_iov) {
>> +               size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
>> +               async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
>> +       }
> 
> I agree, it doesn't look right. It indeed needs sth like
> io_uring/rw.c:io_req_map_rw()

Took a closer look, that chunk above looks good and matches
io_req_map_rw() apart from non essential differences. Can you
send a patch?


>> As iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
>> being only relative to the first element.
>>
>> I'm not sure about the 'kmsg->free_iov' case, do we reuse the
>> callers memory or should we make a copy?

We can reuse it, we own it and it's immutable from
the iter perspective.

>> BTW: I tested with 5 vectors with length like this 4, 0, 64, 32, 8388608
>> and got a short write with about ~ 2000000.

Which is interesting to know. What does 2M here mean? Is it
consistently retries when sending more than 2M bytes?

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2435EE263
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 18:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiI1Q5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiI1Q5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 12:57:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2210221834
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 09:57:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m4so6406036wrr.5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 09:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=jfbHBpvM9uDoluPd+AxNJuy1TynfvSCJebwldrFgYB4=;
        b=UKvuBa8BEgOD1D4+j6M2l5hUV+4/kqEH6ejjE+ya8SuJRiIRohPhKbQ8DkcmxeD4HO
         rJi0hAExX+5v0pLZbk2BZjGugHONgToZQ075ojyGUK30j9Sc+D1LAeVFr/XFYs9Th/w3
         T9RTXbZNA4wtAHyYY1Tlql9+CX/OYsmffhEH0AVTe4jOKomR3kUyYxEsAAxsc2El4w4d
         e+FrmAhmlx/x8Od/Sb1rqQlb3fzfesItctUotsvP1W8NnwawjnZ32hjAZ3noW3FPJ/Gr
         t2peVecnsMUuUtqBjI3pTYmQ7GLikZc/B92djTHDg64sWfBAyBotqXiougiqd54YlOxC
         FMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jfbHBpvM9uDoluPd+AxNJuy1TynfvSCJebwldrFgYB4=;
        b=Hz1Y2/bu1sbVS9ckdY7A16cL+fHT1MZD2RVLe72wA/x5OODjcM8rLa/4z4Wn6FSGSQ
         2KgWt/IKbwe0oC1bT1YqOJ5XxzLfLzWBgw9/w+5HoQk5eueEDhCeRtX9jLcI/dy1jAs1
         8t3RSyUfMCMvaK7cjr5IC6NoOV+DEODH3dl111oRjVaFhlVnyc+URH8jFDD1l4n+tfbo
         I8Rpe2OIhnpBUgk4WK1zW/0YwhKIPwJEBKmowky9dGzpJkZFmu0MUbrWH6RW7nMpbzg4
         JPi3j+onCRUWA4xyRVXkGVgSINBk8fBfL3S7hj6WM9W5WIopg6pj9GytSdQ3l8Len5kn
         YQ1A==
X-Gm-Message-State: ACrzQf1GHGKNH9kHaiyv79HDO80z/TbvHfugWIQ2luCpcxOceHfLLAIM
        TBjcfDw0q7/eK+P9JDFvIsIloEBqR5E=
X-Google-Smtp-Source: AMsMyM4/pk1HVCHyjVR22ticssjqPQ17rGs6cJJ07JPOfw8pOKDRN+M3PRXuertBAbNPQXiyKzAvwQ==
X-Received: by 2002:a5d:4b83:0:b0:22c:cc7b:9c70 with SMTP id b3-20020a5d4b83000000b0022ccc7b9c70mr1114559wrt.273.1664384260541;
        Wed, 28 Sep 2022 09:57:40 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id w9-20020adfee49000000b0022add371ed2sm4574337wro.55.2022.09.28.09.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 09:57:40 -0700 (PDT)
Message-ID: <31a0a8b5-2915-4a4a-e19b-a347a5d7dad9@gmail.com>
Date:   Wed, 28 Sep 2022 17:56:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-6.1] io_uring/net: don't skip notifs for failed
 requests
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
 <ba8eafce-c4cb-6993-7902-1db17168d37b@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ba8eafce-c4cb-6993-7902-1db17168d37b@samba.org>
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

On 9/28/22 16:23, Stefan Metzmacher wrote:
> 
> Hi Pavel,
> 
>> We currently only add a notification CQE when the send succeded, i.e.
>> cqe.res >= 0. However, it'd be more robust to do buffer notifications
>> for failed requests as well in case drivers decide do something fanky.
>>
>> Always return a buffer notification after initial prep, don't hide it.
>> This behaviour is better aligned with documentation and the patch also
>> helps the userspace to respect it.
> 
> Just as reference, this was the version I was testing with:
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=7ffb896cdb8ccd55065f7ffae9fb8050e39211c7
> 
>>   void io_sendrecv_fail(struct io_kiocb *req)
>>   {
>>       struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
>> -    int res = req->cqe.res;
>>       if (req->flags & REQ_F_PARTIAL_IO)
>> -        res = sr->done_io;
>> +        req->cqe.res = sr->done_io;
>> +
>>       if ((req->flags & REQ_F_NEED_CLEANUP) &&
>> -        (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
>> -        /* preserve notification for partial I/O */
>> -        if (res < 0)
>> -            sr->notif->flags |= REQ_F_CQE_SKIP;
>> -        io_notif_flush(sr->notif);
>> -        sr->notif = NULL;
> 
> Here we rely on io_send_zc_cleanup(), correct?
> 
> Note that I hit a very bad problem during my tests of SENDMSG_ZC.
> BUG(); in first_iovec_segment() triggered very easily.
> The problem is io_setup_async_msg() in the partial retry case,
> which seems to happen more often with _ZC.
> 
>         if (!async_msg->free_iov)
>                 async_msg->msg.msg_iter.iov = async_msg->fast_iov;
> 
> Is wrong it needs to be something like this:
> 
> +       if (!kmsg->free_iov) {
> +               size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
> +               async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
> +       }

I agree, it doesn't look right. It indeed needs sth like
io_uring/rw.c:io_req_map_rw()


> As iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
> being only relative to the first element.
> 
> I'm not sure about the 'kmsg->free_iov' case, do we reuse the
> callers memory or should we make a copy?
> I initially used this
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=e1d3a9f5c7708a37172d258753ed7377eaac9e33
> But I didn't test with the non-fast_iov case.
> 
> BTW: I tested with 5 vectors with length like this 4, 0, 64, 32, 8388608
> and got a short write with about ~ 2000000.
> 
> I'm not sure if it was already a problem before:
> 
> commit 257e84a5377fbbc336ff563833a8712619acce56
> io_uring: refactor sendmsg/recvmsg iov managing
> 
> But I guess it was a potential problem before starting with
> 7ba89d2af17aa879dda30f5d5d3f152e587fc551 where io_net_retry()
> was introduced.
> 
> metze

-- 
Pavel Begunkov

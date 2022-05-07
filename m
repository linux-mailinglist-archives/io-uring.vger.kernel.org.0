Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC451E630
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 11:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244252AbiEGJvp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 05:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347894AbiEGJvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 05:51:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C08C3631C;
        Sat,  7 May 2022 02:47:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u3so13075501wrg.3;
        Sat, 07 May 2022 02:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v/2GAcCoGWA0XrbLG0oyBMQDo3jgcdYPVii1ckL8LbQ=;
        b=ffIXVNyI9uBJLQlVgIfoxcPFxxn3ADhmeQV7hnH9my5lVZcYCuDWzWf6NAM0k9PR9U
         /X1tZmCvY+KPiJTL+q5/WOFXPb6naa2U2YYnTuv2Butv+2QOZue1iiXtfVPufzX2QlFJ
         /7TP2jAhLxTkylUOJYPcU/lpE25RDVU6QEQ3mHT989Dhet+o09H4idarDPV10W4TrlaC
         UNNRMEsUlA/z4rjwOIJQ+2r41TbAKUtN4qyCSTxpV2QoGNxPPWPXvQHgNRcUpbcTZZ0z
         FS32UrVTDddHwH34IxdxR1YTb3ED0eN6nlym9MeS/A69+pTir0kd0JCbAZ2gjAtDebNR
         C6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v/2GAcCoGWA0XrbLG0oyBMQDo3jgcdYPVii1ckL8LbQ=;
        b=UbHQ4CmH6oCYlbIoVG4szrcNFR+gkAm8s7vY/LlQMSsSz9s0tlcLQRQlHWC+HD4NUl
         YdfNU1wuCXWKqEem5lNRX9Uo1xnpZ/cXNCGd9Y/KeYCsagzDp87M3URw0YA5/R18nXAj
         9nlOx0lB3oxCRhdyGiKFjYPJqRd2KwLtILueHXciudIIJs0cqhJVrzVFJn862pgHyfnA
         buVsGs7JBg9/1r0K6j00kcC5KBtPIawApXio6kEHYHcOA8An31znaNc+TcFjw78/QeLK
         FIiuNRAbMcSOhHthaE8ylKY4bsLEFhGRahZ24wFOOdUP6BPubrvF/JuvmnKLAaRYDoHK
         7ftA==
X-Gm-Message-State: AOAM531fc5f8v6gp8PpYmg+V2er/6mlb2c/p3QOCURePvf2UtfafgHYO
        O3ELmVhtQhEoUJO2IAqi/As=
X-Google-Smtp-Source: ABdhPJzks/svN3u7oItngSITPmwo2Bky+7CvxxV15UoaWPPIoJZMhADL2tcPDELLlsom+rWujjFw/w==
X-Received: by 2002:a5d:53c1:0:b0:20a:db5d:2590 with SMTP id a1-20020a5d53c1000000b0020adb5d2590mr5795841wrw.411.1651916876731;
        Sat, 07 May 2022 02:47:56 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.69])
        by smtp.gmail.com with ESMTPSA id k7-20020a05600c1c8700b003946433a829sm6658153wms.11.2022.05.07.02.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 02:47:56 -0700 (PDT)
Message-ID: <acd36e44-8351-d907-bb50-57375823268c@gmail.com>
Date:   Sat, 7 May 2022 10:47:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/5] io_uring: let fast poll support multishot
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-4-haoxu.linux@gmail.com>
 <d68381cf-a9fc-33b8-8a9c-ff8485ba8d19@gmail.com>
 <135b16e4-f316-cb25-9cdd-09bd63eb4aef@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <135b16e4-f316-cb25-9cdd-09bd63eb4aef@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 08:08, Hao Xu wrote:
> 在 2022/5/7 上午1:19, Pavel Begunkov 写道:
>> On 5/6/22 08:01, Hao Xu wrote:
[...]
>> That looks dangerous, io_queue_sqe() usually takes the request ownership
>> and doesn't expect that someone, i.e. io_poll_check_events(), may still be
>> actively using it.
>>
>> E.g. io_accept() fails on fd < 0, return an error,
>> io_queue_sqe() -> io_queue_async() -> io_req_complete_failed()
>> kills it. Then io_poll_check_events() and polling in general
>> carry on using the freed request => UAF. Didn't look at it
>> too carefully, but there might other similar cases.
>>
> I checked this when I did the coding, it seems the only case is
> while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
> uses req again after req recycled in io_queue_sqe() path like you
> pointed out above, but this case should be ok since we haven't
> reuse the struct req{} at that point.

Replied to another message with an example that I think might
be broken, please take a look.

The issue is that io_queue_sqe() was always consuming / freeing /
redirecting / etc. requests, i.e. call it and forget about the req.
With io_accept now it may or may not free it and not even returning
any return code about that. This implicit knowledge is quite tricky
to maintain.

might make more sense to "duplicate" io_queue_sqe()

ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
// REQ_F_COMPLETE_INLINE should never happen, no check for that
// don't care about io_arm_ltimeout(), should already be armed
// ret handling here



> In my first version, I skiped the do while{} in io_poll_check_events()
> for multishot apoll and do the reap in io_req_task_submit()
> 
> static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>    {
>            int ret;
> 
> 
>            ret = io_poll_check_events(req, locked);
>            if (ret > 0)
>                    return;
> 
> 
>            __io_poll_clean(req);
> 
> 
>            if (!ret)
>                    io_req_task_submit(req, locked);   <------here
>            else
>                    io_req_complete_failed(req, ret);
>    }
> 
> But the disadvantage is in high frequent workloads case, it may loop in
> io_poll_check_events for long time, then finally generating cqes in the
> above io_req_task_submit() which is not good in terms of latency.
>>

-- 
Pavel Begunkov

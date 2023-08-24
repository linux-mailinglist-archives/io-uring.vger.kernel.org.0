Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831BC7875F8
	for <lists+io-uring@lfdr.de>; Thu, 24 Aug 2023 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbjHXQtw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 12:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjHXQt2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 12:49:28 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F7B1B9
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:49:25 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-34bae11c5a6so54205ab.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692895765; x=1693500565;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+M9lz0OshXgyVaA5LzeRlAtcsm3Pfc8dKXHBpcHJcYA=;
        b=n4jqysyneWgfj7530hqYpkRkxIpk5qDfFIaNe7OQ2bIaez0djeuhyOMm4WGuaZFc+2
         C5HOLUuRmnVjxhO/W9gc2UGGSDklVOLuzM7DleFTnhpgxbbHmZY6VURPZ+D5DeUGOfSW
         BCpfxz+OXlBErQBAr8gNiGeAwksINV4f/ppYGBmEWq6FAVhoP66zKfA7EEc/qdJS5vln
         vTxiknw4LqNh9pACfUXu9lMnr13eiaEQU2nhKYobpTgu1abEJ7qAzNPJTi9uxT8PXKjb
         Kp82yDOoZQwE5xnFw1AvDwBiZzQ2ugRoNpBPKRXRYs0a1d+QxlpgnLP8ezjWRw5SEA7w
         XvgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692895765; x=1693500565;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+M9lz0OshXgyVaA5LzeRlAtcsm3Pfc8dKXHBpcHJcYA=;
        b=FUrI4TPuYrCvv95Td/bcun2jJJGmrOsBQD7SJfw1LxcYDUoDnmspXdbIRqkt3zZlJ5
         Fao+zXKCSG7PfjLAB9GMFAnuLZxAJBlAwhbpD4/woaBT2N4jIh0MH0B+vomfsL6iqvCx
         h6IHA5c5OERgOSTFJMkMnZWFSsdf5sjmSexFwC2gIuFPBFoTanBSItH3zpdSJ/SWHict
         DIdfLpYQ/Tmm3QcCiEUsYtseSllbBehdVmck2644abg9PM59GI+JakyvOKLXcoX7D5j/
         pNBhtDy8UmiztaSl/Sp1yDt9wwzhFExXyrShhRGtSh0zUoaZpWlgRst3BSA654aUd4c/
         IKQg==
X-Gm-Message-State: AOJu0YwY9XsBNTBUv8msC+yVmQ0BH3cpuWVZQ6hWDPcSnKWjkDchYm43
        BXSuYPskYt8aZHb9HNGe5P9vow==
X-Google-Smtp-Source: AGHT+IHedPTEKuHBu+gAn5920CrD6UNGMV/+A3pdZSihytgj8EAhDbipwmNTplgBeC6wEGS08Tfwdg==
X-Received: by 2002:a05:6602:3706:b0:791:e6ca:363 with SMTP id bh6-20020a056602370600b00791e6ca0363mr20379714iob.1.1692895765182;
        Thu, 24 Aug 2023 09:49:25 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i2-20020a02cc42000000b0041e328a2084sm4542108jaq.79.2023.08.24.09.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 09:49:24 -0700 (PDT)
Message-ID: <b305d893-98a2-4226-9ab3-1d2669743088@kernel.dk>
Date:   Thu, 24 Aug 2023 10:49:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] io_uring: cqe init hardening
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <731ecc625e6e67900ebe8c821b3d3647850e0bea.1692119257.git.asml.silence@gmail.com>
 <2ef18cd5-c8a6-4a5e-8b9c-139604d6d51a@kernel.dk>
 <b36af67b-5160-c9c8-aa70-669da4f1d797@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b36af67b-5160-c9c8-aa70-669da4f1d797@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/23 10:28 AM, Pavel Begunkov wrote:
> On 8/19/23 16:03, Jens Axboe wrote:
>> On 8/15/23 11:31 AM, Pavel Begunkov wrote:
>>> io_kiocb::cqe stores the completion info which we'll memcpy to
>>> userspace, and we rely on callbacks and other later steps to populate
>>> it with right values. We have never had problems with that, but it would
>>> still be safer to zero it on allocation.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index e189158ebbdd..4d27655be3a6 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1056,7 +1056,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>>       req->link = NULL;
>>>       req->async_data = NULL;
>>>       /* not necessary, but safer to zero */
>>> -    req->cqe.res = 0;
>>> +    memset(&req->cqe, 0, sizeof(req->cqe));
>>>   }
>>>     static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
>>
>> I think this is a good idea, but I wonder if we should open-clear it
>> instead. I've had cases in the past where that's more efficient than
>> calling memset.
> 
> I don't think it ever happens for 16 byte memcpy, and in either
> case it's a cache refill, quite a slow path. I believe memcpy is
> better here.

Yeah I think it's fine as-is - just checked here and either approach
yields the same.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3557D4CEDF6
	for <lists+io-uring@lfdr.de>; Sun,  6 Mar 2022 22:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiCFVgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Mar 2022 16:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiCFVgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Mar 2022 16:36:50 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4414DF42
        for <io-uring@vger.kernel.org>; Sun,  6 Mar 2022 13:35:57 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qx21so28027866ejb.13
        for <io-uring@vger.kernel.org>; Sun, 06 Mar 2022 13:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t8G2F30Vq8FJacMzZEIjevAum7/PAf0xCdof4XSHZFw=;
        b=feyHWzTQU2d+/LUEjCk2actwWez6bzYLIr76zom8fXMEuVx+5CRQYbHoB57yTNgbly
         wEOSr8JaCiIEFJISErMIZIKh0M7uAy4Kq1siFbk+2dsfCwh8eC9RWQdJeq6mrYXFmIcl
         rGPHtoO/83vwK7UKKAOggrQQmsTm2gy8IyHs/DuAyqd4JJFbuX0ROvFmkkonGo1aLuoI
         bOUwgGPZlZRDrfTVObUnAMQo6Z5mTku/H49UhVXOUTzZ9rBKseJBUHYecYpivSqpv3QJ
         Br/tDnb1sAVmFtwIckQ0bVsYzgmrThedQpfPesZ6XOVAPyZGPi+ZDX4lc5WHU9Z0KdLa
         zOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t8G2F30Vq8FJacMzZEIjevAum7/PAf0xCdof4XSHZFw=;
        b=IRUSj25GTraGx42cs1z7tq1oeqJOVTKWlzFajOsPmmWaJXuWQCD800chSk2Kr91NxZ
         ThozvSHVtLOEJxSjkxh58DeMlRP65TLyf1uP+T91xVgZtpPEWYY176NYtPKSERDsdtyW
         5uqLUFovkLIfLUFy/tXlKHUKvFOi49jdHmYlcPAwhLa7dcb+8beZYtJpnWzp2G1lDbRW
         tdl53erQxuxndz5JnY6Yik9i/xXvUewlYlPxTfxGsLoWrUB4tPhEc80HB45M3blE1SNe
         W+9iS48h16BIsZSQkIog2BN8vWJccYcv28NFGXsEnPUIcqwcqNV0Si6cLubEYcABUABx
         jdcg==
X-Gm-Message-State: AOAM533sSpUOMxwyWVhByGha45V6wz9A4pCLm3/rEyA5w8Go34mZvVMj
        chXvmhhvS7QMMo8vMeoFDOp49470RW8fD3ox+zQ=
X-Google-Smtp-Source: ABdhPJwI0nV7x4tshXwqaCn3yqISpd1vtgHUjmg+3Q8VvYvZXhOSQAYMq7w1hxfvXDgbw7QEXTuACA==
X-Received: by 2002:a17:907:7b8d:b0:6db:a30:8b96 with SMTP id ne13-20020a1709077b8d00b006db0a308b96mr5101355ejc.221.1646602555800;
        Sun, 06 Mar 2022 13:35:55 -0800 (PST)
Received: from [10.0.2.15] (89-139-33-239.bb.netvision.net.il. [89.139.33.239])
        by smtp.gmail.com with ESMTPSA id z92-20020a509e65000000b00416466dc220sm687037ede.87.2022.03.06.13.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:35:55 -0800 (PST)
Message-ID: <b1699cff-b899-bc20-e7b8-14f7583a3193@gmail.com>
Date:   Sun, 6 Mar 2022 23:35:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: fix memory ordering when SQPOLL thread goes to
 sleep
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220306103544.96974-1-almogkh@gmail.com>
 <768398e5-4909-6c7a-aee7-f36210f41a8f@gmail.com>
 <33f74159-3dfa-f0ab-0b55-09916db837e8@kernel.dk>
From:   Almog Khaikin <almogkh@gmail.com>
In-Reply-To: <33f74159-3dfa-f0ab-0b55-09916db837e8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/22 23:00, Jens Axboe wrote:
> On 3/6/22 6:32 AM, Almog Khaikin wrote:
>> On 3/6/22 12:35, Almog Khaikin wrote:
>>> Without a full memory barrier between the store to the flags and the
>>> load of the SQ tail the two operations can be reordered and this can
>>> lead to a situation where the SQPOLL thread goes to sleep while the
>>> application writes to the SQ tail and doesn't see the wakeup flag.
>>> This memory barrier pairs with a full memory barrier in the application
>>> between its store to the SQ tail and its load of the flags.
>>
>> The IOPOLL list is internal to the kernel, userspace doesn't interact
>> with it. AFAICT it can't cause any races with userspace so the check if
>> the list is empty seems unnecessary. The flags and the SQ tail are the
>> only things that are shared that can cause any problems when the kernel
>> thread goes to sleep so I think it's safe to remove that check.
>>
>> The race here can result in a situation where the kernel thread goes to
>> sleep while the application updates the SQ tail and doesn't see the
>> NEED_WAKEUP flag. Checking the SQ tail after setting the wakeup flag
>> along with the full barrier would ensure that either we see the tail
>> update or the application sees the wakeup flag. The IOPOLL list doesn't
>> tie into any of this.
> 
> I think you're mixing up two different things, and even if not, the
> IOPOLL change should be a separate change.
> 
> The iopoll list check isn't about synchronizing with userspace, it's
> about not going to sleep if we have entries to reap. If we're running
> with IOPOLL|SQPOLL, then it's the sq poll thread that does the polling
> and reaping.

I understand that, but the iopoll list check is already done earlier in
the function and if the list isn't empty, the timer is reset. Checking
again just a little later in the function and after writing the
NEED_WAKEUP flag seems unnecessary but regardless, I guess it's not
really relevant to this patch as it's not a bug that the check is
there. The patch in the original message along with the liburing pull
request should fix the race.

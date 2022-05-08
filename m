Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA35751ED8D
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 14:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiEHMxS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 08:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiEHMxS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 08:53:18 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCBDBC12
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 05:49:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j14so11555672plx.3
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9CgvYRHO+zyjILbsXpuCYz5kUi3xutsr2ZbyqD78JvA=;
        b=yj7HlQlC9P/3bif3QvZacoMfkS8sumx0VL9jmM+inS90KT1x4FNGuHZ+EY5D+NR407
         73/EfgTOpZAjVrPhAXM0Zk3NdZEwkX7Jt3e3GjnvQ2ztPSXecKFakNVgFEK5FM2sTvs1
         ldGVXJ1cYGpxvutBdDFsDCsTJ1Eyn86qZ7QO2ASGExIUiHap2IrqFRszKB1CIz/5ZWke
         4MwpsBWsxQetTEEYhdq6jNB4xmgeMDC0NTXnTFvT0hYRijNZFo8atgdiIsr55Y/rrbBL
         V0U1wob3zNDWadtMs1T850NOFYPqTwmSMpqnziPlh/KCC9qqD57b1YLMjlOUAFbLeS4L
         3TjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9CgvYRHO+zyjILbsXpuCYz5kUi3xutsr2ZbyqD78JvA=;
        b=rIamG0Yax3+DvExl/pCx9A/RI8qWr7B2pz77dNtQ3Rc2wOSNzKp20lOwDWXgSwVhMu
         HbHqwDcfSsXnbgesru9ztcvV8TOcno8UnybzFCXuQj5Si8kkvUZXAF40WWs67zwpjAgY
         55ltcHwzB/NKZro9BTNG7Lgz7q6usnwnx1xqV1UfvKwcXUzaLuL7NswF6MwrvsxYwKLT
         RfazRhVjetvceJdJ5qMzu+uVUVlvO/vY6nzaO7IGB3cGpYFejH04pdUgdpLmLe13XYTh
         htmE5vRo7j23IMJwdmF3vczT+Zd/RpZd3kHwiiG28CpZakbEPdqcVBPB6m7V5HfWeQd9
         ZmBg==
X-Gm-Message-State: AOAM531VO1WzZSgGiKcM/Lnaq8G/vZ776aYkRQXbyMbZRx3cQNL3YEYE
        F5tl9124OeaCqipPczZ6UaVPng==
X-Google-Smtp-Source: ABdhPJyz+ZeUJu57xCM99ZO3D/oL59Iu+3Go2FgbA5WiT03U2A7ip9gH11prhONktOjJgoIELiZw0Q==
X-Received: by 2002:a17:902:6b0b:b0:158:f889:edd9 with SMTP id o11-20020a1709026b0b00b00158f889edd9mr11993926plk.122.1652014166759;
        Sun, 08 May 2022 05:49:26 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090aae0300b001d5e1b124a0sm10756372pjq.7.2022.05.08.05.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 05:49:26 -0700 (PDT)
Message-ID: <df7755df-869d-86a9-bcd5-db0fd2762d31@kernel.dk>
Date:   Sun, 8 May 2022 06:49:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
 <390a7780-b02b-b086-803c-a8540abfd436@gmail.com>
 <f0a6c58f-62c0-737b-7125-9f75f8432496@kernel.dk>
 <0b52bbd2-56de-c213-df3f-73f0f83a1f3a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0b52bbd2-56de-c213-df3f-73f0f83a1f3a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 11:21 AM, Hao Xu wrote:
> 在 2022/5/8 上午12:11, Jens Axboe 写道:
>> On 5/7/22 10:05 AM, Hao Xu wrote:
>>>> But we still need to consider direct accept with multishot... Should
>>>> probably be an add-on patch as I think it'd get a bit more complicated
>>>> if we need to be able to cheaply find an available free fixed fd slot.
>>>> I'll try and play with that.
>>>
>>> I'm tending to use a new mail account to send v4 rather than the gmail
>>> account since the git issue seems to be network related.
>>> I'll also think about the fixed fd problem.
>>
>> Two basic attached patches that attempt do just alloc a fixed file
>> descriptor for this case. Not tested at all... We return the fixed file
>> slot in this case since we have to, to let the application know what was
>> picked. I kind of wish we'd done that with direct open/accept to begin
>> with anyway, a bit annoying that fixed vs normal open/accept behave
>> differently.
>>
>> Anyway, something to play with, and I'm sure it can be made better.
>>
> Thanks. I tried to fix the mail account issue, still unclear what is
> wrong, and too late at my timezone now, I'll try to send v4 tomorrow

No worries. IN the meantime, I played with allocated direct descriptors
yesterday and implemented them for openat/openat2/accept:

https://git.kernel.dk/cgit/linux-block/log/?h=fastpoll-mshot

It's independent of multishot accept in the sense that you can use it
without that, but multishot accept requires it with fixed files.


-- 
Jens Axboe


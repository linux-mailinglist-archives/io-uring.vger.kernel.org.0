Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209AC4F0CEE
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 01:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359006AbiDCXWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 19:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354780AbiDCXWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 19:22:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DDC37A2F
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 16:20:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so7470193pjm.0
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=b6eyXzlqYNbzS7k0xSRp118faeCdpA79oEJuJiWumUk=;
        b=oRI4wMYyiPoWpoCMxN7ddQUSEUy3vcumIXr2B+KVPWX4IyI4OOxKhJ+pz1XsrIZ0gJ
         Xw9z2kZhQEhCmy+fRJpCB3Xtw5vsdXEMplVffF8N+vzhRfaqxk6h0y6GjP/kRlMVEYFz
         bArL8HmvciLEpAu61M0j9zNOH2ev13hwxKJsCDZIymNPysawWh3oBQZDElJSHre/h0md
         uB/5+rlJWCX2oJfu4Q5BZbMQ/dzQo127RmShbASK4L3idlCmPN+RyCOiSVWaOzHPLPEt
         k08uKcpxwF4JPLIjWl+0b1DDQkFti2K9RwnG/RM77KtJn134U/166oDDHfo8Q4FluuI9
         EztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=b6eyXzlqYNbzS7k0xSRp118faeCdpA79oEJuJiWumUk=;
        b=evdmXgXbMFLexTu+l6UwHd3JF5QKfLRzcDD8TUYNL+tX8Z5vTJ9THACix9oKFlydhs
         npDRdrNq/xxRzyOFd29zIDt3TGjCMYGAKLoRPbzsfb0zawN45N9CHfwx4WzQuqCBEdIC
         prKtpRQDjugezXreKKdL3RVE5q+OqJl/c/XInZFbH3rcSfN1BA13zz/PCr/nZ32ANOS1
         aJSB36WuzpVKq6krzBYs/xBPg87pr5/vKUHrriRCFdNxidTPj/ScRpLegV6VN7nn1KcD
         6TY0KSwew0wH9OOR55+7DNXWe2QTq4satO8gTbB1EwPX2mclRvwMDas7BebAeljeos+2
         /uNg==
X-Gm-Message-State: AOAM533i8iwLuJVU9r8c3vMJOfSYc9ZHlymtsRRgsuqf2YnZjoCvv5o4
        4DDTK8QELwj9LfKRUKMF97Bvwg==
X-Google-Smtp-Source: ABdhPJwcdK8gdbE4mbU+32QYQqx8X2O6yEpYpv+7T4vzsSSZ0ktL0aKM7K8uVGOR/C5ZFk09sAq1qg==
X-Received: by 2002:a17:902:dac1:b0:154:3d06:9c5b with SMTP id q1-20020a170902dac100b001543d069c5bmr20673760plx.93.1649028021778;
        Sun, 03 Apr 2022 16:20:21 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l5-20020a056a0016c500b004f768db4c94sm10232396pfc.212.2022.04.03.16.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 16:20:21 -0700 (PDT)
Message-ID: <51905fee-9670-0d18-75c8-28dd5b07d919@kernel.dk>
Date:   Sun, 3 Apr 2022 17:20:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing v2 0/3] Simplify build for tests and gitignore
 cleanup
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
 <edcdf7d7-c993-3dd7-1ed8-b6a713d0fbd9@kernel.dk>
In-Reply-To: <edcdf7d7-c993-3dd7-1ed8-b6a713d0fbd9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 5:15 PM, Jens Axboe wrote:
> On 4/3/22 12:21 PM, Ammar Faizi wrote:
>> Hi Jens,
>>
>> This is the v2, there are 3 patches in this series:
>>
>>   - Rename `[0-9a-f]-test.c` to `[0-9a-f].c`.
>>
>>   - Append -lpthread for all tests and remove the LDFLAGS override
>>     for tests that use pthread.
>>
>>   - Append `.t` to the test binary filename for gitignore simplification.
> 
> Thanks - I have applied this series, but noticed that test/statx.t isn't
> properly cleaned when make clean is run. If you have time, please take
> a look. If not I will tomorrow.

It was pretty trivial, I fixed it up.

-- 
Jens Axboe


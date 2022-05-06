Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629DA51DA9E
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442243AbiEFOke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442241AbiEFOkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 10:40:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CD56A414
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:36:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so10999589pju.2
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 07:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fXoaTVMgA9NByG8F/KlwqAPg3XfIGQXe3O0mJFi20A8=;
        b=mOKykvLRyhUFPqn5hFts82geeunHcUrMUCx7i76A1EHYoZwABlx+5CpTU9fdKr7H2D
         wrUeeD60f9ha4kmK3Em0StgJd41czpufZGore7radx50UsIjLCDsXda6DpoeWriPr/Jz
         9elrJG6XOqXJx9+RTrMSQXXMJi1e4mFb8RTaYO4Hv7veUPrM+AjpIyD+KlbdFqiA8OWz
         jXYM0s5RfxVfffJZh/CXmWhQdTg1hyUpkx2462FH0xzBMDH3EHlAUzzKYfkGW8Ymz0ux
         LPFKK0ztNRV7tw6QmMsipeAcKFnVGXW0HHW1HZK/YkP8QlbzVNhROc16TcLea3pMczFZ
         UJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fXoaTVMgA9NByG8F/KlwqAPg3XfIGQXe3O0mJFi20A8=;
        b=r8fUboCQ4AMeLd6TU6jy3Rb3ncWE9pPvUjxEyzKAe/MHxSmGo5wbCW6gMe9i+7HAXM
         KfAg0Ec8GIUAhNad1N4UJn6S0NEcuwRyqO2y/9PvAMTsURyM0Y8rFkJ9TIkmrYRuMHfR
         W1SeRbkWpApJqJMM4RSdNgvrGRCman/UbpT4pEZH7NY1Ci8bwgOIaRmlncFhufWsyNJo
         IeBQNmxhKwyprwAWQXo91LvYnsdBCAtR9NsDQ7SOxlubtmSlyANwjkLa4/luSPwOHG5y
         boGNmTeF/veFZlwpimUD/KQR4cuXuiFxJbluh9WDctFdbHpk/20wQeXFB+IzXwkVXZGT
         HW+A==
X-Gm-Message-State: AOAM532yg3twdMJawzHuzTgawOKr5T6nMblvF7MrROijFZeZ+lNjLRX9
        qcEashNU8ikwSsqUMvP9iH4jXQ==
X-Google-Smtp-Source: ABdhPJxPeHLbFsPoSAN4eEslmUKPFl2lv5GFn5EY7O60JXBJffK3iYIpufgjfdGDMknYiEM4PY2xpg==
X-Received: by 2002:a17:90b:1c0e:b0:1dc:45b6:6392 with SMTP id oc14-20020a17090b1c0e00b001dc45b66392mr4447846pjb.236.1651847810175;
        Fri, 06 May 2022 07:36:50 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r20-20020aa79634000000b0050dc7a3e88asm3532021pfg.9.2022.05.06.07.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 07:36:49 -0700 (PDT)
Message-ID: <7ea9cb04-3f80-d8a0-ab3c-40cf5049f614@kernel.dk>
Date:   Fri, 6 May 2022 08:36:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-5-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506070102.26032-5-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 1:01 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a helper for poll clean, it will be used in the multishot accept in
> the later patches.

Should this just go into io_clean_op()? Didn't look at it thoroughly,
but it'd remove some cases from the next patch if it could.

-- 
Jens Axboe


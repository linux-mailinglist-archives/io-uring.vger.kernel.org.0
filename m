Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61121509EDD
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356721AbiDULrU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 07:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiDULrT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 07:47:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6ABF2E082
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 04:44:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n33-20020a17090a5aa400b001d28f5ee3f9so4944126pji.4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 04:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=Cp5Up0LrSho0GDgkM58ffKNnMeqDgC1ngKbkriHUeDE=;
        b=DCOasWnT/TubABiEGuyI0X+v+QATOqQorp/1q3AFJyrFhSOFII1DRR71QaumRx+F22
         W6yAswj8ifjQ9xXU32ElNSRkuN79g2NjUM2k85dyJcbooxWjST6zVclLLArVy9ShMR+u
         FMfyRh+swoFCFsjCCu2+V4DRhBKhIGpM2vSSK99wfvMMjIGMONCmv+7S3SqAjpiqT0cA
         +4HASk1DIAQmDfCUOnnNjyqfP7KfoAkjHLwXewsGMKVfy4p3mngIO0yvHlBW/CnT40VL
         +IyD9b7YDwMtpLjgLwNzxUTdfe/wmZAHak4oisJGULH+f1wDBStrugki9OmZOWNQPz8y
         r5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=Cp5Up0LrSho0GDgkM58ffKNnMeqDgC1ngKbkriHUeDE=;
        b=knVbFEApbv3CnYx39Rt+wBAwDyB5ZFvQ7tl4kikUNh87KO6+LJ05TBbVMvbUNhEcDb
         UtHLkKbSawzhHCLivjUi6dz3PgfH6S10wFRslryHTpAZoSVbk0z0bU0bt7BsKkyUX5O7
         SHhSo+a5niCgw0Pe9kWyAh3a2tGc20HhCQBTkQXpupVSW/tNLRjVjtFMrn/ZugcvmoXg
         HTItNhU89Newg7w5hrgoQckxqJ3fY55Vgcx8Jet2cJ39rfdiF0+r06txD7k0Zgeu9oCG
         adhPnir7qV3akZwAfMFZAL9Nw1jJxMREm80ab+6Ix9IiaXzRrx2/bboYVNF2q4BqkT00
         hXEQ==
X-Gm-Message-State: AOAM531QaVwvxFoRvZYfEzEwVmw2eG+/p40ZnuL59MeKOrkm9W9zbKsy
        +PLDVhYEWjsuXrIPffOT3WI=
X-Google-Smtp-Source: ABdhPJwgjulZoDidtGIATXbgK3CaN+ZiGQFtY9e0gIflthwIqWRt2krPdE9pMYBNX50PoYTZshnqDg==
X-Received: by 2002:a17:903:40ce:b0:158:8178:8563 with SMTP id t14-20020a17090340ce00b0015881788563mr24470764pld.167.1650541469220;
        Thu, 21 Apr 2022 04:44:29 -0700 (PDT)
Received: from [192.168.88.87] ([36.72.213.118])
        by smtp.gmail.com with ESMTPSA id x71-20020a62864a000000b0050ad2c24a39sm3439780pfd.205.2022.04.21.04.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 04:44:28 -0700 (PDT)
Message-ID: <b98c1c0c-fcc8-4c0a-86bd-e95f0c0ab25a@gmail.com>
Date:   Thu, 21 Apr 2022 18:44:23 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        kernel-team@fb.com
References: <20220421091427.2118151-1-dylany@fb.com>
 <20220421091427.2118151-6-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gmail.com>
Subject: Re: [PATCH liburing 5/5] overflow: add tests
In-Reply-To: <20220421091427.2118151-6-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 4:14 PM, Dylan Yudaken wrote:
> Add tests that verify that overflow conditions behave appropriately.
> Specifically:
>   * if overflow is continually flushed, then CQEs should arrive mostly in
>   order to prevent starvation of some completions
>   * if CQEs are dropped due to GFP_ATOMIC allocation failures it is
>   possible to terminate cleanly. This is not tested by default as it
>   requires debug kernel config, and also has system-wide effects
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---

Dylan, this breaks -Werror build with clang-15.

```
   cq-overflow.c:188:15: error: variable 'drop_count' set but not used [-Werror,-Wunused-but-set-variable]
           unsigned int drop_count = 0;
                        ^
   1 error generated.
   make[1]: *** [Makefile:210: cq-overflow.t] Error 1
   make[1]: *** Waiting for unfinished jobs....
```

Maybe you miss something that you forgot to use the value of @drop_count?

-- 
Ammar Faizi

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB394CC02F
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 15:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbiCCOlr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 09:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiCCOlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 09:41:46 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D218F229
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 06:40:59 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so5067575pjb.0
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 06:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=w9SeCTTfPOMpZlaZeTxmD08SwR66pORbsklOSsmoU6E=;
        b=r+Ua4xpvDToaxfPBEdimELo/lWEwKUB7rJV8QX4scAoU+vh8Ym8nbc9lgHq8hSf5Hs
         y2fKbJgsUhuKelaHF9ulypRRVCxAcdOZ734pJAhmdy+/F/ow28XtMWe5dXvdLfxPCT8j
         RE5IVdy6Wl56FBdVwBVATY1B2SswlwHyszYG5PykyQOi2b432qvED/DKeklfQSBqwEbH
         J4gNAmFft/Ih1IN9BVxB4yUKzVEjt33MMwjQyYhVOVlEdnJky2O3opdnHyvhhoCRKQmx
         mdG8RBSWT0MHqSwkFM8WmxxM6SPkQZj2R0CruIRs/xUR+XAIZuGCXxaIHIRe87VzK7U0
         oMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=w9SeCTTfPOMpZlaZeTxmD08SwR66pORbsklOSsmoU6E=;
        b=VgaS3ZCJGlteMlcQpT4E1I28D0XqIFXCq2MXafWzYYmFMx5UTaZwmcSi4Iz+AYxy5/
         t4XvHQSgKwiJ08G9tlPKk6+/aX0ctceHXwg4qIyAc4OzJ7s1s3VpCnwZty03DfXy5hAo
         FVHzPY8eJNQxvAU61ssrNAOpOjNYQOnNqWnWsG9RVikO4DE8szC/UqqQVwgd6liBWy/A
         2EiLnhhCHb8DY6Q+cuhKLszW88ZbeOF7aXFa86PS6y23KIzp4+U0Vkljuua8n0uuTMWG
         RPUHbnss55tLR+uhqhdkH1P5UUK3m4M9BSZWaNp0lTSq/hz8Vec9JjvP1uvoqhyPMZRV
         9x3Q==
X-Gm-Message-State: AOAM531MUnAFAiY9fsO2BoztZSIiv7dyrXo3zpAseTt4EH105/7N53WN
        tZD2+3j2T8WebZMSGzJPCsAV4FtqqKXfLw==
X-Google-Smtp-Source: ABdhPJwpm6MyYPMj/oYwo7FlBVw3AHBHU1oUb1bPgpihsBw/T43geSOiyaIwaOcEkhzkALYTMAndIw==
X-Received: by 2002:a17:902:7283:b0:150:b5b:5375 with SMTP id d3-20020a170902728300b001500b5b5375mr36581552pll.90.1646318455130;
        Thu, 03 Mar 2022 06:40:55 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o3-20020a056a0015c300b004e17afd9af9sm2870249pfu.92.2022.03.03.06.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 06:40:54 -0800 (PST)
Message-ID: <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
Date:   Thu, 3 Mar 2022 07:40:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
In-Reply-To: <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
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

On 3/3/22 7:36 AM, Jens Axboe wrote:
> The only potential oddity here is that the fd passed back is not a
> legitimate fd. io_uring does support poll(2) on its file descriptor, so
> that could cause some confusion even if I don't think anyone actually
> does poll(2) on io_uring.

Side note - the only implication here is that we then likely can't make
the optimized behavior the default, it has to be an IORING_SETUP_REG
flag which tells us that the application is aware of this limitation.
Though I guess close(2) might mess with that too... Hmm.

-- 
Jens Axboe


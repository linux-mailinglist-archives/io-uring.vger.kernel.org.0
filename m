Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258404FE9BF
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 23:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiDLVEc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 17:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiDLVEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 17:04:31 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B96C74A5
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:51:57 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d4so13736215iln.6
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=wNFXZNvtZrO4vgUMc2PIOKPvuUiEoHIlqJ6c5ytJTuc=;
        b=myA1F9+f2vjrjABMrrRh9Tw7a3g6BpkwCtwdLC/At406tw47dq2guHA5AlPzh5wBxj
         6mjd+tUBlUuFbTJua7gWGo778HzEfNWwML+StNMHUbWxy9abGPUz2ZY5vb4y5JsqVnNN
         2eSCf47NiT3sTJ1INKPuxEstbxgP4jGvO3dQuCRs/A+pGNxDDAAmvimU9d7TsxWo8H0u
         MsA+3taxNzGGdq4bBNPOfdZ8psvwUJI/IBQ4oKM1twSUmOwnS9RZTg2z+RCdm/FjaAzt
         seubmrJCK35YcRSKrcrFZ5fylFhKlO7FxsP/AvFzj1Zd9TgRiM7rl7MYrfWKPXZDKw41
         XPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=wNFXZNvtZrO4vgUMc2PIOKPvuUiEoHIlqJ6c5ytJTuc=;
        b=HhqBuFyHFjnf7hYVWouvMz/2QIlKQQaPdZ7/adC8NDLH9HgWcWUKskBUdOnPblEtw9
         osxpH7lOwfOEVBcOpTQMDOubnr6m00OjILF2mqxLCCcOtRmcif46ftldV1sXquUcMecP
         9oBOSx5hU+R1rTIxIEoqwTqnRfMGLwUYcXrRTHMocylN6QETg6ZZfHFi6Aq95MFIYjxY
         XMY2heeC0pNZLeGqlTeouDR/8S/UvMIISOgnUnB0VVEtqoGrX4PfxetcBltCENuFjrYE
         KU7sqPCEd1Bg6puX0LQEx5ovWrehOJRt3B5xocGB2ZAS7zt3E7hbWvzi3F1fsV+xrncB
         elvw==
X-Gm-Message-State: AOAM5303pdLLUUA+3NILiuVE6/TyeV8CS6IdFb1+1usw7APZT/l+tWvS
        ovafyWPSAqgC4FrXw8O6MEEmnjBhuXmV5M3j
X-Google-Smtp-Source: ABdhPJz4ALzXmiZKdQU5EH7K9eSMeLO10tZCOYs+tD+QzfCosujGEd6CJcLyh90uv9eIlUdjM+8OpQ==
X-Received: by 2002:a63:35c1:0:b0:386:3620:3c80 with SMTP id c184-20020a6335c1000000b0038636203c80mr31823394pga.327.1649795927348;
        Tue, 12 Apr 2022 13:38:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g14-20020a65580e000000b0039ce0873289sm3660752pgr.84.2022.04.12.13.38.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:38:46 -0700 (PDT)
Message-ID: <a9e32c3e-3f81-5e8e-8a03-3a1f91988a46@kernel.dk>
Date:   Tue, 12 Apr 2022 14:38:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] io_uring: allow direct descriptors for connect
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <ee10eb48-ee50-7efb-54a7-7cb55bb23c15@kernel.dk>
In-Reply-To: <ee10eb48-ee50-7efb-54a7-7cb55bb23c15@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 2:27 PM, Jens Axboe wrote:
> Looks like an oversight that this is currently disabled, but I guess it
> didn't matter before we had direct descriptor support for socket.

Disregard, obviously a bug in my test program!

-- 
Jens Axboe


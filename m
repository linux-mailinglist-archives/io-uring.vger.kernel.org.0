Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6E6D259D
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjCaQds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 12:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjCaQdc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 12:33:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502502293D;
        Fri, 31 Mar 2023 09:30:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id er13so50830648edb.9;
        Fri, 31 Mar 2023 09:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680280200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ckUy8IxYVWgbUK827JnEfOoFEUFnEUlcGnp3eVCTYI0=;
        b=pP54FJOBGDs8tRw7ZYZsyKU0Vaa3IivmckjMNXZcsDmBaNdZ4mSUYalPKh/L2hQJ5o
         YOvwK/QtDIaPVnTzgFgjFDDAauMV4OkwzK1Ag8jnlkzXyvqkbfpyahtXC3TPyGErvOTx
         i41G5vh7nTB77vajIx2ZRRbZuwrllJyrzK2zBvLrLQuUTRDqLysoDVEOteb3cOIHvhMZ
         qmCq8D4USZ3yKk/ztETPM5PNeLcNJaAeUyovoSs9IsQTU5YLn3DgqiXd3dMn0/4UfZwl
         JgYuGu148r3aoD+zpGINjDS8OCWn+WLMAQCpQRPXEkbMa+kOJ0hye/PEzvRvhNdYrvV2
         9xOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680280200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ckUy8IxYVWgbUK827JnEfOoFEUFnEUlcGnp3eVCTYI0=;
        b=dBhb+z7JTDQ86oLwdxq8HyDV9v2pNZKuE2bve/KqKVukEHPtsfhpTL9mZskV2kV1Vw
         XnY1506xeDkmJC0jwj3fF/YvUILF7FHOxYD6rGWBhuP7xZgMPAr1Yz706up0zVjeDaxd
         NHwNkGMLky6xK4HQUpOTH9DQX0JNweP0w4MgUQymlQdF+UCzgn25BSS5bGqw61wJo9Id
         7qq3C2NMEMUH8H9BmPsKQBgteX7wmV3AkroipcwWFcXzCV1xjX29dtMmFoekWcrwo/Ef
         60686VWWJyypNqaTu1sSZvh8qK1JXiM4zGxTs5LBz5K4iWHkktVeKuwp7PmPvZ2Fu1IG
         Tk4w==
X-Gm-Message-State: AAQBX9dCRLEOq5miwx4aM7pMTOkJn0s7TnJ2uIyhEkzDILBF99hy4jeV
        MKXiGDf+6lPHj7RwggSl/UA=
X-Google-Smtp-Source: AKy350aAzlOhZvg2SBc1PyNMNIgN2T20jkwD8ago2aKKNI2LoO92XkP8D55K3CmcnYuOKhpYzuQwUg==
X-Received: by 2002:a17:906:25d5:b0:932:40f4:5c44 with SMTP id n21-20020a17090625d500b0093240f45c44mr27405360ejb.36.1680280200627;
        Fri, 31 Mar 2023 09:30:00 -0700 (PDT)
Received: from [192.168.8.100] (188.28.114.40.threembb.co.uk. [188.28.114.40])
        by smtp.gmail.com with ESMTPSA id a22-20020a17090682d600b0092c8da1e5ecsm1132988ejy.21.2023.03.31.09.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 09:30:00 -0700 (PDT)
Message-ID: <6eaadad2-d6a6-dfbb-88aa-8ae68af2f89d@gmail.com>
Date:   Fri, 31 Mar 2023 17:27:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
References: <cover.1680187408.git.asml.silence@gmail.com>
 <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
 <87cz4p1083.fsf@suse.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87cz4p1083.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/23 15:09, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> Add allocation cache for struct io_rsrc_node, it's always allocated and
>> put under ->uring_lock, so it doesn't need any extra synchronisation
>> around caches.
> 
> Hi Pavel,
> 
> I'm curious if you considered using kmem_cache instead of the custom
> cache for this case?  I'm wondering if this provokes visible difference in
> performance in your benchmark.

I didn't try it, but kmem_cache vs kmalloc, IIRC, doesn't bring us
much, definitely doesn't spare from locking, and the overhead
definitely wasn't satisfactory for requests before.

A quick note that I want to further limit the cache size,
IO_ALLOC_CACHE_MAX=512 for nodes doesn't sound great.

-- 
Pavel Begunkov

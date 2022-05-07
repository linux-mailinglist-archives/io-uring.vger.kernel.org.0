Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E2F51E824
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 17:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245705AbiEGPcs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 11:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbiEGPcr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 11:32:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362563ED06
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 08:29:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso9279315pjj.2
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w5snkalLPq8nNKOldyfRBHJYjmO4+itefoaZvRQgmGs=;
        b=xtgbspjUF4DnU28FtWKzjI/Ell1hoJjF5Xi+fKe8rYp1SabQQ/QznBC7owlz8g5g1V
         2lcb5scyidVo0HyYDIMS+NHLAyU9iHTUxi6MRSX9zUBmGeGvw8wesjQ00aAV2iEBZcyZ
         08IUsexauv/Wea4ZwrA7YS8YbsqGKK7bdt4ziBOSqqHj/FIQQwb48Y9waBXeUg3a2e9B
         D3AcW7a04Jps69qFV9h7PNodTtClxM4uxAgK4L2SHTMtZ9u9/pzukVepGn1ZDIPk0Oil
         ULkxVt6faR6ktw4aOwOdO0qX8kf2dtLD66gC4b7E8Ypphj9+z8f9cehv8hPmUXy9rz7V
         WzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w5snkalLPq8nNKOldyfRBHJYjmO4+itefoaZvRQgmGs=;
        b=mSko6TZ1Njl0DpO4cLueWanBsD2AeHi4GmpA00ToOm068SZ34jc8cxuC0y4Zw+pii7
         b8Y/6Dy5yx5zYiAOyK8ZNz+C0Yol8ftRkd7SkfzYnspdxBXy15ZT+zA1uLNQAtGMyIDR
         KU53KaW7sMmVSor5TdA47mlTbSiurT20Tzh+JL5r71jFphh1e/cYPbma+QXUgk9rlW27
         EgyO8/Ma8lneruPZondsNVxOInXp4IgFRu32LwTSCG2E811OjRvw9Olxwvt66pKRG0CW
         3/AsEx3s8K9Zlcn8v+Sv6XQTMORxyyK6KUgvk9jeoB4KROOCr8QaHy0hd8XUsuzBaVzY
         4rCA==
X-Gm-Message-State: AOAM530NEvgfWac9CGNUtjxu4lBmeemCby77AtL9s+gkJSUaXAqWp0EW
        NCGaOgnq6J4D2jrswOqFnS6Rqg==
X-Google-Smtp-Source: ABdhPJxVUUqh4+Tw57N1Q8d0H/9lV/Oj8vMGbxsAPaB4cjbVjpTkLE3kfvuVDxRDNHy0FTfsdhhvtQ==
X-Received: by 2002:a17:903:2288:b0:15e:8da2:fcc0 with SMTP id b8-20020a170903228800b0015e8da2fcc0mr8917589plh.125.1651937340615;
        Sat, 07 May 2022 08:29:00 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x20-20020aa78f14000000b0050dc76281e7sm5413751pfr.193.2022.05.07.08.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 08:28:59 -0700 (PDT)
Message-ID: <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
Date:   Sat, 7 May 2022 09:28:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220507140620.85871-1-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/22 8:06 AM, Hao Xu wrote:
> Let multishot support multishot mode, currently only add accept as its
> first comsumer.

consumer

> theoretical analysis:
>   1) when connections come in fast
>     - singleshot:
>               add accept sqe(userpsace) --> accept inline

userspace

>                               ^                 |
>                               |-----------------|
>     - multishot:
>              add accept sqe(userspace) --> accept inline
>                                               ^     |
>                                               |--*--|
> 
>     we do accept repeatedly in * place until get EAGAIN
> 
>   2) when connections come in at a low pressure
>     similar thing like 1), we reduce a lot of userspace-kernel context
>     switch and useless vfs_poll()

Overall this looks better than v2 for sure, just some minor tweaks
needed I believe.

But we still need to consider direct accept with multishot... Should
probably be an add-on patch as I think it'd get a bit more complicated
if we need to be able to cheaply find an available free fixed fd slot.
I'll try and play with that.

-- 
Jens Axboe


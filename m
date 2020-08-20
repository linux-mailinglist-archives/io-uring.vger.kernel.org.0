Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78C124AB7E
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 02:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHTAKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 20:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgHTACU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 20:02:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BFEC061757
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 17:02:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so201204plr.0
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vu3C2nHkaibAi0r7iu/KKFCKayZPQvq7h72BYW9dSIQ=;
        b=me3YahkANzzzJDsw/btpETQqyL4LcQ0jO8X3kkfrspbgu6BRfmWpZWfA0zthOZmm93
         MpcULjBXl+1TS3iaKZgk+xFaRD60cGfsLYAAXMoErEazE8HKdlEesZvNFMfNE7KNvShF
         KptaPBzoVRnf3CxmfYsBljHzQPFGOzvsvESuXGTnuX8iTzG2CHorpB/vSaQwxwMhcjLF
         WzrDiaYQCU4Odp1dEJNCprSBHaLdLqnoBla3vkLOtAVb2Ghat3dcS48l6IuNq5jMnF7z
         pLQE5A8KnYQzK94slR4x5H9g6xIufLu177BAWOcoNcvWcJ2jLkxDuytuw2K9TiJGWDhJ
         x6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vu3C2nHkaibAi0r7iu/KKFCKayZPQvq7h72BYW9dSIQ=;
        b=DJvsljnixo/xJsRvOXsoIwple+S+twXzuHAdowxceiHOpfg5MZDyVJmU47xkkeBtkM
         8ePp/JA5t+UHGgwoFJ1DNRwIz7hMqfE0oQtWmqZDaUjFPq5R16l2oxgulON6p1Kfy3zX
         ldT2fiBTmkxyKgoA/lq6vBwFQl0ME/oTULvM68tll3vjLephBBez7o3zdGR3c4yTQ9Iv
         RRucm++Ent6/H0K81kJVWq6Cg68DRtfb1EOZ2IKm4WE24TCtUWxTR7XGpllhpkBsKfDi
         YosLgMtAxSnJwLw2/iLumbgiZC2SvSVJpfNIFZR3z/7xZbjANvGBlMv20GZkw+oyot2R
         Ux8A==
X-Gm-Message-State: AOAM5326XGe74WfjmpzW24GPt9jqrgqRQSxSHzGlsHQazsbsgm6uzPX3
        /bEVVo0yceR1fmTw6kYKHrx4sQ==
X-Google-Smtp-Source: ABdhPJyFs/CprB5sE7zchjANYkCvm6/NDQCtdANATVE/+4V3iFkZUBNbHuX1xuyVGPVpvpjSiWpLtw==
X-Received: by 2002:a17:90a:f416:: with SMTP id ch22mr277116pjb.232.1597881739699;
        Wed, 19 Aug 2020 17:02:19 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q13sm122935pjj.36.2020.08.19.17.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 17:02:19 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, stable@vger.kernel.org
References: <20200808183439.342243-3-axboe@kernel.dk>
 <20200819235703.AA48120B1F@mail.kernel.org>
 <073069ae-6de9-811d-b22e-c4d992ba3110@kernel.dk>
Message-ID: <e3ea62e9-2e76-cefc-b032-77df8e5e3fa0@kernel.dk>
Date:   Wed, 19 Aug 2020 18:02:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <073069ae-6de9-811d-b22e-c4d992ba3110@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/20 4:59 PM, Jens Axboe wrote:
> On 8/19/20 4:57 PM, Sasha Levin wrote:
>> Hi
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: 5.7+
>>
>> The bot has tested the following trees: v5.8.1, v5.7.15.
>>
>> v5.8.1: Failed to apply! Possible dependencies:
>>     3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
>>     4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")
>>     7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
>>     9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
>>     9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
>>     a1d7c393c471 ("io_uring: enable READ/WRITE to use deferred completions")
>>     b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
>>     bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")
>>     c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
>>     c40f63790ec9 ("io_uring: use task_work for links if possible")
>>     e1e16097e265 ("io_uring: provide generic io_req_complete() helper")
>>
>> v5.7.15: Failed to apply! Possible dependencies:
>>     0cdaf760f42e ("io_uring: remove req->needs_fixed_files")
>>     310672552f4a ("io_uring: async task poll trigger cleanup")
>>     3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
>>     405a5d2b2762 ("io_uring: avoid unnecessary io_wq_work copy for fast poll feature")
>>     4a38aed2a0a7 ("io_uring: batch reap of dead file registrations")
>>     4dd2824d6d59 ("io_uring: lazy get task")
>>     7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
>>     7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests completed inline")
>>     7d01bd745a8f ("io_uring: remove obsolete 'state' parameter")
>>     9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
>>     9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
>>     c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
>>     c40f63790ec9 ("io_uring: use task_work for links if possible")
>>     d4c81f38522f ("io_uring: don't arm a timeout through work.func")
>>     f5fa38c59cb0 ("io_wq: add per-wq work handler instead of per work")
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
> 
> It's already queued for 5.7 and 5.8 stable. At least it should be, I'll double
> check!

The replacement is:

commit 228bb0e69491f55e502c883c583d7c0d67659e83
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Aug 6 19:41:50 2020 -0600

    io_uring: use TWA_SIGNAL for task_work uncondtionally

So you can ignore this one.

-- 
Jens Axboe


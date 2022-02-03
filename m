Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B550A4A8BAA
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 19:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353327AbiBCS3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbiBCS3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 13:29:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9ABC061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 10:29:53 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z199so4359976iof.10
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 10:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w2pv08NOU3KU2lIlQuwAWBX3jpye2DFb+MEiE68cpW4=;
        b=h1iCk0AwBLtt+QD/Mwlw3HzGkdprr4NwzHHC+wAFuzPkSB986b6eOLszxktDOv3NzX
         Za01y5W/wBCUdAMWjXaPXIjgI0hUEhyOph8ryqYYpmfaPUeJTLCAS+UhlgTXhOVK1PWU
         xlrix/NdZ3asXRAhgLAiBNLxeFI30j14h489+J/208X2qS4bZ+jatg1xdtREIHT4fUxI
         b7GuJaFWef53w0WUJ+bILCSX6ylyrqEuFqEqwMdyVSyDnDm+WP+onZyIrF2+a5MjSfn5
         2AY7BXZPqF/BtQer4iqanqzgAi4kPvYdGt8oML6iMoE4yhCE8UeZNX+GaHsuV6IAytoy
         eTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2pv08NOU3KU2lIlQuwAWBX3jpye2DFb+MEiE68cpW4=;
        b=ZCmvZBtRKLuoO8wuw86UA5O0kPHvtMYTTdJnwj4Ndau57RnlQIrop7g7u0j8lYyVf4
         W+e3K/8HK72JlzhjCxK+pjzsjX6zbjqLE4iWCUdwDhwDe4cL99ceEJ0tthrbqh2U72hQ
         ZM9q0AN6AVxZ5q3HIClnDAUJA1F3yhC1AQnGmbeR1C843L+xvu81Sv2jT7lP4qOzEL3Q
         4sc07YSaJziv+5pN5Q6NTEHb+ldLAg/F+vCURaxzAYJX3BCWnmkFGJ+TT4xG3rrsmeDg
         20ItceTgBewWM2Lwxo67yEQfWBkHzC4AR077hkngy2vNzrxx/1iMTPIPOkVc9YkBO10b
         gRbQ==
X-Gm-Message-State: AOAM530SkIvnnNvq/FKeyaRBO3MjU6xhrMY+zDMWDnkru/i8nAs3slp1
        RMOOAgeGoR5EwSd0DiDN9wYGjLJIhpaGKw==
X-Google-Smtp-Source: ABdhPJzmmDpJsK13OLmZ6Oekeawwf/XD5/aTa7Y5OmboVbh7q2JfxH01jSrqEluZ6BYWD39xhPA5HA==
X-Received: by 2002:a05:6638:38a8:: with SMTP id b40mr13899658jav.134.1643912993131;
        Thu, 03 Feb 2022 10:29:53 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u26sm18117218ior.52.2022.02.03.10.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:29:52 -0800 (PST)
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
Date:   Thu, 3 Feb 2022 11:29:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 11:26 AM, Usama Arif wrote:
> Hmm, maybe i didn't understand you and Pavel correctly. Are you 
> suggesting to do the below diff over patch 3? I dont think that would be 
> correct, as it is possible that just after checking if ctx->io_ev_fd is 
> present unregister can be called by another thread and set ctx->io_ev_fd 
> to NULL that would cause a NULL pointer exception later? In the current 
> patch, the check of whether ev_fd exists happens as the first thing 
> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.

They are cheap, but they are still noticeable at high requests/sec
rates. So would be best to avoid them.

And yes it's obviously racy, there's the potential to miss an eventfd
notification if it races with registering an eventfd descriptor. But
that's not really a concern, as if you register with inflight IO
pending, then that always exists just depending on timing. The only
thing I care about here is that it's always _safe_. Hence something ala
what you did below is totally fine, as we're re-evaluating under rcu
protection.

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 25ed86533910..0cf282fba14d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1736,12 +1736,13 @@ static void io_eventfd_signal(struct io_ring_ctx 
> *ctx)
>   {
>          struct io_ev_fd *ev_fd;
> 
> +       if (likely(!ctx->io_ev_fd))
> +               return;
> +
>          rcu_read_lock();
>          /* rcu_dereference ctx->io_ev_fd once and use it for both for 
> checking and eventfd_signal */
>          ev_fd = rcu_dereference(ctx->io_ev_fd);
> 
> -       if (likely(!ev_fd))
> -               goto out;
>          if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>                  goto out;
> 
> 
>> synchronize_rcu() can take a long time, and I think this is in the wrong
>> spot. It should be on the register side, IFF we need to expedite the
>> completion of a previous event fd unregistration. If we do it that way,
>> at least it'll only happen if it's necessary. What do you think?
>>
> 
> 
> How about the approach in v4? so switching back to call_rcu as in v2 and 
> if ctx->io_ev_fd is NULL then we call rcu_barrier to make sure all rcu 
> callbacks are finished and check for NULL again.

I'll check, haven't looked at v4 yet!

-- 
Jens Axboe


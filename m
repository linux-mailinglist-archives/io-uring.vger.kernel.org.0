Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAAC4AC0BF
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242797AbiBGOLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 09:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388365AbiBGNqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 08:46:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02FDC043188
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 05:46:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso6621642pjt.4
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 05:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ug9KpH6bIvmPFydrBBlGOiV1ojuh4o4EvlAVOtW+r8=;
        b=Ucb6NZccAO1goAXBmte2XO3+lvr0ZtNlsCU1niaB4QeCGfuaC+ZZ34xsjuiUZ34J8P
         /PnDKyDwwKZuyRevYLH0cVu+uCxqEht+7er+qya2op6bjdApe9jED//PHeQR5KhnvRSi
         o4CuIM7pIIeu74ADGEG1vVJsUXTxHgkEvPzxtrhogxoQg5Pgb1QV4Ds6kJhzGHEfj/Js
         X18y8WlvaeZpnMJicsHItS4pA/ToBOt7PEBsnu43DqRWFYqgaSwsjHYfF7nC2ZYrqTz+
         K3FGWynLI1LQBD2ydHoPIv4f5Q2OU5bpE28FB9kpldJ0ng8rn0wtSRR/4J+59QLHhwRw
         8fKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ug9KpH6bIvmPFydrBBlGOiV1ojuh4o4EvlAVOtW+r8=;
        b=jWAERWdTgElQOFjHCzJJV13m0PEv/W6QVLKsa+1W57wQF4DCAjMNRprS8HPpLhAaa1
         GPn7RDrbl1j6VLl5eQg4U1n3z0x0imzlSw06d//X8ZCB+00MQxUcJB503mSNqwULh472
         3U7ghOwweUITsozuomSIHl6dTibUKBSOoMqhcFG1nya07cIJ5KipRgnCx4XTnZQxmPy3
         K6Ikn9wafn7PppidA92h4BpWSKHlns50X4mglpD00+2OvRYaekpetIXyYIf3uc2uDalY
         q0TsxF5aLJI+NLlrTRMV/BrqC79duz3LdX/X+WXpssoLAis3NNGMYoNQFHQkdiJchJ/J
         IDuw==
X-Gm-Message-State: AOAM5308X/a2T2uQpSYW7uYVKcbpAcXbP6ZBABV47LE+B4YW+SyYR/53
        +oZYUo9jUCqQuoH6t/Cffzs2y48vxcCdjQ==
X-Google-Smtp-Source: ABdhPJy9dgozjBf35cBNjjoa6rNFAeIyMjWTFI96ymPkw8SlosV4+0d7/rydA66/7FD2PEhtZhWwFA==
X-Received: by 2002:a17:90a:f414:: with SMTP id ch20mr8409368pjb.146.1644241609260;
        Mon, 07 Feb 2022 05:46:49 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 198sm8378636pgg.4.2022.02.07.05.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 05:46:48 -0800 (PST)
Subject: Re: [PATCH] io_uring: unregister eventfd while holding lock when
 freeing ring ctx
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, lkp@lists.01.org, lkp@intel.com,
        kernel test robot <oliver.sang@intel.com>
References: <20220207105040.2662467-1-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <696e49fe-3d2e-da6c-2fc6-5d69bc7a60f9@kernel.dk>
Date:   Mon, 7 Feb 2022 06:46:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220207105040.2662467-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/22 3:50 AM, Usama Arif wrote:
> This is because ctx->io_ev_fd is rcu_dereference_protected using
> ctx->uring_lock in io_eventfd_unregister. Not locking the function
> resulted in suspicious RCU usage reported by kernel test robot.

I'll fold this in with the change, thanks.

-- 
Jens Axboe


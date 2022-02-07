Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310F24AC0C1
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 15:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiBGOMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 09:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384887AbiBGNqG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 08:46:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3537C043181
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 05:46:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e6so13022211pfc.7
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 05:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+fYYVy93BDFqw0cCdynsbSRegfY0xYWHIfwAqDxymeY=;
        b=hp3MMQ8ZMedpHg9Nevp1XeEuuEA7IKnvKqo3RmIMgSgkNZVcw4jBrSu78B7Dx97yzi
         ChG12kiPN5PHLwvGlce9A0y5Co7qoc5PD33ihFDc/g1bGg4tbNHvi4ffk8p1O6Ksm5My
         8BtSs5gvT2LhokIb2C3tAO+hrK5GTuyzQrRXirbOgMOoWQh3fse1cb5JMHqHIXxI8Fre
         uYUXkpw437r8QzNVs6c23wTMj6+Kfq6yj2oLsk7GzdQPcsInWy68JVklCfUL8CbW6oGC
         7JMcutC1k+rlN6rp3tNzXDqgVacnpF5Doatrua7fNfYRD/YTFpNYv00gpZYUSBG4Ylf1
         eI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fYYVy93BDFqw0cCdynsbSRegfY0xYWHIfwAqDxymeY=;
        b=H5CdNCyKegJYmxQYP6XRtUtLnnJE+DV9YYoCm4wwl845g5Sy6qFpOC5uI1Fb5ecXbO
         UZg/O7VulCIxWGnnjk7D/VBvv/7L1A9Q/37qRSSJsWD96MZKhYCyEqFISFBQXSZCABDI
         DSpQbILw41JgWFnmks/k57YS9h0WXDmqBimGPkQFwYManaJRckbbN6ueiRFYuwqQNAvb
         gCg80mDKNphN6YQFX/hliMpoG70CrC+GBfe5uWO1cvnBP/2Ki2TWtLrkAhC7vYGm5LFb
         6VjewIVO80fwuCMPXrXQvLFo4JGo1bZ/jbA7QbapvO8quQbAKpwaCmQ+NzBRUXLH/oRj
         +rkQ==
X-Gm-Message-State: AOAM533f8wo0m1bFoz7brGpKBvewTlPPnRf0b2GVIbrcFakEao8UfSSw
        RxmefUrSdb+fvD4VqNtldi17pA==
X-Google-Smtp-Source: ABdhPJy13wPQSgj1YQJzHPhdlM4opHdCLY6oe1/iBRCUm78RUTw3mK/LTWyJn4eAdyiaxbyeS+SOEw==
X-Received: by 2002:a63:e647:: with SMTP id p7mr9358380pgj.23.1644241560350;
        Mon, 07 Feb 2022 05:46:00 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c11sm12279229pfv.76.2022.02.07.05.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 05:45:59 -0800 (PST)
Subject: Re: [PATCH io_uring-5.17] io_uring: Fix build error potential reading
 uninitialized value
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
 <20220207114315.555413-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <91e8ca64-0670-d998-73d8-f75ec5264cb0@kernel.dk>
Date:   Mon, 7 Feb 2022 06:45:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220207114315.555413-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/22 4:43 AM, Ammar Faizi wrote:
> From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
> 
> In io_recv() if import_single_range() fails, the @flags variable is
> uninitialized, then it will goto out_free.
> 
> After the goto, the compiler doesn't know that (ret < min_ret) is
> always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
> could be taken.
> 
> The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
> ```
>   fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags'
> ```
> Fix this by bypassing the @ret and @flags check when
> import_single_range() fails.

The compiler should be able to deduce this, and I guess newer compilers
do which is why we haven't seen this warning before. I'm fine with doing
this as a cleanup, but I think the commit title should be modified a
bit. It sounds like there might be an issue reading uninitialized data,
which isn't actually true.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD01C0BB6
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEABdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 21:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEABdD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 21:33:03 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD11C035494
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2020 18:33:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h12so4203366pjz.1
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2020 18:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b2oUjF+x1zZ5MEEMsODFLS2JFIsV3hFPTTLkg+0EpSU=;
        b=T8M62Sxaxj0kmrdYhwOUqCHH0MqEevSs6TPNC4M3NF0reG6HJ/fnbC08JTdqXFoDHl
         5qi4rZOn5kUpAf+MXi4ncF2yRO6IX1foX6EEo21m5jJA/BNCaKLuijek/0vZouRkUvwY
         M0rfsMyIibs27OWNWY4zpIoBRyr5cXYXmR5y0/B5ewsuRklzxU2j58INR77EdzFceBN4
         2Qla5dGwkMtlQ9MYeW4babQkMJ+GF/f+yPjeBiaqibMsV/vkP0RTvxIx53nm1zufOtCR
         zFq7/6Jm94ffeVj6bggh31gm+7GZzFuzxNAKp55HAbi3vFe+Ct6IlhuqXUd34uAc/5I1
         IGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2oUjF+x1zZ5MEEMsODFLS2JFIsV3hFPTTLkg+0EpSU=;
        b=iklMY1puO3YMcdumc8kbjF4xFX6oXszIkilnae2AfQw27xLHdGEde6WLFj4+rrx2hU
         HNov966GjdvJDxLOeHFPfOidQh6khtrWt8orh3/HKJlgvquji6209l0Om2yGyNrZApLX
         BqkuhELrc9PaV9rfVyS/JbkNKbZyqxL5WZslDIgLJdd17eYS21a7uxyqD4iAyUe6bQLo
         gCou4jny9IZkZ0NaFqxP0XQSyGjc34nGRf4QGb/fX7oJ/80z/I8o7jkW1Df8vICV5ivp
         7dY7lb8+A4qWE2VoRG3F2ge6HQijEPW/MNkq2XhX0hDKqZeOa62E+T2XsCOmbIfZYnic
         vS3w==
X-Gm-Message-State: AGi0PuacVKEmE3h+gDsGprt3w8gkglkEB9W8cYl9aj79n+uvsmJqau/e
        iWvz98mqCyqfg1Ub2BzP6bjpTfPqbZP7Ag==
X-Google-Smtp-Source: APiQypI1We/R2l7Y83yP8mI/HGpkY8nVhaND9XrpZT9plL2S+u4Ur0scZyxlVgFOajrNkh6sPSiMYg==
X-Received: by 2002:a17:90a:2365:: with SMTP id f92mr1871263pje.117.1588296783068;
        Thu, 30 Apr 2020 18:33:03 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a142sm847560pfa.6.2020.04.30.18.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 18:33:02 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use cond_resched() in
 io_ring_ctx_wait_and_kill()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200501005256.17310-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b4dcba3-8a16-c616-7e39-2325ad8061fb@kernel.dk>
Date:   Thu, 30 Apr 2020 19:32:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501005256.17310-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/20 6:52 PM, Xiaoguang Wang wrote:
> While working on to make io_uring sqpoll mode support syscalls that need
> struct files_struct, I got cpu soft lockup in io_ring_ctx_wait_and_kill(),
>     while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
>         cpu_relax();
> above loop never has an chance to exit, it's because preempt isn't enabled
> in the kernel, and the context calling io_ring_ctx_wait_and_kill() and
> io_sq_thread() run in the same cpu, if io_sq_thread calls a cond_resched()
> yield cpu and another context enters above loop, then io_sq_thread() will
> always in runqueue and never exit.
> 
> Use cond_resched() can fix this issue.

Thanks, this looks good, I believe it should also fix the syzbot reported
issue so I added the tag for that.

-- 
Jens Axboe


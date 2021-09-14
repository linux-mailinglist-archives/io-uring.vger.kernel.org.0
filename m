Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF1540B203
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhINOuk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbhINOuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:50:08 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC949C0613BB
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:47:53 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h20so13381143ilj.13
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CPdIAWEERxDaTOEnCWeFpEdTVzGZnPtk8vcfKk9r5Dw=;
        b=ODF1yWhaZ0s5C9QIu8ApHSS7hNkndULySClJpF6xn8PVqPELIxi00El+97dlKY5l3H
         xw+IP9yN7KKPMO/Q2IiTPdoondaCXrG4rhKPQtk1a1/cWIakBXqlVutT4x2xVyJaQlbz
         opKB73OoxAm37m/SASrBrUHQpkdfPH5MIY467GldbxTkLx8/DNLSKNfzlDpUJ6HzUKCn
         WohZSGCwvtCjb1etsl5ODuFjKuXjWTe26PbPGmIEzrEhLBhFyt0We52URv+MZp69fFyL
         J78U36htJdUW55nmK+7jICjDP4z/rvh/QMAdjC/AZJWoFvCfsh+Awnk/3KUmtefvvBeZ
         vMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CPdIAWEERxDaTOEnCWeFpEdTVzGZnPtk8vcfKk9r5Dw=;
        b=0+L4TyC1i4oVIzBa8qD8stivODX97sZpPWbJEVXyFdnNWIT+cxYmv+PMaAk2BE/Y4A
         RN274MzyBcaZdxSR8wpZjAViFua2zXgD2m86rsft3J4AHgWFetUtGTzDWaPsY7WdsMKI
         5WVKScXUw1cHQ6mBSICL340EmatQOFKx9p0wl61eWKrsSEaN2EolJonhL+OM+tazX32N
         +2Z297TsIw5F0iE/p1wmy5KG8ym/JUDBpvmhw3kjmMr4jxMj80mbNxJE+EBr42VDrDHu
         cSVkOMypliLBJzFWNMg3icP8wxNWJtpEu9oqC5rZnsyh/Rtm6fSECGzIWmfbgEUGPmYP
         ESgQ==
X-Gm-Message-State: AOAM532OKQ6M/OFacLX+7WsFlnwYy03Wigu6X799Xk/35vCNGXhuFIM/
        7rcctP3tLZR274+CeQvtqT1a+2d9tD208h2dwqA=
X-Google-Smtp-Source: ABdhPJwk0SiT9hK/hCEfOtcwNxRhHh/mzfibRlLZsX45wQz/4l4hcwrLNoa9IN/+RBKGN3sFMw2txA==
X-Received: by 2002:a05:6e02:1561:: with SMTP id k1mr804789ilu.302.1631630873229;
        Tue, 14 Sep 2021 07:47:53 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i15sm2991319ilb.30.2021.09.14.07.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:47:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix missing sigmask restore in io_cqring_wait()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210914143852.9663-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d5e72e5f-5653-f738-f675-9ac955d7e55e@kernel.dk>
Date:   Tue, 14 Sep 2021 08:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210914143852.9663-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 8:38 AM, Xiaoguang Wang wrote:
> Move get_timespec() section in io_cqring_wait() before the sigmask
> saving, otherwise we'll fail to restore sigmask once get_timespec()
> returns error.

Applied, thanks! I added a:

Fixes: c73ebb685fb6 ("io_uring: add timeout support for io_uring_enter()")

to the commit since that's when it got broken, that'll help with
stable backports. Not that it's a _huge_ issue, it basically means
the application is broken anyway.

-- 
Jens Axboe


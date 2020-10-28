Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5829D890
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 23:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbgJ1Wd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 18:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387572AbgJ1WdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 18:33:25 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E8C0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:33:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z1so323600plo.12
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iTJyMNABss5yRFu7c3CfsJi8yzykBstceqj2JHylJqU=;
        b=faVYwEbtZkqLLaOdgytFSnIg7I1AaV8ijmLdJSy9sZVNlqDvx/Kx/eeiPfM0ctL8XH
         vvQsB95YfdSx868O+5jnV/R6suq3QKhz5vhvYbGOWvcfpuTm1t6nyFlUMmOgjiHhKN69
         ZlpXiip0Z3IxpnQ611YV1WvgsHinQvHes0bGKK8+DqJ9afX7s3ze6vG7bCqrOOy+HhlU
         p2lz/J14zsHaMKFn+bItmWgOMoq/8ctf1Xd5HIWV8JRCDjWqNaw5ZDvvDdRgAzfLRJP+
         KjVGedgV26fN2X8YVQ/rPu3Qo6Vf37w7bZzSxykl+NATd0+ngWV4taugs8k/RTvSM0o9
         yTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iTJyMNABss5yRFu7c3CfsJi8yzykBstceqj2JHylJqU=;
        b=Ocf5Cgpj9lO7WDXMb7jqsQ9BItUCgDyqOfNgjkvR00b1k6Mp+3EBybOnYQWEiY/pRr
         tJzlDuXWrTGqx+/1/ZJ866UYehXjdjb+3S0zWPmpkbxFzIBH8GS4TCwkdS+yXT+RPItN
         UWawiurxmxg7T/G/nvurIV7FIPf4weYrVu7zZoOwn7w+y8bpIjG5bQ0UcMA1AqVsSn4T
         45huJGS7v7U+bi39SYr/IQxoLUq/UJhJraueoNCPF01I4pnS3MDYGCESDd2om4T2wlHS
         ufN/Xj/mZvBCcM3nUn653p3khIKWy7LaKs1wmYnQojn374YgMzVBRO99M0LKQBF2Bvd+
         t3AA==
X-Gm-Message-State: AOAM5304/50crfZ6x0SPLdJBwF/hTfD0h1d8AYXxcdjKlj36niskZLS3
        4Nou/A4TFZNByEZNC2k01X5llJeXvzh7xQ==
X-Google-Smtp-Source: ABdhPJzPC8xVi28zpQDGFpGepFlOaGcXBUIxNFPldgy//O/qWt0EMKWS9B8kSRMWF7+cXQ3MWK1MFw==
X-Received: by 2002:a17:902:8647:b029:d3:d448:98a8 with SMTP id y7-20020a1709028647b02900d3d44898a8mr1153573plt.29.1603924405279;
        Wed, 28 Oct 2020 15:33:25 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y8sm607411pfg.104.2020.10.28.15.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 15:33:24 -0700 (PDT)
Subject: Re: [PATCH] examples: disable ucontext-cp if ucontext.h is not
 available
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <20201028023120.24509-1-simon@bl4ckb0ne.ca>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18887bed-0e96-5904-5bbd-147393e1eae5@kernel.dk>
Date:   Wed, 28 Oct 2020 16:33:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201028023120.24509-1-simon@bl4ckb0ne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 8:31 PM, Simon Zeni wrote:
> The header file `ucontext.h` is not available on musl based distros. The
> example `ucontext-cp` is not built if `configure` fails to locate the
> header.

Thanks, applied.

> I also noticed that `make runtests` fails on alpinelinux (5.4.72-0-lts
> with musl-1.2.1)
> 
> ```
> Tests failed:  <accept-reuse> <across-fork> <defer> <double-poll-crash>
> <file-register> <file-update> <io_uring_enter> <io_uring_register> <lfs-openat>
> <lfs-openat-write> <link-timeout> <link_drain> <open-close> <openat2>
> <pipe-eof> <poll-cancel> <poll-cancel-ton> <poll-link> <read-write>
> <sigfd-deadlock> <sq-poll-dup> <sq-poll-share> <sq-space_left> <timeout>
> <statx>

It's been a while since I double checked 5.4-stable, I bet a lot of these
are due to the tests not being very diligent in checking what is and what
isn't supported. I'll take a look and rectify some of that.

-- 
Jens Axboe


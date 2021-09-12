Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D87407F3B
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhILSUR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbhILSUQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:20:16 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2862AC061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:19:01 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y18so9205465ioc.1
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NvoMELoof2pgZdJvdv3xLpz+7xC1NVchy/vxcYS67jw=;
        b=lqTsjEhukaZpAAGc3jf0CWtg/3FVonYfC9Ud+jjgRgBC08jvoCGCF4eec90jlEgJgs
         /PiXM1ScN2WaDBM/Tp53ji+E24wnzxvpKaPjKtA1wZEOn6N2bB36QwggH3MqY7ps3ZDr
         hz6erHi1tgE+m3iG0F6qkHqhnXXsZxEsRZ8ejkzj5Kq1RJwnWTbJOZpgx5WyLvLf4s50
         9N/tDUUf77F9dkW3kl8BtHSnvoOzbCvcO5U+qv6jNAf3bQuBU85MdznT6hIUNw2nGzkw
         p2loAB3yPzwABXZWd0WW/ZJEEk5ftnbHV4q1Wf2a/PTUkh/T+fhJ5skzcWMxKS74SFkZ
         5XdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NvoMELoof2pgZdJvdv3xLpz+7xC1NVchy/vxcYS67jw=;
        b=piWKSiePY4H2idAdiY5ECA1a84zp8s9NUmtZ/i5eNMHz2AfBRRYWW2E0MaFACxgJoM
         /kQlqlv2Q3BeVnIAwXPzD8SFg63SVHkaY7rWk1FCPQ9WfRLr/U3ATt3FJgHL8REsBv7m
         LKawrV2sVg9XhA6BW1lwKpxqOxxhrB5JvJ9t49fCR3GeokrzNqAUo3u0hYLOaBPP2INe
         3IdJix06LWVFgIadDg3Sg3CtgX5A7CSBST6rC7GIcqikpdKsAHett07uWA6xF5fmhvCW
         k3c1bq2ztfKRrWO2S7lOiBSbVwlQh/axvo47fyBmjyI75RTajge6IOEQM3ffoO9r3NLn
         LeGQ==
X-Gm-Message-State: AOAM532/wX3YitMlzjqt6WgdCaSODJE16qY0q7f7o0wvnRA1vyMT8ZIg
        /VeT6Y6jMWUwNjTNo7YdCk83X76GdlbIzA==
X-Google-Smtp-Source: ABdhPJyfSa3IjH6X3+/eAqqXjZG9qAnJ1L9t4aEtaPqBcyFlgVu6uFp34FttR1hD2dT3DBffz5AlAA==
X-Received: by 2002:a05:6638:2690:: with SMTP id o16mr6512672jat.65.1631470740571;
        Sun, 12 Sep 2021 11:19:00 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m26sm3086112ioj.54.2021.09.12.11.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:19:00 -0700 (PDT)
Subject: Re: [PATCH 2/4] io-wq: code clean of io_wqe_create_worker()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-3-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <47404d12-888a-f8cd-2d75-e38b1c5b490e@kernel.dk>
Date:   Sun, 12 Sep 2021 12:18:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210911194052.28063-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 1:40 PM, Hao Xu wrote:
> Remove do_create to save a local variable.

This one looks good, it's easier to follow as well. Applied.

-- 
Jens Axboe


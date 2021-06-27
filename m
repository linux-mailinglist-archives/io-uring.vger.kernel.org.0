Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3153B557C
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhF0WZW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Jun 2021 18:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhF0WZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Jun 2021 18:25:22 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669F3C061574
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:22:57 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id s19so19857144ioc.3
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+nCXoWh9Uc8L3D9TFiUZjusA8OAUhgOTu2kLDFOEGH0=;
        b=pOEzcQYw7P78FplLifMQ8MEIaxPxs4yEC+ihq62N972wV7k5mleFEsX+PCn5ok8JIN
         nN5uSdeH8kL4J/Jz8tY7wdYogUV/6R7XEQSWU82ih4ckXmgqrebiJ3MszOTWP/9zrNYd
         Kk3hf3uBFwC4m7aRG5knTMIDmxmGDc93kOI/K3ERGEgycRE5o523JVMvzVDm5VfqAogD
         NP8weUYn+15M7+bXgvPpEtLLPlr/05eKjT3aJWy1VcdtnDyRVV2oaG5LvOBKFWbSDLTT
         NMcYIkHwZNK3UB0hq3Ij0VThKDQSi6PgH56obBbgFNSJtVu4fRJXsusT63/iC2uJbz9A
         nZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nCXoWh9Uc8L3D9TFiUZjusA8OAUhgOTu2kLDFOEGH0=;
        b=AAFJQc3l7Tf/7WADNZNFEosdIZM9/C/76GV0eDOetmW+u9hYO+hOcrw1ez1CDOl7Ey
         sByDkW59Oa+j6OGxF9pUSjJGJH2I8Y2BeZtZ9bAfXQE09+2QEk4/aAco5FzpYlRr6N/J
         hGC0w53glGOBMmy+MFaHq9UYGN/qICnfc1kgmdg5+hgqQXfNzQlWhAdPvX5K1bIWChSQ
         zwQAxQp7Qhrhw8Q6U4GfIztAzTMV/mzG1rFVHs8l9YYiJOvZ3UqaGKMikbPJ37UeIhZK
         QZKZghMSg0LpxDL6+UTWMnR0A6LuyDV/rZk9UFQoJFcYPTPQ2ZGXafcHuwlyiOqXTpQD
         CwNA==
X-Gm-Message-State: AOAM530hh2GI/guZWEBgG4VMq0DCcrUpBJ96zeHHqCMmyjqLPchWaQhW
        5k1m+b7xL3ISs9KIATvcQh1oeg==
X-Google-Smtp-Source: ABdhPJxGok6do0RnXmo0BSLj8aitn34aPyERpaujbVT7Q3iX1QvYD4cUQJNotob28qkOa73cp4oYpw==
X-Received: by 2002:a05:6638:3806:: with SMTP id i6mr19772276jav.9.1624832576559;
        Sun, 27 Jun 2021 15:22:56 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i6sm1389777ilm.85.2021.06.27.15.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 15:22:56 -0700 (PDT)
Subject: Re: [PATCH] io_uring: spin in iopoll() only when reqs are in a single
 queue
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1624829850-38536-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15e9d60f-ec71-f0c8-1cc3-01efffc0eb22@kernel.dk>
Date:   Sun, 27 Jun 2021 16:22:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1624829850-38536-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/21 3:37 PM, Hao Xu wrote:
> We currently spin in iopoll() when requests to be iopolled are for
> same file(device), while one device may have multiple hardware queues.
> given an example:
> 
> hw_queue_0     |    hw_queue_1
> req(30us)           req(10us)
> 
> If we first spin on iopolling for the hw_queue_0. the avg latency would
> be (30us + 30us) / 2 = 30us. While if we do round robin, the avg
> latency would be (30us + 10us) / 2 = 20us since we reap the request in
> hw_queue_1 in time. So it's better to do spinning only when requests
> are in same hardware queue.

Applied, thanks.

-- 
Jens Axboe


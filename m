Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6543F798D
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 17:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbhHYP73 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbhHYP73 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 11:59:29 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E000C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 08:58:43 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z1so31543493ioh.7
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 08:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rb0jVycOgCUK9nIqqezN9iYmJXrjmc8PZcfYC0vnLCE=;
        b=iF4cEpuk0yAJflXM4upNk9L6r2i0aKzc0FAjrYKHYj6nFltUKE4NB0oqm6/uIQnQh8
         1yNVV8X0H4pWotSh4N0fLAQHH3eoXcY3QbDECC3uH9g4BAelt03kwY2kRpCI+s9E2K5p
         /dEFYgd6qaC8947rt1H0AaJ8PlcilcUyAPQgx1y90E5rmzGqLzEsiOtm4cMRfpU9ptD4
         pscrfosQGis/wB36Mqn5m2Z7fk7IxA3aPcnvKjzsat++q0UiQZii5scMHts12teWbq+V
         KR4ouefCvZSBPkFP+0bT1hybAeZcAoZUlit3e0cs01k+nGgw8b7XaDjMey8SBmbZNLx4
         5Mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rb0jVycOgCUK9nIqqezN9iYmJXrjmc8PZcfYC0vnLCE=;
        b=uCDuGL7kXhDwhnnZ2IbypW1e4wA04HY1pE5S3AA6htDEv5Cl0dovGMqXZhmjUK6rJo
         kBszE0/S5tKrBalpI8aLlRXIfNfu9IR92cmoLpt7KGxh+inIDaSVJKbDUXi3RYCtvtyJ
         nCLyTfI07VHK8/pLvwwVu3Zb0punaWh6WLAF1mECDe1GCVKhpxTCOao3QYyYQ/IdnOSJ
         Q28qu1dKz+olLOUc4o8BGnuHypSPX8HPEGSeq3txTp2R6eSXl47sBt01dU/R6nPIBLfL
         PK0cDtFyUGzPf4oBeIY7xOw8MIMNSiRwCa3qqpXONkaHFnoQYrLoc85GoLSEgQsC0Mn5
         aFUQ==
X-Gm-Message-State: AOAM530LsEbm67OEHDQSMbGPcitwhrX0VuLF50pU+RCXubJ5kOnuOEGZ
        o6GUCd7dgCW05dYI13E8uoyOfTRMhzK3rQ==
X-Google-Smtp-Source: ABdhPJxTrmPYKXYCn0hrF/PrIr1QQ/hSsNuwkp0L8Ge3o17qIpg0/TxwKizy4kQgu535U5rXpCCw6g==
X-Received: by 2002:a02:7312:: with SMTP id y18mr39920213jab.129.1629907121466;
        Wed, 25 Aug 2021 08:58:41 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s7sm63518ioc.42.2021.08.25.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 08:58:41 -0700 (PDT)
Subject: Re: [RFC 0/2] io_task_work optimization
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <503f1587-f7d9-13a9-a509-f9623d8748e9@kernel.dk>
Date:   Wed, 25 Aug 2021 09:58:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210823183648.163361-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 12:36 PM, Hao Xu wrote:
> running task_work may not be a big bottleneck now, but it's never worse
> to make it move forward a little bit.
> I'm trying to construct tests to prove it is better in some cases where
> it should be theoretically.
> Currently only prove it is not worse by running fio tests(sometimes a
> little bit better). So just put it here for comments and suggestion.

I think this is interesting, particularly for areas where we have a mix
of task_work uses because obviously it won't really matter if the
task_work being run is homogeneous.

That said, would be nice to have some numbers associated with it. We
have a few classes of types of task_work:

1) Work completes really fast, we want to just do those first
2) Work is pretty fast, like async buffered read copy
3) Work is more expensive, might require a full retry of the operation

Might make sense to make this classification explicit. Problem is, with
any kind of scheduling like that, you risk introducing latency bubbles
because the prio1 list grows really fast, for example.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5143D20F6A9
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbgF3OC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388108AbgF3OC0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:02:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C34C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:02:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c1so2253929pja.5
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1SwETOwhFum1Wy7jGIwDfEXPL1VjGXKxI2f6NVuwitM=;
        b=W59Gp2wsoDctnHqQdsbtDHHS1uf/Yra/vqABTTo9EPijQf/AjOy2SgrIU0hTgrd2hQ
         25oEDWVu8IjFkMTl5bHRII5BvecQH3GKhq3R7tbLdR8dlJhGWTUX5S3u1y/qOFWmXm8Q
         zeHs1tiOpqBBYrUp4x3OArdZRcvYut0/RWBrWVqIxYIMFsbOMw9HSm0TwRnPVrbtXW9n
         QAzfDBbh782GLb4CiOhkE0OOQMTaIQ693ly6sfWVaOB/SQdJdQwfjiRyn8wntzwbj9YR
         rK97qxwHIHH5Dm1XKC2YRW7YQPdiN7gBlq3oUWNUId9PgM/rJZfDvbZ7l6roqEQqiU5s
         OLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1SwETOwhFum1Wy7jGIwDfEXPL1VjGXKxI2f6NVuwitM=;
        b=rXxn3mWI+ULpHTV/BgqgGIC7YwL9fMPdLrnWenhQUEN5DzuIA+m9sNZNoXeFizzMhX
         /bVW5C/gxP+qxNqsQbrjhWcsvsTnwPgunAiq5nIq8duP1/NTqs5BHnKhNISLPTEFFN0n
         CULioosf+c8rNoIcCfhXGjCV8wUcn9vVf4RBeouStpOCo2GsZmk6wPSC/VS3VVao2OTF
         3LDejgVRgs0U80PbjaQGkC/epKVgTr7S8G/LG/NdLLbIWOYh86tITrIdbTCGnHBr4F18
         stSREGzX7TrcweTtPMdtPjjaPpTQtZLG3fFaLE3cSV8cy3om0Wg5EDm+I/+IaHrb2rj6
         WzUQ==
X-Gm-Message-State: AOAM531EzWSL1X1zBnT6aLW3QfgpXGk7GY6tCtP4BbD9la2LZR3WFMYB
        aO9f5xl7bmCqQsdJpGBuOaYhZLc/Pgrpew==
X-Google-Smtp-Source: ABdhPJzn9RyS14hWwesJghwomTsBV28u5uZPvru3JsF6UMtAOtPNfb/r4a5vjjw7A5S75Zris/FEuA==
X-Received: by 2002:a17:90b:1492:: with SMTP id js18mr14614795pjb.42.1593525745236;
        Tue, 30 Jun 2020 07:02:25 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4113:50ea:3eb3:a39b? ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id i125sm2783832pgd.21.2020.06.30.07.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:02:24 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix req cannot arm poll after polled
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2e7f500b-7478-bd4e-c003-82b931ce27f7@kernel.dk>
Date:   Tue, 30 Jun 2020 08:02:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2ebb186ebbef9c5a01e27317aae664e9011acf86.1593520864.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/20 6:41 AM, Xuan Zhuo wrote:
> For example, there are multiple sqes recv with the same connection.
> When there is no data in the connection, the reqs of these sqes will
> be armed poll. Then if only a little data is received, only one req
> receives the data, and the other reqs get EAGAIN again. However,
> due to this flags REQ_F_POLLED, these reqs cannot enter the
> io_arm_poll_handler function. These reqs will be put into wq by
> io_queue_async_work, and the flags passed by io_wqe_worker when recv
> is called are BLOCK, which may make io_wqe_worker enter schedule in the
> network protocol stack. When the main process of io_uring exits,
> these io_wqe_workers still cannot exit. The connection will not be
> actively released until the connection is closed by the peer.
> 
> So we should allow req to arm poll again.

I was actually pondering this when I wrote it, and was worried about
potential performance implications from only allowing a single trigger
of the poll side. But only for performance reasons, I'm puzzled as
to why this would cause a cancelation issue.

Why can't the workers exit? It's expected to be waiting in there,
and it should be interruptible sleep. Do you have more details on
the test case, maybe even a reproducer for this?

-- 
Jens Axboe


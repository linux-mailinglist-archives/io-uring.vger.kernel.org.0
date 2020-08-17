Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FB224685B
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 16:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgHQO3l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 10:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbgHQO3k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 10:29:40 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67706C061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 07:29:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so7621670plt.3
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5tQPhhgudoPpGgkzjArbW0W0ncezPZFTqoSzqrf/qzw=;
        b=Ik+0VkQiBXIcEhBhwbUmxk2UYFOcJStkNuwgdB/yruflJkeCSXf6WCyqp1r+vbHEDe
         DDpydJEI0h3VvClLiBP2j6EeApPT3hRmEzuBwtIcOjiSCALApbz6NJXQ2D7B9hrMFFzQ
         x/VTO0U2asBzMdcw8gKPKHWI3mcvJKxLD4v0kmdMhDnwnsXWQ7syDkP9uYGuaOTR0itv
         tOBwU+wogST22P4cQ5o1nOn6Y0AWrFC9BYtySMD75PEyegBcuaGSRiv6zi9rt4JRqWek
         yMWQXtNv4F7aXrf2qdfLheElC0QRfshHSan8VoldzrAX8TqvhNoZgEiN3zzrQhvpGBHy
         RIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5tQPhhgudoPpGgkzjArbW0W0ncezPZFTqoSzqrf/qzw=;
        b=Hh4KqQUncx3g4nLZ/vcqT9m53Y/gki3WSAGxI4qKOOjZhhkXBQ1ZI/O5PRNDX7+YZJ
         Nu30ZP3Uis6YsSTS1c7BtTgkvIgS3zZqtHdW0iMJGQkN2rhlAkP4bWAT/JFYCP1my7GN
         MSo+aMUN84MgnOFiYDW5y7PZoO68t+5+bIHbKf6b1HLP5pnJqgswbQEZcS+jgD8nwvNO
         v7rGI51B1qxLFZEyUYWRo5pYNc62D6zRGWLs16VCR8HPKFmN273NVTnSkhv1iPvNMhx0
         PXVidQY+PNh8AOL55eoIzD7lgE5goX+MtUL/chSdOuh3O+a1Vb4BMjKuFqnsT6Dy+f/r
         VQRg==
X-Gm-Message-State: AOAM533m7/nMo5R1wY15qnF62xS8C59u0Y9n67Zn00yNN9nZUNwCeHL3
        fLEYkyye42utcougILCTdLmlfdwLjetP8YXg
X-Google-Smtp-Source: ABdhPJwwXyuBoJJymea82bEP0XbGxe1MW2NMxmRdWiuhmpMyzonkS+cG6L9jyhX4AVZ/US4GN9JC1g==
X-Received: by 2002:a17:902:a714:: with SMTP id w20mr11339526plq.8.1597674578021;
        Mon, 17 Aug 2020 07:29:38 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id l17sm20868985pff.126.2020.08.17.07.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 07:29:37 -0700 (PDT)
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Dmitry Shulyak <yashulyak@gmail.com>, io-uring@vger.kernel.org
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk>
Date:   Mon, 17 Aug 2020 07:29:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/20 4:46 AM, Dmitry Shulyak wrote:
> Hi everyone,
> 
> I noticed in iotop that all writes are executed by the same thread
> (io_wqe_worker-0). This is a significant problem if I am using files
> with mentioned flags. Not the case with reads, requests are
> multiplexed over many threads (note the different name
> io_wqe_worker-1). The problem is not specific to O_SYNC, in the
> general case I can get higher throughput with thread pool and regular
> system calls, but specifically with O_SYNC the throughput is the same
> as if I were using a single thread for writing.
> 
> The setup is always the same, ring per thread with shared workers pool
> (IORING_SETUP_ATTACH_WQ), and high submission rate. Also, it is
> possible to get around this performance issue by using separate worker
> pools, but then I have to load balance workload between many rings for
> perf gains.
> 
> I thought that it may have something to do with the IOSQE_ASYNC flag,
> but setting it had no effect.
> 
> Is it expected behavior? Are there any other solutions, except
> creating many rings with isolated worker pools?

This is done on purpose, as buffered writes end up being serialized
on the inode mutex anyway. So if you spread the load over multiple
workers, you generally just waste resources. In detail, writes to the
same inode are serialized by io-wq, it doesn't attempt to run them
in parallel.

What kind of performance are you seeing with io_uring vs your own
thread pool that doesn't serialize writes? On what fs and what kind
of storage?

-- 
Jens Axboe


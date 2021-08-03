Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BD83DEEFF
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhHCNWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 09:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbhHCNW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 09:22:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21CFC06175F
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 06:22:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so4691885pjd.0
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 06:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ip1ffG0kWxlF47p1RnVHZvZP5Ea9dA29IpexBerj1jc=;
        b=WEUy2RbBZdEU5sW+bsJWwUaJwBjWepfcQI1r9gpdrT1KFXGKOv/UsTfbeYgy61oHtv
         lPPjsDE3wgdTBQp41tRGORrwj3DrwG5NBpcl2vpANSQ0GzAbj8Ib9bGaK1kwo48+6ja6
         ZN2YJuFBC/A4SbvhuLA9ZZzvMZY0rv2lu8vHRJwGikDk/Wbyt929Dy+1Ro0+CDu+B9SV
         hZ7Idk5ERu6bUjAw2NltRkS+LsDBbqKlKbN4kevaiqOFpTGERdOwLtx5nV9uSHZIwbI8
         0pzusRY46dMCYNiNdyTf2pe+cBzXN6dqabKaVHj1wD0nBf2pH+DEMGuZ2LwubIMux6iO
         1VrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ip1ffG0kWxlF47p1RnVHZvZP5Ea9dA29IpexBerj1jc=;
        b=bmUtdSVDFh7WPXPxva/jSHPkDije8vto7K5xryyLCfdSzMdcDba2/kCbv0Aset1fsM
         4xE37DNjiRxXJok1Y8kiHmE7UDVh0x7eDggQY6y1Ko1ipQIGJE8bzIwXKjsMbQwM9IgP
         1DpVSczeZmBnsO0rpKNCg+TOvtg3ty0A8+Ntc2zGtcnTjAe+yghvfs8Z2jkIDXi7I83f
         trlIU4JAUz6jwGKjiH0MU88AKAiI2rm26Sj38HYD11iE15yjNeBaW9jkjqdqXLEtk9rw
         28fUgUkuU2iG4vGJ+b1BBbiiDl/vnU0E44vx2t0XKO86bPafkpbMb/maph4Hnrx+VuOz
         Ewpg==
X-Gm-Message-State: AOAM531LT+g+IedvT2G6qc5BOyQBjF2uILOFAB3iiqYC6n3+XHPYLgb6
        g5WYm2dZwe6DdMgPbP9D44Ls+4Qhs0nc9sVI
X-Google-Smtp-Source: ABdhPJxxsDoRAQFENuyXxeBcI4Urgj6bp/ZrOP0Y4gSLZwdjwteiwoTPkDoekO9i048R3tQMvSB9Uw==
X-Received: by 2002:a63:2c01:: with SMTP id s1mr219889pgs.357.1627996933895;
        Tue, 03 Aug 2021 06:22:13 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id a20sm14848559pfv.101.2021.08.03.06.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 06:22:13 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
Date:   Tue, 3 Aug 2021 07:22:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/21 7:05 PM, Nadav Amit wrote:
> Hello Jens,
> 
> I encountered an issue, which appears to be a race between
> io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to address
> this issue and whether I am missing something, since this seems to
> occur in a common scenario. Your feedback (or fix ;-)) would be
> appreciated.
> 
> I run on 5.13 a workload that issues multiple async read operations
> that should run concurrently. Some read operations can not complete
> for unbounded time (e.g., read from a pipe that is never written to).
> The problem is that occasionally another read operation that should
> complete gets stuck. My understanding, based on debugging and the code
> is that the following race (or similar) occurs:
> 
> 
>   cpu0					cpu1
>   ----					----
> 					io_wqe_worker()
> 					 schedule_timeout()
> 					 // timed out
>   io_wqe_enqueue()
>    io_wqe_wake_worker()
>     // work_flags & IO_WQ_WORK_CONCURRENT
>     io_wqe_activate_free_worker()
> 					 io_worker_exit()
> 
> 
> Basically, io_wqe_wake_worker() can find a worker, but this worker is
> about to exit and is not going to process further work. Once the
> worker exits, the concurrency level decreases and async work might be
> blocked by another work. I had a look at 5.14, but did not see
> anything that might address this issue.
> 
> Am I missing something?
> 
> If not, all my ideas for a solution are either complicated (track
> required concurrency-level) or relaxed (span another worker on
> io_worker_exit if work_list of unbounded work is not empty).
> 
> As said, feedback would be appreciated.

You are right that there's definitely a race here between checking the
freelist and finding a worker, but that worker is already exiting. Let
me mull over this a bit, I'll post something for you to try later today.

-- 
Jens Axboe


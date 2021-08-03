Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD33DF58D
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 21:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbhHCTYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 15:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbhHCTYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 15:24:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842C4C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 12:24:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nh14so19246779pjb.2
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 12:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w9DymvLchH5aMb3GAWMn97lkfwBhWJl1v980ZzD+v4k=;
        b=zQO1hg9d/87poyNoDLjKjfeidAw8VruUuvtF51j8P09ySVaWYz/orTcaiGRLyAjFwt
         Cl96Jvunkcky0dKQmksqPyfi4VMbKV3o8M+xPf/liqxC3L8Sdt6NyAk1KWKQ/afD1QeX
         GD9x00+wuvJP9jaqltLZMjNkvG4VC+QMH+6rH6G4RGXLGRGuZIVS0Rs32ZsCc07372d/
         TpExsJJjZ5jP/DamzGjjP5TMe4RuA6IyeDJksTLDN4w3pU/xnBjgQzam8zpyZ/xrXYab
         gBJN+szqynCtGIZOeHB9/8ixFyejKCxO+0NIXY3w+4b1syXuO3+FcLqPKfhnlEgL7+UJ
         Gfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w9DymvLchH5aMb3GAWMn97lkfwBhWJl1v980ZzD+v4k=;
        b=d+DdYe9qnuyMVyisQgcVtGpAvjOmuu9YfGHBoBNGUlAA1ffXEJMc4GhUPdHURPONIT
         VPKLBwndn3OdZw8QAhRwEEkhdP4KpRmzVhCOTiSVZ1euakeTMMqY3Mk7hHa6cLBFanAj
         /smGS/62hii148S+UaK8diXwtOTIoHpo0gMgEE29RqMNb6gq6rkZTCMHYvW50SGFbXpX
         OXxnIU/Gq7+weLipfxf9tzupxjibE9CuUpvSKM4ne2lPCAu76faRXFQoWBOfvWcykHJD
         QDKDAGhGmrjlRKKwSUfpr26ado7/m2mfWy7m5JjZtE4GpCRJQPu3twkoK2fATtDy3gbz
         +bSQ==
X-Gm-Message-State: AOAM531ld/Vt7o2/YUR1NYA9THQ/1bnWHZKWf0Z2cYWJLokaGb7eHgng
        sc3KpVE0gZPQAPv0AMZDeZ/pPQ==
X-Google-Smtp-Source: ABdhPJzff2CdiHl0o2HSS5pUs4hHmEG8knYOvImsnQIXQxky1eeBfqpmN7egcuIx0f1kdCbZLfyizg==
X-Received: by 2002:a65:4147:: with SMTP id x7mr2555604pgp.23.1628018678973;
        Tue, 03 Aug 2021 12:24:38 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id d2sm18683043pgv.87.2021.08.03.12.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 12:24:38 -0700 (PDT)
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
 <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
 <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f574edb-86ca-2584-dd40-b25fa7bf0517@kernel.dk>
Date:   Tue, 3 Aug 2021 13:24:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 1:20 PM, Nadav Amit wrote:
> 
> 
>> On Aug 3, 2021, at 11:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/3/21 12:04 PM, Nadav Amit wrote:
>>>
>>>
>>> Thanks for the quick response.
>>>
>>> I tried you version. It works better, but my workload still gets stuck
>>> occasionally (less frequently though). It is pretty obvious that the
>>> version you sent still has a race, so I didn’t put the effort into
>>> debugging it.
>>
>> All good, thanks for testing! Is it a test case you can share? Would
>> help with confidence in the final solution.
> 
> Unfortunately no, since it is an entire WIP project that I am working
> on (with undetermined license at this point). But I will be happy to
> test any solution that you provide.

OK no worries, I'll see if I can tighten this up. I don't particularly
hate your solution, it would just be nice to avoid creating a new worker
if we can just keep running the current one.

I'll toss something your way in a bit...

-- 
Jens Axboe


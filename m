Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7206E1D205B
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgEMUoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgEMUoU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 16:44:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22930C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 13:44:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id j13so1494004pjm.2
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 13:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G5/0GM4ZmuZwR2FgC3QWReM0MKhUaUfkrXxZpMmrHMw=;
        b=bkPaGKRlhOXeaw2n/1eHqNp4hfObjbGXmRv2Iub1jab521hwpy+74Y75JQEVBytXtt
         Jg3PoHNbLXiotVcSmJdGiJCkQmt6w+3Rx86VGDCTMZ0M74SrMh07p23EFCEpMC7CdIhp
         GGbnOoRrRZ7lfz+rvkKIrs0Wq3OXd/kaqdOKtkK/jcXHiA0d/Q5402nu5CPTp4cP5Scz
         8i1RIFpmK2hs26o/n75m2agt+cSnS6NutGqNPJHJdIVa8y8gvvVYB4dyXJF+OOwadGRe
         Z/L7Iixey3ve6qww9tw1hDRQfR7M5J3YzbIoInl1QQOd9ZUebQkCzzlsFVEgQ1IvKqEa
         5nhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G5/0GM4ZmuZwR2FgC3QWReM0MKhUaUfkrXxZpMmrHMw=;
        b=dXauKtIl8oX90BBBtoc2fR+04bzfVDXXSX47aschAKyHkJ6Zj0E8xqBexg5lVZ9m2n
         TbiZNu8NfV4jzYtnWMIPdzpJDjDD3yFkOXHCAe8YQz8kH8EdBOwjWSmLlIuUKCQH0Etr
         hv5D6In4gL9TDxgwSsfr5UPz0YEHyXXJ7mI9UbVWLXjQE5e9yggj783EvWB2zuDzLVc6
         0ZRNHOrvGN+1oOqcKGVU0OTkBun7ddRHrHVrIXbkAM/iNj4nL/JjrRenwMB32mkZW+W8
         D0HG8DGeHnGBociUr9KZUcgFPtss8hwIeLtaTYRioKc5hqRAznEgT8+rMI6qvhCuiHVX
         3kIw==
X-Gm-Message-State: AGi0Pub3JU/a9E/rZ32+s71DJry+Wdw2x+FmUV3v/xusGrQ258m88Gkx
        pTS3bk9HSaDPYe9/wqOZNM0WEQ==
X-Google-Smtp-Source: APiQypJWqXEusHksv4Brc3aquk6g4ocIDeG44NPtB72Xl0HZl6C4ejCno15ggtGpLULtM2kN9y7kZA==
X-Received: by 2002:a17:90a:c702:: with SMTP id o2mr36044638pjt.196.1589402659390;
        Wed, 13 May 2020 13:44:19 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::1150? ([2620:10d:c090:400::5:adac])
        by smtp.gmail.com with ESMTPSA id l11sm2497418pjj.33.2020.05.13.13.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 13:44:18 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pekka Enberg <penberg@iki.fi>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
 <20200513191919.GA10975@nero>
 <fb43ddb4-693b-5c07-775f-3142502495de@kernel.dk>
 <d3ff604d-2955-f8f6-dcbd-25ae90569dc3@iki.fi>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <672c5a33-fcdf-86f8-e529-6341dcbdadca@kernel.dk>
Date:   Wed, 13 May 2020 14:44:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d3ff604d-2955-f8f6-dcbd-25ae90569dc3@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 2:31 PM, Pekka Enberg wrote:
> Hi Jens,
> 
> On 5/13/20 1:20 PM, Pekka Enberg wrote:
>>> So I assume if someone does "perf record", they will see significant
>>> reduction in page allocator activity with Jens' patch. One possible way
>>> around that is forcing the page allocation order to be much higher. IOW,
>>> something like the following completely untested patch:
> 
> On 5/13/20 11:09 PM, Jens Axboe wrote:
>> Now tested, I gave it a shot. This seems to bring performance to
>> basically what the io_uring patch does, so that's great! Again, just in
>> the microbenchmark test case, so freshly booted and just running the
>> case.
> 
> Great, thanks for testing!
> 
> On 5/13/20 11:09 PM, Jens Axboe wrote:
>> Will this patch introduce latencies or non-deterministic behavior for a
>> fragmented system?
> 
> You have to talk to someone who is more up-to-date with how the page 
> allocator operates today. But yeah, I assume people still want to avoid 
> higher-order allocations as much as possible, because they make 
> allocation harder when memory is fragmented.

That was my thinking... I don't want a random io_kiocb allocation to
take a long time because of high order allocations.

> That said, perhaps it's not going to the page allocator as much as I 
> thought, but the problem is that the per-CPU cache size is just to small 
> for these allocations, forcing do_slab_free() to take the slow path 
> often. Would be interesting to know if CONFIG_SLAB does better here 
> because the per-CPU cache size is much larger IIRC.

Just tried with SLAB, and it's roughly 4-5% down from the baseline
(non-modified) SLUB. So not faster, at least for this case.

-- 
Jens Axboe


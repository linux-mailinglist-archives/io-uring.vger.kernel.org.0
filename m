Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94943EA8B6
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhHLQrS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhHLQrQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:47:16 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D61C061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 09:46:51 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id r16-20020a0568304190b02904f26cead745so8476252otu.10
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 09:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pq0QUH/VcZ2vtmpr9YCfMhQR/7cJY0M/JWUa/959iiw=;
        b=siOEkxSZN+x8U7kd06QqPGOBt8c1XnEBZERPyizdXqPSjKBjmaJYXwH/sQIo4Vh8yI
         9h2s6Bntv43fORJEoK6c8PxpbZq5DFApx/W7IK1fbG5iLm7lIMVpwbD569VeTqdEnT+m
         jtevUCGJ5rmie157qHeJIJb04etC4MUkcNx6fc+PGROQqThV3e85VcLwgbMAXW5uHrnM
         XKkEsnQy2QMVBR84CiHWzaE6iYiexP2Z5ZJMQjhu7oS5+54f9fDy7VHQbl86Betutwqh
         0BsphwWeR+X5jXILBdF5kKtaq+OfzDAZSvTheOGBS7P9q7LzI/zYRxXVoikr0tnnR2MY
         lWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pq0QUH/VcZ2vtmpr9YCfMhQR/7cJY0M/JWUa/959iiw=;
        b=uh6O2K+67r3pp0E7Sk6P2weZveyeAikMCEB6/I+vvxR7tMicqnWLUsWRTVX736Fkj4
         tK6/e/iO7iCU09am8AP6J5/hDdCC3voMvIWHKD+cm3igOlS1n7kbItQQmpwttl/NK9jV
         PUGNp5brTmIHimT6bGZ8Q0scELyrxWXnbfFqdVc89y5bYoo88XUsUT4eXvee66XpSVpC
         N2Vo7zEK7MiR4d3FB4tYthRWIX4qyxYUQCR5oEWmpDDYNVSxQtT/EBOuzC/+TqnTGKac
         ZlRcUlhy3IYNqLRfGKmqD+uXgaOtuHhu7s/WvYnN2azxDTxwWjouvRVD+E32OgpxpRjO
         X4yg==
X-Gm-Message-State: AOAM5334PV+WCwBm0wgtDYj/lVAlcaUNukEJr4PSjR1f5B+W1QZ6znLs
        A6dMLCSUj/ocxhLliI7hzwqjbQ==
X-Google-Smtp-Source: ABdhPJxLr5Uu/pHS4FOZxHNj7vP7v18Lu1tDBH0DDAys7VNdFZBUit/Tgp7bevXpc28pDR9N+2GR6g==
X-Received: by 2002:a9d:7d0d:: with SMTP id v13mr4216514otn.252.1628786810828;
        Thu, 12 Aug 2021 09:46:50 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u136sm704638oie.44.2021.08.12.09.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:46:50 -0700 (PDT)
Subject: Re: [PATCH 5/6] io_uring: enable use of bio alloc cache
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-6-axboe@kernel.dk> <YRVOrHvfBSKBiBEr@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40288323-8d7d-d068-28b6-27c5794b8ff4@kernel.dk>
Date:   Thu, 12 Aug 2021 10:46:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRVOrHvfBSKBiBEr@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 10:39 AM, Christoph Hellwig wrote:
> On Thu, Aug 12, 2021 at 09:41:48AM -0600, Jens Axboe wrote:
>> Mark polled IO as being safe for dipping into the bio allocation
>> cache, in case the targeted bio_set has it enabled.
>>
>> This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
>> ~3.3M IOPS.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Didn't the cover letter say 3.5M+ IOPS, though?

It does indeed, we've had some recent improvements so the range is now
more in the 3.2M -> 3.5M IOPS with the cache. Didn't update it, as it's
still roughly the same 10% bump.

-- 
Jens Axboe


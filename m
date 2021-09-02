Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9409D3FF0D4
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhIBQMF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346125AbhIBQMF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 12:12:05 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A9C061757
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 09:11:06 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s16so2352803ilo.9
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 09:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VqfFZC7owX9AhxY0eTA4rJhU32knZVRjvzo+21sNXsM=;
        b=1+Ts+W4re2BM1zH5ekGfGjS7rM/G/0wYOWz1RGMdJlh6AUQetHqGSvwTlM/st/hHcG
         TS1BAb9TDAFp2XV8voe0KRam6np1BjWKSmublS4TQ/D3vSXZUh8NaKoKI81BfBGzKWe1
         UF0wL53Y+oTviX2uApEeVGT/BkkosUCA+iZQaUHKq5T4+4zZjxfc8UKYLwgB5ayRMv5b
         mecXuCiqlgsg4CKB1FhxirgYpB5Kug0bAlJ2O4RHhXZYrvgXaC7lxu7rU18J5H8/d+jf
         +5C/2Xd9rgEK8NJW1j4+xC5ycVj2MQZGVBoUl51Tb2QIZuq/WJyqDPGb1DwV8j9T7Y6F
         yQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VqfFZC7owX9AhxY0eTA4rJhU32knZVRjvzo+21sNXsM=;
        b=m6+S/Bp1SWTR73kQTCUIy4MInfiN0pD1n27u2M3ozhj4dMXey7qeKVRBcvH4PprEpJ
         NUiDvQ2NwwdX7hlCR/HwV2zwQDQTwGuV5/nBi5WP7jqAstjs52zFe5Ar9U6SwYY6eE3T
         2N0SRJSYxM0NsFAVXz7uvWLTTdrkzJFwTf1gjTEZpv386ir1CJ63DYulVE/JaHRU8jPy
         wNdDGUDuxg8suRO9lQrbWrc6GBcsFVKAkncwMvcxlaMl8Lm4G4XCjLx6ELZXh70EqGIe
         PErdgJLuJwwjgXDpXszKOjF+SE7gnnu1cUqJudtLhKDHFVVVXaqmcKOO3I2WS3Ni/rxT
         PAWA==
X-Gm-Message-State: AOAM531e0fFKJeRS05/mObzmfJdzEUzcKge1Cr1Om+M4MLryLySs9Tvv
        shkedOvSkihwJjfyfNt1JHd2cpWvdEALvA==
X-Google-Smtp-Source: ABdhPJyaBmcgXntX+OArUutEbrBmsga+w0LH+rnr0AFLAfZjHuz00n7FviNgirbx/rrtq8Wy3tpxtA==
X-Received: by 2002:a92:3012:: with SMTP id x18mr2872365ile.249.1630599065784;
        Thu, 02 Sep 2021 09:11:05 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v15sm1158607ilq.2.2021.09.02.09.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 09:11:05 -0700 (PDT)
Subject: Re: [RFC] io_uring: fix possible poll event lost in multi shot mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210902144843.2668-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <34f4e3a4-c10d-cdc2-4a30-807f620304ce@kernel.dk>
Date:   Thu, 2 Sep 2021 10:11:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210902144843.2668-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 8:48 AM, Xiaoguang Wang wrote:
> IIUC, IORING_POLL_ADD_MULTI is similar to epoll's edge-triggered mode,
> that means once one pure poll request returns one event(cqe), we'll
> need to read or write continually until EAGAIN is returned, then I think
> there is a possible poll event lost race in multi shot mode:
> 
> t1  poll request add |                         |
> t2                   |                         |
> t3  event happens    |                         |
> t4  task work add    |                         |
> t5                   | task work run           |
> t6                   |   commit one cqe        |
> t7                   |                         | user app handles cqe
> t8                   |   new event happen      |
> t9                   |   add back to waitqueue |
> t10                  |
> 
> After t6 but before t9, if new event happens, there'll be no wakeup
> operation, and if user app has picked up this cqe in t7, read or write
> until EAGAIN is returned. In t8, new event happens and will be lost,
> though this race window maybe small.
> 
> To fix this possible race, add poll request back to waitqueue before
> committing cqe.

This looks sane to me. Probably just needs a:

Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")

tag.

-- 
Jens Axboe


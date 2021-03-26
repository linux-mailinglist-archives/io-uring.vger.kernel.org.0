Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6755B34A92A
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCZN7s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 09:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhCZN7a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 09:59:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45B8C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 06:59:29 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e33so4650939pgm.13
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N525R0I1T5gnDP/3pYDdjFavoBHG9Qg5l7r45szAcMA=;
        b=On5nh8B2BwJPDQwCEKPxGLKDv3gYAyj5ajozYNDU4Ce24qYJ24iq/peVoXZaJP+dVc
         2pq/64hQrDfofYJKjVYhSdFgCsGriXtI8NX+u1vqXJozoIB5NZDGF15omc4P7xv0zx82
         c/mRquYRrktbKcqvmaT27SzUmkgBozvx2eZaKBGQ8uMV8lfnWQUSFEBmbFB9OLWHeDC/
         XvwYLKJNai+IrsOEPm7glz55eK8IEUUanTZpt31eYU/UoYfyq3zyvZsc438+KaLouX33
         gxSEVD5wL32jRxNgNlkuvruzM4QeAxcOwgFrftWqb35fGsIZy7OHOUnwlUgD/IDh8pmZ
         bvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N525R0I1T5gnDP/3pYDdjFavoBHG9Qg5l7r45szAcMA=;
        b=unadmDQShu8wVw5jwj8i07ddA7m72r1v99DVN00RO2h66uof+52T4L2NE4dTW7CsO/
         yYQZbhI2RhmnXux5hSDZEBbtwUvr86OsIAhwW1t/YIUC6wdBwBMb8FcU1FbdzicLveAj
         bHHmnA1mZfnQttJrxozSP4WT+1rpSuxJzaaE1BzHZIyQtmR7K+mQjuCDCT4NvESUPCHo
         A8bcdNBoRxq3NEt/Cuht2EGLKwj6qMoBbKBqj51/djI8+j0c2ZMK/ykGTA4WFA6az7NV
         YN8J0HnaEXqIM0jbXqtKB1CuaV7vXfHhGTki0dRgVnl7Pu2B/Q0GdYgkkG9JrNqi9OZf
         9IzA==
X-Gm-Message-State: AOAM532ts8v/HSmRWI/B9IeLl3GyEZFiXLE64S43cF16S6ehjPGhBpe3
        Hb1HdAO3g2gT/0XvlYSKjhry8z0vJ1/eOg==
X-Google-Smtp-Source: ABdhPJxy4yx7KcV09Vt/gQnCAzR92830CABL6QhI9gAQ40ZE1qQ2TJB5VYfnCuiKZjlGm330dxP55w==
X-Received: by 2002:a65:5849:: with SMTP id s9mr6142005pgr.309.1616767169276;
        Fri, 26 Mar 2021 06:59:29 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k5sm9537445pfg.215.2021.03.26.06.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 06:59:28 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
Message-ID: <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
Date:   Fri, 26 Mar 2021 07:59:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 7:54 AM, Jens Axboe wrote:
>> The KILL after STOP deadlock still exists.
> 
> In which tree? Sounds like you're still on the old one with that
> incremental you sent, which wasn't complete.
> 
>> Does io_wq_manager() exits without cleaning up on SIGKILL?
> 
> No, it should kill up in all cases. I'll try your stop + kill, I just
> tested both of them separately and didn't observe anything. I also ran
> your io_uring-cp example (and found a bug in the example, fixed and
> pushed), fwiw.

I can reproduce this one! I'll take a closer look.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8CA31966B
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhBKXPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhBKXPO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:15:14 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E34C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:14:34 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id b3so5862624wrj.5
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hllCaZSS/wUiUKq9o0X0LWVnkQI3VQisXPYPsPgOqLY=;
        b=Wuv18PD4t+go0Qz12ZRQI2u7+q36IWINAqZLxD3w5TaKv0Y6C8UKUGXTbrqzNwCSJw
         8XJto8/DRBQYQQpU8w3o5PwnyWnZZZg3Idb0i6GSWceVrIrqi70ZqC4u2L7pkFjxNbER
         IZxnFsZW0ozMxuQjW5JXBm3B+RkEAHFMl+SDvL6zqC2j+1Wk8KNT5Rbwsd9oVabrWbEI
         N/AmsZFUMGkFXOFwfQNk/QFoUGnhDd4VZqEaUA0yAkifWuOIaeE9+qLPLfrx2g0+IVka
         u4hcn6R4R6U3B0AR9V1Lg7XBUI2zTC5Y1tXI+YYqK4vqYfh8Sx4F0A3ZBWxSOEjoy43r
         qpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hllCaZSS/wUiUKq9o0X0LWVnkQI3VQisXPYPsPgOqLY=;
        b=NspvWNFXSAntKhW2XxReB5nJaO1JCy0gvwuJaYeOsWoZctw6KhcjQWjgsjsMzrMcpr
         W75dMhcd8SqGgD+rAAy7XMHmJaQwgWPD9vdT+VVofEeEBkOYEACoYTUPiPFYIFHh1wAS
         3km3sTfO5O8Nx5kim8vm/BzJem7umz8MGjvKCODu+/Yjx3D9sdEBiJ1kRpslC+7uA1U/
         7zLA4oF+1kPfAFiOP+6WP+h+0DaGA2MRb+BjopRAoALyHIgjz+G20InseZ/2VBxm9Jcs
         oVNkZ7dpYQDLXbMJKv5OydSoyAXA9UnCzVsCAVfW6g3I9row0wanzlz1lp9/4DSWw96t
         7mdQ==
X-Gm-Message-State: AOAM5323tO547zpBvMBIMvxwQ3YJj0TSOWhCk8h4I/n2HL/7IRsilgmq
        oOPI3/qpalB9alvVTCOS0rcg+EYmIuiACA==
X-Google-Smtp-Source: ABdhPJySaOVckOJ4FMJ/qFErmiMDbXRDfu3XrCpBHYZug953Wq/M5/76x6f9t4F1aul9qdVXTHfJeA==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr136674wrn.33.1613085273172;
        Thu, 11 Feb 2021 15:14:33 -0800 (PST)
Received: from [192.168.8.102] ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id w4sm11373589wmc.13.2021.02.11.15.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 15:14:32 -0800 (PST)
Subject: Re: [PATCH liburing 0/5] segfault and not only fixes
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613084222.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <78869a0d-93ea-4a2b-51c4-073b1578da1e@gmail.com>
Date:   Thu, 11 Feb 2021 23:10:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/02/2021 23:08, Pavel Begunkov wrote:
> First 4 should be good and simple. 5/5 is my shot on the segfaults,
> take it with a grain of salt.
> 
> link-timeout failure is a separate beast, it's from the old times,
> and comes from the kernel's io_async_find_and_cancel() failing with
> ENOENT(?) when a linked-timeout sees its master but fails to cancel
> it, e.g. when the master is in IRQ or posting CQE.
> Maybe we just need to fix the test.

Easily reproducible if you apply 3/5 and do

while (1) {
	int err = test_single_link_timeout(10);
	assert(err == 0);
}

> 
> Pavel Begunkov (5):
>   src/queue: don't re-wait for CQEs
>   src/queue: control kernel enter with a var
>   test/link-timeout: close pipes after yourself
>   test/sq-poll-share: don't ignore wait errors
>   src/queue: fix no-error with NULL cqe
> 
>  src/include/liburing.h |  4 +++-
>  src/queue.c            | 22 +++++++++-------------
>  test/link-timeout.c    |  2 ++
>  test/sq-poll-share.c   |  9 ++++++++-
>  4 files changed, 22 insertions(+), 15 deletions(-)
> 

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24A29D853
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 23:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgJ1WbU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 18:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387875AbgJ1WbU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 18:31:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E088DC0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:31:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h6so701065pgk.4
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=18LswsdxcgtY61y4XqqvZgQdXJOnEYlF5rDVgIz71mY=;
        b=b41BD5k1/pHzy9sPtssMybfe+kuZIPnrG1V8K4UoTD5HrjnwOmJ2ZCvfS/M7dEtc70
         cIC9OgG7wqEQ6G1EfxyHRWtmjoFf2EJUqHMeUR23v1LnUgE3KcYJaSuUZeC4En5zvzQT
         Ot90u+vrEOCR6UfDEFgyBZwKBLt1koRDv/h9a3CLPu2NB1aa+FvEP8x4tkSZdwI6S2X/
         f8FPq2WX/t2OnCZMJKZjyWQVxwsBaltNifrpYCOd69IcRYduVfVb0w1aJmvXj5CYxh+k
         HEP6dDxlwbFpzrY4TDtH263SEp2aBljVWrKkFpATIUrNeSUwtt7TlqzoE34v6m0gzPbN
         55aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18LswsdxcgtY61y4XqqvZgQdXJOnEYlF5rDVgIz71mY=;
        b=o0nKd9S7rejKu0jDolPtx9cr7XRWMINJtNFiGwAfMMxbjc9bkqHHTwG8fgf8iyVGjr
         hmgnvCS0N3lMpo4kAMk/Hx2DtuKsGSU485rgwSBA0Na0lOjKMO8gcK7aX/enbVg7jtV+
         OzpqGr7BEor/OXoIkHtExqwyIB7pfs1r86Vhwcm5tGRqVpkABztflx11W1KY72ZG/pH5
         kiAWWAdY8F9E5clxoPFxaKh7TZL8U8ObKTPi1d+O2FHcPijF8JqwVfRQQ6cSMVy/odQS
         0TqSHR2Gjbp69hKqiGzcr9w058LvaBasQ3zsC+6Li9zMNNq7zQqZAkfzEeE+fVI0xJYl
         z+8g==
X-Gm-Message-State: AOAM531mxxMyedS0vnWyymwu6SYSBGX0CfYM/6QH0oZMcMZODhcpbNq/
        BjTtkikPVZOKaHeYyGcfxjAvbfSxM+MOkQ==
X-Google-Smtp-Source: ABdhPJyx46tHdZ7GfsgoZWXhHDkqp1XlfvV+U1kTqDlah1Wb4ZB/OQWQqlktN0wv0WcbgtyU3Liamg==
X-Received: by 2002:a17:90a:c7c4:: with SMTP id gf4mr1006976pjb.220.1603924279229;
        Wed, 28 Oct 2020 15:31:19 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w19sm582433pfn.174.2020.10.28.15.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 15:31:18 -0700 (PDT)
Subject: Re: [PATCH] Fix compilation with iso C standard
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <20201028031824.16413-1-simon@bl4ckb0ne.ca>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <200e1c71-2214-f84e-f62d-0ed4b420d465@kernel.dk>
Date:   Wed, 28 Oct 2020 16:31:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201028031824.16413-1-simon@bl4ckb0ne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 9:18 PM, Simon Zeni wrote:
> The whole repo can now be built with iso C standard (c89, c99 and c11)
> 
> Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>
> ---
> 
> References to the compiler extension `typeof` have been changed to
> `__typeof__` for portability. See [GCC's documentation][1] about
> `typeof`.
> 
> I've added the definition `_POSIX_C_SOURCE` in the source files that are
> using functions not defined in by the POSIX standard, fixing a few
> occurences of `sigset_t` not being defined.
> 
> I've also added the definition `_BSD_SOURCE` in `setup.c` and
> `syscall.c` for respectively the `madvise` function (I know that
> `posix_madvise` exists, but there is not equivalent for
> `MADV_DONTFORK`), and `syscall`.

All of this good stuff should be in the commit message before
the '---' or it won't make it into the git log. Which would be a
shame!

I get a bunch of these with this applied:

In file included from /usr/include/x86_64-linux-gnu/sys/types.h:25,
                 from setup.c:4:
/usr/include/features.h:187:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]
  187 | # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE"
      |   ^~~~~~~


-- 
Jens Axboe


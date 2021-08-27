Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04F63F9BA7
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbhH0PYU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245358AbhH0PYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 11:24:19 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E30C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 08:23:31 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n24so8935258ion.10
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 08:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SuqrvG4jG4ZxKb93MhewLBshu/bVyyizpMfrGr1VlZQ=;
        b=Xm+8gm2mn9AvUveMxqlKKBG31ciH62Itze5FPOVQXYCuaehCNG8wev1U+q/rjGv/a5
         KDU4kuJXY4wQRpDGngE/GiAFW0mbQTgfzZbj9I3ahWO6oY29I8cAYl2YENEJZ63Ldzzp
         4WwmDPyq2B9JLDuP8Yr6XXEVZ2cJRQ8zzNJh2ZsI3ObgXPX8jBd5JaCybMGpnfmqaLVx
         xA6PgHcRN7FT6p2mrvMS3XCHIt6YIvtiLohKTlWOKX+Z05Ve25Ir2iWqKBFaB5fMDxUa
         ik+m6dKBrarMcbc0ibHtScShcBbJlAZ5b5qF1yGnRB2Nea5asDd41TGiAcHPrlWBXCHO
         0vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuqrvG4jG4ZxKb93MhewLBshu/bVyyizpMfrGr1VlZQ=;
        b=Rp74zEd/feDs0PX5o5qWJfqOzb9F6oeNDqb//cWvap7/OSQEoVXSEFEOhf/xj65Ksh
         0bxuIw6aLzUj0Ffhkls0WuyuYLk9rsbe5LjNcxg7sYq7BXG74cbz9vRuOHUBUtBHgpf3
         P10LLW9Xf0FvROKLTM2+OHozMl7GWcDVD0MM63SVJtU/BqtmDrAhJvPMx+PtCbroP8gn
         +kUKHJkgBjxFVVmI14yy4lrGDrkfN31bsA3y/rg5HXheBdIXGIKQdGqrKd0URO4sTRTz
         rLYoA7b/i7h1QjbkD6pj4ibcMBlTGfdGHYjmWJkW8ogiqXh3RDunQYLVWWX8pFLhz844
         qJtw==
X-Gm-Message-State: AOAM532hrLeHawt8xVWHEgg8woBvB8PIN0f1ObF5uZZHeLq7hQiTJXQK
        FSZFpz8UDh0ZysY0kOe/2yWVpmTVAONs9w==
X-Google-Smtp-Source: ABdhPJzIMuiMM+EPPiQkFD9Y1mOQli+itqQqIr+kbLZXJMuAFrYTH1RawjlI7S20Bf70jR3vk9wpOA==
X-Received: by 2002:a05:6638:3789:: with SMTP id w9mr8619144jal.131.1630077810113;
        Fri, 27 Aug 2021 08:23:30 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k7sm3356055iok.22.2021.08.27.08.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 08:23:29 -0700 (PDT)
Subject: Re: [PATCH for-next 0/2] 5.15 small improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629920396.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <749e237a-3eab-924e-418a-0a7ebc817982@kernel.dk>
Date:   Fri, 27 Aug 2021 09:23:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629920396.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 1:51 PM, Pavel Begunkov wrote:
> Just two small patches following past and potential problems
> 
> Pavel Begunkov (2):
>   io_uring: clarify io_req_task_cancel() locking
>   io_uring: add build check for buf_index overflows
> 
>  fs/io_uring.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Jens Axboe


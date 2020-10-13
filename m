Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9C528CB2F
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 11:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgJMJt0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 05:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgJMJt0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 05:49:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F31AC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 02:49:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e18so23200009wrw.9
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 02:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q2ufpIBkQ+NBZtGzXYBorD8FqCsdmdzTEFVvT9919xs=;
        b=jZfQbMORyDWC7Lk5KL/NaV+/Ws9nHkYsuY4+OOqs8U0Li8JYbC+zTY7JrCofk808jO
         UrNfJRdPklrZoyx3NO1b0fRN3rSJapmWEfhYRxu3Mxc3P+hSvMOOWAZz/25oiFbEFg4d
         Djdifhwlu5aFXat4Ha/0fiwmMwX+kN7Wu5KAN5nnQcbVkjMIOR48G+u1TkmBqUahGs5y
         L/wJ1M7fYBNRovj8tIwkUUCoRDL3oEGC8+raXFsTplnUXAao00hM7g3c7wzhs+2zeRCu
         oFnpw+nARmfYR+GpjJ6Dcv+ZJe6RlF4krWWdt2LsOs9IJ6ulNMmnNY1dzcjDL7HsnsHZ
         zlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2ufpIBkQ+NBZtGzXYBorD8FqCsdmdzTEFVvT9919xs=;
        b=U/z6Q+Wpbd65G5Ga/RadvnCjSWUJfN+IexLhAPwtXk1rpI702T9vsqIjeNPkZ/Bq7L
         6gzfPjaK9rAGJ9lnDecbpCXxDlM9HHVyIInU+D62F6uvblj6Mj3hlhm5/szL1EjP7qGl
         lnX/0P3dOz2rR4WRbZz2ABV7rs3QaIErSDUMfOeIOiw0HeIQzyeHYeoPSavOs4p6qThT
         0Z5QAURM0E/AH8UOuyyOWCh9xcLE3360H+Vln5bIOxx83l0xOVyCzQhXqKF5Y7dxehzC
         daQ/3szpoAJ7BVx0cX8hteWQ6C1UgLF5rRbVB9XmHBqDlGabyWoOVjhTgzRUuWZkoV8D
         hCZw==
X-Gm-Message-State: AOAM530iJKI+dXrLL/MoA44ArDlDpNUFLMd+iF/XC/MjpJI+p2mUHQqo
        VhSN0800mybiSm8s7KWP+uFqd74IarM=
X-Google-Smtp-Source: ABdhPJwljb6Y+Wa1HSClrQNAo0b7Y6sAX9Kk8gNYl/MvF0VIrrCqPWTHF/oCkYnoB2fKFOfdNVh29A==
X-Received: by 2002:adf:814f:: with SMTP id 73mr14743614wrm.174.1602582564029;
        Tue, 13 Oct 2020 02:49:24 -0700 (PDT)
Received: from [192.168.1.27] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id o3sm25063885wru.15.2020.10.13.02.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 02:49:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1602577875.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/5] fixes for REQ_F_COMP_LOCKED
Message-ID: <48cf67e4-caf1-c1e2-bf74-b3d487ef08b3@gmail.com>
Date:   Tue, 13 Oct 2020 10:46:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/10/2020 09:43, Pavel Begunkov wrote:
> This removes REQ_F_COMP_LOCKED to fix a couple of problems with it.
> 
> [5/5] is harsh and some work should be done to ease the aftermath,
> i.e. io_submit_flush_completions() and maybe fail_links().
> 
> Another way around would be to replace the flag with an comp_locked
> argument in put_req(), free_req() and so on, but IMHO in a long run
> removing it should be better.
> 
> note: there is a new io_req_task_work_add() call in [5/5]. Jens,
> could you please verify whether passed @twa_signal_ok=true is ok,
> because I don't really understand the difference.

btw, when I copied task_work_add(TWA_RESUME) from __io_free_req(),
tasks were hanging sleeping uninterruptibly, and fail_links()
wasn't waking them. It looks like the deferring branch of
__io_free_req() is buggy as well and should use
io_req_task_work_add().


> 
> Pavel Begunkov (5):
>   io_uring: don't set COMP_LOCKED if won't put
>   io_uring: don't unnecessarily clear F_LINK_TIMEOUT
>   io_uring: don't put a poll req under spinlock
>   io_uring: dig out COMP_LOCK from deep call chain
>   io_uring: fix REQ_F_COMP_LOCKED by killing it
> 
>  fs/io_uring.c | 158 ++++++++++++++++++--------------------------------
>  1 file changed, 57 insertions(+), 101 deletions(-)
> 

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD37329FA7
	for <lists+io-uring@lfdr.de>; Tue,  2 Mar 2021 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbhCBDkn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 22:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhCAXyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 18:54:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB2C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 15:53:59 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a24so10911730plm.11
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 15:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WwYwVaAtO93MKNrvaxitdx09hXcN0E8BrJZhhKrwFg0=;
        b=Ca2PcgKgyBNSaBJincV/XOQp5eMTPjWUDg/E9JZMrVW8CDCbYP1Te8ZqHcuEOMHnOf
         w5KmLEDr4ICqIgEoGTQNJUnDwfNSM/4wkgShFc73wkfLHCNqdyFy4WWR/LLw2BUikbav
         JnniVmVpLHHucqO+hbLRBif7FjstfL4klJbIVug0HirkvFldFefczzYFuUjx5k31nqY4
         dpfd1GMRLdIEa1+5Ld6YURl1/WGYb30xVZibQpJBwFaopulaD5OWYKUp7Lxre2nTIdfD
         g4eWiGUhH8ivURt/tW7FhCdtS1DFQB3x9Jgf/o1unOqZhkG9qKp25QvrA0Ygqh5mUcc6
         /T6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WwYwVaAtO93MKNrvaxitdx09hXcN0E8BrJZhhKrwFg0=;
        b=WCOdm0satA/1idD3k1bLSS6VkMOrlom1DQC30S0pPolCCQLZKDy6HeQ8V0S9StZKJF
         aiQiamcZD1vsXFKSSFGIy3IsKqp1S1NOlxDuLAI/bO03e5PoLaugDJeJm3BYGEGasH87
         KJehprC2g2eRPxWd4rALVrXq1osuUn9Mn4WX4ffeEW7T5ZAGAgNnA+QrG3vhYV7j52ut
         Br4A8N8m5QdI4l2JeqhRGzk8abDfc5MKtVyW+vwRUnVd3HlnTkbGl28Ig+BjfWMOW5/m
         4qazZWbCvcySBJJHHjS6yOR28f7FRRN/S2E7TzpuH4jH5uSIIUDhJxqS1c+wBcP8Ze1b
         FHdQ==
X-Gm-Message-State: AOAM532b9LaFe3bYhXFcJSHh+LE5uZVZdTTGzJI+rdObNoNDpO9lzClE
        ON4rDFMnO14WiBlqCF2ZXF/hRIs4fAdWdA==
X-Google-Smtp-Source: ABdhPJyo+t4JNQVTGGr5YfyznLHnOoAnuw+JXaLY7dtTHG5JBhzj63qsOL8HIobxMd+9rpxR7HlqZg==
X-Received: by 2002:a17:902:768b:b029:e3:fb85:1113 with SMTP id m11-20020a170902768bb02900e3fb851113mr940032pll.3.1614642838581;
        Mon, 01 Mar 2021 15:53:58 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fr23sm551044pjb.22.2021.03.01.15.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 15:53:58 -0800 (PST)
Subject: Re: [PATCH RESEND for-next 00/12] 5.13 first batch
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1614551467.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a693506d-3fa2-c744-a398-1cbf8173445f@kernel.dk>
Date:   Mon, 1 Mar 2021 16:53:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/21 3:35 PM, Pavel Begunkov wrote:
> 1-7 are just random stuff
> 8-12 are further cleanups for around prep_async
> 
> based on io_uring-worker.v4, but should apply fine to for-next
> 
> Pavel Begunkov (12):
>   io_uring: avoid taking ctx refs for task-cancel
>   io_uring: reuse io_req_task_queue_fail()
>   io_uring: further deduplicate file slot selection
>   io_uring: add a helper failing not issued requests
>   io_uring: refactor provide/remove buffer locking
>   io_uring: don't restirct issue_flags for io_openat
>   io_uring: use better types for cflags
>   io_uring: refactor out send/recv async setup
>   io_uring: untie alloc_async_data and needs_async_data
>   io_uring: rethink def->needs_async_data
>   io_uring: merge defer_prep() and prep_async()
>   io_uring: simplify io_resubmit_prep()
> 
>  fs/io_uring.c | 210 ++++++++++++++++----------------------------------
>  1 file changed, 68 insertions(+), 142 deletions(-)
> 

Thanks, I've queued this up for 5.13 - I'll most likely rebase this
branch a few times going forward, until we have 5.12 fully settled.

-- 
Jens Axboe


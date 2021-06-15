Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8073A8B3E
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFOVlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 17:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhFOVlF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 17:41:05 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3247C061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:39:00 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so404820oti.2
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+AJt/jNH05ZTMczIzT+exH/sYoYnluP2JPifAUU37Nw=;
        b=mbdhnPrEKVxyuPFfOQCq2iCf6Rjg4vOhIHG/z0jk5Txtc+oNKsQuchRvgE0Z6PFCw9
         zMr1lFseJJyGWeWQFF6qto0Ep3FfoWIZhEmk7gJlirjLUdfWrrCa7xU/TjoEB1+RAmGm
         nmjOsdrdacHbKRp42jhBwFTv4K12P3B2I3bGfzYk+SL8n9ZV7XrNv36Vv+0/SFUL0b0Y
         tb+0vSNRjAMOHuFQT4xjv6YDyn0uBAmvGwdMARh2XLzQ6vfWeIx7/E5kKvlYr+Aohm74
         1oW2f/4jClldwNyxMlEyY4F7wCa92DApLwENCwJeSXAFTv+KboVhVvymJddiptC3bwsG
         G+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+AJt/jNH05ZTMczIzT+exH/sYoYnluP2JPifAUU37Nw=;
        b=OQykHz+dTUaeII7nINEouuO6lv7BcgGvu4udregJHX9d/Wa1v3AMuZFuKW95ATgzfx
         6Mh+UqQ8KgBdd8zbBWX2JDbANe9XcA1GHVq5YfFlGe2X012DvYihHajlnIVbXGXckRuS
         cW/z5CZkZclNwlWhSYjOPHGKhgv42eWTRoqIp3ZSAMyfS0mJEjzSwINxnYGoS683i7tx
         5Q/tdzsjJ4YXtMbSq23WAVkfgIFhD7gxr2TRd9OPkqa5esmGgcDC3dLmmU54qDShq/t2
         zhbu2RZr7qrzJi9fY4JqcUlM+pf5arWpOJpIwEAEpJIkdy2tgt62X3nkeNKz6LoWVUfk
         xjDQ==
X-Gm-Message-State: AOAM5327EPTdIS+xvAKS3SY01/OCG0qIuHVTo9jlyEs09dIahSQuuJhA
        TAm2H/wLAS/NIfCvBL+FSmOsZqT4AmGzfA==
X-Google-Smtp-Source: ABdhPJxgyC2EUvkoMupfnW3LbGwI3mGbCKKN9mX2foOemI/ftesvp4FnjNpIT1wXf7cGVqPF8P//Pw==
X-Received: by 2002:a05:6830:14a:: with SMTP id j10mr1119283otp.112.1623793138721;
        Tue, 15 Jun 2021 14:38:58 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 79sm45822otc.34.2021.06.15.14.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:38:58 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/12] for-next optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1623709150.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <526459e2-7f43-0823-70f5-6cb9cd4f71ee@kernel.dk>
Date:   Tue, 15 Jun 2021 15:38:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/21 4:37 PM, Pavel Begunkov wrote:
> There are two main lines intervened. The first one is pt.2 of ctx field
> shuffling for better caching. There is a couple of things left on that
> front.
> 
> The second is optimising (assumably) rarely used offset-based timeouts
> and draining. There is a downside (see 12/12), which will be fixed
> later. In plans to queue a task_work clearing drain_used (under
> uring_lock) from io_queue_deferred() once all drainee are gone.
> 
> nops(batch=32):
>     15.9 MIOPS vs 17.3 MIOPS
> nullblk (irqmode=2 completion_nsec=0 submit_queues=16), no merges, no stat
>     1002 KIOPS vs 1050 KIOPS
> 
> Though the second test is very slow comparing to what I've seen before,
> so might be not represantative.

Applied, thanks. I'll run this through my testing, too.

-- 
Jens Axboe


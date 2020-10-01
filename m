Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BE727F819
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 05:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJADBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 23:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJADBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 23:01:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3384C061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:01:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 197so2809354pge.8
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 20:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wR5Wd1YwOIizrjYQwT79zNSBWj89yfNI32sCkKwFq8Q=;
        b=Q9UjhzNVDnfzpaXOaPdNrqbRPeXwLK0QnQliTafPKDn3aNoymy7qse7UMDjqyZia6A
         C6hNDb6dzJ85zAVuiKg85OfLGzcSki9WAhCCJpYUeGboTGHlKv/wRTeyb0/bg8/ks8rP
         ZA71OV1bk8IBdlWThSmXimXsBkwFjhRgpXNvXjoBeNJOfZj4MGf5HudI6m/AZNogTOLf
         jUg/7hSfXlcKLR6k3+8nK3oimyMA/lyjYwTAHvGO0d/4yMIendzhtjnkisw2UBild7Ei
         hX4EytzJefkaXAbFKL0zTyFCxgBEo/sy0D2LrfXqojs0KYRG7r+R4VzJxzMpbEZgukCs
         889g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wR5Wd1YwOIizrjYQwT79zNSBWj89yfNI32sCkKwFq8Q=;
        b=r/AxcyOkHshygPpGetzR3E3t0FukOdQNuSp0dgU/YHOaVCnIp6isKol40draQ2zX2e
         ER+sPZfF42Sbhfq8apQHTYPtR9HpiubSiITPXoZYb2/Arkq+uPCJ2Q26EITZLotHSGsz
         rj9rvT9+HGkLTctJYUtTrsHwbS+xUts3tFU0qDFQhZxdMxVDEd/bAiF9WwMxgWOSE7ac
         dxiNmmlEZP262dE9CYSOPPzytyn+eK69Kj06CjKsXmDkXKa46RtmkUf+bXJpsHcduNQl
         GA32++fjqIuY6Uh03uqj61xw6Y3812wLezqA1tl6kXcQ0jVMJxpSuhNq3VfZZGWzbblw
         NJXg==
X-Gm-Message-State: AOAM5315rgKDJwUyCXSN03p+TIJ7l7yHZqLa6BLdgFHjYcBfpXpXYagw
        +9Mel95j3UDPMkI8CWS6WtA3MxrKKJUW59SJ
X-Google-Smtp-Source: ABdhPJyN0/V2iRuKs5qOO5KAxOgx3hFuvXiP8BiDcmuNZ5p4lu0lBarfdpQtleWcb26egZ9XbGx0/w==
X-Received: by 2002:a17:902:988c:b029:d2:2f2a:8aa6 with SMTP id s12-20020a170902988cb02900d22f2a8aa6mr692406plp.17.1601521309079;
        Wed, 30 Sep 2020 20:01:49 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u2sm3569778pji.50.2020.09.30.20.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 20:01:48 -0700 (PDT)
Subject: Re: [PATCH for-next 0/4] cleanups around request preps
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1601495335.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c93c1317-27b9-aeb1-ea16-c5117ad95ef7@kernel.dk>
Date:   Wed, 30 Sep 2020 21:01:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1601495335.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/30/20 1:57 PM, Pavel Begunkov wrote:
> [3/4] is splitting io_issue_sqe() as someone once proposed. (I can't
> find who it was and the thread). Hopefully, it doesn't add much
> overhead.
> 
> Apart from massive deduplication, this also reduces sqe propagation
> depth, that's a good thing.
> 
> Pavel Begunkov (4):
>   io_uring: set/clear IOCB_NOWAIT into io_read/write
>   io_uring: remove nonblock arg from io_{rw}_prep()
>   io_uring: decouple issuing and req preparation
>   io_uring: move req preps out of io_issue_sqe()
> 
>  fs/io_uring.c | 316 ++++++++++++--------------------------------------
>  1 file changed, 77 insertions(+), 239 deletions(-)

Thanks, this is awesome! Easier to read, and kills a ton of lines.
I have applied this and your standalone patches.

-- 
Jens Axboe


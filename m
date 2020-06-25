Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A6F209FA8
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 15:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404932AbgFYNVQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 09:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403941AbgFYNVM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 09:21:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F863C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 06:21:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z5so3274139pgb.6
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 06:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wJfFA7Bq0B+KC15Q8f+/jSKFh8zbNtSTmbiv4SH+pao=;
        b=licMAqKnCRhl06F26ksnjRZ9QOafA8QE/XeKKNmgnBx9ti8Of3GhZqRCtCvoF883c7
         LtDmj4H8J1OHGOaQjn2f0Gap1eaSckAhjGrmsvdRjGUw5afbQTjJfg3Uq+Ep4AwJuWon
         QDSxptWrPLm3dq9kmjLXy3vZC67/NUyx4iUP3OI4MzsV7V7goaWtd3Hqe52k0VJQ0l1S
         a9RIlvoW4lr3hcQncrmwVIWnr1EAFdn+/D8Ctrv5cAV3TcyWdNlxHgAbAxJf9Frdnjj0
         Q1OMP6kbVZ78XI/b1KQqnnVjNnodm8a+ZfJDUxWQag+hkj3EVmq0DhcX/L4o+3eLcF7A
         N6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wJfFA7Bq0B+KC15Q8f+/jSKFh8zbNtSTmbiv4SH+pao=;
        b=Y6c9lQkDftLCD4cvqu1NODGVAEqwU8o2nr8Mrk6lazRNlD7/mj8atUE+pFdP9rEay6
         9XmLGjjAWObIw2QZgqQ1El2OoGIo9zGBJTTZEsxEc22zjnSTM3qROTt1S3cTeF7kAyxs
         v57ZbBVr+ZimL7ViMj9cIvuhVEWJRHKbc708wwbTb4bRWOhQhtW5pcgvLaKzXn9SX9YO
         x1UGgTjI5zyArTWZhkGIo7KvB/AhGo8AfwMTj8LkJTM1+KAAOS6B9EAhzlmhEoUqJt9r
         W6Kp0KMBzrgDBFET1oseJHVGWrHH0CfQy9rjr9KU1jA3UoglTC2hFanNF+R3s00xuxLd
         8Bjg==
X-Gm-Message-State: AOAM532RGJfubucJ13Az5wOfT2dubSjBNbbL7RK9cEVef8zDT7ERjJuN
        9lxlALkQ663WSnjX7sdix8B3Kg==
X-Google-Smtp-Source: ABdhPJzstZq3G8LqEQvYNcgpNZRXSattYuw9jbSO5BFRHf0Q9aBHqdEpFid396WPzfpVNmgK52mhzw==
X-Received: by 2002:a62:ee17:: with SMTP id e23mr5540283pfi.291.1593091271995;
        Thu, 25 Jun 2020 06:21:11 -0700 (PDT)
Received: from ?IPv6:2600:380:6c49:6812:d113:f43c:df53:19ee? ([2600:380:6c49:6812:d113:f43c:df53:19ee])
        by smtp.gmail.com with ESMTPSA id w22sm23444783pfq.193.2020.06.25.06.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 06:21:11 -0700 (PDT)
Subject: Re: [PATCH for-5.8 0/2] iopoll fixes pt.1
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1593077359.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f5bcef74-95d1-aa24-a5b2-76c6cc7a4e1b@kernel.dk>
Date:   Thu, 25 Jun 2020 07:21:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593077359.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/25/20 3:37 AM, Pavel Begunkov wrote:
> Split as requested, this is for 5.8.
> 
> The only thing changed is 1 line moved for easier rebasing.
> Yesterday problems were unrelated.
> 
> Pavel Begunkov (2):
>   io_uring: fix hanging iopoll in case of -EAGAIN
>   io_uring: fix current->mm NULL dereference on exit
> 
>  fs/io_uring.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)

Applied, thanks Pavel.

-- 
Jens Axboe


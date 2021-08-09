Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F03E4719
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhHIOCD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 10:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhHIOCD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 10:02:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8652C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 07:01:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nt11so4925862pjb.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 07:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jpSS0hwzriDP1NpUdNC7BhjXw2NvxcipZRhGyJNljLE=;
        b=JKmpeC5LAdZ3WEYw8pJhUF2YTzo+9yTPBex61YgNkVN8xlD2qKm3jOt7o/WTnbx1XQ
         lr6mS+0OiZyp329u1YpJVmP+/7IFS0UoUUvYBmQ55rGLg5BwbPddGZKkWH2cWL6BforZ
         05W9XV2CBUKYRG99xTJyqFRMPsuIz5qjg0Cp7oLjiESUT+JWYG2BzlFBRkBSFSWcZDou
         1uqFkX/CBu36Us2n9Rv5T17uddo3FonxEyqWL79s9Pt4fb+VtQXO2xD5aij5AHUXy2Oc
         wDLF4x4ApDG54oKTMAkL9v4QsDol2XsdApZ+aodf6V91n09jkOzODEEWR5WJdr4kxZ3n
         PT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jpSS0hwzriDP1NpUdNC7BhjXw2NvxcipZRhGyJNljLE=;
        b=b11wHyAMMHvluTCEcY+WLOdycLwu7iA1dJDMpmCZiBEPrOpUVYiOoyYogj2bwE7w2S
         WIUwo1Tv2dOc2/+LzwlAHPJ6c/YFeEseaGaVJCxdKwK9d4HOKzoVN2S71V28Fku+GyG2
         VYG2V+olf/MuR60aFHDsIHBuFVqOCNP4JXNvYwntz8l1X+dZgG8sKf/jnfPpv8KXr0hj
         JMJc4nE5hXGdVAHDi2OTJQ8DmFO/TXBmk/6kRxL9TkHcG0cfK53Ky54r5lIxvkdqK5wG
         Wfh2slELgpxlZA4XC4qanf1UveyU2zDkBRzF8GGQXSaWHPQyULgU5ylArGb0sVnabvKY
         6AXg==
X-Gm-Message-State: AOAM53191LBUb66fPvZ7S0IxEN3yKV+5uhVuOksDBOrQJefWr2HdCYMU
        PffXJvMaBCU016FDOkjCZEgirw==
X-Google-Smtp-Source: ABdhPJwWSJoA1tpiz2/TymKjNzGVX9fhQzahAmfKnWvmJqtwX5x2lDnfPGp0E1XS46AMiNzektHDzQ==
X-Received: by 2002:a62:ee0f:0:b029:335:a681:34f6 with SMTP id e15-20020a62ee0f0000b0290335a68134f6mr18282178pfi.55.1628517702367;
        Mon, 09 Aug 2021 07:01:42 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g26sm23736284pgb.45.2021.08.09.07.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 07:01:41 -0700 (PDT)
Subject: Re: [PATCH 1/2] io-wq: fix bug of creating io-wokers unconditionally
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210808135434.68667-1-haoxu@linux.alibaba.com>
 <20210808135434.68667-2-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb56a09e-0c10-2aad-ad94-f84947367f07@kernel.dk>
Date:   Mon, 9 Aug 2021 08:01:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210808135434.68667-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/21 7:54 AM, Hao Xu wrote:
> The former patch to add check between nr_workers and max_workers has a
> bug, which will cause unconditionally creating io-workers. That's
> because the result of the check doesn't affect the call of
> create_io_worker(), fix it by bringing in a boolean value for it.
> 
> Fixes: 21698274da5b ("io-wq: fix lack of acct->nr_workers < acct->max_workers judgement")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 12fc19353bb0..5536b2a008d1 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -252,14 +252,15 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>  
>  		raw_spin_lock_irq(&wqe->lock);
>  		if (acct->nr_workers < acct->max_workers) {
> -			atomic_inc(&acct->nr_running);
> -			atomic_inc(&wqe->wq->worker_refs);
>  			acct->nr_workers++;
>  			do_create = true;
>  		}
>  		raw_spin_unlock_irq(&wqe->lock);
> -		if (do_create)
> +		if (do_create) {
> +			atomic_inc(&acct->nr_running);
> +			atomic_inc(&wqe->wq->worker_refs);
>  			create_io_worker(wqe->wq, wqe, acct->index);
> +		}
>  	}

I don't get this hunk - we already know we're creating a worker, what's the
point in moving the incs?

-- 
Jens Axboe


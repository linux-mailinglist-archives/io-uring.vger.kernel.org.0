Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B1E215974
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgGFObM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFObM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:31:12 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC3C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:31:11 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so34617702iof.12
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tKnagFiICBZi9DuTSFdOS9T56N8xQpH8I5VctNv/Plk=;
        b=vayd9q2OkzplRR8BswxctQGrmwbqjXGaHLfcesLOAQa3K7fLh+7VZZ4uZnoaMOT7LD
         kg62DT6avEYr7QJXdoM/qB9/uwjw5Oj/MZr2tdeG4ZNkZ4drLX4KbeYxaCjuFPv2MksX
         4PtIXqF8v04+eGbbzngmQbekn9teUzmWEepZ41B5SvDke83pBrj3UwsYS6myPHhI8Owo
         5IGCgO2W2tfvvZkSloFV3yTVyT9ZrOWjMLmz6J+JfJ/TavXd4/6xyvtCvauvZRwyZdti
         /m8Yry2tkS+gfxVDFS5DAR5XrMNi8ZCVqbZdlO+EM+e2zJ8r1++FJzpA9Wu6TZeR33GW
         gW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tKnagFiICBZi9DuTSFdOS9T56N8xQpH8I5VctNv/Plk=;
        b=poHwwkOCpI3KsgmLPCoMV/ISx3Wrg38lCgjhqtSPt9uOkctZCq3BS3CH8IuOxqziv9
         LZqjP2lVDPNqfYHjD/6DVyLUR2hHuz08K9VHPYtt8fC9mwhR5n2M2TaTLSiTn/ExCif7
         0DsJKmZAis7CDYzgGxQPcmnyWYdhWcf7RvMWB5N+ZZna+NFdw646tc96SGW0IZLvnCAz
         7rLCOCicE/IopTUpF+OImdCgbvzWu6l41C1INmOVdIIDfxAaVPl9yU/i/poExG5iHw84
         dU+RzTIfdZsirUiHCKyIQTJpdBFUpQnxGwaTVkJar4a27yM9zgQAwFgGqmF73o+ZHDuH
         c5zA==
X-Gm-Message-State: AOAM532MxWxQPdvIYHuev6kSclM6JDMAJU+c/J5lcJJN7VONo1miU/sq
        TMSC8a07ktzJ9At+FwxQpBFjOx81hiO/WQ==
X-Google-Smtp-Source: ABdhPJw3XiETN0PJRFruJako8vhkIyg6lhRKKp0SK5EKFh7uYNp5aHumYD9DYwxHHwNG7OI5d9r6ug==
X-Received: by 2002:a05:6638:1515:: with SMTP id b21mr43482177jat.84.1594045870798;
        Mon, 06 Jul 2020 07:31:10 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 13sm11484361ilj.81.2020.07.06.07.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 07:31:10 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: briefly loose locks while reaping events
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594044830.git.asml.silence@gmail.com>
 <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e8cfe972-0b28-8c5d-122d-0a724b3424fa@kernel.dk>
Date:   Mon, 6 Jul 2020 08:31:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 8:14 AM, Pavel Begunkov wrote:
> It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
> For instance, the lock is needed to publish requests to @poll_list, and
> that locks out tasks doing that for no good reason. Loose it
> occasionally.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 020944a193d0..568e25bcadd6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2059,11 +2059,14 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
>  
>  		io_iopoll_getevents(ctx, &nr_events, 1);
>  
> +		/* task_work takes the lock to publish a req to @poll_list */
> +		mutex_unlock(&ctx->uring_lock);
>  		/*
>  		 * Ensure we allow local-to-the-cpu processing to take place,
>  		 * in this case we need to ensure that we reap all events.
>  		 */
>  		cond_resched();
> +		mutex_lock(&ctx->uring_lock);
>  	}
>  	mutex_unlock(&ctx->uring_lock);
>  }

This would be much better written as:

if (need_resched()) {
	mutex_unlock(&ctx->uring_lock);
	cond_resched();
	mutex_lock(&ctx->uring_lock);
}

to avoid shuffling the lock when not needed to. Every cycle counts for
polled IO.

-- 
Jens Axboe


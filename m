Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DADF3529DD
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 12:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhDBKnD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 06:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKnC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 06:43:02 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49242C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 03:43:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o16so4410773wrn.0
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 03:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NIPdhZNlxClDKJ7DwzjH19+sy+7VDt6tjTLEhc1UlHs=;
        b=Ub53PuLYoArto0t5NB8t0murFXzgUCCIVzysilHofwUCYk+0Na7TWe6q3tlG2wpZGD
         AGoLoVAXHzDX5CTzXy23EuiVOYUYQx3iLAgD1R1OXOpyNFDyQmxV0EaUGGYo3/J8Vkbw
         mu9gC0qJwYq61nwf4VAtpsrH2Ftyr4vsbDVMImFBFolpXsANPBZb2B7UWJDYPC+AvffS
         CWEq42/0jYCkGYAL2M6i69t1aan40jZcQacUmurEjG2tpzAVRsfs1PGcz6x/hPpQhz7v
         6ruyuXXgAz4OdBVkaTg2rIlGI6ssdRQNfV4660x53tD+wuVOspnxaQXmjPBUh7mZlew5
         Sg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NIPdhZNlxClDKJ7DwzjH19+sy+7VDt6tjTLEhc1UlHs=;
        b=LzsinkpWe5xK0+UW/V3DDluhBH/cAeoRIugyOz3C90wQiVva1vGUuZ541Uok8SxR8e
         w7V3CMCejx106pWWSnMjtrQ8WWJq6I1az9DudcABBkGmuRKWcVFP3u+b12kLb+gLzT9Y
         OC+WvVxaC4PM5cVAT3WzBN/qrt4kMXj0iAuU23j05Vto/TNH5RACOcyEaf9MYsFQMtjQ
         gD9c6G2ikKlWc2KQiKHjVpTggVraFfw448wBskwdNR9VO0r5DsOGAABZZS1LHcKruOZy
         j5WuGaTw+dIx5yDShyjdK5klp9xe69EW3GT5DCBKh9fjHim3fPrzNEnZgSFXcNbzwi8n
         LxSg==
X-Gm-Message-State: AOAM530xU8mgDRxvzmgebdZOTlJdCbVAFe07trzWi9KHHP4sLpXZaCUa
        x+7zBomlvqOG6na3WdEuCqNOnoHV+GWYAQ==
X-Google-Smtp-Source: ABdhPJzI3XlS3ImUmT5rucQcWlg43goxn0t70THXaFe3vQgBKkTFwtf2o6e+oOMbBz92KUx/ltaOLA==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr14432507wrp.231.1617360180051;
        Fri, 02 Apr 2021 03:43:00 -0700 (PDT)
Received: from [192.168.8.131] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id b15sm14396988wmd.41.2021.04.02.03.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 03:42:59 -0700 (PDT)
Subject: Re: [PATCH] io-wq: simplify code in __io_worker_busy
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617358729-36761-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <91175ea9-950a-868b-bddf-dfe4c0184225@gmail.com>
Date:   Fri, 2 Apr 2021 11:38:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1617358729-36761-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/04/2021 11:18, Hao Xu wrote:
> leverage xor to simplify code in __io_worker_busy

I don't like hard-coded ^1 because if indexes change it may break.
One option is to leave it to the compiler:

idx = bound : WQ_BOUND ? WQ_UNBOUND;
compl_idx = bound : WQ_UNBOUND ? WQ_BOUND;

Or add a BUILD_BUG_ON() checking that WQ_BOUND and WQ_UNBOUND
are mod 2 complementary.


> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 7434eb40ca8c..f77e4704d7c7 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -292,16 +292,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
>  	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
>  	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
>  	if (worker_bound != work_bound) {
> +		int index = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;
>  		io_wqe_dec_running(worker);
> -		if (work_bound) {
> -			worker->flags |= IO_WORKER_F_BOUND;
> -			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers--;
> -			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers++;
> -		} else {
> -			worker->flags &= ~IO_WORKER_F_BOUND;
> -			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers++;
> -			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
> -		}
> +		worker->flags ^= IO_WORKER_F_BOUND;
> +		wqe->acct[index].nr_workers--;
> +		wqe->acct[index^1].nr_workers++;
>  		io_wqe_inc_running(worker);
>  	 }
>  }
> 

-- 
Pavel Begunkov

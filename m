Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09E932523B
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 16:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhBYPTX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 10:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhBYPTW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 10:19:22 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA67C061574
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 07:18:41 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e2so5221586ilu.0
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 07:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oyT9Oe1cC7coyFl6zbfe06KDP1TJh6/1ZFG4oL/1Tos=;
        b=nrpE80NeygxKbSoGjYTQGbrv5ZsDqPSXhHSwJvmAz0UU1aSYXgYCEJrF/dZcgnyYVf
         Y0orSdcrONsK0sHQZWQWuEVj/Ih49vQrsyAY7X8X6dU1iBy0zupTbeINV2yjac7aw/9d
         LAbZKXisYNPUYbJEfjQY5bTYslqrhMHQurn1TH3cYEJEdDMG8O3c/C9ud7isNp291TAr
         XPBipmnORPOE9acwfO6BdIevXQ4GHJdZogyG7a88nxoAm+GFhF4f8ai6lxGwDLW+9tNx
         IN2NBMMUh0zXEYS3iWfoZIy6p0QbGortEqdgJk2OlQcq+MdQ2LAy+RkEBGzGtUgYBqbB
         cUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyT9Oe1cC7coyFl6zbfe06KDP1TJh6/1ZFG4oL/1Tos=;
        b=G6XQcI26tvYSC+RNbTdG+oS7NZfN7oCBv4acogoKLwrb1dNRFYTuhFxPkQqrAkUB7A
         w425RTlHjVIAN+bg6TcZw3lZ0EF1oulJXLna4dL49ydQbRwX3tjjQQGnSJDhiojK4at7
         UAOK4Ey1Tt5DYQmLfr8A23FFubJN1jOkDySMZpagFDxlfr/vU+HwziXdFIupy/N7u5AS
         j2u7rTBD1Dou831Tpgg0ujqwywA73W3TLUwWPEXliqqvwmTwQ1JqWWUXxCK1fv4cUGOH
         Y18DEcrR44J5vHT1o2ygifheYEzYHE4cHd296nTRNh3P00eu7wZjU48ZVO2qb1xNBu6h
         +cCg==
X-Gm-Message-State: AOAM530q3RTokyMN5+QuFV5BKG+FzBfVs3j1SAuM3TIEuN+EttwYiqy8
        Eq90rr48XbyESZVIgDGm18KX4lDUaV60OBrL
X-Google-Smtp-Source: ABdhPJzKzHtL54DVNoV/dehA/nRVn0yMXGL5JoAG/CNZJye6ZTyhqiI/n9LIh9EJ1eaqcelREPuMjQ==
X-Received: by 2002:a05:6e02:1447:: with SMTP id p7mr2955077ilo.93.1614266320107;
        Thu, 25 Feb 2021 07:18:40 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e25sm3810262iot.49.2021.02.25.07.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 07:18:39 -0800 (PST)
Subject: Re: [PATCH] io-wq: remove unused label
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org
References: <20210225021844.13879-1-chaitanya.kulkarni@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7969e56-46ad-d451-8733-62f06ee33da0@kernel.dk>
Date:   Thu, 25 Feb 2021 08:18:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210225021844.13879-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/21 7:18 PM, Chaitanya Kulkarni wrote:
> Remove unused label so that we can get rid of the following warning:-
> 
> fs/io-wq.c: In function ‘io_get_next_work’:
> fs/io-wq.c:357:1: warning: label ‘restart’ defined but not used
> [-Wunused-label]
>  restart:
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
> 
> Without this patch :-
> # makej fs/
>   DESCEND  objtool
>   CALL    scripts/atomic/check-atomics.sh
>   CALL    scripts/checksyscalls.sh
>   CC      fs/io-wq.o
> fs/io-wq.c: In function ‘io_get_next_work’:
> fs/io-wq.c:357:1: warning: label ‘restart’ defined but not used [-Wunused-label]
>  restart:
>  ^~~~~~~
>   AR      fs/built-in.a
> 
> With this patch :-
> 
> linux-block (for-next) # git am 0001-io-wq-remove-unused-label.patch
> Applying: io-wq: remove unused label
> linux-block (for-next) # makej fs/
>   DESCEND  objtool
>   CALL    scripts/atomic/check-atomics.sh
>   CALL    scripts/checksyscalls.sh
>   CC      fs/io-wq.o
>   AR      fs/built-in.a
> 
> ---
>  fs/io-wq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 42ce01183b51..169e1d6a7ee2 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -354,7 +354,6 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
>  	struct io_wq_work *work, *tail;
>  	unsigned int stall_hash = -1U;
>  
> -restart:
>  	wq_list_for_each(node, prev, &wqe->work_list) {
>  		unsigned int hash;
>  

This was dropped from for-next for now anyway, as it needed to handle
more cases.

-- 
Jens Axboe


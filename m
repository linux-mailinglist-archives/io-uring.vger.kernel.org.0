Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E55A4341B8
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 00:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJSW5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhJSW5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 18:57:07 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F1BC06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 15:54:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so6058754wmz.2
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 15:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7FyVZJ44MGAftLG2IZX1Opll4gniqxtsGFzMeIyzhwg=;
        b=R4A7BYZVONrZvWJ3VDBTSq2qKCMcODaTRLpDQZvXXsOuahD7H1DP3KQo1mK06nrYCh
         LHSwq/FFHN3ewlL/QYT/Sg+r70pW0GGSx8NpQXg0B3g8r0s3RGc7PvXKWkkOBSm/fCHn
         ImmpioEyl656moGaiotZ8Mm949eoWjxorr2OHP3AVFYG0V3mlEpVNdstmczLwybraURG
         SzxZKIzQ4oIWrxuZRO4C4WPGSrL2ouK3hVsD3nWzrsr4Pu3tFup5Gka4rudikZraj7PS
         6V9IXTDvEl1f3T9+APhpvJgyyoRS6fmArjpTPelgMNwpFNRp+6MyyyXFFjVrP1C819d6
         c6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7FyVZJ44MGAftLG2IZX1Opll4gniqxtsGFzMeIyzhwg=;
        b=ThglXAcaHgWQ8aSFgEU3KzKes1WHEvOHo1YNeWcnUAy0g4FbSeMgC8YSrKn1z2GeI3
         yxUH6/ogsr0peLp15m7A1ZgiBOs2Ziv3Aw4/yzYab34M8xAh1Rd2WYPZ5hGnT4X0GFYX
         3bHjxB/9ykkIDM5bTfYbPfseP+rdxpjVI7usxyTz6mHESPv+JB54DoKnzjluiJ1deiEi
         rzTb9WVXCPn8SKMdMhsSLeDgkQzrIwRlO8dmR92LduAUgCgdqDceCfwFkdk9d29C+UoJ
         1KXzWcwnVomFgkI1mygfk/0W8zfLbT5Ezh03GjEV4vRNdPDVBJCk2egdSpVb0pGyXKGw
         Nuzg==
X-Gm-Message-State: AOAM530qPPCWxKIxhTOUUkd7LN9EIvqCjvITjln4uvQeeBI8Rd1iJhyM
        B64TKmGYtGT2djw2hJvY2vr/lypOFODO0Q==
X-Google-Smtp-Source: ABdhPJzgQHrQaGwlmvbR6h7qNBz/B/0O9KtbXZJMIuRTWhKucWPRWfNMuUjFJlwkHRioQiUUdu33Qg==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr49419787wrz.293.1634684091883;
        Tue, 19 Oct 2021 15:54:51 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id g8sm292242wrx.26.2021.10.19.15.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 15:54:51 -0700 (PDT)
Message-ID: <242c1e1d-ffd4-5844-77fb-4ac0eb23ff91@gmail.com>
Date:   Tue, 19 Oct 2021 23:54:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5.15] io-wq: max_worker fixes
Content-Language: en-US
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/21 20:31, Pavel Begunkov wrote:
> First, fix nr_workers checks against max_workers, with max_worker
> registration, it may pretty easily happen that nr_workers > max_workers.
> 
> Also, synchronise writing to acct->max_worker with wqe->lock. It's not
> an actual problem, but as we don't care about io_wqe_create_worker(),
> it's better than WRITE_ONCE()/READ_ONCE().

Jens, can you add

Reported-by: Beld Zhang <beldzhang@gmail.com>

> 
> Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io-wq.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 811299ac9684..cdf1719f6be6 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -253,7 +253,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>   		pr_warn_once("io-wq is not configured for unbound workers");
>   
>   	raw_spin_lock(&wqe->lock);
> -	if (acct->nr_workers == acct->max_workers) {
> +	if (acct->nr_workers >= acct->max_workers) {
>   		raw_spin_unlock(&wqe->lock);
>   		return true;
>   	}
> @@ -1290,15 +1290,18 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
>   
>   	rcu_read_lock();
>   	for_each_node(node) {
> +		struct io_wqe *wqe = wq->wqes[node];
>   		struct io_wqe_acct *acct;
>   
> +		raw_spin_lock(&wqe->lock);
>   		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
> -			acct = &wq->wqes[node]->acct[i];
> +			acct = &wqe->acct[i];
>   			prev = max_t(int, acct->max_workers, prev);
>   			if (new_count[i])
>   				acct->max_workers = new_count[i];
>   			new_count[i] = prev;
>   		}
> +		raw_spin_unlock(&wqe->lock);
>   	}
>   	rcu_read_unlock();
>   	return 0;
> 

-- 
Pavel Begunkov

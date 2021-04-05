Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40092354845
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 23:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbhDEVq4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 17:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbhDEVq4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 17:46:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F8DC061756
        for <io-uring@vger.kernel.org>; Mon,  5 Apr 2021 14:46:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so6529258pjg.5
        for <io-uring@vger.kernel.org>; Mon, 05 Apr 2021 14:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BtWUHXM1i8S7R+Xdr2usuILxhJfxzyVCdQLbpzPrB1Y=;
        b=DxxiHQePokWOb6RS77EC7FFBeA2ucS4YFDkh+QhWMUjT+kvzHIiJgep9Ee9kz7XgFe
         u/K9qGmb7hfbHaPm5B+5q4qTGyNPDrDYpF9VGIlgOW17HGv/D4We5BuW943Zk/ruFJC0
         jUIWV8p+k2t7gUiIgM+Jo/Mku2ZHO15Ed1wbVhC36cCY3wq+z+PX2C4/KdEsZ29wHSv3
         4WYh7mI6sSL2dOocP1NXzjtA86RuqVawQnby5r/RrlsdRTKRT7hbbj1bcK25mTDJ9Q11
         FE5oqBUNydclwFrsYa8I1fmFTQ7ZviPIYNWGSY+XBPj2boV8yC23VImv+xLqg/WtKH8h
         NF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BtWUHXM1i8S7R+Xdr2usuILxhJfxzyVCdQLbpzPrB1Y=;
        b=WVM0f7u65tSxAC3vN8KqEVC9tB7nBX67F/moGRFspAFzpYQ0V9BZvVqizMb45PS+op
         Su4G5ySdtfyMl1wa5jyVUPO3dxan6LhfTkV2IwyC9MHzNvsRkhxIxHSAaUE8bXRVcYGc
         g+zNohLp7KLL1vU6JJb9+OYoCAuRquJV+QcrD1Lt6xd7V7gaXl+xOuoWDRzim7kovMhA
         m+fPtZqJNU6QMkLBK4rjr+2GHkHu+/txS+zri9XCVGMZ8HDpWCvzvctbpyripvyc2b5f
         jeMBUc7GB9/h2klXgIqnn8VbTJo3Qs8RQatn2+hGmOIBBYis8m3shqFvrbimDZaSYjjJ
         2dkA==
X-Gm-Message-State: AOAM533oes8+hgPtqe33MpE1yhOWWs+7GS4/9jJ1iEnb+zBhJSFEaHSb
        MXUVlJS1w61u8oGoPaEywlTCoQ==
X-Google-Smtp-Source: ABdhPJx9EsayeuSW5gj/DM6vIGT5hsracAq2NeOOt5+YSBf2i1et31pP5d+9bEg+okMFHY3JtEvgjQ==
X-Received: by 2002:a17:90a:ab09:: with SMTP id m9mr1228978pjq.122.1617659208948;
        Mon, 05 Apr 2021 14:46:48 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id kk6sm334675pjb.51.2021.04.05.14.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 14:46:48 -0700 (PDT)
Subject: Re: [PATCH v3] io-wq: simplify code in __io_worker_busy
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <7f078f30-d60f-2b19-7933-f1ccba8e7282@kernel.dk>
 <1617609210-227185-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
Date:   Mon, 5 Apr 2021 15:46:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1617609210-227185-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/21 1:53 AM, Hao Xu wrote:
> leverage xor to simplify code in __io_worker_busy
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 433c4d3c3c1c..8d8324eba2ec 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -276,10 +276,12 @@ static void io_wqe_dec_running(struct io_worker *worker)
>   */
>  static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
>  			     struct io_wq_work *work)
> -	__must_hold(wqe->lock)
> +	__must_hold(w qe->lock)

Looks like something is off there? I see a v2 as well, but this one is
later, so...

-- 
Jens Axboe


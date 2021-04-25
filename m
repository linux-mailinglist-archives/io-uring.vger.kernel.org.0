Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0F36A3A5
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 02:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhDYAJn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 20:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDYAJn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 20:09:43 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7F0C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 17:09:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n4-20020a05600c4f84b029013151278decso3133016wmq.4
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 17:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FrA18kqk03sq41B9lthuLebui26LPOPSXtZGfJaKyM4=;
        b=tUL5SWh/hvsB8bZImRUy5/VDZ7ZgFVbEmEJoePZ8IJ01Cl9mf3v4u2PBFLPVJNXU/7
         7ZBi6Ij085FFEkSqhonGDmpGbt61lCEG0+VeIXzOzATNLL9KYa1ke0VBele8ByjJfV5W
         Cp/VpTjLFHdKQjQIHJjF8TnqhS5rNzJda2QUL+mZuv9Idi/qb3XLl+enghwSORlzuzxk
         +INQ74xjLyQOARdBsccOhVkjpp4Pc6HRWkFdLdZ1NaoPbPT5JPO5riVscUV03CwnVpX4
         KGzEUy1HaNT61PO2CEflmQi66u0YdoSN3hZUFFQR8TwN4hgEoYUl/NKcNiKPhtRalIOp
         DQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FrA18kqk03sq41B9lthuLebui26LPOPSXtZGfJaKyM4=;
        b=af+jHmiY7oKxdJzrTAmaoRy1YSyPkrRzlUSSJiP81I2fpf+6PaUKJ1gzTpCEqvJ5iJ
         fsAgMkFXJJMO6zhiX2+i+0s5d2rAz47/UVY/OBeO6oyFIiLQu+w8J2RgvUQR3bMc2YN7
         XSDulSlN4ZmXQqgxU8Axl1QtCmqJgw+Xp78ITZ2R5o3K40A/tA0h3Hc12cidr2SHX/QC
         fxB15JiXM6sLV+Bkzf9/whv5vX9tnO1wVyjFxCWtrMOxWFOEVxnaD0be5A45p9/PDFkS
         /rLIzNV3Uxm5pg+j/7VXS+YEnEWvVJ/kowR//pnYqDsWndXRbHusxgztUxjyjWEu3hOs
         uVGA==
X-Gm-Message-State: AOAM530viTZxpMGa9ThEDI/HTvNqypIL36u90NIvA3jIDvN+IE0SuCtR
        m7jLTk7HtWHewEnmMCTYN9p85hTPND+Pvw==
X-Google-Smtp-Source: ABdhPJxc+ZRXKNOF9xnvL4q0OYsnlPhEC5wu1eRt0ZjFGqd9RYVitvY8ApH3Eu8j2Z2uX2PXsjhqfQ==
X-Received: by 2002:a7b:ce8a:: with SMTP id q10mr238216wmj.109.1619309342855;
        Sat, 24 Apr 2021 17:09:02 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id b128sm1854119wmh.42.2021.04.24.17.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Apr 2021 17:09:02 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] io-wq: warn about future set_task_comm()
 overflows.
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1619306115.git.metze@samba.org>
 <94254f497b59e7fda85503c643ec5a2e25a30c0d.1619306115.git.metze@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <33696f42-b1b8-2485-108a-6b4d44ffdf64@gmail.com>
Date:   Sun, 25 Apr 2021 01:08:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <94254f497b59e7fda85503c643ec5a2e25a30c0d.1619306115.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 12:26 AM, Stefan Metzmacher wrote:
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/io-wq.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cd1af924c3d1..b80c5d905127 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -640,7 +640,19 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
>  		return;
>  	}
>  
> -	snprintf(tsk_comm, sizeof(tsk_comm), "iou-wrk-%d", wq->task->pid);
> +	/*
> +	 * The limit value of pid_max_max/PID_MAX_LIMIT
> +	 * is 4 * 1024 * 1024 = 4194304.
> +	 *
> +	 * TASK_COMM_LEN is 16, so we have 15 chars to fill.
> +	 *
> +	 * With "iou-wrk-4194304" we just fit into 15 chars.
> +	 * If that ever changes we may better add some special
> +	 * handling for PF_IO_WORKER in proc_task_name(), as that
> +	 * allows up to 63 chars.
> +	 */
> +	WARN_ON(snprintf(tsk_comm, sizeof(tsk_comm),
> +			 "iou-wrk-%d", wq->task->pid) >= sizeof(tsk_comm));


We don't really care, so saner would be to just to leave them and don't
warn. Not see much need but can be something like "iou-wrk-00000*" if
overflowed. Same for 6/6.


>  	set_task_comm(tsk, tsk_comm);
>  
>  	tsk->pf_io_worker = worker;
> 

-- 
Pavel Begunkov

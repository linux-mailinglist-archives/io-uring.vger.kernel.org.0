Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B679A1E6809
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 19:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405340AbgE1RDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 13:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405249AbgE1RDW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 13:03:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8445CC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 10:03:21 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so3404184pjd.1
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 10:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HKns1VtRdy4aWp5aVdGSVnrj/aZMV6fRZ75ZqBpFiF4=;
        b=XvbSulWA4RusBJACApYLZS213MlQZdYg5Cld84lucdIDUQq3O4ZxCOaadvrJt/rdEf
         zMm4m7pRYUYofgCfHhqiDUITRr9Peex3mrrm7lOhnT46y9C5cGgI474e5TVBkpft3Q3A
         suo3l2Xm0Ib3yVikqHdSh3ZZAjZtxSwDKvooZrCSlxkv8Cp7GUAPHfUUp9LTMbIPbgnk
         nCU4WdQ3L4GZGdMe+f9GGMTMnirUV2/FtCHSUVlFc4d3tSEnOU6tKBOqjj8tXMWhlRmN
         P7ebdhhdWiC9hsWlpMksGYNV+JjCCsIvtasQ+a8+YFKZq2LHZV91Wwuk5y6N0/8GdXLp
         QU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKns1VtRdy4aWp5aVdGSVnrj/aZMV6fRZ75ZqBpFiF4=;
        b=PWedwJ+EH5A/dAe/u4Cd3R6vZy9iODIP/qvhAsxv+me/akZiRvu7f8G2J0vhM0lyld
         iVNy9K3rVWepPbg70tC5VKySIdaJOnLEydc5duP6E+ecjlsb0N02PJD1K9RL6Mw2yL9Y
         RPv5tUwlHFX+bZ8rNJ5LynA/Ez0wFHwI7oeqMM4Ky5kujYgX5mTXFKRjS0caSyhcoJQc
         1PR/IZg5ST5GETQr46OazDAFtdsva24erx3muoGNn/35MVjYw4J5j1S6jYfXQOXMyru4
         1cO2yVNgfg13zESMJz0s9UkVEdhZmEv/LO/t5hEADzuta7YCt4pqEeIub9gErsaRDj3c
         nR7A==
X-Gm-Message-State: AOAM530ujSd0ikGWCvzyBMo7ihvf/snKwV3ovKyaFoDoo3EDgc7Lz6Ao
        m/Hq9F5ZL/guvOPb8XSJ1ZZNjw==
X-Google-Smtp-Source: ABdhPJyBQrkXtG5Zto85FY1z0sMC9JAH6pUFAiPDRs9wzoE5ldLcMur1jt6RMA7AY6Sjm0pqOuHwUg==
X-Received: by 2002:a17:90a:ba8b:: with SMTP id t11mr5106635pjr.191.1590685400650;
        Thu, 28 May 2020 10:03:20 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id fw4sm6052246pjb.31.2020.05.28.10.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 10:03:20 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc55b1e7-2ac1-c315-4c75-99da724d50f3@kernel.dk>
Date:   Thu, 28 May 2020 11:03:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528091550.3169-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 3:15 AM, Xiaoguang Wang wrote:
> If requests can be submitted and completed inline, we don't need to
> initialize whole io_wq_work in io_init_req(), which is an expensive
> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
> io_wq_work is initialized.
> 
> I use /dev/nullb0 to evaluate performance improvement in my physical
> machine:
>   modprobe null_blk nr_devices=1 completion_nsec=0
>   sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nullb0 -iodepth=128
>   -thread -rw=read -ioengine=io_uring -direct=1 -bs=4k -size=100G -numjobs=1
>   -time_based -runtime=120
> 
> before this patch:
> Run status group 0 (all jobs):
>    READ: bw=724MiB/s (759MB/s), 724MiB/s-724MiB/s (759MB/s-759MB/s),
>    io=84.8GiB (91.1GB), run=120001-120001msec
> 
> With this patch:
> Run status group 0 (all jobs):
>    READ: bw=761MiB/s (798MB/s), 761MiB/s-761MiB/s (798MB/s-798MB/s),
>    io=89.2GiB (95.8GB), run=120001-120001msec
> 
> About 5% improvement.

I think this is a big enough of a win to warrant looking closer
at this. Just a quick comment from me so far:

> @@ -2923,7 +2943,10 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
>  {
>  	/* fsync always requires a blocking context */
>  	if (force_nonblock) {
> -		req->work.func = io_fsync_finish;
> +		if (!(req->flags & REQ_F_WORK_INITIALIZED))
> +			init_io_work(req, io_fsync_finish);
> +		else
> +			req->work.func = io_fsync_finish;

This pattern is repeated enough to warrant a helper, ala:

static void io_req_init_async(req, func)
{
	if (req->flags & REQ_F_WORK_INITIALIZED)
		req->work.func = func;
	else
		init_io_work(req, func);
}

also swapped the conditions, I tend to find it easier to read without
the negation.

-- 
Jens Axboe


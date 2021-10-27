Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971EF43D073
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 20:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhJ0SSO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 14:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243428AbhJ0SSG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 14:18:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D56C0613B9
        for <io-uring@vger.kernel.org>; Wed, 27 Oct 2021 11:15:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d13so5602941wrf.11
        for <io-uring@vger.kernel.org>; Wed, 27 Oct 2021 11:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4lWa+L9FkWeB3kC4mQztrtylcZd9ljl2NKg4uq1cSH0=;
        b=IgRpvypjRVUr0dyjVGMSaiWVpqls1ZC3f1D0ALmlHAad+Uw2eCrxGjXIpx1+OoA3q7
         K+aWXX43v61gyGDOZXMxlhazbmlrQ3LKSRvN0M/ZCU8y2mVyMmgS0LcRF1jrbNhgZnpz
         lXYbBzgAEaoplZb2Cifh4lbyACUe5NUcOgr2UeG3Lubq8BcD/+0x17LprxnNFT4BGICY
         SeGDauxOBd8iOCOz3ono7A8btmvrvxahMOjmg90eIVW2SVCshYXx7S2tz4ZFZNABdous
         XKbjcpPKXYHkxfZFqoM/qJAJkvKyDWJv6fC9ZnRjBG9VpAgQUNMaNmc7MZ9cxygt+tN1
         iOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4lWa+L9FkWeB3kC4mQztrtylcZd9ljl2NKg4uq1cSH0=;
        b=HHSqn2n8X1OZnYgRA8GSLNxGNY/MLrYaIqDlMZxGlqjJA1dD3NAX+Oc+fELVHI0jwF
         m1Bh/Upo8va4RBV1cvWBsdKQkVUin7uePdjmwYtvqX52wvn3prDwvB2kzg2WDxBoFPjz
         OB6NAfhc4DlMdUbyyUwpt+wvoGwUWIrnrNmiCfaL6GVOlf8YkvgeTflbUcuVHSIu8h3q
         fqTSuaPRYeEJ8MOkNqjiEgvgnEA7khZsT7UarSt2iFqvn2Ze23rQJDNOrGwfso/MKsjr
         JRcMbaGnfp+ornRoRtylCda9ZWwUVrFWvtK29ldLsXuZti0PfA5FKF5cr6qPUdNgRPyl
         8qqw==
X-Gm-Message-State: AOAM5336cOmIQNEKU36YLXp2IQC6d1VDC5/ysxGKYk9agBCknXNUJB3P
        5DqOLnoS6JPMMs4YZcR7l78=
X-Google-Smtp-Source: ABdhPJxKsQB04aLwr5Dc6SOzKywkd0JDVzOjNyTNFQV7tJMi4A4+l39L2jKoZ51H2V0OHVRfuY6INg==
X-Received: by 2002:adf:fc49:: with SMTP id e9mr698681wrs.130.1635358539774;
        Wed, 27 Oct 2021 11:15:39 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.132.100])
        by smtp.gmail.com with ESMTPSA id d5sm560134wrn.73.2021.10.27.11.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:15:39 -0700 (PDT)
Message-ID: <da85ab25-a6c6-f6a7-e2d5-d9a13c4dcf2f@gmail.com>
Date:   Wed, 27 Oct 2021 19:15:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH for-5.16 v3 0/8] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/21 15:02, Hao Xu wrote:
> Tested this patchset by manually replace __io_queue_sqe() in
> io_queue_sqe() by io_req_task_queue() to construct 'heavy' task works.
> Then test with fio:

If submissions and completions are done by the same task it doesn't
really matter in which order they're executed because the task won't
get back to userspace execution to see CQEs until tw returns.
Furthermore, it even might be worse because the earlier you submit
the better with everything else equal.

IIRC, that's how it's with fio, right? If so, you may get better
numbers with a test that does submissions and completions in
different threads.

Also interesting to find an explanation for you numbers assuming
they're stable. 7/8 batching? How often it does it go this path?
If only one task submits requests it should already be covered
with existing batching.


> ioengine=io_uring
> sqpoll=1
> thread=1
> bs=4k
> direct=1
> rw=randread
> time_based=1
> runtime=600
> randrepeat=0
> group_reporting=1
> filename=/dev/nvme0n1
> 
> 2/8 set unlimited priority_task_list, 8/8 set a limitation of
> 1/3 * (len_prority_list + len_normal_list), data below:
>     depth     no 8/8   include 8/8      before this patchset
>      1        7.05         7.82              7.10
>      2        8.47         8.48              8.60
>      4        10.42        9.99              10.42
>      8        13.78        13.13             13.22
>      16       27.41        27.92             24.33
>      32       49.40        46.16             53.08
>      64       102.53       105.68            103.36
>      128      196.98       202.76            205.61
>      256      372.99       375.61            414.88
>      512      747.23       763.95            791.30
>      1024     1472.59      1527.46           1538.72
>      2048     3153.49      3129.22           3329.01
>      4096     6387.86      5899.74           6682.54
>      8192     12150.25     12433.59          12774.14
>      16384    23085.58     24342.84          26044.71
> 
> It seems 2/8 is better, haven't tried other choices other than 1/3,
> still put 8/8 here for people's further thoughts.
> 
> Hao Xu (8):
>    io-wq: add helper to merge two wq_lists
>    io_uring: add a priority tw list for irq completion work
>    io_uring: add helper for task work execution code
>    io_uring: split io_req_complete_post() and add a helper
>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>    io_uring: add nr_ctx to record the number of ctx in a task
>    io_uring: batch completion in prior_task_list
>    io_uring: add limited number of TWs to priority task list
> 
>   fs/io-wq.h    |  21 +++++++
>   fs/io_uring.c | 168 +++++++++++++++++++++++++++++++++++---------------
>   2 files changed, 138 insertions(+), 51 deletions(-)
> 

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E561F5F74
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 03:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFKBTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 21:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgFKBTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 21:19:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC89C08C5C1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 18:19:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v24so1668256plo.6
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 18:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8jr3WGRPrXHJKhodcZ2ZfPwj9oscYxHngGAHRKnCZSI=;
        b=n20Cry/wHczXDMoBuf9DAGwDHtPBDsv07+SwwzNrCtYraLZeQTRH5T8KWHOam1qy9l
         68Qo+UQ4AI4XvQX+h5cKb1nfSySLtmn+5trlwDWIB1J5+x35LEUz4lBTVRbkqCv/Bcw+
         bCjqOEa+gJ9pdAUSvgtBF7eVZNZKB5BUlCjBwR/00AmcDbB21znL3ntnicZFIaPhWI0M
         XbZzZ2HOFLU6z+uZGxDklf4s20GGnpd2JDHkiYuR9heyIPUh4Igu0D3Woh/3g/Wnv6Ny
         SpUCDOiExo9ZenDBeX0QxslRWWAgrk2l+niwIoGq4UrnlcVBQSXy/71ehpbT6acAwaXa
         B/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jr3WGRPrXHJKhodcZ2ZfPwj9oscYxHngGAHRKnCZSI=;
        b=KspLawGSmeJbfhrnhGTuectiG42noYMOuUqo87n1fWG3JCDnlBsghdLNu3pJ8GacQm
         cVc8Q9s7Z83c4o2B93gu2YGbu72it1SSByTB4/DVCgkVgDP7FppABF5eOtdoserqiC23
         wpB+GeXcYeKdrg95lsLcHn7ExYD8NEkajNoUmB4zu/gxxxGDhWCf099lOVnkVMmXtuED
         RLi8liCCcG87AjRUhUmKURrn7R4zrMVdZXIxs01SQKW1nequpq4tpCbXuhE3636G/bs+
         XYkJx2SbdLJgff4jk50jcgQwDLOSOmpz+io8wTT7lzd09E+rNgoxjdKj5aADsiKV1Lg1
         7y0A==
X-Gm-Message-State: AOAM5307YwKwafUdDW13cBec4i0rak7/miROd4253JL1MGHMhrU6ZkX1
        cQYvaymPpEYdpUbxWFLxD0H0sGz8WM9w+Q==
X-Google-Smtp-Source: ABdhPJxVEiBXDLTqovH6smFsB2Shr7Dd3IpIy4MIOUFsINW9WYdL1j+monVFQGm5WB9VWbIxIzsPWA==
X-Received: by 2002:a17:90a:4d09:: with SMTP id c9mr5802173pjg.137.1591838359716;
        Wed, 10 Jun 2020 18:19:19 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w15sm845636pjb.44.2020.06.10.18.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:19:19 -0700 (PDT)
Subject: Re: [PATCH v7 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200610114120.7518-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <44818989-6798-0c03-751c-515106e0ea5c@kernel.dk>
Date:   Wed, 10 Jun 2020 19:19:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200610114120.7518-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/20 5:41 AM, Xiaoguang Wang wrote:
> If requests can be submitted and completed inline, we don't need to
> initialize whole io_wq_work in io_init_req(), which is an expensive
> operation, add a new 'REQ_F_WORK_INITIALIZED' to determine whether
> io_wq_work is initialized and add a helper io_req_init_async(), users
> must call io_req_init_async() for the first time touching any members
> of io_wq_work.
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

Thanks for pulling this one to completion! I've applied 1-2 for 5.8.

One note on future patches only - please use a coverletter, makes
it easier to reply to the series as a whole.

-- 
Jens Axboe


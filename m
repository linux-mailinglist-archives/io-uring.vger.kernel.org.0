Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8296C28EA66
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 03:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgJOBoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 21:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgJOBoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 21:44:38 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ED0C0613D5
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:57:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c20so547982pfr.8
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rB+nux/G63c9eToXeI6vLA96Dmc4GWb9o2DHQhmU3f8=;
        b=GQuUjqftHZ1hj+U0ECf2WAA6GKVkFpnO+VQCz+g1DPBDomLRX1aVn2L+fxoQXtAcu2
         lqtU7MbDFowvGrPLtf4iXI1io3CW4k2+X46zKiq6muR6qxLzDgrMbh2zP8M+X+zycW9R
         +LYvamnsltATfog4crQOEgZ0A7MQQBgKgAyJ2zHc+0f3DZwtYN8hBK6QYn1ftKIJXITc
         PmUhKruXLRDkE6xgX/GbbqhcJDq5oHQDsx1/PRRNByvEvBxwAPWgF0qU9nqMgn1daBdv
         IvqVnxCZCV8fHDymFrEqbTscNaS4ruQ2wkJmGM0QDkq17NNrDlZBQJMd7fLXCagg/+Lp
         HuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rB+nux/G63c9eToXeI6vLA96Dmc4GWb9o2DHQhmU3f8=;
        b=E9R20+SkIgThTkIJJEEpHxeiQI9jalxo7JOUtLslA9hyDr3e0S9WcMX7WEEzgJ2PEG
         lehupCJG8F6svMpaeiI5du/tiHfqVkmgnHU39VBRQnaWTvEG45vRkaPqqpygGwOX4HBr
         tKJhPUem/Nlw2nFihpjsnHwHvPZ0g7bzf1ALXbvd5MvpavvCOlGhdy2bKI3eyiYSU+ic
         sd21LEcyueq8I+TKVc8QeBlDlXUwDG5Y/LqGDGrvV5MTO9fsmlzwete6ow9vvYltaoIh
         QIxn9bfAwDvS3GJi9DCRKPcl7zmGeCelX8i7DQjUY2ATHrCM9y9B5Ukpc2gFF7rf8IQi
         jbUg==
X-Gm-Message-State: AOAM53243Q/Q3HBWynhCX86wYVLLU5j9Wwt0e2Rtt4eJ00EzfNECn0TM
        4TCo1Y4gIy5ErzK79UJ1ac9CccE7taKJFGz/
X-Google-Smtp-Source: ABdhPJxUzd6DEYBr13xTg8AcG4zBV9/rrSVZqSbN9qFp9yxybZ1gZwT7+o60jJd6ceXlYXIYVVouyA==
X-Received: by 2002:a63:4c6:: with SMTP id 189mr629552pge.233.1602709033183;
        Wed, 14 Oct 2020 13:57:13 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s11sm429086pjz.29.2020.10.14.13.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 13:57:12 -0700 (PDT)
Subject: Re: Loophole in async page I/O
To:     Hao_Xu <haoxu@linux.alibaba.com>,
        Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
 <0a2918fc-b2e4-bea0-c7e1-265a3da65fc9@kernel.dk>
 <22881662-a503-1706-77e2-8f71bf41fe49@kernel.dk>
 <22435d46-bf78-ee8d-4470-bb3bcbc20cf2@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <794bb5f3-b9c3-b3f1-df42-fe2167175d23@kernel.dk>
Date:   Wed, 14 Oct 2020 14:57:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <22435d46-bf78-ee8d-4470-bb3bcbc20cf2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/20 2:31 PM, Hao_Xu wrote:
> Hi Jens,
> I've done some tests for the new fix code with readahead disabled from 
> userspace. Here comes some results.
> For the perf reports, since I'm new to kernel stuff, still investigating 
> on it.
> I'll keep addressing the issue which causes the difference among the 
> four perf reports(in which the  copy_user_enhanced_fast_string() catches 
> my eyes)
> 
> my environment is:
>      server: physical server
>      kernel: mainline 5.9.0-rc8+ latest commit 6f2f486d57c4d562cdf4
>      fs: ext4
>      device: nvme ssd
>      fio: 3.20
> 
> I did the tests by setting and commenting the code:
>      filp->f_mode |= FMODE_BUF_RASYNC;
> in fs/ext4/file.c ext4_file_open()

You don't have to modify the kernel, if you use a newer fio then you can
essentially just add:

--force_async=1

after setting the engine to io_uring to get the same effect. Just a
heads up, as that might make it easier for you.

> the IOPS with readahead disabled from userspace is below:
> 
> with new fix code(force readahead)
> QD/Test        FMODE_BUF_RASYNC set    FMODE_BUF_RASYNC not set
> 1                    10.8k                  10.3k
> 2                    21.2k                  20.1k
> 4                    41.1k                  39.1k
> 8                    76.1k                  72.2k
> 16                   133k                   126k
> 32                   169k                   147k
> 64                   176k                   160k
> 128                  (1)187k                (2)156k
> 
> now async buffered reads feature looks better in terms of IOPS,
> but it still looks similar with the async buffered reads feature in the 
> mainline code.

I'd say it looks better all around. And what you're completely
forgetting here is that when FMODE_BUF_RASYNC isn't set, then you're
using QD number of async workers to achieve that result. Hence you have
1..128 threads potentially running on that one, vs having a _single_
process running with FMODE_BUF_RASYNC.

> with mainline code(the fix code in commit c8d317aa1887 ("io_uring: fix 
> async buffered reads when readahead is disabled"))
> QD/Test        FMODE_BUF_RASYNC set    FMODE_BUF_RASYNC not set
> 1                       10.9k            10.2k
> 2                       21.6k            20.2k
> 4                       41.0k            39.9k
> 8                       79.7k            75.9k
> 16                      141k             138k
> 32                      169k             237k
> 64                      190k             316k
> 128                     (3)195k          (4)315k
> 
> Considering the number in place (1)(2)(3)(4), the new fix doesn't seem 
> to fix the slow down
> but make the number (4) become number (2)

Not sure why there would be a difference between 2 and 4, that does seem
odd. I'll see if I can reproduce that. More questions below.

> the perf reports of (1)(2)(3)(4) situations are:
> (1)
>    9 # Overhead  Command  Shared Object       Symbol
>   10 # ........  .......  .................. 
> ..............................................
>   11 #
>   12     10.19%  fio      [kernel.vmlinux]    [k] 
> copy_user_enhanced_fast_string
>   13      8.53%  fio      fio                 [.] clock_thread_fn
>   14      4.67%  fio      [kernel.vmlinux]    [k] xas_load
>   15      2.18%  fio      [kernel.vmlinux]    [k] clear_page_erms
>   16      2.02%  fio      libc-2.24.so        [.] __memset_avx2_erms
>   17      1.55%  fio      [kernel.vmlinux]    [k] mutex_unlock
>   18      1.51%  fio      [kernel.vmlinux]    [k] shmem_getpage_gfp
>   19      1.48%  fio      [kernel.vmlinux]    [k] native_irq_return_iret
>   20      1.48%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
>   21      1.46%  fio      [kernel.vmlinux]    [k] generic_file_buffered_read
>   22      1.45%  fio      [nvme]              [k] nvme_irq
>   23      1.25%  fio      [kernel.vmlinux]    [k] __list_del_entry_valid
>   24      1.22%  fio      [kernel.vmlinux]    [k] free_pcppages_bulk
>   25      1.15%  fio      [kernel.vmlinux]    [k] _raw_spin_lock
>   26      1.12%  fio      fio                 [.] get_io_u
>   27      0.81%  fio      [ext4]              [k] ext4_mpage_readpages
>   28      0.78%  fio      fio                 [.] fio_gettime
>   29      0.76%  fio      [kernel.vmlinux]    [k] find_get_entries
>   30      0.75%  fio      [vdso]              [.] __vdso_clock_gettime
>   31      0.73%  fio      [kernel.vmlinux]    [k] release_pages
>   32      0.68%  fio      [kernel.vmlinux]    [k] find_get_entry
>   33      0.68%  fio      fio                 [.] io_u_queued_complete
>   34      0.67%  fio      [kernel.vmlinux]    [k] io_async_buf_func
>   35      0.65%  fio      [kernel.vmlinux]    [k] io_submit_sqes

These profiles are of marginal use, as you're only profiling fio itself,
not all of the async workers that are running for !FMODE_BUF_RASYNC.

How long does the test run? It looks suspect that clock_thread_fn shows
up in the profiles at all.

And is it actually doing IO, or are you using shm/tmpfs for this test?
Isn't ext4 hosting the file? I see a lot of shmem_getpage_gfp(), makes
me a little confused.

-- 
Jens Axboe


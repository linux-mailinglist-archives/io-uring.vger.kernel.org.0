Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681B915F788
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 21:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgBNUNi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 15:13:38 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46475 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387505AbgBNUNi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 15:13:38 -0500
Received: by mail-pg1-f195.google.com with SMTP id b35so5339308pgm.13
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 12:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2Micov/NqPFeWnuJIGvBye/adxMXUKvTi7INn1relB8=;
        b=1QCErWrylzA2IG9wlVfYo0JaZu6PkbQJZMzyS7vIAgk8nJ1znjGmOwjX8HYz3c0Hyh
         N6ZdRETeRnPot9lmmCVDVYYfqfw6W3dpi0Uk3Keh23VKfWE5bzR3s9W/O/T2V+mVMFsx
         rbtv8cHq+duwGsSLqNeVIRkjqUnQwH5yYrK0SQddfmx+1DLgzSUVRSb4CjPjE933x9CT
         WvG/3+ldg+kyksceKdF8Po5HmYprC7yDb4VsHDGn24EIXZus+4T5KzXpeJ0gynd8TnvY
         6vntpYdqokGP195y1IpQdcYaal0qF/pxI+gguBRc/NYiWuuKk27BDYCAdy3HAr8oikDx
         XMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Micov/NqPFeWnuJIGvBye/adxMXUKvTi7INn1relB8=;
        b=GO6TvLDAbyPw9FS3n3B2kN3sLqP0I09OF1KrKDm44IEqCJcvytmf/UMI6ATXP4Rp2g
         AfO/aO2K1kV0qMGBFs0sWHVrMfB55p82rBwegtexCU3lb8HTCs89/PKwqtfwg1EF2Rsr
         JRz+ybFm28F/Uj8B/nHzNg2xQ+8amn0Grnwc1hx8UVA40OBqmtsZ8NCf7z7BqHK7axqe
         4mT9pY1dCv8gKmx0JnG7Z+zWV8/NpEWsH3kTiK8usr50smOwhCywe/925s9ekHpv0Lid
         R842yvVaqRFThzOc6OvWQyCCCalwubS6u3rxwWlugYX1w0di8svsop0SB+2WhlKBQYP8
         iLIQ==
X-Gm-Message-State: APjAAAX3seGcbYue7vKwWMgLetGu+L9GcR1G6BkHMFav8oOdz+Srj5E+
        8IZs7+ilDsAaEIx2HMW+7xBYBTfy5+Y=
X-Google-Smtp-Source: APXvYqykBkOcvpszOuAtabZuRDYGNMh5a9ZemSCQzxsJwZ+rfCQz8tUYuZI+qHkPi8TgClzC5NbW6g==
X-Received: by 2002:aa7:93a6:: with SMTP id x6mr5209584pff.72.1581711217159;
        Fri, 14 Feb 2020 12:13:37 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n2sm7976031pfq.50.2020.02.14.12.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 12:13:36 -0800 (PST)
Subject: Re: Buffered IO async context overhead
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
Date:   Fri, 14 Feb 2020 13:13:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 12:50 PM, Andres Freund wrote:
> Hi,
> 
> For workloads where a lot of buffered IO is done, I see considerably
> higher overhead when going through io_uring, then when just doing the IO
> synchronously.
> 
> This example is on a samsung 970 pro nvme (i.e. decent, but not top
> class). I've limited the amount of dirty buffers allowed to 2/4 GB to
> keep the test times in check.   This is with a relatively recent kernel,
> 33b40134e5cfbbccad7f3040d1919889537a3df7 .
> 
> fio --name=t --time_based=1 --runtime=100 --ioengine=io_uring --rw=write --bs=8k --filesize=300G --iodepth=1
> 
> Jobs: 1 (f=1): [W(1)][100.0%][w=1049MiB/s][w=134k IOPS][eta 00m:00s]
> t: (groupid=0, jobs=1): err= 0: pid=46625: Fri Feb 14 11:22:05 2020
>   write: IOPS=73.4k, BW=573MiB/s (601MB/s)(55.0GiB/100001msec); 0 zone resets
>     slat (nsec): min=571, max=607779, avg=2927.18, stdev=1213.47
>     clat (nsec): min=40, max=1400.7k, avg=9947.92, stdev=2606.65
>      lat (usec): min=4, max=1403, avg=12.94, stdev= 3.28
>     clat percentiles (nsec):
>      |  1.00th=[ 4960],  5.00th=[ 6368], 10.00th=[ 8032], 20.00th=[ 8640],
>      | 30.00th=[ 9024], 40.00th=[ 9280], 50.00th=[ 9664], 60.00th=[10048],
>      | 70.00th=[10560], 80.00th=[11072], 90.00th=[11968], 95.00th=[13120],
>      | 99.00th=[21632], 99.50th=[23424], 99.90th=[26752], 99.95th=[28288],
>      | 99.99th=[35584]
>    bw (  KiB/s): min=192408, max=1031483, per=79.92%, avg=468998.16, stdev=108691.70, samples=199
>    iops        : min=24051, max=128935, avg=58624.37, stdev=13586.54, samples=199
>   lat (nsec)   : 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%
>   lat (nsec)   : 1000=0.01%
>   lat (usec)   : 2=0.01%, 4=0.01%, 10=56.98%, 20=41.67%, 50=1.32%
>   lat (usec)   : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%
>   lat (msec)   : 2=0.01%
>   cpu          : usr=15.63%, sys=34.79%, ctx=7333387, majf=0, minf=41
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=0,7335827,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: bw=573MiB/s (601MB/s), 573MiB/s-573MiB/s (601MB/s-601MB/s), io=55.0GiB (60.1GB), run=100001-100001msec
> 
> Disk stats (read/write):
>   nvme0n1: ios=0/49033, merge=0/12, ticks=0/1741787, in_queue=1717299, util=20.89%
> 
> 
> During this most of the time there's a number of tasks with decent CPU usage
>   46627 root      20   0       0      0      0 R  99.7   0.0   1:07.74 io_wqe_worker-0
>   46625 root      20   0  756920   6708   1984 S  51.0   0.0   0:34.56 fio
>   42818 root      20   0       0      0      0 I   3.3   0.0   0:03.23 kworker/u82:6-flush-259:0
>   43338 root      20   0       0      0      0 I   1.3   0.0   0:02.06 kworker/u82:18-events_unbound
> 
> 
> Comparing that to using sync:
> fio --name=t --time_based=1 --runtime=100 --ioengine=sync --rw=write --bs=8k --filesize=300G --iodepth=1
> Jobs: 1 (f=1): [W(1)][100.0%][w=1607MiB/s][w=206k IOPS][eta 00m:00s]
> t: (groupid=0, jobs=1): err= 0: pid=46690: Fri Feb 14 11:24:17 2020
>   write: IOPS=234k, BW=1831MiB/s (1920MB/s)(179GiB/100001msec); 0 zone resets
>     clat (nsec): min=1612, max=6649.7k, avg=3913.39, stdev=3170.65
>      lat (nsec): min=1653, max=6649.7k, avg=3955.30, stdev=3172.59
>     clat percentiles (nsec):
>      |  1.00th=[ 2512],  5.00th=[ 2544], 10.00th=[ 2576], 20.00th=[ 2640],
>      | 30.00th=[ 2672], 40.00th=[ 2768], 50.00th=[ 3376], 60.00th=[ 3792],
>      | 70.00th=[ 4192], 80.00th=[ 4832], 90.00th=[ 5792], 95.00th=[ 7008],
>      | 99.00th=[11968], 99.50th=[15552], 99.90th=[22656], 99.95th=[26496],
>      | 99.99th=[40192]
>    bw (  MiB/s): min=  989, max= 2118, per=82.26%, avg=1506.28, stdev=169.56, samples=193
>    iops        : min=126684, max=271118, avg=192803.37, stdev=21703.94, samples=193
>   lat (usec)   : 2=0.01%, 4=66.33%, 10=32.14%, 20=1.34%, 50=0.19%
>   lat (usec)   : 100=0.01%, 250=0.01%, 500=0.01%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 10=0.01%
>   cpu          : usr=8.35%, sys=91.55%, ctx=6183, majf=0, minf=74
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=0,23437892,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: bw=1831MiB/s (1920MB/s), 1831MiB/s-1831MiB/s (1920MB/s-1920MB/s), io=179GiB (192GB), run=100001-100001msec
> 
> Disk stats (read/write):
>   nvme0n1: ios=0/152371, merge=0/587772, ticks=0/5657236, in_queue=5580764, util=67.57%
> 
> Tasks:
>   46690 root      20   0  756912   6524   1800 R 100.0   0.0   1:24.64 fio
>    2913 root      20   0       0      0      0 S  32.2   0.0   0:09.57 kswapd1
>   45683 root      20   0       0      0      0 I  13.2   0.0   0:08.57 kworker/u82:16-events_unbound
>   42816 root      20   0       0      0      0 I  11.2   0.0   0:09.71 kworker/u82:1-flush-259:0
>   36087 root      20   0       0      0      0 I   1.6   0.0   0:01.51 kworker/27:2-xfs-conv/nvme0n1
> 
> I.e. sync did about three times the throughput of io_uring.
> 
> 
> It's possible to make io_uring perform better, by batching
> submissions/completions:
> fio --name=t --time_based=1 --runtime=100 --ioengine=io_uring --rw=write --bs=8k --filesize=300G --iodepth=64 --iodepth_batch_submit=32 --iodepth_batch_complete_min=16 --iodepth_low=16
> t: (g=0): rw=write, bs=(R) 8192B-8192B, (W) 8192B-8192B, (T) 8192B-8192B, ioengine=io_uring, iodepth=64
> fio-3.17
> Starting 1 process
> Jobs: 1 (f=1): [W(1)][100.0%][w=1382MiB/s][w=177k IOPS][eta 00m:00s]
> t: (groupid=0, jobs=1): err= 0: pid=46849: Fri Feb 14 11:28:13 2020
>   write: IOPS=194k, BW=1513MiB/s (1587MB/s)(148GiB/100001msec); 0 zone resets
>     slat (usec): min=4, max=455, avg=48.09, stdev=18.20
>     clat (usec): min=6, max=25435, avg=164.91, stdev=104.69
>      lat (usec): min=66, max=25512, avg=213.03, stdev=101.19
>     clat percentiles (usec):
>      |  1.00th=[   60],  5.00th=[   68], 10.00th=[   78], 20.00th=[   94],
>      | 30.00th=[  108], 40.00th=[  127], 50.00th=[  143], 60.00th=[  180],
>      | 70.00th=[  210], 80.00th=[  227], 90.00th=[  265], 95.00th=[  302],
>      | 99.00th=[  379], 99.50th=[  441], 99.90th=[  562], 99.95th=[  611],
>      | 99.99th=[  816]
>    bw (  MiB/s): min=  289, max= 1802, per=81.00%, avg=1225.72, stdev=173.92, samples=197
>    iops        : min=37086, max=230692, avg=156891.42, stdev=22261.80, samples=197
>   lat (usec)   : 10=0.01%, 50=0.09%, 100=25.74%, 250=60.50%, 500=13.46%
>   lat (usec)   : 750=0.19%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>   cpu          : usr=31.80%, sys=26.04%, ctx=793383, majf=0, minf=1301
>   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=66.7%, >=64=33.3%
>      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=50.0%, 32=50.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=100.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued rwts: total=0,19369087,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=64
> 
> Run status group 0 (all jobs):
>   WRITE: bw=1513MiB/s (1587MB/s), 1513MiB/s-1513MiB/s (1587MB/s-1587MB/s), io=148GiB (159GB), run=100001-100001msec
> 
> Disk stats (read/write):
>   nvme0n1: ios=0/127095, merge=0/15, ticks=0/4936953, in_queue=4873341, util=55.82%
> 
> but that's still worse than the plain sync one. And doesn't work well
> for reads.
> 
> 
> Now, it's clear that there's some overhead in backgrounding small IOs to
> the async context, but this seems awfully high. There's still a slowdown
> when using considerably larger pieces of IO (128k).
> 
> For the 128k, iodepth 1 case I get:
> sync:
> -   97.77%     0.04%  fio      fio                     [.] fio_syncio_queue
>      97.73% fio_syncio_queue
>       - __libc_write
>          - __libc_write
>             - 97.50% entry_SYSCALL_64
>                - 97.31% do_syscall_64
>                   - 97.25% ksys_write
>                      - 97.10% vfs_write
>                         - 96.91% new_sync_write
>                            - 96.82% xfs_file_buffered_aio_write
>                               - 96.13% iomap_file_buffered_write
>                                  - iomap_apply
>                                     - 95.52% iomap_write_actor
>                                        + 37.66% iov_iter_copy_from_user_atomic
>                                        + 26.83% iomap_write_begin
>                                        + 26.64% iomap_write_end.isra.0
>                                          2.26% iov_iter_fault_in_readable
>                                          0.87% balance_dirty_pages_ratelimited
> and --no-children shows:
> +   36.57%  fio      [kernel.vmlinux]    [k] copy_user_enhanced_fast_string
> +   14.31%  fio      [kernel.vmlinux]    [k] iomap_set_range_uptodate
> +    3.85%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
> +    3.34%  fio      [kernel.vmlinux]    [k] queued_spin_lock_slowpath
> +    2.94%  fio      [kernel.vmlinux]    [k] xas_load
> +    2.66%  fio      [kernel.vmlinux]    [k] __add_to_page_cache_locked
> +    2.51%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irqsave
> +    2.28%  fio      [kernel.vmlinux]    [k] iov_iter_fault_in_readable
> +    1.87%  fio      [kernel.vmlinux]    [k] __lru_cache_add
> +    1.80%  fio      [kernel.vmlinux]    [k] __pagevec_lru_add_fn
> +    1.59%  fio      [kernel.vmlinux]    [k] node_dirty_ok
> +    1.30%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irq
> +    1.30%  fio      [kernel.vmlinux]    [k] iomap_set_page_dirty
> +    1.25%  fio      fio                 [.] get_io_u
> +    1.18%  fio      [kernel.vmlinux]    [k] xas_start
> 
> io_uring (the io_wqe_worker-0):
> -  100.00%    22.64%  io_wqe_worker-0  [kernel.vmlinux]  [k] io_wqe_worker
>    - 77.36% io_wqe_worker
>       - 77.18% io_worker_handle_work
>          - 75.80% io_rw_async
>             - io_wq_submit_work
>                - 75.57% io_issue_sqe
>                   - io_write
>                      - 70.96% xfs_file_buffered_aio_write
>                         - 70.37% iomap_file_buffered_write
>                            - iomap_apply
>                               - 70.08% iomap_write_actor
>                                  + 30.05% iov_iter_copy_from_user_atomic
>                                  - 18.38% iomap_write_begin
>                                     - 17.64% grab_cache_page_write_begin
>                                        + 16.73% pagecache_get_page
>                                          0.51% wait_for_stable_page
>                                  - 16.96% iomap_write_end.isra.0
>                                       8.72% iomap_set_range_uptodate
>                                     + 7.35% iomap_set_page_dirty
>                                    3.45% iov_iter_fault_in_readable
>                                    0.56% balance_dirty_pages_ratelimited
>                      - 4.36% kiocb_done
>                         - 3.56% io_cqring_ev_posted
>                            + __wake_up_common_lock
>                           0.61% io_cqring_add_event
>            0.56% io_free_req
> --no-children:
> +   29.55%  io_wqe_worker-0  [kernel.vmlinux]  [k] copy_user_enhanced_fast_string
> +   22.64%  io_wqe_worker-0  [kernel.vmlinux]  [k] io_wqe_worker
> +    8.71%  io_wqe_worker-0  [kernel.vmlinux]  [k] iomap_set_range_uptodate
> +    3.41%  io_wqe_worker-0  [kernel.vmlinux]  [k] iov_iter_fault_in_readable
> +    2.50%  io_wqe_worker-0  [kernel.vmlinux]  [k] get_page_from_freelist
> +    2.24%  io_wqe_worker-0  [kernel.vmlinux]  [k] xas_load
> +    1.82%  io_wqe_worker-0  [kernel.vmlinux]  [k] queued_spin_lock_slowpath
> +    1.80%  io_wqe_worker-0  [kernel.vmlinux]  [k] _raw_spin_lock_irqsave
> +    1.72%  io_wqe_worker-0  [kernel.vmlinux]  [k] __add_to_page_cache_locked
> +    1.58%  io_wqe_worker-0  [kernel.vmlinux]  [k] _raw_spin_lock_irq
> +    1.29%  io_wqe_worker-0  [kernel.vmlinux]  [k] __lru_cache_add
> +    1.27%  io_wqe_worker-0  [kernel.vmlinux]  [k] __pagevec_lru_add_fn
> +    1.08%  io_wqe_worker-0  [kernel.vmlinux]  [k] xas_start
> 
> So it seems the biggest difference is the cpu time in io_wqe_worker
> itself. Which in turn appears to mostly be:
> 
>        │       mov    %rbp,%rdi
>        │     → callq  io_worker_handle_work
>        │       mov    $0x3e7,%eax
>        │     ↓ jmp    28c
>        │     rep_nop():
>        │     }
>        │
>        │     /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
>        │     static __always_inline void rep_nop(void)
>        │     {
>        │     asm volatile("rep; nop" ::: "memory");
>  74.50 │281:   pause
>        │     io_worker_spin_for_work():
>        │     while (++i < 1000) {
>  11.15 │       sub    $0x1,%eax
>        │     ↑ je     9b
>        │     __read_once_size():
>        │     __READ_ONCE_SIZE;
>   9.53 │28c:   mov    0x8(%rbx),%rdx
>        │     io_wqe_run_queue():
>        │     if (!wq_list_empty(&wqe->work_list) &&
>        │       test   %rdx,%rdx
>   2.68 │     ↓ je     29f
>        │     io_worker_spin_for_work():
> 
> 
> With 8k it looks similar, but more extreme:
> sync (fio itself):
> +   29.89%  fio      [kernel.vmlinux]    [k] copy_user_enhanced_fast_string
> +   14.10%  fio      [kernel.vmlinux]    [k] iomap_set_range_uptodate
> +    2.80%  fio      [kernel.vmlinux]    [k] get_page_from_freelist
> +    2.66%  fio      [kernel.vmlinux]    [k] queued_spin_lock_slowpath
> +    2.46%  fio      [kernel.vmlinux]    [k] xas_load
> +    1.97%  fio      [kernel.vmlinux]    [k] _raw_spin_lock_irqsave
> +    1.94%  fio      [kernel.vmlinux]    [k] __add_to_page_cache_locked
> +    1.79%  fio      [kernel.vmlinux]    [k] iomap_set_page_dirty
> +    1.64%  fio      [kernel.vmlinux]    [k] iov_iter_fault_in_readable
> +    1.61%  fio      fio                 [.] __fio_gettime
> +    1.49%  fio      [kernel.vmlinux]    [k] __pagevec_lru_add_fn
> +    1.39%  fio      [kernel.vmlinux]    [k] __lru_cache_add
>      1.30%  fio      fio                 [.] get_io_u
> +    1.11%  fio      [kernel.vmlinux]    [k] up_write
> +    1.10%  fio      [kernel.vmlinux]    [k] node_dirty_ok
> +    1.09%  fio      [kernel.vmlinux]    [k] down_write
> 
> io_uring (io_wqe_worker-0 again):
> +   54.13%  io_wqe_worker-0  [kernel.vmlinux]  [k] io_wqe_worker
> +   11.01%  io_wqe_worker-0  [kernel.vmlinux]  [k] copy_user_enhanced_fast_string
> +    2.70%  io_wqe_worker-0  [kernel.vmlinux]  [k] iomap_set_range_uptodate
> +    2.62%  io_wqe_worker-0  [kernel.vmlinux]  [k] iov_iter_fault_in_readable
> +    1.91%  io_wqe_worker-0  [kernel.vmlinux]  [k] __slab_free
> +    1.85%  io_wqe_worker-0  [kernel.vmlinux]  [k] _raw_spin_lock_irqsave
> +    1.66%  io_wqe_worker-0  [kernel.vmlinux]  [k] try_to_wake_up
> +    1.62%  io_wqe_worker-0  [kernel.vmlinux]  [k] io_cqring_fill_event
> +    1.55%  io_wqe_worker-0  [kernel.vmlinux]  [k] io_rw_async
> +    1.43%  io_wqe_worker-0  [kernel.vmlinux]  [k] __wake_up_common
> +    1.37%  io_wqe_worker-0  [kernel.vmlinux]  [k] _raw_spin_lock_irq
> +    1.20%  io_wqe_worker-0  [kernel.vmlinux]  [k] rw_verify_area
> 
> which I think is pretty clear evidence we're hitting fairly significant
> contention on the queue lock.
> 
> 
> I am hitting this in postgres originally, not fio, but I thought it's
> easier to reproduce this way.  There's obviously benefit to doing things
> in the background - but it requires odd logic around deciding when to
> use io_uring, and when not.
> 
> To be clear, none of this happens with DIO, but I don't forsee switching
> to DIO for all IO by default ever (too high demands on accurate
> configuration).

Can you try with this added?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 76cbf474c184..207daf83f209 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -620,6 +620,7 @@ static const struct io_op_def io_op_defs[] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_WRITEV] = {
@@ -634,6 +635,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -711,11 +713,13 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_FADVISE] = {
@@ -955,7 +959,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 	bool do_hashed = false;
 
 	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file)
+		if (!(req->kiocb->ki_flags & IOCB_DIRECT) && def->hash_reg_file)
 			do_hashed = true;
 	} else {
 		if (def->unbound_nonreg_file)

-- 
Jens Axboe


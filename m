Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3848E35A189
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhDIOxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 10:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhDIOxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 10:53:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B90BC061760;
        Fri,  9 Apr 2021 07:53:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso3124514wmq.4;
        Fri, 09 Apr 2021 07:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F4L5k00MCYAkYKbtq27mvOiN47MzHKZV8WH2mTH52wg=;
        b=vPVx30+dQKe0EV7Ns7y+BDFAAv1z3xVq/fOCGFjv3AUtW1iA5WRMk3kCPvWO9gVv43
         nfKHwyo3mQvgxn36+5nKWn34uovHcXKEo0vtelwxbj/MmcbrILjCnHm5d7dNjMuoSChy
         AvUXFS1uHf6QcQq3R4/T3xBlcUqjVMZZl99ERvObYUoon3YtpJj0knwUAXlX7CadajuZ
         MzSKomcM8s7Ig+nxaJH2PpTcIJcWC2BwoWzMTEgprtAsT7w1uBv5hiJ/6cZRImAWC+kR
         UcfRnkUC72JzqXJKOGR/drjCX8eq7OpnZzuEkIxvjaKVt7sMmVzU5ycBQBwSD4Ty5Apx
         fDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F4L5k00MCYAkYKbtq27mvOiN47MzHKZV8WH2mTH52wg=;
        b=dfw+zW39r1oee5v6JcnWqxt1R0leolxBjO9PJTAeGma0zcaQ7e3MeMshiFoFx2abD8
         371USRSBWtGZmwlgM4VUXsOjdI4Zs3OKzfjl44efe6CYHDbzkSZAzHvQkopGAP1HlHnp
         WtbRrxUVPf2qhfhGUsJ9tO/evyOKmSEu6yuVx+RYqxeshIh3akLZHyumGsZ6Adab4WYL
         7Vd0xSmerKxFpYvLSMPKrByZzdLilboyR/0Gdmn5ybg5q9ywpbWJizHHZs7cey5whtCL
         CIUb1tUlUvWnHUOwzOU7g2dsnm+QspC+3pb59IHGJW2NoVRBzBmFdi92NYYVcCYsvZN/
         9Mgw==
X-Gm-Message-State: AOAM531nusoGaiIlkQt1viBmtfXfqpsKWij8SySzq7c29jYZASxzGanh
        BhuMYKBSJmEh3nuMl3jmsZPx2GMkximT4w==
X-Google-Smtp-Source: ABdhPJzvnsmymF9vSGbS+IwW/Q5gvqNNhyhy0kPbUqqSUacLcsG5ZRN8f8Bk2vCb2/bB6CW3H3UTIw==
X-Received: by 2002:a1c:87:: with SMTP id 129mr8982505wma.112.1617980002573;
        Fri, 09 Apr 2021 07:53:22 -0700 (PDT)
Received: from [192.168.8.162] ([148.252.129.0])
        by smtp.gmail.com with ESMTPSA id f20sm4163543wmg.36.2021.04.09.07.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 07:53:21 -0700 (PDT)
To:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
Message-ID: <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
Date:   Fri, 9 Apr 2021 15:49:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210401071807.3328235-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/04/2021 08:18, yangerkun wrote:
> We get a bug:
> 
> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x11c/0x404
> lib/iov_iter.c:1139
> Read of size 8 at addr ffff0000d3fb11f8 by task
> 
> CPU: 0 PID: 12582 Comm: syz-executor.2 Not tainted
> 5.10.0-00843-g352c8610ccd2 #2
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace+0x0/0x2d0 arch/arm64/kernel/stacktrace.c:132
>  show_stack+0x28/0x34 arch/arm64/kernel/stacktrace.c:196
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x110/0x164 lib/dump_stack.c:118
>  print_address_description+0x78/0x5c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report+0x148/0x1e4 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:183 [inline]
>  __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>  iov_iter_revert+0x11c/0x404 lib/iov_iter.c:1139
>  io_read fs/io_uring.c:3421 [inline]
>  io_issue_sqe+0x2344/0x2d64 fs/io_uring.c:5943
>  __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>  io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>  io_submit_sqe fs/io_uring.c:6395 [inline]
>  io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>  __do_sys_io_uring_enter fs/io_uring.c:9013 [inline]
>  __se_sys_io_uring_enter fs/io_uring.c:8960 [inline]
>  __arm64_sys_io_uring_enter+0x190/0x708 fs/io_uring.c:8960
>  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>  el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>  do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:227
>  el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
>  el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>  el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
> 
> Allocated by task 12570:
>  stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc+0xdc/0x120 mm/kasan/common.c:461
>  kasan_kmalloc+0xc/0x14 mm/kasan/common.c:475
>  __kmalloc+0x23c/0x334 mm/slub.c:3970
>  kmalloc include/linux/slab.h:557 [inline]
>  __io_alloc_async_data+0x68/0x9c fs/io_uring.c:3210
>  io_setup_async_rw fs/io_uring.c:3229 [inline]
>  io_read fs/io_uring.c:3436 [inline]
>  io_issue_sqe+0x2954/0x2d64 fs/io_uring.c:5943
>  __io_queue_sqe+0x19c/0x520 fs/io_uring.c:6260
>  io_queue_sqe+0x2a4/0x590 fs/io_uring.c:6326
>  io_submit_sqe fs/io_uring.c:6395 [inline]
>  io_submit_sqes+0x4c0/0xa04 fs/io_uring.c:6624
>  __do_sys_io_uring_enter fs/io_uring.c:9013 [inline]
>  __se_sys_io_uring_enter fs/io_uring.c:8960 [inline]
>  __arm64_sys_io_uring_enter+0x190/0x708 fs/io_uring.c:8960
>  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>  el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>  do_el0_svc+0x120/0x290 arch/arm64/kernel/syscall.c:227
>  el0_svc+0x1c/0x28 arch/arm64/kernel/entry-common.c:367
>  el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>  el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
> 
> Freed by task 12570:
>  stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track+0x38/0x6c mm/kasan/common.c:56
>  kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:355
>  __kasan_slab_free+0x124/0x150 mm/kasan/common.c:422
>  kasan_slab_free+0x10/0x1c mm/kasan/common.c:431
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook mm/slub.c:1577 [inline]
>  slab_free mm/slub.c:3142 [inline]
>  kfree+0x104/0x38c mm/slub.c:4124
>  io_dismantle_req fs/io_uring.c:1855 [inline]
>  __io_free_req+0x70/0x254 fs/io_uring.c:1867
>  io_put_req_find_next fs/io_uring.c:2173 [inline]
>  __io_queue_sqe+0x1fc/0x520 fs/io_uring.c:6279
>  __io_req_task_submit+0x154/0x21c fs/io_uring.c:2051
>  io_req_task_submit+0x2c/0x44 fs/io_uring.c:2063
>  task_work_run+0xdc/0x128 kernel/task_work.c:151
>  get_signal+0x6f8/0x980 kernel/signal.c:2562
>  do_signal+0x108/0x3a4 arch/arm64/kernel/signal.c:658
>  do_notify_resume+0xbc/0x25c arch/arm64/kernel/signal.c:722
>  work_pending+0xc/0x180
> 
> blkdev_read_iter can truncate iov_iter's count since the count + pos may
> exceed the size of the blkdev. This will confuse io_read that we have
> consume the iovec. And once we do the iov_iter_revert in io_read, we
> will trigger the slab-out-of-bounds. Fix it by reexpand the count with
> size has been truncated.

Looks right,

Acked-by: Pavel Begunkov <asml.silencec@gmail.com>

> 
> blkdev_write_iter can trigger the problem too.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/block_dev.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 92ed7d5df677..788e1014576f 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1680,6 +1680,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	struct inode *bd_inode = bdev_file_inode(file);
>  	loff_t size = i_size_read(bd_inode);
>  	struct blk_plug plug;
> +	size_t shorted = 0;
>  	ssize_t ret;
>  
>  	if (bdev_read_only(I_BDEV(bd_inode)))
> @@ -1697,12 +1698,17 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if ((iocb->ki_flags & (IOCB_NOWAIT | IOCB_DIRECT)) == IOCB_NOWAIT)
>  		return -EOPNOTSUPP;
>  
> -	iov_iter_truncate(from, size - iocb->ki_pos);
> +	size -= iocb->ki_pos;
> +	if (iov_iter_count(from) > size) {
> +		shorted = iov_iter_count(from) - size;
> +		iov_iter_truncate(from, size);
> +	}
>  
>  	blk_start_plug(&plug);
>  	ret = __generic_file_write_iter(iocb, from);
>  	if (ret > 0)
>  		ret = generic_write_sync(iocb, ret);
> +	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
>  	blk_finish_plug(&plug);
>  	return ret;
>  }
> @@ -1714,13 +1720,21 @@ ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	struct inode *bd_inode = bdev_file_inode(file);
>  	loff_t size = i_size_read(bd_inode);
>  	loff_t pos = iocb->ki_pos;
> +	size_t shorted = 0;
> +	ssize_t ret;
>  
>  	if (pos >= size)
>  		return 0;
>  
>  	size -= pos;
> -	iov_iter_truncate(to, size);
> -	return generic_file_read_iter(iocb, to);
> +	if (iov_iter_count(to) > size) {
> +		shorted = iov_iter_count(to) - size;
> +		iov_iter_truncate(to, size);
> +	}
> +
> +	ret = generic_file_read_iter(iocb, to);
> +	iov_iter_reexpand(to, iov_iter_count(to) + shorted);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(blkdev_read_iter);
>  
> 

-- 
Pavel Begunkov

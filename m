Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B91175C8B
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 15:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBOFt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 09:05:49 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36997 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgCBOFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 09:05:49 -0500
Received: by mail-il1-f193.google.com with SMTP id a6so9404648ilc.4
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 06:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3jFpsIIYVofSaFtxOUgqKk0fISRkToP+ixiKdyYmaHU=;
        b=LCtRr2OTxEorkPjGml5uJgZsXSw1D1cyZ71R7QWIKu1F3snwSCLHZJXtXdMhj/icuF
         ic9xq4R5qXtTr+B4dkpeNk8L1zG14h7dEax1M5v6P/NP6NlVePjzzif+z7tV41cM/7Sn
         0YLIxIPhySuOPdjVPpPEHOobKDr7IwxdJweWZ9wF7EdP6V2BT7dXOO3tncak50Ofjp/U
         M5Ia8gVI4QNBIPCw8xdusYg3aKPjS6Lzy108sNkH66HD0fyuZAXAQ8y+ib9kBZ+xLZIe
         GOGvImHBLMdiUHQoWtctpBsrAlrbCG63n8zYmqg/3QAo/BTVBP2xLmGkSWX8yG+027Ia
         PN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3jFpsIIYVofSaFtxOUgqKk0fISRkToP+ixiKdyYmaHU=;
        b=aTjRFnSYOKtSWTRA471LkikjQXJPtIghLK6TPsPb2bQEbPzsI73eYU+Lnrebh/0Vhg
         RjZDOW3r/bC70sLzaDa3mWNb231aGVXbq3hz1QVnmcqxE4PcDhphsk2UR48sOXThA2HK
         nTGMciH5tX+WjHYVVaDLKqhsfVaBpGRHLP6+18Zz0bWL4vBPnClXAkIBqqWz0RCaMHkw
         8Bzh1oeKZdRuBdiV2JEyjK1q2H4/w3RJnmjnWRxyJ0eIH+nl2xf+2T2pkorLJQUwMFBP
         tZJ5PBQs09rgTwyywhAX1ZIqrYJK5XtYN0c4YBLpDmPqvYMs50px4r/yxFZl3AR0lddj
         rYAw==
X-Gm-Message-State: APjAAAUep5rQdyVds77DzGdcxb+owIO9PXVHJvVJlC/ZzqWJMzz45K45
        pos0LnLMAK9G2qDOnw6BUySivfvw07c=
X-Google-Smtp-Source: APXvYqzf3tquFLu/H7gi0sUmJQlCof3cTsTEVTXQaBcNsw+tadGx/C4hX7rXqWn1/mH0YAHIzVNEXQ==
X-Received: by 2002:a92:3dc3:: with SMTP id k64mr8404257ilf.208.1583157947244;
        Mon, 02 Mar 2020 06:05:47 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm6613456ila.54.2020.03.02.06.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 06:05:46 -0800 (PST)
Subject: Re: [PATCH] __io_uring_get_cqe: eliminate unnecessary
 io_uring_enter() syscalls
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <91e11a5a-1880-8ce3-18c5-6843abd2cf2b@kernel.dk>
Date:   Mon, 2 Mar 2020 07:05:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/20 9:18 PM, Xiaoguang Wang wrote:
> When user applis programming mode, like sumbit one sqe and wait its
> completion event, __io_uring_get_cqe() will result in many unnecessary
> syscalls, see below test program:
> 
>     int main(int argc, char *argv[])
>     {
>             struct io_uring ring;
>             int fd, ret;
>             struct io_uring_sqe *sqe;
>             struct io_uring_cqe *cqe;
>             struct iovec iov;
>             off_t offset, filesize = 0;
>             void *buf;
> 
>             if (argc < 2) {
>                     printf("%s: file\n", argv[0]);
>                     return 1;
>             }
> 
>             ret = io_uring_queue_init(4, &ring, 0);
>             if (ret < 0) {
>                     fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>                     return 1;
>             }
> 
>             fd = open(argv[1], O_RDONLY | O_DIRECT);
>             if (fd < 0) {
>                     perror("open");
>                     return 1;
>             }
> 
>             if (posix_memalign(&buf, 4096, 4096))
>                     return 1;
>             iov.iov_base = buf;
>             iov.iov_len = 4096;
> 
>             offset = 0;
>             do {
>                     sqe = io_uring_get_sqe(&ring);
>                     if (!sqe) {
>                             printf("here\n");
>                             break;
>                     }
>                     io_uring_prep_readv(sqe, fd, &iov, 1, offset);
> 
>                     ret = io_uring_submit(&ring);
>                     if (ret < 0) {
>                             fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>                             return 1;
>                     }
> 
>                     ret = io_uring_wait_cqe(&ring, &cqe);
>                     if (ret < 0) {
>                             fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
>                             return 1;
>                     }
> 
>                     if (cqe->res <= 0) {
>                             if (cqe->res < 0) {
>                                     fprintf(stderr, "got eror: %d\n", cqe->res);
>                                     ret = 1;
>                             }
>                             io_uring_cqe_seen(&ring, cqe);
>                             break;
>                     }
>                     offset += cqe->res;
>                     filesize += cqe->res;
>                     io_uring_cqe_seen(&ring, cqe);
>             } while (1);
> 
>             printf("filesize: %ld\n", filesize);
>             close(fd);
>             io_uring_queue_exit(&ring);
>             return 0;
>     }
> 
> dd if=/dev/zero of=testfile bs=4096 count=16
> ./test  testfile
> and use bpftrace to trace io_uring_enter syscalls, in original codes,
> [lege@localhost ~]$ sudo bpftrace -e "tracepoint:syscalls:sys_enter_io_uring_enter {@c[tid] = count();}"
> Attaching 1 probe...
> @c[11184]: 49
> Above test issues 49 syscalls, it's counterintuitive. After looking
> into the codes, it's because __io_uring_get_cqe issue one more syscall,
> indded when __io_uring_get_cqe issues the first syscall, one cqe should
> already be ready, we don't need to wait again.
> 
> To fix this issue, after the first syscall, set wait_nr to be zero, with
> tihs patch, bpftrace shows the number of io_uring_enter syscall is 33.

Thanks, that's a nice fix, we definitely don't want to be doing
50% more system calls than we have to...

-- 
Jens Axboe


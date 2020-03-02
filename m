Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E3E175E52
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 16:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCBPhV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 10:37:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41109 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgCBPhV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 10:37:21 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so11949954ioo.8
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 07:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ghVOQQN3KEHQe9NKhsD9xk9Z/OgnNQNqhZa0+AkMlQQ=;
        b=W2d2UtzezEjQTnyLcJwflUQ05znEwRFhcrBD6qMRnXWlrspLg2RkC89xVVDGchQnA6
         Y78QF+1WyqBh3QiVGvWksjPrs6tiqmOoIUkJiEUV/edA6KnTpdOOwYA3rg/VAypBW/0c
         opznerf56wRa2jUCLYnkTkvVL0J81katdKtKHfFW6SUoFElqMMRl4tjQ+fKwN1w2I+EP
         P3nWpY/rGczXCzUTclJgRU/Cg6BRTlY6crNhI9NcJ+ln/X1JZwugyabalyQNMAcAptMR
         IxytQ7OemWDjjfusLB5v8jDdWwb+UTWQHp5qBj7Zr4b30u0oIXEF2VHoIWVk/OvYbfL0
         SJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ghVOQQN3KEHQe9NKhsD9xk9Z/OgnNQNqhZa0+AkMlQQ=;
        b=m8EjLPpProSGgfHBH44uWMcI5ClETyidFrruj68YKuIhYkyZlAzj4F2uO5zinmR9HW
         9rqsC5mowiai0Ny0y0vET6WRBN/b/FtBf6tUeB+87qfppcShmWOeHGKi5fGrXgoyQFYK
         +f79htPJwrFlbUr0adFONKVyJWraf+X/cJ3cifnia81k6C80r+t3qximnEgn1j+5C+S0
         eHCzn5XyFzBN+goRN9pPiJzcTHWEpTmnu8616lQVyRMAP2+vm2u2hOJBsVQouOsX1Xpa
         Oh6zHUOLAQcFMjTM6QHKRUlp8zbk3/qiLi+n7SSMrirqcsYxA7hJw/pFvzGlQnMapcd5
         7Biw==
X-Gm-Message-State: APjAAAU21eXxr9ussjz46sXzUmO6QQv+u2Ez5K5M3kic9QmgwwqkCbvA
        /i1L/7zBWRqDHuLaHcuM4ySfYXOmmGk=
X-Google-Smtp-Source: APXvYqytCvKfcD0qNBm6sVBevLWaglMtTTSMG1gBOfV+DH4seuCnFUB7Zx+dGiiW/C77nh1aN6PYwg==
X-Received: by 2002:a02:90d0:: with SMTP id c16mr8968952jag.22.1583163440501;
        Mon, 02 Mar 2020 07:37:20 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j17sm6735092ild.45.2020.03.02.07.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 07:37:20 -0800 (PST)
Subject: Re: [PATCH] __io_uring_get_cqe: eliminate unnecessary
 io_uring_enter() syscalls
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
 <91e11a5a-1880-8ce3-18c5-6843abd2cf2b@kernel.dk>
 <5370d9cf-2ca6-53bc-0e32-544a43ca88a3@kernel.dk>
Message-ID: <1c4ff425-a5a9-1e5a-a07c-24c8f3aa0f2e@kernel.dk>
Date:   Mon, 2 Mar 2020 08:37:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5370d9cf-2ca6-53bc-0e32-544a43ca88a3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 8:24 AM, Jens Axboe wrote:
> On 3/2/20 7:05 AM, Jens Axboe wrote:
>> On 3/1/20 9:18 PM, Xiaoguang Wang wrote:
>>> When user applis programming mode, like sumbit one sqe and wait its
>>> completion event, __io_uring_get_cqe() will result in many unnecessary
>>> syscalls, see below test program:
>>>
>>>     int main(int argc, char *argv[])
>>>     {
>>>             struct io_uring ring;
>>>             int fd, ret;
>>>             struct io_uring_sqe *sqe;
>>>             struct io_uring_cqe *cqe;
>>>             struct iovec iov;
>>>             off_t offset, filesize = 0;
>>>             void *buf;
>>>
>>>             if (argc < 2) {
>>>                     printf("%s: file\n", argv[0]);
>>>                     return 1;
>>>             }
>>>
>>>             ret = io_uring_queue_init(4, &ring, 0);
>>>             if (ret < 0) {
>>>                     fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>>>                     return 1;
>>>             }
>>>
>>>             fd = open(argv[1], O_RDONLY | O_DIRECT);
>>>             if (fd < 0) {
>>>                     perror("open");
>>>                     return 1;
>>>             }
>>>
>>>             if (posix_memalign(&buf, 4096, 4096))
>>>                     return 1;
>>>             iov.iov_base = buf;
>>>             iov.iov_len = 4096;
>>>
>>>             offset = 0;
>>>             do {
>>>                     sqe = io_uring_get_sqe(&ring);
>>>                     if (!sqe) {
>>>                             printf("here\n");
>>>                             break;
>>>                     }
>>>                     io_uring_prep_readv(sqe, fd, &iov, 1, offset);
>>>
>>>                     ret = io_uring_submit(&ring);
>>>                     if (ret < 0) {
>>>                             fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>>>                             return 1;
>>>                     }
>>>
>>>                     ret = io_uring_wait_cqe(&ring, &cqe);
>>>                     if (ret < 0) {
>>>                             fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
>>>                             return 1;
>>>                     }
>>>
>>>                     if (cqe->res <= 0) {
>>>                             if (cqe->res < 0) {
>>>                                     fprintf(stderr, "got eror: %d\n", cqe->res);
>>>                                     ret = 1;
>>>                             }
>>>                             io_uring_cqe_seen(&ring, cqe);
>>>                             break;
>>>                     }
>>>                     offset += cqe->res;
>>>                     filesize += cqe->res;
>>>                     io_uring_cqe_seen(&ring, cqe);
>>>             } while (1);
>>>
>>>             printf("filesize: %ld\n", filesize);
>>>             close(fd);
>>>             io_uring_queue_exit(&ring);
>>>             return 0;
>>>     }
>>>
>>> dd if=/dev/zero of=testfile bs=4096 count=16
>>> ./test  testfile
>>> and use bpftrace to trace io_uring_enter syscalls, in original codes,
>>> [lege@localhost ~]$ sudo bpftrace -e "tracepoint:syscalls:sys_enter_io_uring_enter {@c[tid] = count();}"
>>> Attaching 1 probe...
>>> @c[11184]: 49
>>> Above test issues 49 syscalls, it's counterintuitive. After looking
>>> into the codes, it's because __io_uring_get_cqe issue one more syscall,
>>> indded when __io_uring_get_cqe issues the first syscall, one cqe should
>>> already be ready, we don't need to wait again.
>>>
>>> To fix this issue, after the first syscall, set wait_nr to be zero, with
>>> tihs patch, bpftrace shows the number of io_uring_enter syscall is 33.
>>
>> Thanks, that's a nice fix, we definitely don't want to be doing
>> 50% more system calls than we have to...
> 
> Actually, don't think the fix is quite safe. For one, if we get an error
> on the __io_uring_enter(), then we may not have waited for entries. Or if
> we submitted less than we thought we would, we would not have waited
> either. So we need to check for full success before deeming it safe to
> clear wait_nr.

Unrelated fix:

https://git.kernel.dk/cgit/liburing/commit/?id=0edcef5700fd558d2548532e0e5db26cb74d19ca

and then a fix for your patch on top:

https://git.kernel.dk/cgit/liburing/commit/?id=dc14e30a086082b6aebc3130948e2453e3bd3b2a

Can you double check that your original test case still produces the
same amount of system calls with the fix in place?

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9151791CF
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgCDN5I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:57:08 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40429 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgCDN5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:57:08 -0500
Received: by mail-io1-f67.google.com with SMTP id m22so2466560ioj.7
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 05:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7CG2sL2dJ/MOPYDzCHZTI4142v/Ewxy7iySRKVaWf/4=;
        b=ngnz3BpNUCaBEq5YgVL2gx/nPKF+wQ8DRsbOpviGhge+cOmvFYK1N8EehkZAM7ovEy
         cP+OrvPyJAQjHtgRy/2MvkY2ToPEflt1WKN501reVxm+59Go21tJqeMafvGLbgkZBC68
         iv9ZnjDhjQnt69AcU+FNdSmjSUGCmPfDeFUGGtulVJX4uyZJ8SpR8dyItTQqB9MXEsPd
         NClIPaTN1lPFR1XfiI9Jjc0h/kLXoZlld/vPl3ksDl2YzXHJYLHL/dK15YACK5Y8FZSd
         ngRZEgRvmtlKwjonrhlmbKvN0bJYLbJby1+yXXhRH+usSbDjXVKL7rZoEQzKl7IsBAed
         Nn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CG2sL2dJ/MOPYDzCHZTI4142v/Ewxy7iySRKVaWf/4=;
        b=ayXjazp1fYJzJsW65l85BaDiRSJ63S8RnB+mx/XBYiQAxvVF5ds0k2WKXWhtHUD/9w
         dRqgLiPhyMRkEcQwQmTKfcvN7NhRwvFFR3WZfjnwUV1m9ikw275epsR5JLvsO23d1gJA
         rflSOgYs3DFQ0m7zZ6zuthKBctWnZ+/KLSkZ1mgTpwTKw9MrRWsEaH3AhpgT8Gxtt6lz
         iL+rfAesIpqAPaRHmDiuCUKudb55UcJxbGC1563sx+rbSK4f0dg/BJXtaGpFeOP4tXsi
         Y751fkMpvhVxfkt8mN+JIBySJ4hO7hL7jz5pjgTWVZldcbKE1MlJwwL6ExNUT6xj5tvD
         9QDQ==
X-Gm-Message-State: ANhLgQ3SoGocv7tpgDjKrJHUvzsIfjDq5tXghOBz8+oDpGwBS/nKR2Ad
        VwHNA56VEAjJ4gtoX6PjzGPg1Fgd16o=
X-Google-Smtp-Source: ADFU+vtrJmehvKZhccggxhac/3CyyZ045UK7NtR25hIq1le9Vwe8560Sck0IjVqsj6Jjk68BPHNscQ==
X-Received: by 2002:a5e:cb07:: with SMTP id p7mr2149620iom.243.1583330227529;
        Wed, 04 Mar 2020 05:57:07 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i16sm4010890ioo.78.2020.03.04.05.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 05:57:06 -0800 (PST)
Subject: Re: [PATCH] __io_uring_get_cqe: eliminate unnecessary
 io_uring_enter() syscalls
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
 <91e11a5a-1880-8ce3-18c5-6843abd2cf2b@kernel.dk>
 <5370d9cf-2ca6-53bc-0e32-544a43ca88a3@kernel.dk>
 <1c4ff425-a5a9-1e5a-a07c-24c8f3aa0f2e@kernel.dk>
 <40b6ef0c-7e13-a476-0916-3ec293c244d0@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d36c2739-7c12-ce34-f806-251fbcc1781a@kernel.dk>
Date:   Wed, 4 Mar 2020 06:57:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <40b6ef0c-7e13-a476-0916-3ec293c244d0@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 6:27 AM, Xiaoguang Wang wrote:
> hi，
> 
>> On 3/2/20 8:24 AM, Jens Axboe wrote:
>>> On 3/2/20 7:05 AM, Jens Axboe wrote:
>>>> On 3/1/20 9:18 PM, Xiaoguang Wang wrote:
>>>>> When user applis programming mode, like sumbit one sqe and wait its
>>>>> completion event, __io_uring_get_cqe() will result in many unnecessary
>>>>> syscalls, see below test program:
>>>>>
>>>>>      int main(int argc, char *argv[])
>>>>>      {
>>>>>              struct io_uring ring;
>>>>>              int fd, ret;
>>>>>              struct io_uring_sqe *sqe;
>>>>>              struct io_uring_cqe *cqe;
>>>>>              struct iovec iov;
>>>>>              off_t offset, filesize = 0;
>>>>>              void *buf;
>>>>>
>>>>>              if (argc < 2) {
>>>>>                      printf("%s: file\n", argv[0]);
>>>>>                      return 1;
>>>>>              }
>>>>>
>>>>>              ret = io_uring_queue_init(4, &ring, 0);
>>>>>              if (ret < 0) {
>>>>>                      fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>>>>>                      return 1;
>>>>>              }
>>>>>
>>>>>              fd = open(argv[1], O_RDONLY | O_DIRECT);
>>>>>              if (fd < 0) {
>>>>>                      perror("open");
>>>>>                      return 1;
>>>>>              }
>>>>>
>>>>>              if (posix_memalign(&buf, 4096, 4096))
>>>>>                      return 1;
>>>>>              iov.iov_base = buf;
>>>>>              iov.iov_len = 4096;
>>>>>
>>>>>              offset = 0;
>>>>>              do {
>>>>>                      sqe = io_uring_get_sqe(&ring);
>>>>>                      if (!sqe) {
>>>>>                              printf("here\n");
>>>>>                              break;
>>>>>                      }
>>>>>                      io_uring_prep_readv(sqe, fd, &iov, 1, offset);
>>>>>
>>>>>                      ret = io_uring_submit(&ring);
>>>>>                      if (ret < 0) {
>>>>>                              fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>>>>>                              return 1;
>>>>>                      }
>>>>>
>>>>>                      ret = io_uring_wait_cqe(&ring, &cqe);
>>>>>                      if (ret < 0) {
>>>>>                              fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
>>>>>                              return 1;
>>>>>                      }
>>>>>
>>>>>                      if (cqe->res <= 0) {
>>>>>                              if (cqe->res < 0) {
>>>>>                                      fprintf(stderr, "got eror: %d\n", cqe->res);
>>>>>                                      ret = 1;
>>>>>                              }
>>>>>                              io_uring_cqe_seen(&ring, cqe);
>>>>>                              break;
>>>>>                      }
>>>>>                      offset += cqe->res;
>>>>>                      filesize += cqe->res;
>>>>>                      io_uring_cqe_seen(&ring, cqe);
>>>>>              } while (1);
>>>>>
>>>>>              printf("filesize: %ld\n", filesize);
>>>>>              close(fd);
>>>>>              io_uring_queue_exit(&ring);
>>>>>              return 0;
>>>>>      }
>>>>>
>>>>> dd if=/dev/zero of=testfile bs=4096 count=16
>>>>> ./test  testfile
>>>>> and use bpftrace to trace io_uring_enter syscalls, in original codes,
>>>>> [lege@localhost ~]$ sudo bpftrace -e "tracepoint:syscalls:sys_enter_io_uring_enter {@c[tid] = count();}"
>>>>> Attaching 1 probe...
>>>>> @c[11184]: 49
>>>>> Above test issues 49 syscalls, it's counterintuitive. After looking
>>>>> into the codes, it's because __io_uring_get_cqe issue one more syscall,
>>>>> indded when __io_uring_get_cqe issues the first syscall, one cqe should
>>>>> already be ready, we don't need to wait again.
>>>>>
>>>>> To fix this issue, after the first syscall, set wait_nr to be zero, with
>>>>> tihs patch, bpftrace shows the number of io_uring_enter syscall is 33.
>>>>
>>>> Thanks, that's a nice fix, we definitely don't want to be doing
>>>> 50% more system calls than we have to...
>>>
>>> Actually, don't think the fix is quite safe. For one, if we get an error
>>> on the __io_uring_enter(), then we may not have waited for entries. Or if
>>> we submitted less than we thought we would, we would not have waited
>>> either. So we need to check for full success before deeming it safe to
>>> clear wait_nr.
>>
>> Unrelated fix:
>>
>> https://git.kernel.dk/cgit/liburing/commit/?id=0edcef5700fd558d2548532e0e5db26cb74d19ca
>>
>> and then a fix for your patch on top:
>>
>> https://git.kernel.dk/cgit/liburing/commit/?id=dc14e30a086082b6aebc3130948e2453e3bd3b2a
> In this patch, seesms that you forgot to delete:
>      if (wait_nr)
>          wait_nr = 0;
> 
> With these two codes removed, my original test case still produces the same amount
> of io_uring_enter syscalls, so you can just remove them safely.

Ah indeed, thanks for letting me know! Killed those two lines.

-- 
Jens Axboe


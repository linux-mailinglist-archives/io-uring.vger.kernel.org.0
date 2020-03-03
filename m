Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206E0177925
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgCCOfq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 09:35:46 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:47061 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbgCCOfp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 09:35:45 -0500
Received: by mail-pf1-f196.google.com with SMTP id o24so1528776pfp.13
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 06:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ouf1+DJDwhm/5ZElUXpk3SJdH41b2dI1crMCfR1CPw0=;
        b=SMHoGFSdPPFuBWu5C5gXcST+zGDfTmBduWyGTOxeApkgka0f7HBvKJsllmWUlO/qxc
         r15KfdjJh/gXku8O5/hEqvXjKTf4Lz1MlrWoa4wlNOtU/QjQyLlKiJ2LslIcFmQ/IXdk
         Foo1aZyFUzl/IwdFfBRkPuIusHsIoZkAYzdv5PjRhYxI1i1HFEwP7ox7hhoIfg+nJQkZ
         2Wlyj4nCJnr0zrL3O/0MRZKuyZS6NvkIgq/JvozSOJ3wxomzvTSwWPoGowLsWDFsbsSx
         48YrwSL3Zoc+DveupIlbzcpvLPVRHIZ1qSCbYC9bTUCvnlWE74AFuIsjewYyFL9aF/P3
         NV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ouf1+DJDwhm/5ZElUXpk3SJdH41b2dI1crMCfR1CPw0=;
        b=Tc/kkW0zjntN5wpvyWAKhW7ulJSy7fyoMhqyRmmW0pdez6qyluO/Iu88hm7bId//zI
         /RurBpaYn6waCrURAfflaTJZkG0EK/hmHVwEyQEWfiGfDSDSg51flNxJn0QpzpfuglF1
         /r6soY0hsQWREClPEMfdtPwDkh5CnFzvzJv62Se9iRvmgYwlSoiBQG3xciYvMnBk3eZk
         rzcNUYeglTGjMxLYaTGMvW8rF6ZwbeYvYwQbGSH8ULb+v6hc1Pax7Ix8Hmp/SNFSwHXb
         e38klkM37CDrWgo/v5OHHDYLxY1u/UDbEfG7JKngMvxhOXdnRslFwiIuqnWi/oZUOYDi
         CdCg==
X-Gm-Message-State: ANhLgQ387pZb/wcOA3CXG71VKfAt0kFF4jh31yTnsHB3rqv1nIqTW/t4
        DesFMjNf1Qhzr+SMC83o3oWMlmiD4jE=
X-Google-Smtp-Source: ADFU+vuLhOC1RMoSeVI5IKfC6PyRPfetRlCN8E/6vRAYtCBSnTINgs1Hiin3fOMq2P0YeOnwfyjN1Q==
X-Received: by 2002:a63:5713:: with SMTP id l19mr4485444pgb.216.1583246143131;
        Tue, 03 Mar 2020 06:35:43 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c2sm2779393pjo.28.2020.03.03.06.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 06:35:42 -0800 (PST)
Subject: Re: [PATCH] __io_uring_get_cqe: eliminate unnecessary
 io_uring_enter() syscalls
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
 <91e11a5a-1880-8ce3-18c5-6843abd2cf2b@kernel.dk>
 <5370d9cf-2ca6-53bc-0e32-544a43ca88a3@kernel.dk>
 <1c4ff425-a5a9-1e5a-a07c-24c8f3aa0f2e@kernel.dk>
 <90f3eee6-ddec-74a9-e9d0-568aa3e0fdc9@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed18a9e4-60d9-721a-ec3f-fe42452eb413@kernel.dk>
Date:   Tue, 3 Mar 2020 07:35:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <90f3eee6-ddec-74a9-e9d0-568aa3e0fdc9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/20 6:11 AM, Xiaoguang Wang wrote:
> hi,
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
>>
>> Can you double check that your original test case still produces the
>> same amount of system calls with the fix in place?
> Yes, it still produces the same amount of system calls.
> Thanks for explanation and right fix.

Great, thanks for confirming!

-- 
Jens Axboe


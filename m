Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF2B1776B6
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 14:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgCCNLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 08:11:44 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53079 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727913AbgCCNLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 08:11:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TrZAP.J_1583241099;
Received: from 30.39.180.198(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TrZAP.J_1583241099)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Mar 2020 21:11:40 +0800
Subject: Re: [PATCH] __io_uring_get_cqe: eliminate unnecessary
 io_uring_enter() syscalls
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200302041811.13330-1-xiaoguang.wang@linux.alibaba.com>
 <91e11a5a-1880-8ce3-18c5-6843abd2cf2b@kernel.dk>
 <5370d9cf-2ca6-53bc-0e32-544a43ca88a3@kernel.dk>
 <1c4ff425-a5a9-1e5a-a07c-24c8f3aa0f2e@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <90f3eee6-ddec-74a9-e9d0-568aa3e0fdc9@linux.alibaba.com>
Date:   Tue, 3 Mar 2020 21:11:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1c4ff425-a5a9-1e5a-a07c-24c8f3aa0f2e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 3/2/20 8:24 AM, Jens Axboe wrote:
>> On 3/2/20 7:05 AM, Jens Axboe wrote:
>>> On 3/1/20 9:18 PM, Xiaoguang Wang wrote:
>>>> When user applis programming mode, like sumbit one sqe and wait its
>>>> completion event, __io_uring_get_cqe() will result in many unnecessary
>>>> syscalls, see below test program:
>>>>
>>>>      int main(int argc, char *argv[])
>>>>      {
>>>>              struct io_uring ring;
>>>>              int fd, ret;
>>>>              struct io_uring_sqe *sqe;
>>>>              struct io_uring_cqe *cqe;
>>>>              struct iovec iov;
>>>>              off_t offset, filesize = 0;
>>>>              void *buf;
>>>>
>>>>              if (argc < 2) {
>>>>                      printf("%s: file\n", argv[0]);
>>>>                      return 1;
>>>>              }
>>>>
>>>>              ret = io_uring_queue_init(4, &ring, 0);
>>>>              if (ret < 0) {
>>>>                      fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>>>>                      return 1;
>>>>              }
>>>>
>>>>              fd = open(argv[1], O_RDONLY | O_DIRECT);
>>>>              if (fd < 0) {
>>>>                      perror("open");
>>>>                      return 1;
>>>>              }
>>>>
>>>>              if (posix_memalign(&buf, 4096, 4096))
>>>>                      return 1;
>>>>              iov.iov_base = buf;
>>>>              iov.iov_len = 4096;
>>>>
>>>>              offset = 0;
>>>>              do {
>>>>                      sqe = io_uring_get_sqe(&ring);
>>>>                      if (!sqe) {
>>>>                              printf("here\n");
>>>>                              break;
>>>>                      }
>>>>                      io_uring_prep_readv(sqe, fd, &iov, 1, offset);
>>>>
>>>>                      ret = io_uring_submit(&ring);
>>>>                      if (ret < 0) {
>>>>                              fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>>>>                              return 1;
>>>>                      }
>>>>
>>>>                      ret = io_uring_wait_cqe(&ring, &cqe);
>>>>                      if (ret < 0) {
>>>>                              fprintf(stderr, "io_uring_wait_cqe: %s\n", strerror(-ret));
>>>>                              return 1;
>>>>                      }
>>>>
>>>>                      if (cqe->res <= 0) {
>>>>                              if (cqe->res < 0) {
>>>>                                      fprintf(stderr, "got eror: %d\n", cqe->res);
>>>>                                      ret = 1;
>>>>                              }
>>>>                              io_uring_cqe_seen(&ring, cqe);
>>>>                              break;
>>>>                      }
>>>>                      offset += cqe->res;
>>>>                      filesize += cqe->res;
>>>>                      io_uring_cqe_seen(&ring, cqe);
>>>>              } while (1);
>>>>
>>>>              printf("filesize: %ld\n", filesize);
>>>>              close(fd);
>>>>              io_uring_queue_exit(&ring);
>>>>              return 0;
>>>>      }
>>>>
>>>> dd if=/dev/zero of=testfile bs=4096 count=16
>>>> ./test  testfile
>>>> and use bpftrace to trace io_uring_enter syscalls, in original codes,
>>>> [lege@localhost ~]$ sudo bpftrace -e "tracepoint:syscalls:sys_enter_io_uring_enter {@c[tid] = count();}"
>>>> Attaching 1 probe...
>>>> @c[11184]: 49
>>>> Above test issues 49 syscalls, it's counterintuitive. After looking
>>>> into the codes, it's because __io_uring_get_cqe issue one more syscall,
>>>> indded when __io_uring_get_cqe issues the first syscall, one cqe should
>>>> already be ready, we don't need to wait again.
>>>>
>>>> To fix this issue, after the first syscall, set wait_nr to be zero, with
>>>> tihs patch, bpftrace shows the number of io_uring_enter syscall is 33.
>>>
>>> Thanks, that's a nice fix, we definitely don't want to be doing
>>> 50% more system calls than we have to...
>>
>> Actually, don't think the fix is quite safe. For one, if we get an error
>> on the __io_uring_enter(), then we may not have waited for entries. Or if
>> we submitted less than we thought we would, we would not have waited
>> either. So we need to check for full success before deeming it safe to
>> clear wait_nr.
> 
> Unrelated fix:
> 
> https://git.kernel.dk/cgit/liburing/commit/?id=0edcef5700fd558d2548532e0e5db26cb74d19ca
> 
> and then a fix for your patch on top:
> 
> https://git.kernel.dk/cgit/liburing/commit/?id=dc14e30a086082b6aebc3130948e2453e3bd3b2a
> 
> Can you double check that your original test case still produces the
> same amount of system calls with the fix in place?
Yes, it still produces the same amount of system calls.
Thanks for explanation and right fix.

Regards,
Xiaoguang Wang
> 

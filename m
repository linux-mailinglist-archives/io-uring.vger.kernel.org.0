Return-Path: <io-uring+bounces-19-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A4A7DFA2C
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 19:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF1C1C20F48
	for <lists+io-uring@lfdr.de>; Thu,  2 Nov 2023 18:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4901D55D;
	Thu,  2 Nov 2023 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0115484
	for <io-uring@vger.kernel.org>; Thu,  2 Nov 2023 18:43:59 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A74128
	for <io-uring@vger.kernel.org>; Thu,  2 Nov 2023 11:43:57 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VvWmel4_1698950633;
Received: from 30.121.33.208(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0VvWmel4_1698950633)
          by smtp.aliyun-inc.com;
          Fri, 03 Nov 2023 02:43:54 +0800
Message-ID: <7feaba7c-b93c-a136-6438-1de365b5a02a@linux.alibaba.com>
Date: Fri, 3 Nov 2023 02:43:49 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Content-Language: en-US
From: Ferry Meng <mengferry@linux.alibaba.com>
Subject: Problem about sq->khead update and ring full judgement
To: io-uring@vger.kernel.org, axboe@kernel.dk
Cc: joseph.qi@linux.alibaba.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all:
     I'm using io_uring in a program, with SQPOLL feature enabled. The 
userspace program will actively count the queue status of urings, the 
programming model is similar to:
     {
         sqe = io_uring_get_sqe();
         if(sqe){
             /* prepare next request */
             queue_count++;
     }


     {
         cqe = io_uring_peek_cqe();
         if(cqe){
             queue_count--;
         }
     }

     In this way, maybe we can assume that " sq_ring_size - queue_count 
= sqe_left_we_can_alloc "?

     Userspace program will compare queue_count with io_uring's sq_size 
: if queue is not full ( queue_count < sq_size), it will try getting new 
sqe(means Initiating a new IO request).

     Now I'm currently coming into a situation where  I/O is very high 
—— Userspace program submit lots of sqes (around 2000) at the same time, 
meanwhile  sq_ring_size is 4096. In kernel, 
__io_sq_thread->io_submit_sqes(), I see that nr(to_submit) is also over 
2000.   At a point, a strange point comes out: Userspace program find 
sq_ring is not full, but Kernel(in fact liburing::io_uring_get_sqe) 
think sq_ring is full.

     After analyzing, I find the reason is: kernel update "sq->khead" 
after submitting "all" sqes. The running of my program is : Before 
kernel update khead, userspace program has received many cqes, causing 
queue_count-- . After decreasing queue_count, user-program thinks 
sq_ring is not full, and try to start new IO requeust. As sq->head is 
not updated, io_uring_get_sqe() returns NULL.

     My questions are:

     1. Is userspace 'queue_count' judgement reasonable? From 
'traditional' point of view, if we want to find sq_ring full or not, we 
can just use io_uring_get_sqe() to check. Maybe this discussion is 
similar to this issue in a way: https://github.com/axboe/liburing/issues/88

     2. I must confess that it's very strange that cqe's average 
receiving latency is shorter than the consumption time of sqe(Now it 
really happens and I'm trying to find why this happened, or it's a just 
some bug). Assuming this scenario is reasonable, it seems that we can 
update sq->khead more often to get higher throughput. When userspace 
gets more 'sensetive', it can send out more IO requests. And it won't 
cause much more overhead if kernel atomically update 'khead' 
a-little-bit more.






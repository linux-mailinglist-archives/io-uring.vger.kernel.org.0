Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CD91A7BD3
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 15:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502589AbgDNNJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 09:09:00 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56112 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730314AbgDNNI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 09:08:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TvX7Ca-_1586869733;
Received: from 30.5.112.143(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TvX7Ca-_1586869733)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Apr 2020 21:08:53 +0800
To:     io-uring@vger.kernel.org, "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Should io_sq_thread belongs to specific cpu, not io_uring instance
Message-ID: <16ed5a58-e011-97f3-0ed7-e57fa37cede1@linux.alibaba.com>
Date:   Tue, 14 Apr 2020 21:08:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi£¬

Currently we can create multiple io_uring instances which all have SQPOLL
enabled and make them run in the same cpu core by setting sq_thread_cpu
argument, but I think this behaviour maybe not efficient. Say we create two
io_uring instances, which both have sq_thread_cpu set to 1 and sq_thread_idle
set to 1000 milliseconds, there maybe such scene below:
   For example, in 0-1s time interval, io_uring instance0 has neither sqes
nor cqes, so it just busy waits for new sqes in 0-1s time interval, but
io_uring instance1 have work to do, submitting sqes or polling issued requests,
then io_uring instance0 will impact io_uring instance1. Of cource io_uring
instance1 may impact iouring instance0 as well, which is not efficient. I think
the complete disorder of multiple io_uring instances running in same cpu core is
not good.

How about we create one io_sq_thread for user specified cpu for multiple io_uring
instances which try to share this cpu core, that means this io_sq_thread does not
belong to specific io_uring instance, it belongs to specific cpu and will
handle requests from mulpile io_uring instance, see simple running flow:
   1, for cpu 1, now there are no io_uring instances bind to it, so do not create io_sq_thread
   2, io_uring instance1 is created and bind to cpu 1, then create cpu1's io_sq_thread
   3, io_sq_thread will handle io_uring instance1's requests
   4, io_uring instance2 is created and bind to cpu 1, since there are already an
      io_sq_thread for cpu 1, will not create an io_sq_thread for cpu1.
   5. now io_sq_thread in cpu1 will handle both io_uring instances' requests.

What do you think about it? Thanks.

Regards,
Xiaoguang Wang

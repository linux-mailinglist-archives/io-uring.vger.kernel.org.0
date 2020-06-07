Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D05B1F0AF9
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 13:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgFGLl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 07:41:29 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39129 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgFGLl3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 07:41:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-phZHG_1591530084;
Received: from 30.15.203.104(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-phZHG_1591530084)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Jun 2020 19:41:25 +0800
Subject: Re: [PATCH] io_uring: execute task_work_run() before dropping mm
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
 <a23f96f9-fbe8-8dba-a1cd-20a3f121d868@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <948c2d50-1b5a-27df-bda3-503d2f266405@linux.alibaba.com>
Date:   Sun, 7 Jun 2020 19:41:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a23f96f9-fbe8-8dba-a1cd-20a3f121d868@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/6/20 9:12 AM, Xiaoguang Wang wrote:
>> While testing io_uring in our internal kernel, note it's not upstream
>> kernel, we see below panic:
>> [  872.498723] x29: ffff00002d553cf0 x28: 0000000000000000
>> [  872.508973] x27: ffff807ef691a0e0 x26: 0000000000000000
>> [  872.519116] x25: 0000000000000000 x24: ffff0000090a7980
>> [  872.529184] x23: ffff000009272060 x22: 0000000100022b11
>> [  872.539144] x21: 0000000046aa5668 x20: ffff80bee8562b18
>> [  872.549000] x19: ffff80bee8562080 x18: 0000000000000000
>> [  872.558876] x17: 0000000000000000 x16: 0000000000000000
>> [  872.568976] x15: 0000000000000000 x14: 0000000000000000
>> [  872.578762] x13: 0000000000000000 x12: 0000000000000000
>> [  872.588474] x11: 0000000000000000 x10: 0000000000000c40
>> [  872.598324] x9 : ffff000008100c00 x8 : 000000007ffff000
>> [  872.608014] x7 : ffff80bee8562080 x6 : ffff80beea862d30
>> [  872.617709] x5 : 0000000000000000 x4 : ffff80beea862d48
>> [  872.627399] x3 : ffff80bee8562b18 x2 : 0000000000000000
>> [  872.637044] x1 : ffff0000090a7000 x0 : 0000000000208040
>> [  872.646575] Call trace:
>> [  872.653139]  task_numa_work+0x4c/0x310
>> [  872.660916]  task_work_run+0xb0/0xe0
>> [  872.668400]  io_sq_thread+0x164/0x388
>> [  872.675829]  kthread+0x108/0x138
>>
>> The reason is that once io_sq_thread has a valid mm, schedule subsystem
>> may call task_tick_numa() adding a task_numa_work() callback, which will
>> visit mm, then above panic will happen.>
>> To fix this bug, only call task_work_run() before dropping mm.
> 
> That's a bug outside of io_uring, you'll want to backport this patch
> from 5.7:
> 
> commit 18f855e574d9799a0e7489f8ae6fd8447d0dd74a
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue May 26 09:38:31 2020 -0600
> 
>      sched/fair: Don't NUMA balance for kthreadsThanks, it's a better fix than mine, will backport it.

Regards,
Xiaoguang Wang

> 
> 

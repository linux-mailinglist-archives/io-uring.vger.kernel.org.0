Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944944B5855
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348654AbiBNRSh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:18:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbiBNRSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:18:36 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C115488A9
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:18:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V4U-a8c_1644859101;
Received: from 192.168.31.207(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4U-a8c_1644859101)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 01:18:23 +0800
Message-ID: <19c981c2-95aa-b56a-2fea-7c5f4a886179@linux.alibaba.com>
Date:   Tue, 15 Feb 2022 01:18:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/3] decouple work_list protection from the big wqe->lock
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
 <43f8ca19-fa38-929b-88c8-cfff565fbb16@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <43f8ca19-fa38-929b-88c8-cfff565fbb16@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2/12/22 00:55, Jens Axboe wrote:
> On 2/6/22 2:52 AM, Hao Xu wrote:
>> wqe->lock is abused, it now protects acct->work_list, hash stuff,
>> nr_workers, wqe->free_list and so on. Lets first get the work_list out
>> of the wqe-lock mess by introduce a specific lock for work list. This
>> is the first step to solve the huge contension between work insertion
>> and work consumption.
>> good thing:
>>    - split locking for bound and unbound work list
>>    - reduce contension between work_list visit and (worker's)free_list.
>>
>> For the hash stuff, since there won't be a work with same file in both
>> bound and unbound work list, thus they won't visit same hash entry. it
>> works well to use the new lock to protect hash stuff.
>>
>> Results:
>> set max_unbound_worker = 4, test with echo-server:
>> nice -n -15 ./io_uring_echo_server -p 8081 -f -n 1000 -l 16
>> (-n connection, -l workload)
>> before this patch:
>> Samples: 2M of event 'cycles:ppp', Event count (approx.): 1239982111074
>> Overhead  Command          Shared Object         Symbol
>>    28.59%  iou-wrk-10021    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
>>     8.89%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
>>     6.20%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock
>>     2.45%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
>>     2.36%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
>>     2.29%  iou-wrk-10021    [kernel.vmlinux]      [k] io_worker_handle_work
>>     1.29%  io_uring_echo_s  [kernel.vmlinux]      [k] io_wqe_enqueue
>>     1.06%  iou-wrk-10021    [kernel.vmlinux]      [k] io_wqe_worker
>>     1.06%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
>>     1.03%  iou-wrk-10021    [kernel.vmlinux]      [k] __schedule
>>     0.99%  iou-wrk-10021    [kernel.vmlinux]      [k] tcp_sendmsg_locked
>>
>> with this patch:
>> Samples: 1M of event 'cycles:ppp', Event count (approx.): 708446691943
>> Overhead  Command          Shared Object         Symbol
>>    16.86%  iou-wrk-10893    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
>>     9.10%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock
>>     4.53%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
>>     2.87%  iou-wrk-10893    [kernel.vmlinux]      [k] io_worker_handle_work
>>     2.57%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
>>     2.56%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
>>     1.82%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
>>     1.33%  iou-wrk-10893    [kernel.vmlinux]      [k] io_wqe_worker
>>     1.26%  io_uring_echo_s  [kernel.vmlinux]      [k] try_to_wake_up
>>
>> spin_lock failure from 25.59% + 8.89% =  34.48% to 16.86% + 4.53% = 21.39%
>> TPS is similar, while cpu usage is from almost 400% to 350%
> I think this looks like a good start to improving the io-wq locking. I
> didnt spot anything immediately wrong with the series, my only worker
> was worker->flags protection, but I _think_ that looks OK to in terms of
> the worker itself doing the manipulations.

Yes, I went over the code  to make sure worker->flags is manipulated by 
the worker

itself when doing coding.


Regards,

Hao

>
> Let's queue this up for 5.18 testing, thanks!
>

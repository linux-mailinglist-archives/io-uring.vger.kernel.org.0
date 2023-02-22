Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F9569F630
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjBVONe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVONd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:13:33 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FB7303F8;
        Wed, 22 Feb 2023 06:13:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VcHE1wA_1677075207;
Received: from 30.221.149.207(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcHE1wA_1677075207)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 22:13:27 +0800
Message-ID: <fb36c119-87ec-a265-314c-bf6fc2f7964f@linux.alibaba.com>
Date:   Wed, 22 Feb 2023 22:13:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC 3/3] ublk_drv: add ebpf support
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
 <20230215004122.28917-4-xiaoguang.wang@linux.alibaba.com>
 <Y+3lOn04pdFtdGbr@T590>
 <54043113-e524-6ca2-ce77-08d45099aff2@linux.alibaba.com>
 <Y+7uNpw7QBpJ4GHA@T590>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <Y+7uNpw7QBpJ4GHA@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

I spent some time to write v2, especially think about how to work
around task_work_add is not exported, so sorry for late response.
>
>>> The above is for setting up target io parameter, which is supposed
>>> to be from userspace, cause it is result of user space logic. If
>>> these parameters are from kernel, the whole logic has to be done
>>> in io_prep_prog.
>> Yeah, it's designed that io_prep_prog implements user space
>> io logic.
> That could be the biggest weakness of this approach, because people
> really want to implement complicated logic in userspace, which should
> be the biggest value of ublk, but now seems you move kernel C
> programming into ebpf userspace programming, I don't think ebpf
> is good at handling complicated userspace logic.
Absolutely agree with you, ebpf has strict programming rules,
I spent more time than I had thought at startup for support loop
target ebpf prog(ublk.bpf.c). Later I'll try to collaborate with my
colleagues, to see whether we can program their userspace logic
into ebpf prog or partially.
 
>> io_prep_prog is called when ublk_queue_rq() is called, this bpf
>> prog will initialize one or more sqes according to user logic, and
>> io_prep_prog will put these sqes in an ebpf map structure, then
>> execute a task_work_add() to notify ubq_daemon to execute
>> io_submit_prog. Note, we can not call io_uring_submit_sqe()
>> in task context that calls ublk_queue_rq(), that context does not
>> have io_uring instance owned by ubq_daemon.
>> Later ubq_daemon will call io_submit_prog to submit sqes.
> Submitting sqe from kernel looks interesting, but I guess
> performance may be hurt, given plugging(batching) can't be applied
> any more, which is supposed to affect io perf a lot.
Yes, agree, but I didn't have much time to improve this yet.
Currently, I mainly try to use this feature on large ios, to
reduce memory copy overhead, which consumes much
cpu resource, our clients really hope we can reduce it.

Regards,
Xiaoguang Wang

>
>
>
> Thanks,
> Ming


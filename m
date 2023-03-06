Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931936AB87D
	for <lists+io-uring@lfdr.de>; Mon,  6 Mar 2023 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCFIjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Mar 2023 03:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFIjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Mar 2023 03:39:10 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F23F1CF41
        for <io-uring@vger.kernel.org>; Mon,  6 Mar 2023 00:39:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VdDPTSs_1678091945;
Received: from 30.82.254.66(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VdDPTSs_1678091945)
          by smtp.aliyun-inc.com;
          Mon, 06 Mar 2023 16:39:06 +0800
Message-ID: <cd73d991-8c0b-847a-5d3d-42f21ec7b073@linux.alibaba.com>
Date:   Mon, 6 Mar 2023 16:39:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC v2 2/3] io_uring: add fixed poll support
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
 <20211028122850.13025-2-xiaoguang.wang@linux.alibaba.com>
 <0ca484de-0af1-b506-5ded-fa125bee1bcb@kernel.dk>
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <0ca484de-0af1-b506-5ded-fa125bee1bcb@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 10/28/21 6:28?AM, Xiaoguang Wang wrote:
>> Recently I spend time to research io_uring's fast-poll and multi-shot's
>> performance using network echo-server model. Previously I always thought
>> fast-poll is better than multi-shot and will give better performance,
>> but indeed multi-shot is almost always better than fast-poll in real
>> test, which is very interesting. I use ebpf to have some measurements,
>> it shows that whether fast-poll is excellent or not depends entirely on
>> that the first nowait try in io_issue_sqe() succeeds or fails. Take
>> io_recv operation as example(recv buffer is 16 bytes):
>>   1) the first nowait succeeds, a simple io_recv() is enough.
>> In my test machine, successful io_recv() consumes 1110ns averagely.
>>
>>   2) the first nowait fails, then we'll have some expensive work, which
>> contains failed io_revc(), apoll allocations, vfs_poll(), miscellaneous
>> initializations anc check in __io_arm_poll_handler() and a final
>> successful io_recv(). Among then:
>>     failed io_revc() consumes 620ns averagely.
>>     vfs_poll() consumes 550ns averagely.
>> I don't measure other overhead yet, but we can see if the first nowait
>> try fails, we'll need at least 2290ns(620 + 550 + 1110) to complete it.
>> In my echo server tests, 40% of first nowait io_recv() operations fails.
>>
>> From above measurements, it can explain why mulit-shot is better than
>> multi-shot, mulit-shot can ensure the first nowait try succeed.
>>
>> Based on above measurements, I try to improve fast-poll a bit:
>> Introduce fix poll support, currently it only works in file registered
>> mode. With this feature, we can get rid of various repeated operations
>> in io_arm_poll_handler(), contains apoll allocations, and miscellaneous
>> initializations anc check.
> I was toying with an idea on how to do persistent poll support,
> basically moving the wait_queue_entry out of io_poll and hence detaching
> it from the io_kiocb. That would allow a per-file (and type) poll entry
> to remain persistent in the kernel rather than needing to do this
> expensive work repeatedly. Pavel kindly reminded me of your work, which
> unfortunately I had totally forgotten.
>
> Did you end up taking this further? My idea was to make it work
> independently of fixed files, but I also don't want to reinvent the
> wheel if you ended up with something like this.
I haven't continued to work on this work since last patch set and
currently I don't have time for myself to continue working on this
job, sorry. It'll be great if we can add similar fixed poll for fast-poll
feature, or if we can eliminate the possible failed first no-wait submit
overhead. Recently, aone of our clients also wants to use asio(with
io_uring enabled), seems that asio(use io_uring fast-poll) does not
perform better than asio(epoll), I need to figure that out firstly.

asio: https://github.com/chriskohlhoff/asio.git


Regards,
Xiaoguang Wang
>


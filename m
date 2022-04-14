Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29477500C16
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 13:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbiDNLZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 07:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiDNLZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 07:25:33 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919C88594F
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 04:23:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VA2KpuH_1649935385;
Received: from 30.225.28.188(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VA2KpuH_1649935385)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Apr 2022 19:23:06 +0800
Message-ID: <b7351b4e-e8b7-11ba-a892-fe36a41df99d@linux.alibaba.com>
Date:   Thu, 14 Apr 2022 19:23:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: questions about io_uring buffer select feature
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <c5382b9e-2a15-c6e9-59c1-48e7b40e5487@linux.alibaba.com>
 <ec3c4d65-b677-53ce-bb6c-3ebe51340777@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <ec3c4d65-b677-53ce-bb6c-3ebe51340777@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 4/14/22 08:41, Xiaoguang Wang wrote:
>> hi,
>>
>> I spent some time to learn the history of buffer select feature, especially
>> from https://lwn.net/Articles/813311/. According to the description in this
>> link:
>>      when doing the same IORING_OP_RECV, no buffer is passed in
>>      with the request. Instead, it's flagged with IOSQE_BUFFER_SELECT, and
>>      sqe->buf_group is filled in with a valid group ID. When the kernel can
>>      satisfy the receive, a buffer is selected from the specified group ID
>>      pool. If none are available, the IO is terminated with -ENOBUFS. On
>>      success, the buffer ID is passed back through the (CQE) completion
>>      event. This tells the application what specific buffer was used.
>>
>> According to my understandings, buffer select feature is suggested to be
>> used with fast-poll feature, then in example of io_read(), for the first nowait
>> try, io_read() will always get one io_buffer even later there is no data
>> ready, eagain is returned and this req will enter io_arm_poll_handler().
>> So it seems that this behaviour violates the rule that buffer is only selected
>> when data is ready?
>
> Right, that's how it was working, but recently Jens was queueing
> patches to fix it, e.g. see io_kbuf_recycle(). I think it was
> for 5.18.
I see now, thanks for clarification.

>
>> And for ENOBUFS error, how should apps handle this error? Re-provide
>> buffers and re-issue requests from user space again? Thanks.
>
> It sounds just right. If the userspace can't re-provide buffers,
> I assume it may want to wait for some inflight requests to complete.
ok.

Regards,
Xiaoguang Wang


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279FD4BD56B
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 06:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbiBUFZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 00:25:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344500AbiBUFZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 00:25:56 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C0313CD5;
        Sun, 20 Feb 2022 21:25:33 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V5.86ZF_1645421130;
Received: from 30.225.24.181(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5.86ZF_1645421130)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 13:25:31 +0800
Message-ID: <96ad477e-138b-b588-3017-8b60dd9443f1@linux.alibaba.com>
Date:   Mon, 21 Feb 2022 13:25:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
 <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
 <f070354c-b65b-f8b3-e597-2e756bcfa705@kernel.dk>
 <b674472d8c52a84002908e2248fd81ce11247569.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <b674472d8c52a84002908e2248fd81ce11247569.camel@trillion01.com>
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

在 2022/2/21 上午2:37, Olivier Langlois 写道:
> On Sat, 2022-02-19 at 17:22 -0700, Jens Axboe wrote:
>>
>> Outside of this, I was hoping to see some performance numbers in the
>> main patch. Sounds like you have them, can you share?
>>
> Yes.
> 
> It is not much. Only numbers from my application and it is far from
> being the best benchmark because the result can be influenced by
> multiple external factors.
> 
> Beside addressing the race condition remaining inside io_cqring_wait()
> around napi_list for v2 patch, creating a benchmark program that
> isolate the performance of the new feature is on my todo list.
> 
> I would think that creating a simple UDP ping-pong setup and measure

An echo-server may be a good choice.
> RTT with and without busy_polling should be a good enough test.
> 
> In the meantime, here are the results that I have:
> 
> Without io_uring busy poll:
> reaction time to an update: 17159usec
> reaction time to an update: 19068usec
> reaction time to an update: 23055usec
> reaction time to an update: 16511usec
> reaction time to an update: 17604usec
> 
> With io_uring busy poll:
> reaction time to an update: 15782usec
> reaction time to an update: 15337usec
> reaction time to an update: 15379usec
> reaction time to an update: 15275usec
> reaction time to an update: 15107usec
> 
> Concerning my latency issue with busy polling, I have found this that
> might help me:
> https://lwn.net/ml/netdev/20201002222514.1159492-1-weiwan@google.com/


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE884AE844
	for <lists+io-uring@lfdr.de>; Wed,  9 Feb 2022 05:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346093AbiBIEIB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Feb 2022 23:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347371AbiBIDnz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Feb 2022 22:43:55 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B244C0401C1
        for <io-uring@vger.kernel.org>; Tue,  8 Feb 2022 19:34:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V3z8WNq_1644377644;
Received: from 30.225.24.82(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V3z8WNq_1644377644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 11:34:05 +0800
Message-ID: <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 11:34:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: napi_busy_poll
To:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
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

在 2022/2/9 上午1:05, Jens Axboe 写道:
> On 2/8/22 7:58 AM, Olivier Langlois wrote:
>> Hi,
>>
>> I was wondering if integrating the NAPI busy poll for socket fds into
>> io_uring like how select/poll/epoll are doing has ever been considered?
>>
>> It seems to me that it could be an awesome feature when used along with
>> a io_qpoll thread and something not too difficult to add...
> 
> Should be totally doable and it's been brought up before, just needs
> someone to actually do it... Would love to see it.
> 
We've done some investigation before, would like to have a try.

Regards,
Hao


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013B96A14E4
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 03:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjBXCZp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 21:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBXCZp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 21:25:45 -0500
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFED5E875;
        Thu, 23 Feb 2023 18:25:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VcMIeW7_1677205538;
Received: from 30.221.148.141(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VcMIeW7_1677205538)
          by smtp.aliyun-inc.com;
          Fri, 24 Feb 2023 10:25:39 +0800
Message-ID: <084ea730-a3a1-4dff-ecb5-d45a0af82e97@linux.alibaba.com>
Date:   Fri, 24 Feb 2023 10:25:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH tools/io_uring] tools/io_uring: correctly set "ret" for
 sq_poll case
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        asml.silence@gmail.com
References: <20230221073736.628851-1-ZiyangZhang@linux.alibaba.com>
 <55a01e39-c28c-dde0-172c-feee378c2f74@kernel.dk>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <55a01e39-c28c-dde0-172c-feee378c2f74@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/2/23 11:46, Jens Axboe wrote:
> On 2/21/23 12:37?AM, Ziyang Zhang wrote:
>> For sq_poll case, "ret" is not initialized or cleared/set. In this way,
>> output of this test program is incorrect and we can not even stop this
>> program by pressing CTRL-C.
>>
>> Reset "ret" to zero in each submission/completion round, and assign
>> "ret" to "this_reap".
> 
> Can you check if this issue also exists in the fio copy of this, which
> is t/io_uring.c in:
> 
> git://git.kernel.dk/fio
> 
> The copy in the kernel is pretty outdated at this point, and should
> probably get removed. But if the bug is in the above main version, then
> we should fix it there and then ponder if we want to remove the one in
> the kernel or just get it updated to match the upstream version.
> 

Hi Jens,

I have checked t/io_uring.c and the code is correct with sq_poll.

Regards,
Zhang

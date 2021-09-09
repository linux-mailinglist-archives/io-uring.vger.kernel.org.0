Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE1C4055D4
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355621AbhIINN6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 09:13:58 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:48201 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355494AbhIINB7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 09:01:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnnZGPn_1631192447;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnnZGPn_1631192447)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 21:00:48 +0800
Subject: Re: [PATCH] io-wq: fix memory leak in create_io_worker()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210909040507.82711-1-haoxu@linux.alibaba.com>
 <d3351ea9-5389-1cd9-ba11-5df4c030f87b@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <574bb7cd-c0e4-14d3-8afa-2f892a7b78bd@linux.alibaba.com>
Date:   Thu, 9 Sep 2021 21:00:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d3351ea9-5389-1cd9-ba11-5df4c030f87b@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/9 下午8:57, Jens Axboe 写道:
> On 9/8/21 10:05 PM, Hao Xu wrote:
>> We should free memory the variable worker point to in fail path.
> 
> I think this one is missing a few paths where it can also happen, once
> punted.
True. I browse the code again and I think Qiang.zhang's patch should be
fine.
> 


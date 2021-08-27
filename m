Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860BC3F9D34
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 19:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhH0RFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 13:05:46 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:35153 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhH0RFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 13:05:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UmI3UiN_1630083895;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmI3UiN_1630083895)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Aug 2021 01:04:55 +0800
Subject: Re: [PATCH for-5.15 v3 0/2] fix failed linkchain code logic
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210827094609.36052-1-haoxu@linux.alibaba.com>
 <40dee78d-1283-1067-cc7b-94b493eb2150@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <180ec124-79b1-2274-4570-9b0d6620d512@linux.alibaba.com>
Date:   Sat, 28 Aug 2021 01:04:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <40dee78d-1283-1067-cc7b-94b493eb2150@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/27 下午9:27, Jens Axboe 写道:
> On 8/27/21 3:46 AM, Hao Xu wrote:
>> the first patch is code clean.
>> the second is the main one, which refactors linkchain failure path to
>> fix a problem, detail in the commit message.
> 
> Thanks for pulling this one to completion - applied!
> 
sorry for the delay.

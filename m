Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01368305ADB
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 13:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhA0MHY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 07:07:24 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:46356 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237617AbhA0MFD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 07:05:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UN2JKHS_1611749047;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UN2JKHS_1611749047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Jan 2021 20:04:08 +0800
Subject: Re: [PATCH liburing] test: use a map to define test files / devices
 we need
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1607430489-10020-1-git-send-email-haoxu@linux.alibaba.com>
 <12018281-f8d4-7a67-3ffc-49d6a1c721b8@linux.alibaba.com>
 <87b3001f-0984-3890-269b-1a069704e374@linux.alibaba.com>
 <81cf9b02-a6e6-6b9e-3053-a5a34d3cffb6@linux.alibaba.com>
 <fecb3d93-1dba-8c81-f835-1fa9a98042f0@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <f0c21066-0b99-d477-3f0b-4307233d9cae@linux.alibaba.com>
Date:   Wed, 27 Jan 2021 20:04:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <fecb3d93-1dba-8c81-f835-1fa9a98042f0@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/1/27 上午1:59, Jens Axboe 写道:
> On 1/25/21 11:18 PM, Hao Xu wrote:
>> 在 2020/12/22 上午11:03, Hao Xu 写道:
>>> 在 2020/12/15 上午10:44, Hao Xu 写道:
>>>> 在 2020/12/8 下午8:28, Hao Xu 写道:
>>>> ping...
>>> Hi Jens,
>>> I'm currently develop a test which need a device arg, so I
>>> leverage TEST_FILES, I found it may be better to form
>>> TEST_FILES as a key-value structure.
>>> Thanks && Regards,
>>> Hao
>> ping again..
> 
> Sorry about the delay - I have applied it, thanks.
> 
No worries. Thanks, Jens.

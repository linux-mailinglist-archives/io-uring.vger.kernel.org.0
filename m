Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5CF2ACB25
	for <lists+io-uring@lfdr.de>; Tue, 10 Nov 2020 03:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKJCc5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 21:32:57 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:42384 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbgKJCc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 21:32:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UEpi4qw_1604975575;
Received: from 30.225.32.17(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UEpi4qw_1604975575)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 10:32:55 +0800
Subject: Re: [PATCH v2 0/2] improve SQPOLL handling
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201103061600.11053-1-xiaoguang.wang@linux.alibaba.com>
 <71e21e18-69f6-fe24-2a13-1b8269d72393@linux.alibaba.com>
 <82e42f8a-7f97-4016-ba55-1f460defef26@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <2d85d28f-eb01-75b2-5615-450945079692@linux.alibaba.com>
Date:   Tue, 10 Nov 2020 10:31:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <82e42f8a-7f97-4016-ba55-1f460defef26@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 11/8/20 7:16 AM, Xiaoguang Wang wrote:
>> hi,
>>
>> A gentle reminder. How does this patch set look now?
>> I think the first patch looks ok at least.
> 
> I have applied 1/2 for now, I agree that one looks fine and should get
> applied. I'll go over 2/2 soonish.
Thanks :)

Regards,
Xiaoguang Wang

> 

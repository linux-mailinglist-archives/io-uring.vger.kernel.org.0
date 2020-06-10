Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5763D1F53A0
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 13:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgFJLjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 07:39:17 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46822 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728510AbgFJLjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 07:39:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.AkAuE_1591789154;
Received: from 30.225.32.170(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.AkAuE_1591789154)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Jun 2020 19:39:15 +0800
Subject: Re: [PATCH v6 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
 <c4f10448-0199-85d3-3ab5-b5931dad00f0@gmail.com>
 <3803a578-a13c-07e7-37f1-fee691dd888f@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <4d5b9706-9abf-55c4-1f01-d87d536e5b45@linux.alibaba.com>
Date:   Wed, 10 Jun 2020 19:39:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3803a578-a13c-07e7-37f1-fee691dd888f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/9/20 10:44 AM, Pavel Begunkov wrote:
>> On 09/06/2020 11:25, Xiaoguang Wang wrote:
>>> If requests can be submitted and completed inline, we don't need to
>>> initialize whole io_wq_work in io_init_req(), which is an expensive
>>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>>> io_wq_work is initialized.
>>
>> Basically it's "call io_req_init_async() before touching ->work" now.
>> This shouldn't be as easy to screw as was with ->func.
>>
>> The only thing left that I don't like _too_ much to stop complaining
>> is ->creds handling. But this one should be easy, see incremental diff
>> below (not tested). If custom creds are provided, it initialises
>> req->work in req_init() and sets work.creds. And then we can remove
>> req->creds.
>>
>> What do you think? Custom ->creds (aka personality) is a niche feature,
>> and the speedup is not so great to care.
> 
> Thanks for reviewing, I agree. Xiaoguang, care to fold in that change
> and then I think we're good to shove this in.
Yeah, I'll send new version soon.
Pavel, thanks for your great work, and really appreciate both of you and jens' patience.

Regards,
Xiaoguang Wang
> 

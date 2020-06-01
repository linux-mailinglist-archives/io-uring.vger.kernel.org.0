Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7F1EA315
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 13:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgFALux (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 07:50:53 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52868 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgFALux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 07:50:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-F57jA_1591012250;
Received: from 30.225.32.149(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-F57jA_1591012250)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Jun 2020 19:50:51 +0800
Subject: Re: [PATCH v4 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
 <8c361177-c0b0-b08c-e0a5-141f7fd948f0@kernel.dk>
 <e2040210-ab73-e82b-50ea-cdeb88c69157@kernel.dk>
 <27e264ec-2707-495f-3d24-4e9e20b86032@kernel.dk>
 <32d0768e-f7d7-1281-e9ff-e95329db9dc5@linux.alibaba.com>
 <94ed2ba3-0209-d3a1-c5f0-dc45493f4505@linux.alibaba.com>
 <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <4de0ccd2-249f-26af-d815-6dba1b86b25a@linux.alibaba.com>
 <360f970a-0984-f452-1ff0-c31988a3e4ec@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <1e3224fe-73da-f12a-f094-74346a5a94ec@linux.alibaba.com>
Date:   Mon, 1 Jun 2020 19:50:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <360f970a-0984-f452-1ff0-c31988a3e4ec@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 31/05/2020 19:15, Xiaoguang Wang wrote:
>> In the begin of __io_splice_prep or io_close_prep, current io_uring mainline codes will
>> modify req->work.flags firstly, so we need to call io_req_init_async to initialize
>> io_wq_work before the work.flags modification.
>> For below codes:
>> static inline void io_req_init_async(struct io_kiocb *req,
>>                          void (*func)(struct io_wq_work **))
>> {
>>          if (req->flags & REQ_F_WORK_INITIALIZED) {
>>                  if (!req->work.func)
>>                          req->work.func = func;
>>          } else {
>>                  req->work = (struct io_wq_work){ .func = func };
>>                  req->flags |= REQ_F_WORK_INITIALIZED;
>>          }
>> }
>>
>> if we not pass NULL to parameter 'func', e.g. pass io_wq_submit_work, then
>> we can not use io_req_init_async() to pass io_close_finish again.
> 
> It's not as bad, just the thing you poked is overused and don't have strict rules.
> I have a feeling, that for it to be done right it'd need more fundamental refactoring
> with putting everything related to ->work closer to io_queue_async_work().
Yes, I totally agree with you, that would be safer.

Regards,
Xiaoguang Wang

> 
>>
>> Now I'm confused how to write better codes based on current io_uring mainline codes :)
>> If you have some free time, please have a deeper look, thanks.
> 

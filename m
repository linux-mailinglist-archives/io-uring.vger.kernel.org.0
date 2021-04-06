Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE4354AD0
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 04:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbhDFCSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 22:18:10 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42405 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238828AbhDFCSJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 22:18:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUeS7Ym_1617675481;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUeS7Ym_1617675481)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 06 Apr 2021 10:18:01 +0800
Subject: Re: [PATCH v3] io-wq: simplify code in __io_worker_busy
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <7f078f30-d60f-2b19-7933-f1ccba8e7282@kernel.dk>
 <1617609210-227185-1-git-send-email-haoxu@linux.alibaba.com>
 <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4f9dc45f-b04d-277f-643a-edb145f6191a@linux.alibaba.com>
Date:   Tue, 6 Apr 2021 10:18:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/6 上午5:46, Jens Axboe 写道:
> On 4/5/21 1:53 AM, Hao Xu wrote:
>> leverage xor to simplify code in __io_worker_busy
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 17 +++++++----------
>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 433c4d3c3c1c..8d8324eba2ec 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -276,10 +276,12 @@ static void io_wqe_dec_running(struct io_worker *worker)
>>    */
>>   static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
>>   			     struct io_wq_work *work)
>> -	__must_hold(wqe->lock)
>> +	__must_hold(w qe->lock)
> 
> Looks like something is off there? I see a v2 as well, but this one is
> later, so...
> 
v2 is sent before I saw your comment, actully both v2 and v3 make sense
for me, but now I prefer v3.

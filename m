Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0B2ACB7D
	for <lists+io-uring@lfdr.de>; Tue, 10 Nov 2020 04:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgKJDGE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 22:06:04 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:50452 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728607AbgKJDGE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 22:06:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UEpi9pn_1604977561;
Received: from 30.225.32.17(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UEpi9pn_1604977561)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Nov 2020 11:06:01 +0800
Subject: Re: [PATCH] io_uring: don't take percpu_ref operations for registered
 files in IOPOLL mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200902050538.8350-1-xiaoguang.wang@linux.alibaba.com>
 <2eb73693-9c40-d657-b822-548ddd92b875@linux.alibaba.com>
 <764234cf-ab08-7ccf-f4b6-b0a2f5ae6cbc@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <c6089492-9280-ab24-e333-4a752b108353@linux.alibaba.com>
Date:   Tue, 10 Nov 2020 11:04:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <764234cf-ab08-7ccf-f4b6-b0a2f5ae6cbc@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 11/4/20 8:20 PM, Xiaoguang Wang wrote:
>> hi,
>>
>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>> light-weight synchronization primitives, especially in arm platform. In one
>>> our arm machine, I get below perf data(registered files enabled):
>>> Samples: 98K of event 'cycles:ppp', Event count (approx.): 63789396810
>>> Overhead  Command      Shared Object     Symbol
>>>      ...
>>>      0.78%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
>>> There is an obvious overhead that can not be ignored.
>>>
>>> Currently I don't find any good and generic solution for this issue, but
>>> in IOPOLL mode, given that we can always ensure get/put registered files
>>> under uring_lock, we can use a simple and plain u64 counter to synchronize
>>> with registered files update operations in __io_sqe_files_update().
>>>
>>> With this patch, perf data show shows:
>>> Samples: 104K of event 'cycles:ppp', Event count (approx.): 67478249890
>>> Overhead  Command      Shared Object     Symbol
>>>      ...
>>>      0.27%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
>> The above %0.78 => %0.27 improvements are observed in arm machine with
>> 4.19 kernel. In upstream mainline codes, since this patch
>> "2b0d3d3e4fcf percpu_ref: reduce memory footprint of percpu_ref in
>> fast path", I believe the io_file_get's overhead would be further
>> smaller. I have same tests in same machine, in upstream codes with my
>> patch, now the io_file_get's overhead is %0.44.
>>
>> This patch's idea is simple, and now seems it only gives minor
>> performance improvement, do you have any comments about this patch,
>> should I continue re-send it?
> 
> Can you resend it against for-5.11/io_uring? Looks simple enough to me,
> and it's a nice little win.Thanks, I'll prepare V2 soon.

Regards,
Xiaoguang Wang
> 

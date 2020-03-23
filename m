Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB95918FA43
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCWQpO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 12:45:14 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28844 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727230AbgCWQpN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 12:45:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TtRQlrK_1584981901;
Received: from 30.39.205.252(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TtRQlrK_1584981901)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Mar 2020 00:45:01 +0800
Subject: Re: [PATCH] io_uring: refacor file register/unregister/update based
 on sequence
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200323115036.6539-1-xiaoguang.wang@linux.alibaba.com>
 <bf9c7c16-76bb-7fd5-7190-63d8c6bb430a@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <eeafad2e-afb1-a548-90a2-e021afa00e69@linux.alibaba.com>
Date:   Tue, 24 Mar 2020 00:45:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <bf9c7c16-76bb-7fd5-7190-63d8c6bb430a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 3/23/20 5:50 AM, Xiaoguang Wang wrote:
>> While diving into iouring fileset resigster/unregister/update codes,
>> we found one bug in fileset update codes. Iouring fileset update codes
>> use a percpu_ref variable to check whether can put previous registered
>> file, only when the refcnt of the perfcpu_ref variable reachs zero, can
>> we safely put these files, but this do not work well. If applications
>> always issue requests continually, this perfcpu_ref will never have an
>> chance to reach zero, and it'll always be in atomic mode, also will
>> defeat the gains introduced by fileset register/unresiger/update feature,
>> which are used to reduce the atomic operation overhead of fput/fget.
>>
>> To fix this issue, we remove the percpu_ref related codes, and add two new
>> counter: sq_seq and cq_seq to struct io_ring_ctx:
>>      sq_seq: the most recent issued requset sequence number, which is
>>              protected uring_lock.
>>      cq_seq: the most recent completed request sequence number, which is
>>              protected completion_lock.
>>
>> When we update fileset(under uring_lock), we record the current sq_seq,
>> and when cq_seq is greater or equal to recorded sq_seq, we know we can
>> put previous registered file safely.
> 
> Maybe I'm misunderstanding the idea here, but what if you have the
> following:
> 
> - sq_seq 200, cq_seq 100
> 
> We have 100 inflight, and an unregister request comes in. I then
> issue 100 nops, which complete. cq_seq is now 200, but none of the
> original requests that used the file have completed.
> 
> What am I missing?
No, you're right. I had thought requests will be completed in the order
they are issued, thanks for pointing this.
As for not using per percpu_ref per registered file, I also worry about
the memory consume, because the max allowed registered files are 32768.

Regards,
Xiaoguang Wang

> 

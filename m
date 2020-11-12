Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1902B04FB
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 13:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgKLMdp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 07:33:45 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:34900 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbgKLMdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 07:33:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UF4wz7P_1605184422;
Received: from 30.225.32.243(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF4wz7P_1605184422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 20:33:43 +0800
Subject: Re: [PATCH 5.11 1/2] io_uring: initialize 'timeout' properly in
 io_sq_thread()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
References: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
 <20201112065600.8710-2-xiaoguang.wang@linux.alibaba.com>
 <20201112111519.ydrzwsvsbipotogr@steredhat>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <58c69d4a-64e5-b4f3-54e7-fae59a550cdb@linux.alibaba.com>
Date:   Thu, 12 Nov 2020 20:32:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201112111519.ydrzwsvsbipotogr@steredhat>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On Thu, Nov 12, 2020 at 02:55:59PM +0800, Xiaoguang Wang wrote:
>> Some static checker reports below warning:
>>    fs/io_uring.c:6939 io_sq_thread()
>>    error: uninitialized symbol 'timeout'.
>>
>> Fix it.
> 
> We can also add the reporter:
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Sorry, forgot to add it :)

> 
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>> fs/io_uring.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Thanks.

Regards,
Xiaoguang Wang
> 
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c1dcb22e2b76..c9b743be5328 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6921,7 +6921,7 @@ static int io_sq_thread(void *data)
>>     const struct cred *old_cred = NULL;
>>     struct io_sq_data *sqd = data;
>>     struct io_ring_ctx *ctx;
>> -    unsigned long timeout;
>> +    unsigned long timeout = 0;
>>     DEFINE_WAIT(wait);
>>
>>     task_lock(current);
>> -- 
>> 2.17.2
>>

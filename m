Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D40528F0DF
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 13:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgJOLZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 07:25:37 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:49748 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728364AbgJOLZZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 07:25:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UC69OAG_1602761121;
Received: from 30.225.32.25(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UC69OAG_1602761121)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Oct 2020 19:25:22 +0800
Subject: Re: [PATCH] io_uring: fix possible use after free to sqd
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
References: <20201015091335.1667-1-xiaoguang.wang@linux.alibaba.com>
 <20201015100142.k2uylzcwy6pu6vzw@steredhat>
 <840c002d-399b-92ba-cdc0-de17522fdbce@linux.alibaba.com>
 <20201015110707.r77jkzema4nmsvrf@steredhat>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <7dc05ac2-f3f6-bdcd-afde-46e4754c24cd@linux.alibaba.com>
Date:   Thu, 15 Oct 2020 19:24:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201015110707.r77jkzema4nmsvrf@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Thu, Oct 15, 2020 at 06:46:34PM +0800, Xiaoguang Wang wrote:
>> hi閿涳拷
>>
>>> On Thu, Oct 15, 2020 at 05:13:35PM +0800, Xiaoguang Wang wrote:
>>>> Reading codes finds a possible use after free issue to sqd:
>>>>             thread1              |       thread2
>>>> ==> io_attach_sq_data()        |
>>>> ===> sqd = ctx_attach->sq_data;|
>>>>                                  | ==> io_put_sq_data()
>>>>                                  | ===> refcount_dec_and_test(&sqd->refs)
>>>>                                  |     If sqd->refs is zero, will free sqd.
>>>>                                  |
>>>> ===> refcount_inc(&sqd->refs); |
>>>>                                  |
>>>>                                  | ====> kfree(sqd);
>>>> ===> now use after free to sqd |
>>>>
>>>
>>> IIUC the io_attach_sq_data() is called only during the setup of an
>>> io_uring context, before that the fd is returned to the user space.
>> Sorry I didn't make it clear in commit message.
>> In io_attach_sq_data(), we'll try to attach to a previous io_uring instance
>> indicated by p->wq_fd, this p->wq_fd could be closed independently.
> 
> Thanks to clarify! Got it.
> 
> Also in this case, IIUC io_put_sq_data() is called only when
> io_uring_release() is invoked on the previous io_uring instance.
> 
> Since we are taking a reference with fdget at the begin of io_attach_sq_data()
> and we release this reference only at the end of io_attach_sq_data(),
> can io_put_sq_data() runs in another thread while we have the reference?
Oh, right, thanks. Jens, you can ignore this patch, thanks.

Regards,
Xiaoguang Wang

> 
> Thanks,
> Stefano
> 
>>
>> Regards,
>> Xiaoguang Wang
>>>
>>> So, I'm not sure a second thread can call io_put_sq_data() while the
>>> first thread is in io_attach_sq_data().
>>>
>>> Can you check if this situation can really happen?
>>>
>>> Thanks,
>>> Stefano
>>>
>>>> Use refcount_inc_not_zero() to fix this issue.
>>>>
>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>> ---
>>>>    fs/io_uring.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 33b5cf18bb51..48e230feb704 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -6868,7 +6868,11 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
>>>>    		return ERR_PTR(-EINVAL);
>>>>    	}
>>>> -	refcount_inc(&sqd->refs);
>>>> +	if (!refcount_inc_not_zero(&sqd->refs)) {
>>>> +		fdput(f);
>>>> +		return ERR_PTR(-EINVAL);
>>>> +	}
>>>> +
>>>>    	fdput(f);
>>>>    	return sqd;
>>>>    }
>>>> -- 
>>>> 2.17.2
>>>>
>>

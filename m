Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18FC233D21
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 04:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgGaCNE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 22:13:04 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:51939 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730904AbgGaCND (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 22:13:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U4H-SRe_1596161579;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4H-SRe_1596161579)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Jul 2020 10:13:00 +0800
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
Date:   Fri, 31 Jul 2020 10:12:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2020/7/30 下午11:28, Jens Axboe wrote:
> On 7/29/20 8:32 PM, Jiufei Xue wrote:
>> Hi Jens,
>>
>> On 2020/7/30 上午1:51, Jens Axboe wrote:
>>> On 7/29/20 4:10 AM, Jiufei Xue wrote:
>>>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>>>> supported. Add two new interfaces: io_uring_wait_cqes2(),
>>>> io_uring_wait_cqe_timeout2() for applications to use this feature.
>>>
>>> Why add new new interfaces, when the old ones already pass in the
>>> timeout? Surely they could just use this new feature, instead of the
>>> internal timeout, if it's available?
>>>
>> Applications use the old one may not call io_uring_submit() because
>> io_uring_wait_cqes() will do it. So I considered to add a new one.
> 
> Not sure I see how that's a problem - previously, you could not do that
> either, if you were doing separate submit/complete threads. So this
> doesn't really add any new restrictions. The app can check for the
> feature flag to see if it's safe to do so now.
>Yes, new applications can check for the feature flag. What about the existing
apps? The existing applications which do not separate submit/complete
threads may use io_uring_wait_cqes() or io_uring_wait_cqe_timeout() without
submiting the requests. No one will do that now when the feature is supported.


>>>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>>>> index 0505a4f..6176a63 100644
>>>> --- a/src/include/liburing.h
>>>> +++ b/src/include/liburing.h
>>>> @@ -56,6 +56,7 @@ struct io_uring {
>>>>  	struct io_uring_sq sq;
>>>>  	struct io_uring_cq cq;
>>>>  	unsigned flags;
>>>> +	unsigned features;
>>>>  	int ring_fd;
>>>>  };
>>>
>>> This breaks the API, as it changes the size of the ring...
>>>
>> Oh, yes, I haven't considering that before. So could I add this feature
>> bit to io_uring.flags. Any suggestion?
> 
> Either that, or we add this (and add pad that we can use later) and just
> say that for the next release you have to re-compile against the lib.
> That will break existing applications, unless they are recompiled... But
> it might not be a bad idea to do so, just so we can pad io_uring out a
> little bit to provide for future flexibility.
>
Agree about that. So should we increase the major version after adding the
feature flag and some pad?

Thanks,
Jiufei

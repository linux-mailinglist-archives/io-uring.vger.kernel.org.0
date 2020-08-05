Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6656E23C4F2
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 07:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgHEFRU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 01:17:20 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50493 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgHEFRS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 01:17:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U4naRfZ_1596604635;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4naRfZ_1596604635)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Aug 2020 13:17:15 +0800
Subject: Re: [PATCH liburing v3 0/2] add support for new timeout feature
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <3CC9BEDE-0509-4EC7-948C-77746E40B531@eoitek.com>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <7efabc7f-a649-b0aa-ff3b-7cd6c9f450b7@linux.alibaba.com>
Date:   Wed, 5 Aug 2020 13:17:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3CC9BEDE-0509-4EC7-948C-77746E40B531@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2020/8/5 上午11:28, Carter Li 李通洲 wrote:
>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>> index 0505a4f..82c2980 100644
>> --- a/src/include/liburing.h
>> +++ b/src/include/liburing.h
>> @@ -56,6 +56,9 @@ struct io_uring {
>>  	struct io_uring_sq sq;
>>  	struct io_uring_cq cq;
>>  	unsigned flags;
>> +	unsigned flags_internal;
>> +	unsigned features;
>> +	unsigned pad[4];
>>  	int ring_fd;
>>  };
> 
> Won't it break existing code runs on newer kernel?

io_uring is a structure that used in userspace. It breaks the API
with existing compiled application. So I have changed the soname
to 2.0.7.

And for syscall io_uring_enter(), I have added a new feature bit
IORING_FEAT_GETEVENTS_TIMEOUT and io_uring_enter() flag
IORING_ENTER_GETEVENTS_TIMEOUT. Here are 3 cases below:

1) old liburing <-> new kernel: old liburing can not pass the flag
   IORING_ENTER_GETEVENTS_TIMEOUT, so new kernel will parse the arguments
   the original way.

2) new liburing <-> old kernel: feature IORING_FEAT_GETEVENTS_TIMEOUT
   not supported, liburing will do things like before.

3) new liburing <-> new kernel: feature IORING_FEAT_GETEVENTS_TIMEOUT
   supported, liburing pass the new arguments with the flag
   IORING_ENTER_GETEVENTS_TIMEOUT which helps kernel parse the arguments
   correctly.

Thanks,
Jiufei.

> Won't it break code compiled with new liburing but runs on older kernel?
> 

> IMO In this case, a new syscall `io_uring_setup2` is required at least.
> 
> Regards,
> Carter
> 

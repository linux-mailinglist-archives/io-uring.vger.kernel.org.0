Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E09232A13
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 04:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgG3Cca (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jul 2020 22:32:30 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55836 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgG3Cca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jul 2020 22:32:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U4C9fmu_1596076345;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4C9fmu_1596076345)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Jul 2020 10:32:25 +0800
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
Date:   Thu, 30 Jul 2020 10:32:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 2020/7/30 上午1:51, Jens Axboe wrote:
> On 7/29/20 4:10 AM, Jiufei Xue wrote:
>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>> supported. Add two new interfaces: io_uring_wait_cqes2(),
>> io_uring_wait_cqe_timeout2() for applications to use this feature.
> 
> Why add new new interfaces, when the old ones already pass in the
> timeout? Surely they could just use this new feature, instead of the
> internal timeout, if it's available?
> 
Applications use the old one may not call io_uring_submit() because
io_uring_wait_cqes() will do it. So I considered to add a new one.

>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>> index 0505a4f..6176a63 100644
>> --- a/src/include/liburing.h
>> +++ b/src/include/liburing.h
>> @@ -56,6 +56,7 @@ struct io_uring {
>>  	struct io_uring_sq sq;
>>  	struct io_uring_cq cq;
>>  	unsigned flags;
>> +	unsigned features;
>>  	int ring_fd;
>>  };
> 
> This breaks the API, as it changes the size of the ring...
> 
Oh, yes, I haven't considering that before. So could I add this feature
bit to io_uring.flags. Any suggestion?

Thanks,
JIufei. 

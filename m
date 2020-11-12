Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62E2B00A7
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 08:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgKLH6b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 02:58:31 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:33507 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgKLH6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 02:58:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UF3B8El_1605167907;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UF3B8El_1605167907)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 15:58:27 +0800
Subject: Re: [dm-devel] dm: add support for DM_TARGET_NOWAIT for various
 targets
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com, koct9i@gmail.com,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20201110065558.22694-1-jefflexu@linux.alibaba.com>
 <20201111153824.GB22834@redhat.com>
 <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
Message-ID: <8e958749-3954-a041-e6a9-ec13c328e9b6@linux.alibaba.com>
Date:   Thu, 12 Nov 2020 15:58:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <533a3b6b-146b-afe6-2e3e-d1bc2180a8c8@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/12/20 2:05 PM, JeffleXu wrote:
>>
>> dm-table.c:dm_table_set_restrictions() has:
>>
>>          if (dm_table_supports_nowait(t))
>>                  blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
>>          else
>>                  blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
>>
>>> This patch adds support for DM_TARGET_NOWAIT for those dm targets, the
>>> .map() algorithm of which just involves sector recalculation.
>> So you're looking to constrain which targets will properly support
>> REQ_NOWAIT, based on whether they do a simple remapping?
>
> To be honest, I'm a little confused about the semantics of REQ_NOWAIT. 
> Jens may had ever
>
> explained it in block or io_uring mailing list, but I can't find the 
> specific mail.
>
I find it here 
https://lore.kernel.org/linux-block/f1a6ae88-1436-e947-1124-41e10b3ea9bc@kernel.dk/


So if the IO is offloaded to workqueue and the current process context 
will not get blocked,

then is this device capable of handling REQ_NOWAIT or not?

-- 
Thanks,
Jeffle


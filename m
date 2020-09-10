Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5B264E98
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 21:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIJTUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 15:20:36 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:44799 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731431AbgIJPw2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 11:52:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8WQhF._1599753140;
Received: from 192.168.124.15(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U8WQhF._1599753140)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Sep 2020 23:52:20 +0800
Subject: Re: [RFC PATCH for-next] io_uring: support multiple rings to share
 same poll thread by specifying same cpu
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200910070359.14683-1-xiaoguang.wang@linux.alibaba.com>
 <d926108a-eda2-3041-0afc-7c82f0c0ac70@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <6424dacd-7ebb-f8be-ddfa-4e4e96c4a015@linux.alibaba.com>
Date:   Thu, 10 Sep 2020 23:51:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d926108a-eda2-3041-0afc-7c82f0c0ac70@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 9/10/20 1:03 AM, Xiaoguang Wang wrote:
>> We have already supported multiple rings to share one same poll thread
>> by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
>> IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
>> has already existed, that means it will require app to regulate the
>> creation oder between uring instances.
>>
>> Currently we can make this a bit simpler, for those rings which will
>> have SQPOLL enabled and are willing to be bound to one same cpu, add a
>> capability that these rings can share one poll thread by specifying
>> a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
>>    1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
>> try to attach this ring to an existing ring's corresponding poll thread,
>> no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
>> set.
>>    2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
>> for this case, we'll create a single poll thread to be shared by these
>> rings, and this poll thread is bound to a fixed cpu.
>>    3, for any other cases, we'll just create one new poll thread for the
>> corresponding ring.
>>
>> And for case 2, don't need to regulate creation oder of multiple uring
>> instances, we use a mutex to synchronize creation, for example, say five
>> rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
>> enabled, and are willing to be bound same cpu, one ring that gets the
>> mutex lock will create one poll thread, the other four rings will just
>> attach themselves the previous created poll thread.
>>
>> To implement above function, add one global hlist_head hash table, only
>> sqd that is created for IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
>> will be added to this global list, and its search key are current->files
>> and cpu number.
> 
> Can you resend this against the current tree? Looks like it's against
> something that is outdated. That'll make it easier to test and review.
Sorry, I forgot to update my local tree to the current tree.
It's a little late today, I'll send a V2 against the current tree tomorrow, thanks.

Regards,
Xiaoguang Wang

> 

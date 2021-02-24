Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A506F32356C
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 02:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhBXBpd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 20:45:33 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:47383 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231154AbhBXBpb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 20:45:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UPPc0lB_1614131089;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPPc0lB_1614131089)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Feb 2021 09:44:49 +0800
Subject: Re: [PATCH v4 00/12] dm: support IO polling
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, Mikulas Patocka <mpatocka@redhat.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
 <e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
 <20210223205434.GB25684@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <5c4e6bab-63be-f390-55a8-3f700eebf98b@linux.alibaba.com>
Date:   Wed, 24 Feb 2021 09:44:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223205434.GB25684@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/24/21 4:54 AM, Mike Snitzer wrote:
> On Mon, Feb 22 2021 at 10:55pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>>
>> On 2/20/21 7:06 PM, Jeffle Xu wrote:
>>> [Changes since v3]
>>> - newly add patch 7 and patch 11, as a new optimization improving
>>> performance of multiple polling processes. Now performance of multiple
>>> polling processes can be as scalable as single polling process (~30%).
>>> Refer to the following [Performance] chapter for more details.
>>>
>>
>> Hi Mike, would please evaluate this new version patch set? I think this
>> mechanism is near maturity, since multi-thread performance is as
>> scalable as single-thread (~30%) now.
> 
> OK, can do. But first I think you need to repost with a v5 that
> addresses Mikulas' v3 feedback:
> 
> https://listman.redhat.com/archives/dm-devel/2021-February/msg00254.html
> https://listman.redhat.com/archives/dm-devel/2021-February/msg00255.html
> 

Will do. Besides I will also rebase to 5.12 in the next version.

-- 
Thanks,
Jeffle

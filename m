Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46B66CD267
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 09:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjC2HAD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 03:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC2HAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 03:00:02 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5C268B;
        Wed, 29 Mar 2023 00:00:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vevp.P8_1680073195;
Received: from 30.97.56.166(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0Vevp.P8_1680073195)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 14:59:56 +0800
Message-ID: <8a30ac76-dbee-e785-a6fc-1a752af9b18f@linux.alibaba.com>
Date:   Wed, 29 Mar 2023 14:59:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
 <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
 <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
 <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/28 21:01, Ming Lei wrote:

[...]

>>
>>
>>> So re-using splice for this purpose is still bad not mention splice
>>> can't support writeable spliced page.
>>>
>>> Wiring device io buffer with context registered buffer table looks like
>>> another approach, however:
>>>
>>> 1) two uring command OPs for registering/unregistering this buffer in io fast
>>> path has to be added since only userspace can know when buffer(reference)
>>> isn't needed
>>
>> Yes, that's a good point. Registration replaces fuse master cmd, so it's
>> one extra request for unregister, which might be fine.
> 
> Unfortunately I don't think this way is good, the problem is that buffer
> only has physical pages, and doesn't have userspace mapping, so why bother
> to export it to userspace?
> 
> As I replied to Ziyang, the current fused command can be extended to
> this way easily, but I don't know why we need to use the buffer registration,
> given userspace can't read/write the buffer, and fused command can cover
> it just fine.
> 

Hi Ming, I have replied to you in another email.


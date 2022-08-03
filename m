Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B24588BBD
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiHCMEI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 08:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiHCMEH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 08:04:07 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E04328E09;
        Wed,  3 Aug 2022 05:04:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VLGuMQA_1659528241;
Received: from 30.227.84.71(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VLGuMQA_1659528241)
          by smtp.aliyun-inc.com;
          Wed, 03 Aug 2022 20:04:02 +0800
Message-ID: <2edb5698-4423-cbdb-350b-609e8fba1e1c@linux.alibaba.com>
Date:   Wed, 3 Aug 2022 20:04:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [bug report] ublk_drv: hang while removing ublk character device
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
References: <99bc953a-22d4-2bb2-e2b9-f0a92e787c1b@linux.alibaba.com>
 <YupjpIAQYxbuaOR6@T590>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <YupjpIAQYxbuaOR6@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/8/3 20:01, Ming Lei wrote:
> Hi Ziyang,
> 
> On Wed, Aug 03, 2022 at 07:45:24PM +0800, Ziyang Zhang wrote:
>> Hi all,
>>
>> Now ublk_drv has been pushed into master branch and I am running tests on it.
>> With newest(master) kernel and newest(master) ublksrv[1], a test case(generic/001) of ublksrv failed(hanged):
>>
> 
> Please see the fix:
> 
> https://lore.kernel.org/io-uring/48b58f2b-014c-cbc6-36c3-29be42040fa0@gmail.com/T/#t

Yeah, I got this. Thanks for the fix, Ming.


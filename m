Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789B66AFD9B
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 04:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCHDsW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 22:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHDsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 22:48:21 -0500
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5AD80925;
        Tue,  7 Mar 2023 19:48:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VdNfgny_1678247296;
Received: from 30.97.56.232(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VdNfgny_1678247296)
          by smtp.aliyun-inc.com;
          Wed, 08 Mar 2023 11:48:16 +0800
Message-ID: <3e5c7542-e4ad-202f-6dbb-fdea37bd62d7@linux.alibaba.com>
Date:   Wed, 8 Mar 2023 11:48:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH V2 06/17] block: ublk_drv: mark device as LIVE before
 adding disk
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <20230307141520.793891-7-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20230307141520.793891-7-ming.lei@redhat.com>
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

On 2023/3/7 22:15, Ming Lei wrote:
> IO can be started before add_disk() returns, such as reading parititon table,
> then the monitor work should work for making forward progress.
> 
> So mark device as LIVE before adding disk, meantime change to
> DEAD if add_disk() fails.
> 
> Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---

Hi Ming,

Without this patch, if we fail to read partition table(Could this
happen?)and EIO is returned, then START_DEV may hang forever, right?
I may have encountered such error before and I think this bug is introduced
by:
bbae8d1f526b(ublk_drv: consider recovery feature in aborting mechanism)
which change the behavior of monitor_work. So shall we add a fixes tag, such
as:
Fixes: bbae8d1f526b("ublk_drv: consider recovery feature in aborting mechanism")

Regards,
Zhang

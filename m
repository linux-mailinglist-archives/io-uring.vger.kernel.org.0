Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DFA6A8F25
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 03:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjCCCZp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Mar 2023 21:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCCCZo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Mar 2023 21:25:44 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9971B460A4;
        Thu,  2 Mar 2023 18:25:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vcz9kbA_1677810339;
Received: from 30.97.56.172(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0Vcz9kbA_1677810339)
          by smtp.aliyun-inc.com;
          Fri, 03 Mar 2023 10:25:40 +0800
Message-ID: <32db6601-8cb2-da04-fad1-82c17eb96a6e@linux.alibaba.com>
Date:   Fri, 3 Mar 2023 10:25:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 10/12] block: ublk_drv: mark device as LIVE before
 adding disk
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
 <20230301140611.163055-11-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20230301140611.163055-11-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/1 22:06, Ming Lei wrote:
> IO can be started before add_disk() returns, such as reading parititon table,
> then the monitor work should work for making forward progress.
> 
> So mark device as LIVE before adding disk, meantime change to
> DEAD if add_disk() fails.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>

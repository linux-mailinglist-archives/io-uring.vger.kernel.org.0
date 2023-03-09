Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978916B19D2
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 04:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCIDMJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 22:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCIDMI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 22:12:08 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7F7EA3B;
        Wed,  8 Mar 2023 19:12:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VdRapbN_1678331522;
Received: from 30.97.56.238(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VdRapbN_1678331522)
          by smtp.aliyun-inc.com;
          Thu, 09 Mar 2023 11:12:03 +0800
Message-ID: <7c5498a7-26ac-406c-1f52-4a66ef268525@linux.alibaba.com>
Date:   Thu, 9 Mar 2023 11:12:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH V2 09/17] block: ublk_drv: add two helpers to clean up
 map/unmap request
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <20230307141520.793891-10-ming.lei@redhat.com>
Content-Language: en-US
In-Reply-To: <20230307141520.793891-10-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/7 22:15, Ming Lei wrote:
> Add two helpers for checking if map/unmap is needed, since we may have
> passthrough request which needs map or unmap in future, such as for
> supporting report zones.
> 
> Meantime don't mark ublk_copy_user_pages as inline since this function
> is a bit fat now.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>

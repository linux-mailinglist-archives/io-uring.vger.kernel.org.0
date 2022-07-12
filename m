Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C93571027
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 04:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiGLC1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 22:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiGLC06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 22:26:58 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BE78FD4A;
        Mon, 11 Jul 2022 19:26:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJ6IXEP_1657592808;
Received: from 30.97.56.235(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VJ6IXEP_1657592808)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 10:26:49 +0800
Message-ID: <1f021cc5-3cbe-a69d-7d50-8c758174d178@linux.alibaba.com>
Date:   Tue, 12 Jul 2022 10:26:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting
 to build as module
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <20220711022024.217163-3-ming.lei@redhat.com> <87lesze7o3.fsf@collabora.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <87lesze7o3.fsf@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/7/12 04:06, Gabriel Krisman Bertazi wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
>> Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
>> ubq daemon context, so we can avoid to call task_work_add(), then
>> it is fine to build ublk driver as module.
>>
>> In this way, iops is affected a bit, but just by ~5% on ublk/null,
>> given io_uring provides pretty good batching issuing & completing.
>>
>> One thing to be careful is race between ->queue_rq() and handling
>> abort, which is avoided by quiescing queue when aborting queue.
>> Except for that, handling abort becomes much easier with
>> UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
>> anything done in ubq daemon kernel context.
> 
> Hi Ming,
> 
> FWIW, I'm not very fond this change.  It adds complexity to the kernel
> driver and to the userspace server implementation, who now have to deal
> with different interface semantics just because the driver was built-in
> or built as a module.  I don't think the tristate support warrants such
> complexity.  I was hoping we might get away with exporting that symbol
> or adding a built-in ubd-specific wrapper that can be exported and
> invokes task_work_add.
> 
> Either way, Alibaba seems to consider this feature useful, and if that
> is the case, we can just not use it on our side.

Our app handles IOs itself with network(RPC) and internal memory pool
so UBLK_IO_REFETCH_REQ
(actually I think it is like NEED_GET_DATA in the earlist version :) )
is helpful to us because we can assign data buffer address AFTER the app
gets one IO requests(WRITE, with data size) and we avoid PRE-allocating buffers.

Besides, adding UBLK_IO_REFETCH_REQ is helpful to build ublk driver as module
It seems like kernel developers do not want a built-in driver. :)

Maybe your app is different from ours(you may not need to handle IOs by yourelf).

Thanks， 
Ziyang Zhang


> 
> That said, the patch looks good to me, just a minor comment inline.
> 
> Thanks,
> 
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>  drivers/block/Kconfig         |   2 +-
>>  drivers/block/ublk_drv.c      | 121 ++++++++++++++++++++++++++--------
>>  include/uapi/linux/ublk_cmd.h |  17 +++++
>>  3 files changed, 113 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>> index d218089cdbec..2ba77fd960c2 100644
>> --- a/drivers/block/Kconfig
>> +++ b/drivers/block/Kconfig
>> @@ -409,7 +409,7 @@ config BLK_DEV_RBD
>>  	  If unsure, say N.
>>  
>>  config BLK_DEV_UBLK
>> -	bool "Userspace block driver"
>> +	tristate "Userspace block driver"
>>  	select IO_URING
>>  	help
>>            io uring based userspace block driver.
>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>> index 0076418e6fad..98482f8d1a77 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -92,6 +92,7 @@ struct ublk_queue {
>>  	int q_id;
>>  	int q_depth;
>>  
>> +	unsigned long flags;
>>  	struct task_struct	*ubq_daemon;
>>  	char *io_cmd_buf;
>>  
>> @@ -141,6 +142,15 @@ struct ublk_device {
>>  	struct work_struct	stop_work;
>>  };
>>  
>> +#define ublk_use_task_work(ubq)						\
>> +({                                                                      \
>> +	bool ret = false;						\
>> +	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&                          \
>> +			!((ubq)->flags & UBLK_F_NEED_REFETCH))		\
>> +		ret = true;						\
>> +	ret;								\
>> +})
>> +
> 
> This should be an inline function, IMO.
> 
> 

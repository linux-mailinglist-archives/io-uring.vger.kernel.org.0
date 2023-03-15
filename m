Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5363D6BA8C0
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 08:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjCOHIu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 03:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjCOHIo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 03:08:44 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBE56700B;
        Wed, 15 Mar 2023 00:08:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vdv8zjI_1678864101;
Received: from 30.97.56.196(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0Vdv8zjI_1678864101)
          by smtp.aliyun-inc.com;
          Wed, 15 Mar 2023 15:08:22 +0800
Message-ID: <af393444-71cb-6692-5ea2-8f96be7d7832@linux.alibaba.com>
Date:   Wed, 15 Mar 2023 15:08:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
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
> Hello,
> 
> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> and its ->issue() can retrieve/import buffer from master request's
> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> submits slave OP just like normal OP issued from userspace, that said,
> SQE order is kept, and batching handling is done too.
> 
> Please see detailed design in commit log of the 3th patch, and one big
> point is how to handle buffer ownership.
> 
> With this way, it is easy to support zero copy for ublk/fuse device.
> 
> Basically userspace can specify any sub-buffer of the ublk block request
> buffer from the fused command just by setting 'offset/len'
> in the slave SQE for running slave OP. This way is flexible to implement
> io mapping: mirror, stripped, ...
> 
> The 4th & 5th patches enable fused slave support for the following OPs:
> 
> 	OP_READ/OP_WRITE
> 	OP_SEND/OP_RECV/OP_SEND_ZC
> 
> The other ublk patches cleans ublk driver and implement fused command
> for supporting zero copy.
> 
> Follows userspace code:
> 
> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> 
> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> 
> 	ublk add -t [loop|nbd|qcow2] -z .... 
> 
> Basic fs mount/kernel building and builtin test are done.
> 
> Also add liburing test case for covering fused command based on miniublk
> of blktest:
> 
> https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> 
> Performance improvement is obvious on memory bandwidth
> related workloads, such as, 1~2X improvement on 64K/512K BS
> IO test on loop with ramfs backing file.
> 
> Any comments are welcome!
> 


Hi Ming,

Maybe we can split patch 06-12 to a separate cleanup pacthset. I think
these patches can be merged first because they are not related to zero copy.

Regards,
Zhang

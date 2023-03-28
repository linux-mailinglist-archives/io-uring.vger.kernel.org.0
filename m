Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306386CB4AD
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 05:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjC1DOA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 23:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1DOA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 23:14:00 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2078D1A6;
        Mon, 27 Mar 2023 20:13:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VerH6ke_1679973233;
Received: from 30.221.134.40(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VerH6ke_1679973233)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 11:13:55 +0800
Message-ID: <a786568e-50fb-6f93-352a-1328d0f98a7b@linux.alibaba.com>
Date:   Tue, 28 Mar 2023 11:13:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
To:     Ming Lei <ming.lei@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 2023/3/28 09:16, Ming Lei wrote:
> Hi Dan,
> 
> On Mon, Mar 27, 2023 at 05:36:33PM -0700, Dan Williams wrote:
>> Ming Lei wrote:
>>> Hello Jens,
>>>
>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>> and its ->issue() can retrieve/import buffer from master request's
>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>> submits slave OP just like normal OP issued from userspace, that said,
>>> SQE order is kept, and batching handling is done too.
>>
>> Hi Ming,
>>
>> io_uring and ublk are starting to be more on my radar these days. I
>> wanted to take a look at this series, but could not get past the
>> distracting "master"/"slave" terminology in this lead-in paragraph let
>> alone start looking at patches.
>>
>> Frankly, the description sounds more like "head"/"tail", or even
>> "fuse0"/"fuse1" because, for example, who is to say you might not have
> 
> The term "master/slave" is from patches.
> 
> The master command not only provides buffer for slave request, but also requires
> slave request for serving master command, and master command is always completed
> after all slave request are done.
> 
> That is why it is named as master/slave. Actually Jens raised the similar concern
> and I hate the name too, but it is always hard to figure out perfect name, or
> any other name for reflecting the relation? (head/tail, fuse0/1 can't
> do that, IMO)
> 
>> larger fused ops in the future and need terminology to address
>> "fuse{0,1,2,3}"?
> 
> Yeah, definitely, the interface can be extended in future to support
> multiple "slave" requests.

I guess master/slave (especially now) have bad meaning to
English-language guys so it's better to avoid it.

Thanks,
Gao Xiang

> 
> Thanks,
> Ming

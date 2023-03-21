Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21976C365C
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 16:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjCUP6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjCUP6O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 11:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DE851FB9
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679414230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DN59pp+C6hDNz15tX2qpijzkgX68iyvX6ziKjshgX7I=;
        b=HWCs8mNYo6wuiiWezwED/1dWN383GMVTWHBBvTK2R/ttYnVq+XyC8QdCM2yd7b4lhPbtNJ
        z4JDnfp1BpPNe7a7fw53zWi/0t3Ta94p3oNU3F8kYvDWfC/l1B+M/wZ2bjzP0U3QxbWH5T
        8dpps+quFjNSWYo7hUQFa96UD8vBTtQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-hQEJgpWcPOyn5NJcx6wZzA-1; Tue, 21 Mar 2023 11:57:05 -0400
X-MC-Unique: hQEJgpWcPOyn5NJcx6wZzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E305857FB5;
        Tue, 21 Mar 2023 15:57:04 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A617E140E960;
        Tue, 21 Mar 2023 15:56:50 +0000 (UTC)
Date:   Tue, 21 Mar 2023 23:56:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBnTuX+5D8QeLPuQ@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
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
> Please see detailed design in commit log of the 2th patch, and one big
> point is how to handle buffer ownership.
> 
> With this way, it is easy to support zero copy for ublk/fuse device.
> 
> Basically userspace can specify any sub-buffer of the ublk block request
> buffer from the fused command just by setting 'offset/len'
> in the slave SQE for running slave OP. This way is flexible to implement
> io mapping: mirror, stripped, ...
> 
> The 3th & 4th patches enable fused slave support for the following OPs:
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
> Basic fs mount/kernel building and builtin test are done, and also not
> observe regression on xfstest test over ublk-loop with zero copy.
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
> V3:
> 	- fix build warning reported by kernel test robot
> 	- drop patch for checking fused flags on existed drivers with
> 	  ->uring_command(), which isn't necessary, since we do not do that
>       when adding new ioctl or uring command
>     - inline io_init_rq() for core code, so just export io_init_slave_req
> 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
> 	will be cleared
> 	- pass xfstest over ublk-loop

BTW, I just wrote one ublk zero copy document, which describes technical requirement
for this feature, and explains why splice isn't good and how fused command solves it,
feel free to refer to it when working on candidate approach.

https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v4/Documentation/block/ublk.rst#zero-copy

Which will be included in V4.


Thanks, 
Ming


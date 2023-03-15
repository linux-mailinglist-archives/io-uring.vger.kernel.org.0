Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6194D6BAA22
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 08:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjCOH4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 03:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjCOH4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 03:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDE265C62
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 00:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678866907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQGLNPAUIMXCLvvVzseeTkdBPu3uHBXvFY7HOJnpJu8=;
        b=LyBp8cEZepIwoqcCUtqb/PtnX37qdoL75X7KAjN2AljZABc+TQaphpdta06Z7EpVSWCNoB
        7U9ZC3Fv2YGrYVU5O1GaM48y2mbLE++rvZCSeYgP/zdMKhBIOUOh5/ncMBNgIdAbmkkcZ5
        wlHp2hcQG71hi2hvcka6uBofNnHF4ws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-u2H9CsGGMsyl3l2n-Q-scg-1; Wed, 15 Mar 2023 03:55:02 -0400
X-MC-Unique: u2H9CsGGMsyl3l2n-Q-scg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25199886461;
        Wed, 15 Mar 2023 07:55:02 +0000 (UTC)
Received: from ovpn-8-22.pek2.redhat.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E705BC017D7;
        Wed, 15 Mar 2023 07:54:56 +0000 (UTC)
Date:   Wed, 15 Mar 2023 15:54:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBF5y5/vAPk1jTg8@ovpn-8-22.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <af393444-71cb-6692-5ea2-8f96be7d7832@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af393444-71cb-6692-5ea2-8f96be7d7832@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 15, 2023 at 03:08:21PM +0800, Ziyang Zhang wrote:
> On 2023/3/7 22:15, Ming Lei wrote:
> > Hello,
> > 
> > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > and its ->issue() can retrieve/import buffer from master request's
> > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > submits slave OP just like normal OP issued from userspace, that said,
> > SQE order is kept, and batching handling is done too.
> > 
> > Please see detailed design in commit log of the 3th patch, and one big
> > point is how to handle buffer ownership.
> > 
> > With this way, it is easy to support zero copy for ublk/fuse device.
> > 
> > Basically userspace can specify any sub-buffer of the ublk block request
> > buffer from the fused command just by setting 'offset/len'
> > in the slave SQE for running slave OP. This way is flexible to implement
> > io mapping: mirror, stripped, ...
> > 
> > The 4th & 5th patches enable fused slave support for the following OPs:
> > 
> > 	OP_READ/OP_WRITE
> > 	OP_SEND/OP_RECV/OP_SEND_ZC
> > 
> > The other ublk patches cleans ublk driver and implement fused command
> > for supporting zero copy.
> > 
> > Follows userspace code:
> > 
> > https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> > 
> > All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> > 
> > 	ublk add -t [loop|nbd|qcow2] -z .... 
> > 
> > Basic fs mount/kernel building and builtin test are done.
> > 
> > Also add liburing test case for covering fused command based on miniublk
> > of blktest:
> > 
> > https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> > 
> > Performance improvement is obvious on memory bandwidth
> > related workloads, such as, 1~2X improvement on 64K/512K BS
> > IO test on loop with ramfs backing file.
> > 
> > Any comments are welcome!
> > 
> 
> 
> Hi Ming,
> 
> Maybe we can split patch 06-12 to a separate cleanup pacthset. I think
> these patches can be merged first because they are not related to zero copy.

Hi Ziyang,

I think the fused command approach is doable, and the patchset is basically
ready to go now:

- the fused command approach won't affect normal uring OP
- most of the change focuses on io_uring/fused_cmd.*
- this approach works reliably and efficiently, pass xfstests, and
  verified on all three ublk targets(loop, nbd, qcow2), improvement is
  pretty obvious

so I'd rather to put them in one series and aim at v6.14, then we can avoid conflict.

However if things doesn't work toward the expected direction, we can move on with
another way at that time, so it is too early to separate the cleanup patchset now.

thanks,
Ming


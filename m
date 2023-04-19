Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD66E787B
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 13:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjDSLVj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjDSLVh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 07:21:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B04613FA9
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 04:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681903175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GgOW5sQn+ypCHeLUClWbKQUCBoyTE44G8sVc+d/AfFM=;
        b=Z4isTUyZCMZDi4u8abor9gQ57lwdEWFR2B+uHm0AjHtWZH6Ty7POAw5k+UZl5nUb5sk4QT
        PHTxsTNAVtuFJ+e27kVWuocikn61fC+1HEP+zYuThU+3Ti3th2tUiUdILFjkg4fGVpyhpv
        DI96b08uQd82SoQwfIfYL7ZqDgjYt2E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-4E60WAUyMYqrGp0YHZij5Q-1; Wed, 19 Apr 2023 07:19:30 -0400
X-MC-Unique: 4E60WAUyMYqrGp0YHZij5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDF8C885623;
        Wed, 19 Apr 2023 11:19:29 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6445C51E3;
        Wed, 19 Apr 2023 11:19:21 +0000 (UTC)
Date:   Wed, 19 Apr 2023 19:19:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Amir Goldstein <amir73il@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Message-ID: <ZD/ONON4AzwvtlLB@ovpn-8-18.pek2.redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
 <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
 <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 09:56:43AM +0000, Bernd Schubert wrote:
> On 4/19/23 03:51, Ming Lei wrote:
> > On Tue, Apr 18, 2023 at 07:38:03PM +0000, Bernd Schubert wrote:
> >> On 3/30/23 13:36, Ming Lei wrote:
> >> [...]
> >>> V6:
> >>> 	- re-design fused command, and make it more generic, moving sharing buffer
> >>> 	as one plugin of fused command, so in future we can implement more plugins
> >>> 	- document potential other use cases of fused command
> >>> 	- drop support for builtin secondary sqe in SQE128, so all secondary
> >>> 	  requests has standalone SQE
> >>> 	- make fused command as one feature
> >>> 	- cleanup & improve naming
> >>
> >> Hi Ming, et al.,
> >>
> >> I started to wonder if fused SQE could be extended to combine multiple
> >> syscalls, for example open/read/close.  Which would be another solution
> >> for the readfile syscall Miklos had proposed some time ago.
> >>
> >> https://lore.kernel.org/lkml/CAJfpegusi8BjWFzEi05926d4RsEQvPnRW-w7My=ibBHQ8NgCuw@mail.gmail.com/
> >>
> >> If fused SQEs could be extended, I think it would be quite helpful for
> >> many other patterns. Another similar examples would open/write/close,
> >> but ideal would be also to allow to have it more complex like
> >> "open/write/sync_file_range/close" - open/write/close might be the
> >> fastest and could possibly return before sync_file_range. Use case for
> >> the latter would be a file server that wants to give notifications to
> >> client when pages have been written out.
> > 
> > The above pattern needn't fused command, and it can be done by plain
> > SQEs chain, follows the usage:
> > 
> > 1) suppose you get one command from /dev/fuse, then FUSE daemon
> > needs to handle the command as open/write/sync/close
> > 2) get sqe1, prepare it for open syscall, mark it as IOSQE_IO_LINK;
> > 3) get sqe2, prepare it for write syscall, mark it as IOSQE_IO_LINK;
> > 4) get sqe3, prepare it for sync file range syscall, mark it as IOSQE_IO_LINK;
> > 5) get sqe4, prepare it for close syscall
> > 6) io_uring_enter();	//for submit and get events
> 
> Oh, I was not aware that IOSQE_IO_LINK could pass the result of open 
> down to the others. Hmm, the example I find for open is 
> io_uring_prep_openat_direct in test_open_fixed(). It probably gets off 
> topic here, but one needs to have ring prepared with 
> io_uring_register_files_sparse, then manually manages available indexes 
> and can then link commands? Interesting!

Yeah,  see test/fixed-reuse.c of liburing

> 
> > 
> > Then all the four OPs are done one by one by io_uring internal
> > machinery, and you can choose to get successful CQE for each OP.
> > 
> > Is the above what you want to do?
> > 
> > The fused command proposal is actually for zero copy(but not limited to zc).
> 
> Yeah, I had just thought that IORING_OP_FUSED_CMD could be modified to 
> support generic passing, as it kind of hands data (buffers) from one sqe 
> to the other. I.e. instead of buffers it would have passed the fd, but 
> if this is already possible - no need to make IORING_OP_FUSED_CMD more 
> complex.man

The way of passing FD introduces other cost, read op running into async,
and adding it into global table, which introduces runtime cost.

That is the reason why fused command is designed in the following way:

- link can be avoided, so OPs needn't to be run in async
- no need to add buffer into global table

Cause it is really in fast io path.

> 
> > 
> > If the above write OP need to write to file with in-kernel buffer
> > of /dev/fuse directly, you can get one sqe0 and prepare it for primary command
> > before 1), and set sqe2->addr to offet of the buffer in 3).
> > 
> > However, fused command is usually used in the following way, such as FUSE daemon
> > gets one READ request from /dev/fuse, FUSE userspace can handle the READ request
> > as io_uring fused command:
> > 
> > 1) get sqe0 and prepare it for primary command, in which you need to
> > provide info for retrieving kernel buffer/pages of this READ request
> > 
> > 2) suppose this READ request needs to be handled by translating it to
> > READs to two files/devices, considering it as one mirror:
> > 
> > - get sqe1, prepare it for read from file1, and set sqe->addr to offset
> >    of the buffer in 1), set sqe->len as length for read; this READ OP
> >    uses the kernel buffer in 1) directly
> > 
> > - get sqe2, prepare it for read from file2, and set sqe->addr to offset
> >    of buffer in 1), set sqe->len as length for read;  this READ OP
> >    uses the kernel buffer in 1) directly
> > 
> > 3) submit the three sqe by io_uring_enter()
> > 
> > sqe1 and sqe2 can be submitted concurrently or be issued one by one
> > in order, fused command supports both, and depends on user requirement.
> > But io_uring linked OPs is usually slower.
> > 
> > Also file1/file2 needs to be opened beforehand in this example, and FD is
> > passed to sqe1/sqe2, another choice is to use fixed File; Also you can
> > add the open/close() OPs into above steps, which need these open/close/READ
> > to be linked in order, usually slower tnan non-linked OPs.
> 
> 
> Yes thanks, I'm going to prepare this in an branch, otherwise current 
> fuse-uring would have a ZC regression (although my target ddn projects 
> cannot make use of it, as we need access to the buffer for checksums, etc).

storage has similar use case too, such as encrypt, nvme tcp data digest,
..., if the checksum/encrypt approach is standard, maybe one new OP or
syscall can be added for doing that on kernel buffer directly.


Thanks
Ming


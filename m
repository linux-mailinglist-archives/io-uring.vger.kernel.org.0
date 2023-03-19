Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162846BFEA8
	for <lists+io-uring@lfdr.de>; Sun, 19 Mar 2023 01:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCSAbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 20:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCSAbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 20:31:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584FB1042E
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 17:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679185741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uDIEFtBVpeOSOYrS78nZM9Q/s82SzdDFQHZp5fuSgac=;
        b=eXGhYEd1ECnJbzpbiqKxqzHsO/nS8KXRcCLQw6nuHKI1hiE2trjDOUeUiN5DN/+PWTG2qi
        CuAyNcBo4zY4LALVwa0VWlqrF1Ewg7efAz9YScO0CrvA7BbqM70yU5OiNInfuDVYaNoDiQ
        YVxmZLUHtnxOeNIQimZZOIR/NLzPhXA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-CYhPBqY-MbGAItohR0d06A-1; Sat, 18 Mar 2023 20:17:29 -0400
X-MC-Unique: CYhPBqY-MbGAItohR0d06A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39BC687B2A1;
        Sun, 19 Mar 2023 00:17:29 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 227C340D1C8;
        Sun, 19 Mar 2023 00:17:22 +0000 (UTC)
Date:   Sun, 19 Mar 2023 08:17:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBZUjVw/V4Kbr1SV@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
 <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Mar 19, 2023 at 07:42:26AM +0800, Ming Lei wrote:
> On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
> > On 3/18/23 13:35, Ming Lei wrote:
> > > Hi Jens,
> > > 
> > > Thanks for the response!
> > > 
> > > On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
> > > > On 3/17/23 2:14?AM, Ming Lei wrote:
> > > > > On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > > > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > > > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > > > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > > > > and its ->issue() can retrieve/import buffer from master request's
> > > > > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > > > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > > > > submits slave OP just like normal OP issued from userspace, that said,
> > > > > > SQE order is kept, and batching handling is done too.
> > > > > > 
> > > > > > Please see detailed design in commit log of the 2th patch, and one big
> > > > > > point is how to handle buffer ownership.
> > > > > > 
> > > > > > With this way, it is easy to support zero copy for ublk/fuse device.
> > > > > > 
> > > > > > Basically userspace can specify any sub-buffer of the ublk block request
> > > > > > buffer from the fused command just by setting 'offset/len'
> > > > > > in the slave SQE for running slave OP. This way is flexible to implement
> > > > > > io mapping: mirror, stripped, ...
> > > > > > 
> > > > > > The 3th & 4th patches enable fused slave support for the following OPs:
> > > > > > 
> > > > > > 	OP_READ/OP_WRITE
> > > > > > 	OP_SEND/OP_RECV/OP_SEND_ZC
> > > > > > 
> > > > > > The other ublk patches cleans ublk driver and implement fused command
> > > > > > for supporting zero copy.
> > > > > > 
> > > > > > Follows userspace code:
> > > > > > 
> > > > > > https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> > > > > > 
> > > > > > All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> > > > > > 
> > > > > > 	ublk add -t [loop|nbd|qcow2] -z ....
> > > > > > 
> > > > > > Basic fs mount/kernel building and builtin test are done, and also not
> > > > > > observe regression on xfstest test over ublk-loop with zero copy.
> > > > > > 
> > > > > > Also add liburing test case for covering fused command based on miniublk
> > > > > > of blktest:
> > > > > > 
> > > > > > https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> > > > > > 
> > > > > > Performance improvement is obvious on memory bandwidth
> > > > > > related workloads, such as, 1~2X improvement on 64K/512K BS
> > > > > > IO test on loop with ramfs backing file.
> > > > > > 
> > > > > > Any comments are welcome!
> > > > > > 
> > > > > > V3:
> > > > > > 	- fix build warning reported by kernel test robot
> > > > > > 	- drop patch for checking fused flags on existed drivers with
> > > > > > 	  ->uring_command(), which isn't necessary, since we do not do that
> > > > > >        when adding new ioctl or uring command
> > > > > >      - inline io_init_rq() for core code, so just export io_init_slave_req
> > > > > > 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
> > > > > > 	will be cleared
> > > > > > 	- pass xfstest over ublk-loop
> > > > > 
> > > > > Hello Jens and Guys,
> > > > > 
> > > > > I have been working on io_uring zero copy support for ublk/fuse for a while, and
> > > > > I appreciate you may share any thoughts on this patchset or approach?
> > > > 
> > > > I'm a bit split on this one, as I really like (and want) the feature.
> > > > ublk has become popular pretty quickly, and it makes a LOT of sense to
> > > > support zero copy for it. At the same time, I'm not really a huge fan of
> > > > the fused commands... They seem too specialized to be useful for other
> > > > things, and it'd be a shame to do something like that only for it later
> > > > to be replaced by a generic solution. And then we're stuck with
> > > > supporting fused commands forever, not sure I like that prospect.
> > > > 
> > > > Both Pavel and Xiaoguang voiced similar concerns, and I think it may be
> > > > worth spending a bit more time on figuring out if splice can help us
> > > > here. David Howells currently has a lot going on in that area too.
> > > 
> > > IMO, splice(->splice_read()) can help much less in this use case, and
> > > I can't see improvement David Howells has done in this area:
> > 
> > Let me correct a misunderstanding I've seen a couple of times
> > from people. Apart from the general idea of providing buffers, it's
> > not that bound to splice. Yes, I reused splicing guts for that
> > half-made POC, but we can add a new callback that would do it a
> > bit nicer, i.e. better consolidating returned buffers. Would
> 
> ->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).
> 
> > probably be even better to have both of them falling back to
> > splice so it can cover more cases. The core of it is mediating
> > buffers through io_uring's registered buffer table, which
> > decouples all the components from each other.
> 
> For using pipe buffer's ->release() to release the whole buffer's
> reference, you have to allocate one pipe for each fixed buffer, and add
> pipe buffer to it, and keep each pipe buffer into the pipe
> until it is consumed, since ->release() needs to be called when
> unregistering buffer(all IOs are completed)
> 
> It(allocating/free pipe node, and populating it with each page) is
> really inefficient for handling one single IO.
> 
> So re-using splice for this purpose is still bad not mention splice
> can't support writeable spliced page.
> 
> Wiring device io buffer with context registered buffer table looks like
> another approach, however:
> 
> 1) two uring command OPs for registering/unregistering this buffer in io fast
> path has to be added since only userspace can know when buffer(reference)
> isn't needed
> 
> 2) userspace becomes more complicated, 3+ OPs are required for handling one
> single device IO
> 
> 3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
> we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
> for unregistering buffer

Follows another problem or complexity here:

- normal usage when handling one application(ublk/fuse) IO:

	register device io buffer (file, buffer key)
	OP1 consumes the buffer reference and submits IO
	OP2 consumes the buffer reference and submits IO
	...
	unregister device io buffer(file, buffer key) after all above OPs are completed

- for avoiding devil userspace(we are allowed for unprivileged user) to consume
  buffer after buffer is un-registered, each OP has to grab the buffer(reference)'s
  reference or check if the buffer is stale in its io code path; which has to be added
  to current OP code path

- so the decoupling purpose may _not_ be supported actually, also the current
  fixed buffer interface does not support this kind of buffer retrieving via (xarray, (file, key))


thanks,
Ming


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9E6BFD76
	for <lists+io-uring@lfdr.de>; Sun, 19 Mar 2023 00:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCRXn0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 19:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCRXnZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 19:43:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D81C339
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 16:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679182960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZWWWez/1duXx6Lx3zsFuT6C9D+H9aMkbIXre0Shup14=;
        b=S6iO9ZFZIjF6F1uaUSTWwTJPBdhqQ80gkuJ2lvxa2+XQjLXAKgLeqas1Xt24UR51fU3pre
        2shZUTbyX4G/cKE9DAO92SgZJSMWHLBDzQsWLh+qzZ8IfkTNrIbWGgBWzPZInq7+6GAEvR
        bttxZvbQqwYfh7R9be5myRh/kSmNYsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-V1dBsFapMwSq3hJSMNykNQ-1; Sat, 18 Mar 2023 19:42:39 -0400
X-MC-Unique: V1dBsFapMwSq3hJSMNykNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCC1B85A5A3;
        Sat, 18 Mar 2023 23:42:38 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5F2F40D1C5;
        Sat, 18 Mar 2023 23:42:31 +0000 (UTC)
Date:   Sun, 19 Mar 2023 07:42:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
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

On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
> On 3/18/23 13:35, Ming Lei wrote:
> > Hi Jens,
> > 
> > Thanks for the response!
> > 
> > On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
> > > On 3/17/23 2:14?AM, Ming Lei wrote:
> > > > On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
> > > > > Hello,
> > > > > 
> > > > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > > > and its ->issue() can retrieve/import buffer from master request's
> > > > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > > > submits slave OP just like normal OP issued from userspace, that said,
> > > > > SQE order is kept, and batching handling is done too.
> > > > > 
> > > > > Please see detailed design in commit log of the 2th patch, and one big
> > > > > point is how to handle buffer ownership.
> > > > > 
> > > > > With this way, it is easy to support zero copy for ublk/fuse device.
> > > > > 
> > > > > Basically userspace can specify any sub-buffer of the ublk block request
> > > > > buffer from the fused command just by setting 'offset/len'
> > > > > in the slave SQE for running slave OP. This way is flexible to implement
> > > > > io mapping: mirror, stripped, ...
> > > > > 
> > > > > The 3th & 4th patches enable fused slave support for the following OPs:
> > > > > 
> > > > > 	OP_READ/OP_WRITE
> > > > > 	OP_SEND/OP_RECV/OP_SEND_ZC
> > > > > 
> > > > > The other ublk patches cleans ublk driver and implement fused command
> > > > > for supporting zero copy.
> > > > > 
> > > > > Follows userspace code:
> > > > > 
> > > > > https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
> > > > > 
> > > > > All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> > > > > 
> > > > > 	ublk add -t [loop|nbd|qcow2] -z ....
> > > > > 
> > > > > Basic fs mount/kernel building and builtin test are done, and also not
> > > > > observe regression on xfstest test over ublk-loop with zero copy.
> > > > > 
> > > > > Also add liburing test case for covering fused command based on miniublk
> > > > > of blktest:
> > > > > 
> > > > > https://github.com/ming1/liburing/commits/fused_cmd_miniublk
> > > > > 
> > > > > Performance improvement is obvious on memory bandwidth
> > > > > related workloads, such as, 1~2X improvement on 64K/512K BS
> > > > > IO test on loop with ramfs backing file.
> > > > > 
> > > > > Any comments are welcome!
> > > > > 
> > > > > V3:
> > > > > 	- fix build warning reported by kernel test robot
> > > > > 	- drop patch for checking fused flags on existed drivers with
> > > > > 	  ->uring_command(), which isn't necessary, since we do not do that
> > > > >        when adding new ioctl or uring command
> > > > >      - inline io_init_rq() for core code, so just export io_init_slave_req
> > > > > 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
> > > > > 	will be cleared
> > > > > 	- pass xfstest over ublk-loop
> > > > 
> > > > Hello Jens and Guys,
> > > > 
> > > > I have been working on io_uring zero copy support for ublk/fuse for a while, and
> > > > I appreciate you may share any thoughts on this patchset or approach?
> > > 
> > > I'm a bit split on this one, as I really like (and want) the feature.
> > > ublk has become popular pretty quickly, and it makes a LOT of sense to
> > > support zero copy for it. At the same time, I'm not really a huge fan of
> > > the fused commands... They seem too specialized to be useful for other
> > > things, and it'd be a shame to do something like that only for it later
> > > to be replaced by a generic solution. And then we're stuck with
> > > supporting fused commands forever, not sure I like that prospect.
> > > 
> > > Both Pavel and Xiaoguang voiced similar concerns, and I think it may be
> > > worth spending a bit more time on figuring out if splice can help us
> > > here. David Howells currently has a lot going on in that area too.
> > 
> > IMO, splice(->splice_read()) can help much less in this use case, and
> > I can't see improvement David Howells has done in this area:
> 
> Let me correct a misunderstanding I've seen a couple of times
> from people. Apart from the general idea of providing buffers, it's
> not that bound to splice. Yes, I reused splicing guts for that
> half-made POC, but we can add a new callback that would do it a
> bit nicer, i.e. better consolidating returned buffers. Would

->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).

> probably be even better to have both of them falling back to
> splice so it can cover more cases. The core of it is mediating
> buffers through io_uring's registered buffer table, which
> decouples all the components from each other.

For using pipe buffer's ->release() to release the whole buffer's
reference, you have to allocate one pipe for each fixed buffer, and add
pipe buffer to it, and keep each pipe buffer into the pipe
until it is consumed, since ->release() needs to be called when
unregistering buffer(all IOs are completed)

It(allocating/free pipe node, and populating it with each page) is
really inefficient for handling one single IO.

So re-using splice for this purpose is still bad not mention splice
can't support writeable spliced page.

Wiring device io buffer with context registered buffer table looks like
another approach, however:

1) two uring command OPs for registering/unregistering this buffer in io fast
path has to be added since only userspace can know when buffer(reference)
isn't needed

2) userspace becomes more complicated, 3+ OPs are required for handling one
single device IO

3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
for unregistering buffer

4) here the case is totally different with io_mapped_ubuf which isn't
related to any specific file, and just belong to io_uring context; however,
the device io buffer belongs to device(file) actually, so in theory it is wrong
to put it into context's registered buffer table, and supposed to put into
per-file buffer table which isn't supported by io_uring, or it becomes hard to
implement multiple-device io buffer in single context since 'file + buffer key'
has to be used to retrieve this buffer, probably xarray has to be
relied, but

	- here the index is (file, buffer key) if the table is per-context, current
	xarray only supports index with type of 'unsigned long', so looks not doable
	- or per-file xarray has to be used, then the implementation becomes more complicated
	- write to xarray has to be done two times in fast io path, so another factor which
	hurts performance.

> 
> > 1) we need to pass reference of the whole buffer from driver to io_uring,
> > which is missed in splice, which just deals with page reference; for
> > passing whole buffer reference, we have to apply per buffer pipe to
> > solve the problem, and this way is expensive since the pipe can't
> > be freed until all buffers are consumed.
> > 
> > 2) reference can't outlive the whole buffer, and splice still misses
> > mechanism to provide such guarantee; splice can just make sure that
> > page won't be gone if page reference is grabbed, but here we care
> > more the whole buffer & its (shared)references lifetime
> > 
> > 3) current ->splice_read() misses capability to provide writeable
> > reference to spliced page[2]; either we have to pass new flags
> > to ->splice_read() or passing back new pipe buf flags, unfortunately
> > Linus thought it isn't good to extend pipe/splice for such purpose,
> > and now I agree with Linus now.
> 
> It might be a non-workable option if we're thinking about splice(2)
> and pipes, but pipes and ->splice_read() are just internal details,
> an execution mechanism, and it's hidden from the userspace.

both pipe and ->splice_read() are really exposed to userspace, and are
used in other non-io_uring situations, so any change can not break
existed splice/pipe usage, maybe I misunderstand your point?

> 
> I guess someone might make a point that we don't want any changes
> to the splice code even if it doesn't affect splice(2) userspace
> users, but that's rather a part of development process.
> > I believe that Pavel has realized this point[3] too, and here the only
> > of value of using pipe is to reuse ->splice_read(), however, the above
> > points show that ->splice_read() isn't good at this purpose.
> 
> But agree that, ->splice_read() doesn't support the revers
> direction, i.e. a file (e.g. ublk) provides buffers for
> someone to write into it, that would need to be extended
> in some way.

Linus has objected[1] explicitly to extend it in this way:

	There's no point trying to deal with "if unexpectedly doing crazy
	things". If a sink writes the data, the sinkm is so unbelievably buggy
	that it's not even funny.

[1] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/

That is also the reason why fuse can only support write zero copy via splice
for 10+ years.

> 
> > [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/
> 
> Oops, missed this one
> 
> > [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> 
> Miklos said that it's better to signal the owner of buffer about
> completion, IIUC the way I was proposing, i.e. calling ->release
> when io_uring removes the buffer and all io_uring requests using
> it complete, should do exactly that.

->release() just for acking the page consumption, what the ublk needs is
to drop the whole buffer(represented by bvec) reference when the buffer isn't
used by normal OPs, actually similar with fuse's case, because buffer
reference can't outlive the buffer itself(repesented by bvec).

Yeah, probably releasing whole buffer reference can be done by ->release() in
very complicated way, but the whole pipe & pipe buffer has to be kept in
the whole IO lifetime for calling each pipe buffer's ->release(), so you have to
allocate one pipe when registering this buffer, and release it when un-registering
it. Much less efficient.

In short, splice can't help us for meeting ublk/fuse requirement.

Thanks, 
Ming


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9096CC00D
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjC1NCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjC1NCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 09:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C04FAD13
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 06:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680008496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QHrIT10U/HwbnbHfh15/xIUm76PzhuMWdcPTjn7QUWY=;
        b=PQrAYtROE7BPEE7YlV8vAwUyBaAfYb1ycrPPkzqlIcCJsCS7WuZfA4F/gitjolRfveOz3q
        bp8jP3w8qnm7xNUTNGH5ubcIlx1oS9DyuBtUpoKwGjPkbHmobkCWMRbgR20aiAAnc2Vuql
        3Ls4h1Yzk0a/5E5DGp0AenTKm/wdjTU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-_lVvkgUCNxe2LerOMgA4dw-1; Tue, 28 Mar 2023 09:01:33 -0400
X-MC-Unique: _lVvkgUCNxe2LerOMgA4dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76FBE884ECA;
        Tue, 28 Mar 2023 13:01:32 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A81D1121330;
        Tue, 28 Mar 2023 13:01:25 +0000 (UTC)
Date:   Tue, 28 Mar 2023 21:01:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
 <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
 <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 28, 2023 at 11:55:38AM +0100, Pavel Begunkov wrote:
> On 3/18/23 23:42, Ming Lei wrote:
> > On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
> > > On 3/18/23 13:35, Ming Lei wrote:
> > > > On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
> > > > > On 3/17/23 2:14?AM, Ming Lei wrote:
> > > > > > On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
> [...]
> > > > IMO, splice(->splice_read()) can help much less in this use case, and
> > > > I can't see improvement David Howells has done in this area:
> > > 
> > > Let me correct a misunderstanding I've seen a couple of times
> > > from people. Apart from the general idea of providing buffers, it's
> > > not that bound to splice. Yes, I reused splicing guts for that
> > > half-made POC, but we can add a new callback that would do it a
> > > bit nicer, i.e. better consolidating returned buffers. Would
> > 
> > ->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).
> > > probably be even better to have both of them falling back to
> > > splice so it can cover more cases. The core of it is mediating
> > > buffers through io_uring's registered buffer table, which
> > > decouples all the components from each other.
> > 
> > For using pipe buffer's ->release() to release the whole buffer's
> > reference, you have to allocate one pipe for each fixed buffer, and add
> > pipe buffer to it, and keep each pipe buffer into the pipe
> > until it is consumed, since ->release() needs to be called when
> > unregistering buffer(all IOs are completed)
> 
> What I'm saying is that I'm more concerned about the uapi,
> whether internally it's ->splice_read(). I think ->splice_read()
> has its merit in a hybrid approach, but simplicity let's say for
> we don't use it and there is a new f_op callback or it's
> it's returned with by cmd requests.

OK, then forget splice if you add new callback, isn't that what this
patchset(just reuse ->uring_cmd()) is doing? 

> 
> > It(allocating/free pipe node, and populating it with each page) is
> > really inefficient for handling one single IO.
> 
> It doesn't need pipe node allocation. We'd need to allocate
> space for pages, but again, there is a good io_uring infra
> for it without any single additional lock taken in most cases.

Then it is same with this patchset.

> 
> 
> > So re-using splice for this purpose is still bad not mention splice
> > can't support writeable spliced page.
> > 
> > Wiring device io buffer with context registered buffer table looks like
> > another approach, however:
> > 
> > 1) two uring command OPs for registering/unregistering this buffer in io fast
> > path has to be added since only userspace can know when buffer(reference)
> > isn't needed
> 
> Yes, that's a good point. Registration replaces fuse master cmd, so it's
> one extra request for unregister, which might be fine.

Unfortunately I don't think this way is good, the problem is that buffer
only has physical pages, and doesn't have userspace mapping, so why bother
to export it to userspace?

As I replied to Ziyang, the current fused command can be extended to
this way easily, but I don't know why we need to use the buffer registration,
given userspace can't read/write the buffer, and fused command can cover
it just fine.

> 
> > 2) userspace becomes more complicated, 3+ OPs are required for handling one
> > single device IO
> > 
> > 3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
> > we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
> > for unregistering buffer
> 
> It should not necessarily be a file.

At least in ublk's case, from io_uring viewpoint, the buffer is owned by
ublk device, so we need the device node or file for releasing the
buffer.

> 
> > 4) here the case is totally different with io_mapped_ubuf which isn't
> > related to any specific file, and just belong to io_uring context; however,
> > the device io buffer belongs to device(file) actually, so in theory it is wrong
> > to put it into context's registered buffer table, and supposed to put into
> 
> Not at all, it doesn't belong to io_uring but rather to the user space,
> without a file, right, but io_uring still only borrowing it.

How can one such buffer be owned by userspace? What if the userspace is
killed? If you think userspace can grab the buffer reference, that still
needs userspace to release the buffer, but that is unreliable, and
io_uring has to cover the buffer cleanup in case of userspace exit abnormally.

Because buffer lifetime is crossing multiple OPs if you implement buffer
register/unregister OPs. And there isn't such issue for fused command
which has same lifetime with the buffer.

> 
> As for keeping files, I predict that it'll be there anyway in some time,
> some p2pdma experiments, dma preregistration, all required having a file
> attached to the buffer.
> 
> > per-file buffer table which isn't supported by io_uring, or it becomes hard to
> > implement multiple-device io buffer in single context since 'file + buffer key'
> > has to be used to retrieve this buffer, probably xarray has to be
> > relied, but
> 
> I was proposing to give slot selection to the userspace, perhaps with
> optional auto index allocation as it's done with registered files.

As I mentioned above, it doesn't make sense to export buffer to
userspace which can't touch any data of the buffer at all.

> 
> > 	- here the index is (file, buffer key) if the table is per-context, current
> > 	xarray only supports index with type of 'unsigned long', so looks not doable
> > 	- or per-file xarray has to be used, then the implementation becomes more complicated
> > 	- write to xarray has to be done two times in fast io path, so another factor which
> > 	hurts performance.
> > 
> > > 
> > > > 1) we need to pass reference of the whole buffer from driver to io_uring,
> > > > which is missed in splice, which just deals with page reference; for
> > > > passing whole buffer reference, we have to apply per buffer pipe to
> > > > solve the problem, and this way is expensive since the pipe can't
> > > > be freed until all buffers are consumed.
> > > > 
> > > > 2) reference can't outlive the whole buffer, and splice still misses
> > > > mechanism to provide such guarantee; splice can just make sure that
> > > > page won't be gone if page reference is grabbed, but here we care
> > > > more the whole buffer & its (shared)references lifetime
> > > > 
> > > > 3) current ->splice_read() misses capability to provide writeable
> > > > reference to spliced page[2]; either we have to pass new flags
> > > > to ->splice_read() or passing back new pipe buf flags, unfortunately
> > > > Linus thought it isn't good to extend pipe/splice for such purpose,
> > > > and now I agree with Linus now.
> > > 
> > > It might be a non-workable option if we're thinking about splice(2)
> > > and pipes, but pipes and ->splice_read() are just internal details,
> > > an execution mechanism, and it's hidden from the userspace.
> > 
> > both pipe and ->splice_read() are really exposed to userspace, and are
> > used in other non-io_uring situations, so any change can not break
> > existed splice/pipe usage, maybe I misunderstand your point?
> 
> Oh, I meant reusing some of splice bits but not changing splice(2).
> E.g. a kernel internal flag which is not allowed to be passed into
> splice(2).
> 
> 
> > > I guess someone might make a point that we don't want any changes
> > > to the splice code even if it doesn't affect splice(2) userspace
> > > users, but that's rather a part of development process.
> > > > I believe that Pavel has realized this point[3] too, and here the only
> > > > of value of using pipe is to reuse ->splice_read(), however, the above
> > > > points show that ->splice_read() isn't good at this purpose.
> > > 
> > > But agree that, ->splice_read() doesn't support the revers
> > > direction, i.e. a file (e.g. ublk) provides buffers for
> > > someone to write into it, that would need to be extended
> > > in some way.
> > 
> > Linus has objected[1] explicitly to extend it in this way:
> > 
> > 	There's no point trying to deal with "if unexpectedly doing crazy
> > 	things". If a sink writes the data, the sinkm is so unbelievably buggy
> > 	that it's not even funny.
> 
> As far as I can see, Linus doesn't like there that the semantics
> is not clear. "sink writes data" and writing to pages provided
> by ->splice_read() don't sound right indeed.
> 
> I might be wrong but it appears that the semantics was ublk
> lending an "empty" buffer to another file, which will fill it
> in and return back the data by calling some sort of ->release
> callback, then ublk consumes the data.

Yes, that is exactly what fused command is doing.

> 
> 
> > [1] https://lore.kernel.org/linux-block/CAHk-=wgJsi7t7YYpuo6ewXGnHz2nmj67iWR6KPGoz5TBu34mWQ@mail.gmail.com/
> > 
> > That is also the reason why fuse can only support write zero copy via splice
> > for 10+ years.
> > 
> > > 
> > > > [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/
> > > 
> > > Oops, missed this one
> > > 
> > > > [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> > > 
> > > Miklos said that it's better to signal the owner of buffer about
> > > completion, IIUC the way I was proposing, i.e. calling ->release
> > > when io_uring removes the buffer and all io_uring requests using
> > > it complete, should do exactly that.
> > 
> > ->release() just for acking the page consumption, what the ublk needs is
> > to drop the whole buffer(represented by bvec) reference when the buffer isn't
> > used by normal OPs, actually similar with fuse's case, because buffer
> > reference can't outlive the buffer itself(repesented by bvec).
> > 
> > Yeah, probably releasing whole buffer reference can be done by ->release() in
> > very complicated way, but the whole pipe & pipe buffer has to be kept in
> > the whole IO lifetime for calling each pipe buffer's ->release(), so you have to
> > allocate one pipe when registering this buffer, and release it when un-registering
> > it. Much less efficient.
> 
> As per noted above, We don't necessarily have to stick with splice_read()
> and pipe callbacks.

As I mentioned, it is basically what fused command is doing.


Thanks,
Ming


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA08A6CD8E8
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjC2L5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC2L5F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 07:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A1E4EC7
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 04:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680090927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RxTYRUFHq/F9oqWPhcdyN86fLW5mAQU10Q+OpnH7u8c=;
        b=VRzhMYgBWoENRoah/G1WUkUFEWmrC14SiXlfY28k+UQrXFRftGlUNmXg3XiUnQXvc//yea
        d4ND4fXRN/B/wfrXrITBPQsX0zXOUcqXtgjX/rPFMBU18QYlW6lz86gXbr1J7Xgn09L3bl
        XoBAsnqJeiSaOYYBZiSbgdQh2t+/+ug=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-7Tz7ATq0PIqze14-zqZbcg-1; Wed, 29 Mar 2023 07:55:23 -0400
X-MC-Unique: 7Tz7ATq0PIqze14-zqZbcg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01A12280604C;
        Wed, 29 Mar 2023 11:55:23 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00A74492C3E;
        Wed, 29 Mar 2023 11:55:16 +0000 (UTC)
Date:   Wed, 29 Mar 2023 19:55:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZCQnHwrXvSOQHfAC@ovpn-8-26.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
 <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
 <ZBZJXb6vQ7z4CYk/@ovpn-8-18.pek2.redhat.com>
 <8b227cf3-6ad1-59ad-e13b-a46381958a4c@gmail.com>
 <ZCLlIAnBWOm59rIM@ovpn-8-20.pek2.redhat.com>
 <ac0c51aa-7240-94b9-476a-9401911ee481@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0c51aa-7240-94b9-476a-9401911ee481@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 29, 2023 at 11:43:41AM +0100, Pavel Begunkov wrote:
> On 3/28/23 14:01, Ming Lei wrote:
> > On Tue, Mar 28, 2023 at 11:55:38AM +0100, Pavel Begunkov wrote:
> > > On 3/18/23 23:42, Ming Lei wrote:
> > > > On Sat, Mar 18, 2023 at 04:51:14PM +0000, Pavel Begunkov wrote:
> > > > > On 3/18/23 13:35, Ming Lei wrote:
> > > > > > On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
> > > > > > > On 3/17/23 2:14?AM, Ming Lei wrote:
> > > > > > > > On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
> > > [...]
> > > > > > IMO, splice(->splice_read()) can help much less in this use case, and
> > > > > > I can't see improvement David Howells has done in this area:
> > > > > 
> > > > > Let me correct a misunderstanding I've seen a couple of times
> > > > > from people. Apart from the general idea of providing buffers, it's
> > > > > not that bound to splice. Yes, I reused splicing guts for that
> > > > > half-made POC, but we can add a new callback that would do it a
> > > > > bit nicer, i.e. better consolidating returned buffers. Would
> > > > 
> > > > ->release() is for releasing pipe-buffer(page), instead of the whole buffer(reference).
> > > > > probably be even better to have both of them falling back to
> > > > > splice so it can cover more cases. The core of it is mediating
> > > > > buffers through io_uring's registered buffer table, which
> > > > > decouples all the components from each other.
> > > > 
> > > > For using pipe buffer's ->release() to release the whole buffer's
> > > > reference, you have to allocate one pipe for each fixed buffer, and add
> > > > pipe buffer to it, and keep each pipe buffer into the pipe
> > > > until it is consumed, since ->release() needs to be called when
> > > > unregistering buffer(all IOs are completed)
> > > 
> > > What I'm saying is that I'm more concerned about the uapi,
> > > whether internally it's ->splice_read(). I think ->splice_read()
> > > has its merit in a hybrid approach, but simplicity let's say for
> > > we don't use it and there is a new f_op callback or it's
> > > it's returned with by cmd requests.
> > 
> > OK, then forget splice if you add new callback, isn't that what this
> > patchset(just reuse ->uring_cmd()) is doing?
> 
> It certainly similar in many aspects! And it's also similar to
> splicing with pipes, just instead of pipes there is io_uring and,

It is definitely different with pipe/splice, which works on page lifetime, but
here we need to focus on the whole buffer lifetime.

> of course, semantics changes. The idea is to decouple requests from
> each other with a different uapi.

The only difference is that buffer registration can use current ->buffer_idx
interface, and fused command uses normal uapi interface by passing
buffer offset/len via sqe->addr & sqe->len to locate buffer in primary
command. That should be the decouple. But not sure if the difference matters.

Even though I am not sure if it is doable, because:

- only 1 sqe flag is left, and how to differentiate this buffer
  registration with normal fixed buffer

- unregister buffer OP may not be called because of task exit
  abnormally, so io_uring has to take care of the cleanup, so
  file/command data needs to be saved somewhere for the cleanup,
  since buffer belongs to device, both register and unregister should
  call into device via uring command, see details below

Also there are other performance effects from buffer registration:

1) one extra OP of unregister is needed in io code path

2) boundary in buffer register & OPs & buffer unregister have to be
linked since there are dependencies among the three(register, OPs,
unregister)

> 
> > > > It(allocating/free pipe node, and populating it with each page) is
> > > > really inefficient for handling one single IO.
> > > 
> > > It doesn't need pipe node allocation. We'd need to allocate
> > > space for pages, but again, there is a good io_uring infra
> > > for it without any single additional lock taken in most cases.
> > 
> > Then it is same with this patchset.
> > 
> > > 
> > > 
> > > > So re-using splice for this purpose is still bad not mention splice
> > > > can't support writeable spliced page.
> > > > 
> > > > Wiring device io buffer with context registered buffer table looks like
> > > > another approach, however:
> > > > 
> > > > 1) two uring command OPs for registering/unregistering this buffer in io fast
> > > > path has to be added since only userspace can know when buffer(reference)
> > > > isn't needed
> > > 
> > > Yes, that's a good point. Registration replaces fuse master cmd, so it's
> > > one extra request for unregister, which might be fine.
> > 
> > Unfortunately I don't think this way is good, the problem is that buffer
> > only has physical pages, and doesn't have userspace mapping, so why bother
> > to export it to userspace?
> > 
> > As I replied to Ziyang, the current fused command can be extended to
> > this way easily, but I don't know why we need to use the buffer registration,
> > given userspace can't read/write the buffer, and fused command can cover
> > it just fine.
> 
> I probably mentioned it before, but that's where we need a new memcpy
> io_uring request type, to partially copy it, e.g. headers. I think people
> mentioned memcpy before in general, and it will also be used for DMA driven
> copies if Keith returns back to experiments.
> 
> Apart from it and things like broadcasting, sending different chunks to
> different places and so, there is a typical problem what to do when the
> second operation fails but the data has already been received, mostly
> relevant to sockets / streams.

OK, but the new copy OP can work with both fused command and buffer registration
if it is involved, and buffer register isn't a must given the interface
needs to support plain offset/len way.

> 
> > > > 2) userspace becomes more complicated, 3+ OPs are required for handling one
> > > > single device IO
> > > > 
> > > > 3) buffer reference crosses multiple OPs, for cleanup the registered buffer,
> > > > we have to store the device file & "buffer key" in each buffer(such as io_uring_bvec_buf)
> > > > for unregistering buffer
> > > 
> > > It should not necessarily be a file.
> > 
> > At least in ublk's case, from io_uring viewpoint, the buffer is owned by
> > ublk device, so we need the device node or file for releasing the
> > buffer.
> 
> For example, io_uring has a lightweight way to pin the context
> (pcpu refcount). I haven't looked into ublk code, it's hard for
> me to argue about it.

The buffer(generic bio/bvec pages) is originated from generic application which
submits IO to /dev/ublkbN(block device), or page cache, and io_uring borrows the
buffer via uring command on /dev/ublkbcN(pair device of /dev/ublkbN).

> 
> > > > 4) here the case is totally different with io_mapped_ubuf which isn't
> > > > related to any specific file, and just belong to io_uring context; however,
> > > > the device io buffer belongs to device(file) actually, so in theory it is wrong
> > > > to put it into context's registered buffer table, and supposed to put into
> > > 
> > > Not at all, it doesn't belong to io_uring but rather to the user space,
> > > without a file, right, but io_uring still only borrowing it.
> > 
> > How can one such buffer be owned by userspace? What if the userspace is
> > killed? If you think userspace can grab the buffer reference, that still
> > needs userspace to release the buffer, but that is unreliable, and
> > io_uring has to cover the buffer cleanup in case of userspace exit abnormally.
> 
> Conceptually userspace owns buffers and io_uring is share / borrowing it.
> Probably, I misunderstood and you was talking about refcounting or something
> else. Can you elaborate? As for references, io_uring pins normal buffers
> and so holds additional refs.

We need one uring command on /dev/ublkcN to get the buffer, and the
buffer needs to be return back after we run OPs with the buffer.

Follows difference between the two approaches:

1) fused command
- the buffer lifetime is same with the primary command which is
  completed after all secondary OPs are completed with the buffer,
  so driver gets notified after we use the buffer which belongs to
  /dev/ublkcN

2) buffer registration

- one uring command to get the buffer from /dev/ublkcN and register it
  into io_uring

- submit OPs with the buffer

- unregister the buffer after all above OPs are done, which still needs
one uring command on /dev/ulkbcN

That is why I mentioned it is hard to handle buffer cleanup after
userspace exits abnormally with buffer registration.

> 
> > Because buffer lifetime is crossing multiple OPs if you implement buffer
> > register/unregister OPs. And there isn't such issue for fused command
> > which has same lifetime with the buffer.
> > 
> > > 
> > > As for keeping files, I predict that it'll be there anyway in some time,
> > > some p2pdma experiments, dma preregistration, all required having a file
> > > attached to the buffer.
> > > 
> > > > per-file buffer table which isn't supported by io_uring, or it becomes hard to
> > > > implement multiple-device io buffer in single context since 'file + buffer key'
> > > > has to be used to retrieve this buffer, probably xarray has to be
> > > > relied, but
> > > 
> > > I was proposing to give slot selection to the userspace, perhaps with
> > > optional auto index allocation as it's done with registered files.
> > 
> > As I mentioned above, it doesn't make sense to export buffer to
> > userspace which can't touch any data of the buffer at all.
> 
> replied above.

buffer register isn't a must for new io_uring memcpy OP, we can just
copy with offset/len & the "buffer".


Thanks,
Ming


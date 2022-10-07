Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0E5F7756
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJGLWK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 07:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJGLWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 07:22:07 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FFFCF1B8
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 04:22:04 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y100so6582995ede.6
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 04:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DixBaSnqkPBBtpUYdAsSR8GQ/t8LkPr+Nw1KPDi7uoY=;
        b=btpz+9NwHTht9XRJijdsLBCR5mkTKEPy7fniLEhQAX6v5bcJQix3nbfG/xmDCr4IxI
         Gmo7ymg1NKCYc6E0QxCvjIfKxRNCv6TbwxRdFh8lw+itDKFTNVmRd5KcFPjGMDm8ZILs
         BS3r5S8Rvc9Cykkrkz0sjPQXnxaR0+dKhs07fI85Rg93ls4W78Y741FspYGZhC6i4iBx
         VibjcJqaiziUh6SWrdd7WyIsCBv2AlaIsBuSk/Oysz/9s60rM3ATkBVrktrJU19DGQbq
         DDCqIcSk0EQtzGvCIoaYtXqhGCNrzNBT4dFsq3Z/2bjoulHhNjPLZrBpF0HYn0ad8n1J
         kZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DixBaSnqkPBBtpUYdAsSR8GQ/t8LkPr+Nw1KPDi7uoY=;
        b=3aAqtaUKzyIUq1Cyji1MV9BOzQ3P+Y4uJKnTH4CqUfc63MjRoMskLbEYcnft7uhGcR
         UE6rTS+TiM2HVM01pxfpqEMAKCcUPFvJps17QBZAIFU9aCU9qERD8dPh0CiWElb04igb
         /0ZARvwor28N+GAJiC+1y2jbX2ywKVqdZOmrZZBrrvC/Hxth1H0LzbakwFGYn2GYRUoA
         lx2vSMy7htOCeuwhDzk96vepQ2kASE8rqDYBtTyUN5UrnF5cD4HHcjlJd0a1OvyxXf3V
         o3vQ8JOtZk8ruSdtj0dXA3w/J8kF68gT4BiurySOsbZsPrFnfLtTkZ6qIIu662pqvH9z
         avcA==
X-Gm-Message-State: ACrzQf1QHUvYZtp8PWRfd4JN7jMkGMVD4PUGdBY4s4yELCmOw6Zn7tmz
        0KB6VsTM8AvwSs3UeMllxdtSMjaIZ7k7eHD1wYv+
X-Google-Smtp-Source: AMsMyM7puYyJ6q18hmJpMYFjKXvuNOOHEoxv3zIKBU+yOae4s4I+Qfr+jszKcvkVKXZ32tNCs9AfLxyESLGqJ6ylewg=
X-Received: by 2002:a05:6402:5024:b0:440:e4ad:f7b6 with SMTP id
 p36-20020a056402502400b00440e4adf7b6mr4134926eda.358.1665141723300; Fri, 07
 Oct 2022 04:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590> <CAJSP0QUQgA8Az3Kx8-6ynbWxDxaSVW3xWOPj4VBPhhUhsRYT9g@mail.gmail.com>
 <Yz668hfMAuES2/lt@T590> <CACycT3t346g2gc9anp_T8vz5=9ds=NAGJhcSU8T2EmyCNuDCSw@mail.gmail.com>
 <Y0AEpCWzXmupJ8K3@T590>
In-Reply-To: <Y0AEpCWzXmupJ8K3@T590>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 7 Oct 2022 19:21:51 +0800
Message-ID: <CACycT3spcuGaxBBNksz3oi3AfHSPbZPObrL3TaZjpoGyrHUspg@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 7, 2022 at 6:51 PM Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Fri, Oct 07, 2022 at 06:04:29PM +0800, Yongji Xie wrote:
> > On Thu, Oct 6, 2022 at 7:24 PM Ming Lei <tom.leiming@gmail.com> wrote:
> > >
> > > On Wed, Oct 05, 2022 at 08:21:45AM -0400, Stefan Hajnoczi wrote:
> > > > On Wed, 5 Oct 2022 at 00:19, Ming Lei <tom.leiming@gmail.com> wrote:
> > > > >
> > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > > > > On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > > > > > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > > > > > ublk-qcow2 is available now.
> > > > > > > >
> > > > > > > > Cool, thanks for sharing!
> > > > > > > >
> > > > > > > > >
> > > > > > > > > So far it provides basic read/write function, and compression and snapshot
> > > > > > > > > aren't supported yet. The target/backend implementation is completely
> > > > > > > > > based on io_uring, and share the same io_uring with ublk IO command
> > > > > > > > > handler, just like what ublk-loop does.
> > > > > > > > >
> > > > > > > > > Follows the main motivations of ublk-qcow2:
> > > > > > > > >
> > > > > > > > > - building one complicated target from scratch helps libublksrv APIs/functions
> > > > > > > > >   become mature/stable more quickly, since qcow2 is complicated and needs more
> > > > > > > > >   requirement from libublksrv compared with other simple ones(loop, null)
> > > > > > > > >
> > > > > > > > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > > > > > > > >   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > > > > > > >   might useful be for covering requirement in this field
> > > > > > > > >
> > > > > > > > > - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > > > > > > > >   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > > > > > > > >   is started
> > > > > > > > >
> > > > > > > > > - help to abstract common building block or design pattern for writing new ublk
> > > > > > > > >   target/backend
> > > > > > > > >
> > > > > > > > > So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > > > > > > > device as TEST_DEV, and kernel building workload is verified too. Also
> > > > > > > > > soft update approach is applied in meta flushing, and meta data
> > > > > > > > > integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > > > > > > > test, and only cluster leak is reported during this test.
> > > > > > > > >
> > > > > > > > > The performance data looks much better compared with qemu-nbd, see
> > > > > > > > > details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > > > > > > > empty image and pre-allocated image, for example of pre-allocated qcow2
> > > > > > > > > image(8GB):
> > > > > > > > >
> > > > > > > > > - qemu-nbd (make test T=qcow2/002)
> > > > > > > >
> > > > > > > > Single queue?
> > > > > > >
> > > > > > > Yeah.
> > > > > > >
> > > > > > > >
> > > > > > > > >     randwrite(4k): jobs 1, iops 24605
> > > > > > > > >     randread(4k): jobs 1, iops 30938
> > > > > > > > >     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > > > > > >     rw(512k): jobs 1, iops read 724 write 728
> > > > > > > >
> > > > > > > > Please try qemu-storage-daemon's VDUSE export type as well. The
> > > > > > > > command-line should be similar to this:
> > > > > > > >
> > > > > > > >   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> > > > > > >
> > > > > > > Not found virtio_vdpa module even though I enabled all the following
> > > > > > > options:
> > > > > > >
> > > > > > >         --- vDPA drivers
> > > > > > >           <M>   vDPA device simulator core
> > > > > > >           <M>     vDPA simulator for networking device
> > > > > > >           <M>     vDPA simulator for block device
> > > > > > >           <M>   VDUSE (vDPA Device in Userspace) support
> > > > > > >           <M>   Intel IFC VF vDPA driver
> > > > > > >           <M>   Virtio PCI bridge vDPA driver
> > > > > > >           <M>   vDPA driver for Alibaba ENI
> > > > > > >
> > > > > > > BTW, my test environment is VM and the shared data is done in VM too, and
> > > > > > > can virtio_vdpa be used inside VM?
> > > > > >
> > > > > > I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > > > >
> > > > > > virtio_vdpa is available inside guests too. Please check that
> > > > > > VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> > > > > > drivers" menu.
> > > > > >
> > > > > > >
> > > > > > > >   # modprobe vduse
> > > > > > > >   # qemu-storage-daemon \
> > > > > > > >       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> > > > > > > >       --blockdev qcow2,file=file,node-name=qcow2 \
> > > > > > > >       --object iothread,id=iothread0 \
> > > > > > > >       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> > > > > > > >   # vdpa dev add name vduse0 mgmtdev vduse
> > > > > > > >
> > > > > > > > A virtio-blk device should appear and xfstests can be run on it
> > > > > > > > (typically /dev/vda unless you already have other virtio-blk devices).
> > > > > > > >
> > > > > > > > Afterwards you can destroy the device using:
> > > > > > > >
> > > > > > > >   # vdpa dev del vduse0
> > > > > > > >
> > > > > > > > >
> > > > > > > > > - ublk-qcow2 (make test T=qcow2/022)
> > > > > > > >
> > > > > > > > There are a lot of other factors not directly related to NBD vs ublk. In
> > > > > > > > order to get an apples-to-apples comparison with qemu-* a ublk export
> > > > > > > > type is needed in qemu-storage-daemon. That way only the difference is
> > > > > > > > the ublk interface and the rest of the code path is identical, making it
> > > > > > > > possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > > > > >
> > > > > > > Maybe not true.
> > > > > > >
> > > > > > > ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> > > > > > > and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> > > > > > > command.
> > > > > >
> > > > > > qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > > > >
> > > > > I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.
> > > > >
> > > > > > know whether the benchmark demonstrates that ublk is faster than NBD,
> > > > > > that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > > > > > whether there are miscellaneous implementation differences between
> > > > > > ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> > > > > > ublk and backend IO), or something else.
> > > > >
> > > > > The theory shouldn't be too complicated:
> > > > >
> > > > > 1) io uring passthough(pt) communication is fast than socket, and io command
> > > > > is carried over io_uring pt commands, and should be fast than virio
> > > > > communication too.
> > > > >
> > > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
> > > > > by io_uring.
> > > > >
> > > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> > > > >
> > > > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > > > backend IOs, so batching handling is common, and it is easy to see
> > > > > dozens of IOs/io commands handled in single syscall, or even more.
> > > >
> > > > I agree with the theory but theory has to be tested through
> > > > experiments in order to validate it. We can all learn from systematic
> > > > performance analysis - there might even be bottlenecks in ublk that
> > > > can be solved to improve performance further.
> > >
> > > Indeed, one thing is that ublk uses get user pages to retrieve user pages
> > > for copying data, this way may add latency for big chunk IO, since
> > > latency of get user pages should be increased linearly by nr_pages.
> > >
> > > I looked into vduse code a bit too, and vduse still needs the page copy,
> > > but lots of bounce pages are allocated and cached in the whole device
> > > lifetime, this way can void the latency for retrieving & allocating
> > > pages runtime with cost of extra memory consumption. Correct me
> > > if it is wrong, Xie Yongji or anyone?
> > >
> >
> > Yes, you are right. Another way is registering the preallocated
> > userspace memory as bounce buffer.
>
> Thanks for the clarification.
>
> IMO, the pages consumption is too much for vduse, each vdpa device
> has one vduse_iova_domain which may allocate 64K bounce pages at most,
> and these pages won't be freed until freeing the device.
>

Yes, actually in our initial design, this can be mitigated by some
memory reclaim mechanism and zero copy support. Even we can let
multiple vdpa device share one iova domain.

Thanks,
Yongji

> But it is one solution for implementing generic userspace device(not
> limit to block device), and this idea seems great.
>
>
>
>
> Thanks,
> Ming

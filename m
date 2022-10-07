Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB25F775D
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJGLXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 07:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJGLXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 07:23:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62863371B0;
        Fri,  7 Oct 2022 04:23:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c24so4285519plo.3;
        Fri, 07 Oct 2022 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0IsG1YjKcULf4Nro1hHc2xEi7JQ0Xjyl104t6tkNu1U=;
        b=AVAZZesdmryCIbohOMrm8au7sWxAxWehrAxtDpd6qkIKl0ssVJ9lOYx60+LGDB3b4Q
         nLgdqhDWBRYX6GvkdFEcJeHTdjvXxlK0ATPwjtIko7H0UlG7UAQS3sRuI5+pdDj8xHn7
         ySoUk17tZe0pmYT8XE/vhrXgsI0xs29NYV9CjZBc+r5IBhVyWzcCzA77IG2Q3uE54sG0
         u0vz+5nnn3hH1Klu4wZ2P7ZjNdw70W+bCZJY855h2YTRcTGCN89++UzHcLlPEwutwLdV
         6lt1X+HthpUm7euOrvkDTfV2IM4MUNFBoYDS2foGii4YXc8jA3DUNLlvZiLesNYmninG
         RKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IsG1YjKcULf4Nro1hHc2xEi7JQ0Xjyl104t6tkNu1U=;
        b=wc1QpQs0hYVDpHCER/0s67wxT+evGX3wmOtrVuJ8VEtkQHVGKdu9945MiQuy2Uv31e
         NnpNx7jWKEuWZrC4zJQNcERDSXWKcJ3e9fZaPXA8+X1dVYpEJYENMuaOiRgj7uv429bI
         R50Ku1vHZN1q5nkjnb4W+Q6SNQFM5nXBcBTUQib6RSsW9IbJ5lhFiObByKxu8eCv3RRq
         txPEuRM5QTUGQ+69kVXvm9+IjiKzDna3yHcRlCDMoXgUXLz2VpUT4QVZuae8ubzAHGGt
         f3YAGUF6Gn8aw/Ip3yiMjTKYgvnsgS9rQumjkIzTQfsToCBw0OaTKuDITBrvOSFHUQTQ
         n/qQ==
X-Gm-Message-State: ACrzQf3d3zsYQpHA9zdN4wg24q6Qsoklobj060PVvaFm8Jc0ZyYXHmNx
        6WgXcYbTB+wX9nGP3FS0uwE=
X-Google-Smtp-Source: AMsMyM7U/3Qo92MsX5rzu23y9kLajXW8std3X4f3PURpPdBUvE9uVubW85XmFae67O38CnQB+1Az4A==
X-Received: by 2002:a17:903:1ce:b0:178:80f1:c4c7 with SMTP id e14-20020a17090301ce00b0017880f1c4c7mr4358772plh.27.1665141821829;
        Fri, 07 Oct 2022 04:23:41 -0700 (PDT)
Received: from T590 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k9-20020a654649000000b00434e1d3b2ecsm1430545pgr.79.2022.10.07.04.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 04:23:41 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:23:34 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y0AMNo7DXxOBDX2T@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <Yz0FrzJVZTqlQtJ5@T590>
 <CAJSP0QUQgA8Az3Kx8-6ynbWxDxaSVW3xWOPj4VBPhhUhsRYT9g@mail.gmail.com>
 <Yz668hfMAuES2/lt@T590>
 <CACycT3t346g2gc9anp_T8vz5=9ds=NAGJhcSU8T2EmyCNuDCSw@mail.gmail.com>
 <Y0AEpCWzXmupJ8K3@T590>
 <CACycT3spcuGaxBBNksz3oi3AfHSPbZPObrL3TaZjpoGyrHUspg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3spcuGaxBBNksz3oi3AfHSPbZPObrL3TaZjpoGyrHUspg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 07, 2022 at 07:21:51PM +0800, Yongji Xie wrote:
> On Fri, Oct 7, 2022 at 6:51 PM Ming Lei <tom.leiming@gmail.com> wrote:
> >
> > On Fri, Oct 07, 2022 at 06:04:29PM +0800, Yongji Xie wrote:
> > > On Thu, Oct 6, 2022 at 7:24 PM Ming Lei <tom.leiming@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 05, 2022 at 08:21:45AM -0400, Stefan Hajnoczi wrote:
> > > > > On Wed, 5 Oct 2022 at 00:19, Ming Lei <tom.leiming@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > > > > > On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > > > > > > > > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > > > > > > > > ublk-qcow2 is available now.
> > > > > > > > >
> > > > > > > > > Cool, thanks for sharing!
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > So far it provides basic read/write function, and compression and snapshot
> > > > > > > > > > aren't supported yet. The target/backend implementation is completely
> > > > > > > > > > based on io_uring, and share the same io_uring with ublk IO command
> > > > > > > > > > handler, just like what ublk-loop does.
> > > > > > > > > >
> > > > > > > > > > Follows the main motivations of ublk-qcow2:
> > > > > > > > > >
> > > > > > > > > > - building one complicated target from scratch helps libublksrv APIs/functions
> > > > > > > > > >   become mature/stable more quickly, since qcow2 is complicated and needs more
> > > > > > > > > >   requirement from libublksrv compared with other simple ones(loop, null)
> > > > > > > > > >
> > > > > > > > > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > > > > > > > > >   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > > > > > > > > >   might useful be for covering requirement in this field
> > > > > > > > > >
> > > > > > > > > > - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > > > > > > > > >   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > > > > > > > > >   is started
> > > > > > > > > >
> > > > > > > > > > - help to abstract common building block or design pattern for writing new ublk
> > > > > > > > > >   target/backend
> > > > > > > > > >
> > > > > > > > > > So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > > > > > > > > device as TEST_DEV, and kernel building workload is verified too. Also
> > > > > > > > > > soft update approach is applied in meta flushing, and meta data
> > > > > > > > > > integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > > > > > > > > test, and only cluster leak is reported during this test.
> > > > > > > > > >
> > > > > > > > > > The performance data looks much better compared with qemu-nbd, see
> > > > > > > > > > details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > > > > > > > > empty image and pre-allocated image, for example of pre-allocated qcow2
> > > > > > > > > > image(8GB):
> > > > > > > > > >
> > > > > > > > > > - qemu-nbd (make test T=qcow2/002)
> > > > > > > > >
> > > > > > > > > Single queue?
> > > > > > > >
> > > > > > > > Yeah.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > >     randwrite(4k): jobs 1, iops 24605
> > > > > > > > > >     randread(4k): jobs 1, iops 30938
> > > > > > > > > >     randrw(4k): jobs 1, iops read 13981 write 14001
> > > > > > > > > >     rw(512k): jobs 1, iops read 724 write 728
> > > > > > > > >
> > > > > > > > > Please try qemu-storage-daemon's VDUSE export type as well. The
> > > > > > > > > command-line should be similar to this:
> > > > > > > > >
> > > > > > > > >   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
> > > > > > > >
> > > > > > > > Not found virtio_vdpa module even though I enabled all the following
> > > > > > > > options:
> > > > > > > >
> > > > > > > >         --- vDPA drivers
> > > > > > > >           <M>   vDPA device simulator core
> > > > > > > >           <M>     vDPA simulator for networking device
> > > > > > > >           <M>     vDPA simulator for block device
> > > > > > > >           <M>   VDUSE (vDPA Device in Userspace) support
> > > > > > > >           <M>   Intel IFC VF vDPA driver
> > > > > > > >           <M>   Virtio PCI bridge vDPA driver
> > > > > > > >           <M>   vDPA driver for Alibaba ENI
> > > > > > > >
> > > > > > > > BTW, my test environment is VM and the shared data is done in VM too, and
> > > > > > > > can virtio_vdpa be used inside VM?
> > > > > > >
> > > > > > > I hope Xie Yongji can help explain how to benchmark VDUSE.
> > > > > > >
> > > > > > > virtio_vdpa is available inside guests too. Please check that
> > > > > > > VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
> > > > > > > drivers" menu.
> > > > > > >
> > > > > > > >
> > > > > > > > >   # modprobe vduse
> > > > > > > > >   # qemu-storage-daemon \
> > > > > > > > >       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> > > > > > > > >       --blockdev qcow2,file=file,node-name=qcow2 \
> > > > > > > > >       --object iothread,id=iothread0 \
> > > > > > > > >       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> > > > > > > > >   # vdpa dev add name vduse0 mgmtdev vduse
> > > > > > > > >
> > > > > > > > > A virtio-blk device should appear and xfstests can be run on it
> > > > > > > > > (typically /dev/vda unless you already have other virtio-blk devices).
> > > > > > > > >
> > > > > > > > > Afterwards you can destroy the device using:
> > > > > > > > >
> > > > > > > > >   # vdpa dev del vduse0
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > - ublk-qcow2 (make test T=qcow2/022)
> > > > > > > > >
> > > > > > > > > There are a lot of other factors not directly related to NBD vs ublk. In
> > > > > > > > > order to get an apples-to-apples comparison with qemu-* a ublk export
> > > > > > > > > type is needed in qemu-storage-daemon. That way only the difference is
> > > > > > > > > the ublk interface and the rest of the code path is identical, making it
> > > > > > > > > possible to compare NBD, VDUSE, ublk, etc more precisely.
> > > > > > > >
> > > > > > > > Maybe not true.
> > > > > > > >
> > > > > > > > ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> > > > > > > > and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> > > > > > > > command.
> > > > > > >
> > > > > > > qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
> > > > > >
> > > > > > I tried to use it via --aio=io_uring for setting up qemu-nbd, but not succeed.
> > > > > >
> > > > > > > know whether the benchmark demonstrates that ublk is faster than NBD,
> > > > > > > that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
> > > > > > > whether there are miscellaneous implementation differences between
> > > > > > > ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
> > > > > > > ublk and backend IO), or something else.
> > > > > >
> > > > > > The theory shouldn't be too complicated:
> > > > > >
> > > > > > 1) io uring passthough(pt) communication is fast than socket, and io command
> > > > > > is carried over io_uring pt commands, and should be fast than virio
> > > > > > communication too.
> > > > > >
> > > > > > 2) io uring io handling is fast than libaio which is taken in the
> > > > > > test on qemu-nbd, and all qcow2 backend io(include meta io) is handled
> > > > > > by io_uring.
> > > > > >
> > > > > > https://github.com/ming1/ubdsrv/blob/master/tests/common/qcow2_common
> > > > > >
> > > > > > 3) ublk uses one single io_uring to handle all io commands and qcow2
> > > > > > backend IOs, so batching handling is common, and it is easy to see
> > > > > > dozens of IOs/io commands handled in single syscall, or even more.
> > > > >
> > > > > I agree with the theory but theory has to be tested through
> > > > > experiments in order to validate it. We can all learn from systematic
> > > > > performance analysis - there might even be bottlenecks in ublk that
> > > > > can be solved to improve performance further.
> > > >
> > > > Indeed, one thing is that ublk uses get user pages to retrieve user pages
> > > > for copying data, this way may add latency for big chunk IO, since
> > > > latency of get user pages should be increased linearly by nr_pages.
> > > >
> > > > I looked into vduse code a bit too, and vduse still needs the page copy,
> > > > but lots of bounce pages are allocated and cached in the whole device
> > > > lifetime, this way can void the latency for retrieving & allocating
> > > > pages runtime with cost of extra memory consumption. Correct me
> > > > if it is wrong, Xie Yongji or anyone?
> > > >
> > >
> > > Yes, you are right. Another way is registering the preallocated
> > > userspace memory as bounce buffer.
> >
> > Thanks for the clarification.
> >
> > IMO, the pages consumption is too much for vduse, each vdpa device
> > has one vduse_iova_domain which may allocate 64K bounce pages at most,
> > and these pages won't be freed until freeing the device.
> >
> 
> Yes, actually in our initial design, this can be mitigated by some
> memory reclaim mechanism and zero copy support. Even we can let
> multiple vdpa device share one iova domain.

I think zero copy is great, especially for big chunk IO request.

Thanks,
Ming

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7145F44D6
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 15:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJDNxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 09:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiJDNxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 09:53:48 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9222256B9B;
        Tue,  4 Oct 2022 06:53:45 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id e20so2354571ybh.2;
        Tue, 04 Oct 2022 06:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Hs3jvXYRoW9cue3NWCTKTBo720DcB8K81r/kuPpiKLg=;
        b=NKVA9fTuWcg09Dku5bT/SxrAfaWTl4KWWCzK5e1YEmWxMcBMAtGeke6u6Uzeys0MpG
         orqbTldkVSP4mEZ8pETdfFsIDjm3bdLtsGBnnVcs/0AXfagv8f4hTMz5TA+pYUNezVR9
         x8B+dJxYJ2XAwOxtZDxCBt8/hC128iqbGxU0GCOPcd4Ga5TqAjZftpXyK2ofqDnwrWS9
         nAYxOQDRUb7XuRKggMq9a7V4oh3Qjmytldrn5bEOpmMJGrPcTr8wx8zlH/xspYCjhwD4
         2xOYNNERdQPKQ6fEQFdKFUl7h2mgA8nxiAO7+O8VgotTWu8yHzRHPuuhawFfZ6UEVlio
         pX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Hs3jvXYRoW9cue3NWCTKTBo720DcB8K81r/kuPpiKLg=;
        b=rv9FfcjDuglG5gKKC6Ev1iOQO1YSiKdlERJqduMT0wBfm2Fa6sRth7cQRk9o/EOH4H
         mGbfrjVyWq+yNEN5hQTAd+B3n8RGfum5U+CuexvYk8aDECSDKr8/lCP4hrHifp6/JO3O
         QYe1/e7acEPuLONtHuY4K6/AEzn+SSJa038m4yMllquQL4zUCwfppwP3pJ/+Y8tx7ruR
         O8MuT6hCqc3eMhVdWtp0U276Zp42GXH6vt98Mo7K2ozJGQJekX37dzMenCThWZ+7gtdn
         RHcXcg+XlIJnZZrm5DPUAUEiWADuiKFzPCNoK8Jh37YV9eId+d+Ojxu+NSXKTzuD4bHl
         ejow==
X-Gm-Message-State: ACrzQf26XPZDAHeH/bLTf8dLS69dbMp/zgVW3EYjNkDuDxAsBvb7W48A
        i07NqqSnXXo8u/cLH+qnak3M6AEow+mn1dTHFn0=
X-Google-Smtp-Source: AMsMyM6+zGsuKsj2AwyUhlrPTvcMauXh5gjI+oX3NcpIaTUUvACKUgqczJK/iCDAJc9ZZht8ZphALvXUKQeyqyY04SE=
X-Received: by 2002:a05:6902:44:b0:6af:f412:cfb7 with SMTP id
 m4-20020a056902004400b006aff412cfb7mr23782496ybh.366.1664891624610; Tue, 04
 Oct 2022 06:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora> <YzwARuAZdaoGTUfP@T590>
In-Reply-To: <YzwARuAZdaoGTUfP@T590>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 4 Oct 2022 09:53:32 -0400
Message-ID: <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        rjones@redhat.com, Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 4 Oct 2022 at 05:44, Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Mon, Oct 03, 2022 at 03:53:41PM -0400, Stefan Hajnoczi wrote:
> > On Fri, Sep 30, 2022 at 05:24:11PM +0800, Ming Lei wrote:
> > > ublk-qcow2 is available now.
> >
> > Cool, thanks for sharing!
> >
> > >
> > > So far it provides basic read/write function, and compression and snapshot
> > > aren't supported yet. The target/backend implementation is completely
> > > based on io_uring, and share the same io_uring with ublk IO command
> > > handler, just like what ublk-loop does.
> > >
> > > Follows the main motivations of ublk-qcow2:
> > >
> > > - building one complicated target from scratch helps libublksrv APIs/functions
> > >   become mature/stable more quickly, since qcow2 is complicated and needs more
> > >   requirement from libublksrv compared with other simple ones(loop, null)
> > >
> > > - there are several attempts of implementing qcow2 driver in kernel, such as
> > >   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
> > >   might useful be for covering requirement in this field
> > >
> > > - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
> > >   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
> > >   is started
> > >
> > > - help to abstract common building block or design pattern for writing new ublk
> > >   target/backend
> > >
> > > So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> > > device as TEST_DEV, and kernel building workload is verified too. Also
> > > soft update approach is applied in meta flushing, and meta data
> > > integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> > > test, and only cluster leak is reported during this test.
> > >
> > > The performance data looks much better compared with qemu-nbd, see
> > > details in commit log[1], README[5] and STATUS[6]. And the test covers both
> > > empty image and pre-allocated image, for example of pre-allocated qcow2
> > > image(8GB):
> > >
> > > - qemu-nbd (make test T=qcow2/002)
> >
> > Single queue?
>
> Yeah.
>
> >
> > >     randwrite(4k): jobs 1, iops 24605
> > >     randread(4k): jobs 1, iops 30938
> > >     randrw(4k): jobs 1, iops read 13981 write 14001
> > >     rw(512k): jobs 1, iops read 724 write 728
> >
> > Please try qemu-storage-daemon's VDUSE export type as well. The
> > command-line should be similar to this:
> >
> >   # modprobe virtio_vdpa # attaches vDPA devices to host kernel
>
> Not found virtio_vdpa module even though I enabled all the following
> options:
>
>         --- vDPA drivers
>           <M>   vDPA device simulator core
>           <M>     vDPA simulator for networking device
>           <M>     vDPA simulator for block device
>           <M>   VDUSE (vDPA Device in Userspace) support
>           <M>   Intel IFC VF vDPA driver
>           <M>   Virtio PCI bridge vDPA driver
>           <M>   vDPA driver for Alibaba ENI
>
> BTW, my test environment is VM and the shared data is done in VM too, and
> can virtio_vdpa be used inside VM?

I hope Xie Yongji can help explain how to benchmark VDUSE.

virtio_vdpa is available inside guests too. Please check that
VIRTIO_VDPA ("vDPA driver for virtio devices") is enabled in "Virtio
drivers" menu.

>
> >   # modprobe vduse
> >   # qemu-storage-daemon \
> >       --blockdev file,filename=test.qcow2,cache.direct=of|off,aio=native,node-name=file \
> >       --blockdev qcow2,file=file,node-name=qcow2 \
> >       --object iothread,id=iothread0 \
> >       --export vduse-blk,id=vduse0,name=vduse0,num-queues=$(nproc),node-name=qcow2,writable=on,iothread=iothread0
> >   # vdpa dev add name vduse0 mgmtdev vduse
> >
> > A virtio-blk device should appear and xfstests can be run on it
> > (typically /dev/vda unless you already have other virtio-blk devices).
> >
> > Afterwards you can destroy the device using:
> >
> >   # vdpa dev del vduse0
> >
> > >
> > > - ublk-qcow2 (make test T=qcow2/022)
> >
> > There are a lot of other factors not directly related to NBD vs ublk. In
> > order to get an apples-to-apples comparison with qemu-* a ublk export
> > type is needed in qemu-storage-daemon. That way only the difference is
> > the ublk interface and the rest of the code path is identical, making it
> > possible to compare NBD, VDUSE, ublk, etc more precisely.
>
> Maybe not true.
>
> ublk-qcow2 uses io_uring to handle all backend IO(include meta IO) completely,
> and so far single io_uring/pthread is for handling all qcow2 IOs and IO
> command.

qemu-nbd doesn't use io_uring to handle the backend IO, so we don't
know whether the benchmark demonstrates that ublk is faster than NBD,
that the ublk-qcow2 implementation is faster than qemu-nbd's qcow2,
whether there are miscellaneous implementation differences between
ublk-qcow2 and qemu-nbd (like using the same io_uring context for both
ublk and backend IO), or something else.

I'm suggesting measuring changes to just 1 variable at a time.
Otherwise it's hard to reach a conclusion about the root cause of the
performance difference. Let's learn why ublk-qcow2 performs well.

Stefan

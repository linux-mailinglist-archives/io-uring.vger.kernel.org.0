Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6119529968
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 08:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiEQGRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 02:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiEQGRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 02:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7529377F6
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 23:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652768265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y9PBWR+mX8nOiXRrnBGyVfT0vthcQVvulV/Dos3xts0=;
        b=LpXooqa5I7O1tgJmiVJK39GZdah0jREVw4qS/9KPo2Y2KQlhbX3we5xT61xlol+s/31a8z
        Z4o6GRQ8XQaVA0E0YXFCgqHbOQwk1LvqIRZbjfoyrZkBBBMLumT/Q/42aQERDO2b1EDobX
        eK28599j0p0N85M/AMJVtArvYWKwuGU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-VItfNYJMPEanhSUoQ9d-vA-1; Tue, 17 May 2022 02:17:42 -0400
X-MC-Unique: VItfNYJMPEanhSUoQ9d-vA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A51C100BAAB;
        Tue, 17 May 2022 06:17:41 +0000 (UTC)
Received: from localhost (unknown [10.39.192.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 477E040CF8F0;
        Tue, 17 May 2022 06:17:41 +0000 (UTC)
Date:   Tue, 17 May 2022 07:17:40 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        kwolf@redhat.com, sgarzare@redhat.com
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Message-ID: <YoM+BCqeNAEfjJ3Y@stefanha-x1.localdomain>
References: <20220509092312.254354-1-ming.lei@redhat.com>
 <YoKmFYjIe1AWk/P8@stefanha-x1.localdomain>
 <YoMBJMk0GhXk+13E@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tTM2BDrKnW6jmOjZ"
Content-Disposition: inline
In-Reply-To: <YoMBJMk0GhXk+13E@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--tTM2BDrKnW6jmOjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2022 at 09:57:56AM +0800, Ming Lei wrote:
> Hello Stefan,
>=20
> On Mon, May 16, 2022 at 08:29:25PM +0100, Stefan Hajnoczi wrote:
> > Hi,
> > This looks interesting! I have some questions:
>=20
> Thanks for your comment!
>=20
> >=20
> > 1. What is the ubdsrv permission model?
> >=20
> > A big usability challenge for *-in-userspace interfaces is the balance
> > between security and allowing unprivileged processes to use these
> > features.
> >=20
> > - Does /dev/ubd-control need to be privileged? I guess the answer is
> >   yes since an evil ubdsrv can hang I/O and corrupt data in hopes of
> >   triggering file system bugs.
>=20
> Yes, I think so.
>=20
> UBD should be in same position with NBD which does require
> capable(CAP_SYS_ADMIN).
>=20
> > - Can multiple processes that don't trust each other use UBD at the same
> >   time? I guess not since ubd_index_idr is global.
>=20
> Only single process can open /dev/ubdcN for communicating with ubd
> driver, see ubd_ch_open().

I was thinking about /dev/ubd-control:
Commands like UBD_CMD_STOP_DEV use ubd_find_device() to look up an
arbitrary device. This means there is no isolation of UBD devices
between processes.

It makes me wonder whether a design that isolates devices would be
better in the long-term. For example, UBD_CMD_ADD_DEV returns a new UBD
device control file descriptor that responds to control commands like
UBD_CMD_START_DEV/UBD_CMD_STOP_DEV. info->dev_id isn't necessary anymore
and doesn't provide access to arbitrary devices because the per-device
control file descriptor provides that information instead. You can still
grant another process access to the control file descriptor (e.g. UNIX
domain socket fd passing) but other processes cannot access your UBD
devices unless you allow it. I think it's worth thinking about this
approach because access is much more controlled.

> > - What about containers and namespaces? They currently have (write)
> >   access to the same global ubd_index_idr.
>=20
> I understand contrainers/namespaces only need to see /dev/ubdbN, and
> the usage model should be same with kernel loop: the global ubd_index_idr
> is same with loop's loop_index_idr too.
>=20
> Or can you explain a bit in detail if I misunderstood your point.

If containers only have access to /dev/ubdbN, how can a program running
inside a container create new UBD devices? I think it's worth supporting
use cases where containers create new UBD devices because more and more
software is being deployed in containers and it's not always possible to
rely on a non-containerized tool that sets up the environment for the
container.

> > - Maybe there should be a struct ubd_device "owner" (struct
> >   task_struct *) so only devices created by the current process can be
> >   modified?
>=20
> I guess it isn't needed since /dev/ubdcN is opened by single process.

Yes, but the control device has the same problem as /dev/ubdcN. It
should be possible for multiple processes that are not cooperating to
control their own UBD devices.

>=20
> >=20
> > 2. io_uring_cmd design
> >=20
> > The rationale for the io_uring_cmd design is not explained in the cover
> > letter. I think it's worth explaining the design. Here are my guesses:
> >=20
> > The same thing can be achieved with just file_operations and io_uring.
> > ubdsrv could read I/O submissions with IORING_OP_READ and write I/O
> > completions with IORING_OP_WRITE. That would require 2 sqes per
> > roundtrip instead of 1, but the same number of io_uring_enter(2) calls
> > since multiple sqes/cqes can be batched per syscall:
> >=20
> > - IORING_OP_READ, addr=3D(struct ubdsrv_io_desc*) (for submission)
> > - IORING_OP_WRITE, addr=3D(struct ubdsrv_io_cmd*) (for completion)
> >=20
> > Both operations require a copy_to/from_user() to access the command
> > metadata.
>=20
> Yes, but it can't be efficient as io_uring command.
>=20
> Two OPs require two long code path for read and write which are supposed
> for handling fs io, so reusing complicated FS IO interface for sending
> command via cha dev is really overkill, and nvme passthrough has shown
> better IOPS than read/write interface with io_uring command, and extra
> copy_to/from_user() may fault with extra meta copy, which can slow down
> the ubd server.
>=20
> Also for IORING_OP_READ, copy_to_user() has to be done in the ubq daemon
> context, even though that isn't a big deal, but with extra cost(cpu utili=
zation)
> in the ubq deamon context or sleep for handling page fault, that is
> really what should be avoided, we need to save more CPU for handling user
> space IO logic in that context.
>=20
> >=20
> > The io_uring_cmd approach works differently. The IORING_OP_URING_CMD sqe
> > carries a 40-byte payload so it's possible to embed struct ubdsrv_io_cmd
> > inside it. The struct ubdsrv_io_desc mmap gets around the fact that
> > io_uring cqes contain no payload. The driver therefore needs a
> > side-channel to transfer the request submission details to ubdsrv. I
> > don't see much of a difference between IORING_OP_READ and the mmap
> > approach though.
>=20
> At least the performance difference, ->uring_cmd() requires much less
> code path(single simple o_uring command) than read/write, without any copy
> on command data, without fault in copy_to/from_user(), without two long/
> complicated FS IO code path.
>=20
> Single command of UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching
> io request desc and commit command result in one trip.
>=20
> >=20
> > It's not obvious to me how much more efficient the io_uring_cmd approach
> > is, but taking fewer trips around the io_uring submission/completion
> > code path is likely to be faster. Something similar can be done with
> > file_operations ->ioctl(), but I guess the point of using io_uring is
> > that is composes. If ubdsrv itself wants to use io_uring for other I/O
> > activity (e.g. networking, disk I/O, etc) then it can do so and won't be
> > stuck in a blocking ioctl() syscall.
>=20
> ioctl can't be a choice, since we will lose the benefit of batching
> handling.
>=20
> >=20
> > It would be nice if you could write 2 or 3 paragraphs explaining why the
> > io_uring_cmd design and the struct ubdsrv_io_desc mmap was chosen.
>=20
> Fine, I guess most are the above inline comment?

Yes, thanks for posting explanation! It would be great to have it in the
commit description or cover letter.

> >=20
> > 3. Miscellaneous stuff
> >=20
> > - There isn't much in the way of memory ordering in the code. I worry a
> >   little that changes to the struct ubdsrv_io_desc mmap may not be
> >   visible at the expected time with respect to the io_uring cq ring.
>=20
> I believe io_uring_cmd_done() with userspace cqe helper implies enough me=
mory
> barrier, once the cqe is observed in userspace, any memory OP done before
> io_uring_cmd_done() should be observed by user side cqe handling code,
> otherwise it can be thought as io_uring bug.
>=20
> If it isn't this way, we still can avoid any barrier by moving
> setting io desc into ubq daemon context(ubd_rq_task_work_fn), but I
> really want to save cpu in that context, and don't think it is needed.

It might be worth a comment that ubd_setup_iod() stores are implicitly
ordered by io_uring_cmd_done() so userspace will see the stores when it
sees the cqe.

By the way, does ubd_ch_mmap() need to check vma->vm_flags to prevent
ubdsrv from mapping with PROT_WRITE?

Stefan

--tTM2BDrKnW6jmOjZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKDPgMACgkQnKSrs4Gr
c8hZDggAmOp/1TKRP0aCJcNJFA8UTBceMStyawTRkPvZcDec22hvEIUI04wuxYeo
jGK/ujHy0ICUUlHbzJOJ9UPZcgzlnaf8fCGHfBAQe9MjIYXQtARz+WlL5DdvbFOm
u+3vD2awjqBKO0+EVL7qMMreSS308w8FEQPn2hNPnFnSCgAYYwuAxe1y2d8r9Bbb
OCrs+SnLyXySEjGp4SZDY7TGUvFUGLT1mJFZnaGll7wXepyACajKTXYi/J2/UNkV
DJuEk0m8qH9E4x4R3cyTcqmj4Kozp/U+j98XfiQnoxrOswY9Ez1wjaNAo5LLzjbh
fjL+E2FPX5YMom1e4NZN4JFgsDTO5Q==
=3OZV
-----END PGP SIGNATURE-----

--tTM2BDrKnW6jmOjZ--


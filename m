Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9444952BF2B
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 18:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiERPtN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 11:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239685AbiERPtM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 11:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6847318DAC6
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 08:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652888949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CPMtpCANwEoxwHK48M0Snd0aiOyfZBKw+8aByA2ZSdo=;
        b=C3e+FLYuFaPfiGc7wqA57NYWgiKaINpLTXtxjk9JvDrPBYOXPkhGI1c539MG/V7gZwEVEw
        QTGN47mC/FU+2h1+GRj41k0jxwlx4GSyDzXm0YPFtF/x1mdePgIRBqnX/Xd90nm33VNdCk
        moS40zfMTMtA0ZwcGklg5MUpoA6OzIo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-YbbNmX4VOyusgVngS6orDQ-1; Wed, 18 May 2022 11:49:05 -0400
X-MC-Unique: YbbNmX4VOyusgVngS6orDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 587AA294EDCB;
        Wed, 18 May 2022 15:49:05 +0000 (UTC)
Received: from localhost (unknown [10.39.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFAE140C1438;
        Wed, 18 May 2022 15:49:04 +0000 (UTC)
Date:   Wed, 18 May 2022 16:49:03 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <YoUVb8CeWRIErJBY@stefanha-x1.localdomain>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <YoOr6jBfgVm8GvWg@stefanha-x1.localdomain>
 <YoSbuvT88sG5UkfG@T590>
 <YoTOTCooQfQQxyA8@stefanha-x1.localdomain>
 <YoTsYvnACbCNIMPE@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hPQQNyCAeGrb5boE"
Content-Disposition: inline
In-Reply-To: <YoTsYvnACbCNIMPE@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--hPQQNyCAeGrb5boE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 18, 2022 at 08:53:54PM +0800, Ming Lei wrote:
> On Wed, May 18, 2022 at 11:45:32AM +0100, Stefan Hajnoczi wrote:
> > On Wed, May 18, 2022 at 03:09:46PM +0800, Ming Lei wrote:
> > > On Tue, May 17, 2022 at 03:06:34PM +0100, Stefan Hajnoczi wrote:
> > > > Here are some more thoughts on the ubd-control device:
> > > >=20
> > > > The current patch provides a ubd-control device for processes with
> > > > suitable permissions (i.e. root) to create, start, stop, and fetch
> > > > information about devices.
> > > >=20
> > > > There is no isolation between devices created by one process and th=
ose
> > >=20
> > > I understand linux hasn't device namespace yet, so can you share the
> > > rational behind the idea of device isolation, is it because ubd device
> > > is served by ubd daemon which belongs to one pid NS? Or the user crea=
ting
> > > /dev/ubdbN belongs to one user NS?
> >=20
> > With the current model a process with access to ubd-control has control
> > over all ubd devices. This is not desirable for most container use cases
> > because ubd-control usage within a container means that container could
> > stop any ubd device on the system.
> >=20
> > Even for non-container use cases it's problematic that two applications
> > that use ubd can interfere with each other. If an application passes the
> > wrong device ID they can stop the other application's device, for
> > example.
> >=20
> > I think it's worth supporting a model where there are multiple ubd
> > daemons that are not cooperating/aware of each other. They should be
> > isolated from each other.
>=20
> Maybe I didn't mention it clearly, I meant the following model in last em=
ail:
>=20
> 1) every user can send UBD_CMD_ADD_DEV to /dev/ubd-control
>=20
> 2) the created /dev/ubdcN & /dev/udcbN are owned by the user who creates
> it

How does this work? Does userspace (udev) somehow get the uid/gid from
the uevent so it can set the device node permissions?

> 3) only the user who has permission to /dev/ubdcN can send other control
> commands(START_DEV/STOP_DEV/GET_DEV_INFO/GET_QUEUE_AFFINITY/DEL_DEV);
> and same with /dev/ubdbN
>=20
> 4) for unprivileged user who owns /dev/ubdbN, limit kernel behavior,
> such as, not probed for partitions and LVM, only allow unprivileged
> mounts,...
>=20
> So ubd device can be isolated wrt. user NS.

Cool!

>=20
> >=20
> > > IMO, ubd device is one file in VFS, and FS permission should be appli=
ed,
> > > then here the closest model should be user NS, and process privilege &
> > > file ownership.
> >=20
> > Yes, /dev/ubdbN can has file ownership/permissions and the cgroup device
> > controller can restrict access too. That works fine when the device was
> > created previously.
> >=20
> > But what about ubd device creation via ubd-control?
> >=20
> > The problem is a global control interface like ubd-control gives access
> > to all ubd devices. There is no way to let an application/container
> > control (create/start/stop/etc) some ubd devices but not all. I think
> > ubd-control must be more fine-grained so multiple
> > applications/containers can use it without the possibility of
> > interference.
> >=20
> > /dev/ubdcN is a separate problem. The cgroup device controller can limit
> > the device nodes that are accessible from a process. However, this
> > requires reserving device minor number ranges for each
> > application/container so they can only mknod/open their own ubd devices
> > and not devices that don't belong to them. Maybe there is a better
> > solution?
> >=20
> > /dev/ubdbN has similar requirements to /dev/ubdcN. It should be possible
> > to create a new /dev/ubdbN but not access an existing device that belong
> >=20
> > So if we want to let containers create ubd devices without granting them
> > access to all devices on the system, then the ubd-control interface
> > needs to be changed (see below) and the container needs a reserved range
> > of ubdcN minor numbers. Any container using ubdbN needs the cgroup
> > device controller and file ownership/permissions to open the block
> > device.
> >=20
> > > > created by another. Therefore two processes that do not trust each =
other
> > > > cannot both use UBD without potential interference. There is also no
> > >=20
> > > Can you share what the expectation is for this situation?
> >=20
> > Two users should be able to run ubd daemons on the same system without
> > being able to stop each other's devices.
>=20
> Yeah, the above process privilege & file ownership based way can reach
> the goal in user NS.
>=20
> >=20
> > > It is the created UBD which can only be used in this NS, or can only =
be
> > > visible inside this NS? I guess the latter isn't possible since we do=
n't
> > > have this kind of isolation framework yet.
> >=20
> > It should be possible to access the ubd device according to file
> > ownership/permissions. No new isolation framework is needed for that.
> >=20
> > But ubd-control should not grant global access to all ubd devices, at
> > least not in the typical case of a ubd daemon that just wishes to
> > create/start/stop its own devices.
>=20
> Yeah, I agree.
>=20
> >=20
> > > > isolation for containers.
> > > >=20
> > > > I think it would be a mistake to keep the ubd-control interface in =
its
> > > > current form since the current global/root model is limited. Instea=
d I
> > > > suggest:
> > > > - Creating a device returns a new file descriptor instead of a glob=
al
> > > >   dev_id. The device can be started/stopped/configured through this=
 (and
> > > >   only through this) per-device file descriptor. The device is not
> > > >   visible to other processes through ubd-control so interference is=
 not
> > > >   possible. In order to give another process control over the devic=
e the
> > > >   fd can be passed (e.g. SCM_RIGHTS).=20
> > > >=20
> > >=20
> > > /dev/ubdcN can only be opened by the process which is the descendant =
of
> > > the process which creates the device by sending ADD_DEV.
> > >=20
> > > But the device can be deleted/queried by other processes, however, I
> > > think it is reasonable if all these processes has permission to do th=
at,
> > > such as all processes owns the device with same uid.
> >=20
> > I don't think it's a good idea to require all ubd daemons to have
> > CAP_SYS_ADMIN/same uid. That's the main point I'm trying to make and the
> > discussion is based on that.
>=20
> I meant only the user who owns /dev/ubdcN can send the command to
> /dev/ubd-control for controlling /dev/ubdcN. I believe this way is
> straightforward.
>=20
> >=20
> > > So can we apply process privilege & file ownership for isolating ubd =
device?
> > >=20
> > > If per-process FD is used, it may confuse people, because process can
> > > not delete/query ubd device even though its uid shows it has the
> > > privilege.
> >=20
> > Is it better to stop the device via ubd-control instead of a
> > daemon-specific command (or just killing the daemon process)?
> >=20
> > Regarding querying the device, the daemon has more information
> > associated with the device (e.g. if it's an iSCSI initiator it will have
> > the iSCSI URI). The ubd driver can only tell you the daemon pid and the
> > block device attributes that should already be available via sysfs.
> > Quering the daemon will yield more useful information than using
> > ubd-control.
>=20
> I don't think it is good to interrupt daemon for this admin/control job,
> which may distract daemon from handling normal IO tasks, also not necessa=
ry
> to make daemon implementation more complicated.
>=20
> We should separate admin task from normal IO handling, which is one
> common design pattern.
>=20
> >=20
> > > > Now multiple applications/containers/etc can use ubd-control without
> > > > interfering with each other. The security model still requires root
> > > > though since devices can be malicious.
> > > >=20
> > > > FUSE allows unprivileged mounts (see fuse_allow_current_process()).=
 Only
> > > > processes with the same uid as the FUSE daemon can access such moun=
ts
> > > > (in the default configuration). This prevents security issues while
> > > > still allowing unprivileged use cases.
> > >=20
> > > OK, looks FUSE applies process privilege & file ownership for dealing
> > > with unprivileged mounts.
> > >=20
> > > >=20
> > > > I suggest adapting the FUSE security model to block devices:
> > > > - Devices can be created without CAP_SYS_ADMIN but they have an
> > > >   'unprivileged' flag set to true.
> > > > - Unprivileged devices are not probed for partitions and LVM doesn't
> > > >   touch them. This means the kernel doesn't access these devices via
> > > >   code paths that might be exploitable.
> > >=20
> > > The above two makes sense.
> > >=20
> > > > - When another process with a different uid from ubdsrv opens an
> > > >   unprivileged device, -EACCES is returned. This protects other
> > > >   uids from the unprivileged device.
> > >=20
> > > OK, only the user who owns the device can access unprivileged device.
> > >=20
> > > > - When another process with a different uid from ubdsrv opens a
> > > >   _privileged_ device there is no special access check because ubds=
rv is
> > > >   privileged.
> > >=20
> > > IMO, it depends if uid of this process has permission to access the
> > > ubd device, and we can set ubd device's owership by the process
> > > credentials.
> >=20
> > Yes, file ownership/permissions are still relevant.
> >=20
> > >=20
> > > >=20
> > > > With these changes UBD can be used by unprivileged processes and
> > > > containers. I think it's worth discussing the details and having th=
is
> > > > model from the start so UBD can be used in a wide range of use case=
s.
> > >=20
> > > I am pretty happy to discuss & figure out the details, but not sure
> > > it is one blocker for ubd:
> > >=20
> > > 1) kernel driver of loop/nbd or others haven't support the isolation
> >=20
> > It may be better to compare it with FUSE where unprivileged users can
> > run their own servers. Imagine FUSE required a global root control
> > interface like ubd-control, then it wouldn't be possible to have
> > unprivileged FUSE mounts.
> >=20
> > > 2) still don't know exact ubd use case for containers
> >=20
> > There are two common use cases for block devices:
> > 1. File systems or volume managers
> > 2. Direct access for databases, backup tools, disk image tools, etc
> >=20
> > The file system use case involved kernel code and probably needs to be
> > restricted to untrusted containers cannot exploit the kernel file system
> > implementations. I'll ignore this use case and containers probably
> > shouldn't do this.
> >=20
> > The second use case is when you have any program that can operate on a
> > block device. It could be an application that imports/exports a block
> > device from network storage. This kind of application should be able to
> > do its job without CAP_SYS_ADMIN and it should be able to run in a
> > container. It might be part of KubeVirt's Containerized Data Importer,
> > for example, and is deployed as a container.
> >=20
> > If ubd supports unprivileged operation then this container use case is
> > straightforward. If not, then it's problematic because it either
> > requires a privileged container or some kind of privileged helper
> > outside the container. At that point people may avoid ubd because it's
> > too hard to deploy with privilege requirements.
>=20
> OK, thanks for the sharing. In short, container requires unprivileged
> operation on block device. I think it makes sense.

Thanks!

Stefan

--hPQQNyCAeGrb5boE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKFFW8ACgkQnKSrs4Gr
c8gl4gf/af2Wh8d//orm/DrB4u5zPE6iRY7WWi8cKLS0lLx9gBqTGh2Yn3516lDd
PnujQYCS05Nn8QeQtNvzXTUGunhse85gey/a0p35+pwU+dhJCeOQR70/0gdYM4j7
iyr2RNaJgulxY+g/1E8FpxqQ9hRB/QX54iYyfSRjqWeltLmQhspJeTo+JTmry4+/
jdxqTedrXxciq89R0DV+q3B69nw1EybWGWJue6MWSn2PzuAAZ+KWIM0PNdzAoJQp
8rQgC5DpKGNyJDpaRJUqywwIXUEjioqAXPIXrRobD7PoPaWBkdQn8CtCJAk42cZ4
UDTTg/pfM/U/9HAXi9avOLg+L/EnaA==
=jsUe
-----END PGP SIGNATURE-----

--hPQQNyCAeGrb5boE--


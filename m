Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6552CFA5
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 11:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiESJqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 05:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiESJqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 05:46:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A687E6970F
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 02:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652953605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bMReF8cCrWNT+y8fLyYoHigFI6O30lF2NYiv8Us0yFg=;
        b=fzofp5B0srfBQsA6+rXM7mDaaPOb609FaW2e5TJ2gm1AFq9ESFAWdkn0wNE8UDrIoBFmWg
        vSwFi5RrBdUF4hgTRw00XPcPCBUWlQtlfUfzYuzGAKMd3lV2CcS8KqDFnJA3+EkXkvZs9d
        duJvRFZAomUxMEXGswaWqakxFuScqtg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-Fa9_pUzsMRCdUL7KDmAiGw-1; Thu, 19 May 2022 05:46:44 -0400
X-MC-Unique: Fa9_pUzsMRCdUL7KDmAiGw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C264811E80;
        Thu, 19 May 2022 09:46:43 +0000 (UTC)
Received: from localhost (unknown [10.39.193.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFC4B401E9D;
        Thu, 19 May 2022 09:46:42 +0000 (UTC)
Date:   Thu, 19 May 2022 10:46:41 +0100
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
Message-ID: <YoYSAb8h98uVKtgV@stefanha-x1.localdomain>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <YoOr6jBfgVm8GvWg@stefanha-x1.localdomain>
 <YoSbuvT88sG5UkfG@T590>
 <YoTOTCooQfQQxyA8@stefanha-x1.localdomain>
 <YoTsYvnACbCNIMPE@T590>
 <YoUVb8CeWRIErJBY@stefanha-x1.localdomain>
 <YoWujjFArHaXuqYS@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6MbhIVNGz8/JKSi2"
Content-Disposition: inline
In-Reply-To: <YoWujjFArHaXuqYS@T590>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--6MbhIVNGz8/JKSi2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 19, 2022 at 10:42:22AM +0800, Ming Lei wrote:
> On Wed, May 18, 2022 at 04:49:03PM +0100, Stefan Hajnoczi wrote:
> > On Wed, May 18, 2022 at 08:53:54PM +0800, Ming Lei wrote:
> > > On Wed, May 18, 2022 at 11:45:32AM +0100, Stefan Hajnoczi wrote:
> > > > On Wed, May 18, 2022 at 03:09:46PM +0800, Ming Lei wrote:
> > > > > On Tue, May 17, 2022 at 03:06:34PM +0100, Stefan Hajnoczi wrote:
> > > > > > Here are some more thoughts on the ubd-control device:
> > > > > >=20
> > > > > > The current patch provides a ubd-control device for processes w=
ith
> > > > > > suitable permissions (i.e. root) to create, start, stop, and fe=
tch
> > > > > > information about devices.
> > > > > >=20
> > > > > > There is no isolation between devices created by one process an=
d those
> > > > >=20
> > > > > I understand linux hasn't device namespace yet, so can you share =
the
> > > > > rational behind the idea of device isolation, is it because ubd d=
evice
> > > > > is served by ubd daemon which belongs to one pid NS? Or the user =
creating
> > > > > /dev/ubdbN belongs to one user NS?
> > > >=20
> > > > With the current model a process with access to ubd-control has con=
trol
> > > > over all ubd devices. This is not desirable for most container use =
cases
> > > > because ubd-control usage within a container means that container c=
ould
> > > > stop any ubd device on the system.
> > > >=20
> > > > Even for non-container use cases it's problematic that two applicat=
ions
> > > > that use ubd can interfere with each other. If an application passe=
s the
> > > > wrong device ID they can stop the other application's device, for
> > > > example.
> > > >=20
> > > > I think it's worth supporting a model where there are multiple ubd
> > > > daemons that are not cooperating/aware of each other. They should be
> > > > isolated from each other.
> > >=20
> > > Maybe I didn't mention it clearly, I meant the following model in las=
t email:
> > >=20
> > > 1) every user can send UBD_CMD_ADD_DEV to /dev/ubd-control
> > >=20
> > > 2) the created /dev/ubdcN & /dev/udcbN are owned by the user who crea=
tes
> > > it
> >=20
> > How does this work? Does userspace (udev) somehow get the uid/gid from
> > the uevent so it can set the device node permissions?
>=20
> We can let 'ubd list' export the owner info, then udev may override the d=
efault
> owner with exported info.
>=20
> Or it can be done inside devtmpfs_create_node() by passing ubd's uid/gid
> at default.
>=20
> For /dev/ubdcN, I think it is safe, since the driver is only
> communicating with the userspace daemon, and both belong to same owner.
> Also ubd driver is simple enough to get full audited.
>=20
> For /dev/ubdbN, even though FS isn't allowed to mount, there is still
> lots of kernel code path involved, and some code path may not be run
> with unprivileged user before, that needs careful audit.
>=20
> So the biggest problem is if it is safe to export block disk to unprivile=
ged
> user, and that is the one which can't be bypassed for any approach.

Okay.

Stefan

--6MbhIVNGz8/JKSi2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKGEgEACgkQnKSrs4Gr
c8g2CwgAvaVnBulG+1c9I6BHt2M9ly7JiY7SJaDyWvG957J4B6mO+lOkkRA6Xa5q
kY+IKgDG2RuuJcKQklVHgBWxx1+6dWN9Ax1iODGBphJVAKHiy+ZADI2YG7YnrNhp
zVDS/gRDiSL9+HWmFcy5zzedNZvbCZK6wACLMTk8pU1euwvmQFOIbIDX9hRS5v9J
4SEQKKLzNw8p6C1fT1/V0JRQgk5DAiNT8Zh4KDqwo29ikHv/1GXZBO31CVMOKLHH
MHFRJrRv68BphPbhUL0wnLuiERArSYvJlWk6UH8F9kGirrERon+7eKXrrsDQwJmW
YP3ozMHS0rN1fHDkdZKlro7Ett3oUQ==
=O25D
-----END PGP SIGNATURE-----

--6MbhIVNGz8/JKSi2--


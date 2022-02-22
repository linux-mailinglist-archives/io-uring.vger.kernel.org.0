Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D314BF765
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 12:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiBVLm2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 06:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBVLm1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 06:42:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22902136EED;
        Tue, 22 Feb 2022 03:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA908B81984;
        Tue, 22 Feb 2022 11:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EE9C340E8;
        Tue, 22 Feb 2022 11:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645530119;
        bh=EjscWLGJWk9jJIq0Yuq9lpx8LbZ3BlFOQvLg5DZEOg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e7ZT/JmCl5YhyboLSCPp0oAtWsnVvbC1YIohXWQc40w6ZDy0d6QvOMXE5khpCWEWy
         qH9Ex/a8LEYOLsT12cUpELOlibJGEwiJThs1T91RXV2jTyFZOiLgV+7kX7QcXItsfC
         0L9NJWlGp+Q74UsomLQYwF81Q+q339WWloCBruFV4tBKa2HVbGBpwmZw4IMeSECkhg
         4TjDppofiEhj6keu2fkw0bjZdEixiwzKJkmrWn/BT3/8IodcMr4795suiCR8E97PBY
         rY4iGhKPEymnAE71+QQSKzP8rrlakd8yOdW9J4jZWOfP4G1YXZ+k3FI2kPSL8gmLRg
         J5mR0CbR9yJrQ==
Date:   Tue, 22 Feb 2022 11:41:56 +0000
From:   Filipe Manana <fdmanana@kernel.org>
To:     Daniel Black <daniel@mariadb.org>
Cc:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Fwd: btrfs / io-uring corrupting reads
Message-ID: <YhTMBFrZeEvROh0C@debian9.Home>
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 22, 2022 at 08:53:02AM +1100, Daniel Black wrote:
> Per references at the bottom btfs + iouring manage to corrupt the
> reading of a file.
>=20
> Using podman here however docker or another container runtime will
> probably work. As will any MariaDB-10.6 on a distro with a native
> liburing userspace. Apologies for the older and bloated container
> image.
>=20
> Reproduction of bug:
>=20
> using a btrfs:
>=20
> $ dd if=3D/dev/zero  of=3D../btrfs.blk bs=3D1M count=3D2K
> $ sudo losetup --direct-io=3Don  -f ../btrfs.blk
> $ sudo mkfs.btrfs /dev/loop6
> $ sudo mount /dev/loop/6 /mnt/btrfstest
> $ sudo mkdir /mnt/btrfstest/noaio
> $ sudo chown dan: /mnt/btrfstest/noaio
>=20
> Initialize database on directory:
>=20
> $ podman run --name mdbinit --rm -v
> /mnt/btrfstest/noaio/:/var/lib/mysql:Z -e
> MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=3D1
> quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> --innodb_use_native_aio=3D0
>=20
> $ podman kill mdbinit
>=20
> Switch to using uring to read:
>=20
> $ podman run --rm -v /mnt/btrfstest/noaio/:/var/lib/mysql:Z -e
> MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=3D1
> quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> --innodb_use_native_aio=3D1
>=20
> Failure observed on startup:
>=20
> 2022-02-21 14:43:31 0 [ERROR] InnoDB: Database page corruption on disk
> or a failed read of file './ibdata1' page [page id: space=3D0, page
> number=3D9]. You may have to recover from a backup.

I gave it a try, but it fails setting up io_uring:

2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (di=
sabling future attempts)
2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with e=
rrno 1
2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to =
innodb_use_native_aio=3DOFF
2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size =
=3D 134217728, chunk size =3D 134217728
2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool

So that's why it doesn't fail here, as it fallbacks to no aio mode.

Any idea why it's failing to setup io_uring?

I have the liburing2 and liburing-dev packages installed on debian, and
tried with a 5.17-rc4 kernel.

I can run fio with io_uring as the ioengine (works perferctly so far).

Thanks.

>=20
> 2022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii and hex (16384 by=
tes):
>=20
>  len 16384; hex 00000000000000092022-02-21 14:43:31 0 [ERROR] InnoDB:
> Database page corruption on disk or a failed read of file './ibdata1'
> page [page id: space=3D0, page number=3D243]. You may have to recover from
> a backup.
>=20
> ffffffffffffff2022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii
> and hex (16384 bytes):
>=20
>  len 16384; hex
> 00000000000000f3ffffff0000000000009c2045bf00ffffff0000000000ffffff0000000=
000000002017100090000000001550002000600070000000000000009000000000000000000=
0000000500000000000000020572000000000000000204b208010000030085690000006e666=
96d756d000908a0d3000300000803000073757072656d756d000000000013080000100500a0=
00000000000000000000000000000b5359535f464f524549474e18080000180500c00000000=
00000000c5359ffffff535f464fff0000524549474e5f434f4c531308ffffff0000200500ff=
0000db000000000000000d5359535f56495254550000000000000056414c000000000000200=
80000280501030000ffffffff0000ffffffff0000000000000000000e6d7973000000716c2f=
696e6e6f64625f7461626c655f7300ffffffff0000ffffffff0000000000746174732000fff=
f080000300501ffff0000ffffffff000005d6692b000000000000000f6d7973716c2f696e6e=
6f64625f696e6465785fd2007374617473220800003805015500000000000000106d7973716=
c2f7472616e73616374696f6e5f72656769737472791c0800004005000000f4ffffff740000=
00000000ffffff00116d79ffffffffffffffffffffffffffffffffffff73716c2f67fffffff=
fffffffffff7469645f736c6176655fffffffffffffffffff706f7300ffffffffffffff2022=
-02-21
> 14:43:31 0 [ERROR] InnoDB: Database page corruption on disk or a
> failed read of file './mysql/innodb_table_stats.ibd' page [page id:
> space=3D1, page number=3D0]. You may have to recover from a backup.
>=20
> 002022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii and hex (16384 =
bytes):
>=20
> Without --innodb_use_native_aio=3D0 as a container argument this starts
> without error.
>=20
> $ sudo losetup --direct-io=3Doff  -f btrfs.blk also exhibits the failure
>=20
> Observed failures in:
> * 5.17.0-0.rc4.96.fc36.x86_64
> * 5.16.8 (on nixos)
> * 5.15.6
>=20
> No observed failure:
> * 5.15.14-200.fc35.x86_64
> * 5.10
>=20
> references:
> * https://jira.mariadb.org/browse/MDEV-27900
> * https://github.com/NixOS/nixpkgs/issues/160516
> * https://jira.mariadb.org/browse/MDEV-27449

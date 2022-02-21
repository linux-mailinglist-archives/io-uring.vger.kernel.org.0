Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C344BECCF
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 22:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiBUVxj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 16:53:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBUVxj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 16:53:39 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D5B22BD5
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 13:53:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u18so32166241edt.6
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 13:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=vKerE769IxjYegW3awSWRx2E6jCGcT96j3I8KNC2R9o=;
        b=O/ohzwBgMXBM/At5571AH4q+py4M085Z8S8RHWYnxndMaor5dSVRo+moaxG84qSAbR
         3ICgkFub/s2s1i5/iC2JHZ1TcukKPk9htrRWUVny/EPqMIuR5/WsL+c7tVXuejSyLtA4
         Q4sXgd66notLyPWUPZwzwRBkvyaKecKgQEIZpdOnaOnAksQVHOWDxsMo3rBsM1v9+Mm7
         5QNwl/brmRzUcR6fgHB/S64tmG9IC7neBetnolO766vxy8JQU/tn44fjFQKJwFlv1jn4
         0+qU7oeJUSpZTzU7dS1kb2cNG7RqY94g2VVzpU0SCNSdoXtP0jzqpQewQbaeLuzAx7Cz
         SNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=vKerE769IxjYegW3awSWRx2E6jCGcT96j3I8KNC2R9o=;
        b=SFtHkC/5u+iHGZlnhF3goTtW/YVeaCpr+efFzjOPT9jgtRiOYN5GYh/UkMiN+MrwtG
         aQNojz0qBJkjO6lrB+WivroOMCmq91vE4Zt8BldTgYFSlHrOeHpbd+P0f2IfNUtvI51d
         i06rDET/KIE+6QPNLkylNV6XkWVV7STiikKLe+9Z4KS/hK3rI8m2C/a3DREwAx8cNsuW
         wkiXh/BT/3Fr0iCcJ8Jk0OjxrJOUohMoNMAH4iWBdp57+t2H0CGEmPnGbkPCXdtLXC8/
         H/OTyje+6AzeqIY1hujP0AFO4gPiwnG12VGqoXkq1cwJp0z0la2YmBoYEOfHJKyyXy6e
         70NQ==
X-Gm-Message-State: AOAM533oDTnTK2FpwonkeCGOtR7eJ79bWZ6NXYbJH5xRF+Mo2zydfnua
        14GG51uykCfPAw+MSFZKfOIe6bnh0wHrxMJoOOcKA/4dB0Q=
X-Google-Smtp-Source: ABdhPJwkCuaOTmHrDFjup995/3ci2fJnGhYDa3tnmW3LpGfa/IzZaO7q8QKySe9JPEeg/0+Y0/LdtR0oUthIjkhwHVQ=
X-Received: by 2002:a50:ef10:0:b0:410:b95b:a89b with SMTP id
 m16-20020a50ef10000000b00410b95ba89bmr23684183eds.146.1645480393611; Mon, 21
 Feb 2022 13:53:13 -0800 (PST)
MIME-Version: 1.0
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
In-Reply-To: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
From:   Daniel Black <daniel@mariadb.org>
Date:   Tue, 22 Feb 2022 08:53:02 +1100
Message-ID: <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
Subject: Fwd: btrfs / io-uring corrupting reads
To:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Per references at the bottom btfs + iouring manage to corrupt the
reading of a file.

Using podman here however docker or another container runtime will
probably work. As will any MariaDB-10.6 on a distro with a native
liburing userspace. Apologies for the older and bloated container
image.

Reproduction of bug:

using a btrfs:

$ dd if=3D/dev/zero  of=3D../btrfs.blk bs=3D1M count=3D2K
$ sudo losetup --direct-io=3Don  -f ../btrfs.blk
$ sudo mkfs.btrfs /dev/loop6
$ sudo mount /dev/loop/6 /mnt/btrfstest
$ sudo mkdir /mnt/btrfstest/noaio
$ sudo chown dan: /mnt/btrfstest/noaio

Initialize database on directory:

$ podman run --name mdbinit --rm -v
/mnt/btrfstest/noaio/:/var/lib/mysql:Z -e
MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=3D1
quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
--innodb_use_native_aio=3D0

$ podman kill mdbinit

Switch to using uring to read:

$ podman run --rm -v /mnt/btrfstest/noaio/:/var/lib/mysql:Z -e
MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=3D1
quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
--innodb_use_native_aio=3D1

Failure observed on startup:

2022-02-21 14:43:31 0 [ERROR] InnoDB: Database page corruption on disk
or a failed read of file './ibdata1' page [page id: space=3D0, page
number=3D9]. You may have to recover from a backup.

2022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii and hex (16384 byte=
s):

 len 16384; hex 00000000000000092022-02-21 14:43:31 0 [ERROR] InnoDB:
Database page corruption on disk or a failed read of file './ibdata1'
page [page id: space=3D0, page number=3D243]. You may have to recover from
a backup.

ffffffffffffff2022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii
and hex (16384 bytes):

 len 16384; hex
00000000000000f3ffffff0000000000009c2045bf00ffffff0000000000ffffff000000000=
000000201710009000000000155000200060007000000000000000900000000000000000000=
00000500000000000000020572000000000000000204b208010000030085690000006e66696=
d756d000908a0d3000300000803000073757072656d756d000000000013080000100500a000=
000000000000000000000000000b5359535f464f524549474e18080000180500c0000000000=
000000c5359ffffff535f464fff0000524549474e5f434f4c531308ffffff0000200500ff00=
00db000000000000000d5359535f56495254550000000000000056414c00000000000020080=
000280501030000ffffffff0000ffffffff0000000000000000000e6d7973000000716c2f69=
6e6e6f64625f7461626c655f7300ffffffff0000ffffffff0000000000746174732000ffff0=
80000300501ffff0000ffffffff000005d6692b000000000000000f6d7973716c2f696e6e6f=
64625f696e6465785fd2007374617473220800003805015500000000000000106d7973716c2=
f7472616e73616374696f6e5f72656769737472791c0800004005000000f4ffffff74000000=
000000ffffff00116d79ffffffffffffffffffffffffffffffffffff73716c2f67fffffffff=
fffffffff7469645f736c6176655fffffffffffffffffff706f7300ffffffffffffff2022-0=
2-21
14:43:31 0 [ERROR] InnoDB: Database page corruption on disk or a
failed read of file './mysql/innodb_table_stats.ibd' page [page id:
space=3D1, page number=3D0]. You may have to recover from a backup.

002022-02-21 14:43:31 0 [Note] InnoDB: Page dump in ascii and hex (16384 by=
tes):

Without --innodb_use_native_aio=3D0 as a container argument this starts
without error.

$ sudo losetup --direct-io=3Doff  -f btrfs.blk also exhibits the failure

Observed failures in:
* 5.17.0-0.rc4.96.fc36.x86_64
* 5.16.8 (on nixos)
* 5.15.6

No observed failure:
* 5.15.14-200.fc35.x86_64
* 5.10

references:
* https://jira.mariadb.org/browse/MDEV-27900
* https://github.com/NixOS/nixpkgs/issues/160516
* https://jira.mariadb.org/browse/MDEV-27449

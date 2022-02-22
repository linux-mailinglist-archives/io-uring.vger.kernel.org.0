Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED14BF853
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 13:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiBVMri (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 07:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiBVMrg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 07:47:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7720A12859F;
        Tue, 22 Feb 2022 04:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD7760FDA;
        Tue, 22 Feb 2022 12:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694CAC340E8;
        Tue, 22 Feb 2022 12:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645534029;
        bh=ZZtmi+1Df6i1IoRmJ1zfgD0eKjbVvWPa2oaByiLYk2E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KJlB23/92Z7F3NRCwqYFcffXz3xEwU0t5CIUfn0py/ox3xhaMJcSJ7Dw3Mb3Rt71W
         +elaKECrtvUsxKAKUJUxsftM+kjFrK/h68vGqy2gHXXAd8i9tUI1ZMaXYFSkd9AZBM
         l6+iGLDDvc+4bJUwbWzRBtKuwdAk49v9qMhooX/2eHMc3iFIc0TTb7VjY+dkrozrR3
         M5J3rLjpvwpLaDIAo7SA8OPk8jy1xnHyVgWIaBI4U68Yd8rVDZWI+k2CBP4Yjq85H6
         GD1r73UgdXCaC2Up8SadzpjsKVegNUK3MhxqTTs5uwPx26RFFhnvbozbUSyqE3ZG1b
         Ov2LgyAblSFfg==
Received: by mail-qv1-f49.google.com with SMTP id fc19so3841455qvb.7;
        Tue, 22 Feb 2022 04:47:09 -0800 (PST)
X-Gm-Message-State: AOAM531wESxmHWPaKgz7Ydl+K7rQdKca33QAzPz2JgLvavnCuMTxvD6C
        TsNdiepp+1tW1Ss8XhpEHCR+WfvczJh2k8C4j7s=
X-Google-Smtp-Source: ABdhPJz6BILwaQLmC23CiiZkNy3PB2UOUA2m+QZ2JoflZwEaw0JaYObfKcxtyH8sJgHcwem+WZoB5Dk1Sb/fgYQW+Vw=
X-Received: by 2002:a05:6214:2b0f:b0:42b:fd3b:8b24 with SMTP id
 jx15-20020a0562142b0f00b0042bfd3b8b24mr19028154qvb.30.1645534028467; Tue, 22
 Feb 2022 04:47:08 -0800 (PST)
MIME-Version: 1.0
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
 <YhTMBFrZeEvROh0C@debian9.Home> <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
In-Reply-To: <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 22 Feb 2022 12:46:32 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com>
Message-ID: <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com>
Subject: Re: Fwd: btrfs / io-uring corrupting reads
To:     Daniel Black <daniel@mariadb.org>
Cc:     io-uring@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 22, 2022 at 12:22 PM Daniel Black <daniel@mariadb.org> wrote:
>
> On Tue, Feb 22, 2022 at 10:42 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> > I gave it a try, but it fails setting up io_uring:
> >
> > 2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (disabling future attempts)
> > 2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with errno 1
> > 2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to innodb_use_native_aio=OFF
> > 2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
> > 2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool
> >
> > So that's why it doesn't fail here, as it fallbacks to no aio mode.
>
> error 1 is EPERM. Seems it needs --privileged on the container startup
> as a podman argument (before the image name). Sorry I missed that
>
> > Any idea why it's failing to setup io_uring?
> >
> > I have the liburing2 and liburing-dev packages installed on debian, and
> > tried with a 5.17-rc4 kernel.
>
> Taking https://packages.debian.org/bookworm/mariadb-server-core-10.6 package:
>
> mariadb-install-db --no-defaults --datadir=/empty/btrfs/path
> --innodb-use-native-aio=0
>
> mariadbd --no-defaults --datadir=/empty/btrfs/path --innodb-use-native-aio=1
>
> should achieve the same thing.

Sorry, I have no experience with mariadb and podman. How am I supposed
to run that?
Is that supposed to run inside the container, on the host? Do I need
to change the podman command lines?

What I did before was:

DEV=/dev/sdh
MNT=/mnt/sdh

mkfs.btrfs -f $DEV
mount $DEV $MNT

mkdir $MNT/noaio
chown fdmanana: $MNT/noaio

podman run --name mdbinit --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
--innodb_use_native_aio=0


Then in another shell:

podman kill --all

podman run --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
--innodb_use_native_aio=1


What should I change or add in there?

Thanks.

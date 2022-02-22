Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742A74BF867
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 13:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiBVMz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 07:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiBVMz5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 07:55:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48B7128DEF;
        Tue, 22 Feb 2022 04:55:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA44B818FA;
        Tue, 22 Feb 2022 12:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F7C340E8;
        Tue, 22 Feb 2022 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645534529;
        bh=qB6D13taUv08S3fe71dFG+0qc2B8oJzJkanitzPuHvI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gbPPBjwhej/DCjjE7Wun9lJ1fhplJLNS422cRb0FvIZOOoyPFT5dyJEXpj21uzZY2
         FBoQVGVVVk2H685g5B37U/Q77yOgoEJ1fupCINkvoGwH4Z7aqi+209OggpOB9H8hTo
         v4YEMomEAqDkhuLljcnGRDYZS06if0mgJiXlS2fvAkSxWm9Fi4Yscj2d9FnHl2P+oD
         RszDeqggMNlH5Q7tMSnHKCvBkUZOQaofPB6vfVKfvHcIYw8OlGt4eR5uO4BPjhps0+
         5DXd0hyAprrGFZzouLQvFQPeQYu16kVaWLmeTmSuYo4PI3hoJ0xvSntf2ec3oTN8g/
         wUJiRo7zkhepQ==
Received: by mail-qv1-f50.google.com with SMTP id 8so5416084qvf.2;
        Tue, 22 Feb 2022 04:55:28 -0800 (PST)
X-Gm-Message-State: AOAM531xE5GcuoYco0+UC5ScBYSdUrg1tqKP5vNMP9vyC/LVa/KcSX8D
        ka9IKRtDka78jykfgGCkVtkOeZnqtLaIiC91gl0=
X-Google-Smtp-Source: ABdhPJyU/O6sPf7hQsJUxeTEq02dqsIXxONUaRB6sBe9eyhAPHwJmSL/RRlgBBD8f7L7th80EBjShusweRPpddC/dpo=
X-Received: by 2002:a05:622a:198c:b0:2de:707:b1d9 with SMTP id
 u12-20020a05622a198c00b002de0707b1d9mr9926879qtc.233.1645534528041; Tue, 22
 Feb 2022 04:55:28 -0800 (PST)
MIME-Version: 1.0
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
 <YhTMBFrZeEvROh0C@debian9.Home> <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
 <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com>
In-Reply-To: <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 22 Feb 2022 12:54:52 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4gwg+9ACTZV-BF_kr6QQ6-AFFtufezo2KYrVORC81QhQ@mail.gmail.com>
Message-ID: <CAL3q7H4gwg+9ACTZV-BF_kr6QQ6-AFFtufezo2KYrVORC81QhQ@mail.gmail.com>
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

On Tue, Feb 22, 2022 at 12:46 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Tue, Feb 22, 2022 at 12:22 PM Daniel Black <daniel@mariadb.org> wrote:
> >
> > On Tue, Feb 22, 2022 at 10:42 PM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > > I gave it a try, but it fails setting up io_uring:
> > >
> > > 2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (disabling future attempts)
> > > 2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with errno 1
> > > 2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to innodb_use_native_aio=OFF
> > > 2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
> > > 2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool
> > >
> > > So that's why it doesn't fail here, as it fallbacks to no aio mode.
> >
> > error 1 is EPERM. Seems it needs --privileged on the container startup
> > as a podman argument (before the image name). Sorry I missed that
> >
> > > Any idea why it's failing to setup io_uring?
> > >
> > > I have the liburing2 and liburing-dev packages installed on debian, and
> > > tried with a 5.17-rc4 kernel.
> >
> > Taking https://packages.debian.org/bookworm/mariadb-server-core-10.6 package:
> >
> > mariadb-install-db --no-defaults --datadir=/empty/btrfs/path
> > --innodb-use-native-aio=0
> >
> > mariadbd --no-defaults --datadir=/empty/btrfs/path --innodb-use-native-aio=1
> >
> > should achieve the same thing.
>
> Sorry, I have no experience with mariadb and podman. How am I supposed
> to run that?
> Is that supposed to run inside the container, on the host? Do I need
> to change the podman command lines?
>
> What I did before was:
>
> DEV=/dev/sdh
> MNT=/mnt/sdh
>
> mkfs.btrfs -f $DEV
> mount $DEV $MNT
>
> mkdir $MNT/noaio
> chown fdmanana: $MNT/noaio
>
> podman run --name mdbinit --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> --innodb_use_native_aio=0
>
>
> Then in another shell:
>
> podman kill --all
>
> podman run --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> --innodb_use_native_aio=1
>
>
> What should I change or add in there?

Ok, just passing  --privileged to both podman commands triggered the
bug as in your report.
I'll see if I can figure out what's causing the read corruption.


>
> Thanks.

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649934C97EC
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 22:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiCAVwx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 16:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiCAVws (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 16:52:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465C8090E
        for <io-uring@vger.kernel.org>; Tue,  1 Mar 2022 13:52:05 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r13so34234324ejd.5
        for <io-uring@vger.kernel.org>; Tue, 01 Mar 2022 13:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6Yp2lR+BpwAyJfH9Aw/L0Iar9s0NkRJeOkJoTWGXkA=;
        b=Efhmp5nxumcx6cbUAab+E/zCp09YRNR05gs7oZo2e438QXfzSvX6V8oM1DyVolJ6jn
         3/AsLmumBY3gKoTejgBNuRye05L/+h149AkRi0GbtVl76hoWPvubBlzyxFNOQbH3hjSM
         iF7JEyqPlNVD5lS7UezB9Pih829gXHSqT+sK5YdQ9zmiAqiHbSVieE03gaUaCBuymBQC
         OxQnXSQRJkCnJM11Zg0ZV8mAUuJFOOdzlDtIQZdXGQElRXQ18TM7JrcDzOrQUscHlN2d
         ijQQiX+ukMHTRQClWd+NmvG/Cr/A9MR8i78434cfU31OmUhNwZEtU2KvZOONJNxT/YkL
         7Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6Yp2lR+BpwAyJfH9Aw/L0Iar9s0NkRJeOkJoTWGXkA=;
        b=ZJBEdJeMDaCEx2r87hJiSUaJtv5m/WNuVksOQeBihdQuCEXVmRMz0fBpQ/DNZOcxoF
         RyWHFwTvLi8UnZyCtmpb3W96bJ8r+dg4bxO6rgi3/Un9qiY71QnBvjHpQR7TjVyw/oKb
         4vAPYGBfJYELwhSykGVT8EuCoV8mDO1XIFpZ4ft58bUjoI7+CAXzwv27dXqxNg9ee95S
         kQsJhp/FuWR9cj7UIE3ko98IzxMjLJ41HgON1OpIQFq4KlyOR8G9VZjz3OPAoyE0Rujq
         QXU5S1u4mEO1F7pjI+gIli3kwqWcTV18GSqEeENbz3h2ljdKgs+hL0ua514BMaJrG5u7
         eXvw==
X-Gm-Message-State: AOAM530qSJh6GfD1Q/YGR9wbXQ96YcyHOHWQEjXSB2SjJXa0WEHVFlC8
        4T3dzVqlYMokEcoCHmrCd4TyRri1V/1aeIMyypuHcA==
X-Google-Smtp-Source: ABdhPJxLDGRSYtAJlyeGdiSUWmTbpf401vQ1U+kE736PaDarkzMPKOOvLF8ygmNe8k3yzB7YDO2vWho8YVJTeUBMp7k=
X-Received: by 2002:a17:906:37cf:b0:6ce:6321:5ecb with SMTP id
 o15-20020a17090637cf00b006ce63215ecbmr20897106ejc.385.1646171524297; Tue, 01
 Mar 2022 13:52:04 -0800 (PST)
MIME-Version: 1.0
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
 <YhTMBFrZeEvROh0C@debian9.Home> <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
 <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com> <CAL3q7H4gwg+9ACTZV-BF_kr6QQ6-AFFtufezo2KYrVORC81QhQ@mail.gmail.com>
In-Reply-To: <CAL3q7H4gwg+9ACTZV-BF_kr6QQ6-AFFtufezo2KYrVORC81QhQ@mail.gmail.com>
From:   Daniel Black <daniel@mariadb.org>
Date:   Wed, 2 Mar 2022 08:51:53 +1100
Message-ID: <CABVffEOWjSg+8pqzALuLt6mMviA0y7XRwsdJyv9_DodWKQFpqQ@mail.gmail.com>
Subject: Re: Fwd: btrfs / io-uring corrupting reads
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Filipe,

DId you find anything? This is starting to be noticed by our mutual users.

https://jira.mariadb.org/browse/MDEV-27900
https://mariadb.zulipchat.com/#narrow/stream/118759-general/topic/Corrupt.20database.20page.20when.20updating.20from.2010.2E5

On Tue, Feb 22, 2022 at 11:55 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Tue, Feb 22, 2022 at 12:46 PM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > On Tue, Feb 22, 2022 at 12:22 PM Daniel Black <daniel@mariadb.org> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 10:42 PM Filipe Manana <fdmanana@kernel.org> wrote:
> > >
> > > > I gave it a try, but it fails setting up io_uring:
> > > >
> > > > 2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (disabling future attempts)
> > > > 2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with errno 1
> > > > 2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to innodb_use_native_aio=OFF
> > > > 2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
> > > > 2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool
> > > >
> > > > So that's why it doesn't fail here, as it fallbacks to no aio mode.
> > >
> > > error 1 is EPERM. Seems it needs --privileged on the container startup
> > > as a podman argument (before the image name). Sorry I missed that
> > >
> > > > Any idea why it's failing to setup io_uring?
> > > >
> > > > I have the liburing2 and liburing-dev packages installed on debian, and
> > > > tried with a 5.17-rc4 kernel.
> > >
> > > Taking https://packages.debian.org/bookworm/mariadb-server-core-10.6 package:
> > >
> > > mariadb-install-db --no-defaults --datadir=/empty/btrfs/path
> > > --innodb-use-native-aio=0
> > >
> > > mariadbd --no-defaults --datadir=/empty/btrfs/path --innodb-use-native-aio=1
> > >
> > > should achieve the same thing.
> >
> > Sorry, I have no experience with mariadb and podman. How am I supposed
> > to run that?
> > Is that supposed to run inside the container, on the host? Do I need
> > to change the podman command lines?
> >
> > What I did before was:
> >
> > DEV=/dev/sdh
> > MNT=/mnt/sdh
> >
> > mkfs.btrfs -f $DEV
> > mount $DEV $MNT
> >
> > mkdir $MNT/noaio
> > chown fdmanana: $MNT/noaio
> >
> > podman run --name mdbinit --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> > MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> > quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> > --innodb_use_native_aio=0
> >
> >
> > Then in another shell:
> >
> > podman kill --all
> >
> > podman run --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> > MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> > quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> > --innodb_use_native_aio=1
> >
> >
> > What should I change or add in there?
>
> Ok, just passing  --privileged to both podman commands triggered the
> bug as in your report.
> I'll see if I can figure out what's causing the read corruption.
>
>
> >
> > Thanks.

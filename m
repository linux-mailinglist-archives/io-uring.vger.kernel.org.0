Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A904CA3A4
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 12:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiCBL3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 06:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBL3D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 06:29:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2DD3ED35;
        Wed,  2 Mar 2022 03:28:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D4B61804;
        Wed,  2 Mar 2022 11:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB75CC004E1;
        Wed,  2 Mar 2022 11:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646220499;
        bh=NNW4l+jluOy6hGNsds61IYRiSLBNoFZnVB4BY5EzUeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJrIu5HiHUVuYb1YtJcldJe13nkso3YpgyfAL7is/pavjDfZJ7bTd3A8pRUeqMcN4
         BpqXtZaWFhShjX+U3caPGbOw6QlpZbMizPZQwU+fZ9hiJx94y9E65Li0IGhWYhpM4L
         uJlzE55FQwGV6WnfgFlnXsyBmYgp8kxDXHkAJuGq24/23ev0r6rZowonCaV7hc8Jhz
         wckbfc5fV2oNMcD8omZM4ebCCgaPoR69RQeeJ1jxSVsI1pCfDbynUJ/8KaoodVfDIJ
         1NwILteumnfROBqmcq3QtSVDr2Zk5+GLpsmZgPcvaBwzXIeXY8jI2cnrktJl1HHIaY
         PNyRKbeaEvtqA==
Date:   Wed, 2 Mar 2022 11:28:16 +0000
From:   Filipe Manana <fdmanana@kernel.org>
To:     Daniel Black <daniel@mariadb.org>
Cc:     io-uring@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: btrfs / io-uring corrupting reads
Message-ID: <Yh9U0PSU+gfWGqU+@debian9.Home>
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com>
 <YhTMBFrZeEvROh0C@debian9.Home>
 <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
 <CAL3q7H5mSV69ambZy_uCnTMOW7U0n_fU1DtVNA-FYwDdHVrp9w@mail.gmail.com>
 <CAL3q7H4gwg+9ACTZV-BF_kr6QQ6-AFFtufezo2KYrVORC81QhQ@mail.gmail.com>
 <CABVffEOWjSg+8pqzALuLt6mMviA0y7XRwsdJyv9_DodWKQFpqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVffEOWjSg+8pqzALuLt6mMviA0y7XRwsdJyv9_DodWKQFpqQ@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 02, 2022 at 08:51:53AM +1100, Daniel Black wrote:
> Filipe,
> 
> DId you find anything? This is starting to be noticed by our mutual users.

Yes, I've sent a patch to address it:

https://lore.kernel.org/linux-btrfs/39c96b5608ed99b7d666d4d159f8d135e86b9606.1646219178.git.fdmanana@suse.com/T/#u

The details are in the changelog.

Basically, MariaDB is getting a short read - it asks to read 16K of data
but it only gets the first 4K of data (or the first 8K or 12K). It treats
such partial read as a corruption, but in fact it could check that it's a
short read and then try to read the remaining data.

I understand it's an unexpected result, since it knows its read requests
don't cross the EOF boundary and knows exactly the length and file offsets
of its pages/blocks, so it expects a read requesting 16K of data to return
exactly 16K of data, and no less than that. I've worked in the database
industry before, and the same assumptions existed on the engines I worked on.
Either way it was a behaviour change in btrfs and it can, and should be,
addressed in btrfs.

And yes, before your report, there was at least another on the btrfs mailing
list from someone getting MariaDB corruptions on btrfs only. However yours had
a useful reproducer that made it easier to dig into.

Thanks.

> 
> https://jira.mariadb.org/browse/MDEV-27900
> https://mariadb.zulipchat.com/#narrow/stream/118759-general/topic/Corrupt.20database.20page.20when.20updating.20from.2010.2E5
> 
> On Tue, Feb 22, 2022 at 11:55 PM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > On Tue, Feb 22, 2022 at 12:46 PM Filipe Manana <fdmanana@kernel.org> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 12:22 PM Daniel Black <daniel@mariadb.org> wrote:
> > > >
> > > > On Tue, Feb 22, 2022 at 10:42 PM Filipe Manana <fdmanana@kernel.org> wrote:
> > > >
> > > > > I gave it a try, but it fails setting up io_uring:
> > > > >
> > > > > 2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (disabling future attempts)
> > > > > 2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with errno 1
> > > > > 2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to innodb_use_native_aio=OFF
> > > > > 2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
> > > > > 2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool
> > > > >
> > > > > So that's why it doesn't fail here, as it fallbacks to no aio mode.
> > > >
> > > > error 1 is EPERM. Seems it needs --privileged on the container startup
> > > > as a podman argument (before the image name). Sorry I missed that
> > > >
> > > > > Any idea why it's failing to setup io_uring?
> > > > >
> > > > > I have the liburing2 and liburing-dev packages installed on debian, and
> > > > > tried with a 5.17-rc4 kernel.
> > > >
> > > > Taking https://packages.debian.org/bookworm/mariadb-server-core-10.6 package:
> > > >
> > > > mariadb-install-db --no-defaults --datadir=/empty/btrfs/path
> > > > --innodb-use-native-aio=0
> > > >
> > > > mariadbd --no-defaults --datadir=/empty/btrfs/path --innodb-use-native-aio=1
> > > >
> > > > should achieve the same thing.
> > >
> > > Sorry, I have no experience with mariadb and podman. How am I supposed
> > > to run that?
> > > Is that supposed to run inside the container, on the host? Do I need
> > > to change the podman command lines?
> > >
> > > What I did before was:
> > >
> > > DEV=/dev/sdh
> > > MNT=/mnt/sdh
> > >
> > > mkfs.btrfs -f $DEV
> > > mount $DEV $MNT
> > >
> > > mkdir $MNT/noaio
> > > chown fdmanana: $MNT/noaio
> > >
> > > podman run --name mdbinit --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> > > MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> > > quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> > > --innodb_use_native_aio=0
> > >
> > >
> > > Then in another shell:
> > >
> > > podman kill --all
> > >
> > > podman run --rm -v $MNT/noaio/:/var/lib/mysql:Z -e
> > > MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1
> > > quay.io/danielgblack/mariadb-test:10.6-impish-sysbench
> > > --innodb_use_native_aio=1
> > >
> > >
> > > What should I change or add in there?
> >
> > Ok, just passing  --privileged to both podman commands triggered the
> > bug as in your report.
> > I'll see if I can figure out what's causing the read corruption.
> >
> >
> > >
> > > Thanks.

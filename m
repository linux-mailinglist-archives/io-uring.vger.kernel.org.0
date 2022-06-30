Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE155618BC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 13:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiF3LJH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 07:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiF3LJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 07:09:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764D433BC;
        Thu, 30 Jun 2022 04:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614C762285;
        Thu, 30 Jun 2022 11:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D604C34115;
        Thu, 30 Jun 2022 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656587342;
        bh=RPRN+JN7GXMRgtjuNhD7qT6toxuYv9she5ZM/dG4Dik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCJAbPeVSr0JCrPJu68GHOaqq9Bh9Z/0G3bwtgEoIACLPjzIrvvaUUGntnuaOMGSU
         UJ3OvP2Fzf0zAsPeQHiD9ZcLVSy9ZI7Sy1IqvWl1FPEmLbn5Jl6fWrxka5L7dhb49i
         5rWrpA/EwD3VuX+lC4ehqM+9b+qRsojj1b4qbIoN+nj4AtiIWXqa2AERtAItPf5FjS
         kZHJJYwjJYnK7vUlzrb6pj/7KIugLLxEIiCqXOQW4zMNr21OGcYqc8BO6GpiPkQO7V
         XCMLmoV5lLRQZIU9HY4pT1f83tnvXfobLjAkcly3AzmCaKMFV6nVfkn1eOrLhPQF9R
         ousnmbrXwHNJQ==
Date:   Thu, 30 Jun 2022 12:09:00 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <20220630110900.GA438014@falcondesktop>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630104536.GA434846@falcondesktop>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 11:45:36AM +0100, Filipe Manana wrote:
> On Thu, Jun 30, 2022 at 04:56:37PM +0900, Dominique MARTINET wrote:
> > Dominique MARTINET wrote on Thu, Jun 30, 2022 at 09:41:01AM +0900:
> > > > I just tried your program, against the qemu/vmdk image you mentioned in the
> > > > first message, and after over an hour running I couldn't trigger any short
> > > > reads - this was on the integration misc-next branch.
> > > >
> > > > It's possible that to trigger the issue, one needs a particular file extent
> > > > layout, which will not be the same as yours after downloading and converting
> > > > the file.
> > > 
> > > Ugh. I've also been unable to reproduce on a test fs, despite filling it
> > > with small files and removing some to artificially fragment the image,
> > > so I guess I really do have something on these "normal" filesystems...
> > > 
> > > Is there a way to artificially try to recreate weird layouts?
> > > I've also tried btrfs send|receive, but while it did preserve reflinked
> > > extents it didn't seem to do the trick.
> > 
> > I take that one back, I was able to reproduce with my filesystem riddled
> > with holes.
> > I was just looking at another distantly related problem that happened
> > with cp, but trying with busybox cat didn't reproduce it and got
> > confused:
> > https://lore.kernel.org/linux-btrfs/Yr1QwVW+sHWlAqKj@atmark-techno.com/T/#u
> > 
> > 
> > Anyway, here's a pretty ugly reproducer to create a file that made short
> > reads on a brand new FS:
> > 
> > # 50GB FS -> fill with 50GB of small files and remove 1/10
> > $ mkdir /mnt/d.{00..50}
> > $ for i in {00000..49999}; do
> > 	dd if=/dev/urandom of=/mnt/d.${i:0:2}/test.$i bs=1M count=1 status=none;
> >   done
> > $ rm -f /mnt/d.*/*2
> > $ btrfs subvolume create ~/sendme
> > $ cp --reflink=always bigfile ~/sendme/bigfile
> > $ btrfs property set ~/sendme ro true
> > $ btrfs send ~/sendme | btrfs receive /mnt/receive
> > 
> > and /mnt/receive/bigfile did the trick for me.
> > This probably didn't need the send/receive at all, I just didn't try
> > plain copy again.
> > 
> > Anyway, happy to test any patch as said earlier, it's probably not worth
> > spending too much time on trying to reproduce on your end at this
> > point...
> 
> That's perfect.
> 
> So here's a patch for you to try:
> 
> https://gist.githubusercontent.com/fdmanana/4b24d6b30983e956bb1784a44873c5dd/raw/572490b127071bf827c3bc05dd58dcb7bcff373a/dio.patch

Actually it's this URL:

https://gist.githubusercontent.com/fdmanana/4b24d6b30983e956bb1784a44873c5dd/raw/0dad2dd3fd14df735f166c2c416dc9265d660493/dio.patch

Thanks.

> 
> Thanks!
> > 
> > -- 
> > Dominique

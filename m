Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC36845D3FC
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 05:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbhKYEsB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 23:48:01 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:29454 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236673AbhKYEqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 23:46:00 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 3069946142A;
        Thu, 25 Nov 2021 04:42:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a278.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id BB65D4611BB;
        Thu, 25 Nov 2021 04:42:48 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a278.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.100.11.72 (trex/6.4.3);
        Thu, 25 Nov 2021 04:42:49 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Thoughtful-Thoughtful: 609f5ee056e614d8_1637815369041_1164783980
X-MC-Loop-Signature: 1637815369041:2682771033
X-MC-Ingress-Time: 1637815369041
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a278.dreamhost.com (Postfix) with ESMTPSA id 4J04xN43p0z29;
        Wed, 24 Nov 2021 20:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1637815368; bh=2eQXOCQLBjTZEE4Yunh+/bMkWHc=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=YdTPpEqMgsGSBZ9tT1OvsAeYvs9aeypsSCfoF4fwpDTHiGiKmdP3xklF2tYQJviCL
         FeiEjKfvbTfYKV6mgVLPnA86DsGZk1b9jHQjcfzgcx0RjcNbuhOmqqu7LpVUMzV6ef
         1xXF36wII07c1rHojBScIsru4FbM8xTJHt6nn3L8=
Date:   Wed, 24 Nov 2021 22:42:47 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] io_uring: add getdents64 support
Message-ID: <20211125044246.ve2433klyjua3a6d@ps29521.dreamhostps.com>
References: <20211124231700.1158521-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124231700.1158521-1-shr@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


I seem to recall making a few comments the last time a getdents64
for io_uring was proposed; in particular I wanted to bring up one
here.  This applies only to altering the internal interface, which
io_uring would use, although wiring up a new syscall would be a nice
addition.

The current interface has 2 issues:

1)
getdents64 requires at least two calls to read a directory.
One or more to get the dents and a final call to see the EOF.
With small directories, this means literally 50% of the calls
are wasted.

2)
The fpos cannot be changed atomically with a read, so it is not
possible to to safely perform concurrent reads on the same fd.

But, the kernel knows (most, if not all of the time) that it is at
EOF at the time it returns the last buffer.  So, it would be very
useful to get an EOF indicator back with the final buffer.  This
could just a flag, or for instance make an fpos parameter which is
both input and output, returning the (post read) fpos or zero at
EOF.

Futhermore, for input, one could supply:
	0:	Start from directory beginning
	-1:	Read from current position
	other:	(output from previous call) Read from here

On Wed, Nov 24 2021 at 15:16:57 -0800, Stefan Roesch quoth thus:

> This series adds support for getdents64 in liburing. The intent is to
> provide a more complete I/O interface for io_uring.
> 
> Patch 1: fs: add parameter use_fpos to iterate_dir()
>   This adds a new parameter to the function iterate_dir() so the
>   caller can specify if the position is the file position or the
>   position stored in the buffer context.
> 
> Patch 2: fs: split off vfs_getdents function from getdents64 system call
>   This splits of the iterate_dir part of the syscall in its own
>   dedicated function. This allows to call the function directly from
>   liburing.
> 
> Patch 3: io_uring: add support for getdents64
>   Adds the functions to io_uring to support getdents64.
> 
> There is also a patch series for the changes to liburing. This includes
> a new test. The patch series is called "liburing: add getdents support."
> 
> The following tests have been performed:
> - new liburing getdents test program has been run
> - xfstests have been run
> - both tests have been repeated with the kernel memory leak checker
>   and no leaks have been reported.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
> V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha with
>     the additional parameter.
> 
> Stefan Roesch (3):
>   fs: add parameter use_fpos to iterate_dir function
>   fs: split off vfs_getdents function of getdents64 syscall
>   io_uring: add support for getdents64
> 
>  arch/alpha/kernel/osf_sys.c   |  2 +-
>  fs/ecryptfs/file.c            |  2 +-
>  fs/exportfs/expfs.c           |  2 +-
>  fs/internal.h                 |  8 +++++
>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++
>  fs/ksmbd/smb2pdu.c            |  2 +-
>  fs/ksmbd/vfs.c                |  4 +--
>  fs/nfsd/nfs4recover.c         |  2 +-
>  fs/nfsd/vfs.c                 |  2 +-
>  fs/overlayfs/readdir.c        |  6 ++--
>  fs/readdir.c                  | 64 ++++++++++++++++++++++++++---------
>  include/linux/fs.h            |  2 +-
>  include/uapi/linux/io_uring.h |  1 +
>  13 files changed, 121 insertions(+), 28 deletions(-)
> 
> 
> base-commit: f0afafc21027c39544a2c1d889b0cff75b346932
> -- 
> 2.30.2

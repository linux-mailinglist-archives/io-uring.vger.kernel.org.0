Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8347E1EF
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 12:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhLWLFA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 06:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbhLWLFA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 06:05:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C786C61E2A;
        Thu, 23 Dec 2021 11:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285F4C36AE5;
        Thu, 23 Dec 2021 11:04:56 +0000 (UTC)
Date:   Thu, 23 Dec 2021 12:04:53 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v6 0/5] io_uring: add xattr support
Message-ID: <20211223110453.zbyah76jpc3ivjfp@wittgenstein>
References: <20211222210127.958902-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211222210127.958902-1-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 01:01:22PM -0800, Stefan Roesch wrote:
> This adds the xattr support to io_uring. The intent is to have a more
> complete support for file operations in io_uring.
> 
> This change adds support for the following functions to io_uring:
> - fgetxattr
> - fsetxattr
> - getxattr
> - setxattr
> 
> Patch 1: fs: split off do_user_path_at_empty from user_path_at_empty()
>   This splits off a new function do_user_path_at_empty from
>   user_path_at_empty that is based on filename and not on a
>   user-specified string.
> 
> Patch 2: fs: split off setxattr_setup function from setxattr
>   Split off the setup part of the setxattr function.
> 
> Patch 3: fs: split off do_getxattr from getxattr
>   Split of the do_getxattr part from getxattr. This will
>   allow it to be invoked it from io_uring.
> 
> Patch 4: io_uring: add fsetxattr and setxattr support
>   This adds new functions to support the fsetxattr and setxattr
>   functions.
> 
> Patch 5: io_uring: add fgetxattr and getxattr support
>   This adds new functions to support the fgetxattr and getxattr
>   functions.
> 
> 
> There are two additional patches:
>   liburing: Add support for xattr api's.
>             This also includes the tests for the new code.
>   xfstests: Add support for io_uring xattr support.
> 
> 
> V6: - reverted addition of kname array to xattr_ctx structure
>       Adding the kname array increases the io_kiocb beyond 64 bytes
>       (increases it to 224 bytes). We try hard to limit it to 64 bytes.
>       Keeping the original interface also is a bit more efficient.
>     - rebased on for-5.17/io_uring-getdents64
> V5: - add kname array to xattr_ctx structure
> V4: - rebased patch series
> V3: - remove req->file checks in prep functions
>     - change size parameter in do_xattr
> V2: - split off function do_user_path_empty instead of changing
>       the function signature of user_path_at
>     - Fix datatype size problem in do_getxattr
> 
> 
> 
> Stefan Roesch (5):
>   fs: split off do_user_path_at_empty from user_path_at_empty()
>   fs: split off setxattr_setup function from setxattr
>   fs: split off do_getxattr from getxattr
>   io_uring: add fsetxattr and setxattr support
>   io_uring: add fgetxattr and getxattr support
> 
>  fs/internal.h                 |  23 +++
>  fs/io_uring.c                 | 318 ++++++++++++++++++++++++++++++++++
>  fs/namei.c                    |  10 +-
>  fs/xattr.c                    | 107 ++++++++----
>  include/linux/namei.h         |   2 +
>  include/uapi/linux/io_uring.h |   8 +-
>  6 files changed, 428 insertions(+), 40 deletions(-)
> 
> 
> base-commit: b4518682080d3a1cdd6ea45a54ff6772b8b2797a

Jens, please keep me in the loop once this series lands.
I maintain a large vfs testsuite for idmapped mounts (It's actually a
generic testsuite which also tests idmapped mounts.) and it currently
already has tests for io_uring:

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c#n6942

Once this lands we need to expand it to test xattr support for io_uring
as well (It should probably also include mkdir/link/mknod that we added
last cycle.).

Christian

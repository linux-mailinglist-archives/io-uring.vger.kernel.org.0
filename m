Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7591848651D
	for <lists+io-uring@lfdr.de>; Thu,  6 Jan 2022 14:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiAFNU1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Jan 2022 08:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiAFNU1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Jan 2022 08:20:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314E2C061245;
        Thu,  6 Jan 2022 05:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3B0661C00;
        Thu,  6 Jan 2022 13:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E5FC36AE5;
        Thu,  6 Jan 2022 13:20:24 +0000 (UTC)
Date:   Thu, 6 Jan 2022 14:20:21 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v12 0/4] io_uring: add xattr support
Message-ID: <20220106132021.n2cwzvf2winkw3qk@wittgenstein>
References: <20220105221830.2668297-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220105221830.2668297-1-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 05, 2022 at 02:18:26PM -0800, Stefan Roesch wrote:
> This adds the xattr support to io_uring. The intent is to have a more
> complete support for file operations in io_uring.
> 
> This change adds support for the following functions to io_uring:
> - fgetxattr
> - fsetxattr
> - getxattr
> - setxattr
> 
> Patch 1: fs: split off setxattr_copy and do_setxattr function from setxattr
>   Split off the setup part of the setxattr function in the setxattr_copy
>   function. Split off the processing part in do_setxattr.
> 
> Patch 2: fs: split off do_getxattr from getxattr
>   Split of the do_getxattr part from getxattr. This will
>   allow it to be invoked it from io_uring.
> 
> Patch 3: io_uring: add fsetxattr and setxattr support
>   This adds new functions to support the fsetxattr and setxattr
>   functions.
> 
> Patch 4: io_uring: add fgetxattr and getxattr support
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
> V12: - add union to xattr_ctx structure. The getxattr api requires
>        a pointer to value and the setxattr requires a const pointer
>        to value (with a union this can be unified).

I'm fine with adding a union in there. I think it's also what Linus
suggested in a previous mail. Al suggested a different allocation for
the attribute name. Fwiw, I'm fine with either (struct kattr or
dynamically allocating via an additional helper).

I've ran this through the generic vfs and idmapped mount xfstests I
added last year. They do test core xattr functionality. I've applied
your patchset on top of Jen's for-next. They pass:

ubuntu@f2-vm:~/src/git/xfstests$ sudo ./check -g idmapped
SECTION       -- xfs
RECREATING    -- xfs on /dev/loop4
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc3-fs-xattr-c62607c023ad #41 SMP PREEMPT Thu Jan 6 12:11:34 UTC 2022
MKFS_OPTIONS  -- -f -f /dev/loop5
MOUNT_OPTIONS -- /dev/loop5 /mnt/scratch

generic/633 26s ...  29s
generic/644 5s ...  19s
generic/645 413s ...  225s
generic/656 13s ...  21s
xfs/152 70s ...  75s
xfs/153 46s ...  48s
Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
Passed all 6 tests

SECTION       -- ext4
RECREATING    -- ext4 on /dev/loop4
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc3-fs-xattr-c62607c023ad #41 SMP PREEMPT Thu Jan 6 12:11:34 UTC 2022
MKFS_OPTIONS  -- -F -F /dev/loop5
MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop5 /mnt/scratch

generic/633 29s ...  20s
generic/644 19s ...  5s
generic/645 225s ...  208s
generic/656 21s ...  12s
Ran: generic/633 generic/644 generic/645 generic/656
Passed all 4 tests

SECTION       -- btrfs
RECREATING    -- btrfs on /dev/loop4
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 f2-vm 5.16.0-rc3-fs-xattr-c62607c023ad #41 SMP PREEMPT Thu Jan 6 12:11:34 UTC 2022
MKFS_OPTIONS  -- -f /dev/loop5
MOUNT_OPTIONS -- /dev/loop5 /mnt/scratch

btrfs/245 10s ...  11s
generic/633 20s ...  25s
generic/644 5s ...  4s
generic/645 208s ...  209s
generic/656 12s ...  14s
Ran: btrfs/245 generic/633 generic/644 generic/645 generic/656
Passed all 5 tests

SECTION       -- xfs
=========================
Ran: generic/633 generic/644 generic/645 generic/656 xfs/152 xfs/153
Passed all 6 tests

SECTION       -- ext4
=========================
Ran: generic/633 generic/644 generic/645 generic/656
Passed all 4 tests

SECTION       -- btrfs
=========================
Ran: btrfs/245 generic/633 generic/644 generic/645 generic/656
Passed all 5 tests

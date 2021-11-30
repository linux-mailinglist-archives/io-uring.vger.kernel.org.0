Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC3D46298B
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhK3BVM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 20:21:12 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:44829 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230248AbhK3BVM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 20:21:12 -0500
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 9DA9D4604D8;
        Tue, 30 Nov 2021 01:08:39 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 9384D460ADC;
        Tue, 30 Nov 2021 01:08:38 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.120.81.154 (trex/6.4.3);
        Tue, 30 Nov 2021 01:08:39 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Tangy-Continue: 22fe33492e12c667_1638234519478_3137472009
X-MC-Loop-Signature: 1638234519478:2193917879
X-MC-Ingress-Time: 1638234519478
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4J33xy26Pgz1Rm;
        Mon, 29 Nov 2021 17:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=claycon.org;
        s=claycon.org; t=1638234518; bh=Hrvak8QnYWGMBh+HAWDJjdi4BXA=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=WydMaiDM/Tz3PoBCXNkfGDPmo5rPJ2BIKNyfnoBpUzl+o0QFnueceMQIZWwB3ytf8
         VuIcsBVTzdIAOqpttKPmVribchOXGOwNwAia5k2C3rwm0R4uBwCBnjGxSlF+v21AYd
         kMmYuedLDJXiOqPy51auEXzGDBj9SK2wEQq2VRzQ=
Date:   Mon, 29 Nov 2021 19:08:36 -0600
From:   Clay Harris <bugs@claycon.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Message-ID: <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
References: <20211129221257.2536146-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129221257.2536146-1-shr@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:

> This adds the xattr support to io_uring. The intent is to have a more
> complete support for file operations in io_uring.
> 
> This change adds support for the following functions to io_uring:
> - fgetxattr
> - fsetxattr
> - getxattr
> - setxattr

You may wish to consider the following.

Patching for these functions makes for an excellent opportunity
to provide a better interface.  Rather than implement fXetattr
at all, you could enable io_uring to use functions like:

int Xetxattr(int dfd, const char *path, const char *name,
	[const] void *value, size_t size, int flags);

Not only does this simplify the io_uring interface down to two
functions, but modernizes and fixes a deficit in usability.
In terms of io_uring, this is just changing internal interfaces.

Although unnecessary for io_uring, it would be nice to at least
consider what parts of this code could be leveraged for future
Xetxattr2 syscalls.

> Patch 1: fs: make user_path_at_empty() take a struct filename
>   The user_path_at_empty filename parameter has been changed
>   from a const char user pointer to a filename struct. io_uring
>   operates on filenames.
>   In addition also the functions that call user_path_at_empty
>   in namei.c and stat.c have been modified for this change.
> 
> Patch 2: fs: split off setxattr_setup function from setxattr
>   Split off the setup part of the setxattr function
> 
> Patch 3: fs: split off the vfs_getxattr from getxattr
>   Split of the vfs_getxattr part from getxattr. This will
>   allow to invoke it from io_uring.
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
> Stefan Roesch (5):
>   fs: make user_path_at_empty() take a struct filename
>   fs: split off setxattr_setup function from setxattr
>   fs: split off the vfs_getxattr from getxattr
>   io_uring: add fsetxattr and setxattr support
>   io_uring: add fgetxattr and getxattr support
> 
>  fs/internal.h                 |  23 +++
>  fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
>  fs/namei.c                    |   5 +-
>  fs/stat.c                     |   7 +-
>  fs/xattr.c                    | 114 +++++++-----
>  include/linux/namei.h         |   4 +-
>  include/uapi/linux/io_uring.h |   8 +-
>  7 files changed, 439 insertions(+), 47 deletions(-)
> 
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
> -- 
> 2.30.2

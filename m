Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EF2482093
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhL3WYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 17:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhL3WYL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 17:24:11 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B45C061574;
        Thu, 30 Dec 2021 14:24:11 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n33qC-00G5W8-6R; Thu, 30 Dec 2021 22:24:08 +0000
Date:   Thu, 30 Dec 2021 22:24:08 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Message-ID: <Yc4xiLus+Os4GWZf@zeniv-ca.linux.org.uk>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
 <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
 <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
 <Yc3bYj33YPwpAg8q@zeniv-ca.linux.org.uk>
 <20211230180114.vuum3zorhafd2zta@wittgenstein>
 <5030f5fa-79c3-b3b7-857d-3ac62bf2b982@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030f5fa-79c3-b3b7-857d-3ac62bf2b982@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 30, 2021 at 11:09:12AM -0800, Jens Axboe wrote:

> For each command, there are two steps:
> 
> - The prep of it, this happens inline from the system call where the
>   request, or requests, are submitted. The prep phase should ensure that
>   argument structs are stable. Hence a caller can prep a request and
>   have memory on stack, as long as it submits before it becomes invalid.
>   An example of that are iovecs for readv/writev. The caller does not
>   need to have them stable for the duration of the request, just across
>   submit. That's the io_${cmd}_prep() helpers.
> 
> - The execution of it. May be separate from prep and from an async
>   worker. Where the lower layers don't support a nonblocking attempt,
>   they are always done async. The statx stuff is an example of that.
> 
> Hence prep needs to copy from userland on the prep side always for the
> statx family, as execution will happen out-of-line from the submission.
> 
> Does that explain it?

The actual call chain leading to filename_lookup() is, AFAICS, this:
	io_statx()
		do_statx()
			vfs_statx()
				user_path_at()
					user_path_at_empty()
						filename_lookup()

If you are providing such warranties for the contents of pathname
arguments, you have a bug in statx in the mainline.  If you are not,
there's no point in doing getname() in getxattr prep.

Which one it is?

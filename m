Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575693CAD86
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 22:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344273AbhGOUFx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 16:05:53 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:60554 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbhGOUFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 16:05:46 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m47ZD-000x9z-CX; Thu, 15 Jul 2021 20:02:43 +0000
Date:   Thu, 15 Jul 2021 20:02:43 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH  02/14] namei: clean up do_rmdir retry logic
Message-ID: <YPCUY5kpGCGvSTkU@zeniv-ca.linux.org.uk>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
 <20210715103600.3570667-3-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715103600.3570667-3-dkadashev@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 15, 2021 at 05:35:48PM +0700, Dmitry Kadashev wrote:
> No functional changes, just move the main logic to a helper function to
> make the whole thing easier to follow.

If you are renaming that pile of labels, at least give them names that would
mean something...  And TBH I would probably go for something like

	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
	if (IS_ERR(dentry)) {
		error = PTR_ERR(dentry);
		goto out_unlock;
	}
	if (!dentry->d_inode)
		error = -ENOENT;
	if (!error)
		error = security_path_rmdir(&path, dentry);
	if (!error)
		error = vfs_rmdir(mnt_user_ns(path.mnt),
				  path.dentry->d_inode, dentry);
	dput(dentry);
out_unlock:

there, to simplify that pile a bit...

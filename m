Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEBF380BD7
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhENOdS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhENOdS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 May 2021 10:33:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C0E6141F;
        Fri, 14 May 2021 14:32:04 +0000 (UTC)
Date:   Fri, 14 May 2021 16:32:02 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/6] fs: make do_mkdirat() take struct filename
Message-ID: <20210514143202.dmzfcgz5hnauy7ze@wittgenstein>
References: <20210513110612.688851-1-dkadashev@gmail.com>
 <20210513110612.688851-2-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210513110612.688851-2-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 13, 2021 at 06:06:07PM +0700, Dmitry Kadashev wrote:
> Pass in the struct filename pointers instead of the user string, and
> update the three callers to do the same. This is heavily based on
> commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
> 
> This behaves like do_unlinkat() and do_renameat2().
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---

Independent of the following patches I think this is ok and with
do_renameat2() that form of conversion has precedence.
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

>  fs/internal.h |  1 +
>  fs/namei.c    | 22 ++++++++++++++++------
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 6aeae7ef3380..848e165ef0f1 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -77,6 +77,7 @@ long do_unlinkat(int dfd, struct filename *name);
>  int may_linkat(struct user_namespace *mnt_userns, struct path *link);
>  int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>  		 struct filename *newname, unsigned int flags);
> +long do_mkdirat(int dfd, struct filename *name, umode_t mode);

(We should probably have all helpers just return either long or int
instead of alternating between long and int.)

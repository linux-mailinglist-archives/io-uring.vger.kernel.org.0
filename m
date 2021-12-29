Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943BA48141B
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhL2Obf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 09:31:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2Obe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 09:31:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88447B81905;
        Wed, 29 Dec 2021 14:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C165FC36AE7;
        Wed, 29 Dec 2021 14:31:30 +0000 (UTC)
Date:   Wed, 29 Dec 2021 15:31:26 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v9 1/5] fs: split off do_user_path_at_empty from
 user_path_at_empty()
Message-ID: <20211229143126.advkumqim7tztlmq@wittgenstein>
References: <20211228184145.1131605-1-shr@fb.com>
 <20211228184145.1131605-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211228184145.1131605-2-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 28, 2021 at 10:41:41AM -0800, Stefan Roesch wrote:
> This splits off a do_user_path_at_empty function from the
> user_path_at_empty_function. This is required so it can be
> called from io_uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/namei.c            | 10 ++++++++--
>  include/linux/namei.h |  2 ++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1f9d2187c765..d988e241b32c 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2794,12 +2794,18 @@ int path_pts(struct path *path)
>  }
>  #endif
>  
> +int do_user_path_at_empty(int dfd, struct filename *filename, unsigned int flags,
> +		       struct path *path)
> +{
> +	return filename_lookup(dfd, filename, flags, path, NULL);
> +}
> +
>  int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
> -		 struct path *path, int *empty)
> +		struct path *path, int *empty)
>  {
>  	struct filename *filename = getname_flags(name, flags, empty);
> -	int ret = filename_lookup(dfd, filename, flags, path, NULL);
>  
> +	int ret = do_user_path_at_empty(dfd, filename, flags, path);
>  	putname(filename);
>  	return ret;
>  }
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index e89329bb3134..8f3ef38c057b 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -49,6 +49,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
>  
>  extern int path_pts(struct path *path);
>  
> +extern int do_user_path_at_empty(int dfd, struct filename *filename,
> +				unsigned int flags, struct path *path);

Sorry, just seeing this now but this wants to live in internal.h not in
namei.h similar to all the other io_uring specific exports we added over
the last releases. There's no need to make this a kernel-wide thing if
we can avoid it, imho. With that changed:
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

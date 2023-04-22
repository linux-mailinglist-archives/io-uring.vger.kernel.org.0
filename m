Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278086EB892
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 12:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjDVKfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 06:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDVKfY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 06:35:24 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D35171B;
        Sat, 22 Apr 2023 03:35:23 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 656F2C01F; Sat, 22 Apr 2023 12:35:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682159721; bh=hsUOoEpi3rbJ1ivrBZ2yc1k7YEK8KLvGigyqc1jFln8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwZAOTvcChBCtmZPu4Du5mpSiNV30/aaXGStR6dKUpy+rLpLZyAPdg2B3FsZJl4AC
         Wrli1QK8D41RPhNNO3Dk96ErrHbUWq3f3g/Dp1kg9LLOhnq4pKP7q/ues/kvIJI0oR
         rMLNkreIGBXfS004iROBpiaLnYcqQMMVbH7lL+K4GaAb9bK9NlBEFRTYytXBkcECbr
         S3O+ATN3cjzfiN1Q1ZBBiNGsi7jqmTugOVVxZMeg3N6FETQKqHBRJoF2lYw4hguQGP
         mQh4qR8xykT2Oe/VBh7WeR4n04sIUXrXC+AUN0RbmcxaekPahTqzb0HqWQB02yyQ4n
         kHn0TftyCmKmg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 51CBDC009;
        Sat, 22 Apr 2023 12:35:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682159720; bh=hsUOoEpi3rbJ1ivrBZ2yc1k7YEK8KLvGigyqc1jFln8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irbWw6iSh9xn0NuWx1AZUlJu6pgEDyFYop5KuI7EP48PjL8GCzws3Ud09rBdt/LMz
         M5Ir3Sh9VnXAu1uXJGSsFhOs5Mwrxc9AR705rhWj433LboS5PRsz+augIn6VoJxf0r
         tDXM0rLHGJkgAwiu/Nt98z2V6bg2e7Z/HvdoE25QYhJsOPqmXxYG7v8zQrA0U2hLfD
         8WM4VhCgWLw56oBZH++8sdjzFRJ4yG0/OZbXvlSP5D63ey2sMCiaRUj+A3PvMqGc3z
         vPm2yV1X9DHPrEli61hHvH0iLzSb/aXlxSinJ63Og/yjCQWYP24yYkdnhFGizVCkaN
         RKUdWJXNMRKJw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 00b0a662;
        Sat, 22 Apr 2023 10:35:14 +0000 (UTC)
Date:   Sat, 22 Apr 2023 19:34:59 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] fs: split off vfs_getdents function of
 getdents64 syscall
Message-ID: <ZEO4U4uuqE8TdS7G@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-1-14c1db36e98c@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230422-uring-getdents-v1-1-14c1db36e98c@codewreck.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dominique Martinet wrote on Sat, Apr 22, 2023 at 05:40:18PM +0900:
> This splits off the vfs_getdents function from the getdents64 system
> call.
> This will allow io_uring to call the vfs_getdents function.
> 
> Co-authored-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/internal.h |  8 ++++++++
>  fs/readdir.c  | 33 +++++++++++++++++++++++++--------
>  2 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index dc4eb91a577a..92eeaf3837d1 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -264,3 +264,11 @@ int setattr_should_drop_sgid(struct mnt_idmap *idmap,
>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
>  struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
>  void mnt_idmap_put(struct mnt_idmap *idmap);
> +
> +/*
> + * fs/readdir.c
> + */
> +struct linux_dirent64;
> +
> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> +		 unsigned int count);
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 9c53edb60c03..1d541a6f2d55 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c

(This needs an extra `#include "internal.h"`, missing declaration
warning reported privately by intel build robot... fs/ doesn't build
with W=1 by default; I'll resend v2 after some comments it doesn't make
much sense to spam patches at this point)

--
Dominique

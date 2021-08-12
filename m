Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD43EA235
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhHLJkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbhHLJkU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 05:40:20 -0400
X-Greylist: delayed 438 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Aug 2021 02:39:55 PDT
Received: from smtp-1908.mail.infomaniak.ch (smtp-1908.mail.infomaniak.ch [IPv6:2001:1600:4:17::1908])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA636C0613D5
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 02:39:55 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GlhL80mW0zMptvC;
        Thu, 12 Aug 2021 11:32:32 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4GlhL711hkzlmrry;
        Thu, 12 Aug 2021 11:32:31 +0200 (CEST)
Subject: Re: [RFC PATCH v2 5/9] fs: add anon_inode_getfile_secure() similar to
 anon_inode_getfd_secure()
To:     Paul Moore <paul@paul-moore.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <162871492283.63873.8743976556992924333.stgit@olly>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <1d19ca85-c6f9-7aa5-162a-f9728e0a8ccd@digikod.net>
Date:   Thu, 12 Aug 2021 11:32:15 +0200
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <162871492283.63873.8743976556992924333.stgit@olly>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/08/2021 22:48, Paul Moore wrote:
> Extending the secure anonymous inode support to other subsystems
> requires that we have a secure anon_inode_getfile() variant in
> addition to the existing secure anon_inode_getfd() variant.
> 
> Thankfully we can reuse the existing __anon_inode_getfile() function
> and just wrap it with the proper arguments.
> 
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> 
> ---
> v2:
> - no change
> v1:
> - initial draft
> ---
>  fs/anon_inodes.c            |   29 +++++++++++++++++++++++++++++
>  include/linux/anon_inodes.h |    4 ++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index a280156138ed..e0c3e33c4177 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -148,6 +148,35 @@ struct file *anon_inode_getfile(const char *name,
>  }
>  EXPORT_SYMBOL_GPL(anon_inode_getfile);
>  
> +/**
> + * anon_inode_getfile_secure - Like anon_inode_getfile(), but creates a new
> + *                             !S_PRIVATE anon inode rather than reuse the
> + *                             singleton anon inode and calls the
> + *                             inode_init_security_anon() LSM hook.  This
> + *                             allows for both the inode to have its own
> + *                             security context and for the LSM to enforce
> + *                             policy on the inode's creation.
> + *
> + * @name:    [in]    name of the "class" of the new file
> + * @fops:    [in]    file operations for the new file
> + * @priv:    [in]    private data for the new file (will be file's private_data)
> + * @flags:   [in]    flags
> + * @context_inode:
> + *           [in]    the logical relationship with the new inode (optional)
> + *
> + * The LSM may use @context_inode in inode_init_security_anon(), but a
> + * reference to it is not held.  Returns the newly created file* or an error
> + * pointer.  See the anon_inode_getfile() documentation for more information.
> + */
> +struct file *anon_inode_getfile_secure(const char *name,
> +				       const struct file_operations *fops,
> +				       void *priv, int flags,
> +				       const struct inode *context_inode)
> +{
> +	return __anon_inode_getfile(name, fops, priv, flags,
> +				    context_inode, true);

This is not directly related to this patch but why using the "secure"
boolean in __anon_inode_getfile() and __anon_inode_getfd() instead of
checking that context_inode is not NULL? This would simplify the code,
remove this anon_inode_getfile_secure() wrapper and avoid potential
inconsistencies.

> +}
> +
>  static int __anon_inode_getfd(const char *name,
>  			      const struct file_operations *fops,
>  			      void *priv, int flags,
> diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
> index 71881a2b6f78..5deaddbd7927 100644
> --- a/include/linux/anon_inodes.h
> +++ b/include/linux/anon_inodes.h
> @@ -15,6 +15,10 @@ struct inode;
>  struct file *anon_inode_getfile(const char *name,
>  				const struct file_operations *fops,
>  				void *priv, int flags);
> +struct file *anon_inode_getfile_secure(const char *name,
> +				       const struct file_operations *fops,
> +				       void *priv, int flags,
> +				       const struct inode *context_inode);
>  int anon_inode_getfd(const char *name, const struct file_operations *fops,
>  		     void *priv, int flags);
>  int anon_inode_getfd_secure(const char *name,
> 

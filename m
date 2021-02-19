Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ADD31F972
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 13:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBSMfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 07:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhBSMfe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 07:35:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09694C061574;
        Fri, 19 Feb 2021 04:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nL98NaEUG65NknpBy9GUqIWGRsbF73KZx2JYEgSxoFU=; b=Q4YFIshmnmtF49HHFoM/CY6k5w
        ymxpEqO/5tsL68tNH3SuI0KZVmjsvrGpYy8opVP5p7B3F2jhdRmcU5/FEbdGFT4tEzT2o+BnKqEVY
        cBwbAjXyUovorINQWgGJ1OuuML4889mhPJ1KfEjKvxhdniRRgUU8bTYWvcnyR1PP5zSzKjJygLHYK
        PQPQV+kT0/8onp9azO5bU7ZceuoN6rzJYfmawXNQB9pV4M0WOvDheZgPZfV4nIgitNxoawmVuLrgB
        VkNRc4kr6uIWGNZB2aKeXY+blRK/hgQnhAiMFFZIKK9HRbtYHwn71USfrXyVXxmO89Sa3kfOs/qps
        cvemhCHw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lD4yx-002rvc-31; Fri, 19 Feb 2021 12:34:17 +0000
Date:   Fri, 19 Feb 2021 12:34:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210219123403.GT2858050@casper.infradead.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218122755.GC334506@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 18, 2021 at 02:27:55PM +0200, Lennert Buytenhek wrote:
> IORING_OP_GETDENTS may or may not update the specified directory's
> file offset, and the file offset should not be relied upon having
> any particular value during or after an IORING_OP_GETDENTS call.

This doesn't give me the warm fuzzies.  What I might suggest
is either passing a parameter to iterate_dir() or breaking out an
iterate_dir_nofpos() to make IORING_OP_GETDENTS more of a READV operation.
ie the equivalent of this:

@@ -37,7 +37,7 @@
 } while (0)
 
 
-int iterate_dir(struct file *file, struct dir_context *ctx)
+int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
 {
        struct inode *inode = file_inode(file);
        bool shared = false;
@@ -60,12 +60,14 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 
        res = -ENOENT;
        if (!IS_DEADDIR(inode)) {
-               ctx->pos = file->f_pos;
+               if (use_fpos)
+                       ctx->pos = file->f_pos;
                if (shared)
                        res = file->f_op->iterate_shared(file, ctx);
                else
                        res = file->f_op->iterate(file, ctx);
-               file->f_pos = ctx->pos;
+               if (use_fpos)
+                       file->f_pos = ctx->pos;
                fsnotify_access(file);
                file_accessed(file);
        }

That way there's no need to play with llseek or take a mutex on the
f_pos of the directory.

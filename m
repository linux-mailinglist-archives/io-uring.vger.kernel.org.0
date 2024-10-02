Return-Path: <io-uring+bounces-3362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C2298CB0F
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 04:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37EA11F2238A
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 02:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D262637;
	Wed,  2 Oct 2024 02:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="oDgp3/zA"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6771C5C96;
	Wed,  2 Oct 2024 02:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727834942; cv=none; b=kEDoRcihiIFrS7hFCTDZK1Dnl6aEk69E5BhoBBrj97UjyIjigcXxxHJuRbG1J+5bDnBqDDeve2ZrA62YojLCEYplLgJ+jL5jjWqaifK81Wmxt9LI9t8XAGHr+Pg7DfapNsWbFgZDSWhzctJaqWM40IE6v8c3tw9YqHwYKm79wcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727834942; c=relaxed/simple;
	bh=DwkW/7SFUysSfvCv0rC7v78Z9UJo3Be59a3v8pEYKQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKwsdfzBs/RQMbXrd7q4h7vOFs16CMI07pBJj/o1OcIfNog4kWC/Y+X4T1L47LocLJrT4astTSl4ZO2vE/qI7nCCwEtEb8mAeQC5uoKmqeNmDSMYfjgRz2XyXz6ya6btfLxsEpLBnXZEnZVZ2fDY8fK5HPqKc5q4AfUPOyFvAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=oDgp3/zA; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/KRwNgUWnU1ZCqCiFsyu0pqGpY1DifhN1myR3c7j7qo=; b=oDgp3/zAb6B4hTFQHhv0slMDWF
	GPWKTRiqbVlXEDajx92c8F8KfS3+tnrkkkcoavY5TrfOnIU95Cn0tpI1gH4qpdWF658LLUu6pvSvA
	4IRiUkMPlEy05QX87HlI2vVHysd+PtfGjS4ghiIT4uLfghJrKO9UwPoCch4YLY6k3r9p1H4OjEA8s
	wcXrx3ucJClGOSzJh4AMGlea33txQ3V77I1R8X4SO/snzKAv0jUaD9+ZECmtYqh7xgoH7MQq6LPTX
	pZ0u2xcfuqnz+4uyR64k+d+B9v6oc5EpImEwvPDMiKo1hKwOw15v6IhrWdlFUivSagJ/qCSof1jAL
	I3v74fbA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svonR-0000000HXEJ-1bIk;
	Wed, 02 Oct 2024 02:08:57 +0000
Date: Wed, 2 Oct 2024 03:08:57 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241002020857.GC4017910@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Oct 01, 2024 at 07:34:12PM -0600, Jens Axboe wrote:

> > -retry:
> > -	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
> > -	if (!ret) {
> > -		ret = __io_setxattr(req, issue_flags, &path);
> > -		path_put(&path);
> > -		if (retry_estale(ret, lookup_flags)) {
> > -			lookup_flags |= LOOKUP_REVAL;
> > -			goto retry;
> > -		}
> > -	}
> > -
> > +	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
> >  	io_xattr_finish(req, ret);
> >  	return IOU_OK;
> 
> this looks like it needs an ix->filename = NULL, as
> filename_{s,g}xattr() drops the reference. The previous internal helper
> did not, and hence the cleanup always did it. But should work fine if
> ->filename is just zeroed.
> 
> Otherwise looks good. I've skimmed the other patches and didn't see
> anything odd, I'll take a closer look tomorrow.

Hmm...  I wonder if we would be better off with file{,name}_setxattr()
doing kvfree(cxt->kvalue) - it makes things easier both on the syscall
and on io_uring side.

I've added minimal fixes (zeroing ix->filename after filename_[sg]etxattr())
to 5/9 and 6/9 *and* added a followup calling conventions change at the end
of the branch.  See #work.xattr2 in the same tree; FWIW, the followup
cleanup is below; note that putname(ERR_PTR(-Ewhatever)) is an explicit
no-op, so there's no need to zero on getname() failures.

commit 67896be9ac99b3fdef82708dd06e720332c13cdc
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Oct 1 22:03:16 2024 -0400

    saner calling conventions for file{,name}_setxattr()
    
    Have them consume ctx->kvalue.  That simplifies both the path_setxattrat()
    and io_uring side of things - there io_xattr_finish() is just left to
    free the xattr name and that's it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/xattr.c b/fs/xattr.c
index 59cdb524412e..6bb656941bce 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -672,6 +672,7 @@ int file_setxattr(struct file *f, struct kernel_xattr_ctx *ctx)
 		error = do_setxattr(file_mnt_idmap(f), f->f_path.dentry, ctx);
 		mnt_drop_write_file(f);
 	}
+	kvfree(ctx->kvalue);
 	return error;
 }
 
@@ -697,6 +698,7 @@ int filename_setxattr(int dfd, struct filename *filename,
 	}
 
 out:
+	kvfree(ctx->kvalue);
 	putname(filename);
 	return error;
 }
@@ -731,14 +733,10 @@ static int path_setxattrat(int dfd, const char __user *pathname,
 	if (!filename) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-			error = -EBADF;
-		else
-			error = file_setxattr(fd_file(f), &ctx);
-	} else {
-		error = filename_setxattr(dfd, filename, lookup_flags, &ctx);
+			return -EBADF;
+		return file_setxattr(fd_file(f), &ctx);
 	}
-	kvfree(ctx.kvalue);
-	return error;
+	return filename_setxattr(dfd, filename, lookup_flags, &ctx);
 }
 
 SYSCALL_DEFINE6(setxattrat, int, dfd, const char __user *, pathname, unsigned int, at_flags,
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 90277246dbea..9f3ea12f628d 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -35,9 +35,10 @@ void io_xattr_cleanup(struct io_kiocb *req)
 
 static void io_xattr_finish(struct io_kiocb *req, int ret)
 {
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 
-	io_xattr_cleanup(req);
+	kfree(ix->ctx.kname);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
 }
 
@@ -94,12 +95,9 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
 	ix->filename = getname(path);
-	if (IS_ERR(ix->filename)) {
-		ret = PTR_ERR(ix->filename);
-		ix->filename = NULL;
-	}
-
-	return ret;
+	if (IS_ERR(ix->filename))
+		return PTR_ERR(ix->filename);
+	return 0;
 }
 
 int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -122,7 +120,6 @@ int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
 	ret = filename_getxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
-	ix->filename = NULL;
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }
@@ -172,12 +169,9 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
 	ix->filename = getname(path);
-	if (IS_ERR(ix->filename)) {
-		ret = PTR_ERR(ix->filename);
-		ix->filename = NULL;
-	}
-
-	return ret;
+	if (IS_ERR(ix->filename))
+		return PTR_ERR(ix->filename);
+	return 0;
 }
 
 int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -205,7 +199,6 @@ int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
 	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
-	ix->filename = NULL;
 	io_xattr_finish(req, ret);
 	return IOU_OK;
 }


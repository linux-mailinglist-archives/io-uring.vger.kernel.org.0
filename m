Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F202BB872
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 22:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgKTVgs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 16:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgKTVgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 16:36:48 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE47C0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 13:36:48 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id v12so9105880pfm.13
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 13:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DHNWrHEo57i/1LUKWT1gfRH8Crpq0Ri3U/SEXQGC8RU=;
        b=ckJsL4oBfEPkG+HCzI2ne/EJyQSj/5hPVHRauvYxU0gHfWZFYKLRqU9quVjHfopl6f
         KLaqjbXDQU4BczXuvvpQUGtM/n4rZicWG5HSaIt3ds7Im7eyFMhOxTUqFEZtOJ7T2ril
         YW8TUEXwU7NITCn+IA8H2oAaC/8vjXI9CWwK0mukw5qUCNlrSNm8lPgAa0azgCYxse9x
         synqBnLVZDscfB9CZYAWLVgzU+Glz5bcnl3iREu/mdNuAPB3P5spDb0FYmkcknIBFPhP
         8qJU4X8K9/bWJl8YRm9FPY59uPewDfqss/d6E2+lchSuorZy1dMbb64A6qD+K7hmY0zf
         0C8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DHNWrHEo57i/1LUKWT1gfRH8Crpq0Ri3U/SEXQGC8RU=;
        b=Kww9hanbhyuUPu4q1gD644Ez1PKdI2Mbmi3P2hsJRdyNr4QQdjBSTd91AwfVCbPktw
         k648lyTLG+pnWrr/vly6lUiHQc4bvraxR6sMkzQ0lLjegUN2iiSwY/3B6ROquRyIjfdA
         E9fQFeFprv5kniDEHOOJZqYHfe4ytXvCeZbRNrr9ygCetawuM5i5Y44MVw/DcJCAjXbO
         e9/yNWTlgI7WjcB7gl+cbuN8bqam9qNqsIooK6NDxfyqCN5wn4GUowsrT6FsyX0sd+vW
         4nqDo8qny1FUQmOxzI09v4Pmmev07ZWY6A+8IbyG1oHYY5ZuRbLGLk4x6bisADb49N5g
         Vr/w==
X-Gm-Message-State: AOAM530c1/2STGMyhumFbsH2k78H8V7ztR+V3dKgMliko8yZlhwKcfEA
        qpzoi1q6RnlpeQOSKjnU3DTICQ==
X-Google-Smtp-Source: ABdhPJyRduIYP7dcEHx/o2i35lEZoeS4+DzULfaPMWYA3RRqq+4QzgEvghH/2luEtYKWVfoODGsjYQ==
X-Received: by 2002:a62:75c6:0:b029:18a:d510:ff60 with SMTP id q189-20020a6275c60000b029018ad510ff60mr15881388pfc.35.1605908207415;
        Fri, 20 Nov 2020 13:36:47 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::18d9? ([2620:10d:c090:400::5:6aac])
        by smtp.gmail.com with ESMTPSA id v63sm4615165pfb.217.2020.11.20.13.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 13:36:46 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk>
Date:   Fri, 20 Nov 2020 14:36:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/20/20 1:02 PM, Linus Torvalds wrote:
> On Fri, Nov 20, 2020 at 10:45 AM Jens Axboe <axboe@kernel.dk> wrote:
>> Jens Axboe (4):
>>       proc: don't allow async path resolution of /proc/self components
> 
> This one is ok.
> 
>>       io_uring: handle -EOPNOTSUPP on path resolution
> 
> But this one smells. It talks about how it shouldn't block, but the
> fact is, it can easily block when the path going through another
> filesystem (think ".." to get to root before even hitting /proc/self,
> but also think /proc/self/cwd/randompathgoeshere).
> 
> The whole concept seems entirely broken anyway. Why would you retry
> the failure after doing it asynchronously? If it really doesn't block,
> then it shouldn't have been done async in the first place.
> 
> IMNSHO, the openat logic is just wrong. And that "ignore_nonblock"
> thing is a disgusting hack that is everything that is wrong with
> io_uring. Stop doing these kinds of hacky things that will just cause
> problems down the line.
> 
> I think the correct thing to do is to just start the open
> synchronously with an RCU lookup, and if that fails, go to the async
> one. And if the async one fails because it's /proc/self, then it just
> fails. None of this kind of "it should be ok" stuff.
> 
> And that would likely be the faster model anyway - do it synchronously
> and immediately for the easy cases.
> 
> And if it really is something like "/proc/self/cwd/randompathgoeshere"
> that actually will block, maybe io_uring just shouldn't support it?
> 
> I've pulled this, but I really object to how io_uring keeps having
> subtle bugs, and then they get worked around with this kind of hackery
> which really smells like "this will be a subtle bug some time in the
> future".

I don't disagree with you on that. I've been a bit gun shy on touching
the VFS side of things, but this one isn't too bad. I hacked up a patch
that allows io_uring to do LOOKUP_RCU and a quick test seems to indicate
it's fine. On top of that, we just propagate the error if we do fail and
get rid of that odd retry loop.

And yes, it should be much better performance as well, for any sort of
cached lookup. There's a reason why we made the close side more
efficient like that, too.

Lightly tested patch below, needs to be split into 2 parts of course.
But the VFS side is just adding a few functions to fs/internal.h and the
struct nameidata structure, no other changes needed.


diff --git a/fs/internal.h b/fs/internal.h
index 6fd14ea213c3..e100d5bca42d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -131,11 +131,41 @@ struct open_flags {
 };
 extern struct file *do_filp_open(int dfd, struct filename *pathname,
 		const struct open_flags *op);
+extern struct file *path_openat(struct nameidata *nd,
+		const struct open_flags *op, unsigned flags);
 extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *);
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 
+#define EMBEDDED_LEVELS 2
+struct nameidata {
+	struct path	path;
+	struct qstr	last;
+	struct path	root;
+	struct inode	*inode; /* path.dentry.d_inode */
+	unsigned int	flags;
+	unsigned	seq, m_seq, r_seq;
+	int		last_type;
+	unsigned	depth;
+	int		total_link_count;
+	struct saved {
+		struct path link;
+		struct delayed_call done;
+		const char *name;
+		unsigned seq;
+	} *stack, internal[EMBEDDED_LEVELS];
+	struct filename	*name;
+	struct nameidata *saved;
+	unsigned	root_seq;
+	int		dfd;
+	kuid_t		dir_uid;
+	umode_t		dir_mode;
+} __randomize_layout;
+
+extern void set_nameidata(struct nameidata *p, int dfd, struct filename *name);
+extern void restore_nameidata(void);
+
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43ba815e4107..896b7f92cfed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4069,9 +4069,6 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
-	if (force_nonblock && !req->open.ignore_nonblock)
-		return -EAGAIN;
-
 	ret = build_open_flags(&req->open.how, &op);
 	if (ret)
 		goto err;
@@ -4080,25 +4077,28 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (ret < 0)
 		goto err;
 
-	file = do_filp_open(req->open.dfd, req->open.filename, &op);
-	if (IS_ERR(file)) {
-		put_unused_fd(ret);
-		ret = PTR_ERR(file);
+	if (!force_nonblock) {
+		struct nameidata nd;
+
+		set_nameidata(&nd, req->open.dfd, req->open.filename);
+		file = path_openat(&nd, &op, op.lookup_flags | LOOKUP_RCU);
+		restore_nameidata();
+
 		/*
-		 * A work-around to ensure that /proc/self works that way
-		 * that it should - if we get -EOPNOTSUPP back, then assume
-		 * that proc_self_get_link() failed us because we're in async
-		 * context. We should be safe to retry this from the task
-		 * itself with force_nonblock == false set, as it should not
-		 * block on lookup. Would be nice to know this upfront and
-		 * avoid the async dance, but doesn't seem feasible.
+		 * If RCU lookup fails, then we need to retry this from
+		 * async context.
 		 */
-		if (ret == -EOPNOTSUPP && io_wq_current_is_worker()) {
-			req->open.ignore_nonblock = true;
-			refcount_inc(&req->refs);
-			io_req_task_queue(req);
-			return 0;
+		if (file == ERR_PTR(-ECHILD)) {
+			put_unused_fd(ret);
+			return -EAGAIN;
 		}
+	} else {
+		file = do_filp_open(req->open.dfd, req->open.filename, &op);
+	}
+
+	if (IS_ERR(file)) {
+		put_unused_fd(ret);
+		ret = PTR_ERR(file);
 	} else {
 		fsnotify_open(file);
 		fd_install(ret, file);
diff --git a/fs/namei.c b/fs/namei.c
index 03d0e11e4f36..288fdae18221 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -498,32 +498,7 @@ void path_put(const struct path *path)
 }
 EXPORT_SYMBOL(path_put);
 
-#define EMBEDDED_LEVELS 2
-struct nameidata {
-	struct path	path;
-	struct qstr	last;
-	struct path	root;
-	struct inode	*inode; /* path.dentry.d_inode */
-	unsigned int	flags;
-	unsigned	seq, m_seq, r_seq;
-	int		last_type;
-	unsigned	depth;
-	int		total_link_count;
-	struct saved {
-		struct path link;
-		struct delayed_call done;
-		const char *name;
-		unsigned seq;
-	} *stack, internal[EMBEDDED_LEVELS];
-	struct filename	*name;
-	struct nameidata *saved;
-	unsigned	root_seq;
-	int		dfd;
-	kuid_t		dir_uid;
-	umode_t		dir_mode;
-} __randomize_layout;
-
-static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
+void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 {
 	struct nameidata *old = current->nameidata;
 	p->stack = p->internal;
@@ -534,7 +509,7 @@ static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 	current->nameidata = p;
 }
 
-static void restore_nameidata(void)
+void restore_nameidata(void)
 {
 	struct nameidata *now = current->nameidata, *old = now->saved;
 
@@ -3346,8 +3321,8 @@ static int do_o_path(struct nameidata *nd, unsigned flags, struct file *file)
 	return error;
 }
 
-static struct file *path_openat(struct nameidata *nd,
-			const struct open_flags *op, unsigned flags)
+struct file *path_openat(struct nameidata *nd, const struct open_flags *op,
+			 unsigned flags)
 {
 	struct file *file;
 	int error;

-- 
Jens Axboe


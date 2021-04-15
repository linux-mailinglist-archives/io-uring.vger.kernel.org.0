Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE836069C
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhDOKIn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 06:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhDOKIn (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 15 Apr 2021 06:08:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5950C61074;
        Thu, 15 Apr 2021 10:08:18 +0000 (UTC)
Date:   Thu, 15 Apr 2021 12:08:15 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210415100815.edrn4a7cy26wkowe@wittgenstein>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
 <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
 <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
 <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 15, 2021 at 02:14:17PM +0700, Dmitry Kadashev wrote:
> On Thu, Apr 8, 2021 at 3:45 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > On Tue, Mar 30, 2021 at 2:17 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > > The only thing that is a bit unpleasant here is that this change
> > > breaks the consistency between the creation helpers:
> > >
> > > do_mkdirat()
> > > do_symlinkat()
> > > do_linkat()
> > > do_mknodat()
> > >
> > > All but of them currently take
> > > const char __user *pathname
> > > and call
> > > user_path_create()
> > > with that do_mkdirat() change that's no longer true. One of the major
> > > benefits over the recent years in this code is naming and type consistency.
> > > And since it's just matter of time until io_uring will also gain support
> > > for do_{symlinkat,linkat,mknodat} I would think switching all of them to
> > > take a struct filename
> > > and then have all do_* helpers call getname() might just be nicer in the
> > > long run.
> >
> > So, I've finally got some time to look into this. do_mknodat() and
> > do_symlinkat() are easy. But do_linkat() is more complicated, I could use some
> > hints as to what's the reasonable way to implement the change.
> >
> > The problem is linkat() requires CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
> > flag is passed. Right now do_linkat checks the capability before calling
> > getname_flags (essentially). If do_linkat is changed to accept struct filename
> > then there is no bulletproof way to force CAP_DAC_READ_SEARCH presence (e.g. if
> > for whatever reason AT_EMPTY_PATH is not in flags passed to do_linkat). Also, it
> > means that the caller is responsible to process AT_EMPTY_PATH in the first
> > place, which means logic duplication.
> >
> > Any ideas what's the best way to approach this?
> 
> Ping. If someone can see how we can avoid making do_linkat() callers
> ensure the process has CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
> was passed then the hints would be really appreciated.

Would something like this help?

From 7adeec2fe4a954e4e4b8a158a4d9fe705b82b978 Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Thu, 15 Apr 2021 12:03:42 +0200
Subject: [PATCH] namei: add getname_uflags()

There are a couple of places where we already open-code the (flags &
AT_EMPTY_PATH) check and io_uring will likely add another one in the future.
Let's just add a simple helper getname_uflags() that handles this directly and
use it.
getname_flags() itself doesn't need access to lookup flags other than
LOOKUP_EMPTY so this is basically just a boolean already so be honest about it.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/exec.c          | 10 ++--------
 fs/fsopen.c        |  6 +++---
 fs/namei.c         |  6 +++---
 include/linux/fs.h |  4 ++++
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..53c633f69f4a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2069,10 +2069,7 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
-	return do_execveat(fd,
-			   getname_flags(filename, lookup_flags, NULL),
+	return do_execveat(fd, getname_uflags(filename, flags),
 			   argv, envp, flags);
 }
 
@@ -2090,10 +2087,7 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 		       const compat_uptr_t __user *, envp,
 		       int,  flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
-	return compat_do_execveat(fd,
-				  getname_flags(filename, lookup_flags, NULL),
+	return compat_do_execveat(fd, getname_uflags(filename, flags),
 				  argv, envp, flags);
 }
 #endif
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 27a890aa493a..00906abaf466 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -321,7 +321,7 @@ SYSCALL_DEFINE5(fsconfig,
 	struct fs_context *fc;
 	struct fd f;
 	int ret;
-	int lookup_flags = 0;
+	bool lookup_empty = false;
 
 	struct fs_parameter param = {
 		.type	= fs_value_is_undefined,
@@ -411,11 +411,11 @@ SYSCALL_DEFINE5(fsconfig,
 		}
 		break;
 	case FSCONFIG_SET_PATH_EMPTY:
-		lookup_flags = LOOKUP_EMPTY;
+		lookup_empty = true;
 		fallthrough;
 	case FSCONFIG_SET_PATH:
 		param.type = fs_value_is_filename;
-		param.name = getname_flags(_value, lookup_flags, NULL);
+		param.name = getname_flags(_value, lookup_empty, NULL);
 		if (IS_ERR(param.name)) {
 			ret = PTR_ERR(param.name);
 			goto out_key;
diff --git a/fs/namei.c b/fs/namei.c
index 216f16e74351..7694f6bcd711 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -125,7 +125,7 @@
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
 struct filename *
-getname_flags(const char __user *filename, int flags, int *empty)
+getname_flags(const char __user *filename, bool lookup_empty, int *empty)
 {
 	struct filename *result;
 	char *kname;
@@ -191,7 +191,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
 	if (unlikely(!len)) {
 		if (empty)
 			*empty = 1;
-		if (!(flags & LOOKUP_EMPTY)) {
+		if (lookup_empty) {
 			putname(result);
 			return ERR_PTR(-ENOENT);
 		}
@@ -206,7 +206,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
 struct filename *
 getname(const char __user * filename)
 {
-	return getname_flags(filename, 0, NULL);
+	return getname_flags(filename, false, NULL);
 }
 
 struct filename *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ec8f3ddf4a6a..6dbd629ece04 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2644,6 +2644,10 @@ static inline struct file *file_clone_open(struct file *file)
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
+extern struct filename *getname_uflags(const char __user *filename, int uflags)
+{
+	return getname_flags(filename, (flags & AT_EMPTY_PATH), NULL);
+}
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 extern void putname(struct filename *name);
-- 
2.27.0


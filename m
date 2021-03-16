Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B907933D8C9
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 17:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhCPQLd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 12:11:33 -0400
Received: from hmm.wantstofly.org ([213.239.204.108]:46750 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbhCPQLC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 12:11:02 -0400
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 6245E7F279; Tue, 16 Mar 2021 18:11:00 +0200 (EET)
Date:   Tue, 16 Mar 2021 18:11:00 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Tavian Barnes <tavianator@tavianator.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <YFDYlMmskAM5t7ET@wantstofly.org>
References: <ea2b3ae7-d5c4-a46e-1d2d-e2c7b5fd8730@tavianator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea2b3ae7-d5c4-a46e-1d2d-e2c7b5fd8730@tavianator.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello!


On Tue, Mar 16, 2021 at 11:39:25AM -0400, Tavian Barnes wrote:

> > IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
> > arguments, but with a small twist: it takes an additional offset
> > argument, and reading from the specified directory starts at the given
> > offset.
> >
> > For the first IORING_OP_GETDENTS call on a directory, the offset
> > parameter can be set to zero, and for subsequent calls, it can be
> > set to the ->d_off field of the last struct linux_dirent64 returned
> > by the previous IORING_OP_GETDENTS call.
> >
> > Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
> > the right directory position before calling vfs_getdents().
> 
> For my envisioned use case it would be important to support reading from
> the current file position when offset == -1 (IORING_FEAT_RW_CUR_POS).

Thank you for the feedback!  This is easy enough to do:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 306e2bd9fd75..1ffe58462ab3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4349,7 +4349,7 @@ static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
 	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
 	mutex_lock(&req->file->f_pos_lock);
 
-	if (req->file->f_pos != getdents->pos) {
+	if (getdents->pos != -1 && req->file->f_pos != getdents->pos) {
 		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
 		if (res < 0)
 			ret = res;

(A corresponding patch to the liburing testsuite is below.)


> Among other things, this would let me fully read a directory with fewer
> round-trips.  Normally after the first getdents(), another one must be
> issued to distinguish between EOF and a short first read.  It would be
> nice to do both calls with linked SQEs so I could immediately know that
> I've reached the end of the directory.

Does that work with this patch?


> > IORING_OP_GETDENTS may or may not update the specified directory's
> > file offset, and the file offset should not be relied upon having
> > any particular value during or after an IORING_OP_GETDENTS call.
> 
> Obviously for the above to work, we'd have to get rid of this
> limitation.  Is that possible?

The idea behind wording it this way was that this would allow for
further in-kernel parallelization of getdents calls in the future
(by not serializing on the current-file-position-mutex), but I can
see how this behavior conflicts with your use case.

Also, given how the current implementation _does_ update the
directory's file offset, some userspace code will surely end up
depending on that behavior, which would make it hard to change
in the future.

Also, allowing unserialized in-kernel getdents calls on the same file
descriptor would require a bunch more VFS work (including auditing
all filesystems), and, to be completely honest, I am unlikely to be
doing that work.

All in all, maybe we should just state that IORING_OP_GETDENTS is
a seek (if needed) plus a getdents combo that does together update
the directory's file offset, and be done with it.




A corresponding incremental patch to the testsuite to test the
"off == -1 means current file position" case:

diff --git a/test/getdents.c b/test/getdents.c
index 3ca7b05..532e6f4 100644
--- a/test/getdents.c
+++ b/test/getdents.c
@@ -130,6 +130,7 @@ int main(int argc, char *argv[])
 	while (bufp < end) {
 		struct linux_dirent64 *dent;
 		uint8_t buf2[BUFSZ];
+		off_t ret2;
 
 		dent = (struct linux_dirent64 *)bufp;
 
@@ -165,6 +166,47 @@ int main(int argc, char *argv[])
 
 			return 1;
 		}
+
+		/*
+		 * Now seek the directory to the given offset manually,
+		 * and perform a getdents call with offset -1 (which means:
+		 * "read from current offset"), and make sure we get the
+		 * same data back.
+		 */
+		ret2 = lseek(dirfd, dent->d_off, SEEK_SET);
+		if (ret2 != dent->d_off) {
+			if (ret2 == (off_t)-1) {
+				perror("lseek");
+			} else {
+				fprintf(stderr, "error seeking directory "
+						"to offset %" PRId64 "\n",
+					(uint64_t)dent->d_off);
+			}
+			return 1;
+		}
+
+		memset(buf2, 0, sizeof(buf2));
+
+		ret = test_getdents(&ring, buf2, sizeof(buf2), (uint64_t)-1);
+		if (ret < 0) {
+			fprintf(stderr, "getdents: %s\n", strerror(-ret));
+			return 1;
+		}
+
+		if (ret != end - bufp || memcmp(bufp, buf2, ret)) {
+			fprintf(stderr, "getdents: read from seeked offset "
+					"%" PRId64 " returned unexpected "
+					"data\n\n", (uint64_t)dent->d_off);
+
+			fprintf(stderr, "read from offset zero:\n");
+			dump_dents(bufp, end - bufp);
+
+			fprintf(stderr, "offsetted read:\n");
+			dump_dents(buf2, ret);
+
+			return 1;
+		}
+
 	}
 
 	if (!found_dot)

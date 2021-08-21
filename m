Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55563F3CA3
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhHUW0M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 18:26:12 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:58546 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhHUW0K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 18:26:10 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mHZQW-00EmiE-6B; Sat, 21 Aug 2021 22:25:20 +0000
Date:   Sat, 21 Aug 2021 22:25:20 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 0/2] iter revert problems
Message-ID: <YSF9UFyLGZQeKbLt@zeniv-ca.linux.org.uk>
References: <cover.1628780390.git.asml.silence@gmail.com>
 <3eaf5365-586d-700b-0277-e0889bfeb05d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3eaf5365-586d-700b-0277-e0889bfeb05d@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Aug 21, 2021 at 03:24:28PM +0100, Pavel Begunkov wrote:
> On 8/12/21 9:40 PM, Pavel Begunkov wrote:
> > For the bug description see 2/2. As mentioned there the current problems
> > is because of generic_write_checks(), but there was also a similar case
> > fixed in 5.12, which should have been triggerable by normal
> > write(2)/read(2) and others.
> > 
> > It may be better to enforce reexpands as a long term solution, but for
> > now this patchset is quickier and easier to backport.
> 
> We need to do something with this, hopefully soon.

I still don't like that approach ;-/  If anything, I would rather do
something like this, and to hell with one extra word on stack in
several functions; at least that way the semantics is easy to describe.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d94fb5835a20..5501f8b3af3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3420,6 +3420,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
+		iov_iter_reexpand(iter, iter->count + iter->truncated);
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		return ret ?: -EAGAIN;
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..5265024e8b90 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -47,6 +47,7 @@ struct iov_iter {
 		};
 		loff_t xarray_start;
 	};
+	size_t truncated;
 };
 
 static inline enum iter_type iov_iter_type(const struct iov_iter *i)
@@ -254,8 +255,10 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
+		i->truncated += i->count - count;
 		i->count = count;
+	}
 }
 
 /*
@@ -264,6 +267,7 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
  */
 static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
+	i->truncated -= count - i->count;
 	i->count = count;
 }
 

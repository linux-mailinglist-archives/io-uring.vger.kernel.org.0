Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3052045292C
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 05:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhKPEix (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Nov 2021 23:38:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239023AbhKPEi3 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 15 Nov 2021 23:38:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EFEC61C12;
        Tue, 16 Nov 2021 04:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637037332;
        bh=wq2Hk1CCwWeZtVWFL6tXwVQVKRV2RGmHT3DEnrbzvd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lIppLQ/19jJhPK6DKRdz0j/o4l4/w3roGokUnL+pR0KbfIovwlVJ6/exh0z0sYpfX
         3bPcBXlAuhZqSAu39Q4pjmqlpFuha5tEHZopYmc20HbToOipEVpmQ+4X5IXMnD5jht
         Tp9w+X1fadqmS238FVm7noO/9YEtZ8t0+PhBztQ4=
Date:   Mon, 15 Nov 2021 20:35:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-Id: <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
In-Reply-To: <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
        <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
        <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
        <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 6 Nov 2021 14:12:45 +0700 Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:

> On 11/6/21 2:05 PM, Drew DeVault wrote:
> > Should I send a v2 or is this email sufficient:
> > 
> > Signed-off-by: Drew DeVault <sir@cmpwn.com>
> 
> Oops, I missed akpm from the CC list. Added Andrew.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Ref: https://lore.kernel.org/io-uring/CFII8LNSW5XH.3OTIVFYX8P65Y@taiga/

Let's cc linux-mm as well.


Unfortunately I didn't know about this until Nov 4, which was formally
too late for 5.16.  I guess I could try to sneak it past Linus if
someone were to send me some sufficiently convincing words explaining
the urgency.

I'd also be interested in seeing feedback from the MM developers.

And a question: rather than messing around with a constant which will
need to be increased again in a couple of years, can we solve this one
and for all?  For example, permit root to set the system-wide
per-process max mlock size and depend upon initscripts to do this
appropriately.




From: Drew DeVault <sir@cmpwn.com>
Subject: Increase default MLOCK_LIMIT to 8 MiB

This limit has not been updated since 2008, when it was increased to 64
KiB at the request of GnuPG.  Until recently, the main use-cases for this
feature were (1) preventing sensitive memory from being swapped, as in
GnuPG's use-case; and (2) real-time use-cases.  In the first case, little
memory is called for, and in the second case, the user is generally in a
position to increase it if they need more.

The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
preparing fixed buffers for high-performance I/O.  This use-case will take
as much of this memory as it can get, but is still limited to 64 KiB by
default, which is very little.  This increases the limit to 8 MB, which
was chosen fairly arbitrarily as a more generous, but still conservative,
default value.

It is also possible to raise this limit in userspace.  This is easily
done, for example, in the use-case of a network daemon: systemd, for
instance, provides for this via LimitMEMLOCK in the service file; OpenRC
via the rc_ulimit variables.  However, there is no established userspace
facility for configuring this outside of daemons: end-user applications do
not presently have access to a convenient means of raising their limits.

The buck, as it were, stops with the kernel.  It's much easier to address
it here than it is to bring it to hundreds of distributions, and it can
only realistically be relied upon to be high-enough by end-user software
if it is more-or-less ubiquitous.  Most distros don't change this
particular rlimit from the kernel-supplied default value, so a change here
will easily provide that ubiquity.

Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
Signed-off-by: Drew DeVault <sir@cmpwn.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/resource.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/resource.h~increase-default-mlock_limit-to-8-mib
+++ a/include/uapi/linux/resource.h
@@ -66,10 +66,17 @@ struct rlimit64 {
 #define _STK_LIM	(8*1024*1024)
 
 /*
- * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
- * and other sensitive information are never written to disk.
+ * Limit the amount of locked memory by some sane default:
+ * root can always increase this limit if needed.
+ *
+ * The main use-cases are (1) preventing sensitive memory
+ * from being swapped; (2) real-time operations; (3) via
+ * IOURING_REGISTER_BUFFERS.
+ *
+ * The first two don't need much. The latter will take as
+ * much as it can get. 8MB is a reasonably sane default.
  */
-#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
+#define MLOCK_LIMIT	((PAGE_SIZE > 8*1024*1024) ? PAGE_SIZE : 8*1024*1024)
 
 /*
  * Due to binary compatibility, the actual resource numbers
_


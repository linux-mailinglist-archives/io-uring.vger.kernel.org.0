Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AAF1BE76D
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 21:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgD2TdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 15:33:17 -0400
Received: from static-213-198-238-194.adsl.eunet.rs ([213.198.238.194]:44014
        "EHLO fx.arvanta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgD2TdR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 15:33:17 -0400
Received: from arya.arvanta.net (arya.arvanta.net [10.5.1.6])
        by fx.arvanta.net (Postfix) with ESMTP id 4D0A74547;
        Wed, 29 Apr 2020 21:33:15 +0200 (CEST)
Date:   Wed, 29 Apr 2020 21:33:15 +0200
From:   Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org
Subject: Re: Build 0.6 version fail on musl libc
Message-ID: <20200429193315.GA31807@arya.arvanta.net>
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 2020-04-29 at 10:14, Jens Axboe wrote:
> On 4/29/20 9:29 AM, Jens Axboe wrote:
> > On 4/29/20 9:26 AM, Christoph Hellwig wrote:
> >> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
> >>>
> >>> Not sure what the best fix is there, for 32-bit, your change will truncate
> >>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
> >>> case for me, maybe musl is different if it just has a nasty define for
> >>> them.
> >>>
> >>> Maybe best to just make them uint64_t or something like that.
> >>
> >> The proper LFS type would be off64_t.
> > 
> > Is it available anywhere? Because I don't have it.
> 
> There seems to be better luck with __off64_t, but I don't even know
> how widespread that is... Going to give it a go, we'll see.

AFAIK, __off64_t is glibc specific, defined in /usr/include/fcntl.h:
------
# ifndef __USE_FILE_OFFSET64
typedef __off_t off_t;
# else
typedef __off64_t off_t;
# endif
------

So, this will not work on musl based Linux system, git commit id
b5096098c62adb19dbf4a39b480909766c9026e7 should be reverted. But you
know better what to do.

I come with another quick and dirty patch attached to this mail but
again  I think it is not proper solution, just playing to find (maybe)
'good enough' workaround.

Thanks
-- 
regards

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="liburing-offt-fix.diff"

diff --git a/configure b/configure
index 30b0a5a..8299597 100755
--- a/configure
+++ b/configure
@@ -301,6 +301,9 @@ EOF
 fi
 if test "$__kernel_timespec" != "yes"; then
 cat >> $compat_h << EOF
+#include <stdint.h>
+#define int64_t uint64_t
+
 struct __kernel_timespec {
 	int64_t		tv_sec;
 	long long	tv_nsec;
diff --git a/src/include/liburing.h b/src/include/liburing.h
index ae5542c..24c24a2 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -14,7 +14,9 @@ extern "C" {
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
 #include "liburing/barrier.h"
+#include <sys/stat.h>
 
+#define loff_t off_t
 /*
  * Library interface to io_uring
  */

--6c2NcOVqGQ03X4Wi--

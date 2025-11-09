Return-Path: <io-uring+bounces-10471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BBAC43944
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 07:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F9EF188BE36
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 06:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB527242D9E;
	Sun,  9 Nov 2025 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="WCx3i6A4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34142215F7D;
	Sun,  9 Nov 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762670271; cv=none; b=SsmFja2Ww5IM08gdjK6vWNb0O774xSgjl/FAZDu8CsOZElYc9wMeyGUVWsBQ0CYXnK51wxGl3Rzx7gs5J0fNumXIqbIlUJVnTQgNjSF6gfHamOQxGw5SadoBTu++HW14zHa1CqMkoNHPHgAiYnaMFxYQZEvtAp4hG1Uu8F5gWEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762670271; c=relaxed/simple;
	bh=pTBP+/Wig4N+3ChLMBYDCqOzKv3k6xs2V1ba9ndBRhY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dzhHLeDCo/JYmexxUOF7dXY/jPe3diTpv9hL/LezFm1ywG0ZWBPOiHT2cyR3Ikn5awcvg2LMOkzp359POl2kST5yFxanbfXXC/xm1qY7XKPxRfX5SBSWANK5Xt8KFO7TVeqnChQa6KRWR4MhfdG8DSCVkNOER/2f/4g+42L1j3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=WCx3i6A4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KxZN2sURzti2wz4a4TMINAs2B/2ODXAH5sKYr+MyV3U=; b=WCx3i6A4/TDmK2jrrcz7xkHURF
	YSh1+Ih0LViP5LpeeKf59GSAu+y7ysAs2twZ93bH7sDekEXjztjG+GifoKZFBVTvdUjnJwbQwts5r
	FjhXgbESAglyablObAsuukTKOhcqG+Uug4RGXUmJ3KB9QH2YskPxVRAZYKwNqyt+TgbtTrgATTHZ9
	bs33Arssg7WXyU0lEo2/iJGu+P8sLZAWPBy2IIXEOXF0GZ+qV2V4aKM/Z6MxCIRXadXrDgD/wc+Cr
	DpiD0DAfqWkyMsLhcUxCwAVcywKJEuNsU7zZABSk1pJiz/WL2GVmctNlT9OCT5g+JH2yHq6fw8686
	XH4WNWvg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHz3Z-00000008lb2-2ZAK;
	Sun, 09 Nov 2025 06:37:45 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC][PATCH 00/13] io_uring, struct filename and audit
Date: Sun,  9 Nov 2025 06:37:32 +0000
Message-ID: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

[The last time that was discussed a year ago; rather than posting it
as a followup into the old thread, I'm starting a new one.  Old thread
can be found at https://lore.kernel.org/all/20240922004901.GA3413968@ZenIV/]

There are two filename-related problems in io_uring and its interplay
with audit.

Filenames are imported when request is submitted and used when it is
processed.  Unfortunately, with io_uring the latter may very well happen
in a different thread.  In that case the reference to filename is put into
the wrong audit_context - that of submitting thread, not the processing
one.  Audit logics is called by the latter, and it really wants to be
able to find the names in audit_context of current (== processing) thread.

Another related problem is the headache with refcounts - normally all
references to given struct filename are visible only to one thread (the
one that uses that struct filename).  io_uring violates that - an extra
reference is stashed in audit_context of submitter.  It gets dropped
when submitter returns to userland, which can happen simultaneously with
processing thread deciding to drop the reference it got.

We paper over that by making refcount atomic, but that means pointless
overhead for everyone.

One more headache with refcount comes from retry loops - handling of
-ESTALE while resolving a parent is dealt with transparently, but
server might get around to telling you that things got stale only
when you e.g. ask it to remove a link.  In that case we have to repeat
the pathwalk in "trust no one" mode and see if it helps.

So far, so good, but depending upon the helpers we are using we might
end up re-importing the pathname from userland.  Had that been merely
duplicated work on an already slow path, it wouldn't matter much, but
with audit in the mix it becomes seriously confusing.  Currently
getname() and its ilk try to cope with that (only if audit is enabled)
by stashing the userland address in struct filename and checking if
an instance for the same userland address has already been made visible
to audit, in which case we just grab an extra reference.

That's bogus for several reasons.  In particular, having the same
pointer passed in different pathname arguments of a syscall should not be
different from having separate strings with identical context given to it.
Compiler might turn the latter into the former, after all - merging
identical string literals may happen.  As the result, audit might produce
significantly different outputs on the same program, depending upon the
compiler flags used when building it.  This is obviously not a good thing.
The fact that this logics is dependent upon CONFIG_AUDIT also doesn't help.

The right solution is to have the pathname imported once, before the
retry loop; fortunately, most of those loops are already done that way
these days - only 9 exceptions in the entire kernel.

With those exceptions taken care of, we can get rid of the entire "stash
the userland address in struct filename" thing.  That helps to solve both
io_uring problems - import of pathname in there is already separated from
making use of it (the former happens in submitting thread, the latter -
in processing one).  If we explicitly mark the places where we start
making use of those suckers (in io_mkdirat(), etc.), we can have the
submitter do "incomplete" imports (just copying the name from userland
and stashing the result in opaque object).  Then processing thread
would explicitly ask to complete the import and use the resulting struct
filename *, same as a normal syscall would - all in the thread that does
actual work, so that situation looks normal for audit - the damn thing
goes into the right audit_context, all uses are thread-synchronous and
from the same thread, etc.  What's more, refcount can become non-atomic
(and grabbed only inside the kernel/auditsc.c, at that).

The series below attempts to do that.  It does need a serious review,
including that from audit and io_uring folks.

It lives in git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git #work.filename-refcnt
Individual patches in followups.

Al Viro (12):
  do_faccessat(): import pathname only once
  do_fchmodat(): import pathname only once
  do_fchownat(): import pathname only once
  do_utimes_path(): import pathname only once
  chdir(2): import pathname only once
  chroot(2): import pathname only once
  user_statfs(): import pathname only once
  do_sys_truncate(): import pathname only once
  do_readlinkat(): import pathname only once
  get rid of audit_reusename()
  allow incomplete imports of filenames
  struct filename ->refcnt doesn't need to be atomic

Mateusz Guzik (1):
  fs: touch up predicts in putname()

 fs/namei.c            |  68 +++++++++++++++++++++-------
 fs/open.c             |  39 +++++++++-------
 fs/stat.c             |   6 +--
 fs/statfs.c           |   4 +-
 fs/utimes.c           |  13 +++---
 include/linux/audit.h |  11 -----
 include/linux/fs.h    |  17 ++++---
 io_uring/fs.c         | 101 ++++++++++++++++++++++--------------------
 io_uring/openclose.c  |  16 +++----
 io_uring/statx.c      |  17 +++----
 io_uring/xattr.c      |  30 +++++--------
 kernel/auditsc.c      |  23 ++--------
 12 files changed, 178 insertions(+), 167 deletions(-)

-- 
2.47.3



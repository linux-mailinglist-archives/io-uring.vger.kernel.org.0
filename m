Return-Path: <io-uring+bounces-10840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA67C94525
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A9343A865E
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC8123EABC;
	Sat, 29 Nov 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Hr7uoRbh"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338622D4E9;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435700; cv=none; b=VvVQ0J11T/jGArwiihm1UfxJuaDVBEH4dLC1KUSF4mbWu5jDTqVsbCAx3mhB/5GwIcnrlORX17d4Sfil7pJWDcpTCkOLWWxGbD/iugXlU0JC5vrnFJqKE95qigSBHE2EsbQiis+79/NiakGDU7geHUFekuTKgAhA34YVOAiVz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435700; c=relaxed/simple;
	bh=/V+yneA/RN3f/AC/uyCI7S9UaPcmdyIblLcpjB7S4So=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgpClcICbqcOwE2Y2p6dMMh7IenR9mNGnI7HcTdijC1C3AiVrWMe3dORN4Y78J9r4t1K/LYHKjmoNHtYlZo0S8UU/y6sby8U1YXNJR10qfNOQzadFLkecG5krdnd5l49lye5nsWjFB2KoWDIoczigBFYHGC7O/FjhuP06pmPWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Hr7uoRbh; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=28phI01yHrxIG5STEvcq2/P5S88Qkqz5fNogIl9Xn4A=; b=Hr7uoRbhNuBcVfky2ZyjO5mvpG
	qOUU2VozQRAC/YnCl9C67y7oEFlKMLueNQS8pzsWUyertvCJOugRyVEv+PvWzge2wMhK44BNhE42w
	t1rUaaWBzyehvulABbxKiRxIyOkR9FtQMs8EhzUyM3auPtEAHwCI8CjhfgfUtYjGwGT6R5DB7GsNF
	sD+cP+qLmlDhJYWDh6DaaL4GMFbugLWPVvwb8tk4+sOEnxs3VyBeIk9LTmwiMTbwFmJ0EJMwFAZhM
	28wQm8Bj/qcgAfqhnmwpwx3DJmt0+sT6bQvzUAdeAa0zYe2mqCKbVmaxau1RYOQ0YOdjPLBXPWAfn
	nrigQYYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKM-00000000dBr-11sC;
	Sat, 29 Nov 2025 17:01:42 +0000
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
Subject: [RFC PATCH v2 00/18] io_uring, struct filename and audit
Date: Sat, 29 Nov 2025 17:01:24 +0000
Message-ID: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Changes compared to v1:
	* putname_to_delayed(): new primitive, hopefully solving the
io_openat2() breakage spotted by Jens
	* Linus' suggestion re saner allocation for struct filename
implemented and carved up [##11--15]

It's obviously doing to slip to the next cycle at this point - I'm not
proposing to merge it in the coming window.

Please, review.  Branch in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.filename-refcnt
individual patches in followups.

Al Viro (17):
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
  ntfs: ->d_compare() must not block
  getname_flags() massage, part 1
  getname_flags() massage, part 2
  struct filename: use names_cachep only for getname() and friends
  struct filename: saner handling of long names
  allow incomplete imports of filenames
  struct filename ->refcnt doesn't need to be atomic

Mateusz Guzik (1):
  fs: touch up predicts in putname()

 fs/dcache.c           |   8 +-
 fs/internal.h         |   2 +
 fs/namei.c            | 218 +++++++++++++++++++++++++++---------------
 fs/ntfs3/namei.c      |   8 +-
 fs/open.c             |  39 +++++---
 fs/stat.c             |   6 +-
 fs/statfs.c           |   4 +-
 fs/utimes.c           |  13 +--
 include/linux/audit.h |  11 ---
 include/linux/fs.h    |  28 +++---
 io_uring/fs.c         | 101 ++++++++++---------
 io_uring/openclose.c  |  26 ++---
 io_uring/statx.c      |  17 ++--
 io_uring/xattr.c      |  30 ++----
 kernel/auditsc.c      |  23 +----
 15 files changed, 286 insertions(+), 248 deletions(-)

-- 
2.47.3



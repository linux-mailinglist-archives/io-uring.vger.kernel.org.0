Return-Path: <io-uring+bounces-13907-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xyQUCUshTGrFggEAu9opvQ
	(envelope-from <io-uring+bounces-13907-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:42:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 519EE715CE6
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:42:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vUgZi3hk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bXKX1Txl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="aT/UKbrQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cJwA0HZN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13907-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13907-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AED003036D67
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 21:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219863803D1;
	Mon,  6 Jul 2026 21:41:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579D47ECE8
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 21:41:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783374102; cv=none; b=lmATmjPOzNM7DNuT/0Wwwm/tpK/jbC9lsFX40GVchLF2GQEvoPsUd3pougvRz0hrJ/eLBMFLqrzB2KOCa07bfl6W8mz1A+yvgMwftEuri4NjUh2tcHh+5F7T/QK8HNXFzj6vADYhijLOyQ0s1oBWHcdnpiLQsJ4gKjMY2FMVlT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783374102; c=relaxed/simple;
	bh=Nceze048FqhHhJqIfyABOmrMKkaoL68L2N9uNECXT1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qDA/MnfQA6tMu0ezzc1G6Pr36Mcqr9zpLJlk1IUjH+nfkQJNNbaG9EMB6FO+XWnRBZXmETnkYaoJfgs06mpajtwmqri4kVtu/N8dDy5sPfwXSFb3cNFcjxM4zLeCNoZUSwZAHo8H9CUSwgjowkJOresCxzyv4cx0H/mBFcmlVIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vUgZi3hk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bXKX1Txl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aT/UKbrQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cJwA0HZN; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA09575A33;
	Mon,  6 Jul 2026 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783374097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4ddnpT+VSKNcuroHdlgizGrGeghF6Kyy/xvPQb59vsg=;
	b=vUgZi3hkFbRpN4WtTmwGmhnFkWTPqt/ylro3JMsDPRupHz5yUHLW0/tImjKTySQ1ttVxKq
	qU255uBC1rXuI6ZAdS+R/5U1vc2IO6r0yfoi66K7Ob1LQy+6P4AfuowasBjJq83lT1UGIs
	K7aTACq403qzP8OFKx57HvzTT6yMnF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783374097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4ddnpT+VSKNcuroHdlgizGrGeghF6Kyy/xvPQb59vsg=;
	b=bXKX1Txl1fC4Fq/0f49cMvbG+909qr1iB6Cao3PgpyJC44JcKiDwlCWRYZM2cb+5T2BMTq
	4Ge/ooICd0VabHCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783374096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4ddnpT+VSKNcuroHdlgizGrGeghF6Kyy/xvPQb59vsg=;
	b=aT/UKbrQXn2eAQuf3W7fkA+LIsCOY3hCpoSDMLilo5bvCwuk4Dg7pQJaWPM+LdWaJmub8d
	wPkH10yr+9AT5wKFsySG57trsB9qwG6w0Y9ogjbelirn1bpAcWM/iCPQJZofl3cJRpHoN7
	8dpumMExf8R1MBF90o+yjwuJ2J4rcRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783374096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4ddnpT+VSKNcuroHdlgizGrGeghF6Kyy/xvPQb59vsg=;
	b=cJwA0HZNTDcxDMGPVo5jqc62KrNKIPFtOcECons4HOqiMkmJjLmdD2nZXfdyvkVKxgUmss
	rwwqKOQSz9FKtrAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91C51779AA;
	Mon,  6 Jul 2026 21:41:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yzcGHRAhTGqrGwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 06 Jul 2026 21:41:36 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	ammarfaizi2@gnuweeb.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 0/3] Convert manpages to markdown
Date: Mon,  6 Jul 2026 17:41:22 -0400
Message-ID: <20260706214132.2841060-1-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13907-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:ammarfaizi2@gnuweeb.org,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,suse.de:from_mime,suse.de:dkim,suse.de:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 519EE715CE6

Since rfc:

Since RFC, this had a few changes.  The main one is that the conversion
from groff to MD is now fully automated, and I suggest reviewers look at
the script in the commit message. The patch can be recreated from that.
This should make patch 3 more digestable.  In addition, I've wrapped MD
files to 72 collumns and splitted the alias handling into a separated
patch.

Cover:

This has been discussed for a while due to the ongoing pain of writing
groff.  Now that we just had a release, convert the manpages to markdown
and add infrastructure to generate back the groff automatically during
compilation.

The conversion is not lossless, mostly due to groff being painful.
You'll notice the conversion is not byte-per-byte accurate, but most of
the differences are whitespace, which is not relevant.  Other more
tricky changes are in bold/italics, which I tried to preserve as much as
possible.  The rest seems solved.

This obviously adds a build dependency on pandoc, which is already
packaged by any sane distro out there.  The configure file is updated to
check for that.

There are a few caveats worth mentioned:

1) Groff comments need to be preserved because of copyrights
notices. This is done by a pre-processor python script.

2) A pandoc filter is applied during conversion to fix up code blocks.
Default pandoc is not smart enough to preserve groff blocks under
```...``` marks, so we do that through a filter.

3) We have a large number of symlinks. These are now kept in an ALIAS
file and also re-generated during compilation.

More details in patches the patch sumaries.

Gabriel Krisman Bertazi (3):
  man: Generate aliases during compilation
  man: Introduce rules to convert Markdown to groff
  man: Convert manpages to markdown

 Makefile                                      |    2 +
 configure                                     |    8 +
 man/.gitignore                                |    8 +
 man/ALIASES                                   |   62 +
 man/IO_URING_CHECK_VERSION.3                  |    1 -
 man/IO_URING_VERSION_MAJOR.3                  |    1 -
 man/IO_URING_VERSION_MINOR.3                  |    1 -
 man/Makefile                                  |   17 +
 man/__io_uring_buf_ring_cq_advance.3          |    1 -
 man/io_uring.7                                |  919 -------
 man/io_uring.7.md                             |  779 ++++++
 man/io_uring_buf_ring_add.3                   |   64 -
 man/io_uring_buf_ring_add.3.md                |   65 +
 man/io_uring_buf_ring_advance.3               |   31 -
 man/io_uring_buf_ring_advance.3.md            |   41 +
 man/io_uring_buf_ring_available.3             |   47 -
 man/io_uring_buf_ring_available.3.md          |   57 +
 man/io_uring_buf_ring_cq_advance.3            |   55 -
 man/io_uring_buf_ring_cq_advance.3.md         |   56 +
 man/io_uring_buf_ring_init.3                  |   36 -
 man/io_uring_buf_ring_init.3.md               |   45 +
 man/io_uring_buf_ring_mask.3                  |   27 -
 man/io_uring_buf_ring_mask.3.md               |   37 +
 man/io_uring_cancelation.7                    |  324 ---
 man/io_uring_cancelation.7.md                 |  288 +++
 man/io_uring_check_version.3                  |   72 -
 man/io_uring_check_version.3.md               |   53 +
 man/io_uring_clone_buffers.3                  |  165 --
 man/io_uring_clone_buffers.3.md               |  133 +
 man/io_uring_clone_buffers_offset.3           |    1 -
 man/io_uring_close_ring_fd.3                  |   43 -
 man/io_uring_close_ring_fd.3.md               |   55 +
 man/io_uring_cq_advance.3                     |   49 -
 man/io_uring_cq_advance.3.md                  |   53 +
 man/io_uring_cq_eventfd_enabled.3             |   38 -
 man/io_uring_cq_eventfd_enabled.3.md          |   45 +
 man/io_uring_cq_eventfd_toggle.3              |   48 -
 man/io_uring_cq_eventfd_toggle.3.md           |   53 +
 man/io_uring_cq_has_overflow.3                |   31 -
 man/io_uring_cq_has_overflow.3.md             |   46 +
 man/io_uring_cq_ready.3                       |   26 -
 man/io_uring_cq_ready.3.md                    |   37 +
 man/io_uring_cqe_get_data.3                   |   53 -
 man/io_uring_cqe_get_data.3.md                |   50 +
 man/io_uring_cqe_get_data64.3                 |    1 -
 man/io_uring_cqe_nr.3                         |   35 -
 man/io_uring_cqe_nr.3.md                      |   42 +
 man/io_uring_cqe_seen.3                       |   41 -
 man/io_uring_cqe_seen.3.md                    |   47 +
 man/io_uring_enable_rings.3                   |   40 -
 man/io_uring_enable_rings.3.md                |   48 +
 man/io_uring_enter.2                          | 2208 -----------------
 man/io_uring_enter.2.md                       | 1466 +++++++++++
 man/io_uring_enter2.2                         |    1 -
 man/io_uring_for_each_cqe.3                   |   63 -
 man/io_uring_for_each_cqe.3.md                |   68 +
 man/io_uring_free_buf_ring.3                  |   53 -
 man/io_uring_free_buf_ring.3.md               |   55 +
 man/io_uring_free_probe.3                     |   27 -
 man/io_uring_free_probe.3.md                  |   36 +
 man/io_uring_get_events.3                     |   33 -
 man/io_uring_get_events.3.md                  |   43 +
 man/io_uring_get_probe.3                      |   30 -
 man/io_uring_get_probe.3.md                   |   43 +
 man/io_uring_get_probe_ring.3                 |   39 -
 man/io_uring_get_probe_ring.3.md              |   45 +
 man/io_uring_get_sqe.3                        |   57 -
 man/io_uring_get_sqe.3.md                     |   55 +
 man/io_uring_get_sqe128.3                     |   67 -
 man/io_uring_get_sqe128.3.md                  |   59 +
 man/io_uring_linked_requests.7                |  271 --
 man/io_uring_linked_requests.7.md             |  261 ++
 man/io_uring_major_version.3                  |    1 -
 man/io_uring_memory_size_params.3             |   45 -
 man/io_uring_memory_size_params.3.md          |   51 +
 man/io_uring_minor_version.3                  |    1 -
 man/io_uring_mlock_size.3                     |   42 -
 man/io_uring_mlock_size.3.md                  |   47 +
 man/io_uring_mlock_size_params.3              |   48 -
 man/io_uring_mlock_size_params.3.md           |   49 +
 man/io_uring_multishot.7                      |  246 --
 man/io_uring_multishot.7.md                   |  235 ++
 man/io_uring_opcode_supported.3               |   30 -
 man/io_uring_opcode_supported.3.md            |   39 +
 man/io_uring_peek_batch_cqe.3                 |    1 -
 man/io_uring_peek_cqe.3                       |   59 -
 man/io_uring_peek_cqe.3.md                    |   55 +
 man/io_uring_prep_accept.3                    |  203 --
 man/io_uring_prep_accept.3.md                 |  161 ++
 man/io_uring_prep_accept_direct.3             |    1 -
 man/io_uring_prep_bind.3                      |   54 -
 man/io_uring_prep_bind.3.md                   |   52 +
 man/io_uring_prep_cancel.3                    |  136 -
 man/io_uring_prep_cancel.3.md                 |  138 ++
 man/io_uring_prep_cancel64.3                  |    1 -
 man/io_uring_prep_cancel_fd.3                 |    1 -
 man/io_uring_prep_close.3                     |   67 -
 man/io_uring_prep_close.3.md                  |   62 +
 man/io_uring_prep_close_direct.3              |    1 -
 man/io_uring_prep_cmd_discard.3               |   64 -
 man/io_uring_prep_cmd_discard.3.md            |   62 +
 man/io_uring_prep_cmd_getsockname.3           |   79 -
 man/io_uring_prep_cmd_getsockname.3.md        |   64 +
 man/io_uring_prep_cmd_sock.3                  |  219 --
 man/io_uring_prep_cmd_sock.3.md               |  159 ++
 man/io_uring_prep_connect.3                   |   66 -
 man/io_uring_prep_connect.3.md                |   65 +
 man/io_uring_prep_epoll_ctl.3                 |   74 -
 man/io_uring_prep_epoll_ctl.3.md              |   68 +
 man/io_uring_prep_epoll_wait.3                |   64 -
 man/io_uring_prep_epoll_wait.3.md             |   61 +
 man/io_uring_prep_fadvise.3                   |   76 -
 man/io_uring_prep_fadvise.3.md                |   68 +
 man/io_uring_prep_fadvise64.3                 |    1 -
 man/io_uring_prep_fallocate.3                 |   59 -
 man/io_uring_prep_fallocate.3.md              |   54 +
 man/io_uring_prep_fgetxattr.3                 |    1 -
 man/io_uring_prep_files_update.3              |   92 -
 man/io_uring_prep_files_update.3.md           |   93 +
 man/io_uring_prep_fixed_fd_install.3          |   70 -
 man/io_uring_prep_fixed_fd_install.3.md       |   71 +
 man/io_uring_prep_fsetxattr.3                 |    1 -
 man/io_uring_prep_fsync.3                     |   70 -
 man/io_uring_prep_fsync.3.md                  |   62 +
 man/io_uring_prep_ftruncate.3                 |   54 -
 man/io_uring_prep_ftruncate.3.md              |   51 +
 man/io_uring_prep_futex_wait.3                |   94 -
 man/io_uring_prep_futex_wait.3.md             |   79 +
 man/io_uring_prep_futex_waitv.3               |   78 -
 man/io_uring_prep_futex_waitv.3.md            |   71 +
 man/io_uring_prep_futex_wake.3                |   86 -
 man/io_uring_prep_futex_wake.3.md             |   71 +
 man/io_uring_prep_getxattr.3                  |   61 -
 man/io_uring_prep_getxattr.3.md               |   57 +
 man/io_uring_prep_link.3                      |    1 -
 man/io_uring_prep_link_timeout.3              |   98 -
 man/io_uring_prep_link_timeout.3.md           |  104 +
 man/io_uring_prep_linkat.3                    |   91 -
 man/io_uring_prep_linkat.3.md                 |   80 +
 man/io_uring_prep_listen.3                    |   52 -
 man/io_uring_prep_listen.3.md                 |   53 +
 man/io_uring_prep_madvise.3                   |   72 -
 man/io_uring_prep_madvise.3.md                |   66 +
 man/io_uring_prep_madvise64.3                 |    1 -
 man/io_uring_prep_mkdir.3                     |    1 -
 man/io_uring_prep_mkdirat.3                   |   83 -
 man/io_uring_prep_mkdirat.3.md                |   75 +
 man/io_uring_prep_msg_ring.3                  |   92 -
 man/io_uring_prep_msg_ring.3.md               |   85 +
 man/io_uring_prep_msg_ring_cqe_flags.3        |    1 -
 man/io_uring_prep_msg_ring_fd.3               |   83 -
 man/io_uring_prep_msg_ring_fd.3.md            |   86 +
 man/io_uring_prep_msg_ring_fd_alloc.3         |    1 -
 man/io_uring_prep_multishot_accept.3          |    1 -
 man/io_uring_prep_multishot_accept_direct.3   |    1 -
 man/io_uring_prep_nop.3                       |   28 -
 man/io_uring_prep_nop.3.md                    |   41 +
 man/io_uring_prep_nop128.3                    |   30 -
 man/io_uring_prep_nop128.3.md                 |   42 +
 man/io_uring_prep_open.3                      |    1 -
 man/io_uring_prep_open_direct.3               |    1 -
 man/io_uring_prep_openat.3                    |  138 --
 man/io_uring_prep_openat.3.md                 |  117 +
 man/io_uring_prep_openat2.3                   |  119 -
 man/io_uring_prep_openat2.3.md                |  104 +
 man/io_uring_prep_openat2_direct.3            |    1 -
 man/io_uring_prep_openat_direct.3             |    1 -
 man/io_uring_prep_pipe.3                      |   91 -
 man/io_uring_prep_pipe.3.md                   |   76 +
 man/io_uring_prep_pipe_direct.3               |    1 -
 man/io_uring_prep_poll_add.3                  |   72 -
 man/io_uring_prep_poll_add.3.md               |   68 +
 man/io_uring_prep_poll_multishot.3            |    1 -
 man/io_uring_prep_poll_remove.3               |   55 -
 man/io_uring_prep_poll_remove.3.md            |   66 +
 man/io_uring_prep_poll_update.3               |  101 -
 man/io_uring_prep_poll_update.3.md            |  101 +
 man/io_uring_prep_provide_buffers.3           |  140 --
 man/io_uring_prep_provide_buffers.3.md        |  116 +
 man/io_uring_prep_read.3                      |   76 -
 man/io_uring_prep_read.3.md                   |   72 +
 man/io_uring_prep_read_fixed.3                |   79 -
 man/io_uring_prep_read_fixed.3.md             |   71 +
 man/io_uring_prep_read_multishot.3            |  107 -
 man/io_uring_prep_read_multishot.3.md         |   92 +
 man/io_uring_prep_readv.3                     |   92 -
 man/io_uring_prep_readv.3.md                  |   86 +
 man/io_uring_prep_readv2.3                    |  118 -
 man/io_uring_prep_readv2.3.md                 |  110 +
 man/io_uring_prep_readv_fixed.3               |   74 -
 man/io_uring_prep_readv_fixed.3.md            |   72 +
 man/io_uring_prep_recv.3                      |  147 --
 man/io_uring_prep_recv.3.md                   |  130 +
 man/io_uring_prep_recv_multishot.3            |    1 -
 man/io_uring_prep_recvmsg.3                   |  130 -
 man/io_uring_prep_recvmsg.3.md                |  113 +
 man/io_uring_prep_recvmsg_multishot.3         |    1 -
 man/io_uring_prep_remove_buffers.3            |   52 -
 man/io_uring_prep_remove_buffers.3.md         |   59 +
 man/io_uring_prep_rename.3                    |    1 -
 man/io_uring_prep_renameat.3                  |   95 -
 man/io_uring_prep_renameat.3.md               |   80 +
 man/io_uring_prep_send.3                      |  197 --
 man/io_uring_prep_send.3.md                   |  154 ++
 man/io_uring_prep_send_bundle.3               |    1 -
 man/io_uring_prep_send_set_addr.3             |   38 -
 man/io_uring_prep_send_set_addr.3.md          |   42 +
 man/io_uring_prep_send_zc.3                   |  140 --
 man/io_uring_prep_send_zc.3.md                |  110 +
 man/io_uring_prep_send_zc_fixed.3             |    1 -
 man/io_uring_prep_sendmsg.3                   |  136 -
 man/io_uring_prep_sendmsg.3.md                |  111 +
 man/io_uring_prep_sendmsg_zc.3                |    1 -
 man/io_uring_prep_sendmsg_zc_fixed.3          |   69 -
 man/io_uring_prep_sendmsg_zc_fixed.3.md       |   70 +
 man/io_uring_prep_sendto.3                    |    1 -
 man/io_uring_prep_setxattr.3                  |   64 -
 man/io_uring_prep_setxattr.3.md               |   59 +
 man/io_uring_prep_shutdown.3                  |   53 -
 man/io_uring_prep_shutdown.3.md               |   51 +
 man/io_uring_prep_socket.3                    |  118 -
 man/io_uring_prep_socket.3.md                 |   94 +
 man/io_uring_prep_socket_direct.3             |    1 -
 man/io_uring_prep_socket_direct_alloc.3       |    1 -
 man/io_uring_prep_splice.3                    |  126 -
 man/io_uring_prep_splice.3.md                 |   88 +
 man/io_uring_prep_statx.3                     |   74 -
 man/io_uring_prep_statx.3.md                  |   70 +
 man/io_uring_prep_symlink.3                   |    1 -
 man/io_uring_prep_symlinkat.3                 |   85 -
 man/io_uring_prep_symlinkat.3.md              |   76 +
 man/io_uring_prep_sync_file_range.3           |   59 -
 man/io_uring_prep_sync_file_range.3.md        |   54 +
 man/io_uring_prep_tee.3                       |   80 -
 man/io_uring_prep_tee.3.md                    |   69 +
 man/io_uring_prep_timeout.3                   |  121 -
 man/io_uring_prep_timeout.3.md                |  124 +
 man/io_uring_prep_timeout_remove.3            |    1 -
 man/io_uring_prep_timeout_update.3            |   85 -
 man/io_uring_prep_timeout_update.3.md         |   95 +
 man/io_uring_prep_unlink.3                    |    1 -
 man/io_uring_prep_unlinkat.3                  |   82 -
 man/io_uring_prep_unlinkat.3.md               |   75 +
 man/io_uring_prep_uring_cmd.3                 |   37 -
 man/io_uring_prep_uring_cmd.3.md              |   47 +
 man/io_uring_prep_uring_cmd128.3              |   38 -
 man/io_uring_prep_uring_cmd128.3.md           |   48 +
 man/io_uring_prep_waitid.3                    |   67 -
 man/io_uring_prep_waitid.3.md                 |   60 +
 man/io_uring_prep_write.3                     |   70 -
 man/io_uring_prep_write.3.md                  |   69 +
 man/io_uring_prep_write_fixed.3               |   75 -
 man/io_uring_prep_write_fixed.3.md            |   69 +
 man/io_uring_prep_writev.3                    |   89 -
 man/io_uring_prep_writev.3.md                 |   84 +
 man/io_uring_prep_writev2.3                   |  115 -
 man/io_uring_prep_writev2.3.md                |  108 +
 man/io_uring_prep_writev_fixed.3              |   71 -
 man/io_uring_prep_writev_fixed.3.md           |   72 +
 man/io_uring_provided_buffers.7               |  266 --
 man/io_uring_provided_buffers.7.md            |  255 ++
 man/io_uring_queue_exit.3                     |   30 -
 man/io_uring_queue_exit.3.md                  |   44 +
 man/io_uring_queue_init.3                     |  144 --
 man/io_uring_queue_init.3.md                  |  109 +
 man/io_uring_queue_init_mem.3                 |    1 -
 man/io_uring_queue_init_params.3              |    1 -
 man/io_uring_queue_mmap.3                     |   49 -
 man/io_uring_queue_mmap.3.md                  |   48 +
 man/io_uring_recvmsg_cmsg_firsthdr.3          |    1 -
 man/io_uring_recvmsg_cmsg_nexthdr.3           |    1 -
 man/io_uring_recvmsg_name.3                   |    1 -
 man/io_uring_recvmsg_out.3                    |   82 -
 man/io_uring_recvmsg_out.3.md                 |   82 +
 man/io_uring_recvmsg_payload.3                |    1 -
 man/io_uring_recvmsg_payload_length.3         |    1 -
 man/io_uring_recvmsg_validate.3               |    1 -
 man/io_uring_register.2                       | 1375 ----------
 man/io_uring_register.2.md                    |  932 +++++++
 man/io_uring_register_bpf_filter.3            |  411 ---
 man/io_uring_register_bpf_filter.3.md         |  358 +++
 man/io_uring_register_bpf_filter_task.3       |    1 -
 man/io_uring_register_buf_ring.3              |  165 --
 man/io_uring_register_buf_ring.3.md           |  135 +
 man/io_uring_register_buffers.3               |  105 -
 man/io_uring_register_buffers.3.md            |   86 +
 man/io_uring_register_buffers_sparse.3        |    1 -
 man/io_uring_register_buffers_tags.3          |    1 -
 man/io_uring_register_buffers_update_tag.3    |    1 -
 man/io_uring_register_clock.3                 |   72 -
 man/io_uring_register_clock.3.md              |   71 +
 man/io_uring_register_eventfd.3               |   50 -
 man/io_uring_register_eventfd.3.md            |   62 +
 man/io_uring_register_eventfd_async.3         |    1 -
 man/io_uring_register_file_alloc_range.3      |   52 -
 man/io_uring_register_file_alloc_range.3.md   |   58 +
 man/io_uring_register_files.3                 |  120 -
 man/io_uring_register_files.3.md              |   99 +
 man/io_uring_register_files_sparse.3          |    1 -
 man/io_uring_register_files_tags.3            |    1 -
 man/io_uring_register_files_update.3          |    1 -
 man/io_uring_register_files_update_tag.3      |    1 -
 man/io_uring_register_ifq.3                   |   49 -
 man/io_uring_register_ifq.3.md                |   49 +
 man/io_uring_register_iowq_aff.3              |   67 -
 man/io_uring_register_iowq_aff.3.md           |   68 +
 man/io_uring_register_iowq_max_workers.3      |   71 -
 man/io_uring_register_iowq_max_workers.3.md   |   77 +
 man/io_uring_register_napi.3                  |   40 -
 man/io_uring_register_napi.3.md               |   43 +
 man/io_uring_register_personality.3           |   34 -
 man/io_uring_register_personality.3.md        |   43 +
 man/io_uring_register_probe.3                 |   47 -
 man/io_uring_register_probe.3.md              |   51 +
 man/io_uring_register_query.3                 |  114 -
 man/io_uring_register_query.3.md              |   99 +
 man/io_uring_register_region.3                |  124 -
 man/io_uring_register_region.3.md             |  101 +
 man/io_uring_register_restrictions.3          |   53 -
 man/io_uring_register_restrictions.3.md       |   53 +
 man/io_uring_register_ring_fd.3               |   51 -
 man/io_uring_register_ring_fd.3.md            |   61 +
 man/io_uring_register_sync_cancel.3           |   73 -
 man/io_uring_register_sync_cancel.3.md        |   65 +
 man/io_uring_register_sync_msg.3              |   74 -
 man/io_uring_register_sync_msg.3.md           |   71 +
 man/io_uring_register_wait_reg.3              |   45 -
 man/io_uring_register_wait_reg.3.md           |   49 +
 man/io_uring_register_zcrx_ctrl.3             |   84 -
 man/io_uring_register_zcrx_ctrl.3.md          |   77 +
 man/io_uring_registered_buffers.7             |  238 --
 man/io_uring_registered_buffers.7.md          |  215 ++
 man/io_uring_registered_files.7               |  228 --
 man/io_uring_registered_files.7.md            |  216 ++
 man/io_uring_resize_rings.3                   |  116 -
 man/io_uring_resize_rings.3.md                |  110 +
 man/io_uring_ring_dontfork.3                  |   36 -
 man/io_uring_ring_dontfork.3.md               |   43 +
 man/io_uring_set_iowait.3                     |   57 -
 man/io_uring_set_iowait.3.md                  |   57 +
 man/io_uring_setup.2                          |  820 ------
 man/io_uring_setup.2.md                       |  664 +++++
 man/io_uring_setup_buf_ring.3                 |   94 -
 man/io_uring_setup_buf_ring.3.md              |   85 +
 man/io_uring_setup_flags.7                    |  451 ----
 man/io_uring_setup_flags.7.md                 |  373 +++
 man/io_uring_sq_ready.3                       |   31 -
 man/io_uring_sq_ready.3.md                    |   42 +
 man/io_uring_sq_space_left.3                  |   25 -
 man/io_uring_sq_space_left.3.md               |   36 +
 man/io_uring_sqe_set_buf_group.3              |   32 -
 man/io_uring_sqe_set_buf_group.3.md           |   41 +
 man/io_uring_sqe_set_data.3                   |   57 -
 man/io_uring_sqe_set_data.3.md                |   56 +
 man/io_uring_sqe_set_data64.3                 |    1 -
 man/io_uring_sqe_set_flags.3                  |   87 -
 man/io_uring_sqe_set_flags.3.md               |  103 +
 man/io_uring_sqpoll.7                         |  259 --
 man/io_uring_sqpoll.7.md                      |  244 ++
 man/io_uring_sqring_wait.3                    |   34 -
 man/io_uring_sqring_wait.3.md                 |   44 +
 man/io_uring_submit.3                         |   51 -
 man/io_uring_submit.3.md                      |   59 +
 man/io_uring_submit_and_get_events.3          |   31 -
 man/io_uring_submit_and_get_events.3.md       |   41 +
 man/io_uring_submit_and_wait.3                |   44 -
 man/io_uring_submit_and_wait.3.md             |   50 +
 man/io_uring_submit_and_wait_min_timeout.3    |  119 -
 man/io_uring_submit_and_wait_min_timeout.3.md |   94 +
 man/io_uring_submit_and_wait_reg.3            |   64 -
 man/io_uring_submit_and_wait_reg.3.md         |   62 +
 man/io_uring_submit_and_wait_timeout.3        |   74 -
 man/io_uring_submit_and_wait_timeout.3.md     |   70 +
 man/io_uring_unregister_buf_ring.3            |   30 -
 man/io_uring_unregister_buf_ring.3.md         |   40 +
 man/io_uring_unregister_buffers.3             |   27 -
 man/io_uring_unregister_buffers.3.md          |   38 +
 man/io_uring_unregister_eventfd.3             |    1 -
 man/io_uring_unregister_files.3               |   27 -
 man/io_uring_unregister_files.3.md            |   37 +
 man/io_uring_unregister_iowq_aff.3            |    1 -
 man/io_uring_unregister_napi.3                |   27 -
 man/io_uring_unregister_napi.3.md             |   35 +
 man/io_uring_unregister_personality.3         |   33 -
 man/io_uring_unregister_personality.3.md      |   41 +
 man/io_uring_unregister_ring_fd.3             |   32 -
 man/io_uring_unregister_ring_fd.3.md          |   43 +
 man/io_uring_wait_cqe.3                       |   41 -
 man/io_uring_wait_cqe.3.md                    |   47 +
 man/io_uring_wait_cqe_nr.3                    |   49 -
 man/io_uring_wait_cqe_nr.3.md                 |   54 +
 man/io_uring_wait_cqe_timeout.3               |   62 -
 man/io_uring_wait_cqe_timeout.3.md            |   56 +
 man/io_uring_wait_cqes.3                      |   82 -
 man/io_uring_wait_cqes.3.md                   |   67 +
 man/io_uring_wait_cqes_min_timeout.3          |   76 -
 man/io_uring_wait_cqes_min_timeout.3.md       |   68 +
 397 files changed, 16844 insertions(+), 18975 deletions(-)
 create mode 100644 man/.gitignore
 create mode 100644 man/ALIASES
 delete mode 120000 man/IO_URING_CHECK_VERSION.3
 delete mode 120000 man/IO_URING_VERSION_MAJOR.3
 delete mode 120000 man/IO_URING_VERSION_MINOR.3
 create mode 100644 man/Makefile
 delete mode 120000 man/__io_uring_buf_ring_cq_advance.3
 delete mode 100644 man/io_uring.7
 create mode 100644 man/io_uring.7.md
 delete mode 100644 man/io_uring_buf_ring_add.3
 create mode 100644 man/io_uring_buf_ring_add.3.md
 delete mode 100644 man/io_uring_buf_ring_advance.3
 create mode 100644 man/io_uring_buf_ring_advance.3.md
 delete mode 100644 man/io_uring_buf_ring_available.3
 create mode 100644 man/io_uring_buf_ring_available.3.md
 delete mode 100644 man/io_uring_buf_ring_cq_advance.3
 create mode 100644 man/io_uring_buf_ring_cq_advance.3.md
 delete mode 100644 man/io_uring_buf_ring_init.3
 create mode 100644 man/io_uring_buf_ring_init.3.md
 delete mode 100644 man/io_uring_buf_ring_mask.3
 create mode 100644 man/io_uring_buf_ring_mask.3.md
 delete mode 100644 man/io_uring_cancelation.7
 create mode 100644 man/io_uring_cancelation.7.md
 delete mode 100644 man/io_uring_check_version.3
 create mode 100644 man/io_uring_check_version.3.md
 delete mode 100644 man/io_uring_clone_buffers.3
 create mode 100644 man/io_uring_clone_buffers.3.md
 delete mode 120000 man/io_uring_clone_buffers_offset.3
 delete mode 100644 man/io_uring_close_ring_fd.3
 create mode 100644 man/io_uring_close_ring_fd.3.md
 delete mode 100644 man/io_uring_cq_advance.3
 create mode 100644 man/io_uring_cq_advance.3.md
 delete mode 100644 man/io_uring_cq_eventfd_enabled.3
 create mode 100644 man/io_uring_cq_eventfd_enabled.3.md
 delete mode 100644 man/io_uring_cq_eventfd_toggle.3
 create mode 100644 man/io_uring_cq_eventfd_toggle.3.md
 delete mode 100644 man/io_uring_cq_has_overflow.3
 create mode 100644 man/io_uring_cq_has_overflow.3.md
 delete mode 100644 man/io_uring_cq_ready.3
 create mode 100644 man/io_uring_cq_ready.3.md
 delete mode 100644 man/io_uring_cqe_get_data.3
 create mode 100644 man/io_uring_cqe_get_data.3.md
 delete mode 120000 man/io_uring_cqe_get_data64.3
 delete mode 100644 man/io_uring_cqe_nr.3
 create mode 100644 man/io_uring_cqe_nr.3.md
 delete mode 100644 man/io_uring_cqe_seen.3
 create mode 100644 man/io_uring_cqe_seen.3.md
 delete mode 100644 man/io_uring_enable_rings.3
 create mode 100644 man/io_uring_enable_rings.3.md
 delete mode 100644 man/io_uring_enter.2
 create mode 100644 man/io_uring_enter.2.md
 delete mode 120000 man/io_uring_enter2.2
 delete mode 100644 man/io_uring_for_each_cqe.3
 create mode 100644 man/io_uring_for_each_cqe.3.md
 delete mode 100644 man/io_uring_free_buf_ring.3
 create mode 100644 man/io_uring_free_buf_ring.3.md
 delete mode 100644 man/io_uring_free_probe.3
 create mode 100644 man/io_uring_free_probe.3.md
 delete mode 100644 man/io_uring_get_events.3
 create mode 100644 man/io_uring_get_events.3.md
 delete mode 100644 man/io_uring_get_probe.3
 create mode 100644 man/io_uring_get_probe.3.md
 delete mode 100644 man/io_uring_get_probe_ring.3
 create mode 100644 man/io_uring_get_probe_ring.3.md
 delete mode 100644 man/io_uring_get_sqe.3
 create mode 100644 man/io_uring_get_sqe.3.md
 delete mode 100644 man/io_uring_get_sqe128.3
 create mode 100644 man/io_uring_get_sqe128.3.md
 delete mode 100644 man/io_uring_linked_requests.7
 create mode 100644 man/io_uring_linked_requests.7.md
 delete mode 120000 man/io_uring_major_version.3
 delete mode 100644 man/io_uring_memory_size_params.3
 create mode 100644 man/io_uring_memory_size_params.3.md
 delete mode 120000 man/io_uring_minor_version.3
 delete mode 100644 man/io_uring_mlock_size.3
 create mode 100644 man/io_uring_mlock_size.3.md
 delete mode 100644 man/io_uring_mlock_size_params.3
 create mode 100644 man/io_uring_mlock_size_params.3.md
 delete mode 100644 man/io_uring_multishot.7
 create mode 100644 man/io_uring_multishot.7.md
 delete mode 100644 man/io_uring_opcode_supported.3
 create mode 100644 man/io_uring_opcode_supported.3.md
 delete mode 120000 man/io_uring_peek_batch_cqe.3
 delete mode 100644 man/io_uring_peek_cqe.3
 create mode 100644 man/io_uring_peek_cqe.3.md
 delete mode 100644 man/io_uring_prep_accept.3
 create mode 100644 man/io_uring_prep_accept.3.md
 delete mode 120000 man/io_uring_prep_accept_direct.3
 delete mode 100644 man/io_uring_prep_bind.3
 create mode 100644 man/io_uring_prep_bind.3.md
 delete mode 100644 man/io_uring_prep_cancel.3
 create mode 100644 man/io_uring_prep_cancel.3.md
 delete mode 120000 man/io_uring_prep_cancel64.3
 delete mode 120000 man/io_uring_prep_cancel_fd.3
 delete mode 100644 man/io_uring_prep_close.3
 create mode 100644 man/io_uring_prep_close.3.md
 delete mode 120000 man/io_uring_prep_close_direct.3
 delete mode 100644 man/io_uring_prep_cmd_discard.3
 create mode 100644 man/io_uring_prep_cmd_discard.3.md
 delete mode 100644 man/io_uring_prep_cmd_getsockname.3
 create mode 100644 man/io_uring_prep_cmd_getsockname.3.md
 delete mode 100644 man/io_uring_prep_cmd_sock.3
 create mode 100644 man/io_uring_prep_cmd_sock.3.md
 delete mode 100644 man/io_uring_prep_connect.3
 create mode 100644 man/io_uring_prep_connect.3.md
 delete mode 100644 man/io_uring_prep_epoll_ctl.3
 create mode 100644 man/io_uring_prep_epoll_ctl.3.md
 delete mode 100644 man/io_uring_prep_epoll_wait.3
 create mode 100644 man/io_uring_prep_epoll_wait.3.md
 delete mode 100644 man/io_uring_prep_fadvise.3
 create mode 100644 man/io_uring_prep_fadvise.3.md
 delete mode 120000 man/io_uring_prep_fadvise64.3
 delete mode 100644 man/io_uring_prep_fallocate.3
 create mode 100644 man/io_uring_prep_fallocate.3.md
 delete mode 120000 man/io_uring_prep_fgetxattr.3
 delete mode 100644 man/io_uring_prep_files_update.3
 create mode 100644 man/io_uring_prep_files_update.3.md
 delete mode 100644 man/io_uring_prep_fixed_fd_install.3
 create mode 100644 man/io_uring_prep_fixed_fd_install.3.md
 delete mode 120000 man/io_uring_prep_fsetxattr.3
 delete mode 100644 man/io_uring_prep_fsync.3
 create mode 100644 man/io_uring_prep_fsync.3.md
 delete mode 100644 man/io_uring_prep_ftruncate.3
 create mode 100644 man/io_uring_prep_ftruncate.3.md
 delete mode 100644 man/io_uring_prep_futex_wait.3
 create mode 100644 man/io_uring_prep_futex_wait.3.md
 delete mode 100644 man/io_uring_prep_futex_waitv.3
 create mode 100644 man/io_uring_prep_futex_waitv.3.md
 delete mode 100644 man/io_uring_prep_futex_wake.3
 create mode 100644 man/io_uring_prep_futex_wake.3.md
 delete mode 100644 man/io_uring_prep_getxattr.3
 create mode 100644 man/io_uring_prep_getxattr.3.md
 delete mode 120000 man/io_uring_prep_link.3
 delete mode 100644 man/io_uring_prep_link_timeout.3
 create mode 100644 man/io_uring_prep_link_timeout.3.md
 delete mode 100644 man/io_uring_prep_linkat.3
 create mode 100644 man/io_uring_prep_linkat.3.md
 delete mode 100644 man/io_uring_prep_listen.3
 create mode 100644 man/io_uring_prep_listen.3.md
 delete mode 100644 man/io_uring_prep_madvise.3
 create mode 100644 man/io_uring_prep_madvise.3.md
 delete mode 120000 man/io_uring_prep_madvise64.3
 delete mode 120000 man/io_uring_prep_mkdir.3
 delete mode 100644 man/io_uring_prep_mkdirat.3
 create mode 100644 man/io_uring_prep_mkdirat.3.md
 delete mode 100644 man/io_uring_prep_msg_ring.3
 create mode 100644 man/io_uring_prep_msg_ring.3.md
 delete mode 120000 man/io_uring_prep_msg_ring_cqe_flags.3
 delete mode 100644 man/io_uring_prep_msg_ring_fd.3
 create mode 100644 man/io_uring_prep_msg_ring_fd.3.md
 delete mode 120000 man/io_uring_prep_msg_ring_fd_alloc.3
 delete mode 120000 man/io_uring_prep_multishot_accept.3
 delete mode 120000 man/io_uring_prep_multishot_accept_direct.3
 delete mode 100644 man/io_uring_prep_nop.3
 create mode 100644 man/io_uring_prep_nop.3.md
 delete mode 100644 man/io_uring_prep_nop128.3
 create mode 100644 man/io_uring_prep_nop128.3.md
 delete mode 120000 man/io_uring_prep_open.3
 delete mode 120000 man/io_uring_prep_open_direct.3
 delete mode 100644 man/io_uring_prep_openat.3
 create mode 100644 man/io_uring_prep_openat.3.md
 delete mode 100644 man/io_uring_prep_openat2.3
 create mode 100644 man/io_uring_prep_openat2.3.md
 delete mode 120000 man/io_uring_prep_openat2_direct.3
 delete mode 120000 man/io_uring_prep_openat_direct.3
 delete mode 100644 man/io_uring_prep_pipe.3
 create mode 100644 man/io_uring_prep_pipe.3.md
 delete mode 120000 man/io_uring_prep_pipe_direct.3
 delete mode 100644 man/io_uring_prep_poll_add.3
 create mode 100644 man/io_uring_prep_poll_add.3.md
 delete mode 120000 man/io_uring_prep_poll_multishot.3
 delete mode 100644 man/io_uring_prep_poll_remove.3
 create mode 100644 man/io_uring_prep_poll_remove.3.md
 delete mode 100644 man/io_uring_prep_poll_update.3
 create mode 100644 man/io_uring_prep_poll_update.3.md
 delete mode 100644 man/io_uring_prep_provide_buffers.3
 create mode 100644 man/io_uring_prep_provide_buffers.3.md
 delete mode 100644 man/io_uring_prep_read.3
 create mode 100644 man/io_uring_prep_read.3.md
 delete mode 100644 man/io_uring_prep_read_fixed.3
 create mode 100644 man/io_uring_prep_read_fixed.3.md
 delete mode 100644 man/io_uring_prep_read_multishot.3
 create mode 100644 man/io_uring_prep_read_multishot.3.md
 delete mode 100644 man/io_uring_prep_readv.3
 create mode 100644 man/io_uring_prep_readv.3.md
 delete mode 100644 man/io_uring_prep_readv2.3
 create mode 100644 man/io_uring_prep_readv2.3.md
 delete mode 100644 man/io_uring_prep_readv_fixed.3
 create mode 100644 man/io_uring_prep_readv_fixed.3.md
 delete mode 100644 man/io_uring_prep_recv.3
 create mode 100644 man/io_uring_prep_recv.3.md
 delete mode 120000 man/io_uring_prep_recv_multishot.3
 delete mode 100644 man/io_uring_prep_recvmsg.3
 create mode 100644 man/io_uring_prep_recvmsg.3.md
 delete mode 120000 man/io_uring_prep_recvmsg_multishot.3
 delete mode 100644 man/io_uring_prep_remove_buffers.3
 create mode 100644 man/io_uring_prep_remove_buffers.3.md
 delete mode 120000 man/io_uring_prep_rename.3
 delete mode 100644 man/io_uring_prep_renameat.3
 create mode 100644 man/io_uring_prep_renameat.3.md
 delete mode 100644 man/io_uring_prep_send.3
 create mode 100644 man/io_uring_prep_send.3.md
 delete mode 120000 man/io_uring_prep_send_bundle.3
 delete mode 100644 man/io_uring_prep_send_set_addr.3
 create mode 100644 man/io_uring_prep_send_set_addr.3.md
 delete mode 100644 man/io_uring_prep_send_zc.3
 create mode 100644 man/io_uring_prep_send_zc.3.md
 delete mode 120000 man/io_uring_prep_send_zc_fixed.3
 delete mode 100644 man/io_uring_prep_sendmsg.3
 create mode 100644 man/io_uring_prep_sendmsg.3.md
 delete mode 120000 man/io_uring_prep_sendmsg_zc.3
 delete mode 100644 man/io_uring_prep_sendmsg_zc_fixed.3
 create mode 100644 man/io_uring_prep_sendmsg_zc_fixed.3.md
 delete mode 120000 man/io_uring_prep_sendto.3
 delete mode 100644 man/io_uring_prep_setxattr.3
 create mode 100644 man/io_uring_prep_setxattr.3.md
 delete mode 100644 man/io_uring_prep_shutdown.3
 create mode 100644 man/io_uring_prep_shutdown.3.md
 delete mode 100644 man/io_uring_prep_socket.3
 create mode 100644 man/io_uring_prep_socket.3.md
 delete mode 120000 man/io_uring_prep_socket_direct.3
 delete mode 120000 man/io_uring_prep_socket_direct_alloc.3
 delete mode 100644 man/io_uring_prep_splice.3
 create mode 100644 man/io_uring_prep_splice.3.md
 delete mode 100644 man/io_uring_prep_statx.3
 create mode 100644 man/io_uring_prep_statx.3.md
 delete mode 120000 man/io_uring_prep_symlink.3
 delete mode 100644 man/io_uring_prep_symlinkat.3
 create mode 100644 man/io_uring_prep_symlinkat.3.md
 delete mode 100644 man/io_uring_prep_sync_file_range.3
 create mode 100644 man/io_uring_prep_sync_file_range.3.md
 delete mode 100644 man/io_uring_prep_tee.3
 create mode 100644 man/io_uring_prep_tee.3.md
 delete mode 100644 man/io_uring_prep_timeout.3
 create mode 100644 man/io_uring_prep_timeout.3.md
 delete mode 120000 man/io_uring_prep_timeout_remove.3
 delete mode 100644 man/io_uring_prep_timeout_update.3
 create mode 100644 man/io_uring_prep_timeout_update.3.md
 delete mode 120000 man/io_uring_prep_unlink.3
 delete mode 100644 man/io_uring_prep_unlinkat.3
 create mode 100644 man/io_uring_prep_unlinkat.3.md
 delete mode 100644 man/io_uring_prep_uring_cmd.3
 create mode 100644 man/io_uring_prep_uring_cmd.3.md
 delete mode 100644 man/io_uring_prep_uring_cmd128.3
 create mode 100644 man/io_uring_prep_uring_cmd128.3.md
 delete mode 100644 man/io_uring_prep_waitid.3
 create mode 100644 man/io_uring_prep_waitid.3.md
 delete mode 100644 man/io_uring_prep_write.3
 create mode 100644 man/io_uring_prep_write.3.md
 delete mode 100644 man/io_uring_prep_write_fixed.3
 create mode 100644 man/io_uring_prep_write_fixed.3.md
 delete mode 100644 man/io_uring_prep_writev.3
 create mode 100644 man/io_uring_prep_writev.3.md
 delete mode 100644 man/io_uring_prep_writev2.3
 create mode 100644 man/io_uring_prep_writev2.3.md
 delete mode 100644 man/io_uring_prep_writev_fixed.3
 create mode 100644 man/io_uring_prep_writev_fixed.3.md
 delete mode 100644 man/io_uring_provided_buffers.7
 create mode 100644 man/io_uring_provided_buffers.7.md
 delete mode 100644 man/io_uring_queue_exit.3
 create mode 100644 man/io_uring_queue_exit.3.md
 delete mode 100644 man/io_uring_queue_init.3
 create mode 100644 man/io_uring_queue_init.3.md
 delete mode 120000 man/io_uring_queue_init_mem.3
 delete mode 120000 man/io_uring_queue_init_params.3
 delete mode 100644 man/io_uring_queue_mmap.3
 create mode 100644 man/io_uring_queue_mmap.3.md
 delete mode 120000 man/io_uring_recvmsg_cmsg_firsthdr.3
 delete mode 120000 man/io_uring_recvmsg_cmsg_nexthdr.3
 delete mode 120000 man/io_uring_recvmsg_name.3
 delete mode 100644 man/io_uring_recvmsg_out.3
 create mode 100644 man/io_uring_recvmsg_out.3.md
 delete mode 120000 man/io_uring_recvmsg_payload.3
 delete mode 120000 man/io_uring_recvmsg_payload_length.3
 delete mode 120000 man/io_uring_recvmsg_validate.3
 delete mode 100644 man/io_uring_register.2
 create mode 100644 man/io_uring_register.2.md
 delete mode 100644 man/io_uring_register_bpf_filter.3
 create mode 100644 man/io_uring_register_bpf_filter.3.md
 delete mode 120000 man/io_uring_register_bpf_filter_task.3
 delete mode 100644 man/io_uring_register_buf_ring.3
 create mode 100644 man/io_uring_register_buf_ring.3.md
 delete mode 100644 man/io_uring_register_buffers.3
 create mode 100644 man/io_uring_register_buffers.3.md
 delete mode 120000 man/io_uring_register_buffers_sparse.3
 delete mode 120000 man/io_uring_register_buffers_tags.3
 delete mode 120000 man/io_uring_register_buffers_update_tag.3
 delete mode 100644 man/io_uring_register_clock.3
 create mode 100644 man/io_uring_register_clock.3.md
 delete mode 100644 man/io_uring_register_eventfd.3
 create mode 100644 man/io_uring_register_eventfd.3.md
 delete mode 120000 man/io_uring_register_eventfd_async.3
 delete mode 100644 man/io_uring_register_file_alloc_range.3
 create mode 100644 man/io_uring_register_file_alloc_range.3.md
 delete mode 100644 man/io_uring_register_files.3
 create mode 100644 man/io_uring_register_files.3.md
 delete mode 120000 man/io_uring_register_files_sparse.3
 delete mode 120000 man/io_uring_register_files_tags.3
 delete mode 120000 man/io_uring_register_files_update.3
 delete mode 120000 man/io_uring_register_files_update_tag.3
 delete mode 100644 man/io_uring_register_ifq.3
 create mode 100644 man/io_uring_register_ifq.3.md
 delete mode 100644 man/io_uring_register_iowq_aff.3
 create mode 100644 man/io_uring_register_iowq_aff.3.md
 delete mode 100644 man/io_uring_register_iowq_max_workers.3
 create mode 100644 man/io_uring_register_iowq_max_workers.3.md
 delete mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_register_napi.3.md
 delete mode 100644 man/io_uring_register_personality.3
 create mode 100644 man/io_uring_register_personality.3.md
 delete mode 100644 man/io_uring_register_probe.3
 create mode 100644 man/io_uring_register_probe.3.md
 delete mode 100644 man/io_uring_register_query.3
 create mode 100644 man/io_uring_register_query.3.md
 delete mode 100644 man/io_uring_register_region.3
 create mode 100644 man/io_uring_register_region.3.md
 delete mode 100644 man/io_uring_register_restrictions.3
 create mode 100644 man/io_uring_register_restrictions.3.md
 delete mode 100644 man/io_uring_register_ring_fd.3
 create mode 100644 man/io_uring_register_ring_fd.3.md
 delete mode 100644 man/io_uring_register_sync_cancel.3
 create mode 100644 man/io_uring_register_sync_cancel.3.md
 delete mode 100644 man/io_uring_register_sync_msg.3
 create mode 100644 man/io_uring_register_sync_msg.3.md
 delete mode 100644 man/io_uring_register_wait_reg.3
 create mode 100644 man/io_uring_register_wait_reg.3.md
 delete mode 100644 man/io_uring_register_zcrx_ctrl.3
 create mode 100644 man/io_uring_register_zcrx_ctrl.3.md
 delete mode 100644 man/io_uring_registered_buffers.7
 create mode 100644 man/io_uring_registered_buffers.7.md
 delete mode 100644 man/io_uring_registered_files.7
 create mode 100644 man/io_uring_registered_files.7.md
 delete mode 100644 man/io_uring_resize_rings.3
 create mode 100644 man/io_uring_resize_rings.3.md
 delete mode 100644 man/io_uring_ring_dontfork.3
 create mode 100644 man/io_uring_ring_dontfork.3.md
 delete mode 100644 man/io_uring_set_iowait.3
 create mode 100644 man/io_uring_set_iowait.3.md
 delete mode 100644 man/io_uring_setup.2
 create mode 100644 man/io_uring_setup.2.md
 delete mode 100644 man/io_uring_setup_buf_ring.3
 create mode 100644 man/io_uring_setup_buf_ring.3.md
 delete mode 100644 man/io_uring_setup_flags.7
 create mode 100644 man/io_uring_setup_flags.7.md
 delete mode 100644 man/io_uring_sq_ready.3
 create mode 100644 man/io_uring_sq_ready.3.md
 delete mode 100644 man/io_uring_sq_space_left.3
 create mode 100644 man/io_uring_sq_space_left.3.md
 delete mode 100644 man/io_uring_sqe_set_buf_group.3
 create mode 100644 man/io_uring_sqe_set_buf_group.3.md
 delete mode 100644 man/io_uring_sqe_set_data.3
 create mode 100644 man/io_uring_sqe_set_data.3.md
 delete mode 120000 man/io_uring_sqe_set_data64.3
 delete mode 100644 man/io_uring_sqe_set_flags.3
 create mode 100644 man/io_uring_sqe_set_flags.3.md
 delete mode 100644 man/io_uring_sqpoll.7
 create mode 100644 man/io_uring_sqpoll.7.md
 delete mode 100644 man/io_uring_sqring_wait.3
 create mode 100644 man/io_uring_sqring_wait.3.md
 delete mode 100644 man/io_uring_submit.3
 create mode 100644 man/io_uring_submit.3.md
 delete mode 100644 man/io_uring_submit_and_get_events.3
 create mode 100644 man/io_uring_submit_and_get_events.3.md
 delete mode 100644 man/io_uring_submit_and_wait.3
 create mode 100644 man/io_uring_submit_and_wait.3.md
 delete mode 100644 man/io_uring_submit_and_wait_min_timeout.3
 create mode 100644 man/io_uring_submit_and_wait_min_timeout.3.md
 delete mode 100644 man/io_uring_submit_and_wait_reg.3
 create mode 100644 man/io_uring_submit_and_wait_reg.3.md
 delete mode 100644 man/io_uring_submit_and_wait_timeout.3
 create mode 100644 man/io_uring_submit_and_wait_timeout.3.md
 delete mode 100644 man/io_uring_unregister_buf_ring.3
 create mode 100644 man/io_uring_unregister_buf_ring.3.md
 delete mode 100644 man/io_uring_unregister_buffers.3
 create mode 100644 man/io_uring_unregister_buffers.3.md
 delete mode 120000 man/io_uring_unregister_eventfd.3
 delete mode 100644 man/io_uring_unregister_files.3
 create mode 100644 man/io_uring_unregister_files.3.md
 delete mode 120000 man/io_uring_unregister_iowq_aff.3
 delete mode 100644 man/io_uring_unregister_napi.3
 create mode 100644 man/io_uring_unregister_napi.3.md
 delete mode 100644 man/io_uring_unregister_personality.3
 create mode 100644 man/io_uring_unregister_personality.3.md
 delete mode 100644 man/io_uring_unregister_ring_fd.3
 create mode 100644 man/io_uring_unregister_ring_fd.3.md
 delete mode 100644 man/io_uring_wait_cqe.3
 create mode 100644 man/io_uring_wait_cqe.3.md
 delete mode 100644 man/io_uring_wait_cqe_nr.3
 create mode 100644 man/io_uring_wait_cqe_nr.3.md
 delete mode 100644 man/io_uring_wait_cqe_timeout.3
 create mode 100644 man/io_uring_wait_cqe_timeout.3.md
 delete mode 100644 man/io_uring_wait_cqes.3
 create mode 100644 man/io_uring_wait_cqes.3.md
 delete mode 100644 man/io_uring_wait_cqes_min_timeout.3
 create mode 100644 man/io_uring_wait_cqes_min_timeout.3.md

-- 
2.54.0



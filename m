Return-Path: <io-uring+bounces-13908-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 14XvFk8hTGrHggEAu9opvQ
	(envelope-from <io-uring+bounces-13908-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:42:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9A1715CEE
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:42:38 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=suse.de (policy=none);
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13908-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13908-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DD96303AAAD
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 21:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F229A47ECE9;
	Mon,  6 Jul 2026 21:41:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C7947ECCC
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 21:41:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783374104; cv=none; b=pAJWeUIrEzDfUySFRJapdrwlSvxYs0ZfM9q8dgprhhys/KbY8ELhNjQNVAUTDaMfqHM9N7s/vp3yfd2BXLeI/eaiWmgjWZvy8fRVqdIFotulhne+cooLv72TsXu1UJVAYDb5suZllItpYfp9cZaURBZq2LLoj84rhd8ReazggcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783374104; c=relaxed/simple;
	bh=rEnsTSPo3F+ugmYjFEEQqJicgc9oW66bVRrXr8HLYg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOF/qFGGXUjX6HgdmS7X+l6VAoA9+T6dRJhXB0AY9ieFB+0Ne5VPFGlhKBeBzCtq4nDLmCZZ8+36j3S8kRlbjUBazDnDfjjX0dQ6VP84teEOnGj1LM5GY/qlru4vt/amYUEAkFJy0PwUi0NKbkgSLQBXw/jtaVaEFZB4LoYxxck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A52EA75821;
	Mon,  6 Jul 2026 21:41:40 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E83D779AA;
	Mon,  6 Jul 2026 21:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8n2ZDBQhTGqwGwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 06 Jul 2026 21:41:40 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	ammarfaizi2@gnuweeb.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/3] man: Generate aliases during compilation
Date: Mon,  6 Jul 2026 17:41:23 -0400
Message-ID: <20260706214132.2841060-2-krisman@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706214132.2841060-1-krisman@suse.de>
References: <20260706214132.2841060-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[suse.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13908-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:ammarfaizi2@gnuweeb.org,m:krisman@suse.de,s:lists@lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,suse.de:from_mime,suse.de:email,suse.de:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EE9A1715CEE

In preparation of the markdown conversion, instead of maintaining
symlinks for multiple names of the same manpage, generate them as a
compilation step.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Makefile                                    |  2 +
 man/ALIASES                                 | 62 +++++++++++++++++++++
 man/IO_URING_CHECK_VERSION.3                |  1 -
 man/IO_URING_VERSION_MAJOR.3                |  1 -
 man/IO_URING_VERSION_MINOR.3                |  1 -
 man/Makefile                                |  8 +++
 man/__io_uring_buf_ring_cq_advance.3        |  1 -
 man/io_uring_clone_buffers_offset.3         |  1 -
 man/io_uring_cqe_get_data64.3               |  1 -
 man/io_uring_enter2.2                       |  1 -
 man/io_uring_major_version.3                |  1 -
 man/io_uring_minor_version.3                |  1 -
 man/io_uring_peek_batch_cqe.3               |  1 -
 man/io_uring_prep_accept_direct.3           |  1 -
 man/io_uring_prep_cancel64.3                |  1 -
 man/io_uring_prep_cancel_fd.3               |  1 -
 man/io_uring_prep_close_direct.3            |  1 -
 man/io_uring_prep_fadvise64.3               |  1 -
 man/io_uring_prep_fgetxattr.3               |  1 -
 man/io_uring_prep_fsetxattr.3               |  1 -
 man/io_uring_prep_link.3                    |  1 -
 man/io_uring_prep_madvise64.3               |  1 -
 man/io_uring_prep_mkdir.3                   |  1 -
 man/io_uring_prep_msg_ring_cqe_flags.3      |  1 -
 man/io_uring_prep_msg_ring_fd_alloc.3       |  1 -
 man/io_uring_prep_multishot_accept.3        |  1 -
 man/io_uring_prep_multishot_accept_direct.3 |  1 -
 man/io_uring_prep_open.3                    |  1 -
 man/io_uring_prep_open_direct.3             |  1 -
 man/io_uring_prep_openat2_direct.3          |  1 -
 man/io_uring_prep_openat_direct.3           |  1 -
 man/io_uring_prep_pipe_direct.3             |  1 -
 man/io_uring_prep_poll_multishot.3          |  1 -
 man/io_uring_prep_recv_multishot.3          |  1 -
 man/io_uring_prep_recvmsg_multishot.3       |  1 -
 man/io_uring_prep_rename.3                  |  1 -
 man/io_uring_prep_send_bundle.3             |  1 -
 man/io_uring_prep_send_zc_fixed.3           |  1 -
 man/io_uring_prep_sendmsg_zc.3              |  1 -
 man/io_uring_prep_sendto.3                  |  1 -
 man/io_uring_prep_socket_direct.3           |  1 -
 man/io_uring_prep_socket_direct_alloc.3     |  1 -
 man/io_uring_prep_symlink.3                 |  1 -
 man/io_uring_prep_timeout_remove.3          |  1 -
 man/io_uring_prep_unlink.3                  |  1 -
 man/io_uring_queue_init_mem.3               |  1 -
 man/io_uring_queue_init_params.3            |  1 -
 man/io_uring_recvmsg_cmsg_firsthdr.3        |  1 -
 man/io_uring_recvmsg_cmsg_nexthdr.3         |  1 -
 man/io_uring_recvmsg_name.3                 |  1 -
 man/io_uring_recvmsg_payload.3              |  1 -
 man/io_uring_recvmsg_payload_length.3       |  1 -
 man/io_uring_recvmsg_validate.3             |  1 -
 man/io_uring_register_bpf_filter_task.3     |  1 -
 man/io_uring_register_buffers_sparse.3      |  1 -
 man/io_uring_register_buffers_tags.3        |  1 -
 man/io_uring_register_buffers_update_tag.3  |  1 -
 man/io_uring_register_eventfd_async.3       |  1 -
 man/io_uring_register_files_sparse.3        |  1 -
 man/io_uring_register_files_tags.3          |  1 -
 man/io_uring_register_files_update.3        |  1 -
 man/io_uring_register_files_update_tag.3    |  1 -
 man/io_uring_sqe_set_data64.3               |  1 -
 man/io_uring_unregister_eventfd.3           |  1 -
 man/io_uring_unregister_iowq_aff.3          |  1 -
 65 files changed, 72 insertions(+), 62 deletions(-)
 create mode 100644 man/ALIASES
 delete mode 120000 man/IO_URING_CHECK_VERSION.3
 delete mode 120000 man/IO_URING_VERSION_MAJOR.3
 delete mode 120000 man/IO_URING_VERSION_MINOR.3
 create mode 100644 man/Makefile
 delete mode 120000 man/__io_uring_buf_ring_cq_advance.3
 delete mode 120000 man/io_uring_clone_buffers_offset.3
 delete mode 120000 man/io_uring_cqe_get_data64.3
 delete mode 120000 man/io_uring_enter2.2
 delete mode 120000 man/io_uring_major_version.3
 delete mode 120000 man/io_uring_minor_version.3
 delete mode 120000 man/io_uring_peek_batch_cqe.3
 delete mode 120000 man/io_uring_prep_accept_direct.3
 delete mode 120000 man/io_uring_prep_cancel64.3
 delete mode 120000 man/io_uring_prep_cancel_fd.3
 delete mode 120000 man/io_uring_prep_close_direct.3
 delete mode 120000 man/io_uring_prep_fadvise64.3
 delete mode 120000 man/io_uring_prep_fgetxattr.3
 delete mode 120000 man/io_uring_prep_fsetxattr.3
 delete mode 120000 man/io_uring_prep_link.3
 delete mode 120000 man/io_uring_prep_madvise64.3
 delete mode 120000 man/io_uring_prep_mkdir.3
 delete mode 120000 man/io_uring_prep_msg_ring_cqe_flags.3
 delete mode 120000 man/io_uring_prep_msg_ring_fd_alloc.3
 delete mode 120000 man/io_uring_prep_multishot_accept.3
 delete mode 120000 man/io_uring_prep_multishot_accept_direct.3
 delete mode 120000 man/io_uring_prep_open.3
 delete mode 120000 man/io_uring_prep_open_direct.3
 delete mode 120000 man/io_uring_prep_openat2_direct.3
 delete mode 120000 man/io_uring_prep_openat_direct.3
 delete mode 120000 man/io_uring_prep_pipe_direct.3
 delete mode 120000 man/io_uring_prep_poll_multishot.3
 delete mode 120000 man/io_uring_prep_recv_multishot.3
 delete mode 120000 man/io_uring_prep_recvmsg_multishot.3
 delete mode 120000 man/io_uring_prep_rename.3
 delete mode 120000 man/io_uring_prep_send_bundle.3
 delete mode 120000 man/io_uring_prep_send_zc_fixed.3
 delete mode 120000 man/io_uring_prep_sendmsg_zc.3
 delete mode 120000 man/io_uring_prep_sendto.3
 delete mode 120000 man/io_uring_prep_socket_direct.3
 delete mode 120000 man/io_uring_prep_socket_direct_alloc.3
 delete mode 120000 man/io_uring_prep_symlink.3
 delete mode 120000 man/io_uring_prep_timeout_remove.3
 delete mode 120000 man/io_uring_prep_unlink.3
 delete mode 120000 man/io_uring_queue_init_mem.3
 delete mode 120000 man/io_uring_queue_init_params.3
 delete mode 120000 man/io_uring_recvmsg_cmsg_firsthdr.3
 delete mode 120000 man/io_uring_recvmsg_cmsg_nexthdr.3
 delete mode 120000 man/io_uring_recvmsg_name.3
 delete mode 120000 man/io_uring_recvmsg_payload.3
 delete mode 120000 man/io_uring_recvmsg_payload_length.3
 delete mode 120000 man/io_uring_recvmsg_validate.3
 delete mode 120000 man/io_uring_register_bpf_filter_task.3
 delete mode 120000 man/io_uring_register_buffers_sparse.3
 delete mode 120000 man/io_uring_register_buffers_tags.3
 delete mode 120000 man/io_uring_register_buffers_update_tag.3
 delete mode 120000 man/io_uring_register_eventfd_async.3
 delete mode 120000 man/io_uring_register_files_sparse.3
 delete mode 120000 man/io_uring_register_files_tags.3
 delete mode 120000 man/io_uring_register_files_update.3
 delete mode 120000 man/io_uring_register_files_update_tag.3
 delete mode 120000 man/io_uring_sqe_set_data64.3
 delete mode 120000 man/io_uring_unregister_eventfd.3
 delete mode 120000 man/io_uring_unregister_iowq_aff.3

diff --git a/Makefile b/Makefile
index a2c8e10f..4046b4ba 100644
--- a/Makefile
+++ b/Makefile
@@ -13,6 +13,7 @@ all:
 	@$(MAKE) -C src
 	@$(MAKE) -C test
 	@$(MAKE) -C examples
+	@$(MAKE) -C man
 
 library:
 	@$(MAKE) -C src
@@ -82,6 +83,7 @@ clean:
 	@$(MAKE) -C src clean
 	@$(MAKE) -C test clean
 	@$(MAKE) -C examples clean
+	@$(MAKE) -C man clean
 
 cscope:
 	@cscope -b -R
diff --git a/man/ALIASES b/man/ALIASES
new file mode 100644
index 00000000..3a9abdfe
--- /dev/null
+++ b/man/ALIASES
@@ -0,0 +1,62 @@
+__io_uring_buf_ring_cq_advance.3	io_uring_buf_ring_cq_advance.3
+IO_URING_CHECK_VERSION.3		io_uring_check_version.3
+io_uring_clone_buffers_offset.3		io_uring_clone_buffers.3
+io_uring_cqe_get_data64.3		io_uring_cqe_get_data.3
+io_uring_enter2.2			io_uring_enter.2
+io_uring_major_version.3		io_uring_check_version.3
+io_uring_minor_version.3		io_uring_check_version.3
+io_uring_peek_batch_cqe.3		io_uring_peek_cqe.3
+io_uring_prep_accept_direct.3		io_uring_prep_accept.3
+io_uring_prep_cancel64.3		io_uring_prep_cancel.3
+io_uring_prep_cancel_fd.3		io_uring_prep_cancel.3
+io_uring_prep_close_direct.3		io_uring_prep_close.3
+io_uring_prep_fadvise64.3		io_uring_prep_fadvise.3
+io_uring_prep_fgetxattr.3		io_uring_prep_getxattr.3
+io_uring_prep_fsetxattr.3		io_uring_prep_setxattr.3
+io_uring_prep_link.3			io_uring_prep_linkat.3
+io_uring_prep_madvise64.3		io_uring_prep_madvise.3
+io_uring_prep_mkdir.3			io_uring_prep_mkdirat.3
+io_uring_prep_msg_ring_cqe_flags.3	io_uring_prep_msg_ring.3
+io_uring_prep_msg_ring_fd_alloc.3	io_uring_prep_msg_ring_fd.3
+io_uring_prep_multishot_accept.3	io_uring_prep_accept.3
+io_uring_prep_multishot_accept_direct.3	io_uring_prep_accept.3
+io_uring_prep_open.3			io_uring_prep_openat.3
+io_uring_prep_openat2_direct.3		io_uring_prep_openat2.3
+io_uring_prep_openat_direct.3		io_uring_prep_openat.3
+io_uring_prep_open_direct.3		io_uring_prep_openat.3
+io_uring_prep_pipe_direct.3		io_uring_prep_pipe.3
+io_uring_prep_poll_multishot.3		io_uring_prep_poll_add.3
+io_uring_prep_recvmsg_multishot.3	io_uring_prep_recvmsg.3
+io_uring_prep_recv_multishot.3		io_uring_prep_recv.3
+io_uring_prep_rename.3			io_uring_prep_renameat.3
+io_uring_prep_send_bundle.3		io_uring_prep_send.3
+io_uring_prep_sendmsg_zc.3		io_uring_prep_sendmsg.3
+io_uring_prep_sendto.3			io_uring_prep_send.3
+io_uring_prep_send_zc_fixed.3		io_uring_prep_send_zc.3
+io_uring_prep_socket_direct.3		io_uring_prep_socket.3
+io_uring_prep_socket_direct_alloc.3	io_uring_prep_socket.3
+io_uring_prep_symlink.3			io_uring_prep_symlinkat.3
+io_uring_prep_timeout_remove.3		io_uring_prep_timeout_update.3
+io_uring_prep_unlink.3			io_uring_prep_unlinkat.3
+io_uring_queue_init_mem.3		io_uring_queue_init.3
+io_uring_queue_init_params.3		io_uring_queue_init.3
+io_uring_recvmsg_cmsg_firsthdr.3	io_uring_recvmsg_out.3
+io_uring_recvmsg_cmsg_nexthdr.3		io_uring_recvmsg_out.3
+io_uring_recvmsg_name.3			io_uring_recvmsg_out.3
+io_uring_recvmsg_payload.3		io_uring_recvmsg_out.3
+io_uring_recvmsg_payload_length.3	io_uring_recvmsg_out.3
+io_uring_recvmsg_validate.3		io_uring_recvmsg_out.3
+io_uring_register_bpf_filter_task.3	io_uring_register_bpf_filter.3
+io_uring_register_buffers_sparse.3	io_uring_register_buffers.3
+io_uring_register_buffers_tags.3	io_uring_register_buffers.3
+io_uring_register_buffers_update_tag.3	io_uring_register_buffers.3
+io_uring_register_eventfd_async.3	io_uring_register_eventfd.3
+io_uring_register_files_sparse.3	io_uring_register_files.3
+io_uring_register_files_tags.3		io_uring_register_files.3
+io_uring_register_files_update.3	io_uring_register_files.3
+io_uring_register_files_update_tag.3	io_uring_register_files.3
+io_uring_sqe_set_data64.3		io_uring_sqe_set_data.3
+io_uring_unregister_eventfd.3		io_uring_register_eventfd.3
+io_uring_unregister_iowq_aff.3		io_uring_register_iowq_aff.3
+IO_URING_VERSION_MAJOR.3		io_uring_check_version.3
+IO_URING_VERSION_MINOR.3		io_uring_check_version.3
diff --git a/man/IO_URING_CHECK_VERSION.3 b/man/IO_URING_CHECK_VERSION.3
deleted file mode 120000
index 21bbf456..00000000
--- a/man/IO_URING_CHECK_VERSION.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_check_version.3
\ No newline at end of file
diff --git a/man/IO_URING_VERSION_MAJOR.3 b/man/IO_URING_VERSION_MAJOR.3
deleted file mode 120000
index 21bbf456..00000000
--- a/man/IO_URING_VERSION_MAJOR.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_check_version.3
\ No newline at end of file
diff --git a/man/IO_URING_VERSION_MINOR.3 b/man/IO_URING_VERSION_MINOR.3
deleted file mode 120000
index 21bbf456..00000000
--- a/man/IO_URING_VERSION_MINOR.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_check_version.3
\ No newline at end of file
diff --git a/man/Makefile b/man/Makefile
new file mode 100644
index 00000000..0c68d9db
--- /dev/null
+++ b/man/Makefile
@@ -0,0 +1,8 @@
+.PHONY all clean
+
+all: gen_aliases
+
+gen_aliases:
+	while IFS=$$'\t' read -r link tgt ; do ln -f -s $$tgt $$link; done < ALIASES
+clean:
+	-rm  -f *.2 *.3 *.7
diff --git a/man/__io_uring_buf_ring_cq_advance.3 b/man/__io_uring_buf_ring_cq_advance.3
deleted file mode 120000
index 4b3a1e5f..00000000
--- a/man/__io_uring_buf_ring_cq_advance.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_buf_ring_cq_advance.3
\ No newline at end of file
diff --git a/man/io_uring_clone_buffers_offset.3 b/man/io_uring_clone_buffers_offset.3
deleted file mode 120000
index 6d7e5483..00000000
--- a/man/io_uring_clone_buffers_offset.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_clone_buffers.3
\ No newline at end of file
diff --git a/man/io_uring_cqe_get_data64.3 b/man/io_uring_cqe_get_data64.3
deleted file mode 120000
index 51991c2a..00000000
--- a/man/io_uring_cqe_get_data64.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_cqe_get_data.3
\ No newline at end of file
diff --git a/man/io_uring_enter2.2 b/man/io_uring_enter2.2
deleted file mode 120000
index 5566c093..00000000
--- a/man/io_uring_enter2.2
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_enter.2
\ No newline at end of file
diff --git a/man/io_uring_major_version.3 b/man/io_uring_major_version.3
deleted file mode 120000
index 21bbf456..00000000
--- a/man/io_uring_major_version.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_check_version.3
\ No newline at end of file
diff --git a/man/io_uring_minor_version.3 b/man/io_uring_minor_version.3
deleted file mode 120000
index 21bbf456..00000000
--- a/man/io_uring_minor_version.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_check_version.3
\ No newline at end of file
diff --git a/man/io_uring_peek_batch_cqe.3 b/man/io_uring_peek_batch_cqe.3
deleted file mode 120000
index fbf4e4cc..00000000
--- a/man/io_uring_peek_batch_cqe.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_peek_cqe.3
\ No newline at end of file
diff --git a/man/io_uring_prep_accept_direct.3 b/man/io_uring_prep_accept_direct.3
deleted file mode 120000
index 0404bf59..00000000
--- a/man/io_uring_prep_accept_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_accept.3
\ No newline at end of file
diff --git a/man/io_uring_prep_cancel64.3 b/man/io_uring_prep_cancel64.3
deleted file mode 120000
index 347db090..00000000
--- a/man/io_uring_prep_cancel64.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_cancel.3
\ No newline at end of file
diff --git a/man/io_uring_prep_cancel_fd.3 b/man/io_uring_prep_cancel_fd.3
deleted file mode 120000
index 347db090..00000000
--- a/man/io_uring_prep_cancel_fd.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_cancel.3
\ No newline at end of file
diff --git a/man/io_uring_prep_close_direct.3 b/man/io_uring_prep_close_direct.3
deleted file mode 120000
index d9ce6a60..00000000
--- a/man/io_uring_prep_close_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_close.3
\ No newline at end of file
diff --git a/man/io_uring_prep_fadvise64.3 b/man/io_uring_prep_fadvise64.3
deleted file mode 120000
index cfd68287..00000000
--- a/man/io_uring_prep_fadvise64.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_fadvise.3
\ No newline at end of file
diff --git a/man/io_uring_prep_fgetxattr.3 b/man/io_uring_prep_fgetxattr.3
deleted file mode 120000
index fd0634a9..00000000
--- a/man/io_uring_prep_fgetxattr.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_getxattr.3
\ No newline at end of file
diff --git a/man/io_uring_prep_fsetxattr.3 b/man/io_uring_prep_fsetxattr.3
deleted file mode 120000
index 724254cd..00000000
--- a/man/io_uring_prep_fsetxattr.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_setxattr.3
\ No newline at end of file
diff --git a/man/io_uring_prep_link.3 b/man/io_uring_prep_link.3
deleted file mode 120000
index 6d3059de..00000000
--- a/man/io_uring_prep_link.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_linkat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_madvise64.3 b/man/io_uring_prep_madvise64.3
deleted file mode 120000
index 1a368eea..00000000
--- a/man/io_uring_prep_madvise64.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_madvise.3
\ No newline at end of file
diff --git a/man/io_uring_prep_mkdir.3 b/man/io_uring_prep_mkdir.3
deleted file mode 120000
index b3412d1d..00000000
--- a/man/io_uring_prep_mkdir.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_mkdirat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_msg_ring_cqe_flags.3 b/man/io_uring_prep_msg_ring_cqe_flags.3
deleted file mode 120000
index c96663b8..00000000
--- a/man/io_uring_prep_msg_ring_cqe_flags.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_msg_ring.3
\ No newline at end of file
diff --git a/man/io_uring_prep_msg_ring_fd_alloc.3 b/man/io_uring_prep_msg_ring_fd_alloc.3
deleted file mode 120000
index a3a7731f..00000000
--- a/man/io_uring_prep_msg_ring_fd_alloc.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_msg_ring_fd.3
\ No newline at end of file
diff --git a/man/io_uring_prep_multishot_accept.3 b/man/io_uring_prep_multishot_accept.3
deleted file mode 120000
index 0404bf59..00000000
--- a/man/io_uring_prep_multishot_accept.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_accept.3
\ No newline at end of file
diff --git a/man/io_uring_prep_multishot_accept_direct.3 b/man/io_uring_prep_multishot_accept_direct.3
deleted file mode 120000
index 0404bf59..00000000
--- a/man/io_uring_prep_multishot_accept_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_accept.3
\ No newline at end of file
diff --git a/man/io_uring_prep_open.3 b/man/io_uring_prep_open.3
deleted file mode 120000
index 67f501e5..00000000
--- a/man/io_uring_prep_open.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_openat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_open_direct.3 b/man/io_uring_prep_open_direct.3
deleted file mode 120000
index 67f501e5..00000000
--- a/man/io_uring_prep_open_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_openat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_openat2_direct.3 b/man/io_uring_prep_openat2_direct.3
deleted file mode 120000
index 2c0e6c9c..00000000
--- a/man/io_uring_prep_openat2_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_openat2.3
\ No newline at end of file
diff --git a/man/io_uring_prep_openat_direct.3 b/man/io_uring_prep_openat_direct.3
deleted file mode 120000
index 67f501e5..00000000
--- a/man/io_uring_prep_openat_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_openat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_pipe_direct.3 b/man/io_uring_prep_pipe_direct.3
deleted file mode 120000
index 025c635b..00000000
--- a/man/io_uring_prep_pipe_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_pipe.3
\ No newline at end of file
diff --git a/man/io_uring_prep_poll_multishot.3 b/man/io_uring_prep_poll_multishot.3
deleted file mode 120000
index ac8fb8fd..00000000
--- a/man/io_uring_prep_poll_multishot.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_poll_add.3
\ No newline at end of file
diff --git a/man/io_uring_prep_recv_multishot.3 b/man/io_uring_prep_recv_multishot.3
deleted file mode 120000
index 71fe277d..00000000
--- a/man/io_uring_prep_recv_multishot.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_recv.3
\ No newline at end of file
diff --git a/man/io_uring_prep_recvmsg_multishot.3 b/man/io_uring_prep_recvmsg_multishot.3
deleted file mode 120000
index cd9566f2..00000000
--- a/man/io_uring_prep_recvmsg_multishot.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_recvmsg.3
\ No newline at end of file
diff --git a/man/io_uring_prep_rename.3 b/man/io_uring_prep_rename.3
deleted file mode 120000
index 785b55eb..00000000
--- a/man/io_uring_prep_rename.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_renameat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_send_bundle.3 b/man/io_uring_prep_send_bundle.3
deleted file mode 120000
index ba85e684..00000000
--- a/man/io_uring_prep_send_bundle.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_send.3
\ No newline at end of file
diff --git a/man/io_uring_prep_send_zc_fixed.3 b/man/io_uring_prep_send_zc_fixed.3
deleted file mode 120000
index c66c84d6..00000000
--- a/man/io_uring_prep_send_zc_fixed.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_send_zc.3
\ No newline at end of file
diff --git a/man/io_uring_prep_sendmsg_zc.3 b/man/io_uring_prep_sendmsg_zc.3
deleted file mode 120000
index 47599fb0..00000000
--- a/man/io_uring_prep_sendmsg_zc.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_sendmsg.3
\ No newline at end of file
diff --git a/man/io_uring_prep_sendto.3 b/man/io_uring_prep_sendto.3
deleted file mode 120000
index ba85e684..00000000
--- a/man/io_uring_prep_sendto.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_send.3
\ No newline at end of file
diff --git a/man/io_uring_prep_socket_direct.3 b/man/io_uring_prep_socket_direct.3
deleted file mode 120000
index 15d7b7f0..00000000
--- a/man/io_uring_prep_socket_direct.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_socket.3
\ No newline at end of file
diff --git a/man/io_uring_prep_socket_direct_alloc.3 b/man/io_uring_prep_socket_direct_alloc.3
deleted file mode 120000
index 15d7b7f0..00000000
--- a/man/io_uring_prep_socket_direct_alloc.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_socket.3
\ No newline at end of file
diff --git a/man/io_uring_prep_symlink.3 b/man/io_uring_prep_symlink.3
deleted file mode 120000
index ae6f41a2..00000000
--- a/man/io_uring_prep_symlink.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_symlinkat.3
\ No newline at end of file
diff --git a/man/io_uring_prep_timeout_remove.3 b/man/io_uring_prep_timeout_remove.3
deleted file mode 120000
index 5aebd368..00000000
--- a/man/io_uring_prep_timeout_remove.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_timeout_update.3
\ No newline at end of file
diff --git a/man/io_uring_prep_unlink.3 b/man/io_uring_prep_unlink.3
deleted file mode 120000
index 80f86d2d..00000000
--- a/man/io_uring_prep_unlink.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_prep_unlinkat.3
\ No newline at end of file
diff --git a/man/io_uring_queue_init_mem.3 b/man/io_uring_queue_init_mem.3
deleted file mode 120000
index c91609e5..00000000
--- a/man/io_uring_queue_init_mem.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_queue_init.3
\ No newline at end of file
diff --git a/man/io_uring_queue_init_params.3 b/man/io_uring_queue_init_params.3
deleted file mode 120000
index c91609e5..00000000
--- a/man/io_uring_queue_init_params.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_queue_init.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_cmsg_firsthdr.3 b/man/io_uring_recvmsg_cmsg_firsthdr.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_cmsg_firsthdr.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_cmsg_nexthdr.3 b/man/io_uring_recvmsg_cmsg_nexthdr.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_cmsg_nexthdr.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_name.3 b/man/io_uring_recvmsg_name.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_name.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_payload.3 b/man/io_uring_recvmsg_payload.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_payload.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_payload_length.3 b/man/io_uring_recvmsg_payload_length.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_payload_length.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_recvmsg_validate.3 b/man/io_uring_recvmsg_validate.3
deleted file mode 120000
index 8eb17436..00000000
--- a/man/io_uring_recvmsg_validate.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_recvmsg_out.3
\ No newline at end of file
diff --git a/man/io_uring_register_bpf_filter_task.3 b/man/io_uring_register_bpf_filter_task.3
deleted file mode 120000
index ed26b2aa..00000000
--- a/man/io_uring_register_bpf_filter_task.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_bpf_filter.3
\ No newline at end of file
diff --git a/man/io_uring_register_buffers_sparse.3 b/man/io_uring_register_buffers_sparse.3
deleted file mode 120000
index 1019ce4f..00000000
--- a/man/io_uring_register_buffers_sparse.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_buffers.3
\ No newline at end of file
diff --git a/man/io_uring_register_buffers_tags.3 b/man/io_uring_register_buffers_tags.3
deleted file mode 120000
index 1019ce4f..00000000
--- a/man/io_uring_register_buffers_tags.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_buffers.3
\ No newline at end of file
diff --git a/man/io_uring_register_buffers_update_tag.3 b/man/io_uring_register_buffers_update_tag.3
deleted file mode 120000
index 1019ce4f..00000000
--- a/man/io_uring_register_buffers_update_tag.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_buffers.3
\ No newline at end of file
diff --git a/man/io_uring_register_eventfd_async.3 b/man/io_uring_register_eventfd_async.3
deleted file mode 120000
index 66599571..00000000
--- a/man/io_uring_register_eventfd_async.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_eventfd.3
\ No newline at end of file
diff --git a/man/io_uring_register_files_sparse.3 b/man/io_uring_register_files_sparse.3
deleted file mode 120000
index db38b932..00000000
--- a/man/io_uring_register_files_sparse.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_files.3
\ No newline at end of file
diff --git a/man/io_uring_register_files_tags.3 b/man/io_uring_register_files_tags.3
deleted file mode 120000
index db38b932..00000000
--- a/man/io_uring_register_files_tags.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_files.3
\ No newline at end of file
diff --git a/man/io_uring_register_files_update.3 b/man/io_uring_register_files_update.3
deleted file mode 120000
index db38b932..00000000
--- a/man/io_uring_register_files_update.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_files.3
\ No newline at end of file
diff --git a/man/io_uring_register_files_update_tag.3 b/man/io_uring_register_files_update_tag.3
deleted file mode 120000
index db38b932..00000000
--- a/man/io_uring_register_files_update_tag.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_files.3
\ No newline at end of file
diff --git a/man/io_uring_sqe_set_data64.3 b/man/io_uring_sqe_set_data64.3
deleted file mode 120000
index 8bbd6927..00000000
--- a/man/io_uring_sqe_set_data64.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_sqe_set_data.3
\ No newline at end of file
diff --git a/man/io_uring_unregister_eventfd.3 b/man/io_uring_unregister_eventfd.3
deleted file mode 120000
index 66599571..00000000
--- a/man/io_uring_unregister_eventfd.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_eventfd.3
\ No newline at end of file
diff --git a/man/io_uring_unregister_iowq_aff.3 b/man/io_uring_unregister_iowq_aff.3
deleted file mode 120000
index c29bd44e..00000000
--- a/man/io_uring_unregister_iowq_aff.3
+++ /dev/null
@@ -1 +0,0 @@
-io_uring_register_iowq_aff.3
\ No newline at end of file
-- 
2.54.0



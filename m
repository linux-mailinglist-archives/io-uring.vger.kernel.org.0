Return-Path: <io-uring+bounces-13728-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id x4qAEBcZMGoFNgUAu9opvQ
	(envelope-from <io-uring+bounces-13728-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 17:24:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEA9687A14
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 17:24:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=mHZEVal5;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13728-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13728-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B91831ED826
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 15:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F659402B8F;
	Mon, 15 Jun 2026 15:18:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90731402B89
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 15:18:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536706; cv=none; b=BdJfE0adudN7LyWd0W3dvCqF7c3S2aMOe9Q1YijNX6EcJ7b820JHDDmEOvvoAutRdwSt+Eh1rqdaSCXamO49KBj7VLsB6m0H1OHMM5+lwECj3UsvVpjnXt+0LQ0YudBZnQIwcd1RdAagLrt3GEWZcNnxUZwi4mW0b6nirt76jnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536706; c=relaxed/simple;
	bh=i0gpv6tVnkHZ66oADymRf0LV9vQSAWV8FGwh6rqS6XY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=kFdaLDLozOgiLZkaulE5i4of4oXxcXAuzVsfbXMN0DqlmHdkJawHyE1D4/fSC8ItyBEDAN46xT6KY9MxQ+Dle9MCLyby6DGtXCoCHqNNeUliRPAgFWAm6cCf2rd9Qt9MQYoqgg+qDy1a7gycw3dPgE7sS0vztw4lDWBT18Orxyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mHZEVal5; arc=none smtp.client-ip=209.85.161.53
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-69e4d51b15dso2479200eaf.2
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 08:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781536703; x=1782141503; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zjtLKzk83LlpUOhNawl+YOayzwkGt+AQx1gu3XndAM=;
        b=mHZEVal5CGgiYLr3ot323ZQjsUteLGIiQUvFcSIEUuFMyWpd3DNwpN5EzLJViNuWOE
         6tzFPkbpzpRFr3LlfG4DIJVJDDNZCs2rKuVpWzL5XYsgnueDKgj97pEBvaW5pWOxYGbu
         RDC1QSR4lNnfBvr9g9FlXQkhyEdGK5VtA1y+s1PBz+dOdwV999ks5s/370jraNiJNUxI
         eIKC8btS47InEzkF8LUoa86F+q7qr1NZobK0x3JEpTABrDst89fCYiz1ZzjERpLuafZT
         I4LRrrs2CEoMJbea4ObQXWX4E53pE2oEKnk462hQc8fGeCEFMH/Cq2PUXmaO+vwSYl50
         zigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781536703; x=1782141503;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2zjtLKzk83LlpUOhNawl+YOayzwkGt+AQx1gu3XndAM=;
        b=o7Of+l7e6zSckXiYFnQjGJhKovR2K7DpqqFVR0fWCQ7vkhnhwCalCwnVuRIKly7ayA
         WHFaA7nK3lnprZI44CTGvGzV6Emu0hIBlm7ZZyZ/yjE5KmZnuZALxGPqjhDO0mtoPaO5
         YcBod0DiqQdBMET5I6BjcY7kluYd4tGe+Mgu0TE/WI4N/3pjnuWnVrgsbOvags0sp4Kd
         q4oPS7qEpZzM13Vbwa+J8NwpzsixE2tVSNbmJqKGvCC+872rOD+f7CHr2YgWrg8NjTnF
         JuvFeed6vAQI06scOnev5l6NSegRY0GDg6SUxoBAY2Kv6oPP2c7c9GydVrDTNa1U2/6G
         JNTA==
X-Gm-Message-State: AOJu0YxM/5ngXRyOVAyq8wY4o8iXcwfiXFqb+hzxqBRWz5FljqJ19ekj
	RvVunF9TyIiwQ4bKgmKQ5i4tg4HD78WbDI/EdubE30jyTCpBym5cmyjUPFwHFhIiS/6ijnFxOfA
	k78Au2jk=
X-Gm-Gg: Acq92OEPVE4gKAuu9/Gyn70lvkKMDt11x4jToG2ShMORDQ1ae2ZDNDkNxPuOF9wZFwj
	Oz3hB/f8XQqGsDUty+EKbtgZ5rxoh+rIDQAHFUh8nMJnxYuW1dbWKhSqm9uYvPfRMHDnRt3IrWr
	I6zjKoSDn4YSt9bGFS/jdYq37U606BzcKL3XJ9VbUCJvgdEnMWUlBi9zhXp7ktvCsy5JeKd+BiT
	B+r6pIC2VbN+rVhkVOmM752zz6sdrq/6JAwfP53JHs1KW900EJ3T58NEUJjFXwv8EyQcBuZtvk/
	5VXiT0xClCT33hohfm71tM7p99z3xM27xlEgJwQCJDAZ2SFIBnkWkcmiAbqBaxGUszU9CbSfSSm
	rno45gF1dBfBwxlJrkxbDY7rcmiNy8lFzUm9dtXmgQwsJVlTSSZYymqrPMtzRy68RFHuHn5YXcZ
	QRvEx+Q/j7s519EN9YyRtxyCB9kAUT3qIONosKbtBKEt0yWZtJxrsLxt+RT/o/EPXq/yeQwq/O8
	L4RYfev
X-Received: by 2002:a05:6820:618:b0:696:1450:ff24 with SMTP id 006d021491bc7-69eec8e79e0mr6181249eaf.36.1781536703427;
        Mon, 15 Jun 2026 08:18:23 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69f00ed708esm3270354eaf.9.2026.06.15.08.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 08:18:22 -0700 (PDT)
Message-ID: <8829b16a-4247-4e07-aa35-c3a185780731@kernel.dk>
Date: Mon, 15 Jun 2026 09:18:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 7.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13728-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8CEA9687A14

Hi Linus,

Here are the core io_uring updates queued up for the 7.2 merge window.
This pull request contains:

- Rework of the task_work infrastructure. Both the local (DEFER_TASKRUN)
  and the normal (tctx) task_work lists were llist based, which is LIFO
  ordered, and hence each run had to do an O(n) list reversal pass first
  to restore queue order. Additionally, to cap the amount of task_work
  run, each method needed a retry list as well. Add a lockless MPCS
  FIFO queue (based on Dmitry Vyukov's intrusive MPSC algorithm) and
  switch both task_work lists to it. It performs better than llists and
  we can then also ditch the retry lists as well as entries are popped
  one-at-the-time. On top of those changes, run the tctx fallback
  task_work directly and remove the now-unused per-ctx fallback machinery
  entirely.

- zcrx user notifications. Add a mechanism for zcrx to communicate
  conditions back to userspace via a dedicated CQE, with the initial
  users being notification on running out of buffers and on a frag copy
  fallback, plus shared-memory notification statistics. Alongside that, a
  series of zcrx reliability and cleanup fixes: more reliable scrubbing,
  poisoning pointers on unregistration, dropping an extra ifq close,
  adding a ctx back-pointer, reordering fd allocation in the export path,
  and killing a dead 'sock' member.

- Allow using io_uring registered buffers for plain SEND and RECV, not
  just for the zero-copy send path. This enables targets like ublk's NBD
  backend to push/pull IO data directly to/from a registered buffer over
  a plain send/recv on a TCP socket.

- Registered buffer improvements: account huge pages correctly, bump the
  io_mapped_ubuf length field to size_t, and raise the previous 1GB
  registered buffer size limit.

- Restrict the ctx access exposed to io_uring BPF struct_ops programs by
  handing them an opaque type rather than the full io_ring_ctx, and add a
  separate MAINTAINERS entry for the bpf-ops code.

- Allow opcode filtering on IORING_OP_CONNECT.

- Validate ring-provided buffer addresses with access_ok(), and align the
  legacy buffer add limit with MAX_BIDS_PER_BGID.

- Various other cleanups and minor fixes, including avoiding msghdr async
  data on connect/bind, dropping async_size for OP_LISTEN, making the
  POLL_FIRST receive side checks consistent, re-checking IO_WQ_BIT_EXIT
  for each linked work item, and using trace_call__##name() at guarded
  tracepoint call sites.

Note that this will throw a merge conflict in io_uring/net.c due to late
changes on the 7.1 side. The merge resolution is fairly straight
forward, including it at the end of this email for reference.

Please pull!


The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/for-7.2/io_uring-20260615

for you to fetch changes up to d9b710f683dc68b5c0b7dd0c6c64aeb5d27a1ac4:

  io_uring/bpf-ops: add a separate maintainer entry (2026-06-13 06:36:16 -0600)

----------------------------------------------------------------
for-7.2/io_uring-20260615

----------------------------------------------------------------
Bertie Tryner (1):
      io_uring/zcrx: reorder fd allocation in zcrx_export()

Clément Léger (2):
      io_uring/zcrx: notify user on frag copy fallback
      io_uring/zcrx: add shared-memory notification statistics

Gabriel Krisman Bertazi (3):
      io_uring/net: Avoid msghdr on op_connect/op_bind async data
      io_uring/net: Remove async_size for OP_LISTEN
      io_uring/nop: Drop a wrong comment in struct io_nop

Jens Axboe (12):
      io_uring/rsrc: add huge page accounting for registered buffers
      io_uring/rsrc: bump struct io_mapped_ubuf length field to size_t
      io_uring/rsrc: raise registered buffer 1GB limit
      io_uring/kbuf: validate ring provided buffer addresses with access_ok()
      io_uring/zcrx: kill dead 'sock' member in struct io_zcrx_args
      io_uring: grab RCU read lock marking task run
      io_uring/mpscq: add lockless multi-producer, single-consumer FIFO queue
      io_uring: switch local task_work to a mpscq
      io_uring: switch normal task_work to a mpscq
      io_uring: run the tctx task_work fallback directly
      io_uring: remove the per-ctx fallback task_work machinery
      io_uring/net: make POLL_FIRST receive side checks consistent

Ming Lei (1):
      io_uring/net: support registered buffer for plain send and recv

Pavel Begunkov (7):
      io_uring/zcrx: make scrubbing more reliable
      io_uring/zcrx: poison pointers on unregistration
      io_uring/zcrx: remove extra ifq close
      io_uring/zcrx: add ctx pointer to zcrx
      io_uring/zcrx: notify user when out of buffers
      io_uring/bpf-ops: restrict ctx access to BPF
      io_uring/bpf-ops: add a separate maintainer entry

Runyu Xiao (1):
      io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item

Shouvik Kar (1):
      io_uring/net: allow filtering on IORING_OP_CONNECT

Vineeth Pillai (1):
      io_uring: Use trace_call__##name() at guarded tracepoint call sites

Yi Xie (1):
      io_uring: parenthesize io_ring_head_to_buf() expansion

liyouhong (1):
      io_uring/kbuf: align legacy buffer add limit with MAX_BIDS_PER_BGID

 MAINTAINERS                              |   8 +
 include/linux/io_uring_types.h           |  46 ++++-
 include/uapi/linux/io_uring/bpf_filter.h |  16 ++
 include/uapi/linux/io_uring/query.h      |  12 ++
 include/uapi/linux/io_uring/zcrx.h       |  36 +++-
 io_uring/bpf-ops.c                       |   9 +-
 io_uring/bpf-ops.h                       |   2 +-
 io_uring/cancel.c                        |   2 -
 io_uring/fdinfo.c                        |   2 +-
 io_uring/io-wq.c                         |   2 +-
 io_uring/io_uring.c                      |  14 +-
 io_uring/io_uring.h                      |   3 +-
 io_uring/kbuf.c                          |  18 +-
 io_uring/loop.c                          |   2 +-
 io_uring/loop.h                          |  10 +
 io_uring/mpscq.h                         | 125 ++++++++++++
 io_uring/net.c                           | 129 ++++++++++---
 io_uring/net.h                           |   7 +
 io_uring/nop.c                           |   1 -
 io_uring/opdef.c                         |   7 +-
 io_uring/query.c                         |  16 ++
 io_uring/rsrc.c                          | 269 ++++++++++++++++++++------
 io_uring/rsrc.h                          |   7 +-
 io_uring/sqpoll.c                        |  30 +--
 io_uring/tctx.c                          |   3 +-
 io_uring/tw.c                            | 315 ++++++++++++++-----------------
 io_uring/tw.h                            |  11 +-
 io_uring/wait.c                          |   2 +-
 io_uring/wait.h                          |  12 +-
 io_uring/zcrx.c                          | 229 +++++++++++++++++++---
 io_uring/zcrx.h                          |  11 +-
 31 files changed, 1000 insertions(+), 356 deletions(-)
 create mode 100644 io_uring/mpscq.h


commit fc98bae94161002f5f78081d55be8d4192ddadb2
Merge: 0e0611827f33 d9b710f683dc
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jun 15 08:15:04 2026 -0600

    Merge branch 'for-7.2/io_uring' into test
    
    * for-7.2/io_uring: (31 commits)
      io_uring/bpf-ops: add a separate maintainer entry
      io_uring/net: make POLL_FIRST receive side checks consistent
      io_uring: remove the per-ctx fallback task_work machinery
      io_uring: run the tctx task_work fallback directly
      io_uring: switch normal task_work to a mpscq
      io_uring: switch local task_work to a mpscq
      io_uring/mpscq: add lockless multi-producer, single-consumer FIFO queue
      io_uring: grab RCU read lock marking task run
      io_uring/zcrx: kill dead 'sock' member in struct io_zcrx_args
      io_uring/kbuf: validate ring provided buffer addresses with access_ok()
      io_uring/net: support registered buffer for plain send and recv
      io_uring/nop: Drop a wrong comment in struct io_nop
      io_uring/net: Remove async_size for OP_LISTEN
      io_uring/net: Avoid msghdr on op_connect/op_bind async data
      io_uring/bpf-ops: restrict ctx access to BPF
      io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
      io_uring/kbuf: align legacy buffer add limit with MAX_BIDS_PER_BGID
      io_uring/zcrx: add shared-memory notification statistics
      io_uring/zcrx: notify user on frag copy fallback
      io_uring/zcrx: notify user when out of buffers
      ...
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --cc io_uring/cancel.c
index 4aa3103ba9c3,b0259e74f678..8c6fa6f367e4
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@@ -561,12 -561,10 +561,10 @@@ __cold bool io_uring_try_cancel_request
  	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
  	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
  	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
 -	mutex_unlock(&ctx->uring_lock);
  	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
 +	mutex_unlock(&ctx->uring_lock);
  	if (tctx)
  		ret |= io_run_task_work() > 0;
- 	else
- 		ret |= flush_delayed_work(&ctx->fallback_work);
  	return ret;
  }
  
diff --cc io_uring/net.c
index ee848eb65ec9,7deb62e3b4c0..081d1b7d77c8
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@@ -1801,29 -1879,11 +1881,29 @@@ out
  	return IOU_COMPLETE;
  }
  
 +/*
 + * Check if bind request would potentially end up with filename_create(),
 + * which in turn end up in mnt_want_write() which will grab the fs
 + * percpu start write sem. This can trigger a lockdep warning.
 + */
- static int io_bind_file_create(const struct io_async_msghdr *io, int addr_len)
++static int io_bind_file_create(const struct sockaddr_storage *addr, int addr_len)
 +{
 +	const struct sockaddr_un *sun;
 +
- 	if (io->addr.ss_family != AF_UNIX)
++	if (addr->ss_family != AF_UNIX)
 +		return 0;
 +	if (addr_len <= offsetof(struct sockaddr_un, sun_path))
 +		return 0;
- 	sun = (const struct sockaddr_un *) &io->addr;
++	sun = (const struct sockaddr_un *) addr;
 +	return sun->sun_path[0] != '\0';
 +}
 +
  int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  {
  	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
  	struct sockaddr __user *uaddr;
- 	struct io_async_msghdr *io;
+ 	struct sockaddr_storage *addr;
 +	int ret;
  
  	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
  		return -EINVAL;
@@@ -1831,17 -1891,13 +1911,18 @@@
  	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
  	bind->addr_len =  READ_ONCE(sqe->addr2);
  
- 	io = io_msg_alloc_async(req);
- 	if (unlikely(!io))
+ 	addr = io_uring_alloc_async_data(NULL, req);
+ 	if (unlikely(!addr))
  		return -ENOMEM;
- 	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
 -	return move_addr_to_kernel(uaddr, bind->addr_len, addr);
++	ret = move_addr_to_kernel(uaddr, bind->addr_len, addr);
 +	if (unlikely(ret))
 +		return ret;
- 	if (io_bind_file_create(io, bind->addr_len))
++	if (io_bind_file_create(addr, bind->addr_len))
 +		req->flags |= REQ_F_FORCE_ASYNC;
 +	return 0;
  }
  
+ 
  int io_bind(struct io_kiocb *req, unsigned int issue_flags)
  {
  	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);

-- 
Jens Axboe



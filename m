Return-Path: <io-uring+bounces-12016-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPgDKX+4gGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12016-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:45:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05949CD8A0
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 378013053643
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 14:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E71828AB0B;
	Mon,  2 Feb 2026 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="eALF+VfP"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F211A76DE;
	Mon,  2 Feb 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043093; cv=pass; b=fDxUgBtABJ2dbvarL3iHPSpaPM19k6d4qcw80oPmgGOZFEYUNwFdTC9n3doodAXs3lRsHQfVtzPXFoufrywhgklPBDpj9Kwy2/r5GVsqxEdVd5fOdEcwnuCQ3xTc3pwHkdAbIsPp5EwinUlpZHIP4fmkYLbkSt++S3VAO5fQSGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043093; c=relaxed/simple;
	bh=okEXM9/shBShOr5ACg362CBiqe/WpUCIhhUbGaZhH0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVzwkAZFKS2404JWeoXZ+3eexzUa46zJKqPJI0EhBDnP+23m5HsYmURLMwgTeNUqlU8LrWQj+7qG1U0eDvghc4GBncukxHE/289Z/CWVa2c3zD4u8Qogs3YcemWTsdMw3CNH+KUD/NgyMs5bRk9Nwd/O7eSbWSUQykBpbxR33sY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=eALF+VfP; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770043085; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OdvGrwgHYtRvzlsC1TuaNyPBsZJWzmvScFFyUSXX+g8XxDcv1hoHESiwKjNPi6mL016Y8Qj/omKdi6gPjRQ+m9yNAGueTmaeUWHQGmdm8cBHncrot1iaafYe3drn+1vJXBeXQc/Db6GIM/cAYlgp87vxXXxaq+Z2LqYeU/r8Roo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770043085; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7Rz7J3aH+YO5uJw0T7QKeUx2LLfB/laDQma/k4m+Nkk=; 
	b=ZtmysD+fp2ys5gVGT9bxYIJdFqZNuJ4iFFzyR5NV2V+5jT/qWAxOTloxcBJeTrb08g/13nr+bWtzi9euB2rAnQCYwF3uxm2Wa8cIOSGVmnjdgDV/jS/fDfGpD1nGr0iz9GKWCvFoDP48/gRyjoGYc0/hFYmQUp+x2P+20vM4k5c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770043085;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7Rz7J3aH+YO5uJw0T7QKeUx2LLfB/laDQma/k4m+Nkk=;
	b=eALF+VfP2XnI2gVfxSyDAq/Vog/ER8uVlMpixT3y7tPoiqP6rtJ3oR5kpOa2LQNF
	xQRbwDzFlzl/QKVHnsa7xv3OTb6jzk4LPxTAq18oOSdxEB5+KEuXUOKBvLeVjlEeZT/
	S06SL0Fn1yapJV7bJx/2Zug9g4qTMZthB4J+AGxg=
Received: by mx.zohomail.com with SMTPS id 1770043082947655.3596413706094;
	Mon, 2 Feb 2026 06:38:02 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] io_uring/io-wq: let workers exit when unused
Date: Mon,  2 Feb 2026 22:37:52 +0800
Message-ID: <20260202143755.789114-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12016-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[linux.beauty];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.beauty:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:mid,linux.beauty:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05949CD8A0
X-Rspamd-Action: no action

io_uring uses io-wq to offload regular file I/O. When that happens, the kernel
creates per-task iou-wrk-<tgid> workers (PF_IO_WORKER) via create_io_thread(),
so the worker is part of the process thread group and shows up under
/proc/<pid>/task/.

io-wq shrinks the pool on idle, but it intentionally keeps the last worker
around indefinitely as a keepalive to avoid churn. Combined with io_uring's
per-task context lifetime (tctx stays attached to the task until exit), a
process may permanently retain an idle iou-wrk thread even after it has closed
its last io_uring instance and has no active rings.

The keepalive behavior is a reasonable default(I guess): workloads may have
bursty I/O patterns, and always tearing down the last worker would add thread
churn and latency. Creating io-wq workers goes through create_io_thread()
(copy_process), which is not cheap to do repeatedly.

However, CRIU currently doesn't cope well with such workers being part of the
checkpointed thread group. The iou-wrk thread is a kernel-managed worker
(PF_IO_WORKER) running io_wq_worker() on a kernel stack, rather than a normal
userspace thread executing application code. In our setup, if the iou-wrk
thread remains present after quiescing and closing the last io_uring instance,
criu dump may hang while trying to stop and dump the thread group.

Besides the resource overhead and surprising userspace-visible threads, this is
a problem for checkpoint/restore. CRIU needs to freeze and dump all threads in
the thread group. With a lingering iou-wrk thread, we observed criu dump can
hang even after the ring has been quiesced and the io_uring fd closed, e.g.:

  criu dump -t $PID -D images -o dump.log -v4 --shell-job
  ps -T -p $PID -o pid,tid,comm | grep iou-wrk

This series is a kernel-side enabler for checkpoint/restore in the current
reality where userspace needs to quiesce and close io_uring rings before dump.
It is not trying to make io_uring rings checkpointable, nor does it change what
CRIU can or cannot restore (e.g. in-flight SQEs/CQEs, SQPOLL, SQE128/CQE32,
registered resources). Even with userspace gaining limited io_uring support,
this series only targets the specific "no active io_uring contexts left, but an
idle iou-wrk keepalive thread remains" case.

This series adds an explicit exit-on-idle mode to io-wq, and toggles it from
io_uring task context when the task has no active io_uring contexts
(xa_empty(&tctx->xa)). The mode is cleared on subsequent io_uring usage, so the
default behavior for active io_uring users is unchanged.

Tested on x86_64 with CRIU 4.2.
With this series applied, after closing the ring iou-wrk exited within ~200ms
and criu dump completed.

Li Chen (2):
  io-wq: add exit-on-idle mode
  io_uring: allow io-wq workers to exit when unused

 io_uring/io-wq.c | 31 +++++++++++++++++++++++++++++++
 io_uring/io-wq.h |  1 +
 io_uring/tctx.c  | 11 +++++++++++
 3 files changed, 43 insertions(+)

-- 
2.52.0


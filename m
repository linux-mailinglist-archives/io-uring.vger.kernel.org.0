Return-Path: <io-uring+bounces-13263-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SZLlFLpEAGqIFgEAu9opvQ
	(envelope-from <io-uring+bounces-13263-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 10:41:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D91BA503206
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 10:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 962BD3002328
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 08:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425CC36B048;
	Sun, 10 May 2026 08:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DB8NwlZP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB08435DA78
	for <io-uring@vger.kernel.org>; Sun, 10 May 2026 08:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778402487; cv=none; b=keWfO1pLuD9sJxmH3VgLo/4k9Exkio+UpK/ViW0tOslSy7CwAKKZ9K5Tz/S8KkM15csJAu9oao39hcwpUb8L8oRWTU7DtBl9QQfhiQJvArGryfosM4kE4YMwegxJN8zFnldlLCZEBGvsNYUmRaC0fYr0U+7WJKzoGRXHFiVEOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778402487; c=relaxed/simple;
	bh=nQQl8Jnr5xiENoRq9UPFaatHarty14EnHftN3n0JTkg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VgkVEsYVAHNS7gkj6zNf2vBBoLLHnRvAK4OzrnUQjAKVoSy8m4xJ+6wB6asv1M5LlKBNZ0DePd8vIgBGK0G0fbkZmFM6qhccxaDw+TW4C4P7pfj0D3IheEBC1HKQaRl5Q4LTWlXz9w9H3pjkxktPGWHhp2S2kfxIzcysROi5M64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DB8NwlZP; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so30761135ad.3
        for <io-uring@vger.kernel.org>; Sun, 10 May 2026 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778402484; x=1779007284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b2J10JjtJjjqUTKbHQ1pnc+iGy3TkAKh2yT2vpmiKao=;
        b=DB8NwlZP4xxA2aP6Mns18XzH5EQvY23LgD/yReKwDmhI2FvWHfHvQBIpk6zv5R7Fj8
         S88j9KK3PaZe05Bi1zScwE9AEPlQCHpbIdv3aUeT0PvKDSrO2dl3FVWYc4IjF7up91TQ
         SvG9CEZWTeo9dLx/Xs20/mOOyL2zDOFgMNamBg99qy9DD3glNXC1+9vgMUNIhBeSZh+F
         Qft94iW1o1t0KFFvT70lMN3a9MGYsxz9DNpJyUu1jPZKf8vf6rqRIMQo9eafouSJqx3y
         p8ua+6/KQle/5uxoqjLDJyRNOO3nCFBa50dDmlL4LRGITBolbc3yDwmPp8cp+0zaXZAR
         fEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778402484; x=1779007284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2J10JjtJjjqUTKbHQ1pnc+iGy3TkAKh2yT2vpmiKao=;
        b=gYnpdD001EshjLccAmXzfxrInFITHQ1ZxLOd/CPITocJIL1Ahegdl9CiHhf7QB5BBe
         kJ/i3mFCFQGYyW2bYLOZ4IuUJv6W+8nA9pPjnRo1gEpXNvAJLpyBoOrJHtK2biOa93du
         ycouNX0KzxQQQIw71pIwd65Zus5WTCnxk2ZlrC/Up5aqvvtOad8neql2S8ZmxfNrFfIC
         cMz7zoyKoWyqzxYqekVJPKZkAHokkbzg1f5LxS16qHVHJZygTYF8ZXrGHIOD6sEHGl/M
         HTp/kPZAGtHm8eqrFDGJaF13720sXavmfwENqFAQ131XrelNFgcWn5EzUvz90zWezg+1
         AFnA==
X-Forwarded-Encrypted: i=1; AFNElJ/jLhZSMVRf/QXFBw/weF/7E3329DY876043/Opp2ewGOjxxMM8jW7jeJLKl76CeQax+nR4RsvpMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxZlMidPCXqaibIJj55isByoRV1Vxss02cDgExbcOoph9yxohb
	Dv9yMtmAFIExfH09KFi3IDXjb6uGmfORgPldXBDQ9lM7H0wPss+HIR/a
X-Gm-Gg: Acq92OEOOOzUnHtYo0niuxtMx32PDb9yYuXrey1byiq1gnUmRk70EFGD2bRKdAjKjre
	7XiSrdk2Sp6+2rBy64alMQ/EfMVtvdCG09RHI6xQsKzHDcJBOufWZi+y58eFzgabPmySHrZpbJr
	B6YASDV0tgRmzOX8brvCKXAVUrzht53blEOAA8diQU66PaS6P1jWWYHg8cmecwSwxqTeuYuUle5
	eUR/d9sfD2h1U7UryDQY8xsz96qWJ4fKw3omDIJzjJp1Y9WT4zPvj1y0ZlySFKy2f7c9rmAj1Ip
	UxPKBjBdl7+5MqcsFXXlRtfJZRGziBvc7i+kFnCIKjyWSiNaAksr7hWX08d06BsdkGztgtOdAZI
	II7kndvLKq6Ipgd8+h8WGPmD91ymmp7Syzj8ilr9bCnghqd3mRnH5N8vA5nUzDBQwhGyI0iyhIR
	BOPUBS7nQT+5sJx76W8dDZstEsr+r5xt8AiKsr+1nGx1Pe4oDsuoYtb4WuDQ9gIxAgchk=
X-Received: by 2002:a17:903:4b03:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2ba79d2e589mr195925275ad.34.1778402483988;
        Sun, 10 May 2026 01:41:23 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d52ef9sm69952575ad.35.2026.05.10.01.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 01:41:23 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
X-Google-Original-From: Maoyi Xie <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>
Subject: [PATCH] io_uring/fdinfo: translate SqThread PID through caller's pid_ns
Date: Sun, 10 May 2026 16:41:19 +0800
Message-Id: <20260510084119.457578-1-maoyi.xie@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D91BA503206
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-13263-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.978];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,ntu.edu.sg:email,ntu.edu.sg:mid]
X-Rspamd-Action: no action

SQPOLL stores current->pid (init_pid_ns view) in sqd->task_pid
at thread creation. fdinfo prints it raw via
seq_printf("SqThread:\t%d\n", sq_pid). A reader inside a
non-initial pid_ns sees the host PID, not the kthread's PID in
the reader's own pid_ns.

The SQPOLL kthread is created with CLONE_THREAD and no
CLONE_NEW*, so it lives in the submitter's pid_ns. An
unprivileged user_ns + pid_ns submitter can read fdinfo and
learn the host PID of a kthread whose in-namespace PID is
different.

Reproducer (mainline 7.0, KASAN): unshare CLONE_NEWUSER |
CLONE_NEWPID | CLONE_NEWNS, mount a private /proc, then have a
grandchild that is pid 1 in the new pid_ns open an io_uring
ring with IORING_SETUP_SQPOLL. /proc/self/task lists {1, 2};
the SQPOLL kthread is pid 2. Before: fdinfo prints
SqThread = <host pid>. After: SqThread = 2.

Use task_pid_nr_ns() against the proc inode's pid_ns to compute
sq_pid, instead of reading the stored sq->task_pid (which holds
the init_pid_ns view). pidfd_show_fdinfo() in kernel/pid.c
follows the same pattern.

Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
---
 io_uring/fdinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index c2d3e4554..05ce477d3 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -190,8 +190,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			get_task_struct(tsk);
 			rcu_read_unlock();
 			usec = io_sq_cpu_usec(tsk);
+			sq_pid = task_pid_nr_ns(tsk,
+						proc_pid_ns(file_inode(m->file)->i_sb));
 			put_task_struct(tsk);
-			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
 			sq_total_time = usec;
 			sq_work_time = sq->work_time;
-- 
2.34.1



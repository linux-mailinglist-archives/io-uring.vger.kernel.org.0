Return-Path: <io-uring+bounces-7302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EE6A75728
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 17:16:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B10A188DA90
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 16:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A693987D;
	Sat, 29 Mar 2025 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Mp83ASOX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28858821
	for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743264970; cv=none; b=NPM+r9lKqb7hta6JStef/BIsce2anuGauk54WLXU19h7qqLSP793FMRqoFVE1tc47mKdWLcULwkGjp3kDqnqM/90VKNxngbe83ZGkXqDGEXT/v+agvpZ6HY4hYcj1ViS5yexQAk5+CmOo/9fnbm75lv665EUh8O1OUO6tGRtq4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743264970; c=relaxed/simple;
	bh=JryjqFs4vZibpVGCM4sa10aaOgZQLlHF7K8i8gZ9Yrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VMnXEQD4GonXhEMjA4XCAlSFVKkTawsP6oNKB4lfX6tDyTRKN43mwHNeu0m2ZJ9wYjOTSrpaNOSQo1WAa7zBh5AK8L8AgK5JikBN5Ev+JPtT5G2Hl3AUswvmvEMcF3XDhGTLZqZrqoXhC938Rb7xWu7jb+fZfhV0vQVVrN/sAIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Mp83ASOX; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-227e29b6c55so9162925ad.1
        for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 09:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743264968; x=1743869768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mewZW+MhqIiDJdg0gacut2Km63vtyiQRW4anmwKETlc=;
        b=Mp83ASOX8IHLFOUQ6gbwvPPWbH3o/zP61m1t70/i8ET8O0oPdphM0T6AU0jN1lw2py
         njFdhXVYCnv2HI9Lf8XdnwdmMhNOTDGs2ksu/O7FrIEjlM6swtuzIwimeMfcCOuuPsSL
         /mWaipOUnB9JfeNv/H2bs2obj9lPVbVwkw4iKV0sgZWfy2jxgqxrs8A4mrShDX4RtxBA
         dcciMyXMWIN3jsjXYxL63yZ0pQhffcWfL9pq5TwCEUMcFTUjPRGmyGkQUuwpWTijgoij
         JBvf7ioJG+q2KKXWbmu3IxdRqbbq9TKZANgr7Vpk7DhcvB4lhXqMYPrRA9DqP/gHyofg
         m4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743264968; x=1743869768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mewZW+MhqIiDJdg0gacut2Km63vtyiQRW4anmwKETlc=;
        b=JRjbQSZ9YbLvb3Bb/e1eOthvyViZXNdMlAya2Ie8Sh62zSdz7espp2PBTJ/J+uZjVM
         RDd0mW8052WqT/Ncn1sc1aKLOoYtaeL47PrB7/rxT8SmZLKCJJbcsyRTLhGK98NrjJ54
         bRNGkEkr1wg5kN6FeIH2uf6CYKrDvlJRdTvmqe9e7o+/WD1Nmo150u0THId2T5kpkI/Q
         jrCjAdmvxIgmZXQjb1UNXt/XOVYj3US8fOYeTdBJR6s7VF0ZzBT3UxaPWLqA86JL5x6r
         pNTvcu+fVP5ez+ece+x7wgqxI13rWCD8pPKZ7GSwXEuLLIbMZ9neMMaIJxcmQNbUfGu0
         psdg==
X-Forwarded-Encrypted: i=1; AJvYcCXlENY6wMjpB3CNvIDYMixLgUCIKyjHDL6cc4OxtX60BgAN0Zx+7WOg5VQ1KceYntiZ5L58Nh9kAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzI6MIQaysuUdNQYpyxXmKH1peikJZglY5+ng4TIKws1bahvenp
	LCjnztTgf+wVU4eH8i3izXMa8aPjWnEZvOmfQkIeFHlEviYuVu1nftHq38BS/IiQ4SgVAs9bi9f
	YqnZDBq7eqQ6TCIpruxscZB+br8wdN6BjVpHg8l21IkdvFBG5
X-Gm-Gg: ASbGnctpC2ZVIeMJ3QShJDf38WsYu7JtnDOGDZZJ3D4vVbRSzIRjjJKFGLyb1TeDKNm
	1dpHhBrSO0kzlySgSVOZ9okOf6gEUkZXUwnuSSlpZxva16iqpyq+PbwGZc+qSQtjo1+BkYmohNm
	NiYDDyzjXFk2ONuUUvkQrdrZYFNZB8PW5JPKQ8n040dQC8dpaw+YZrNuPiZZ44kjcJFC0iYLKXa
	1x3q2/LLoVSRlnCO3NogUu16bqJyEE1VXKMF0wyHjA9DXpLlTtd8N5beCl1cznwK8YjRuHEurWO
	L3dmGcdcP9QHg7UsHY61IfFDhORmVpp2AQ==
X-Google-Smtp-Source: AGHT+IHY7lxeNvUJQr9zrW4f2UbUqXgr3Si/nl43FACLcp5pjVxKR/RkDQZNnecVVayqIk5cPS9U30CnMFRx
X-Received: by 2002:a05:6a00:2350:b0:737:6589:81e5 with SMTP id d2e1a72fcca58-7398032c9b1mr1990437b3a.2.1743264967832;
        Sat, 29 Mar 2025 09:16:07 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-73971090ab8sm368317b3a.17.2025.03.29.09.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 09:16:07 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 1EC273401D3;
	Sat, 29 Mar 2025 10:16:07 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 10E79E410B7; Sat, 29 Mar 2025 10:15:37 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/wq: avoid indirect do_work/free_work calls
Date: Sat, 29 Mar 2025 10:15:24 -0600
Message-ID: <20250329161527.3281314-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct io_wq stores do_work and free_work function pointers which are
called on each work item. But these function pointers are always set to
io_wq_submit_work and io_wq_free_work, respectively. So remove these
function pointers and just call the functions directly.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io-wq.c    | 15 ++++-----------
 io_uring/io-wq.h    |  5 -----
 io_uring/io_uring.c |  2 +-
 io_uring/tctx.c     |  2 --
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 04a75d666195..d52069b1177b 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -112,13 +112,10 @@ enum {
  * Per io_wq state
   */
 struct io_wq {
 	unsigned long state;
 
-	free_work_fn *free_work;
-	io_wq_work_fn *do_work;
-
 	struct io_wq_hash *hash;
 
 	atomic_t worker_refs;
 	struct completion worker_done;
 
@@ -610,14 +607,14 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			next_hashed = wq_next_work(work);
 
 			if (do_kill &&
 			    (work_flags & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
-			wq->do_work(work);
+			io_wq_submit_work(work);
 			io_assign_current_work(worker, NULL);
 
-			linked = wq->free_work(work);
+			linked = io_wq_free_work(work);
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
 				linked = NULL;
 			}
@@ -932,12 +929,12 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
 		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
-		wq->do_work(work);
-		work = wq->free_work(work);
+		io_wq_submit_work(work);
+		work = io_wq_free_work(work);
 	} while (work);
 }
 
 static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct,
 			      struct io_wq_work *work, unsigned int work_flags)
@@ -1193,23 +1190,19 @@ static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret, i;
 	struct io_wq *wq;
 
-	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON_ONCE(!bounded))
 		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(sizeof(struct io_wq), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
 
 	refcount_inc(&data->hash->refs);
 	wq->hash = data->hash;
-	wq->free_work = data->free_work;
-	wq->do_work = data->do_work;
 
 	ret = -ENOMEM;
 
 	if (!alloc_cpumask_var(&wq->cpu_mask, GFP_KERNEL))
 		goto err;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index d4fb2940e435..774abab54732 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -19,13 +19,10 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_OK,	/* cancelled before started */
 	IO_WQ_CANCEL_RUNNING,	/* found, running, and attempted cancelled */
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
-typedef void (io_wq_work_fn)(struct io_wq_work *);
-
 struct io_wq_hash {
 	refcount_t refs;
 	unsigned long map;
 	struct wait_queue_head wait;
 };
@@ -37,12 +34,10 @@ static inline void io_wq_put_hash(struct io_wq_hash *hash)
 }
 
 struct io_wq_data {
 	struct io_wq_hash *hash;
 	struct task_struct *task;
-	io_wq_work_fn *do_work;
-	free_work_fn *free_work;
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e4484a03e033..1d8d1b0e92f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1808,11 +1808,11 @@ void io_wq_submit_work(struct io_wq_work *work)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
-	/* one will be dropped by ->io_wq_free_work() after returning to io-wq */
+	/* one will be dropped by io_wq_free_work() after returning to io-wq */
 	if (!(req->flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
 		req_ref_get(req);
 
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index adc6e42c14df..5b66755579c0 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -33,12 +33,10 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	}
 	mutex_unlock(&ctx->uring_lock);
 
 	data.hash = hash;
 	data.task = task;
-	data.free_work = io_wq_free_work;
-	data.do_work = io_wq_submit_work;
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
 
 	return io_wq_create(concurrency, &data);
-- 
2.45.2



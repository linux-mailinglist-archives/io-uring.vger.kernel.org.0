Return-Path: <io-uring+bounces-6153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECCFA20B64
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E92D3A6DF0
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AFA1ACEB7;
	Tue, 28 Jan 2025 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="eRTpXbZo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857261A9B2A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071583; cv=none; b=N0YbjWGcYigTn4GH9dygE/PT9fbYlDrQRZ53gkr4n7DPPE90IgS4IIkLIr1VCbEus+ojC0fSW8P/whrARK/hQXy1egZL+/BBVpgaTPvcmovGiICnjVmJrChTwF7JoJceTj9rBSSfQES14aQKpsN7CGHbSp3C8TZIPWcbEMhA8wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071583; c=relaxed/simple;
	bh=nxpfJ3wB5nCck0yc+TIyGkKA+HJxeVDU44WyMwYM6D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thnTVqwX5yQ4ZDTj9PxP5ppO7QBf/gq7j1uLNMAzpe/j2Rodwre/oiXmuuHJIDlxDaLwfsLoMfAtE8UFpdwRlOYkEQgE9k8T9TUWYyIiTCjQ/+85ZMlD7lmuluMREpAQH4CzG9lCpOqhw/xQWqWPkLoOEdNDxxM1v/vPdlyG98k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=eRTpXbZo; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38637614567so2743724f8f.3
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071580; x=1738676380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0Sb1zzl9lHTXysx3Zj4dezvRrbNaG/3CIED1Ppo3HQ=;
        b=eRTpXbZo0q2KH4RaOi4L4vOHpN94ehAMpw7bXAForil75RQdh3FDWOZRpEZ/KHC2ky
         Cg5JSf1drvBFLgUjjMwU2ignlHkaXDN5x2i7gldGGML6v3YaGU/nS8EOrngNECxgEqQ6
         lNbdXH8/rmV2m7HDcj1DpXEjVqaQ1c3K6sKYVbPr2WEUZK99lPEjorFme5aG5/FU3UpV
         tABRum2vIikFLNjIsToRoUIzn3c4+ABiOVF6hXIceIDipyyQ6qf7nsXH2WLHwR7NYT6Q
         vGLhgyBVBBMD9sc9A2qjDaQlQfDEmjgJvmh6rpJJeL9EktYw+XU0aJdSaD6vcb8cJApM
         ixtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071580; x=1738676380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0Sb1zzl9lHTXysx3Zj4dezvRrbNaG/3CIED1Ppo3HQ=;
        b=NU9UwbSn/JkrN1UTYDcaYkHLjjsjsmECk+zENseE45OGx84Ub6HKL3FX9ApBQLR0As
         wAVRol8sknyioU0IVKyWHeAVu9ZP5QUrrlAx1BXLrEirOkx/n+58UP+qmRGggl5LBRY6
         TKLw6rQoPqOPXR4hERJnQ/QRCOZijrozt2ng0Zj85MEqq5G5eN2U0nYFVsX2ItX3jreI
         mLe0S70Bxesdxsv6Ciq3k5aArQXHPQ5mUYySOrHu4urc2yL4y3s7eYNZJnev/FlJ1L7d
         kmGW8tCrqqK2jDgxxtxo0DTWSudPSs1izffRjZRw/2uJKwhz4yi/V8JebgD1DN86uUC8
         C/FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz6iPLQ63CgQia+QF/8rHcuRYLO2forgG6Xtlb/Rj8Syu3rBDoRyH93APcg9n8KuNm7BwlHMFLVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw40auSDnwwjwPamytzlK4XnSqS4YaoWYMuPKl2Gx5xNMFw+Cd6
	bCSGLJh/KOB1pswEpmbUrPPX0j0xdxeDPqe8uuXJrPSDI1QNOoGGQQ/xc9NR4p7+qOgep49Mfis
	V2A4=
X-Gm-Gg: ASbGncuQaoN1M/DtG8gxWhrJCpK017pxvqF3N5rU71xBxCrFrifX7XyIBUw9J7a2cHN
	qj2hLST17UtKFS7dVi0EVXEolblFsvcjP+KWLN2yV+aDJmDo7s4kQNk3bnyViGWo8177rIRMaja
	oBjnsM8V3OK/NdrbzEKlrQSIEw5qrXdAyjmX5crZMWAROjHF2/0/Wb7HQBAZYD2LuChjus9V2Z8
	NLiOvhY+eaIrpxDxSbqdg4M49Xw+hsue053WqUmiH12fXv0WSOtrqVhseSitqauJ4CnychcsT+X
	UXoHgPHdA621UgXsg1VRPGcx//ZRmdGlR4LuvVattHGRRKBg++q01lSKrx5s2ifpxNx1/1pqUzq
	TSq3Ndjz+DMTBXNQ=
X-Google-Smtp-Source: AGHT+IGcdEBNubL7sukg4uu3ewHXC+3+vOT/IFRpwXZUOGiTZ50OLbhjM/qTzmALbuEz5d8UD8/mSw==
X-Received: by 2002:a05:6000:18a9:b0:38a:86fe:52dc with SMTP id ffacd0b85a97d-38c3b0cbb61mr9338899f8f.13.1738071579794;
        Tue, 28 Jan 2025 05:39:39 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:38 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
Date: Tue, 28 Jan 2025 14:39:23 +0100
Message-ID: <20250128133927.3989681-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This eliminates several redundant atomic reads and therefore reduces
the duration the surrounding spinlocks are held.

In several io_uring benchmarks, this reduced the CPU time spent in
queued_spin_lock_slowpath() considerably:

io_uring benchmark with a flood of `IORING_OP_NOP` and `IOSQE_ASYNC`:

    38.86%     -1.49%  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
     6.75%     +0.36%  [kernel.kallsyms]  [k] io_worker_handle_work
     2.60%     +0.19%  [kernel.kallsyms]  [k] io_nop
     3.92%     +0.18%  [kernel.kallsyms]  [k] io_req_task_complete
     6.34%     -0.18%  [kernel.kallsyms]  [k] io_wq_submit_work

HTTP server, static file:

    42.79%     -2.77%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     2.08%     +0.23%  [kernel.kallsyms]     [k] io_wq_submit_work
     1.19%     +0.20%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
     1.46%     +0.15%  [kernel.kallsyms]     [k] ep_poll_callback
     1.80%     +0.15%  [kernel.kallsyms]     [k] io_worker_handle_work

HTTP server, PHP:

    35.03%     -1.80%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     0.84%     +0.21%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
     1.39%     +0.12%  [kernel.kallsyms]     [k] _copy_to_iter
     0.21%     +0.10%  [kernel.kallsyms]     [k] update_sd_lb_stats

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 33 +++++++++++++++++++++------------
 io_uring/io-wq.h |  7 ++++++-
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index dfdd45ebe4bb..ba9974e6f521 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -170,9 +170,9 @@ static inline struct io_wq_acct *io_get_acct(struct io_wq *wq, bool bound)
 }
 
 static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
-						  struct io_wq_work *work)
+						  unsigned int work_flags)
 {
-	return io_get_acct(wq, !(atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wq, !(work_flags & IO_WQ_WORK_UNBOUND));
 }
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
@@ -457,9 +457,14 @@ static void __io_worker_idle(struct io_wq_acct *acct, struct io_worker *worker)
 	}
 }
 
+static inline unsigned int __io_get_work_hash(unsigned int work_flags)
+{
+	return work_flags >> IO_WQ_HASH_SHIFT;
+}
+
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 {
-	return atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT;
+	return __io_get_work_hash(atomic_read(&work->flags));
 }
 
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
@@ -489,17 +494,19 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 	struct io_wq *wq = worker->wq;
 
 	wq_list_for_each(node, prev, &acct->work_list) {
+		unsigned int work_flags;
 		unsigned int hash;
 
 		work = container_of(node, struct io_wq_work, list);
 
 		/* not hashed, can run anytime */
-		if (!io_wq_is_hashed(work)) {
+		work_flags = atomic_read(&work->flags);
+		if (!__io_wq_is_hashed(work_flags)) {
 			wq_list_del(&acct->work_list, node, prev);
 			return work;
 		}
 
-		hash = io_get_work_hash(work);
+		hash = __io_get_work_hash(work_flags);
 		/* all items with this hash lie in [work, tail] */
 		tail = wq->hash_tail[hash];
 
@@ -596,12 +603,13 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		/* handle a whole dependent link */
 		do {
 			struct io_wq_work *next_hashed, *linked;
-			unsigned int hash = io_get_work_hash(work);
+			unsigned int work_flags = atomic_read(&work->flags);
+			unsigned int hash = __io_get_work_hash(work_flags);
 
 			next_hashed = wq_next_work(work);
 
 			if (do_kill &&
-			    (atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND))
+			    (work_flags & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
@@ -917,18 +925,19 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 	} while (work);
 }
 
-static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct, struct io_wq_work *work)
+static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct,
+			      struct io_wq_work *work, unsigned int work_flags)
 {
 	unsigned int hash;
 	struct io_wq_work *tail;
 
-	if (!io_wq_is_hashed(work)) {
+	if (!__io_wq_is_hashed(work_flags)) {
 append:
 		wq_list_add_tail(&work->list, &acct->work_list);
 		return;
 	}
 
-	hash = io_get_work_hash(work);
+	hash = __io_get_work_hash(work_flags);
 	tail = wq->hash_tail[hash];
 	wq->hash_tail[hash] = work;
 	if (!tail)
@@ -944,8 +953,8 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int work_flags = atomic_read(&work->flags);
+	struct io_wq_acct *acct = io_work_get_acct(wq, work_flags);
 	struct io_cb_cancel_data match = {
 		.fn		= io_wq_work_match_item,
 		.data		= work,
@@ -964,7 +973,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	}
 
 	raw_spin_lock(&acct->lock);
-	io_wq_insert_work(wq, acct, work);
+	io_wq_insert_work(wq, acct, work, work_flags);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b3b004a7b625..d4fb2940e435 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -54,9 +54,14 @@ int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 bool io_wq_worker_stopped(void);
 
+static inline bool __io_wq_is_hashed(unsigned int work_flags)
+{
+	return work_flags & IO_WQ_WORK_HASHED;
+}
+
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
-	return atomic_read(&work->flags) & IO_WQ_WORK_HASHED;
+	return __io_wq_is_hashed(atomic_read(&work->flags));
 }
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
-- 
2.45.2



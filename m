Return-Path: <io-uring+bounces-13745-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id PPIvJ6s/MWphfQUAu9opvQ
	(envelope-from <io-uring+bounces-13745-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:20:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 050CB68F405
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 14:20:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=f9cX32F1;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13745-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13745-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0E3E7301944B
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 12:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0B62F745E;
	Tue, 16 Jun 2026 12:20:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6B343D85
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 12:20:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612457; cv=none; b=EK/GwKVenUq5ujtwwtqdl63RudTdSaMYYlZCeFqnwGaoFFfD2lQLE4Yl15WUzd2gatqHVCdQQtWuLU2LHCZWe0d/wJUcQHBfFCEIGBnUbE7lJ3d8DunBOWtJM2V7UsIvtFO2+LP2RKAbV6x2ohkOdKyyMslttDFnIWGbOb6CCBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612457; c=relaxed/simple;
	bh=1EpjjkvMp1G9qUro5mQrZT5mPoVPjpHYlptCNiCr+kA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ue+bfOYlgJqqIBQH6XZfMi3E6wlo/rZwSDzC7eD+/tVmD8uEKUZb80/ZNaEI9YnmE43KocwL28Emq2AA6V3cwaxh2SGeH5to2G2EOQ01WqhH+vTwmX8bUIuh6EuuDszB3OCENO87SzpHd4hTwr7FNeD8EPdOenu8Y5ElS7uDLBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=f9cX32F1; arc=none smtp.client-ip=209.85.210.44
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6128bd9b3so2543481a34.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 05:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781612453; x=1782217253; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAqpXVZTK3Lrr5ZtFF+3sT3HQADC523GnskyBMSTmuU=;
        b=f9cX32F1lDxZfcCtf+4XoYLPvd2rhGiHmeRcS5QiQEayVHS3E437zY9VzhvzgpFdIU
         e91tIHoPNiMHLkZeD+qGuGkJ+TaplY/85CGTnaCvpxAaUFodtMLO+4FJ2zPBjWjY3L0j
         yRytVV/S7UQiytCLlWnUTkAyxCl5rldvdEA68B/kZyPgpyuZAUoSiNMJD2Y2zD/tcb5n
         OqLazg8pAJMcjlT2DJNYjhtyzMb439+aXSwGfybyy5QxsP+/HcuFKl7IL7Gj8qA424FZ
         gDI5GpSxUDF7bMBNX2+ictpH65OCShTmlfzpz1sUrbpBcWjiS2qm+mgntCF5XR6POVrm
         O0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612453; x=1782217253;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AAqpXVZTK3Lrr5ZtFF+3sT3HQADC523GnskyBMSTmuU=;
        b=kjPbRWTYIr4fsoKTnP6xnt4RjfVEt58EI4tZKiNtnPjTBwPXCuTwqXD3HL2jXKQ6rS
         cMmv0ha/uAK0BRMnNI8E+IjGOdhtEG+Zo8aBveEk3cVxWLfFcsWB7olCA7EoYGQdWlz3
         pwiyj7e061auBzvBQ3692NvfGfE7qxFDpRgDL5QCoZX4Qa+pqmvX7ErUM2RcXBIHZf8m
         qMxKGpM2LxYL5xgFaE9OyKhtp2OnxdeV0Y1QoVEq9xAVbH/cu+Yc/f8rAW3fb5SgSVvI
         MbliB6lroOWzHjgqQRHeC3cHOacOFcFOA48s1m0aiDTay7EynKGBqiU8+sklho0fQne4
         g6Yw==
X-Gm-Message-State: AOJu0YysIc+XsO6nJ4Y4ZBlcg9WqaCJM/pa+Rz+WuVbwlDN6ULPlvJYk
	ttYN9E++qR9wo9c3pzpUxSogidhNljaxzQaSac+g2XNrXtI+qDfNFeGxO9t66TTLDTiY2u8ugaX
	L7P/zC2I=
X-Gm-Gg: Acq92OHb/jceSps0lQl5vjT1jiI2CKQLaWBvF/wldAGe3q6oGKgQpYKew0heJTur/Qb
	OEkRRK4xm8eUJab/KQG/J9iIA5Ce/aQi0/OLdQGbbQfidxo14qRD7QkFrRipp+U+mwhQkZeTX86
	yg70/cdsQqZNr0/oqJO5RZuv3mprEj88watLC26Io/uxSIjmC0EHkXYcAMsFI4Vju/NyGN8SC9N
	UC91CWxxe55if7W45cGTMk9GQME17pK/d1PigKdjW8nOsh21ljlI3JFmIzhprNsc2xjXqnUI+eT
	aVBW0G9kcTxWe6aKFG3/UIvvSE+jDsEhLPsN3f2iEvB5yrt4UXCc4Pdd0rXz7K0BwcqCk/ehpgZ
	/WaebFNcHHj58WCC3x9jSRs88VCEgbHp+XI0Q2pHBasplZ2zcXiSckenD6su3i9a5nvoMyWmRio
	bNxTTSDCd7z/fRV6cUNjk8sNinjJOefMrLyqIjd4/esU8Kol+1i8Zz17LCLTQ6D3PV+bNN87Xb+
	KoWsl54Jw==
X-Received: by 2002:a05:6808:1454:b0:486:a9d8:ceba with SMTP id 5614622812f47-48741be7c2dmr9534296b6e.32.1781612453436;
        Tue, 16 Jun 2026 05:20:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875dda608fsm4360697b6e.3.2026.06.16.05.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 05:20:52 -0700 (PDT)
Message-ID: <0600ea2a-9a60-49e6-aeba-3bbab4b9d3d2@kernel.dk>
Date: Tue, 16 Jun 2026 06:20:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Caleb Sander Mateos <csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: get rid of tw_pending for !DEFER task work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:csander@purestorage.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13745-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 050CB68F405

The normal task_work path used a tw_pending bit to ensure the callback
was only added once: the mpscq drains incrementally, so a single
tctx_task_work() run can take the queue through empty -> non-empty
several times, and each transition would otherwise re-add the already
pending callback_head. This corrupts the task_work list, and is what
tw_pending protects again.

This can go away, if we stop running the task_work as soon as the queue
empties.

Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6415a3353ee0..87151a5b62c1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -149,8 +149,6 @@ struct io_uring_task {
 
 	struct { /* task_work */
 		struct mpscq		task_list;
-		/* BIT(0) guards adding tw only once */
-		unsigned long		tw_pending;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
index c801384c6a0a..f910526766fd 100644
--- a/io_uring/mpscq.h
+++ b/io_uring/mpscq.h
@@ -122,4 +122,13 @@ static inline struct llist_node *mpscq_pop(struct mpscq *q,
 	return NULL;
 }
 
+/*
+ * Returns true if the most recent mpscq_pop() that returned a node also
+ * emptied the queue. Consumer must be serialized.
+ */
+static inline bool mpscq_pop_emptied(struct mpscq *q, struct llist_node *head)
+{
+	return head == &q->stub;
+}
+
 #endif /* IOU_MPSCQ_H */
diff --git a/io_uring/tw.c b/io_uring/tw.c
index e74372233f40..f2ce806b01a1 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work)
 						  fallback_work);
 	unsigned int count = 0;
 
-	/* see tctx_task_work() - a set bit must always have a run coming */
-	clear_bit(0, &tctx->tw_pending);
-	smp_mb__after_atomic();
-
 	/*
 	 * Run the entries directly. We're in PF_KTHRED context, hence
 	 * io_should_terminate_tw() is true and they will be marked as
@@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries,
 				io_poll_task_func, io_req_rw_complete,
 				(struct io_tw_req){req}, ts);
 		(*count)++;
+		/*
+		 * Break if most recent pop emptied the queue. This helps
+		 * bound task_work run, and also protects the regular
+		 * task_work addition.
+		 */
+		if (mpscq_pop_emptied(&tctx->task_list, tctx->task_head))
+			break;
 		if (unlikely(need_resched())) {
 			ctx_flush_and_put(ctx, ts);
 			ctx = NULL;
@@ -127,8 +130,6 @@ void tctx_task_work(struct callback_head *cb)
 	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
-	clear_bit(0, &tctx->tw_pending);
-	smp_mb__after_atomic();
 	tctx_task_work_run(tctx, UINT_MAX, &count);
 }
 
@@ -206,7 +207,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	/* task_work already pending, we're done */
+	/* tw run already pending, nothing else to do */
 	if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
 		return;
 
@@ -223,10 +224,6 @@ void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	/* task_work must only be added once */
-	if (test_and_set_bit(0, &tctx->tw_pending))
-		return;
-
 	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
-- 
Jens Axboe



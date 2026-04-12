Return-Path: <io-uring+bounces-13030-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMPdEGms22mzEwkAu9opvQ
	(envelope-from <io-uring+bounces-13030-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:30:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CE23E4452
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 63EC13007972
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 14:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0A4BA3D;
	Sun, 12 Apr 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCiKV/FX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD4D32FA2B
	for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776004198; cv=none; b=XnpJ2rSfuiAyISZROxcik5nFRDOpb9ufZA/ekG5xpOycNf9olEbaGyxaWUl2slLkw21brETVW28OSRn1t7UYUojMI9l71t3Vzko1fvd0/6rPy2EBmbWtALhdA52sDczTHL7rfjECBfrX1FvyD0tmqw4zxyRZwLEi4gXJ39wnUOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776004198; c=relaxed/simple;
	bh=qof7/QVxrJnuNmbE6PgC1ZUedCFtC61FzNveW4C4PEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j45HjNbMiS7MrcNN7USWt1Z8qKyi144922bkOyp85dh5oeOEcHgcUiW/1dItJK2quYB+u67o5lYTfqkjZZquuzi+NCLexTVmqbE8g/90E411gcA8GLyZMICowRxzP9+xMYHkl3dSPixlW0qC4wJVchhQvvQ2ymKFvu8GjHpgVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCiKV/FX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-483487335c2so37534915e9.2
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776004195; x=1776608995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BFnkcHoLUWJbl2g9YvgGSy32+/aFExkTidoMUUW/QYg=;
        b=GCiKV/FXHE4dU//FsZF9ISr4a7m+uS+PmL8ydbbKyP0/8PAKgjMg0Gw0pwJmZPtvOA
         YSxNj6pJdAUT81lofnENjn+6Q6UM07RpaaWnm+78EmvThdsTw+5JlJ3I662d6XsQ9SWs
         0Tl2cUkHPAL7fcTVyTpyrcZXOyLS6El7qEybMgwwAm69XEnpZuihI5G6drQQiyAfiZCZ
         pUuOfYqQ6THMUeoznPRWVL5mgz+EsxcJAFpPpAxLN2/MzUhptCRMbyKJ/LYxaowMlLIb
         DuwXOWdXZCn8Pyno2Y02dc+0y2RkMM1WIY6WbwE5rJGNrmhKjtq4Yt4TW3A4heqa/nvn
         xITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776004195; x=1776608995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFnkcHoLUWJbl2g9YvgGSy32+/aFExkTidoMUUW/QYg=;
        b=jqY8t6MVAeH/LqWZVAa10u2oqH9j9oHAyEmCC3tp1F+URTAv+EYoRrZ8cATdIYveJg
         kx+OBRygHGoSzhlSevrSX74FT7SgeS5CaMlouNV53He1vtWzuJZvniAt3u4m2GFQyEtk
         2k2xcGa42BELoUMxUwIoHn0Qner1ihJNoWTOKCQFI1NcAr0Zcwe7Tu1hoSkWPE+thnTC
         IoS8IV6pLKEgek346uXfsBOHvZnvPi+GjwsCFI+Gqwz9jdiBLhQ+iSTeD9nDGYaxehMU
         vG4S1zmYaoSsCCkOYplBP08Nwl1zA/22xGfzq/RtOUT4dFovh7jOr+0rqmyQGwzD2gOK
         j7HQ==
X-Gm-Message-State: AOJu0Ywe5CFirT5z2WM0spioe4Lr8RPnDb5he73TX35FfENOJjTReMBR
	fVT3C1eIg4v9QOYahn++6UG7cK9yKqnWK2njsb0oSl2oud2jwAj3xU5syJ7YTw==
X-Gm-Gg: AeBDies9GMcVXU/DAJoj2+aqFGRXLfknZoD7bXGWXd6PzeO6wWPHAgkzZRKARtpYGg8
	n4/4yieZjS7X8/vOAFaR/pueHJuzyARG6hGwX0k9dULP5CBmdlt5QNLwuQI10HcopRc74wQHV4R
	utnjswJMsIKSi86jGXn12VFGLZEPDKttqNoFlDG4mmPQGer/t8eSFm/swdyyVonWtNBCSXWizT8
	vHxs8iL2wiJvEqoS+e4QWbRF2UIXOBJ1i9DwZnCPJcsH49Km+AqyUcRWQcGqvQbC1w5m7H5CuZb
	nHdioCDZuGXWBMOpvs3yEryu8SXNf5ZR8IaRYYNtL/W4Ht0caYhmB59QHL+aTzfKUn/3JeIsg2h
	FSmw3cyY91YNyyWWpF9foTQUYKVsb+JrrJ9+Iz7BOhZ8edsIjARrnsOJrHftkXlTPu/PXmlw3O6
	SMpFWUpusSHkeKMyg7Bu321IBjWeVszO/2Tvp1LSRAiQoqn/vEZLuIJAhR7ci0hEzP0nlhrjNIT
	+JtjtpMhLgCMvLZLT7/g7ZtoMaq2A==
X-Received: by 2002:a05:600c:a106:b0:486:fbe1:2499 with SMTP id 5b1f17b1804b1-488d685fcf7mr94276895e9.22.1776004194999;
        Sun, 12 Apr 2026 07:29:54 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d73b44b3esm6815363f8f.13.2026.04.12.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 07:29:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests: don't assume tail/head layout in bpf
Date: Sun, 12 Apr 2026 15:30:04 +0100
Message-ID: <6fdc76568f2066bf0d7f0349088883ab29e6cb63.1776004188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13030-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5CE23E4452
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Keep separate tail and head offsets and don't assume they're placed next
to each other.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/bpf-progs/cp.bpf.c   | 19 ++++++++++---------
 test/bpf-progs/nops.bpf.c | 19 ++++++++++---------
 test/bpf_cp.c             |  4 ++--
 test/bpf_defs.h           |  5 -----
 test/bpf_nops.c           |  5 +++--
 5 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/test/bpf-progs/cp.bpf.c b/test/bpf-progs/cp.bpf.c
index 67a9f825..3987d9e3 100644
--- a/test/bpf-progs/cp.bpf.c
+++ b/test/bpf-progs/cp.bpf.c
@@ -9,8 +9,8 @@ enum {
 	REQ_TOKEN_WRITE
 };
 
-const volatile unsigned cq_hdr_offset;
-const volatile unsigned sq_hdr_offset;
+const volatile unsigned cq_tail_offset;
+const volatile unsigned cq_head_offset;
 const volatile unsigned cqes_offset;
 const volatile unsigned sq_entries;
 const volatile unsigned cq_entries;
@@ -68,7 +68,7 @@ int BPF_PROG(cp_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
 {
 	struct io_uring_sqe *sqes;
 	struct io_uring_cqe *cqes;
-	struct io_uring *cq_hdr;
+	__u32 *cq_tail, *cq_head;
 	void *rings;
 	int ret;
 
@@ -78,7 +78,8 @@ int BPF_PROG(cp_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
 				cqes_offset + cq_entries * sizeof(struct io_uring_cqe));
 	if (!rings || !sqes)
 		return IOU_LOOP_STOP;
-	cq_hdr = rings + cq_hdr_offset;
+	cq_tail = rings + cq_tail_offset;
+	cq_head = rings + cq_head_offset;
 	cqes = rings + cqes_offset;
 
 	if (!nr_infligt) {
@@ -89,15 +90,15 @@ int BPF_PROG(cp_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
 			return IOU_LOOP_STOP;
 	}
 
-	if (cq_hdr->tail != cq_hdr->head) {
+	if (*cq_tail != *cq_head) {
 		struct io_uring_cqe *cqe;
 
-		if (cq_hdr->tail - cq_hdr->head != 1) {
+		if (*cq_tail - *cq_head != 1) {
 			cp_result = -ERANGE;
 			return IOU_LOOP_STOP;
 		}
 
-		cqe = &cqes[cq_hdr->head & (cq_entries - 1)];
+		cqe = &cqes[*cq_head & (cq_entries - 1)];
 		if (cqe->res < 0) {
 			cp_result = cqe->res;
 			return IOU_LOOP_STOP;
@@ -127,10 +128,10 @@ int BPF_PROG(cp_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *ls)
 			return IOU_LOOP_STOP;
 		};
 
-		cq_hdr->head++;
+		*cq_head += 1;
 	}
 
-	ls->cq_wait_idx = cq_hdr->head + 1;
+	ls->cq_wait_idx = *cq_head + 1;
 	return IOU_LOOP_CONTINUE;
 }
 
diff --git a/test/bpf-progs/nops.bpf.c b/test/bpf-progs/nops.bpf.c
index 0aefc76e..dccf8e76 100644
--- a/test/bpf-progs/nops.bpf.c
+++ b/test/bpf-progs/nops.bpf.c
@@ -7,8 +7,8 @@ char LICENSE[] SEC("license") = "Dual BSD/GPL";
 #define REQ_TOKEN 0xabba1741
 
 const unsigned max_inflight = 8;
-const volatile unsigned cq_hdr_offset;
-const volatile unsigned sq_hdr_offset;
+const volatile unsigned cq_tail_offset;
+const volatile unsigned cq_head_offset;
 const volatile unsigned cqes_offset;
 const volatile unsigned cq_entries;
 const volatile unsigned sq_entries;
@@ -35,7 +35,7 @@ int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *l
 {
 	struct io_uring_sqe *sqes;
 	struct io_uring_cqe *cqes;
-	struct io_uring *cq_hdr;
+	__u32 *cq_tail, *cq_head;
 	unsigned to_submit;
 	unsigned to_wait;
 	unsigned nr_cqes;
@@ -48,7 +48,8 @@ int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *l
 				cqes_offset + cq_entries * sizeof(struct io_uring_cqe));
 	if (!rings || !sqes)
 		return IOU_LOOP_STOP;
-	cq_hdr = rings + cq_hdr_offset;
+	cq_tail = rings + cq_tail_offset;
+	cq_head = rings + cq_head_offset;
 	cqes = rings + cqes_offset;
 
 	to_submit = nr_to_submit();
@@ -67,14 +68,14 @@ int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *l
 		reqs_inflight += to_submit;
 	}
 
-	nr_cqes = cq_hdr->tail - cq_hdr->head;
+	nr_cqes = *cq_tail - *cq_head;
 	nr_cqes = t_min(nr_cqes, max_inflight);
 	for (i = 0; i < nr_cqes; i++) {
-		struct io_uring_cqe *cqe = &cqes[cq_hdr->head & (cq_entries - 1)];
+		struct io_uring_cqe *cqe = &cqes[*cq_head & (cq_entries - 1)];
 
 		if (cqe->user_data != REQ_TOKEN)
 			return IOU_LOOP_STOP;
-		cq_hdr->head++;
+		*cq_head += 1;
 	}
 
 	reqs_inflight -= nr_cqes;
@@ -85,9 +86,9 @@ int BPF_PROG(nops_loop_step, struct io_ring_ctx *ring, struct iou_loop_params *l
 
 	to_wait = reqs_inflight;
 	/* Don't sleep if there are still CQEs left */
-	if (cq_hdr->tail != cq_hdr->head)
+	if (*cq_tail != *cq_head)
 		to_wait = 0;
-	ls->cq_wait_idx = cq_hdr->head + to_wait;
+	ls->cq_wait_idx = *cq_head + to_wait;
 	return IOU_LOOP_CONTINUE;
 }
 
diff --git a/test/bpf_cp.c b/test/bpf_cp.c
index b9ff11a3..110135da 100644
--- a/test/bpf_cp.c
+++ b/test/bpf_cp.c
@@ -51,8 +51,8 @@ static int setup_ring_ops(struct io_uring *ring)
 	}
 
 	skel->struct_ops.cp_ops->ring_fd = ring->ring_fd;
-	skel->rodata->sq_hdr_offset = params.sq_off.head;
-	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cq_head_offset = params.cq_off.head;
+	skel->rodata->cq_tail_offset = params.cq_off.tail;
 	skel->rodata->cqes_offset = params.cq_off.cqes;
 	skel->rodata->cq_entries = CQ_ENTRIES;
 	skel->rodata->sq_entries = SQ_ENTRIES;
diff --git a/test/bpf_defs.h b/test/bpf_defs.h
index 8e120057..df78bb00 100644
--- a/test/bpf_defs.h
+++ b/test/bpf_defs.h
@@ -14,11 +14,6 @@ struct iou_loop_params {
 	__u32 cq_wait_idx;
 };
 
-struct io_uring {
-	__u32 head;
-	__u32 tail;
-};
-
 enum {
 	IOU_REGION_MEM = 0,
 	IOU_REGION_CQ = 1,
diff --git a/test/bpf_nops.c b/test/bpf_nops.c
index f097434f..1a1068a7 100644
--- a/test/bpf_nops.c
+++ b/test/bpf_nops.c
@@ -45,8 +45,9 @@ static int setup_ring_ops(struct io_uring *ring)
 
 	skel->struct_ops.nops_ops->ring_fd = ring->ring_fd;
 	skel->bss->reqs_to_run = NR_ITERS;
-	skel->rodata->sq_hdr_offset = params.sq_off.head;
-	skel->rodata->cq_hdr_offset = params.cq_off.head;
+	skel->rodata->cq_head_offset = params.cq_off.head;
+	skel->rodata->cq_tail_offset = params.cq_off.tail;
+
 	skel->rodata->cqes_offset = params.cq_off.cqes;
 	skel->rodata->cq_entries = CQ_ENTRIES;
 	skel->rodata->sq_entries = SQ_ENTRIES;
-- 
2.53.0



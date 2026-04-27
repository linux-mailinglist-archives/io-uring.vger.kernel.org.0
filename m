Return-Path: <io-uring+bounces-13149-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PUBOgO472kbEQEAu9opvQ
	(envelope-from <io-uring+bounces-13149-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 21:24:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F5C4793B7
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 21:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD2B8303456D
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 19:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB8F3FE641;
	Mon, 27 Apr 2026 19:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYMxHmgf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962E83FE670
	for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777317874; cv=none; b=m4qy9DuhXVWo+MnoSafmJFsgusIRFX0JVlCTumP94/5jgmC8eMrv0ZkgDo3XS1Q9yz9MyFKXpoIJwUMlTfHxgUPxb4PAv5/tNSxjjQVFppyWUkyNOV9cifNLQXkmrS/Y6KEXcTRC7Hoh9tDNECrYlE4qvOwwtvJDnzgtWkyIdgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777317874; c=relaxed/simple;
	bh=CGHtOlPQR6pOvZqMqOjrz3TPzlmx1xRyQcrX5B3fEBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFwPZjG2JfmiG5WqzZZ16qSNy04QC7VqilQ4LCClZWu537xQQvr2PstggVjGSZwjtSqsy6Z8yYFSf7E7dJN1uYgh+BpUo9G7cLaMrMGyEQfhfevHYNYef4EqZ+j8N2+iEIlyh42JRF5jVFPMHvA6m6fnukmtq8j3qvz0FLpSqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NYMxHmgf; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66bd474d90bso958787a12.3
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 12:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777317868; x=1777922668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcRv6CvxQNxIKnNigOUP1+iEmTXRTTLtzAms3OZtB7o=;
        b=NYMxHmgf912zSCTC2bOQYlpG4ri+yPx1yJ1opes65israNcrA6rAaSBwD2CitWIB4v
         mOAzDEjjX0Yc+WfA6Hsf/CLYTuyrwkYxeE8egtyUib5SjHVk/JVLIdTd/v9q8rWlR+JX
         gyJ2IGprfS60ZRblnnNeSXOOWLnJrH2vtA1PT6RoIzgvLwiy+icqw5dsDTiZqQazN1yG
         u6fj6tLf/BTaMk5lvCA++BkeI1JoOyBe/l/VJn2WvJ2upy2lUObxBgoZ0+RLPMtrQRby
         +z1mR/3yQEM8stg9PtsD8DUKbUdJnmcJc0tVw/gJBCF1Bk22ZERmjtYzbymJ5P/g6ZKm
         ubAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777317868; x=1777922668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pcRv6CvxQNxIKnNigOUP1+iEmTXRTTLtzAms3OZtB7o=;
        b=rPmZcful6b32PQ6lTkp0oSqOmOyZWfAo+oIkbHxKvWySJ3W85fzyu2lgxooJr6He5u
         hRp2RXLx4AEanZ6TfH7lGKrNWqFSn83+YE1ckfQkdIt5PgqEdvqP5OfzsFZSzdLFvlBU
         ilGL/jQyLj3nPqV04bPk+MjIgClEVfrLu6sGob9ZbkoZ3bjuHfbbyOLRDp+1i65z+/Ha
         Jj3StyqXmmLg4x+oWhHXzI2KaGvM3yNoPqcMNG2XrSdBZCNNMyI+sGG7qNjeR8R3Ol3Z
         AR98Zw6ZYiFLu9huJqE8TIQbeX2Im+QG2qJAlksr63l5HbS3AYKMEKI4zaJumYpYKF9S
         Vssw==
X-Gm-Message-State: AOJu0YzEHjY7riigUPdmkt30OTp1nwsn4KYvj1XI5cYG5NXb/1Uc+xHg
	WDUg59ZwQwZXoags8vbKaqw1ZlJ3K3e4xGXWHvpEjh2djcQkuv6yeo3pv4xoWEio
X-Gm-Gg: AeBDievlujwyzwVmErAUSRrSExMHv9JK6MHZkZw/EyDWHFvsx6X9wyqRIvUV3VdPz2r
	iPP5KUL3toEe6gcltceIdDjDID1Exyci+mVJ4hQlaQIPfOiUEirgIqIUNVu3IsnIhzes2FuS1C/
	BumiG6BtNcUnmjxsTt0CAGGOocXfAAXZLFyI2RH2jgJALMsTHw2T2mCzgGGN2+I6LbuPlAVcYhz
	6wi7vaEGCsA/NiBuWZBIZG4IVF5VD0BCeHWzHxQDrX3ZMb0qVqYcOyhUfs1b1FdlY+XrJyiWWLl
	TYDfEFWQ4Wy7GMSf0y+3SNsgNTp2n++t+tPY4rfqOR0WFShFcv/nlQqOSc1L2/Z0ggRIh91kr2H
	Dkm43E+6tBqbUcY26Fmmp6KJi04KsMN6H/9+PkaYUtOa2BOVdPxAyW7I4dIKaJPQAwBb+mHGpGR
	246iCYvkNsGpzuKumjp16OIaMWV9GeVAddLMAYI1S0V4fgdn/J1Q==
X-Received: by 2002:a05:6402:a2ca:10b0:670:8ccd:704a with SMTP id 4fb4d7f45d1cf-679b672096amr100649a12.5.1777317867315;
        Mon, 27 Apr 2026 12:24:27 -0700 (PDT)
Received: from localhost.localdomain ([182.181.202.3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-679b6869a6esm73871a12.31.2026.04.27.12.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 12:24:25 -0700 (PDT)
From: Ali Raza <elirazamumtaz@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ali Raza <elirazamumtaz@gmail.com>
Subject: [PATCH v2] io_uring: add submitter_task consistency check to io_install_bpf()
Date: Tue, 28 Apr 2026 00:24:00 +0500
Message-ID: <20260427192400.416133-1-elirazamumtaz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
References: <12c2bec8-ffb9-4b01-8bea-819c6ec77c5e@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50F5C4793B7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	URIBL_MULTI_FAIL(0.00)[sea.lore.kernel.org:server fail];
	TAGGED_FROM(0.00)[bounces-13149-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[elirazamumtaz@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

io_uring_register() already guards against a different task touching
a SINGLE_ISSUER ring (register.c:733):

    if (ctx->submitter_task && ctx->submitter_task != current)
        return -EEXIST;

bpf_io_reg() calls io_install_bpf() without an equivalent guard.  Add
the same check for consistency.  The check is gated on
IORING_SETUP_SINGLE_ISSUER since submitter_task is only assigned for
that flag combination (io_uring.c:3053 and register.c:282).

Note: io_install_bpf() is called directly from the BPF syscall path,
so `current` is the task invoking BPF_LINK_CREATE.  If BPF link
registration were ever deferred to a worker thread, this check would
need revisiting.

Signed-off-by: Ali Raza <elirazamumtaz@gmail.com>
---
v2: Added IORING_SETUP_SINGLE_ISSUER gate; changed -EPERM to -EEXIST to
    match register.c:733; removed security/exploit framing from commit
    message; acknowledged that `current` may not be valid if BPF link
    creation is ever deferred to a worker thread.

 io_uring/bpf-ops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 937e48bef40b..84578614cc0b 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -162,6 +162,9 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
 		return -EOPNOTSUPP;
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EOPNOTSUPP;
+	if ((ctx->flags & IORING_SETUP_SINGLE_ISSUER) &&
+	    ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;

 	if (ctx->bpf_ops)
 		return -EBUSY;
--
2.43.0


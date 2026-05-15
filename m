Return-Path: <io-uring+bounces-13360-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAP2In42B2rftQIAu9opvQ
	(envelope-from <io-uring+bounces-13360-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:06:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1570E551DC3
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B0C130785F9
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8872D3932D1;
	Fri, 15 May 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDAnfSVr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A625785D
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778857110; cv=none; b=dEqWFsvyB9fdFTgG/7zmtfJV0N8T/GX/30eTscRXDOegCZZhy4G098IdrHbFG+SyfpcBSzyEyKBdYXo4i7m0wylTj8001yFcuZ6opOIKJEHPwIKoXQNnxGzCOpnIrgSs+4DZ3g1WNhTfvWH35M2JuEf1zuhsn4LnB4ke0k7VNJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778857110; c=relaxed/simple;
	bh=E1xx1uYoxK+eSCVWHUsVq/IguOxd3TLj+xysRTJERkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NYiXkcoKzTuMFK9o9W3eGY4arPwqwJIEPpzorgoZQytoUl3I95ASPjcGjKQJjGA1o2ATM42AJj2J/gpWQyryuuRAYcx7a16s/JUNcsWjQ3v5U6cZHs3rCsoHQ0pRBak9kge55h4j82YeJxsijGDtxIWwlKmX3Jz3BCGpA9P+cuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDAnfSVr; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9102e90bcbeso333885385a.1
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778857108; x=1779461908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0+nei0qxNlG/6SVkqADrmiSvLLb+6waS8I6r15019/8=;
        b=PDAnfSVrU9OUHCH0STDvIPOJmRymaf8I4D7D0/3cdx7Nh94rucmofMhBh1MZlaKj5J
         L/GBLIHg906/V/r/BHUsSKmv71mbxCpJjd3Ijviiy3G9Usq/tjqIA52GSp5WNVbuZBmz
         X6G0tnUXmmOXj8elA0thZqSXX0u1mEa5jEYEU7prPCMae+NrHDNcX7jeoWMq+ty/ayEk
         /Z3Vv6vsYY7eQuzU652tfxXN/6EdHZ+aMRkj5bSYVMAOcMwqoOgwGzykM6ESxB4I5are
         w5dEhem6l12rzFq7eJXx7djYbRp6VXZTaJT9a3uZdrXU4iT4H8hVGQ6IIbKJqcPdNw28
         I0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778857108; x=1779461908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+nei0qxNlG/6SVkqADrmiSvLLb+6waS8I6r15019/8=;
        b=p/5FOZzW8kUg7wsXk8cmAfzJejvcSsdsg8rdV4Rl6chV+0LLFoCBraLrUlqdS+sbN/
         vfDikZBrXmWiZPm3FSk6B3f28QW1vp13ROg+SXYU0rZ+QtHefy9f376gONOJ7jK4deCB
         xu2zaO029FmfHgTVTDZcTFu/mWdqDY3A3CXHNTD/ceOKKGcFv9Mx5QI8/MGaRmpxFBw0
         zuSi6I1ik9Yet17GNzYj1kQXVQFYsEaLJMqvrb7WItBzeTAnDLgwYYv40Exi3hDeFT+R
         YQV0vbqxLPh/7WyWDqJx0Bw0l6S9zRKcp3GFS9DmJhC8CDW8tT4qYXtV6rFOuuuxxk7K
         vYTg==
X-Forwarded-Encrypted: i=1; AFNElJ9jlhSKUEx8aOFPRXeRmIZlQ0q+kWMRkguujgYfGfir8AE2WuuS9dXZ7IP8Qm3H6GRcbb+5a0YSgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPsb9FWbdYcISWsGOfZV17PLyyxmnD2lGLRVYJWZ6aEkNi6HLy
	YbfqW2UJlqNCpwAFiqbDtduXhPnn5HhDm4KhpbrrAqIL/eqYRAd4AUOq
X-Gm-Gg: Acq92OFqICVct1KNFT/pl4ZJh1E3o5kYONSfuMDfJWO69mNe01WrQUrRyU0fK+8k5Mq
	omDVDVQzwNU2eMJXUE8GB4A7lAio2LhUYNDK2yhnRGqPvNLUIA7uKFvrt5KdugULm6SDQKmy31M
	89unylCQ0PLT+OIQg0najXWFVOtUJAo2qdJ4b1rBFd0iiQDxjcONG7ZTALgUJAi77lK70g5HuuH
	/qhlM39FGaiytHZE0mwmW+7CKQRu9MXwDGE3O2WJUx2QOuv7LchsgIhyIznhaRyW3X5+T10zG8W
	arA7xnF/CcY61sGOO0Z+uWArNTX+OxKwdcqgztZZHcl02eUM47mCBc2XYnyxdIqyUuWQLf2Oz4x
	iCJh9gyirH3coTVNfmj9ZNseFQ+J4TinOe+4+HVkvHbhJnOrPLMQS0NMQw9VSyNsWilcvAPvsNH
	P6WNsIximzEH7afnesaRb4GNhf0V6exMj2AoVlGKII4LwOOWtK/HnbTXbKXc2eVJmq8Cez5AJxw
	xsA6Iwoxxd4/E+wWWR44FiDpfyqSPkCpTQe0nqJ64M=
X-Received: by 2002:a05:620a:4083:b0:911:1a2c:f953 with SMTP id af79cd13be357-911cd75d3e6mr700185285a.20.1778857108064;
        Fri, 15 May 2026 07:58:28 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf3584esm550293385a.34.2026.05.15.07.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:58:27 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: propagate array_index_nospec opcode into req->opcode
Date: Fri, 15 May 2026 10:58:11 -0400
Message-ID: <20260515145812.1241925-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1570E551DC3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13360-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[michaelbommarito@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
array_index_nospec() to the local opcode in io_init_req(), but the
sanitised value is not written back to req->opcode.  The
unconditional write at the top of io_init_req() stores the raw byte
into the persistent field; the success path of the bounds check
leaves it unchanged, and downstream consumers read the raw value.

In io_uring/io_uring.c those consumers are io_issue_sqe(),
__io_issue_sqe(), io_wq_submit_work() and io_prep_async_work() (all
indexing io_issue_defs[]); io_clean_op(), io_req_defer_failed() and
io_req_sqe_copy() (io_cold_defs[]); io_check_restriction() via
test_bit() on ctx->restrictions.sqe_op; and the audit hook at the
io_issue_sqe entry.  io_uring/bpf_filter.c added in v7.0 extends
this set with io_uring_populate_bpf_ctx() and
__io_uring_run_bpf_filters(), indexing a heap-resident per-filter
pointer array sized at allocation to IORING_OP_LAST.

The kernel's spectre_v1 protection is per-site array_index_nospec()
annotation, so a site missing the annotation is unprotected
regardless of CPU vendor, microarchitecture, or microcode revision.
A per-site array_index_nospec() was applied to the same class of
gap in io_uring/fdinfo.c recently.  Propagating the clamped opcode
to req->opcode once, immediately after the existing
array_index_nospec(), closes the remaining sites at the source
without per-site clamps.

The compiled change is one instruction (a single mov of the clamped
byte to req->opcode); the cmp/sbb/and clamp triplet is unchanged.
No functional change: array_index_nospec() is a no-op for opcodes in
[0, IORING_OP_LAST), and out-of-range opcodes are still rejected at
the bounds check above this assignment.  Boot-tested under UML
(x86_64 defconfig) by building stock and patched kernels and running
a 54-test subset of liburing's test suite against each; pass/fail
identical on both.

Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09c..7b257a03ef84c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1739,6 +1739,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return io_init_fail_req(req, -EINVAL);
 	}
 	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+	req->opcode = opcode;
 
 	def = &io_issue_defs[opcode];
 	if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
-- 
2.53.0



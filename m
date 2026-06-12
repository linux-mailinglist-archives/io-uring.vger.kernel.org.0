Return-Path: <io-uring+bounces-13689-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id pMHONIF0K2q79wMAu9opvQ
	(envelope-from <io-uring+bounces-13689-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D6F676563
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=YIz9j4Ko;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13689-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13689-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D6B031F2F5B
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A863806DC;
	Fri, 12 Jun 2026 02:51:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E188377578
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232697; cv=none; b=jkLpzCEm3UdLiEs6XBKy52kEnQ+RlX9XFh16g7+3QtI5gGpoC1Rv+0HbfHd+CkQ4NOkNzOdevfvLuBMVkGuTHd/IszfHqyy0GGFVo7TP0ZglAQ3tGVCNokNYmFI3W1uVkpyk2LdEr6eZhG6OF5hlmARzfj6MIfkoYxzSw+Hshxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232697; c=relaxed/simple;
	bh=Mdyps4BH0ACPJ/hbNijj6VGHz34dBT3sdoyBgbGjQ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LstTG6Lnyx0atbK7QbbfFi+TQ/2iEq/zIuqiP22zpb7BBzvc49g9lU2E5D+Pl6P7va5y3VnMvRnyslFKTmLa45WXyT79ylSrYKqYkvNKmC4UwEwtdzMon/Osbbi3gFs2Jn7rGo8tO3FCDRntWcq8lajrh5auzyKDzYELP7irfIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=YIz9j4Ko; arc=none smtp.client-ip=209.85.210.42
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6f586a0d5so291252a34.0
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232695; x=1781837495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVMCZBb7MGXgJgtwBltegM7guo+MdJBn8in1qkCSa14=;
        b=YIz9j4KojMWZPPghixXL2YMK2yPf7t4CecSY4gvhPdd0mmq1ageqPiF2kpMvZwzbcQ
         hYG1EUKfzY4PNmYcy/5kKr8Qcht0bv3kyAOL1yfofOwpEDk31NrPO1gxbApCRdzwl0C2
         Cep7HmtRsqVKIzzA1B2QMQ9nnzgPJCPRhy565DdnBK/+AXVqN1qOsBd4dq91IRCQRhed
         NAxBqvpg6iG6h5HjxM1IVkFaJytrquFcINAiwMlmWCNR8irOl7GECO28JxiQBs3vztiG
         P9mY6viSPK6Kg1xhYzVDC0cQIP2sJG3WF6MwpGxXI3rpswU8fXxl5XJWeFlZehKT6U29
         Edyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232695; x=1781837495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PVMCZBb7MGXgJgtwBltegM7guo+MdJBn8in1qkCSa14=;
        b=SIHR6LM/ejNLyCVAqboGkcdNV7G5rIL6rLGdTkmdw1IR82Tgo//C/CG1oNqO4nWS1y
         a9j98h6TL4DM8ahnAxru2y/q9r5ASkI9Rg8bfE5n5HF5wVksX6RIN0QSrfeJf84sA+MM
         aT8DP4Lrt1MYT1F2K4YVUNyjn3fB9m2Wytl6pGvdzTMRDa0xWW+giC787zb2KeJeWy/q
         jqywb5FiwG5YPVp6s39r5GKASjQtJnJC8ESG1/qAXEhzrT1OClo3RIsPG86RzcbpHB09
         rrBa2U2EhcFw1eXk6K/TWVERqUHMbe5KLLW+FlbNyNpeZgUZPapSUEABe0PJSOIli3wO
         e1ug==
X-Gm-Message-State: AOJu0YyIs+w1l8OaYkwlqMseoIbja83Vj16jEuGzjEmlyVEJpLzW15vd
	bDzUgSpgZN+HOxbYz316u8KWqHvFovYCPq3dea67vRHgdbhM2hQ9FHiQh06O4bNlGdQLbk5jH1l
	6PwDfxnY=
X-Gm-Gg: Acq92OHERWZJuhIZLeaTWDaNjXRUrK25TxqjXkl8wlvJj4hhxb8VlTvdzH4uZMe+mvN
	FytirzYPyN0wK01VJ6FCmguru69ZKBZ9gj1OgT3/xzanORfrcDTrA99I1YG+BroLHofXW4LHuiL
	zm+p/+YT/IS2WA3vXfoWRx5MEeGVTHTEZn6DJYX5QpMUS3szS7btcmqxqPmDNGQ9Uu4vNHQRE4o
	VXyXz5863XVLUQNBa8nFXN4qRTtEQzHQsMCUdShctDYE1WXzI+qQucu++RjBTn/hfdlZAvk6w30
	YeH92XbPqiRfcC0zFhEQBF9kPjj+J9nwXAu6i7MElcjyf3unzO9IuJNHy3TITv5gAHh0173Sf/P
	qIkzaL4pPJ8QimON4/XOYqmTjR1n3Zkvg2xx33vMcFgVMTAmDqeJ27z8qTqtqr/infh7RFDeTmJ
	87Anu1KN7jti/2GYBJXrNr0846PI0JOqZjzMNfS1nWsf47vs5nk0DPCFzfJoZbwtDcXyyw
X-Received: by 2002:a05:6830:640d:b0:7dc:c7aa:22c7 with SMTP id 46e09a7af769-7e784474cd9mr621599a34.0.1781232695256;
        Thu, 11 Jun 2026 19:51:35 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: run the tctx task_work fallback directly
Date: Thu, 11 Jun 2026 20:48:31 -0600
Message-ID: <20260612025125.1690253-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612025125.1690253-1-axboe@kernel.dk>
References: <20260612025125.1690253-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13689-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 35D6F676563

The fallback work drains the tctx queue only to redistribute the entries
into the per-ctx fallback lists, bouncing them through a second
(per-ctx) work item before they finally run. That made sense when the
producer side did the draining and could be in any context, but the
fallback work is a regular process context kworker: it can just run the
entries itself. Reuse the normal run loop - if run from the fallback
kernel thread, ts.cancel will get set, and the work terminated.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/tw.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/io_uring/tw.c b/io_uring/tw.c
index ca29bb0b9768..0fa685aa3926 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -78,24 +78,18 @@ void io_tctx_fallback_work(struct work_struct *work)
 {
 	struct io_uring_task *tctx = container_of(work, struct io_uring_task,
 						  fallback_work);
-	struct llist_node *node, *first = NULL, **tail = &first;
+	unsigned int count = 0;
 
 	/* see tctx_task_work() - a set bit must always have a run coming */
 	clear_bit(0, &tctx->tw_pending);
 	smp_mb__after_atomic();
 
-	while (!mpscq_empty(&tctx->task_list)) {
-		node = mpscq_pop(&tctx->task_list, &tctx->task_head);
-		if (!node) {
-			/* a producer is mid-push, wait for it to link */
-			cond_resched();
-			continue;
-		}
-		*tail = node;
-		tail = &node->next;
-	}
-	*tail = NULL;
-	__io_fallback_tw(first, false);
+	/*
+	 * Run the entries directly. We're in PF_KTHRED context, hence
+	 * io_should_terminate_tw() is true and they will be marked as
+	 * canceled.
+	 */
+	tctx_task_work_run(tctx, UINT_MAX, &count);
 	put_task_struct(tctx->task);
 }
 
@@ -161,8 +155,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries,
 	}
 	ctx_flush_and_put(ctx, ts);
 
-	/* relaxed read is enough as only the task itself sets ->in_cancel */
-	if (unlikely(atomic_read(&tctx->in_cancel)))
+	/*
+	 * Relaxed read is enough as only the task itself sets ->in_cancel.
+	 * The tctx may also be drained by io_tctx_fallback_work(), in which
+	 * case current is a kworker that has no tctx refs to drop.
+	 */
+	if (unlikely(atomic_read(&tctx->in_cancel)) &&
+	    current->io_uring == tctx)
 		io_uring_drop_tctx_refs(current);
 
 	trace_io_uring_task_work_run(tctx, *count);
-- 
2.53.0



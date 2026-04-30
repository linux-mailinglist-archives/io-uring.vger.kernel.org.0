Return-Path: <io-uring+bounces-13188-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iD4XNk5T82lnzQEAu9opvQ
	(envelope-from <io-uring+bounces-13188-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 15:04:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 897E54A31FE
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 15:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E91FB30515F1
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2026 12:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D85A40B6E5;
	Thu, 30 Apr 2026 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="DFigt408"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E14406269
	for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 12:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777553829; cv=none; b=mWxqt6knG3CyhXRWxsx/rzbKZhZivIz5z9Ld5GUSTZixV/LNFVNDVvyHnXZIBuSkoYHFlDHJNGRf9vlf0Ehmji0Y0gvEcPZ+7+LCv/XB/Qh08jRPW4PGc1kp3K6VH20YEi8vMS8r6/JnUropTuARG42T8AkVu5h6k83vf6J4noc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777553829; c=relaxed/simple;
	bh=A9oKRVadhDhtIyeSbTPeEOBAt0yO/nmLLQ884Oq+EyI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=TOMWb0zyC3kA/CTOO1NkhYI7mE9FMNkWdwNTGPeHcQ2UJQTE1tgNB2bKOM5CFFe6fAz0hF+5nwKmx+rMSIPXAh3q51a4g5YxxZHykLZRwoPfYvkirqD4EzD7YjJkVOutQ96SLLqDXVdNlA229YHsozp3UZ04lFNBwQnSzu2gY34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=DFigt408; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-42fe552aedeso246680fac.0
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 05:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777553824; x=1778158624; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fp6GLiMc3mG/JBgvPvy5kcIuZGpOSy9AmXMm9ouwy8g=;
        b=DFigt408uAB+rAtEEeBn/s9kBnmJRNmIEh3Qd9TRjv+pREqn3plmsS8BL+540sim8O
         erh+vNOy3g9PDGj0nSQNFXaIMYfEX8dpXi0BRRpLuCVBS5AjZzolZ82Egp4aNb0KYAKD
         7W8/2uue/BYnGI5nhTmZTGnuzjJHllZjg4YRrnX81iAs0gYlduIxtrZsDRuRoI6zcS2m
         ONyR/gICV06ZKWrszHRYi1FlcRqQ2oRUB+tG9H5m6sILfSyR5TaGWJvObRiIYjv1baZV
         kUPZLu0CY2bvA3DAZBXfhN8kHDDQmhl/TsYwRvH7kgiZzJaODaipfmSEEVo6euWSKKHh
         m1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777553824; x=1778158624;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fp6GLiMc3mG/JBgvPvy5kcIuZGpOSy9AmXMm9ouwy8g=;
        b=quPc5S/i/1I6zhn+S3KXsOjUURWC3yV65/6SCqOiRMc8G37zSg2QXcfLc0iOkk0Bui
         fFLRwJmRcDU4MTNCltCQ7dqvYLMeiEhaKMBNpRn5L9e4yjLTWYa8W14saI1PDLpC2+aj
         C7PA0RwyfKH/3jiwykF4orpCp+6GcsVxu9si8M/dPO2E6QqRVjumRzdUOjWD3ih+YrFW
         uX1SJjTQuABkQ/qjxuJaOXDUQ9mO2NY/LhsZwuRpxQ56U3AnSOOmk6RoTTzUPeT1haUQ
         DXe32ToLx9/0ADziHhcy72xt9JOYFPfI/rLWrZ6YUUzqVQQJJXeteDqVonUwmPz08L3A
         2U/Q==
X-Gm-Message-State: AOJu0YxH4HkmlHFhZhYJY2qaWDS5SJBDTDjH9N3zUjFQxk5BMH04SgDQ
	0i1Aj1TDeVhqBLWVZmE2u7z4mB6fMytwptFjQ42IUPvck0P/3XjEI3idajbafyrK48KlpsV/zhu
	l1trS
X-Gm-Gg: AeBDietS1rm9GVmDG+ixO2S9ZJ8uGuQih62S4Fj+U7QbgF/0uDf1HpHh2RkGglxJVLA
	hJLb5eUNBnZyd3Q1tTeG/lVPqmrr+mN2jCfZAypKjNP7XZkCIGVnab/wmW+lfzQRjsCP1Sqe2mE
	c4pGMOnUxsgIBKVjhuiXOSteoQK78sjeIMcxqEVJIISVHiscOrgneQNDT83kp468vgKpEV4eI1P
	PV5VQM5BkXMC86qu3uxAr4HdPoS8lrRw5Pws3Lw2jzengJ8u7+MAuTANiGs0blLhZnEMQ35p6CI
	us+pVtbUq/c1O/GmO0jrNo850M7i2KUCmlRvrcM4NuKnUYO9Kp71OdzLazi7BdtpUNmx1ccTr72
	a7XovdUxBzFD6ERXusEYIXT8VTlDX5JuZDqiJEZGYR3O7vm/kV6fD3LfdXXyLJQTfKLuWFGViUD
	EuThqjQV1S0nLQKAxmFg6XysW+uvcEiS+V+5SzVEbRn5vjtvsl2itaDyiO6IwUrEdn9F4zl6sHh
	dqeT7+XkVbUsrL8eRFz0G0llnuL80Q=
X-Received: by 2002:a05:6870:8e07:b0:42f:fc34:78bd with SMTP id 586e51a60fabf-43434033ccamr1450447fac.33.1777553823981;
        Thu, 30 Apr 2026 05:57:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43436b3ebacsm1475417fac.8.2026.04.30.05.57.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 05:57:03 -0700 (PDT)
Message-ID: <5c5a9cae-eec2-4a1b-9941-fe88868bfa82@kernel.dk>
Date: Thu, 30 Apr 2026 06:57:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/tw: serialize ctx->retry_llist with ->uring_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 897E54A31FE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13188-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RSPAMD_URIBL_FAIL(0.00)[x41-dsec.de:query timed out];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RSPAMD_EMAILBL_FAIL(0.00)[stable.vger.kernel.org:query timed out];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

The DEFER_TASKRUN local task work paths all run under ctx->uring_lock,
which serializes them with each other and with the rest of the ring's
hot paths. io_move_task_work_from_local() is the exception - it's called
from io_ring_exit_work() on a kworker without holding the lock and from
the iopoll cancelation side right after dropping it.

->work_llist is fine with this, as it's only ever updated via the
expected paths. But the ->retry_llist is updated while runing, and hence
it could potentially race between normal task_work running and the
task-has-exited shutdown path.

Simply grab ->uring_lock while moving the local work to the fallback
list for exit purposes, which nicely serializes it across both the
normal additions and the exit prune path.

Cc: stable@vger.kernel.org
Fixes: f46b9cdb22f7 ("io_uring: limit local tw done")
Reported-by: Robert Femmer <robert.femmer@x41-dsec.de>
Reported-by: Christian Reitter <invd@inhq.net>
Reported-by: Michael Rodler <michael.rodler@x41-dsec.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/tw.c b/io_uring/tw.c
index fdff81eebc95..023d5e6bc491 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -273,8 +273,18 @@ void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
 
 void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node = llist_del_all(&ctx->work_llist);
+	struct llist_node *node;
 
+	/*
+	 * Running the work items may utilize ->retry_llist as a means
+	 * for capping the number of task_work entries run at the same
+	 * time. But that list can potentially race with moving the work
+	 * from here, if the task is exiting. As any normal task_work
+	 * running holds ->uring_lock already, just guard this slow path
+	 * with ->uring_lock to avoid racing on ->retry_llist.
+	 */
+	guard(mutex)(&ctx->uring_lock);
+	node = llist_del_all(&ctx->work_llist);
 	__io_fallback_tw(node, false);
 	node = llist_del_all(&ctx->retry_llist);
 	__io_fallback_tw(node, false);

-- 
Jens Axboe



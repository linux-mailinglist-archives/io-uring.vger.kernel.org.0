Return-Path: <io-uring+bounces-12480-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id odHmLTUcomnzzQQAu9opvQ
	(envelope-from <io-uring+bounces-12480-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD991BEB98
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75CEC3133DA0
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054FF47B418;
	Fri, 27 Feb 2026 22:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WlCXbMQo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E354C3D4118
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231710; cv=none; b=jVgfwJKg2P7mNZOQYM1N+1bcSJA4PAq7AAE6GyJ2huRbfDFMqmTsX4lvfjmgHgRBps73v1FshDBUuy0vGxw499JZzhqnIZNwXmTGYlAgHKmDLNeUSQS269/KtWY0PCxxBNZBwpQgV/7r6CcOCcAFXx1z3t2RRi9hr4rIqRLa++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231710; c=relaxed/simple;
	bh=x/lgR7lfxoNQ8NgcIqgi/nGp9L0HR70DpaM2xD91Dbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruoEMPR6YRwQFTc8q1W09UsDjPpEzPSvzUawKRwIcC9DAa+pYSMW9gGQ5albt7zVDUH2uAcCYWs3OXs49VaEj3BvM6ax3EPmVXwg0lMVt5Xj/+cGbmDv5W7rWTj2yFKTxFGmWGXNUnRkHwFEsBoDmn/7dfagElRLn4tEqhT7jhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WlCXbMQo; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-6470d549e10so270472d50.3
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231708; x=1772836508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doNIdz9wMn9gx8zF7Ky2pC6GD/iifRgNWdZEMqpkv1c=;
        b=WlCXbMQohgfDevE37gEl1e8EgNC0Z6xLKsdJVlurSnx9q07v1xhQ1vGJIoXwEHDw8u
         mSyt/WEGenHvRUmx+Y/pgo39YFJIVlBX1NYOVDzbJzREH3ou9RGIk3UW167282iiDg2x
         zCSf/6bzmz7+G7CJeGNhek4fUNAoVt/0dWwk0Z7798Z5IcZMppJv2C0cVGA20FXVNwMX
         iU25QNuYl79/PrDr0HV0GDUCdIiyx3kcL+++fGndqxExKebAZSyv9IsiK+E5gB5E5YFM
         uI3rWl1EJqUafrTJipmQmS2qKLDT6NBV1To+F350xkAlqpfFsASriT04RtR65Ert6TpC
         svgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231708; x=1772836508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=doNIdz9wMn9gx8zF7Ky2pC6GD/iifRgNWdZEMqpkv1c=;
        b=ECykJMi7fWx8K8WdKAysJR6wMTN1vIanLfhq8tVKvyajlt8rkQX1U1PNadt1BMLXgw
         9727Uw+NVjcR9+R4dGuOd3jKtsxdGio/YHKraItu+FGW3Td3Uyk/huRifPmqHBM0C4bl
         /76ymI91f3xiqx85U19ysk+UlC4P+uekNq9y7FXkRIvxM6cEfrs5QKqfYb3+cMiYa6pR
         iSaXhcWfBDPlzXMg9JdNdVNEKNSWrsRaAM2VKwTbJi3tTPQwn7KKL9SbxlAjEJulvray
         sBZT7mLZ53Ng6cXp/ovjKA3UHVmgfWO5LBmqqUz15MrB54EWf9GHhOedeytUwsnNa7nc
         Exyg==
X-Gm-Message-State: AOJu0YydWqV61rMRJa7xXCswoucoNJ5Ju+7kVsR5c7+Mbd/VXcpvmCH1
	4DSerVCFJuNDWMWC/I1VgCMWL287HNZz5NOtxQxr0Tj1d7zLYoHuhHwZMUp1jQTqxCblDEI6My0
	8UTKYGmQVUCBS2tlLtZLmWhFBz1lrGBIwkzBN
X-Gm-Gg: ATEYQzznBnI8yL8Y3IwH/x9tPS3gEioDY6lKxI406LLte6fnMkpqvl/TFOb0+0/g47o
	IKLx3iprla5r0oo/lxXzscFtKGPBx1wXglLj4VWuHkb5aghvUfO9v9cy9XjyZlej6yAAk+I31q7
	2SLgTy8J4aDNXB12okE0VODfmiSiw32vo1aknk+jMIhPmwJTxixBO2qVsEvihOVhRXR2X2Qv6wp
	uljTJXMVwhq1NbIqtLaR+sKk+sTqDJDfQMaXl/Y5yWEV4WDOJD+zRFrySueTZ/u1nN/DWFsXau5
	SEdCM94rutFKDXTLDBJz0bJjTSyPToCsgClDrZ/9RjPaOJJar3insDkPlDpA0CpctyyndzY7+GQ
	E950eC94hA4y376bz01RCl5QBEMFDN9VmfMcZf6ZtOYCJTVG8RYigRw==
X-Received: by 2002:a05:690c:c4fa:b0:797:a57b:d200 with SMTP id 00721157ae682-798850f351bmr35803657b3.0.1772231707838;
        Fri, 27 Feb 2026 14:35:07 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-79876ab7b69sm6884587b3.1.2026.02.27.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:07 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 255C9341DB3;
	Fri, 27 Feb 2026 15:35:07 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 213C2E420D8; Fri, 27 Feb 2026 15:35:07 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 3/5] io_uring: count CQEs in io_iopoll_check()
Date: Fri, 27 Feb 2026 15:35:01 -0700
Message-ID: <20260227223504.1162421-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260227223504.1162421-1-csander@purestorage.com>
References: <20260227223504.1162421-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12480-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 4DD991BEB98
X-Rspamd-Action: no action

A subsequent commit will allow uring_cmds that don't use iopoll on
IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
setting the iopoll_completed flag for a request in iopoll_list or going
through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
io_iopoll_check() loop currently only counts completions posted in
io_do_iopoll() when determining whether the min_events threshold has
been met. It also exits early if there are any existing CQEs before
polling, or if any CQEs are posted while running task work. CQEs posted
via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
against min_events.

Explicitly check the available CQEs in each io_iopoll_check() loop
iteration to account for CQEs posted in any fashion.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 46f39831d27c..5f694052f501 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		io_move_task_work_from_local(ctx);
 }
 
 static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 {
-	unsigned int nr_events = 0;
 	unsigned long check_cq;
 
 	min_events = min(min_events, ctx->cq_entries);
 
 	lockdep_assert_held(&ctx->uring_lock);
@@ -1205,19 +1204,12 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 		 * dropped CQE.
 		 */
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
 			return -EBADR;
 	}
-	/*
-	 * Don't enter poll loop if we already have events pending.
-	 * If we do, we can potentially be spinning for commands that
-	 * already triggered a CQE (eg in error).
-	 */
-	if (io_cqring_events(ctx))
-		return 0;
 
-	do {
+	while (io_cqring_events(ctx) < min_events) {
 		int ret = 0;
 
 		/*
 		 * If a submit got punted to a workqueue, we can have the
 		 * application entering polling for a command before it gets
@@ -1227,34 +1219,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 		 * the poll to the issued list. Otherwise we can spin here
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
 		if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
-			u32 tail = ctx->cached_cq_tail;
-
 			(void) io_run_local_work_locked(ctx, min_events);
 
 			if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
 				mutex_unlock(&ctx->uring_lock);
 				io_run_task_work();
 				mutex_lock(&ctx->uring_lock);
 			}
 			/* some requests don't go through iopoll_list */
-			if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
+			if (list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min_events);
 		if (unlikely(ret < 0))
 			return ret;
 
 		if (task_sigpending(current))
 			return -EINTR;
 		if (need_resched())
 			break;
-
-		nr_events += ret;
-	} while (nr_events < min_events);
+	}
 
 	return 0;
 }
 
 void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
-- 
2.45.2



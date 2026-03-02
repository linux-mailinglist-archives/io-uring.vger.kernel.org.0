Return-Path: <io-uring+bounces-12523-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFF4LvvIpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12523-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A444A1DDCE4
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 30736300B479
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FDF42EEDF;
	Mon,  2 Mar 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IX543Idp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07D942883D
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472565; cv=none; b=lldmJrYzhQiQ9EmmXVmnd8aS5TjF1z67YZ7TzZyqyfmC+5e6C1cXKqywF7e0qTOqZUyFVC4ptByz/nC47mHTWvXSGTn9zMRVRKJ4E2hZAW859fpoYHwLiI/JAHQjhLnAQ7XyqZFhHlFwVWkOmt+29UdcnKSzj0eP6jDXg4DTqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472565; c=relaxed/simple;
	bh=EHWetMLtF/7h2Jzc9WukOzl1UiPE5W/f2SGGcvcIhqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbzBvQAySB3JxspVquTMqK+juAF82izzLUeU/wljDYBIvwFLQsENVMR2y7ZNsuAyOnawhKXpd9EimrRXUzMweDpnUeqIQ7K+Ij81j62M9V246ems67Y7inYtGrW2w0v7X9aKNsU78Y4pl/qC2UACw5DBlu0RJlP0cHlP1lmsCXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IX543Idp; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-c6e18da0f82so259592a12.2
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472563; x=1773077363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJYfmLiCMCsowVS6yyBvopz5p0Wjd6fpqKLBR9qiyiM=;
        b=IX543Idpvg6IdhRShudCrNaH9AYqWbuEJe4zU+fFBSBzVZ0imoaSD5Iy+f93AJR87w
         JB9o397S8WwPnUL/2c6uJgCyYe5/mKIpsoe2736oKt+Wh3ekV7EkMD07P8peCVyRcEa1
         aUMxj+J6Jz74Xlz2eSX8mWWIH7cWbwtEqpplg9lDr+UNyZ4GUUEvfU7SW6wc/d5/3ya0
         sAngLNmvUZnjSMc/QZq8+V7anfYIZ+h7qZiHU7dCmFDTcUJZUXXo6F8cnxjadcGPzf+E
         WsJShp1KP9rOVQqf4+dhK3F+T0Q2VeCfReqaZOhM8bP3yTQbjWpuvPzCFIWUJQinJbEg
         WaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472563; x=1773077363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UJYfmLiCMCsowVS6yyBvopz5p0Wjd6fpqKLBR9qiyiM=;
        b=BALWG3kP2A2QqteYuEuj2EIoQjdfInhmG6yxEuhI7K67b63UghK4dHzsSLCWVAxpNN
         xi0w4NBcLB+sbDB9P/Bas+0cpjqFEe7SILAgMqu1QtDwULR44D665aPF6D4N2Xq/EuIY
         BB2+/n/bgRSbnPlcaZwjssYHEBSkUvnKbofUKp3u3sQ4t22im0DAW1nFVdx/lfF9v1c0
         WUmGh4jffTVNHVH4OaUyVDMoXaqQvuk8eY/mppjEOERIoe+3TIUpzzlZdWwrEnLBWJBL
         0g1PdQqGJ3X/hmhIBHBpjGByCQ+uSw2jhRxQKUiq+fEmNOt8WBmsaK8NDGU1J+7QMtBW
         vwow==
X-Gm-Message-State: AOJu0Yz0+4rnYlHc4AtGToND/i696gwIsPtMfz7UpV/kDG4yvgo3olWH
	E1CHW4ex3a7hSKX/UN5CCjJGpS7uUmsgnHpCaEUIxR0AGl2wY+ssceRbEYYItSFekwWY8+tKjHL
	Y33ko1xAgYthDmGfvJZhV7sn0XbArCxwJgc0c
X-Gm-Gg: ATEYQzz5Vx7a9kjqLDhk1r2ENp0IhJYXvU006Dd0jT/EkEg8332N3y84RPECSKFT2pH
	FwD8NO4Xcd5PnN4bRxlQ392p1jAPpBYBZB51O5sBVJ5Zfh4hsF6Ii7tN/XZQXltTshk+KMtPD34
	7Wy9AJRsj3iB633VotfxH2hnumZJM+qWzl2v4qHCkhiwS4cKd3cupFfNN4pcBjRq2mmEJZ1UH6D
	9dWI+hkOZEGn2DGv9XR2gAjZ+n14fpU0U53nrim1QUhBZhNgiflSD2hvyyE4792TxaI1HTrfV/f
	pQW2zQY8dl1zmjHc5URXcYjtwFMZo07emMJeY8PfZhccv0MTvPEMmaZBBN4PziPTuK64zNYbOAv
	6Rn4UZWcsIbxKAuRjhgqfWtYL8XdMhIqfeEEc2c9ZoGZHzW1Ehp7P7w==
X-Received: by 2002:a17:90b:3c09:b0:359:8d95:4a57 with SMTP id 98e67ed59e1d1-3598d954d03mr2682124a91.6.1772472563024;
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3597c40a81asm921671a91.3.2026.03.02.09.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F0454340506;
	Mon,  2 Mar 2026 10:29:21 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id EDAC2E41FBD; Mon,  2 Mar 2026 10:29:21 -0700 (MST)
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
Subject: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
Date: Mon,  2 Mar 2026 10:29:12 -0700
Message-ID: <20260302172914.2488599-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260302172914.2488599-1-csander@purestorage.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A444A1DDCE4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12523-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:email,purestorage.com:mid];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
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
 io_uring/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 46f39831d27c..b4625695bb3a 100644
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
@@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
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
+	} while (io_cqring_events(ctx) < min_events);
 
 	return 0;
 }
 
 void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
-- 
2.45.2



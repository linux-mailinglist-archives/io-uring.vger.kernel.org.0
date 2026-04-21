Return-Path: <io-uring+bounces-13080-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLasKlaE52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13080-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D1843BBDF
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75BCF305C95D
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07871388E6A;
	Tue, 21 Apr 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0PvJ1vkS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623243D6CDA
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779793; cv=none; b=lAuV96VgsmS/i/lv8PFFkExzPLOfxzUzZSJgMxjjQt8vNS/B9y3HwHk6jOdFzzWp9VhhEsUFPOfZIUO3oR0TOdfm/bzm02w5MSW2cqEr+ydzTD+Bbl8cWeBpemw7NeNcTh77jKuL7tNXR23H3Kb2q/XA1OeFB3jKZdk1hoUS1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779793; c=relaxed/simple;
	bh=NUtkIC4QTXd8Tvc9oo08BtAw61tEWX/Bca02EL3rZRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puV1ELQxkJRjltDOyyWOoQyvtFd0vx4UQfM+SqwKyoVYwAsa9k8N8ST/3xonq8Y6VZxc4p/oz2caw7ufhZm+H5/UcJlErA9DoWH+J5aniopbio2qiicwFEphH9Th+RZGm10fPtGBHZu/6Z88R51hV9m7TTGcGNOmD+DJe7y/XcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0PvJ1vkS; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4243bf9be36so2012542fac.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779791; x=1777384591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FO9ikHJg1h3L2CbJwuN9+q9jPBXYfnACm2PZ143gQXU=;
        b=0PvJ1vkSDe/+PbTriBichkXlYw+2zGbFPP5vBjD4dK1CoEXP7YzDDGITu198zbp4ri
         38I2T5cqbEU1yufrYBI4+lEKxBOdy0K5CEkf9f6eGtX5sAp4wFrbYvnUP1o2HVGozf0n
         Sp7dcAmRxo7CWzFB0jE5H5iYCWSOzXQ9OC2hfvTMj2rUQp4iUbE6ElIxnZG3Ulhb51m1
         owPLutSVxzrD+jVYKCsaUSvaPEm/cUVp3F+IQz9wBQACPZ9zVIcVLo3OL0yuCZ8INkd9
         qaxLdYwXi+Zex6kJanBHMENKryq7kbiB2j68znvRtHEIcGbue0t4LX3R6S7y2DwMwUDH
         w0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779791; x=1777384591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FO9ikHJg1h3L2CbJwuN9+q9jPBXYfnACm2PZ143gQXU=;
        b=D9eqVy1tSNZrDHtQKS7UfBVLuR7sYS/2/4MiPDIiIwGqf5RB1IfeUCy0zJywP9838v
         l5rbUoq6EbthB5V/q7FIm5WeI3zLqpHawMr+uZmSZ5dR84IT/ElLX5PXlgCs/EeYg3fs
         yN+0wIDMDc7Ii6XHlpvzaC24pbPjuZvnH0IO8kNetrPEuQKVxxbJQS9OCfqChdEDoHkC
         eUdCKm7iCWOQWf5koRcbYRkLM5gnlNqdnW0vwBLdvxsx7FrW8sySqjAQcmeodJMzKEH/
         0pUVBFSqE3s0+eHYRDF4EweYjJWTJW+Oz38PQ7ckaZYSozL+Oz9HCt3rclZraFkb6KE6
         s7nA==
X-Gm-Message-State: AOJu0YxLifbSMZzQC8pI58FtPPAJilYndho7mTheryiu5wZwy0C8YRun
	Sm9nW1C8NoPwJiHSP4V4o1p26VajFSwrgW72orpq5DlhIjj/DC7n3U+D7gD2n60QEJ9zzGfWNqz
	mRckEyxY=
X-Gm-Gg: AeBDiev+KgTNwE6zSSTLpx6rVz5kv9g+P5EzTgsC4cBwO7ebYxSwLMAwhEfmUAQ9FT8
	qqVX1TxV0pcqllEqotfES7nv9PixuZ7JTMydKi81CxDIoMj5iw/Ex3sZFKzXlgw3mR411jrNjAj
	kSk+Nib9K3NAArVxJtMOA+kp0tJ+JthfqDZ9chFn5DWlmaYE3RSvphhSG84dzBwRTsK72Gm3uoB
	wOqtg9cBpSUbOPmish0EM56ipFJjbQztbWzmOuHS/Q7ZB0cG3H32XSGhF0TLAtdZOlugyAYO7e4
	gO71BpnIcjObykF+m96xqqhXP79HQO74R93z5Gw8pQFaak9lgqhzpo8hiE2pDwxWF7pNsMtDZ7v
	gw3ShzmCP1w+rL9j1NoQft4dwcclXSJhPhqZUMLhADK39yvQMBTV9wKE5AND1ylreUhHaYK4WpQ
	JqMeult498MvpcqIXN3Nm/mSWdczsPxNg8I0Yu0URM4uZb9+7mQdvdNoaCotJ8uo3YtPblCZZTs
	joRNGw=
X-Received: by 2002:a05:6870:788d:b0:417:3cc0:8dc9 with SMTP id 586e51a60fabf-42aded1cc8cmr10029176fac.24.1776779790923;
        Tue, 21 Apr 2026 06:56:30 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/rsrc: unify nospec indexing for direct descriptors
Date: Tue, 21 Apr 2026 07:51:39 -0600
Message-ID: <20260421135626.581917-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13080-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 54D1843BBDF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

For file updates, the node reset isn't capping the value via
array_index_nospec() like the other paths do. Ensure it's all sane and
have the update path do the proper capping as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rsrc.c | 3 +++
 io_uring/rsrc.h | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fd36e0e319a2..c042054c3b5f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -238,6 +238,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = up->offset + done;
+		if (i >= ctx->file_table.data.nr)
+			break;
+		i = array_index_nospec(i, ctx->file_table.data.nr);
 		if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
 			io_file_bitmap_clear(&ctx->file_table, i);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cff0f8834c35..44e3386f7c1c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -109,10 +109,15 @@ static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node
 }
 
 static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
-				      struct io_rsrc_data *data, int index)
+				      struct io_rsrc_data *data,
+				      unsigned int index)
 {
-	struct io_rsrc_node *node = data->nodes[index];
+	struct io_rsrc_node *node;
 
+	if (index >= data->nr)
+		return false;
+	index = array_index_nospec(index, data->nr);
+	node = data->nodes[index];
 	if (!node)
 		return false;
 	io_put_rsrc_node(ctx, node);
-- 
2.53.0



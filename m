Return-Path: <io-uring+bounces-904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A85A879DB9
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC47028216C
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D42F14404D;
	Tue, 12 Mar 2024 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="tMdL1EOO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DC4144023
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279878; cv=none; b=kI5UO+X/pn55XE6y9Hs1xI4GOR+1HakgP9h6r3ix3Bd3fehwqKoBsetxYIsaIkRCYz45yg+kTboyAHW3ohq+GxAR0FK61LXfEAjDyGfbuE+F5+T7lhIxKlhoo9V6luehe3owfTDPQbBUJx2+Q2YHYqLS5cq7t3ZaoRaiMKuqhvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279878; c=relaxed/simple;
	bh=aE7ib+EBfLAW69AC4DQA5Mh7DG/hbMyPxEWYSNYC1ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYzHzUQgafYvpdblgsevJTOzs4/MXDIfxwDh3GOY0P7C7REiFZD7X9Dsl4H8Kj7vmOa9LdJQw6sQ203drozb4BXuPlMN6p66bxtsidguXdmvllKn0dVcFAKysYkKxIqq8VfDEsdBxEXPa7zSPRADCZSYIPrGzDIcuygXG+z9lns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=tMdL1EOO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6b5831bc8so246889b3a.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279876; x=1710884676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3F8FT2j0FIObJvAopDIV6rSNV9Y4g8SglBip9V0gj+4=;
        b=tMdL1EOO0fOI1kxUdL7tme7vYAR9xvCk55epmnJfx2BDQOVnjpQ58blA6cqSa2NbdJ
         zjTC2kxtBgZ6s4FbNUVOFTr695eOKypA9ouEXudwCPzqcfOrdr9gVkB13DgEaOGCz6I2
         kDisRdIMsDZAiz53mhiA5G57gJOrDwXIOyoh4gOvF6M3tc/cislo8ye1H2pCaDU60NKG
         jNVccKZnaYr2fpS1N0ZotVykklUXi4h9vdnV42we9acxIulDjCKojMKQIdoWeZ+7lJNh
         xvJtAK+jRVN6BHUPQ/zGTYrZZuR3lg6yNUF6IhfA0t81X93rQ6d42dZUQWa+TyTi6MTn
         QaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279876; x=1710884676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3F8FT2j0FIObJvAopDIV6rSNV9Y4g8SglBip9V0gj+4=;
        b=DlMttoPplB/MaE5fBgBMkzTWOtKnK3aaNZOuuftD/TP3fKReR8ihEiN03b21shwu1L
         CM1XR9TskURHwJPdYgkfespsNxicS7VNNTE+Kk1H3YT3LRq+JdHaSvf2DtrxAPapC3CJ
         nbaQ9kHOmAj/NeGAU1VnMLK4Xog79QN9hjY+K19KVUP6hAsT5IO4qPMRb7wqEY3iM2hT
         Y0v/iU34Xcyx7UQjO47O91L6WoHQOkZxH0cdCt7tUVaKCBystMKTCm9x+SjIRH09+cl7
         2sr/L+Pj1njGUefoA71rGi4eHUeNiPyMzxp+9ogGE++YapyKWG2Lr01dJMKSO9lEiAet
         JhZg==
X-Gm-Message-State: AOJu0YyecOFjxPRB8c6y5QVLrqkNbxhsdtU4hEyWWpA2zL/93F5f/GuH
	Ob12aItMfXfzhEXyker709DEmxKQkP+Mof+nxAUyhSqg1Q4ncAK4/N8PWf8pM9L70iOfe8bebMu
	0
X-Google-Smtp-Source: AGHT+IGykgqEeNv3UDI3vBebc0uAZwt30CKqqnPbpoZHLhV7iapU8FXMUGnxzRZGJMPaxuhaI4ymBg==
X-Received: by 2002:a05:6a00:4fcb:b0:6e6:7af6:2201 with SMTP id le11-20020a056a004fcb00b006e67af62201mr712106pfb.8.1710279875807;
        Tue, 12 Mar 2024 14:44:35 -0700 (PDT)
Received: from localhost (fwdproxy-prn-002.fbsv.net. [2a03:2880:ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id p35-20020a056a000a2300b006e6ab799457sm1304163pfh.110.2024.03.12.14.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:35 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 02/16] io_uring: delayed cqe commit
Date: Tue, 12 Mar 2024 14:44:16 -0700
Message-ID: <20240312214430.2923019-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

RFC only, not for upstream

A stub patch allowing to delay and batch the final step of cqe posting
for aux cqes. A different version will be sent separately to upstream.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d8111d64812b..500772189fee 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -205,6 +205,7 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	bool			flush_cqes;
 	unsigned short		submit_nr;
 	unsigned int		cqes_count;
 	struct blk_plug		plug;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..e44c2ef271b9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -176,7 +176,7 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
-	    ctx->submit_state.cqes_count)
+	    ctx->submit_state.cqes_count || ctx->submit_state.flush_cqes)
 		__io_submit_flush_completions(ctx);
 }
 
@@ -1598,6 +1598,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
+	ctx->submit_state.flush_cqes = false;
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.43.0



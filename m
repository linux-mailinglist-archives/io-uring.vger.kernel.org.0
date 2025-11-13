Return-Path: <io-uring+bounces-10577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE57C57021
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85D994EC21A
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3913396F7;
	Thu, 13 Nov 2025 10:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jYFgmwsm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AD33D6D7
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030797; cv=none; b=OQxxZxoKNloBZvvRDGIQnFRIqreCjUMPzNr/IXPkxHq88MwD3XOnsKg81f+WPtibPGqoB0fEUHYwBPthDUq6OFHhImeUsht3d31J5n95BcH+F7vXubyHRRfZaWg+5u2lTWKe3/KgoSN4dklk7yRmKLISnEbN0WZRU7as98HRtUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030797; c=relaxed/simple;
	bh=T5ARdCmLzDS8EubwDtXv1dlZe11yRBbRU9AjfJTvFOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGeKU0BqRmuX5N8Ldjptc4P8VmWFbTmTf6MaC7dj26ymfIlr84SAcsKGluIrUfsoSIPUxlHz1FBpuF0WjKrHRqNla2hGmArY8yEOcbS5Ng3A8b14kGXfKQvMvZdeC15I1GJWdkQwP45u1muCboD3L89ZLGOrfDTaT3TzYAraKQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jYFgmwsm; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4711810948aso4484405e9.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030794; x=1763635594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iq0DxcVWz5wBoNb5zy8fc3ru217Ai8VYBXV9DxFBjg8=;
        b=jYFgmwsmbLdugetxGccRaUE3xPmSthOhGxbhS9v0B82vC9ucKJ53pDim362qlx3JLn
         QbC+HbQpXu5lzgG9/wVsFPd3STJAiw1J4HaI9b2kJC3CpSCOWmugF6YwKYboTZMxVwL+
         bkBGDcxTErzrAvPKDGRmUtqQ65Oh3ycoQGRHP1zW9QKvMP+cziJHFzw23S0K9HHXc31a
         ndsdA8bOOSlYTN2B40fjDEJLgtuIfnmkTg+1zljksu/S8A4zBDGR/8yU1GhGkgdTFn4Z
         ynaEs3+VzqGE8FUVEjs87ec/1lumwxRzxUm4gHIs/aln2tlKcVWocd2oUiIl2vhQ8CN5
         5pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030794; x=1763635594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Iq0DxcVWz5wBoNb5zy8fc3ru217Ai8VYBXV9DxFBjg8=;
        b=xKWr7nBOliqsFkfj9+ppcbgjFL+sVPa8SimZoQ13g5TY0O04RBT1IML5E5BdGNzNdY
         lqVlJzcdH3rmsh1/HRL3KOzXRtiB3UrgE3XtrYSF+NV9zd5zfm1IMx7Z5MHLKgN74Tb0
         sE+CbifonP8PZNAC+bnRvvz3E7Rf55CmkzDFLn/w4rd70M/J7ZXVLu5etRk5CRmHEJsT
         lmSEreihxXxFW8y54zkxvolqDpAdpY3MV8QoUfZFz3xKng4Yhbcv5ZEmXn2QHCzqD7EX
         eCI7Cuuq/1mgsoDdzxq/K28KATStBJ0/DwYnpN/IM1QqOpS1i/0DE1FiDLf8a+xelSYQ
         1h9w==
X-Gm-Message-State: AOJu0YxMzEnMg33tWV+e2kNZGlTb3TN5RMkO6oMu8ntYcuuNiR+qaPeA
	TcVm/xZSr+mRw7qC8zorL9swIbQfGKOZg80Myn4yX0NiJtvZi/AeE85aos0FhA==
X-Gm-Gg: ASbGncvo2i8EldkOX54pYGWu7ZxCteh3q0e9aRv0vP1hlK3w+GsDBpXfR21xWImWSL4
	DUSUgWVlDcZMUHSovylQmrJJVJswdjhG3bTpJlfwZMOXDsMt+YjDzGh+jutCGheup7G0YJbUxDr
	+6kZZWz5RDqlbUyQFp2I3ez1hCP905yH1FW3SIy2v7i1PAKCg+JMuX00FyRe6GSfkPPXlAAJAhU
	jqJEg6IL/yukwTVuvB1lqIyA3c3EoFNDWAPtnNwk6OoMLqSrH3DkLswta3gXO8DmccDUPCQrKAx
	ISclUhJok+enuH5wi6T+xhcO4/2vjY+RVAqHBf/OytQTJV1Dwp8T2XCpClQSJPdX1pT9bgzkaeE
	zEYsgm13QJoozcj+scENdWhdG6xe8+dCeQUeHpKnah9tOHKK2026uvLxInyw=
X-Google-Smtp-Source: AGHT+IFro3r8kn2LP2fzj9CTei4EdVgjCR7DWxoMvhdKbJtgxhI9vxnfI7/7CC67GBSUcS38s6KY6A==
X-Received: by 2002:a05:600c:a06:b0:477:7b16:5f9f with SMTP id 5b1f17b1804b1-477870b3d70mr59519195e9.31.1763030793403;
        Thu, 13 Nov 2025 02:46:33 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 06/10] io_uring/zcrx: count zcrx users
Date: Thu, 13 Nov 2025 10:46:14 +0000
Message-ID: <a33f43735cf25517a377c2c1868296b06dea4e31.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx tries to detach ifq / terminate page pools when the io_uring ctx
owning it is being destroyed. There will be multiple io_uring instances
attached to it in the future, so add a separate counter to track the
users. Note, refs can't be reused for this purpose as it only used to
prevent zcrx and rings destruction, and also used by page pools to keep
it alive.

Signed-off-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 7 +++++--
 io_uring/zcrx.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 08c103af69bc..2335f140ff19 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -482,6 +482,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
+	refcount_set(&ifq->user_refs, 1);
 	return ifq;
 }
 
@@ -742,8 +743,10 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		if (!ifq)
 			break;
 
-		io_close_queue(ifq);
-		io_zcrx_scrub(ifq);
+		if (refcount_dec_and_test(&ifq->user_refs)) {
+			io_close_queue(ifq);
+			io_zcrx_scrub(ifq);
+		}
 		io_put_zcrx_ifq(ifq);
 	}
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index f29edc22c91f..32ab95b2cb81 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -55,6 +55,8 @@ struct io_zcrx_ifq {
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
 	refcount_t			refs;
+	/* counts userspace facing users like io_uring */
+	refcount_t			user_refs;
 
 	/*
 	 * Page pool and net configuration lock, can be taken deeper in the
-- 
2.49.0



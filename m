Return-Path: <io-uring+bounces-2251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9242690DBD7
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A8711C227EB
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4226515E5CA;
	Tue, 18 Jun 2024 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q1rqToYL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B816838DD3
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736420; cv=none; b=u7jU5e0lzKUjCh/V5YiJJeV5dQrIhlnj6UiHgdi5uZUybm4p5/h+lBIK+7CsuDtd2qnrUmoJXc+Ea45w4+JJqkulZl1B62lwWh825EbAIB8mw/jmsuy9pgtS6/f67LyWLkS6zI7kxL8modUfxgj2UTKynO9X9MaTXvBGJRh+VzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736420; c=relaxed/simple;
	bh=aEfz5/xmcGB5aR7lh1cjm2n6fARKlfOXsNF/w0kSFJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmLzvvli64/BmpykAA8TBzpxUTaUD/D+Wy4ztvUu5gWpFCfXFvqJtWVcExBlYJwFrXDt+/HYLBMbyhTRKzuA9nJnM6YQheYFLy3KOGghaMWCcaYD1TP2EnarpZKG7ilpEC3/5PgDJvfidzrT8ah239nExEGn22n/uiNUdbHi3n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q1rqToYL; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-254939503baso408910fac.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736416; x=1719341216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=66BUSeUg9B6VLmlX0iOEJTtO7jrKkbb7vif8muCiPVI=;
        b=q1rqToYLoIUVXd931pr6aEU7s9VPt4oJXnV7gw+xXP69kQVfIhz64o+7CnawkLS8ma
         4j9NcwBziwtJVz9cqF/amgk7lD7wvzhJdMkrSPCT0C4Y1Tz7jaelwIXeA+FS5wUmmP1V
         oOMtK/hHHwu8uuN8dkY77HLcQ6dpyeoycRekiOZFId/JbedlmsNKkVNnLT7e+b+8lLvr
         Z5cxgn7Kek09mcnRw/CSjc0akKwNEsnFoutWchAf2UURF0mcIFrwOWvu9rCsTJDo+Rvh
         Vz6Z3kwa/GOWE9pULfCZwBzwIzOYaws4Ejx34Arsetr9vwaQ90KvvGQMhfx2NbxVKBIB
         hBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736416; x=1719341216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=66BUSeUg9B6VLmlX0iOEJTtO7jrKkbb7vif8muCiPVI=;
        b=wXx21LRuX6sMc0c5Ve36CXoFcLzyTsf2MQLmkwaATeVrXW6TXw0Mbt7TfB3/mWdFOr
         IZlEjAfkFAW2iwo6kVZioaCFYp6+pxc88JM69FZilqw+uhG6gpqp4SGBGF/QFLJW/iUa
         WQzlJQUDsbHMiIaAdjQZr2ciNPdQPo1yj/GosGGFJVaehw9L4YvrHP+NOyX856eOeIX/
         AJtsmXBBDhO3+O3rSJV2aQiA8wAyWq2PGaVsYNotyGsOve2D86NDQKu9aIVw5sAzOP6w
         uQMCAa3eMViN9NwSw+quZeVKW99JCgTEvY8Fg83TUd38qmEHSxZUmVzZpOz+HuDiOhLi
         Zk2A==
X-Gm-Message-State: AOJu0YwqjOC1HnUfP8dng3G30Z0Qqdp2AmfrjIknu9sD4obx1z2hpgUK
	YKzp6+tatyQqCEtojxwVdjcjUvwkL42ChSHo1bYjMTaJG6GeFsgzEFRRlTyVSa3vNMS6obVlgRz
	r
X-Google-Smtp-Source: AGHT+IFYWEPhW6OwOhEsEaH7ko37rvEX0rhQYp+wv1IFgdmzX6AH6KaHNTOzlhsq3ITkIKBlUBYYFw==
X-Received: by 2002:a05:6871:14f:b0:254:cae6:a812 with SMTP id 586e51a60fabf-25c94d8a94emr680853fac.3.1718736416422;
        Tue, 18 Jun 2024 11:46:56 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567aa5e68asm3297475fac.30.2024.06.18.11.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:46:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: use 'state' consistently
Date: Tue, 18 Jun 2024 12:43:51 -0600
Message-ID: <20240618184652.71433-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618184652.71433-1-axboe@kernel.dk>
References: <20240618184652.71433-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_submit_flush_completions() assigns ctx->submit_state to a local
variable and uses it in all but one spot, switch that forgotten
statement to using 'state' as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d10678b9d519..57382e523b33 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1390,7 +1390,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 	__io_cq_unlock_post(ctx);
 
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
+	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
-- 
2.43.0



Return-Path: <io-uring+bounces-2563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 428A193B032
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1AE91F216C8
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66C9156F5D;
	Wed, 24 Jul 2024 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOXvp2QS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FFD155C88
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819767; cv=none; b=WrELCfoX7Qcvr+r4+VJv+uionlz6jJ3yIJO1nqdVfqXtNrODOYp+T1Pzw20bzr+KtqXXgkYlzbNx2iTl8ONpRiTxx08+jcsNrnYgncz+RO4m4Prsf1NHZlxEw75LVaeWzXXao45SbqM0vjS+xKxqfUXdqkMCsSAAbrx3G5JEhno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819767; c=relaxed/simple;
	bh=05EpxvT1cTYIgY/t9g4gbpe2wKiIfso/7xdZWHyZpBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoH0ViQhf2EDDKtqngWr4mAyb/tAmpFxQlufW8tPB/WoVg2hT8rmY8qzD3CACam95nPfaMTpAI/7UQIrtoP+Q+6wSuFyF/X2VLWBJ5TQ2fCuq0rborK4H2lkQKiWKu1YaDjD1j0F+v2shTrLqiQQRkSkIiytP8KRs7Bkv2FBXbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOXvp2QS; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5a156556fb4so5892971a12.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819764; x=1722424564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gOWOrFeYLgn3gX7zaNQQ941x9glpLybPAboBIfEaVg=;
        b=bOXvp2QSoFERMxthHeaM2BhrL2wvzcV964ziGhwgdl0oXk8VozzXFJPVrJPZWTCEKd
         J9TVFaakbma83nZYmGiQv5rv1RYTfFvnYBaqxA+QofcUKTiLNAYHc4ZAZVDHPHO0VuV4
         YplLmYf+r8+LfRWNp1m25jhaPeFgwCtO2xtHTOiWyBLj1I6Jr2sHdFspmoAcliZ7lQ5y
         B4X8HH3rSuRLxQCDwfS5T0GE1SwQcIRXpUCHs1F6ajVXa27mm4Q9bPwqGji/nl4TVX1O
         D9vcG6f3hqujmm8OLlqlM2HYxRPeF+oM7w29ZyvMbhn9U77wGS4yHd/5QK4j6KKcmzZD
         J7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819764; x=1722424564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gOWOrFeYLgn3gX7zaNQQ941x9glpLybPAboBIfEaVg=;
        b=jaCN2daSiFxsJeiN1/jSr6Hsygx3vmlFfc3nJglLPs0vfvpI60WqcLmnzoX2EiBzYS
         w1gkTknVp+khx+v9C4+7iZxSz6XJqSpbRkWbX4jRMbRx/CNl23I4m3nuknmo3JwwV2vF
         EjQ7nxpq2oNzpDcNeCsoAJdrFSictMgOyiXUHct/UwQZH/7zAnGnFoJzHLGXDurrPeuC
         Z2te/bY1ZiNLfwl1B1vUJnFs8jcTojvKBc1VwD3yWozGGyHOILQOb1bQTXaqPWhDxcDN
         jFAg45rdhkEdhvZTOKwwFj3ezIzPClYJVMoImg0blUiyFxWbcF/wLs1K/IC7QgYVAxwY
         YweA==
X-Gm-Message-State: AOJu0YzxTM/Iq6mYnkwpFPKkvbywXivtKu+zeheR6vCkhjGSGxArlU1V
	9YZm9BDo7dC6VQI+AR3KZ1LULjX2L0vxfK6XI7pABh9IS1NTCLl+Ufl+Xg==
X-Google-Smtp-Source: AGHT+IFrmRRvnjKmcNxIc2XRzV44esAikkNrC4VT2HD6OJRaqVy36LPyLno09N7FadspzKpmr2cg0w==
X-Received: by 2002:a50:931a:0:b0:5aa:32bb:146 with SMTP id 4fb4d7f45d1cf-5aa32bb1193mr2490845a12.38.1721819764129;
        Wed, 24 Jul 2024 04:16:04 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring: don't allow netpolling with SETUP_IOPOLL
Date: Wed, 24 Jul 2024 12:16:17 +0100
Message-ID: <1e7553aee0a8ae4edec6742cd6dd0c1e6914fba8.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_IOPOLL rings don't have any netpoll handling, let's fail
attempts to register netpolling in this case, there might be people who
will mix up IOPOLL and netpoll.

Cc: stable@vger.kernel.org
Fixes: ef1186c1a875b ("io_uring: add register/unregister napi function")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/napi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 762254a7ff3f..327e5f3a8abe 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -222,6 +222,8 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	};
 	struct io_uring_napi napi;
 
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return -EINVAL;
 	if (copy_from_user(&napi, arg, sizeof(napi)))
 		return -EFAULT;
 	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
-- 
2.44.0



Return-Path: <io-uring+bounces-9565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2108FB443EF
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFAAFA43984
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 17:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F72E308F1D;
	Thu,  4 Sep 2025 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZnpDsrsa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E222FFDC1
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005753; cv=none; b=JACFLTGhqaEVjslGkcIjulhQf8xQVIaCutmdji26AF2h9uLBof4FQmUb8mO5OiEBdALqz2+sYb9p92vm0n/sfsFTnRxNcHKJRInbtdiCD/HMb74yaJxB6vt2JNNglTFVkA62qIQ0wPscIteVGiBkXNOGiGLigEUGKZbPIQo3ycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005753; c=relaxed/simple;
	bh=vT37VwGjZOyCl9u5Iz9sHTvtTUWCCe6Xb+1IziJLUvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZbIQ3BGS5e1Z81vcQteP38IYnLNIzXbzj+GWLWPm3tpqQBuf6OZ3/bnfbPdDp0BSuLbeKVjJe1L2jIg+6ropSdxPMt32Nw824PLRnhxsITG4Y0slLfdgcl5Le9L61v2Ak4bDBYqjy5NSfjejKQm/IrRJVE8a2GnCkJ5RJiT3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZnpDsrsa; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-3f6619ff909so956065ab.0
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757005751; x=1757610551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/lOOvLhOLy/sorN2ba6lIemJd4kQXZprLIftfp53Us=;
        b=ZnpDsrsaXpvWZv3b124pn4oiL7gSI/w82Uz/LGZFyuqm+ep6ct7HYyZ6usDyXL5mXW
         PPiOz9zg0WSCoOf36PZRSE9h4ZbF+FAPxCKsaAI5FHFB1ragooP7nDkVNe807mT+qzrN
         B1+anz1GeHteYZ3CFTHOUqBvMTXVyYp1tjvAtPsetxYm1A5/BaAgSnuG6QjHYzMBAKAk
         0yvNxCoWTAo0sL4CrfHEyfW99R+MaJyL2q3HzluTYcoBhL+uLtzUU2YImwHvHT9SG/gp
         ut4eQZkluHsGWU7gPVOm29hfFiYq+JCPFrLOqQyArxPdbLY1l5t6ChP00geYUFCS5Xqg
         64mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757005751; x=1757610551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/lOOvLhOLy/sorN2ba6lIemJd4kQXZprLIftfp53Us=;
        b=qgcEGqYZuTkyiCR/+Ro5h+KEY0mbhN0C/FrsCjHX0qfS31IPWzupVAmETUuxeZATJ8
         JyfAb/n1gYRTrphbwUPqRcjWYAFpGn9rIJIRpoRuvemF3LQs/ItOcITjZp/1bawhAubQ
         BmB1thWyQ1QH6hkFGpSJh+j8dZpx+NbELguQO5c5UFQhbd9D3gMcUlY/bfJT9+fmCUwE
         WBNxohoxOPrTtbSkBaTbmdP/7HkOQQnUMEejd3CtOzvl9WAluSqq3zahdAReKxPWaDLa
         TNY9d1LJltg084pvOVohDczsLQbChjQutEVmae2m0FZYq2BoXRzrdOJ76QozR6VX1FeJ
         dEow==
X-Gm-Message-State: AOJu0YxkaFmcC0qjmCLOlBlkbpq5No++r5VnHQwhY7lky9fSgW4zH1uo
	26WPDwwH1+SHq65DnavsG/6fzX7sn0iZiCChty4ko+c+1jxGbgstKg8L4RH1LO54Qxi7YJQc0AR
	sU8kWh5JTiw3uhoaw3x7lSDASeGeVyPlGYfng+EWfTkU8DL4ICiFY
X-Gm-Gg: ASbGncsEm7vOG0xUFSMeayTMOf16i4UMCIhg+UQN/Flkq0P06sjC++BtoMKt7LQSp90
	x1XO/1hc7etk8JY8Qp34Pd3sVCv1VVTpa2GcgKyGBKlhVL7fa1Sz7GnvohhSNmmGhTcgHjIfOYX
	YXX5Glj/5+bBPwBYUhOJOFgPBs0yvN/zJEcAxPhwVYN2ayw8s1vj9vUkIZAf06jKAp1mL6aQqIF
	sTltY4SZ7+rQPNNyY18cOR/TVA5SYK82fljX18hz5br3xK+0MDA5N/fzBkzDe+OzgpuGKsyPF64
	7krcgB1dMGRnTjbDQWuMXcZH6kvVWM+OYV2uyg35voxKFv0rbT5sYFonag==
X-Google-Smtp-Source: AGHT+IEh2ch4vPTbD7B4ea3OkL8Zr7qiW3UvLkYFSOoyzG427qJeG+QFN0271n1nE4+KifsvKAMaYpGErWYv
X-Received: by 2002:a05:6e02:174d:b0:3ee:34e7:e099 with SMTP id e9e14a558f8ab-3f3242eca9emr137910435ab.5.1757005750796;
        Thu, 04 Sep 2025 10:09:10 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3f3dc763281sm12200645ab.5.2025.09.04.10.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 10:09:10 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 864A0340647;
	Thu,  4 Sep 2025 11:09:10 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 73D5FE41979; Thu,  4 Sep 2025 11:09:10 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
Date: Thu,  4 Sep 2025 11:08:59 -0600
Message-ID: <20250904170902.2624135-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250904170902.2624135-1-csander@purestorage.com>
References: <20250904170902.2624135-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ring_ctx's enabled with IORING_SETUP_SINGLE_ISSUER are only allowed
a single task submitting to the ctx. Although the documentation only
mentions this restriction applying to io_uring_enter() syscalls,
commit d7cce96c449e ("io_uring: limit registration w/ SINGLE_ISSUER")
extends it to io_uring_register(). Ensuring only one task interacts
with the io_ring_ctx will be important to allow this task to avoid
taking the uring_lock.
There is, however, one gap in these checks: io_register_clone_buffers()
may take the uring_lock on a second (source) io_ring_ctx, but
__io_uring_register() only checks the current thread against the
*destination* io_ring_ctx's submitter_task. Fail the
IORING_REGISTER_CLONE_BUFFERS with -EEXIST if the source io_ring_ctx has
a registered submitter_task other than the current task.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2d15b8785a95..1e5b7833076a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1298,14 +1298,21 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
 	src_ctx = file->private_data;
 	if (src_ctx != ctx) {
 		mutex_unlock(&ctx->uring_lock);
 		lock_two_rings(ctx, src_ctx);
+
+		if (src_ctx->submitter_task && 
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
 	}
 
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
 
+out:
 	if (src_ctx != ctx)
 		mutex_unlock(&src_ctx->uring_lock);
 
 	fput(file);
 	return ret;
-- 
2.45.2



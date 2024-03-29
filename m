Return-Path: <io-uring+bounces-1339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A19318927C6
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 00:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08AE41F224FC
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 23:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6B313E051;
	Fri, 29 Mar 2024 23:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f2S+/Cuh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84B64B
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 23:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711754632; cv=none; b=F9HR2vsXDbv4KcJybjEEc+pgodpo1yMsdGS0PT+0dOOdFIrDJ2hzxcHxSETcheIDBJ6EWHrUmYQzoH8LAj2SNe6ZzRSDuPHca2dS3pf0PQKl81E+Lmj6y3NDXDLKuRrRoXEWYRb1nC2fQA2JODmkyhlti+Kc1UHRb+YxUsLOD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711754632; c=relaxed/simple;
	bh=sJ9Oi2xlS0XZv8Wj8PJQacK2zM9a81HAFShgjxwdEHo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Tu7MP4T8Xx2RJXOUz1giSM9gEnqXiPmPn2QlonAZIPw9Y8GfrUGbA7Xkykx0os5A6yiUnjylxmSBO7CRtEdqCe9RO33GqSeIC1RX7A+CTxlF0ad3BAOcvLzygqnALHygxO+D6+U4F+zveaYL1Yrm7uyIxucBA9JqGx6BD/18Xng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f2S+/Cuh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a050cf9adfso494237a91.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711754630; x=1712359430; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kH5sG4rfP1eCel3jPEdB9jOibgKIq9v0Xqkw3sLhumM=;
        b=f2S+/Cuh269sgacJCnZwMSgC6iy87pixio1VhKjwaOW2UwJ6ub/IPm4hv4NxKAm3GZ
         kb+m2c7+coxFWyXcfcwHQ8J8pQhuXUp7v7DEbiwUqYxRv1Ujdi3GceBHAaPYif/tZ08L
         2S6rQY72uz79+poRFhSLuDuDWn3ZUHydFe0+uscaM4mKRg63zf3S+WF7JyJpCMRmsrUS
         aUZCiLTmb5KGK75trroJwrGkQOsNt0HlHPctt3GdVWvalYjYS9MOhpthnT8Thsq2nnbf
         p6VQJix0+rcj40+BtFEKD3Rt3XKswIuZUNL7C6/J1JLFWsmPXItNxw32BxST2twlNmT3
         XYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711754630; x=1712359430;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kH5sG4rfP1eCel3jPEdB9jOibgKIq9v0Xqkw3sLhumM=;
        b=NceF3be5iQ76hIdCUsqPOvyEi9Kam4+7njTt4JcgG/roFusZ+efy2dZfkUrYniQvjy
         fIwj0sEcBooZPPiRefTyvO5g7HyLaRkjxDP1eQ+Ljjw/pHWwg5cILBaZHpdx7Hq4Effd
         gOoP6V+wuwwS2cdJuvaZe9jyrM/T53vr0Z3ofiBQJXka3j/AqDAgdG/dgxw6rlbksDA1
         vdmyn+5qXjPl5HmHD2jgWJcoY5E6zc/BBut/S2ytE3HzSZPMCX7cTEOLCaNYhGloMVFh
         QGrF4siuwI/vgdyuUnQ807WFYOPXOSKZojfPUajHLLMaLSnY81QQsBQO2RIZEr8XUMkM
         XJpA==
X-Gm-Message-State: AOJu0YzwuG0KApQHLUASI77baM6kllcGfwav0AiVi0KQ+pGo07u9+0t/
	2BW0XPese9FlXfFPVbbBEK3mHcopZ/uEc9jQsKIyucrKA17P92Cqzxu9YxxHu2Miqs0l7dVTR1j
	q
X-Google-Smtp-Source: AGHT+IF1DBr0u3vkwK26pn0M124ZSkrZba/KrvA4gDw1GqZ7ciRSOfkTpsdQ+INCyGZ8Bf/GepSMfg==
X-Received: by 2002:a05:6a20:72a8:b0:1a3:c3e6:aef9 with SMTP id o40-20020a056a2072a800b001a3c3e6aef9mr4005495pzk.1.1711754629892;
        Fri, 29 Mar 2024 16:23:49 -0700 (PDT)
Received: from [10.46.44.174] ([156.39.10.100])
        by smtp.gmail.com with ESMTPSA id fd37-20020a056a002ea500b006eab6ac1f83sm3537607pfb.0.2024.03.29.16.23.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 16:23:49 -0700 (PDT)
Message-ID: <111fe139-e3fa-4d0e-8388-7c77e97d3a53@kernel.dk>
Date: Fri, 29 Mar 2024 17:23:48 -0600
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
Subject: [PATCH] io_uring: fix warnings on shadow variables
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are a few of those:

io_uring/fdinfo.c:170:16: warning: declaration shadows a local variable [-Wshadow]
  170 |                 struct file *f = io_file_from_index(&ctx->file_table, i);
      |                              ^
io_uring/fdinfo.c:53:67: note: previous declaration is here
   53 | __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
      |                                                                   ^
io_uring/cancel.c:187:25: warning: declaration shadows a local variable [-Wshadow]
  187 |                 struct io_uring_task *tctx = node->task->io_uring;
      |                                       ^
io_uring/cancel.c:166:31: note: previous declaration is here
  166 |                              struct io_uring_task *tctx,
      |                                                    ^
io_uring/register.c:371:25: warning: declaration shadows a local variable [-Wshadow]
  371 |                 struct io_uring_task *tctx = node->task->io_uring;
      |                                       ^
io_uring/register.c:312:24: note: previous declaration is here
  312 |         struct io_uring_task *tctx = NULL;
      |                               ^

and a simple cleanup gets rid of them. For the fdinfo case, make a
distinction between the file being passed in (for the ring), and the
registered files we iterate. For the other two cases, just get rid of
shadowed variable, there's no reason to have a new one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c   | 4 +---
 io_uring/fdinfo.c   | 4 ++--
 io_uring/register.c | 3 +--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index acfcdd7f059a..a6e58a20efdd 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -184,9 +184,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		ret = io_async_cancel_one(tctx, cd);
+		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)
 				break;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 8d444dd1b0a7..b1e0e0d85349 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -50,9 +50,9 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
  * Caller holds a reference to the file already, we don't need to do
  * anything else to get an extra reference.
  */
-__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
+__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 {
-	struct io_ring_ctx *ctx = f->private_data;
+	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
 	struct rusage sq_usage;
diff --git a/io_uring/register.c b/io_uring/register.c
index 99c37775f974..ef8c908346a4 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -368,8 +368,7 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 
 	/* now propagate the restriction to all registered users */
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
+		tctx = node->task->io_uring;
 		if (WARN_ON_ONCE(!tctx->io_wq))
 			continue;
 
-- 
2.43.0

-- 
Jens Axboe



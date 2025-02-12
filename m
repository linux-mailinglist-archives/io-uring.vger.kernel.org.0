Return-Path: <io-uring+bounces-6366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9DDA32C50
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 17:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECD0416162A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 16:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFD9253F07;
	Wed, 12 Feb 2025 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QRV9p5ip"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DD6253B5B
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739378894; cv=none; b=dtY/88eqAgI4TCMXLze15GXWOtToViO8lGcMDGzTEzvTk0skZHAr01bFpcFdYyUx00p7shXQDBeuZtEHNk6iOUgA8BjIrvs3b3ksDX26B6MizBySQWyoVVkn8dx4LYTEuNt2xzhk9BHCjNKhQYrcIcn+mJ/0EVvoDHCpjGpvfuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739378894; c=relaxed/simple;
	bh=Qjj2QMAanOTsP0E6oofq18bt8+1l7KG1JEs5PYmidSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XGDJlVWEWecHF5A6mJQVoAJ1sumlB9aI4UdPYFWvZxA59HRlag9163PTMDzTzDmnRKpDUrqTUmgK/rluxQx/ovKCY0TitZWHgu5mTXEZ7QjUnzFg8eXMSHRDnzlTQRhnzNN7pC3WB5QtvpYi5aJ5JuROVoctY1CdUkmG8dRSuLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QRV9p5ip; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-3d17844d042so543295ab.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 08:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739378891; x=1739983691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/f8bv9QH5EQJaX+bBU+s7mbL/Dwx7/Hsr9UPWP0QZpE=;
        b=QRV9p5ipIFEB95u8jtDvzsCTTD74C4IvTaHBfmdEjjA7gBtrNX071rsnLtK0kdkWlf
         rDv5sy5dSMW3Y0o42LdWRscCAEhLK8tc9+aOXAXuym1G8jkxh13uesdRsHjtyreBEOj0
         noJYYQR874ZcBRtF+hzOElKRCEXwZQ3V+GVHmJNY+a1Jgj3JOGYOg/1ueQ/DeUxRGyKY
         9u2KQgbZiuTNNc949r+MX4TCtpNRQnPfmFZH5DACMoT5+kYncNATCvpQVDNAhbixE6aQ
         2TsXDm29G6D+HKgSMapTfr0YJXtO1UsgAIrCuBrwo6j0pJO/Yu4YNU5Oy6PxkaKodus1
         DDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739378891; x=1739983691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/f8bv9QH5EQJaX+bBU+s7mbL/Dwx7/Hsr9UPWP0QZpE=;
        b=iXZtvHMVnuGdywjwGIsDJyKU5Jc+LGdSL3276o3BMzwGfn9edvP+zkcbFt1PqaOfza
         yyrSVvdV6pHTl68yKp+cWl+H5ZT4d9/ntQO8DCXLnLpWvXxW2ycZWCRPlfpN4tKBgAR5
         gz/90huPxFCcaETLosFYW0RKC1f7a+WPTG1s1xeu4UkV+KSWvBSQuOAaN73z7rMZHHpl
         VQBYPGXDzcm1TXviIOLrXhZnxavVTUjX5bJ2zA33fHULGOYF5O/FntzCSbcVveZsOeZX
         5xjodCIv/12ZZ5cVWdmrpGrFt8FlxBKsGHjSMVtyKQA0eljLRVMsJXTtCDZy1tntab9Y
         ARHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFyMI5N/vZ9Ai+SK+KLHiR2CbWg1sf/UE0WWfV5pGve1ZZ+0CIWUj/pST5SEAoDbtiT+x7qJiM9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXitnW9YQapGMU3odTbX1f3XkFLzLV95gBxGX06IiHiukUkaeQ
	9NFfiXcLgdbtknl7lMH0JRNUqkI157KFbFVBeIwATehThCens1jCsYeuRM7vJIc3M9pNt2M4y10
	HcZTEkVftY7bRxfjsp2AIImi875aILbQzl7b1FnLTiv4ZDQSF
X-Gm-Gg: ASbGncvakTktyEyAjwpygEnqc+ofLJfVtmnOcq3ZK4dsfhpHfexKQ5WkO13zXplg7i+
	KZFHO1BS3wZ2agkp0DDUZqoTsrhOz2OlQXEjs08p+5xrcNvEnxsywfXMIs/UIHKfbi1V5olze+o
	lBKEf8SwVRFeq+lnI237i4CJX/g64fu9daYRkSoG7hUXWBLJGD6fjMrRAmW43wKc0i70uGwh8xA
	MISc/w3UK/inALbj5Ttb9xIfnFrGyvZed7IDZC3WQ6Z6bIU4KvQ3JgxA/RtH8Nxqhof8qgiWke7
	QxyjLXeY4FVRCOnvsg+tuuI=
X-Google-Smtp-Source: AGHT+IEnewgTPigF6UFFH5AistoyMlBljeF+wcBNbPlqftf8XpROgWlV8W2TEoX8mejN7RP6z7fc3JFqUo0J
X-Received: by 2002:a05:6e02:550:b0:3d1:8bf1:46f9 with SMTP id e9e14a558f8ab-3d18bf14b8fmr114495ab.7.1739378891173;
        Wed, 12 Feb 2025 08:48:11 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d18a9081f3sm150405ab.34.2025.02.12.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 08:48:11 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F31A93402DD;
	Wed, 12 Feb 2025 09:48:09 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id ED64FE416E5; Wed, 12 Feb 2025 09:48:09 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: pass ctx instead of req to io_init_req_drain()
Date: Wed, 12 Feb 2025 09:48:05 -0700
Message-ID: <20250212164807.3681036-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_init_req_drain() takes a struct io_kiocb *req argument but only uses
it to get struct io_ring_ctx *ctx. The caller already knows the ctx, so
pass it instead.

Drop "req" from the function name since it operates on the ctx rather
than a specific req.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8bb8c099c3e1..4a0944a57d96 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1995,13 +1995,12 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 		return false;
 
 	return true;
 }
 
-static void io_init_req_drain(struct io_kiocb *req)
+static void io_init_drain(struct io_ring_ctx *ctx)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *head = ctx->submit_state.link.head;
 
 	ctx->drain_active = true;
 	if (head) {
 		/*
@@ -2059,11 +2058,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			if (ctx->drain_disabled)
 				return io_init_fail_req(req, -EOPNOTSUPP);
-			io_init_req_drain(req);
+			io_init_drain(ctx);
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
 			return io_init_fail_req(req, -EACCES);
-- 
2.45.2



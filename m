Return-Path: <io-uring+bounces-8031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA00ABAA07
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF2234A6BAD
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1211A1FC8;
	Sat, 17 May 2025 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkgQBGrX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547271E4BE
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484799; cv=none; b=jxK6Byc2sTEQ4AzucZ0RtVCGLqywM5KSBudfGOVDlR4hSJJiOs781Hin2Hgpoj5RgdZvIUEV8BpISpaNZMxvwdwPDQIr+c3ODctBFoOT0GVxAVUxL307u0m0CUlbqsD9dZwdFpLD0GwDrr1rkjCmgYSJo+naBEkG29ZCJB+Y0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484799; c=relaxed/simple;
	bh=l/g4fRjMXMa5uN8E2H/K8MVq1eXalqdD3eGycWGVAE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7zZtymSLvk7O8JVBIZu5eZpDLl+vd66BynfIyC9uPK5EQKQoaanQevUi1vAV+v/mCnPicWyOZEqsik5xOY2Ujhnli5nA5yrFKm+jBEI7JtcElQpNCy8RdGiSXWfMmSk4gm7jDYTPNQ4uLGjzyBvsHCc+w0IFcyk6zjnnV78ZW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kkgQBGrX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-601aa44af77so501414a12.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484795; x=1748089595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHlSH42UWaSeZAPcKolt6fBqv0gScCWAMze7ps9dAfs=;
        b=kkgQBGrXJRsjZDYhWrSw44MzfuKZJ74Mp/Yvdk5Am/QiReaZ4iNu93DnxefXYgM6Mp
         O9jAp8XXqE3wceOLBS9HnLmRyWqYOBS/BrTS5NWtW9syWhzvj/bTEpjb3ZvXXNzoN4qq
         1/brMy5qiIubwQMTPu/6fTanAkbXCQ38H+2teUGVnWeubChRsdeI2mLU2Fw1WK3NAscp
         opMWuCaSOODuHRkjef8UWtkQ2ZICUsLX0XJVaFfeXpyc5mB9MHsKLCY4BClyFQuR7ee0
         IDCEBGym79MY4KgLnM7u63eNzzliczEAuifK/jY0SVjzyKvgP9eGr1UI8jfBNdt24qOh
         eHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484795; x=1748089595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHlSH42UWaSeZAPcKolt6fBqv0gScCWAMze7ps9dAfs=;
        b=hxGrIr572X+wQSfieDN48SCzXsBvgOek42Q1K5WaHX0KcRiJO5F9Q9EkWxzDghI++a
         tKBfW1nxuTYxi7TkgbMknPpkgTuTVezE+VdAGBtKRu+xxImVTkX7aauUPCcKdD00rduB
         nkdZ+BdWSPS57XoZi+LIrnl1g5y6v8UdSqqsftiMLelSUMyjBpSSNHmJoemtQWxali0+
         TuYxDHBucB7aiqJF9VzB8+MAlcpnfdN3JTp87hSDJRb1k/Can9AnB/8brOcJ952UAv9V
         IYUyHa66QvUMEw0E2JlL07zr6dNMgSqYqKWHSLr/vpDtGJAES58J48lbYmr/IkBmy2lw
         DOlg==
X-Gm-Message-State: AOJu0YxK0tMhyVBqH2Ob+yt2kaqzO5e1NDeSRZ0c5e5XZ4MyLJEK+EWB
	XwjGLbZCdlg3a98HVdRIL2hIldqbKmvMDG3YvMrlAQYOEF36r1VW5ZXD5D9Azw==
X-Gm-Gg: ASbGncvcCFVi+nByNnlOSyDNe/wGv2+nvwnDgoJ7tHa6Sx4JzNnj9r4Ag3wVkBL58o9
	cSL9z0CGZ6fHKliMz4ETY5q8kVUUmEfTKYpzsCGSXxwge0zWteIFOnsfV15pkBhBtICFksB2Ag0
	KbJId6v7zX6XBc/DZFqRGHUckX2sCSNKDHIV5A5YVzP8XUond9x95FjZLyN5bPgvnD7vNfPvfcL
	GUGpR/0iWms7yLcp4TtWDPEUbWqDZzsJUs5ZnIlQXbTqzwPGVke25oCYI/HVKBl8SWNWCIgmm6s
	q9gNE2UX+9dCu9X9FwmghtL7w7lrJY0iIKlqFNCOscwc3j5uSasnk7y9kv6KWkU=
X-Google-Smtp-Source: AGHT+IEvenx8KzjHQN2jSCOB5nlgwC4cgzYnM/l98jYx1A881Rh0aMG1egttYC9QWeOsfDvInF6thQ==
X-Received: by 2002:a05:6402:1ed2:b0:601:acf7:aec1 with SMTP id 4fb4d7f45d1cf-601acf7b034mr582847a12.13.1747484794856;
        Sat, 17 May 2025 05:26:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/7] io_uring: fix overflow resched cqe reordering
Date: Sat, 17 May 2025 13:27:37 +0100
Message-ID: <90ba817f1a458f091f355f407de1c911d2b93bbf.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Leaving the CQ critical section in the middle of a overflow flushing
can cause cqe reordering since the cache cq pointers are reset and any
new cqe emitters that might get called in between are not going to be
forced into io_cqe_cache_refill().

Fixes: eac2ca2d682f9 ("io_uring: check if we need to reschedule during overflow flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a9b8d35349b..2fa84912b053 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -654,6 +654,7 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		 * to care for a non-real case.
 		 */
 		if (need_resched()) {
+			ctx->cqe_sentinel = ctx->cqe_cached;
 			io_cq_unlock_post(ctx);
 			mutex_unlock(&ctx->uring_lock);
 			cond_resched();
-- 
2.49.0



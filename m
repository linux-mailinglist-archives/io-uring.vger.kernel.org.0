Return-Path: <io-uring+bounces-6542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B13BA3AEFA
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 477303A8F61
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DBD28FD;
	Wed, 19 Feb 2025 01:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iu5iX2mM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737321F5E6
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928775; cv=none; b=OwFxSLlOXxbEmfzNWwcR+XsLl42dhKdqrxTfP0wxawWvcqU+4JBz3BlPGRQV1JTng3CUiRXQxCGCyymUU0lBdgoJi4QdibUiYFiLzOVGl2aHKgLyHHA47HC2vnPH0xW8YLj4OAijlr2MK7zZHgrQPEXBqH/n/7OBoOrbT3mVSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928775; c=relaxed/simple;
	bh=a2BUW0yGemiuzi1y57ExoIhorgW61025RCumgsNKveg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVk0R5ZG3JPcX6GmkXb/1FCS9pfjmgdXCxvRogCu1C8elXcz/kjy9IUatYLFRLIWJoDTXzjf9wt2t5hbKxwsujnRw/2Uu3C5bSbgqjE6Y2p35r+1xudeso053o1/Iq5QJTWY5m28Eu7ECAb4S8sUiayUMXmqxx16+W7O7fN/SrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iu5iX2mM; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38f488f3161so1260182f8f.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928771; x=1740533571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oM5mlez0ZqotlkCx2Jg9DzCaQKRsAad/T7OR8Vz+Uw=;
        b=Iu5iX2mMaDLb2+x1ApZGunZJGneiQ/ln8y9XWeCPiFiB4fk3y1dGYmJ/gK6SqeFVKO
         DK6KJAfrgUvhlhOAoKXARelGdIBdFVJMi51eu8oTiq6UefKuBfa9+Tk5IY0YK7eXGfUF
         YP308mCreihdlm5oo4gLSszP/c+qk/Szxlu4GdIBWDGQziITVdtbQOYJ5TOlVF75jxJ8
         6oAUejcRCRTZfDlgWwM5Rd3F8xDsduw8bYho6gzHPWY/eI4+qicMUAbgU+OJzSJYSc1h
         d++I6Tmr5ZiylpT2mKMhFf7KDFyInXvSYqipw0/4ZpsbmuvQ/l8Nl++SiRIoJS0oFPnS
         SMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928771; x=1740533571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5oM5mlez0ZqotlkCx2Jg9DzCaQKRsAad/T7OR8Vz+Uw=;
        b=IAq7sgNNTDPgmwOJ0x5+poojphPx8K15k7CXFH9mHccGo/1OU7XxBpoWfNFJ/ZIiRq
         POwrUdkrz2DzSbMYhUsEnCgEsSVABJXHA54PDJ+dbE4lq+WpktkUwEMbB4kJtVWU+vzK
         pz2m4RnzblG34f06ex05ORiKJ/BS/HDOfB8bVuwp2yeCT/foZKGEAG0jRwNkzOGEr7q8
         h/73bVYfedjeJM3FqcA97AuAST/LD1k+k+qoNKfMLpD7XpFfPz1myNm07z8Ny0/8uim7
         wrXgLE9GZVlAxc1i2faBn9Xu4+ZMCm521EmLiFShQuNu4LapofXYfLFqDj5pcs/nEYpA
         EIUQ==
X-Gm-Message-State: AOJu0YzwzfSD99C8nuRCTYygvnnmUZLfBntTiWZeWeD26V4P1o2ZEkHa
	V8JA4MSmAsWwKwbSQvvf79gDiq89U0oqt9IwySq9hVCQveCMPW3LuGUskw==
X-Gm-Gg: ASbGncuMqsRo1AC07aGkyMnFv5YAr66hcJUmya8U8567NCcDJnLiYXGGmSPYPw0RIH2
	OZ/1YRXZolMtPqgDP0h3DIozBVqS00FhGNKHCNH0IP9IVguF40jlLbSHLmZkmBrMJ9qqKl2bOvu
	H5A4Y2jQuMCCFVf1Ix1oFHCzjVEZWO6oH+VBlyClrPoLZYmxIZUNTMz2mLcRcrOTAj8ZDunMiWw
	lPRkxFeGM9H7RfRPRNh0nhhOCoNzu4JV8H6bP1/ae9AQzvReo0ic3ZP4rpQA/1PUc5uOA1KWBZM
	FiKFAFVwZf+J6WUSzOwKwQm4T4Sq
X-Google-Smtp-Source: AGHT+IHLHRTIStZVvldY0oN5U7H2rJ82+V9PBIGHl2uArUJxNoGlKDM0S1+jEpbyRV1LQkW+4XWTIw==
X-Received: by 2002:a05:6000:1548:b0:38f:4808:b9f with SMTP id ffacd0b85a97d-38f48080be3mr7155399f8f.47.1739928771470;
        Tue, 18 Feb 2025 17:32:51 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8f1csm16617752f8f.69.2025.02.18.17.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 17:32:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 4/4] io_uring/rw: clean up mshot forced sync mode
Date: Wed, 19 Feb 2025 01:33:40 +0000
Message-ID: <4ad7b928c776d1ad59addb9fff64ef2d1fc474d5.1739919038.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1739919038.git.asml.silence@gmail.com>
References: <cover.1739919038.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move code forcing synchronous execution of multishot read requests out
a more generic __io_read().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d16256505389..9edc6baebd01 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -889,15 +889,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
-		void *cb_copy = rw->kiocb.ki_complete;
-
-		rw->kiocb.ki_complete = NULL;
-		ret = io_iter_do_read(rw, &io->iter);
-		rw->kiocb.ki_complete = cb_copy;
-	} else {
-		ret = io_iter_do_read(rw, &io->iter);
-	}
+	ret = io_iter_do_read(rw, &io->iter);
 
 	/*
 	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
@@ -995,6 +987,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_file_can_poll(req))
 		return -EBADFD;
 
+	/* make it sync, multishot doesn't support async execution */
+	rw->kiocb.ki_complete = NULL;
 	ret = __io_read(req, issue_flags);
 
 	/*
-- 
2.48.1



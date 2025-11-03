Return-Path: <io-uring+bounces-10330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C34CC2DBB4
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F73B18986BF
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B83325488;
	Mon,  3 Nov 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R1m7uq4D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DACC325487
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195785; cv=none; b=J6reJnREiGHyG7B/aemEBkCYVsd19qS5W73qGImwMNEcZk0SH4U61R9lH7abPyGaAoKvho0zrgdW5chE8KATreW5TPopQRfLeXwL2xNBd6JcBAjaALd1v2so7I465Jkw7sX+Srks3dOZmrXpNrAKJ45x9eeyaNpBOqRLdvbbHRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195785; c=relaxed/simple;
	bh=vzKSDaw1zFclyAigJv6xxo3jc8EAoTvjteYEoLWG5eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK7NAlP0k67n8NuQdL0vdR5YgwLbVJItz7dNJmdjhmvrMoWosPpKBX7i6WoynwaqxwAAIpoU16SZr53UfFUq0GQwtUtVl1humTKYKnlMnZ0CLOESJ94mx9Qm850HeBDN9a/ExFrqinCnaAWLhLBUhhXJy1FJt3dNqavvcT4Aogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R1m7uq4D; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-9484c29576bso99281639f.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195782; x=1762800582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oDaLu7YVCQ1A6oaAVrgvU0sld2Y62Gz6PvoBNuDm/s=;
        b=R1m7uq4DO7DZtbEjOLZ7KWCr+rW7OpFzVJmdIUEzi8zH4KExd1UEBXvbtJIpvouzBh
         O5pn2hcXFFWVaeICHs6sFVJM2d4wdD4JrRuiyPVknj59qDoUSnZfuRJMVjs4473/GCJy
         gILSDCnH4FqxaXVV1UJpsRbnCI2BvpzugqPVgR/hBuSz98qtGc9bs9V2jWrjQ56K9nzJ
         chG8xZwCZ3ALd/ccIaFNO8mwmL1zxyYUoDSsiHIkmf2keHd0mpbtgbmd951tEfcnBqsq
         wlBE0eTUSYrFCA2aMFRDbJ65nB3db0mQ2PK+UExcdRf3YWrnsfJFDTujLDOtrgWQe5pv
         RmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195782; x=1762800582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oDaLu7YVCQ1A6oaAVrgvU0sld2Y62Gz6PvoBNuDm/s=;
        b=uVBsXimczirNRzrAtsxIXuCKPO2+DBDSYdFy0bUL3qFzPXsaypATQm+HaRBdsSDHQ9
         inwnJSOfgbatraNE/+7b3LSBOrX7hbI82vkAaeuFzJkoSq0eZnmdegZBRNNSHTQ/gDeH
         11YwIqQcVHEvB832be79l8f4NQNRHIGu6CkPyJdiAPwWQO0LFMH4PtFRaQdyy5D26XyN
         KqHAiaa4sz2SQ7Usb+5+Y2Vel6L0lcEOlWfQJcGRRK0aTFKM2sFEDE98s1cCyr4oaxGx
         gxaeYrHJSyLv1szkOluWP26ub0mR8dggp9at8JnMa4rDKt5kU3eOFxj8AObaHtZLxCn4
         lCMQ==
X-Gm-Message-State: AOJu0YyhJvO0kguORjgG+3j9a7b9bmz9uczf4cvz18um3fgbfOZzc0H0
	U/DpfaYKi3lB5tI4YOi4ziLPua216iYHcXf+A5nNp1SslvZsv6618j9HwvhjlJNKuPpVFvxRq1o
	9U9/2
X-Gm-Gg: ASbGncv1TUCd+jJ8cGOtsOwt/v948lMGEev1PNTQ365ZrcDqgojZBNdBfLytfPOCFXg
	mblidHgoxfwc/S8ULn2jNJAuPqHUvxMvRGtWURz3rZEAfBZ7QmmbTlRu1f9fTrdck5hsa51ELkK
	GnJOxVV/tbOtms/iI9P680bq9iKoab0+80HE4Afz+rviocr4Y9x+MroWSEtuYRVvf3NKEBpnwfp
	vsYLeaPf5gimmjk5UAu6l6vUbc6tFtmCziZN4Q/TJmmLWMJroIZrs5c7ZKrzaAghZSbe3DDi4P7
	yjpGPPJ8xWkJNLzRwP0Pb/OO17TOgh3LO32ebyReHXEUHSoMCYBu8GIShzKGfK980SufYyjzA9m
	17kcE8QR9/l6+bqKuX6QWwC5z7JCsES6nXrEIt/ePp1mqnzZw7HWrf6wQtcCbyaF8TbntcQAv29
	qjNVT6
X-Google-Smtp-Source: AGHT+IHl5A0kMiFr7xvAMfgKHK2iu9eUI/aTyAi4W0Aux7iqBxviX88HPt+6GjTI8cPAC+lzmkRFMA==
X-Received: by 2002:a05:6e02:490e:b0:433:1cd2:2fea with SMTP id e9e14a558f8ab-4331cd23186mr133697115ab.6.1762195781945;
        Mon, 03 Nov 2025 10:49:41 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring/slist: remove unused wq list splice helpers
Date: Mon,  3 Nov 2025 11:47:58 -0700
Message-ID: <20251103184937.61634-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nobody is using those helpers anymore, get rid of them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/slist.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/io_uring/slist.h b/io_uring/slist.h
index 0eb194817242..7ef747442754 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -67,24 +67,6 @@ static inline void wq_list_cut(struct io_wq_work_list *list,
 	last->next = NULL;
 }
 
-static inline void __wq_list_splice(struct io_wq_work_list *list,
-				    struct io_wq_work_node *to)
-{
-	list->last->next = to->next;
-	to->next = list->first;
-	INIT_WQ_LIST(list);
-}
-
-static inline bool wq_list_splice(struct io_wq_work_list *list,
-				  struct io_wq_work_node *to)
-{
-	if (!wq_list_empty(list)) {
-		__wq_list_splice(list, to);
-		return true;
-	}
-	return false;
-}
-
 static inline void wq_stack_add_head(struct io_wq_work_node *node,
 				     struct io_wq_work_node *stack)
 {
-- 
2.51.0



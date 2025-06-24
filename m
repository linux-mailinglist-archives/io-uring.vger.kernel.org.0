Return-Path: <io-uring+bounces-8475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA3CAE66B6
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 15:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C75D7AC766
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226D42C08B0;
	Tue, 24 Jun 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULshgYcs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504B625178E
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772362; cv=none; b=Ib26JqpCDtmTMBPSlMxxhTt/Pm95wVtMf4yj5BqZov1qfhDnv03zCsvsp/nYTAnzP/oB2CM6i2yS0oux/uxPLqFQGbRUUta5oAsolExBXNxrSiBk2cfr8rIFMVCohrk8KGZJKhT1kbILQ/pmnzer8p9QuTwPvfZf7p2iuTYerkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772362; c=relaxed/simple;
	bh=g5DrG5B6CWQn8mH5YVlMMn4xsEyMQEYUAhZnaxbhz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEkpMUmoWuD1WI5RLNOVCNE9ZQDs+L4+Xkjxzta+IWahxNEK96u59y7s4eXeKZ+oHyVnCEHc8ddaxUsuMCrWHz4c6eRPGpgfKGCsUETDOVTShdRKcMM/HtKhz+gqz9a7603DW6J1Pi5JDRauaOCxMUdIU3oynwtLNvlJDZRJFBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ULshgYcs; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-607c2b96b29so867680a12.1
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 06:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772358; x=1751377158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQ3Z8YrBL0WrNUUo2ZsYMqAj5yyCgkNx6LzUWXLL+24=;
        b=ULshgYcs1GBd1IYgRu7vWzPdFJQPOnSr8Cx93nL3Z7ne6WQmG+iYFBcI9dHUh4IcHe
         wLsGzUB7JCZRS4huK42IIro+D1HAos9l62kCW14NOgBXGIdAYkBfDMWJMzBkxcB3eHEn
         tKUaAutk9lWSDpnzEMm4NCTLI7Mi4vbqU4TdQ+X3B4wq/gGPnOAVNCsLlqCQ563u+gzh
         nG9Jy2uV+XXE2J3uRYjdbxKFs4J9P3Xodhf/EAC7+q+ntj2GVjnfXQC9X4eVA5mQBkax
         YFAXYfBfbETQvirgrVWz2sZLy4GsMIlos8L6CFzP4ZpIu6QgRXr+vX24KucMaaKaZ4XA
         ho3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772358; x=1751377158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQ3Z8YrBL0WrNUUo2ZsYMqAj5yyCgkNx6LzUWXLL+24=;
        b=w9+VfIQ/XiaMWJrmaE0G2xbapzMyPlWjOQfCsdmtd5fWUW1UwsMHhEOPc4UE9LZUcl
         jKx5hOJDWnc/llAImA8RggGnqSeQWSDnGNrm9xqs7K4V9ewawFMRlTsMAjlq6Zqm8UdS
         trsFhFccmzSrhmvmzw1GRCMNqqeAxbSXVEMwgbvOjSoH+GELFMu7xuJ+LjAP8A3CcEZ8
         rsx27WJ3GHeJTVAx2YRbDi3T7eMYjeU5o++qEv0nopcfFBAsmOXDVMTGPJpH4+ayweJ5
         b7XXKsJoDaUpe3WRaPI/rO/csGEjXsA2PZQwMScO+ILj0DLTpzXse6IehCB2LFo0yYw7
         9X5A==
X-Gm-Message-State: AOJu0YxI+NitxB2mAZO9KciYxkQX0pXR4RpvjQvGb+tpixpwfCDj7hCn
	cFhHlSDvKUWE58nXK5TMWch+p6JNxIpw0K2QR5kVtRw2xEBDmAhT6RVBTOKkKA==
X-Gm-Gg: ASbGncu/9gHg5iCbDYg1xnmFSXHX7mEvazfimOIWrLh6X5u8pyWyxhKagNfpP6ovJir
	UMwJj/OMuWLIsSZuSKIiR4IOmHD8XTE0ItfmvCH1xzF6Pg5MIhLaokS6rO/cPXTUglEJ0pRFi4V
	HFi+NpxL7iwL0I6PM0FEC3iMwC6QICskPVzQ9g774yorKEWl//kL1vK80p62C4WYvjfFeOfQC/4
	w95EvP452VvrJP0xd98HI4SjORuTnPz+w4Muet/JGmH+HDyQHaVyfFqFvWF4SjXIOp+T3xUWRwi
	/lMgR7pSl9LzphRs004tKwuYNr455zRYU7qAmd6bJ+TjAw==
X-Google-Smtp-Source: AGHT+IH2dqFNLeUMrTFndzWaJi0uDAGFFT7zOy7Q7iOSBy/1zxULk5iygIf3YiVULPT9NggDLe9v7g==
X-Received: by 2002:a05:6402:234d:b0:606:b4de:f72c with SMTP id 4fb4d7f45d1cf-60a1ca0ecefmr13765207a12.0.1750772357947;
        Tue, 24 Jun 2025 06:39:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f196e13sm1052892a12.11.2025.06.24.06.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:39:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 2/3] io_uring/rsrc: don't rely on user vaddr alignment
Date: Tue, 24 Jun 2025 14:40:34 +0100
Message-ID: <e387b4c78b33f231105a601d84eefd8301f57954.1750771718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750771718.git.asml.silence@gmail.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no guaranteed alignment for user pointers, however the
calculation of an offset of the first page into a folio after
coalescing uses some weird bit mask logic, get rid of it.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 7 ++++++-
 io_uring/rsrc.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e83a294c718b..8b06c732d136 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -734,6 +734,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 
 	data->nr_pages_mid = folio_nr_pages(folio);
 	data->folio_shift = folio_shift(folio);
+	data->first_folio_page_idx = folio_page_idx(folio, page_array[0]);
 
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
@@ -830,7 +831,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
-	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
+
+	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	if (coalesced)
+		off += data.first_folio_page_idx << PAGE_SHIFT;
+
 	node->buf = imu;
 	ret = 0;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0d2138f16322..25e7e998dcfd 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -49,6 +49,7 @@ struct io_imu_folio_data {
 	unsigned int	nr_pages_mid;
 	unsigned int	folio_shift;
 	unsigned int	nr_folios;
+	unsigned long	first_folio_page_idx;
 };
 
 bool io_rsrc_cache_init(struct io_ring_ctx *ctx);
-- 
2.49.0



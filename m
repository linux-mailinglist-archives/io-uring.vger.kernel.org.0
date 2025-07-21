Return-Path: <io-uring+bounces-8759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0655FB0C0BF
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 11:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2DBD3BFCAF
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 09:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A084420E71C;
	Mon, 21 Jul 2025 09:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdeF8Q1I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4C28D82A
	for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 09:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753091702; cv=none; b=J5ytcN7J0vKJ8gcQpmEW7ANAYY66DCWIVv1kcYnf4SoU3WXjYHkXvSOkuv8rx4SNBIZMovoUI+zJgCPu9grV30UGf+XzrCL6ZmObc1F3poZVgdzfskAtBcG0+OLPKyYeRMKAx7Y6hJbc4wPe1pG4deSosOSrhXRv6mrwzQw+AGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753091702; c=relaxed/simple;
	bh=BGO9o3JKphwSz4KV8JAYMA7ZkeKN00JA0QvyzEmGIaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsiLyrWhEC8KVkZU1kn8hSL1TuMn0aDXa1p52vNMpzTmMkC70Ae94OsUU5aIBWYJGsWo/irXMut6lR/8qP1EJzRw9AgRqyUGG+kcnSKgoox2wbCu+ZD9c9Ijr3aVfJIPKDm8jjPfbexSkD7sK31UaoH1eQ0QpFsfGa6pcpkb0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QdeF8Q1I; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6129ff08877so6478940a12.1
        for <io-uring@vger.kernel.org>; Mon, 21 Jul 2025 02:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753091699; x=1753696499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RA19tOGrWjR4KRmRRFEiBrCo1pLSDBOXJ/P8/7k1U9Y=;
        b=QdeF8Q1I+CxycIBv0hbdxUVSGC9vz1nzGMUPATpx7eSwIuugWN1TDP8M4uppaC5+Pk
         vEywOITPOuCEvgXzcRdefwFZvx5Ok9wS0uvariQz6J+5YYMfvaVZXHbjv0zXOK7mgKDO
         7YShl2aIOvamnTdcX6ERdB4vLEuSjDgE9p9IcS8XEb/J9q1xnLO+u7aH8VjZzMjO/7po
         Pj1qtvSKRku3HG79ZWzRLw6V5d0rffcgruxIp9M23E9JVrE1YfJm4hYWlJZrTCPDHUBf
         UFJu5jQ2dIPkphNRO7apsDDlF7IaOprdzhihZd+60VkazFttsfVH40vAHldN8SLoFRH+
         B3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753091699; x=1753696499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RA19tOGrWjR4KRmRRFEiBrCo1pLSDBOXJ/P8/7k1U9Y=;
        b=rbIe3a1aFEEMaekDo0L7gnfvb86MP7HBppjPoCtcRBRsEjMm3crCjmZDmR1HRxBJ2Y
         krYczuFtiCUOGiCfq6N02E1A4Bxo96yGgLDn5ZxV/hemFF1bV180WDvNMhNlpkllhMSW
         O5IbInEKZvQV9X0wXdd754DIID2IfTvI3+m+E2V44GeiUtBEcZZVIyepUPleSGd9OCi8
         u08xNsbceX1SJNS2Ljuf4RATx+zdEeT0WYOQLIUB13mdD8jN6R4ABZxQ4n8a5cjCNyqI
         50wbptxrwLXhYaPNhh6AaFIgytt2py7KxIJs5nV7GmX9+pQFB4QNrQT3q17kZS1FhQnZ
         T9aA==
X-Gm-Message-State: AOJu0YyYYC0kFUORpmV+sujyNd51sNYauGJLFNIwkDn4M5s0v/qLMlN0
	f2+7XQQUZZQ91uPrtd6rDmnXndfw9WomVc0In3HOAw22oOHV/osPMTxQpgKpxQ==
X-Gm-Gg: ASbGncs8jBj3y9vsXnAcdhLLbJGUVGwRjo1tMAq+vJ1UKIa6sry6toILChQweJyxKC3
	fd2yK61j/cUgXMdrsUo2/KToFzzKvuUh64Q2qTe22usZ2XNGg1+tw4eobU00C/EkGHOslhR2OJq
	Un0wAjE8L28YHtjoT1+gj1TCLLba07pZ0+sb4JZccrqj/N4j7mBLJ5XTh0vLm20gjPjlU2b+EGq
	3iuBOSt65nJyAaNXo8evI45amf8cP+QsmzYHSd6CEXhmvJCHfb4AzuQJlK7rRfmfd6+jlxsgNKk
	r81+DgGCw8+hq1UiMLpYrzwV2YinCG1ZNfLrFFspCCJBAWA0GQhoH1bLSnxe5gtqm60ZfthcERS
	X6yEa9Q==
X-Google-Smtp-Source: AGHT+IH/bCuxcJn4plIFjgUXYxzyvfhZ1OEfSSHS7DoNwM5SfEIuU8xe5w/w+ti3BzNkEFUT5Gj+vg==
X-Received: by 2002:a17:907:1a4c:b0:ae3:eab4:21ed with SMTP id a640c23a62f3a-aec65cdfc79mr814814966b.11.1753091698521;
        Mon, 21 Jul 2025 02:54:58 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:23d3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caf6c00sm647506466b.157.2025.07.21.02.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 02:54:57 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 3/3] io_uring/zcrx: fix leaking pages on sg init fail
Date: Mon, 21 Jul 2025 10:56:22 +0100
Message-ID: <9fd94d1bc8c316611eccfec7579799182ff3fb0a.1753091564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753091564.git.asml.silence@gmail.com>
References: <cover.1753091564.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If sg_alloc_table_from_pages() fails, io_import_umem() returns without
cleaning up pinned pages first. Fix it.

Fixes: b84621d96ee02 ("io_uring/zcrx: allocate sgtable for umem areas")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6a983f1ab592..2d8bc4219463 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -194,8 +194,10 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
 					0, nr_pages << PAGE_SHIFT,
 					GFP_KERNEL_ACCOUNT);
-	if (ret)
+	if (ret) {
+		unpin_user_pages(pages, nr_pages);
 		return ret;
+	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->ctx, mem->account_pages);
-- 
2.49.0



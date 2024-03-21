Return-Path: <io-uring+bounces-1186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C3C885B29
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B85371C211B3
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2605984FBE;
	Thu, 21 Mar 2024 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uRkJguXW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395DE85624
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032526; cv=none; b=cciR+2Bf1vpSd5Ai8Omq00rn7DKm7vfkuoy2ep0xFDVBT11GEsy/SjWoqzn2r/aExAn65cJvdpyZ4XfY1dDn+609fxi52XEy4kt+9AkYmDWqTva0JVI2pl2sx60kcCf6K9CEUSh8UZ1axCqTmAvUxKy7JyxhiQl8oWxbDSL7X5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032526; c=relaxed/simple;
	bh=IA363V3fu31t0PPCUsgoiiOfsNv8iW0Wnt/MjZXXrdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+QX49AjPe0s3CUGGV4HjPvcueAwYkVhHDD6yDi+e2ndFPjDZO1qivNi6PAUcyeteNdO5jRRboRT1YEzPEvUzfnNkktZG/Gq2Ji/WvZ2U5o1yqH2J0MV7BdFdL4vy1oUKybbdTWSECNajFCxrt8TomBOkNgM6UkmMUJ2TRFkaLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uRkJguXW; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7cb9dd46babso2710139f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032523; x=1711637323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ3pMD8RptEK8J/o1yry4PoQVSvIoeVGC8WVz8qkQnE=;
        b=uRkJguXWjVPerk0gkbML3C4GFLGiDu+dR1UL0axozbof4oi11TgZMXJZYfnU1msniK
         sGbf93kcB9jd0D9FXGTRF7jVIq8UYMajJ4l2432Bn3Gbr4HcakbUZ3ZYs/zHCREF/L+F
         iF73UP5epG/8Z3WRv5HE3CtoB/7NLCwn6X/xccgKRUPqKqPW72rimnU7BF1kqBfmHxzZ
         3Qq3N1g1vX1360mDTTZar/v6oPQfSk2IXGzbjT0ttfeqKn86nt9rI2y4cokEOq2iGKO8
         dHzdL1Ar2o/IsjLUWHxww9JGHktmpk3n68i6D44i1C46WOjC8k02f5jHzP5S2BtfgrSg
         Sp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032523; x=1711637323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ3pMD8RptEK8J/o1yry4PoQVSvIoeVGC8WVz8qkQnE=;
        b=KkBDNbClYJ6L/wjU1L9gLTrOgOnBUSLVYhl/O6l+YhSP6GXK/gaGUMW0JYspVv1RF5
         NsIsXwXpxb5zCZvqOvvuyPgrTwVrRQ7cm09lfpqD5Pfn71CNRKYWK3VOIRlRojohdXtQ
         s/bLsCCnv+NhhgrDCKsPW8R+oZ/UPZyfvU1aVH23tzYrvc9Z4VsQhF98tNeMx1o/cvkL
         HLFlugHHH/JUS1OhablzR8mv3c8xscMN2fwVs9J3/rbk5QHrnw8LNRATZ03H3hEqI7Cz
         ZANkeZZbqoLGclZbOSm7oq2xhmmli+O97NyZdU5owDErait4prw3ox3U9eekeajPf6QU
         aKJw==
X-Gm-Message-State: AOJu0YwHaWyRCFPZ/bYWgHObplr3Yjisq+rLjSPhalg1xP0ze84cSiLG
	Dl+a+M0JTKPCXzXLNDyF6aFPjidyjduYPRdhcjWTWURrVyqJeTz0tpYLQmIZYZeqeP0Kt19C8gN
	Q
X-Google-Smtp-Source: AGHT+IFOaLpzd8HiSWYljU7nafFUixNYmHmcKCzBYZDf+bD0pKk0mO2N+mV1ZzmmVKfyA3UF/X5/EQ==
X-Received: by 2002:a05:6602:5c2:b0:7ce:f921:6a42 with SMTP id w2-20020a05660205c200b007cef9216a42mr8072554iox.0.1711032522906;
        Thu, 21 Mar 2024 07:48:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] mm: add nommu variant of vm_insert_pages()
Date: Thu, 21 Mar 2024 08:45:00 -0600
Message-ID: <20240321144831.58602-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An identical one exists for vm_insert_page(), add one for
vm_insert_pages() to avoid needing to check for CONFIG_MMU in code using
it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/nommu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/nommu.c b/mm/nommu.c
index 5ec8f44e7ce9..a34a0e376611 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -355,6 +355,13 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_pages);
+
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 			unsigned long num)
 {
-- 
2.43.0



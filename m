Return-Path: <io-uring+bounces-1308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A34B890E87
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5540B1C22E78
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D2A45946;
	Thu, 28 Mar 2024 23:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sOuOrSyj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C4F225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668891; cv=none; b=V/XeFkohrvsFqm2o9SZm088d9qzCt+PsZkGEybxllBZn0oL1XAIZxuOSW0kXkVhgjObwVfHa9/43dDLijHfSEJ8vQoHeejWIBZ4TwTLrhPeTjYI/+qCq5eNbU7+xjY3pDb/eoXBhdsOrQ+/nnNx+zCxZPw2gLDS+VWIZD065Yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668891; c=relaxed/simple;
	bh=P1GMNtFtESVWn1dPRf9Nl9/lk5ZAk1q8MCKI0cwCGrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcFJ5GyI/lsxJjSHVuTYV4UDFXBopZD83BXHbi9MNv/yJXDTzENaLkLO3qWdRq3ET0S80V6Lxd8OOD9yjM/+OPKX1OOeyTgd2x1EAT33oE0Ga/+blwk66pV4XkA81bkBB2Hz6RCeQpezVCjXdv5GE89ARjgnJZ4m7p/3hWFXVnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sOuOrSyj; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-29f8ae4eae5so413293a91.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668889; x=1712273689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhrfVg/In3eA3LSQhK4pBME3GHjl1vkZLwH4Hhx29tY=;
        b=sOuOrSyjkUxb3UegXB7qWrLUoUBIAXimeDdpVwmYMQO/fNCTERkfgPxADO4A2XeoKV
         HuRPVfa8W0xeRJw4CGongz6QND9ah0K0vBUMAJBVWu379+sd+SPb0dE/5SBJgL1xoKjg
         puX4ce9LYp8wMa1+WTG3BzuRAvXAwg+9mPXQ2wqDuezpjyyOlnMi4fYOUETjecQ/u8wt
         OhZvbY2JWXYoye1QS3EeU1RbUDZ3kjlbDMCiBR/cuhOTkSnwAN4MkHhGwJf5x8vFdAVm
         Q5C++3h4W5JMu5hcjkhTMluJnYbHBQrYAZP/p/XtrFxOvnjWioTBaQNFNd7GsDcFzTlX
         KaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668889; x=1712273689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhrfVg/In3eA3LSQhK4pBME3GHjl1vkZLwH4Hhx29tY=;
        b=EGRAo8SzGGCVNgA8uXM9n3cnHaCVFhKoNBxmE20cKFMg+4D2tQ6BtBS5RdxAuxC4/d
         t6AQiVJhRmk6h2vXqDa+fcqlGb3ruLmBXwSM5ecTFv3QeapHbR3n9QQCKppG1uSMtKEQ
         kisfcCFEjLLUgMT3dcOzGjVTow72KahvqcNm0xdujquyth/L5PjHI620msY9u4FHY33o
         PK02WUaomcIVvloE/lO6AVjfHnq8O5k0JtOUeT+WhohhHt/KkW5U1NHrnosvuAjw/Vdz
         ZvU/v0oUWbSA2WaMHIwvsIsnWgUxLFemouA9wnySMdRQU72/+NoFmEwuraYTrNBS88PF
         N2oA==
X-Gm-Message-State: AOJu0Yz20Ybq8P6prwINV3bhCvnVSAAYXagmZrZShnYGn3jt+oBo2vw/
	yrnLG1IRVZDAadSpWd5L4RKJEQbEYC6QHvAKYscbeYHfClSbw4LNQV67m/77rz3A/LSW/rphEhP
	1
X-Google-Smtp-Source: AGHT+IGjNbQ+J1O+6k7qwPDsGJRMNd/FFgnxaRr28fXqX/v/Tet6sxHqzrpUOzI48QRZ0iFi7xnjIQ==
X-Received: by 2002:a17:902:ed46:b0:1dd:7c4c:c6b6 with SMTP id y6-20020a170902ed4600b001dd7c4cc6b6mr904101plb.5.1711668888719;
        Thu, 28 Mar 2024 16:34:48 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/11] mm: add nommu variant of vm_insert_pages()
Date: Thu, 28 Mar 2024 17:31:28 -0600
Message-ID: <20240328233443.797828-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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



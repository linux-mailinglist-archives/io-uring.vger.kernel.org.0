Return-Path: <io-uring+bounces-9864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AEFB9509B
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 10:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 768D11900DCA
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 08:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2523F31D362;
	Tue, 23 Sep 2025 08:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PHtTiMYs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B74313D49
	for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 08:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758616886; cv=none; b=E4pnD9lo5ps0+Ebyvzdu/Sw0ZtkIk5lLEgfSsamtSbCJ5ru7CIH+9coQ0JpBM3HGbkBm4r/6sDVDn3qzkAiEtQyYBoVBpaDW3OIUnU+DkiHN5elvBVaqi2e0XVmN9Dg6gBNzYieNfg8kTf1Hw1vnPTINeiGXBqIN1XiVSIZMk4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758616886; c=relaxed/simple;
	bh=UPuPcX75oQ4AL5YVnkB+5pjIsnTNzRooi8XALzUgWoA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=c+SVaWPgkQhUAP2RboKKfmhSd1iABs0uVIgNhsHlrar/5O8IeXPPrjR5/4u51wp0OJJvQL7stekbdQyQ/oJImwhaMFxQDyg8m1akwd1vjuSlg1YZ/JVIhHkFSpi6OBAMi9R27PWaWmLs7n6s1mWBbAfcEkIWU0GmETD4Ty/21PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PHtTiMYs; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-62dfed14d68so585523a12.3
        for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758616883; x=1759221683; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cnwWdeWx6BR1kU+lh9ulv0ufZRbNl5SQ5ed/nJLAMrA=;
        b=PHtTiMYseSTFBp+NpkAd056fXzO/uUGiBFNT4MLNgZE7CoA+UnOQ7EMSKB/csaRl+L
         Wa3hZ2LFMhDnkQnuY+lpXwDToq2xMQFRKlNHKsveRBI+01+xXyVX8BoyZ5irWjz8nnkR
         0D/5RaGw0ohp6/pUVp8u7YKifT/X2PBzbhkvU57+vTv3YDXXErXLjqi0BenWWlxExfHM
         dQ0w2nC+pS3WOwCfTbzWwKoEKePdjGAvziVapfKukGHXdqSxPvrZKyjfgIBIv0QkkTMP
         e+ddHy0oz+csIDOaKZqE4yoHQmNax2vmO6O7aL8bD+orCeULXkYejuJYUVvEzFp/Q0U7
         Pmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758616883; x=1759221683;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cnwWdeWx6BR1kU+lh9ulv0ufZRbNl5SQ5ed/nJLAMrA=;
        b=F6gJtoMG7NMOhgE48XTSI5DJv4+aNTSeJ8PdBLP2feoc6FIWMHvTAKe8HRG340+fa3
         yaU6/rD4FkRmUGBumnZgCDiuituoeOgY3R0P8qGijE1UkVYqPg/io9PIegyCiGJUgkcF
         V2FByQJFlcAqKjGGZ1VprjI9XVo6vQ+UQxCo/FZ1Bd+Z2KViBfuioTNTgygjt/wm47xS
         /uQmkIQTs+q53oDeCTR+pJOgnlGkE2DSUr/lrSZXiPOPHZ268wKdFv0lAZVcSum/YpDd
         XpTlO9WrZLtGVbrGiYnc0zW60F3OaJEjnHvYjnA1polRN0JlKY0Rnri3NW/LgtyelI3h
         NOoA==
X-Gm-Message-State: AOJu0Yx24HR5ldiNIGeuSfNnD+j0TnO8OxRiDjOjr4gUs8j9qsZaeyQJ
	eiZqeEMmhNIbBfzbJQgNhXwOaY9hy7kvE00JE4XIZ/V719/SlbcOpI8KP1yfDHLsoj8BMqUpIQl
	aohcRx6AZyK1JviqAHYCM0rIVUIi/3JA=
X-Gm-Gg: ASbGnctPMhBBN0p8/FaVVDQnvWDwtI3ETIER3Y3pVU/wROZrSOOSXXu+IOosUq0NI5U
	6ugEHSZgdmbX9s+CnDlr89USdJ/6NPtCCcdIhaKPxtoDnRBa4/6hrBhCTftIz2YUYej/Kr0ujPm
	MNOtEZOcbRdKWitjg5LNckXDhMaThF+UymIYYShe8wbTJavKEjKUez3q2Fvf3MR8/oQ+7b74hYW
	XrFPqA=
X-Google-Smtp-Source: AGHT+IFYi+zTjZ6GJpJjCED7cor1eRd2OHWUV3RBOMliTwSgmZulxQHwLSjbrIJF1H20ROTHseuXPrvDPn7AcoPt+SM=
X-Received: by 2002:a05:6402:2812:b0:634:633e:78f3 with SMTP id
 4fb4d7f45d1cf-634676778a7mr738716a12.1.1758616882622; Tue, 23 Sep 2025
 01:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: clingfei <clf700383@gmail.com>
Date: Tue, 23 Sep 2025 16:41:11 +0800
X-Gm-Features: AS18NWBE1R_lwEilUcHJMhsDHcng_jx7lcG6i0fbEByuCHJe6UghO-ZrOrdxUe8
Message-ID: <CADPKJ-7cb9fcPbP3gDNauc22nSbqmddhYzmKeVSiLpkc_u88KA@mail.gmail.com>
Subject: [PATCH] io_uring/rsrc: remove unnecessary check on resv2
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	clingfei <clf700383@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From b52509776e0f7f9ea703d0551ccaeeaa49ab6440 Mon Sep 17 00:00:00 2001
From: clingfei <clf700383@gmail.com>
Date: Tue, 23 Sep 2025 16:30:30 +0800
Subject: [PATCH] io_uring/rsrc: remove unnecessary check on resv2

The memset sets the up.resv2 to be 0,
and the copy_from_user does not touch it,
thus up.resv2 will always be false.

Signed-off-by: clingfei <clf700383@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f75f5e43fa4a..7006b3ca5404 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -372,7 +372,7 @@ int io_register_files_update(struct io_ring_ctx
*ctx, void __user *arg,
    memset(&up, 0, sizeof(up));
    if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
        return -EFAULT;
-   if (up.resv || up.resv2)
+   if (up.resv)
        return -EINVAL;
    return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
-- 
2.34.1


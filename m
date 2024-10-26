Return-Path: <io-uring+bounces-4050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E259B1B47
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACA5D1C20BAB
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5823C1D7E47;
	Sat, 26 Oct 2024 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cSKm4qD4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1657D1D461B
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981440; cv=none; b=FZopOLoYdih7xs6xSYOpMAuWUvzMQKQGLDpNALGy2Hl91pl/pNya4zjrntQrXSP/QvO3hS59KxPr1wdJrhpYZpQ2ukMizw/urAWmp6pJ0pJzEvY0WMRVdJOz1BSe0P/g4EgBCzn8R3RpNryT/yTqri2bPY8dVf+4fq7dwvAYzQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981440; c=relaxed/simple;
	bh=2TXmyCtwXZp1vsGW+1a4yPJ5ITbgbVvr2+o2HfpIP0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltzz8h777qc2eyAGE3bHd8iV7cxM6AzRIiVmMhhnIkUD+JA9UW2OR8u45512uVqImJEbNbHhtXGmdTpvzxzADXh3xhOWcmPcXIymYpGhl1evSBHs9clBvmvMadquuhpBgvLaaL5KeeMfrIEYvt//bhHtR6+RrIQ68UyZcIMuOZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cSKm4qD4; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cd76c513cso28788815ad.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981437; x=1730586237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVO7eeCq6r97bEPVJLNy2xG86WtG8C+xSLbWchjxhk4=;
        b=cSKm4qD4BSq5qkleuEhSZ3QdE1p++hc9ADwhgUyKoSIyvuunGdxfG7Ma6KrZ3aLY4R
         ze9J11JJ7jCjVjcWg7TZtlrav4BxJ+BcdbWCSIzjO366B/wVgbKeORB6jHiZQ/J5PsON
         +79zlBfWHrNJOb/H2sfhtcIlABsoCnNL3TbHccm3O49oP5shBL1sIig+xB2eZNr3iCm9
         hDT67hFcSutMygp8AOk6e1+MWXIV43W6J6B+6aX4XLsv2+YXz12/z5UVuWlM+1BKYtBd
         aP80YDL/FNrhtOgaWhvo8fakcctvJRCWtiVxh0ld2knZ9e7/jFQfzAsOhs08SMmPIFcz
         gflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981437; x=1730586237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVO7eeCq6r97bEPVJLNy2xG86WtG8C+xSLbWchjxhk4=;
        b=Az47+EjtSKoc27ZIYPZWadVYoIHSFc2t+p46EMSKxcghMFNRoD0UU35FdPdCe3TBEA
         ek7ciaMaliv68gABIyu90FoBWdTPzDzPCHPKLzzpeAaGuMpfJ6EFyC0Kjf6UqKvRaJe9
         ZVprfHlTFDm++V+z0q5Kq8BNYODGDXN803VOSQK2bh4kkDMbDU5n7FHB0HxYlxxp2tiu
         PeuxXqUaB4iSkWl13GoKCeHbpnozskwAYWRAAwYI+fl2j0wnMi340+goxpcZbGtEIFwj
         LD+xRIu757Dpvn9ggtlt2AVV+9hQnxyVgKlj3oi4Jhd/2ynt3LuxTCJdVRz9RUOtQNhR
         /7sg==
X-Gm-Message-State: AOJu0YzwOjtrVM1WmWVp+Px0WHVtw7gzLvLRjjyr5IbDRs/qvLaXDTT5
	RG7e5tII/9z8zYQfIK9iKQZSrL5pnqs39NFmUqyzs2ENr12xdr5A5oN0GKknUhppAdbeDNehBqT
	x
X-Google-Smtp-Source: AGHT+IF8YzUOoSl1dLSZAP29PU0wDGubzK4rhPHg6f5OkBWC1if7nAogYCjfTd8KJPSjZRziTQg3nA==
X-Received: by 2002:a17:903:32c8:b0:20b:6a57:bf3a with SMTP id d9443c01a7336-210c686d4a6mr46496445ad.1.1729981436801;
        Sat, 26 Oct 2024 15:23:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:23:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache
Date: Sat, 26 Oct 2024 16:08:27 -0600
Message-ID: <20241026222348.90331-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241026222348.90331-1-axboe@kernel.dk>
References: <20241026222348.90331-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Doesn't matter right now as there's still some bytes left for it, but
let's prepare for the io_kiocb potentially growing and add a specific
freeptr offset for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 140cd47fbdb3..187d4a6b8337 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3785,6 +3785,8 @@ static int __init io_uring_init(void)
 	struct kmem_cache_args kmem_args = {
 		.useroffset = offsetof(struct io_kiocb, cmd.data),
 		.usersize = sizeof_field(struct io_kiocb, cmd.data),
+		.freeptr_offset = offsetof(struct io_kiocb, work),
+		.use_freeptr_offset = true,
 	};
 
 #define __BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename) do { \
-- 
2.45.2



Return-Path: <io-uring+bounces-548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1CC84BAE7
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E02E1C2235D
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C25B130AE8;
	Tue,  6 Feb 2024 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nxspfDxQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51899134CF3
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236865; cv=none; b=TLIhA9G9KgBiV6h/SvU7z7/L/QjYQrU5JE2WzUUBdWiKoKrgWmh7/2cZKw2NLomXNt6S3im91oMMnLfxEoRYdizsrTV5e24r0vAp24MNJMOhV1O1by3zERcqcf0olz3x9hZKWE+qxrPw0Vy2939ZYkNBZlt10sUHDj898YXaTyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236865; c=relaxed/simple;
	bh=aY8eL75oLJ6assrEEuO2Iiym9z4MWJRlEcSBeyfX1qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZSgmU4kNTWiECF3LiUIBsw94RSDOLu0DvPtLQCWEb04ep7CBwBj837rpSNKtOBng/Ri9GQIPwMRDPbJkIulMeqgahgOZx8PlvP+wU1W2IiymG2NOUDCa735nvG3+1D44fTKbOgk1Nt1G4MqrJBc3AqcWDybYOcOQCGim0HZb8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nxspfDxQ; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso40814039f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236862; x=1707841662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjZSEeL4+KnrvnzqwSF9/nWH5ab6nBeq1UOj95ia5fI=;
        b=nxspfDxQYExrI8wS1AkzRCXbHa13852X77NXL7s2dBcgwLRezSWvoy2pIO/KkzDCOi
         leFXqbgHHlBQCIrTJnQxutInMmZ9z+UKaXZCoPvl4i6msfRL1pBIif2CWLA5+U1PmXHK
         FFOa25HluR9YyKw5vFg2FBkgHSKVZSVE8xPuJ4jRpb7Yga9OwU1u4Kj8y7PCXvffpfrX
         WVtnUzwbEfnUcOl3+FoIux5pWOTzZ2xN/9mKIkvEQWQAgwx0nK+KYQGr0zq52MkIwmIP
         utt+FzZJIZyAyt8jQ5lNwy/za15FpFzT04mv1NsjQg8P08WrsR/da09WD6URH29YqjM5
         U4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236862; x=1707841662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gjZSEeL4+KnrvnzqwSF9/nWH5ab6nBeq1UOj95ia5fI=;
        b=Zreh7uf2Bhprrvgqyd5iNNWawKXmt2VadasSibn+3RvHx/aC14pWg8V4lh9TyzoOYl
         mZ+3xj3lS0gEdzDRrnXG3rU1oWmVzixtEHCKa3LrwWFBKDGlQjs9uyYd6XfgDpoNOa6g
         UIISX6B5CtUgmzYc5GYcw9vFHAl2SU+K5m2uocB5IheDjmWII3QYQ7l7dOnnvZ2iQ8KF
         qZXzBGV2W0SEZctmLs6OCaPtxOVMzXHcjPJh98YJPROJvELc5Ips4c95rherM/aMWWt8
         q4Ne8wx4p9GY+4K4AZPV1MNyY6rF9NJxBBC8R6kE8Ul1PrvcrTjMIaZo/vYo4VZKUulY
         mAAg==
X-Gm-Message-State: AOJu0YxkosKec4vPCoLV8JSSKdLi+HPAs8NBLU2LpaMVCyJWa3fRfChM
	pjpQsz22WdA4gbwxSh2au7A7Wr5PVC68jzIftzpGCJpc7LjQ9IIRiBlXP8euCMBckL2ASV6AlDo
	OsDE=
X-Google-Smtp-Source: AGHT+IFoqW6OWqBMtl96ISreoWk0MpcofjJLqe60vPYsDQbGfGQezhyXj/PhsGwNPuaYIov9c2yHdw==
X-Received: by 2002:a5d:938a:0:b0:7c3:f631:a18f with SMTP id c10-20020a5d938a000000b007c3f631a18fmr1205820iol.1.1707236862019;
        Tue, 06 Feb 2024 08:27:42 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:40 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] io_uring/poll: improve readability of poll reference decrementing
Date: Tue,  6 Feb 2024 09:24:41 -0700
Message-ID: <20240206162726.644202-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This overly long line is hard to read. Break it up by AND'ing the
ref mask first, then perform the atomic_sub_return() with the value
itself.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 3f3380dc5f68..8e01c2672df4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -343,8 +343,8 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
-					IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	return IOU_POLL_NO_ACTION;
 }
-- 
2.43.0



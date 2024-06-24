Return-Path: <io-uring+bounces-2326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C32DA91584E
	for <lists+io-uring@lfdr.de>; Mon, 24 Jun 2024 22:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 719951F263A4
	for <lists+io-uring@lfdr.de>; Mon, 24 Jun 2024 20:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BA319D069;
	Mon, 24 Jun 2024 20:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PORPW3eA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6338745010
	for <io-uring@vger.kernel.org>; Mon, 24 Jun 2024 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719262561; cv=none; b=XiZsN10yGvviRTI5TGDtRTn2uA6UzqSj1oumSpjzhiN92c3zGw2IA8MIVIUocTxnmwaEVqeSaq/WCD0EdU5PM72P9tb1s2KdPtgVUR0ampEbUZvPsNHXRPWsBtUTxiAYywA8/Y1fQQLM9bYtKgYb41bYB5JI/109/FScYFAgSaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719262561; c=relaxed/simple;
	bh=TSUNggPi0pA82PEOZTzyk0iXb76jSOP7VP+PsYu8HqQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ndiv2kgQry4I+4QxZC24wd0oWr2vwu4uYGGmVi0SRsEygGb50Q9w1Zeyk8WQozHNalaKlO9xMvf+Sg4n3jnjYoA0lIgvSEX2Z6BFFX8IDl9LkvmwOnNVklcArCUv6q1QsDdba6Rc8eAIdJiWxLYg6xYWfP2z8QreHQRm6cXZ2ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PORPW3eA; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c2cb6750fcso863494a91.1
        for <io-uring@vger.kernel.org>; Mon, 24 Jun 2024 13:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719262556; x=1719867356; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbvlAvOPzqkn5oqA9PyyHggTK1V9xToJF2KLSFNN8Ow=;
        b=PORPW3eAVu8Sj2WqEJc6lFhDmRgFg6rMcgWUEU8hHXPy+pD6UDFiZXFXLGAyFcPtb3
         rQHvq7MS1tZj4+synP7/8HFzVMvfXR+HHyGmMiG1QNCILQcOdoSRTHSyCdXRdD6DRGa6
         YJNjhgqK54j2ATdAv56/eFuv5AdSFEqmtuDLtKQlfwIlwu+jb+tlwcAEcEymmnCvBJ8J
         fA/BBgL0sTPQGjyIxf0TWXGtzLXn4myijnLA+XXhb0PMf+MCp/ful9TQELzIYjOGWKF3
         DPFBYGzfSVLX/ItGP2pVj0KDpUW0aabSFmR8fSFk/Tgz3y5O99dri6s8Ns0QaB4Chw+C
         w8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719262556; x=1719867356;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZbvlAvOPzqkn5oqA9PyyHggTK1V9xToJF2KLSFNN8Ow=;
        b=oyKNxqzULP0kuGLBgUUd+EfoUkTHY2EbdhRcQrHckb3JweSsMabd14vRG1rNfztGX6
         voip1mJxFSuA2LudVQHC+negjGUb+ufH60rIKb7bwoP1Xu9GoW4+TTqP68OiYUDRittl
         V3wiiA8CvN6t5ZTHxEJdfsdLg5OGUEOZHoUWt7X/bBPeZRdhm/oOhpoJFL9sKB6uplfa
         Hw5lkGUvZ1tACb2sZK/r9HDwnf4Z0fWFWSyZAUo/GsUjg6IJJp+SkRCfC7o/OnTkNoP9
         /4lGRqHt/6QjaNsjrpaWSUvLWRIcTWeXvt2w+dBVtmOF8Uez0wLLlY7u6lnb+4Ly0XS1
         fW0Q==
X-Gm-Message-State: AOJu0YyUZOwUSVezg6jXPTVIvc7021fwrJ7hTa/Ca9Y4yghlcf98G+jx
	4VRRinU8ORA4/0DRM3JCg5n7B9sZj1kh7CbCombBAmgLgIfka315oJSqizVdBj6gV0Uv7us0lGb
	x
X-Google-Smtp-Source: AGHT+IEMKtLmwQ6AwFr7nTPhdmMW/PBrn+QL6UuBA8NPOnyRISGRJUdMztHQdN4q2iCvzTOngQUwyw==
X-Received: by 2002:a17:90b:1a8f:b0:2c4:e2cd:996d with SMTP id 98e67ed59e1d1-2c845c56076mr6215424a91.3.1719262555585;
        Mon, 24 Jun 2024 13:55:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e5af9c6esm9168890a91.42.2024.06.24.13.55.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 13:55:55 -0700 (PDT)
Message-ID: <3fad366c-bb10-4bd2-a841-a5f5e128c5b1@kernel.dk>
Date: Mon, 24 Jun 2024 14:55:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove dead struct io_submit_state member
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When the intermediate CQE aux cache got removed, any usage of the this
member went away. As it isn't used anymore, kill it.

Fixes: 902ce82c2aa1 ("io_uring: get rid of intermediate aux cqe caches")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ede42dce1506..3bb6198d1523 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -207,7 +207,6 @@ struct io_submit_state {
 	bool			need_plug;
 	bool			cq_flush;
 	unsigned short		submit_nr;
-	unsigned int		cqes_count;
 	struct blk_plug		plug;
 };
 
-- 
Jens Axboe



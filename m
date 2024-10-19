Return-Path: <io-uring+bounces-3838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B149A512D
	for <lists+io-uring@lfdr.de>; Sun, 20 Oct 2024 00:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ADDDB22344
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 22:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC8C190685;
	Sat, 19 Oct 2024 22:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3FY6w6dr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC15B13C816
	for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 22:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729375556; cv=none; b=ghPJxeWlP9Mu3v9OdsU9pzc7S9xeRCqh+uv7cuIbonD2J/h/tKMoMmm6hj6LNfyzZt8UCTZzsOJI2pVhCy1vR7jR9Qj+SJJnp7vDrorUjjjMItZN+zgSwAbhm3H4EIkQCnn4vks4bcDuqfRYx4YtHloLe4Ge/YqpVYVt2cRNroo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729375556; c=relaxed/simple;
	bh=5agMjqPOM1iMMR9j6hCWLx2VTuT3CDOBtgOcnx2rEDg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=G+SvtSToIRqeTCmxTBcN9w5VKZ/mdPB78kfmNkIN9cl5arLVXrf9C8/PqEQ0apl2TWDx0FCcaXz+zlRO3YPHVRQ/OIySSPvdGENDmZeKi1uLW+qmkkUEP8Wg0noUlY3Sf+wPhBQpeHvsssK3wL9R3tM163WHH0yrbbOKOPUTzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3FY6w6dr; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cb47387ceso28322505ad.1
        for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 15:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729375552; x=1729980352; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FkBgE+8YwpVQHAWL+zPGyPBEJrilAwFkSrJSqq0XlPQ=;
        b=3FY6w6drgbaBB0ateBHFi634nfktNNiAtza57/q60DpDUgYbPDIwA7vBceV4QW3bLr
         DQSIMO7TxghbyaAI1kNQfMeWVEREZZpYguIsdPBT2ZfETFu2TJAiG4VHl5Bkdeisvvia
         NniJlcQZ4G3An9UjjrJYnCyUqAjWsDNyX9i+gIIys8VeXSXZVuUx8k+ovcxa5AvSo8LU
         9EI8afheLLGASGOjcTXz+gsabcxilllzDMkypc3hsQ6CatIOxTpiUrMsS6Z+U3+kHfyS
         19B64TF3igqwuLdMs/JpV3Nw+4yuAQOP5xA9nORgatOTPyZg0pS8GFel5iyOLRRJKWMw
         btwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729375552; x=1729980352;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FkBgE+8YwpVQHAWL+zPGyPBEJrilAwFkSrJSqq0XlPQ=;
        b=wuDPp+UgtDxRpw6ywdkoh0Z6v2qFgU/J8lEKhOIpTWEqibV01z0ShzV0oB1TiXitD/
         enEpF0mPbx1c8l6cAKtlX3sVE4Q4qcIGxbwD0fQvPwYrMiuvL+43FRsaRh+sxxFqbPaM
         qSlxxaKjlV5KgUJB+LEE8nWOOLL2Rr0TMfdfbdekg+3HjdINjjocGc/HWvGDQKAf+t/4
         mXWMHoigzf8y+Z3YrSSlQRIbGc96uZET5wTSZAPj7dgK728eLKBQ8Q226dATcAk39Rru
         v0T3mYCgq//dYTGstjoG2eLSnVIq3mH6Kp9KzJZFKPuHdy4BtrDgKEM48VBcevAK3KL5
         f22A==
X-Gm-Message-State: AOJu0YzEzVntaukoTnEZybnjM7AMVeRAm3vhA/Bhqfa+t96AmvgjgheP
	4RFsSF1lKMFHPo+gTxyGhvn+bh0U9sGAOxba7tch0FVzQ7FeBBJlRz0UunMn3yqtdRFUIT7piZ4
	Y
X-Google-Smtp-Source: AGHT+IGqW5P+gcnxXEgRthQVPGGkRzm4DsHVSAEa1eh85D1XpPq5L3AhKxAob8eWtfX6Hq/DdlfHtQ==
X-Received: by 2002:a17:903:22c7:b0:20c:a644:c5bf with SMTP id d9443c01a7336-20e5a8a007cmr101407605ad.31.1729375552277;
        Sat, 19 Oct 2024 15:05:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0db2c8sm1791385ad.195.2024.10.19.15.05.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2024 15:05:51 -0700 (PDT)
Message-ID: <955ee428-3ec6-4a34-8a66-138efaba1ca0@kernel.dk>
Date: Sat, 19 Oct 2024 16:05:50 -0600
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
Subject: [PATCH] io_uring/rw: fix wrong NOWAIT check in io_rw_init_file()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit improved how !FMODE_NOWAIT is dealt with, but
inadvertently negated a check whilst doing so. This caused -EAGAIN to be
returned from reading files with O_NONBLOCK set. Fix up the check for
REQ_F_SUPPORT_NOWAIT.

Reported-by: Julian Orth <ju.orth@gmail.com>
Link: https://github.com/axboe/liburing/issues/1270
Fixes: f7c913438533 ("io_uring/rw: allow pollable non-blocking attempts for !FMODE_NOWAIT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Thought I had already sent this one out, guess I did not...

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 80ae3c2ebb70..354c4e175654 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -807,7 +807,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
 	if (kiocb->ki_flags & IOCB_NOWAIT ||
-	    ((file->f_flags & O_NONBLOCK && (req->flags & REQ_F_SUPPORT_NOWAIT))))
+	    ((file->f_flags & O_NONBLOCK && !(req->flags & REQ_F_SUPPORT_NOWAIT))))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-- 
Jens Axboe



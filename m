Return-Path: <io-uring+bounces-1952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EB78CC56E
	for <lists+io-uring@lfdr.de>; Wed, 22 May 2024 19:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFF42B219D8
	for <lists+io-uring@lfdr.de>; Wed, 22 May 2024 17:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C1E770E4;
	Wed, 22 May 2024 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Grz3bgVm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C57580D
	for <io-uring@vger.kernel.org>; Wed, 22 May 2024 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716398344; cv=none; b=mMuTItvFtMJZXjG20PIdRuoEX/eGUszS7EqDwRZaWiqxlT7TVV/wM8Cx7XELUmpyEuhzKzoDNjrrcTl3jbGFW+fTQ7jyPShiIOfr3gBVjMLSoNm0KtLYsWjdo3EjoNzL+Uu9r4VhdsQXronC4zjPaxQaFlrJGMIeHJ2basMs40M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716398344; c=relaxed/simple;
	bh=r+LvFti7Juqi7+oEUIUNMgbcb5I55AfhfeCE8OXGT0k=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UOPh5gWW9h9smk95IfppiFLwPBU6Nkiz/pHXTUIISbM8rh5r4WaYSiCx47DJbjUZyP/lCQCO4ThD6KGYiFJ/sOhKa2mX6hKKc0Ya50POtS+HU6o5SXjPy/baaL1KSCJHSs9hw7s5w8lklbJ3NnfphGpqAiCTesZrRMsyEf3Mb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Grz3bgVm; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36da87c973cso2550435ab.0
        for <io-uring@vger.kernel.org>; Wed, 22 May 2024 10:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716398340; x=1717003140; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waXHV/hV/Kcmxilqn0tBGRu1dIQQdRBbsbAsl2mCb6M=;
        b=Grz3bgVmPwimubHMnX4aKxsGUYjJ2B9+6x4L65M4kcywdLbcWqw+nbmh9hogChpPdL
         HdVvYKCHz4SVbyxD/bS0TfMj35PnL6xY5zfdlsDbyCJNUAvRMrkQvSuGlChG+tcpeBnh
         kVDTSoWILxGTm1BPyV6cpx5FVsl778JXnIb/p7i2tFf6SWmMeprSMXhMvAL2ddk1uksW
         GgBCHAHd5150qLDPdqwVQP0FpYQ8WrKjj8TWfiLfP6l/h9709LEyHV9WEIdfdYnU1/Eh
         6cXelozADN0NjUdvOLJTj0UFATloRlmfKuNp5Ilgbgd6v+Uc2feXy3UVR5iJ0IjgLcPf
         1f3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716398340; x=1717003140;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=waXHV/hV/Kcmxilqn0tBGRu1dIQQdRBbsbAsl2mCb6M=;
        b=Ixr1/8lNR7YKwMnWtW0NZn/Edqax/DZhsGjuVlUeH1dsKg/BEgjO2VTjGUKIObUKHF
         qu+pwXH+QXZqPtwGVg3JsjSl3xpeIU/Dlw34yj+aJSFfxPHilCOZby/dnP+BKhyl70cU
         ZwemRASWH1H+VTnb3HGwKecD423xkPRQKVR0nEgdllR95vXsYUshcuKtxZfVQSl7w7Rt
         KgoX5p7nMpJ+hEZacrWxSJ8PVQOEc/KwcYQr50ngb2Yn1wfdsKUDV+pd2ivHQe419LFd
         xiupEajB5ctrevrQYgXzt9dqq/HY7fZOwak6FptAk6N+qgYvFe73QqR+ZIHt5f3dAUT2
         vk+w==
X-Gm-Message-State: AOJu0YyGPA4JoAClTb4dKfDni+nRtWeP4KduahSxkCPNQZ74Ghvm4WJZ
	C4OsMc0hkz7YG0Y44YiLzkRmIqiLWbDlvKXJqygP7jBtKuagbFWItTVrekYGuj8HoRv5zS8Huti
	6
X-Google-Smtp-Source: AGHT+IE3SlaLmiroW90n8smvZ+FDPZfzGwdIbLyQRnEwAVEyB+jK1WVuKYohdRbSuGcLwtE/bqdddQ==
X-Received: by 2002:a05:6e02:1447:b0:36c:3856:4386 with SMTP id e9e14a558f8ab-371f92ff411mr34165655ab.3.1716398339795;
        Wed, 22 May 2024 10:18:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-37195389d91sm6960235ab.7.2024.05.22.10.18.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 May 2024 10:18:59 -0700 (PDT)
Message-ID: <01bb19f4-fb38-4a3b-a0e3-c0ee6c6ea805@kernel.dk>
Date: Wed, 22 May 2024 11:18:58 -0600
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
Subject: [PATCH] io_uring: remove checks for NULL 'sq_offset'
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Since the 5.12 kernel release, nobody has been passing NULL as the
sq_offset pointer. Remove the checks for it being NULL or not, it will
always be valid.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 86fd72f6a1c2..816e93e7f949 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2597,13 +2597,11 @@ static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries
 #endif
 
 	if (ctx->flags & IORING_SETUP_NO_SQARRAY) {
-		if (sq_offset)
-			*sq_offset = SIZE_MAX;
+		*sq_offset = SIZE_MAX;
 		return off;
 	}
 
-	if (sq_offset)
-		*sq_offset = off;
+	*sq_offset = off;
 
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)

-- 
Jens Axboe



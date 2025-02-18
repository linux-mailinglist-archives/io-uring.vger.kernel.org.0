Return-Path: <io-uring+bounces-6535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE09A3ACC7
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 00:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48CB716A890
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEF71C07E6;
	Tue, 18 Feb 2025 23:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z7MVvhUS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF031A8F6D
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 23:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739922561; cv=none; b=j2eS7+8hKOBy+IIMIV/CLdT0O2hWpKuT5UT86TG/K/q67cU0u9n4wID6kXBhfw8yKU5xkwIc4DpCRA7pix2oHy1Q7dff6sKkoymTEEKZP0cazMUX8AIES9THXnrNQDCVq72Dj05ISP9DdBGsCk3l84Hn0r/n33an7xMGB0Ohk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739922561; c=relaxed/simple;
	bh=bPIZZd3zytndJoglvhTX2EWrRHWpgkBKOMNIrTMdaNo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=RkVKYlqZDm7ZtuwpHGz6fJj1O8xCUl+QMZKIZ5J90KyJ1UKKx5EKeFztAReUrLcFUeLYxLNwLb6CgSACZrD+E7RqaYbx45V86LXSQRPaxQih2n+bswqk/DhAq5Z+AhzNLVgsKmQFnPHFUYBdZsoPcUuXPaxPSOfmy5KGqUvPlLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z7MVvhUS; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-852050432a8so9990039f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 15:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739922557; x=1740527357; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+hYMs0Kg9I1k/Q21ONEmxffqU9ORgfA2zXJTM/zuj4=;
        b=Z7MVvhUSqXUDRVBw5lvyKKX6hH1IhM09ALj/jTX1oCOat6lDVrXcO6/bBmOuxfOIPC
         FuiSj78urC1TB0t8iNFVFk7U/d2GA391tlS/iEOAqKyvakSavcuv7dGlGtdGyIO0cqyL
         eZ2P/Sx6Gavgo5b9Y3TYJoxEEsDi9AWvA2p+NoZzPs09zBdwtzaRoVADuXjE/X1pZjev
         3U81JvL3+IEIVCzRct8VTTV7pn8MbL0PWu+OBMmHO1zYuw4w7NX/X5NxqfTPjydAfJeA
         2XggNtuig7qtgR+AJ1KbbA+ZfBWZE8C+/IBAqPeaUIm5VcPd85x6jUfZW5tjremaVV2E
         A8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739922557; x=1740527357;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h+hYMs0Kg9I1k/Q21ONEmxffqU9ORgfA2zXJTM/zuj4=;
        b=smNrCq1uuNI+WSOz+v8BKFWWigO84lFJ76AS6JaS9YJ1j8r8f8PVleU6DTqSwms4NI
         R0ERJ4kcQxfLcDZc9pIUdu59h+17rMQ8BJwEeq3t5dgktRg5BKCKcckspLSOYhUCvcjN
         k/AcUPDhCvUb6sqyVr4s8hDLgyEwmWRvgRScZU+KyJyPMzE+LG1z8n0BovWTP9MRecjg
         awRh6tEPXvYotzANYg/soxmRxIOGCsJCHw8Gk7FJ1sWu7fLsYtrMsfISHvvMu3ILKGCW
         ZS11SXpkQZx3xLRc0m7eQBp/Ida75Tfz+vuTMMs2BFuDaD6OulYTrT4u4Ds3xYbA71qG
         6bAA==
X-Gm-Message-State: AOJu0YzZWhkytyb1AS9hxPFv2JeDgBfVQ8HV1jPcG/BLCPtKKka0VpZy
	o6W8VTDrveLl6/S06BUsfQyMb6TmJgyhyGQRfQLnKwCm9ULjhjXGFOTm3Ptf9JK/FhBzKKnDlFX
	s
X-Gm-Gg: ASbGncumWMADOzjbADX62ZhYC7ImYW8sOulNFfa6WVwzRVDqoP2VstJz98lNzMDg5Hs
	KTt1H7+U69TNNTwjzP5HshK3WQJMezGa2Xb5wOfJHasl24n9Mgv1+zXQ4zCG/mICmMfJw4+mDXJ
	+f8LIA8HvWynDtsmxGh+h7z578cilexvf0XWS1jkfEaA+itkSeAJ5PXcIH35xMfg0fVFTjnuOaL
	aZUZBKbwRBA0AdotBwMJ/cinD6m/MkoWNnmrlT5PlvPekkVAg00AAhc7TEMgcq8/RDwVdQ6F3f4
	zH7EsrYjuTHa
X-Google-Smtp-Source: AGHT+IEhYdPxgRSY9dah65TcsmdAt5IB/mooeafodY6cAiZAGneRi3/2w+WhSaP3EE9lQoLqMAc8NA==
X-Received: by 2002:a05:6602:4f99:b0:855:9ab3:dec with SMTP id ca18e2360f4ac-855b2fa7016mr142341139f.7.1739922556918;
        Tue, 18 Feb 2025 15:49:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eea8fcbf38sm745863173.143.2025.02.18.15.49.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 15:49:16 -0800 (PST)
Message-ID: <fd1a291b-e6e5-4ab0-9a2a-b5751b3e4a02@kernel.dk>
Date: Tue, 18 Feb 2025 16:49:15 -0700
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
Subject: [PATCH] io_uring: fix spelling error in uapi io_uring.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is obviously not that important, but when changes are synced back
from the kernel to liburing, the codespell CI ends up erroring because
of this misspelling. Let's just correct it and avoid this biting us
again on an import.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e11c82638527..050fa8eb2e8f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -380,7 +380,7 @@ enum io_uring_op {
  *				result 	will be the number of buffers send, with
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
- *				will be	contigious from the starting buffer ID.
+ *				will be	contiguous from the starting buffer ID.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
-- 
Jens Axboe



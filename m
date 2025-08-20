Return-Path: <io-uring+bounces-9126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D93B2E570
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD1EE1C84A21
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C281C27D77B;
	Wed, 20 Aug 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FMrOIW4G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F363275AEB
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755716753; cv=none; b=uA8UdA9f/ZwzCJxELTp9NBDMTGC7t9LkF7W12J8f/LXPIFWCESZWF0XgETD2Xk9ER2RgbX3woYOHfNfOQBUyxt5TNcglzXRFN9t0FdBx/HCH+OC9HDRrC2UaXIUman+ks9nKoPCB3Mp0pIscIIj6aaNC7lL4CRNy/qEuoXFa64k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755716753; c=relaxed/simple;
	bh=IP0vkI4Ttpa3KER1jhWEqmhDmuUzX9KyhNhjckRr1Ek=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DywcfRiVq/pXQxJTrZm/sT0MD80sIaK0Kds314wjVscr21FIJO3TD/GyWznH++UTliiyRLCq9Oo5qJY17foyCsz4v1mag2DVsHu2IMcdlxFlkC1ENyMFKOZhki7lIWnPlB/Sgixw0AynCqa2S+ljNPlA4E0T63dqZBhh034pkN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FMrOIW4G; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e56fc0f337so1238095ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755716749; x=1756321549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8xT/LLnh+wvwNr6x7XkQBB6UfVMcDcEDXcWVkvmNkls=;
        b=FMrOIW4Gkfxbalq+Ib1DJ5qgRX9tw9v0GKPAOnbjaRk80UdLmxXr8RI+Jp6y0p/eEX
         W4nvKP4Utav3WwHfOAPV3fxYyulEDIgWxCrRHd0T+IHIc17Ki/GIVRH1cU9Cm0X0XDvz
         dfYH1GdknXuPW/ww86RVSFY8vO5Pzc+JQwJtUiCNECKcy9RZTHqQryQLm2qeVF6Qlvx8
         gSjWZH0piw8tkfqvr3TpTAqxX4O+TU/IZcraSdooX+Xy7FI+89rteQCwU77EZzOWuA8n
         2Ir1eIkYKvnpE6q0XyxRpTh+u1UzoJv92xDONoz0n7qRaNs9+vIxfBHgdEQXTyPMEJZZ
         KTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755716749; x=1756321549;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xT/LLnh+wvwNr6x7XkQBB6UfVMcDcEDXcWVkvmNkls=;
        b=sTL4A4TIAbRkHD4eyTZlhlezVEtfPnxhoiUlsRGYWGp26eD+BXjMAS/99FcofUhJly
         WHiApYgVYLcMtNdt0APZYTDsZP2pEbhnqCMmp8zo598CAulppnrgKwlb0n8l71A/MCfC
         OACM74UQrwsZYh+WHlZKLYQx6Tnyx+H8AZeci4nmHEP0uuoRAUoawYbJJWh6ntH1UCuX
         V3l40Pa477Q0ANAll6RN1aBc807tE7j2zufg4bIHEXIzZrCNbO1pFlICnq17tXJBXzyY
         IZCp8jiubjHlMVmCat7QdiHX1r6PsLTpyI8UdTrQiw9bfwDaE6Gn6AFK0DQ/VmZoOGPE
         GaIA==
X-Gm-Message-State: AOJu0YzBrO626lTy+KIJ0xEl7MsUl8wGkqYtBpTTPvf/G0xblpZtl92p
	aIc7xJoOC58EQ/AscUyTmN9QNCCQWWH2G2WbbymKdEuC77cVqI9CoeZ+0xzoNEfFW1/QntAlbRz
	9hSK+
X-Gm-Gg: ASbGncuxfUyoZ6Aj1172cfKVHatL23IneKHlW3inidDIi2Yu4Yr4vQhjTBpez6I6zdK
	tYqYvcRwGhzRxqNjaTZR9KNzKiTd9IDJO4PG1u80zWxwKpl+HMZweg4LX3fBK069CuSA1c8mSTD
	xQxBSvMqyO1EWGh3HPl41HmR+yaI452/35REi8r36Y+8iDzo2xz9pWtdrSgavSyZmr1nPmCP3ZC
	zSEACo9DoKsbnaS2PDOZei8vjZqcIbigJOY+nZoKLtLtzXssguAMG3mUboZRmRp174XQstHemh0
	faaavD+P65JZVxwN5XS8FESSSU2/GTvGsW2z8rcJQ4RrHB+tql3Nl9xDPqszmAT8e4xvn0uX7JR
	aCeBLlHj7RcPQzTTKu7bdQBmX
X-Google-Smtp-Source: AGHT+IFvlilmKKUfme3SeHGU4bMPxJV/8or/DeusHkDREFVkdJghdbILGPUbCe4m6rkPTkllrC8q3w==
X-Received: by 2002:a05:6e02:218d:b0:3e5:70b0:4f9c with SMTP id e9e14a558f8ab-3e68340e289mr12556375ab.6.1755716749361;
        Wed, 20 Aug 2025 12:05:49 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e68210a198sm4017035ab.1.2025.08.20.12.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 12:05:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com>
References: <fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zctx: check chained notif contexts
Message-Id: <175571674823.450846.8897056737037156094.b4-ty@kernel.dk>
Date: Wed, 20 Aug 2025 13:05:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 14 Aug 2025 15:40:57 +0100, Pavel Begunkov wrote:
> Send zc only links ubuf_info for requests coming from the same context.
> There are some ambiguous syz reports, so let's check the assumption on
> notification completion.
> 
> 

Applied, thanks!

[1/1] io_uring/zctx: check chained notif contexts
      commit: aad1370a6125e1f676c18aabc2e819348e65c25a

Best regards,
-- 
Jens Axboe





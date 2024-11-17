Return-Path: <io-uring+bounces-4767-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 026549D04A0
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 17:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC8872818E8
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 16:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621A31D279C;
	Sun, 17 Nov 2024 16:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pE/7Pdng"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADC26ACB
	for <io-uring@vger.kernel.org>; Sun, 17 Nov 2024 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731859320; cv=none; b=HTUj7MOCMTFi4G1nT8QtEpzTFMnOk3E6gk7Na5b5v3WIZLGRy09IOhTjV/XAHdBbUGQc43nQbWNFUqU8bdRXHDA0NjghrfIVl9QByIUTqg4OY3y3bxPcyBAdl0wKMXRgcKLya8eDoD/BCZ34ne3BFatZWTY3j7ERPbSkN2Pd6CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731859320; c=relaxed/simple;
	bh=MShGJjtG9VJdf82HMsw89luaaEehztY4O1uFuOo3vWo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=USWej4M6HyoiFQXjvbW57e82OOd/7Q7/FX4gg9bfcTkX/8jbPjN3Oh6Cnz7D/dLjpRQcO+nAmkvLZsEHn35qKh74ixOCX3X5w1Q0QnM6zxb2GMlYT9shLDFStuz8SO6hF1B7cinrkaCAHpViTA4J8X8rG5yIqsS5srULcOvXPvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pE/7Pdng; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20cdbe608b3so33489315ad.1
        for <io-uring@vger.kernel.org>; Sun, 17 Nov 2024 08:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731859315; x=1732464115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2zKwwSJauixhbSx27iUO2pPD+wzs/rT5dDL4uigRQA=;
        b=pE/7PdngT9kluimJ/7ZM4R1YN8RYpmi4hc5UoklkQGQFJfmX5lV7B+QkiC9QRjeGhX
         TMI2vcP0BzQfmPA0lsjX1jMZ/CQgRL5+zOCmekbW5FSpGKli0Ufax9DjfheT06kgQjRk
         17AdsMgwLQ6zbtStjHJhnrjHo0K4IooZYuAfLyRfWpcjIh5r5QSr1wjpj4B8D/NXALxe
         mZyLz4/7Tyyby+N/DS6HiFxzTLniq7dxr7IcnLJBLlwtPiZ+Q91pm2qMF/q1CpR6hjYP
         nRaLVT4yN7heOC3sf3/IiU2V7kUcpXBtPTNvWoostrgb5AeFWTcNtQmVYlHA937SmheZ
         P9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731859315; x=1732464115;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m2zKwwSJauixhbSx27iUO2pPD+wzs/rT5dDL4uigRQA=;
        b=ZdYlKKzfkHYc4QBqcrvzGQlnhLahAfPsHtSwZeJTCtxMGlIjbPc5ziOkXjCwBUAwqL
         qr3XtOGeihXabXtfk/gzG6+W59R3fIlWdoNdqB99jsaUzYBjeCQYemiDJ6fbNQeWRsBW
         WAzzWXi/T+lZ1D3KdUgAPWgOYs/3iq72hHZu12bk3Pz1hk7B8mGjcWXSwFkiHaDlLbwa
         NmykFsl0rXYLGaHP/GDg6R8hueR/CztcJ2W6wyv5qSVpToCi+ez+LAkgXTjrdiMihgUx
         2m7tjYXI2+EkfOTQed1PeXUZun2gSxGhceUA3V7H6UWynm8i0PrNgq+cv+/NDpNISsg8
         /SLg==
X-Gm-Message-State: AOJu0YwfW2tEUuddP+eY2E4s+SAIrhLnT8WmikwKrJSZvrAVhs8MuhmM
	9N0eRmRqVzi7GNTO15DsgCE7ZH0AgeyGtPgkpuOJO3P6uX8Yup2x3JHxmGK0Atw=
X-Google-Smtp-Source: AGHT+IFT7uBXOUILxY7BxWJIrpYyBWX0jw3+0XBvHnfP2ru9u+e/gt3fdyyQLogqtukSIBATDyHrNw==
X-Received: by 2002:a17:902:ec88:b0:20c:da98:d752 with SMTP id d9443c01a7336-211d0d6fcdfmr143953115ad.16.1731859315102;
        Sun, 17 Nov 2024 08:01:55 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f45cc5sm42042355ad.183.2024.11.17.08.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2024 08:01:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0abac19dbf81c061cffaa9534a2471ed5460ad3e.1731803848.git.asml.silence@gmail.com>
References: <0abac19dbf81c061cffaa9534a2471ed5460ad3e.1731803848.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/region: fix error codes after failed vmap
Message-Id: <173185931407.2589937.8237387136583206069.b4-ty@kernel.dk>
Date: Sun, 17 Nov 2024 09:01:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sun, 17 Nov 2024 00:38:33 +0000, Pavel Begunkov wrote:
> io_create_region() jumps after a vmap failure without setting the return
> code, it could be 0 or just uninitialised.
> 
> 

Applied, thanks!

[1/1] io_uring/region: fix error codes after failed vmap
      commit: a652958888fb1ada3e4f6b548576c2d2c1b60d66

Best regards,
-- 
Jens Axboe





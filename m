Return-Path: <io-uring+bounces-8350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EF3ADA312
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 20:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C2716A2FA
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 18:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B804327C167;
	Sun, 15 Jun 2025 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1dd+z6FZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86E81DED5D
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750013949; cv=none; b=LrPalBm/DLAxU7mcV2ozVxJs7JEZ0xdHrxykMyEFUfejf8IEIxGJGzINBOxNxJQcm3bOLCA2wankX1+00uMoJwC5RxMriI51PwrHY/B8fCp4piKRRpnHXjQ2NYhg4j8qhYSNrHOM+oBCO35UpWbHYmNTA9wdCYnB8VbsNXRZDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750013949; c=relaxed/simple;
	bh=zps3z4rZEjYVsg/2iOnltpeS3ysiLc7KW6u7xBIWzzM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FQvHSLX/UsQmrijid6eg+/W5XFegXAr3qvoSd3bKvzUp1fiV82pcSeeAzumbzzxnJtU+23Wz3a/fUL1BHUu4UGLZLNOi/3qQi73xU9SA19rqo4C7M0j4NCs3t74D7yH4Ez53rKUVu3tKVMOgMFSuQxtlIeiQhEfVnoKXQRLp7wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1dd+z6FZ; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3de11a14ff7so2322835ab.3
        for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 11:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750013947; x=1750618747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6vBhuyNqqMpO+p7DESnvw4+ewrqQnOmhISSnScK1Ak=;
        b=1dd+z6FZZHbmxK5yEfCMRMcTjekeAc4ZKIBJLL2MhL5/xXY4N2O5JpFcIkygBBcyof
         LRYZGzZwR2wMMqaT26hGRRDDijUFJlKnfCGhevn/c5gxrDvBjpLdSJJwqT8xByPd7Dn7
         AV2y3sFHQwHUlpM3lCDu50Stf8DytgXXejdEQ5vPwZU81ePaTBTltcLNQNbFasFhfj1f
         9AigOwnFF01JiILpCWKpegT2IngmATAxJeFTAeSYmFQIcvkh7L6Al1fU8q0VxzVB+SQP
         HYJ/H6tGE2Z1irQGKjHpQqq4pgiByQDGdLphNRB9WjOymirMdRjubdjxMcgC5NctjDLT
         3iBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750013947; x=1750618747;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6vBhuyNqqMpO+p7DESnvw4+ewrqQnOmhISSnScK1Ak=;
        b=FVijiJJuYqeSE5KS2H5ppHRra8yTYVplKPh+MWEmjv1kEoP9y90WcKA9Ozb9i7RvVG
         qj8AjOmv9nFlMUc2BVeSwITIFsUAItTLPp8+HuF2W246JowF9sj5xMTWITd2wTfb6Yrg
         vVSEe1l8B1gfSrEfy3XTunhLETCVQ9g3IaYKe86UfTOZxUlpiXh7/1AOpDwOP9mex8xl
         BaiTyyD5N0x+11mHO+uSfFSxS9FSQihYXwCTMoJ+RyPesGfcjndMR6Q4GYL9TJ1lh3WD
         LpBgF73IN8gYceq09gXL2ZTlbeLp8s3dd9i0FOPx45u+4CktEDlqaArMHZBGunLFQEsD
         nC7Q==
X-Gm-Message-State: AOJu0YzNL4fWx+igwlFRFqchPxzCXRZrT20uHSXSfiGlJxAHByXl/QfA
	4NkOsoPc+mFwZx/1q0knUNIqWfgcP7UKSS6uLHperPwxqa2Rm3+qFI7T1KKQf0nOu1w=
X-Gm-Gg: ASbGncvskGkRQTyoWWob82US28yd5qmuRmO5LxCGcF9f+qmXPxB9OTtd79vCS+pv6lk
	R/UaCZb+9bFR7nz13/a8ZkR/hgTZ+Ihp6MT+4VHbZXcW0q44T+6C0LivnlggPXqAQTd1Kht4O+g
	mg7ECIeoEn8eh+uVI+Eonh+ZcCRwJOZ1z6xSd3Z9w2mmanqly1oiYn/SkPZyCn8uWVzfE5cG4UW
	G0lnyKaFUX4Ab5I2sDLq7zft7dLzXgbi7bds0OpR5tk5m/1Bf6qKLf+n3c2tWHUVkuVLxA7qO42
	3w3iJfVRw5Squ/C19PmsJs8i4Oo1k5eZ77zGA79+UN8ovKhTtuxzWg==
X-Google-Smtp-Source: AGHT+IGMD1ZxRhn0WxOw5HWc31CsgILQ4psiy349+t0GSX98tbi4y5aEPFYXnE6TWZ3++iluyfig5g==
X-Received: by 2002:a05:6e02:1a2b:b0:3dd:b762:ed1b with SMTP id e9e14a558f8ab-3de07d7ae51mr70044305ab.16.1750013946960;
        Sun, 15 Jun 2025 11:59:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de01a501desm15354325ab.62.2025.06.15.11.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 11:59:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250615163906.2367-1-superman.xpt@gmail.com>
References: <20250615163906.2367-1-superman.xpt@gmail.com>
Subject: Re: [PATCH] io_uring: fix task leak issue in io_wq_create()
Message-Id: <175001394597.940677.9152762979973400635.b4-ty@kernel.dk>
Date: Sun, 15 Jun 2025 12:59:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Sun, 15 Jun 2025 09:39:06 -0700, Penglei Jiang wrote:
> Add missing put_task_struct() in the error path
> 
> 

Applied, thanks!

[1/1] io_uring: fix task leak issue in io_wq_create()
      commit: 89465d923bda180299e69ee2800aab84ad0ba689

Best regards,
-- 
Jens Axboe





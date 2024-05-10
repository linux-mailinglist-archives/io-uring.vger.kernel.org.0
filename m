Return-Path: <io-uring+bounces-1856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 463238C2515
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 14:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1DB8285DAE
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 12:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4E13FB87;
	Fri, 10 May 2024 12:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="INb+Ccmg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EEC7BB17
	for <io-uring@vger.kernel.org>; Fri, 10 May 2024 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715345425; cv=none; b=QcMSGkG6/SFXktSPJNgtakiwPOOt6cz/XhcNbsRUPGUMlSpyR4M3KenL+6g5rnwCUgh6aY9AOoc100JwOmSr6GiOrgNecKNuQz4AOk3pJG45Qw+j/pERhhqT0Mu08HXVx0MJ5ve+BCyE0Pjv/j+OrWSzlL9PbcRPk998BsE8/OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715345425; c=relaxed/simple;
	bh=PP0KcKNoIJ5NCoNdtR20RN/tQQdYE5yYaNNti4GdALQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LPVcIJjTIYaJIWS6/DJvrrma1WqRwynb0m4qM95TnuuIi99A8q+K9FoB7EuklPyK3epsFZVRglDPO727j3u6lIYs0qEs0ow+TQGRTTP7M1jVU1bCYzdbO7lOgZ9N2TxPyVZ7x7wp4jB4OruzuIC5p5ZA1nzBc4mGJfIlvGWPB88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=INb+Ccmg; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2b6215bcd03so537892a91.1
        for <io-uring@vger.kernel.org>; Fri, 10 May 2024 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715345422; x=1715950222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R00U+8EtvjIQ03TgPDpl2lGC7lwhUTTq2NMFtkLe+G8=;
        b=INb+CcmgGr7Q2eXXi+QzL1d6jR9z1Jp5BN4vzTGenQ0tmCcwBPmKCTUpR9SmYlt63g
         3b2g07C9DJ8oMP2OU42ddftykdYHpJI5zBpe6vNkhLV8XxuwiYyklj3fCcw2D0ulBo6R
         b5JBQYJLeMP5IUc9BxJnNI9nGmNs0bJpiImX8sXaLEYHq1m7OA3GG7xguos33JhfAYPg
         t+Yl8HwUoIFlULO+sxVV/OuWnha/0imvlf04Iur9omy1ThvFHv4DgTk9s8/uRd9QDHUI
         FQgMt6tyglEqTr+nC4NgqPemSQslI1xcOH1926CTtl0zoyNm/n1fT4UXg9Y5/KrFYXCn
         9f7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715345422; x=1715950222;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R00U+8EtvjIQ03TgPDpl2lGC7lwhUTTq2NMFtkLe+G8=;
        b=QzTDrEw5XYSEgSfxVAItsblisl+k7a7bHwwrBnvY2ScSjaG4KSE3PskVe4cYvtFwPc
         Px8h8nXwCDVPREOTO3Z8qHNXQ4XmniYMVD/tnXa+vSzqZPKmQCfF8Fnz3IS6wtRCB1js
         TjEkMunK/WUlhTanmFIuWqV5uH9JYBZmYpzIJvAIRAX31iQCuYAGGHhba+sYtn4icZ08
         GJGr7Qx+4YxakrQlUwzp88xpNmrrnjbimqv50J1Q0OWJ1UMMa1ONSg/6HfDLvZI7khp3
         W2+NYsrbCnGuU1p6RD8DZBPaQqMLrWYJiedCpUpaVxJsN6/RH5H8Ldv2xcjHP9KDzbsO
         9EhQ==
X-Gm-Message-State: AOJu0YxbRT7S5jdSW+3oqippoZw2mZyg+Kc2ONI/RmkuxADN0M2Yhfdc
	/FTszLlFizYCl6HO7ecYQI7bIOpcan0D8MFo8U/dYLTL0Jceh9XB937fTz+JGVU=
X-Google-Smtp-Source: AGHT+IExnUVeU+lG2zPrcaefU+kzVp56I2T8Ax7QAE/PzJQX2uzOElrby2CXAiVewN6Wr1yl524eFA==
X-Received: by 2002:a05:6a20:3c87:b0:1af:d057:af9d with SMTP id adf61e73a8af0-1afde23034amr2989153637.4.1715345422485;
        Fri, 10 May 2024 05:50:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a666f9sm2861677b3a.21.2024.05.10.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 05:50:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
In-Reply-To: <20240510035031.78874-1-ming.lei@redhat.com>
References: <20240510035031.78874-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2 0/2] io_uring: support to inject result for NOP
Message-Id: <171534542167.317865.8875772583199413242.b4-ty@kernel.dk>
Date: Fri, 10 May 2024 06:50:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 10 May 2024 11:50:26 +0800, Ming Lei wrote:
> The two patches add nop_flags for supporting to inject result on NOP.
> 
> V2:
> 	- add patch1 for backport, suggested by Jens
> 
> 
> Ming Lei (2):
>   io_uring: fail NOP if non-zero op flags is passed in
>   io_uring: support to inject result for NOP
> 
> [...]

Applied, thanks!

[1/2] io_uring: fail NOP if non-zero op flags is passed in
      (no commit info)
[2/2] io_uring: support to inject result for NOP
      (no commit info)

Best regards,
-- 
Jens Axboe





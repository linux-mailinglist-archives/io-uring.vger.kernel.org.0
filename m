Return-Path: <io-uring+bounces-6510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA84EA3A466
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A419818899D9
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B5126E636;
	Tue, 18 Feb 2025 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RJdkFugk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842F263F36
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899968; cv=none; b=jOoSLStaLblJhlgN9cogH5OIZkuzum9WgmUu0SYx1VbcHZzWxksOoBmjJExe1zdtQbt/3MSd4kprBKsLd/bhofaNoDeDtZ8Karr1i7kqzHGwPYntSFu/yXOwhUqkG668oUA+AMXc8q9gxJ+99YgM4+2Yb27i8eE46UhFN5wIdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899968; c=relaxed/simple;
	bh=D0ME5XaLOrs7wUb/QjajO5/u0moqQYqCk7WFNUIhpK4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J4FMQGnuqpdfGUq6sLenD39ynjOhWaraG+BY1Ywwtq1iRqoSN1yfTBJ/g3VK/7/gPqDh13Q8cVnCJhOYsw5wvFdROFmvqvbdtLuz26rawydFNVQcpWQxQhQyNUjfnUTGfM7KmUNlpOjEousN2axVgt1JOKSUDcFReai7pHEjK/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RJdkFugk; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85571df0265so331695439f.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739899965; x=1740504765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05XE+f2WQD6y8a665mMfd+nbls9jrN0OOQ0kqF/7mts=;
        b=RJdkFugk5r4OMCTxbMqaCbk5OUUOJXq3ZEYERc+CeV5a0pNQ+YUYVTeTwiPquL74Sl
         A5ng9rFHZzdwvJmTt/3yNCyLage0SCnyIJ1NowbCjB2GCJCGIWVRHTixLJ9lGvHl9hcG
         KlmSbtkj2Q0Yr0ppNl1Jk0euoka4drsUInH4EyObHEQKmsGTYrwSb0IHedYAsVr6ybFO
         410GxLSVeokPoynW3Vvwqi6rzxyRdctRf4ghKWqKgFtoF3KKIlmkW/NUF/j4FPGqHeS7
         cbaWMgA1BVF03Ff8pBoHSoosdFnbwJdrlBUX2SnQB/zAu++atiCqTrlPkSACNuvm8QCk
         WxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899965; x=1740504765;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=05XE+f2WQD6y8a665mMfd+nbls9jrN0OOQ0kqF/7mts=;
        b=Pys4OMFpgAD8zdYx6uR65G9noErHbeR/sjrOVg+EaWbwNwnwDgjPbeoGjFzcRyw20n
         gtih5NHxgBypT9x71rrOCXnweJ0bECe3AtG7lJOZ5TufUxfx0Np8/36Pr2+lRpILQBUk
         bT5FBhfUWzCDNWArnFcrc+QuEsSjuEZS2ghc+e+Sa+MWny7WG5l/oVZczwnfLP93O8QB
         WFlSUz1nU/RMFIMgOu9m2nCO8KbakbiJghOfr0NHA9OJhh752h8bc9pBaT5lcCa+Waz4
         mz4caOpWd4aKrS+h1/nYGeiJQC6qPf2zUY0wdgk1PF9zQTihq/h+75nj6EZ/errp01U2
         omiA==
X-Gm-Message-State: AOJu0Ywg5RKM/wU+QDg/Jll+6VVJyS287hBxnuYbo/o6hiY8ZMuWXm/0
	w8l1COkFnuPHd45WDzGsY27dQtjM8LqRZz1GEMzLXUkG0H+Zo+/37H/dMfg+YVk=
X-Gm-Gg: ASbGncumn6yOChoiXaWqjY1W9yHLXGFSKSHtSeGU6Hpdj9USalWND+EEkkpiP1AdbUI
	qzZbRgg5nWreszZO+ybPGD584SHt5zE8pQ/P190ddfL1lQBPcy6KrsblML2ONPUhOUTEZ4qW1d8
	XPp7M6dIi36aJtaq88andCfD4ItJR4kCw2k+uLbmak1wvVKKh52sY+QlMCEL+nEbTjts0Q/I+MA
	VPMr0R/MXvzK3f9KFjhHlqVLEvUWIQxOfgKG+GQ+1tN3yB+FdgRub5/MVy7QQ5Pl5NxIuL0NUod
	ovBwNrU=
X-Google-Smtp-Source: AGHT+IFofXvSaEl35Mmei2TpiA2vEBnBzeUtOtW7FrKzKpWBWviuOWFTZQ5Xp77XjS7Cbjpuib3taQ==
X-Received: by 2002:a05:6602:158f:b0:855:78b1:8c29 with SMTP id ca18e2360f4ac-8557a0ce31dmr1252063939f.5.1739899964865;
        Tue, 18 Feb 2025 09:32:44 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8559d52bcacsm65489339f.25.2025.02.18.09.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 09:32:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250212005119.3433005-1-csander@purestorage.com>
References: <20250212005119.3433005-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: use lockless_cq flag in
 io_req_complete_post()
Message-Id: <173989996383.1462475.17339377843072880185.b4-ty@kernel.dk>
Date: Tue, 18 Feb 2025 10:32:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 11 Feb 2025 17:51:18 -0700, Caleb Sander Mateos wrote:
> io_uring_create() computes ctx->lockless_cq as:
> ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)
> 
> So use it to simplify that expression in io_req_complete_post().
> 
> 

Applied, thanks!

[1/1] io_uring: use lockless_cq flag in io_req_complete_post()
      commit: 62aa9805d123165102273eb277f776aaca908e0e

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-2210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1492908B58
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 14:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12B8E1C22515
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 12:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6ECF144D37;
	Fri, 14 Jun 2024 12:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fDMGReku"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07812F5A0
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367256; cv=none; b=bbl+35qDFHOv2A7ZysdW4StpfVaA31PbZfolB5MFFGs2u6erjLciWey1LR+SvZ3iSi/qfRb1sfWawIaEpzlUK6R4qjxfIwP6GOJk0ZRI4nkf8O5ucxsTgSgzK95PiLNgPGLCh7hVwQsMGB/a14EHWQ8b0gUi7qFdNjuW/AucwKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367256; c=relaxed/simple;
	bh=TLDIzCRgmbkpjtjvz74rOgmiHVLw73LEwRH8VMvqxCA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B3hgtrbahBF9FMGpm/BXHVxHTH2TCeMUw2pH9ZO7lQtqBLkLRy0o0VlGP4p5dZkkct/Ggvz+rHwjuSMGEEg0+Dj6qSWmkBjBwTxkrbD16TmiOlKH+kDtLjoCbNj3nElQM6f+zrVoAiy0LlbqjSsz0TJyyTqvH/0W5Gx1qsmOiG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fDMGReku; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2c2c1473f73so350248a91.3
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 05:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718367251; x=1718972051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlZVzroua8VbSRTrsLKkRwsBDlG6gGsTg/noTWqQGuM=;
        b=fDMGRekuDea8MiAnEUA7AXSJ4w3y5+70YU9j1PjRzS6obXO3JaaQ/TGB/3ZfvyNITE
         4UVYvZOYrgRpL+I3MfSUJQnjcYM5nbVwFn62KuugnwIm6JiWhccj76wX0qQRk2G+K2u2
         NSUyy+43u5BSFAygfJvdvxdCvwQOCZbpgF8Ftsh0PKmSNG9mE/PdUGEKBGW+5onWWY2R
         y2ySxtuKZt4KNiA/3WjAi+1hmPqladUgLv3zMq/klWqjm/N2kRQ5Da/74nwdAz/mFSiD
         gw7ZE35T73p1WbR2Op8VEMRh/3mERJnXVFgMNTrUKS44+1ZK2tNlVBPiJzyBIcb6Oua1
         bEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718367251; x=1718972051;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlZVzroua8VbSRTrsLKkRwsBDlG6gGsTg/noTWqQGuM=;
        b=LCcSD6G4zUokGQlzoekrjQOPo5GZiPOZZXfD0yawwuLxOgVMQTKgvtZxP/uOwd+IGu
         IxognxTVJ0L0mseGoqScVC9g9NZvre8HPc9uN888Fv0bq63F0mXof5xvNKIZBFqqQHsh
         LWueXNWjj6icwXCUGXB436pmnCk838ZUlRSwdqEdeExo+VCeIBZ3J9WWlm/Ryr8E05Qt
         5VuQCnsPphVPDRLSk5KNTt+woUXqR1tSGgUFKQjxIhGD+XgmzZFozQjAjCTl2+Fme2BU
         A1UsXZCovHWPSjwmkogDuxYGccrTWLJ4ft0ZqxaMyRXbzYZemvFfO1xnRN12XNRJhq2V
         XBpA==
X-Gm-Message-State: AOJu0YyrizuGUbE0v5Ips9nx/lp7nWif+HaxNXTRVmz64va0TZq+PdXY
	byNYC/edQa0GE0k10SFMriaIR4ae5D4+jaFVlMse/tCtpLTVs7JwlumMxEuiQEc=
X-Google-Smtp-Source: AGHT+IEZaf0HN3d/a8yzW8L0D0TBNZEf/XjhyA4tth2Tw/Zv7jPafXDmhDEyP8DFIgeN7ln42oj2UQ==
X-Received: by 2002:a17:90a:aa87:b0:2c2:c967:3e56 with SMTP id 98e67ed59e1d1-2c4dc031ca4mr2605435a91.4.1718367250653;
        Fri, 14 Jun 2024 05:14:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75d205asm5969881a91.4.2024.06.14.05.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 05:14:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Li Shi <sl1589472800@gmail.com>
In-Reply-To: <6827b129f8f0ad76fa9d1f0a773de938b240ffab.1718323430.git.asml.silence@gmail.com>
References: <6827b129f8f0ad76fa9d1f0a773de938b240ffab.1718323430.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix cancellation overwriting req->flags
Message-Id: <171836724941.222205.7286563058347838008.b4-ty@kernel.dk>
Date: Fri, 14 Jun 2024 06:14:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 14 Jun 2024 01:04:29 +0100, Pavel Begunkov wrote:
> Only the current owner of a request is allowed to write into req->flags.
> Hence, the cancellation path should never touch it. Add a new field
> instead of the flag, move it into the 3rd cache line because it should
> always be initialised. poll_refs can move further as polling is an
> involved process anyway.
> 
> It's a minimal patch, in the future we can and should find a better
> place for it and remove now unused REQ_F_CANCEL_SEQ.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix cancellation overwriting req->flags
      commit: f4a1254f2a076afb0edd473589bf40f9b4d36b41

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CFDC869876
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 15:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 187742953A8
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 14:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBAF1384A6;
	Tue, 27 Feb 2024 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VJKgiTAG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1EC13B2B8
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044393; cv=none; b=Jm7OXobLhWp6w08EKWRGLOfZKyJ9YShe75xC+4x8EF56JNvkbtttoG6COsqw4ehQS+ALPjphNUBNoHpYt0rBoUify7f4i+lH/ghb8kuGfr1GrayHz+4Ghq+4bw24tR3wNkQmbOWgV5uCKGQ3mz0WWmZ5gbZIvMbuAXjkzYDJk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044393; c=relaxed/simple;
	bh=6ZmvBVYdxhjfoLzIL9AvsXXMdKIC1arMyiU8VyAQ5SM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LFBiuan60D7FCUPYUBfoedOabeP3+R9WqFjKIzXnbKk9QVrxEjG0msrg6I4Q20/j4r3KBLTVR+XugXTlKKCTtXw0Zdr6zMSIOawGJaEKM+xvRFf3by7vbioklPgGCDzllg8VmuzViO1UcsgynOvGQMETTfSaKQhy2OnmWJLOlko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VJKgiTAG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dbff00beceso11768825ad.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 06:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709044389; x=1709649189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zbUxGsoSb7dtwYVKZKLaKmHJglhz3TfMXi+lWlDp0eY=;
        b=VJKgiTAGU9a+xaThlYp10e+fJSnwdx2hiuR4Nnv/h+xpL9/aWpRJCXk4X5R9m4B28x
         WuoZjI90gYFBcAt88u7EV3u7iadii7/jI0NKoWcCDL0zfKR9QDhvoxO6ygHh0nHouYVn
         N9UseNH8DUDzoPg+xO9C07HDstLfxFM2c/cFK4K4SZksObLpG0WySZKdKnsYN307PVVm
         y2REEL+KcSPfbXgwsDe3UEbpu4SYJ6CjvMj0n7EIpwzv/1pZ64gPwj1/nvQDpM+mFBHm
         x8WLT5T7QHAf1JE1Fo7UN5KrDKtE82jr3Z+KS1Pr8hgYvSlI2G4GKKpc82iJz4Qo+UIH
         z04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709044389; x=1709649189;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbUxGsoSb7dtwYVKZKLaKmHJglhz3TfMXi+lWlDp0eY=;
        b=Te7EIPKk2g0GzSaalcpaWlrew8nxtSZVnbn5R7G2nLte1bdT/SlXMSJbsE0d49PAoY
         T7o+YG4BpOLJu3QjyDPTdYoNguhZGg5yc6XNpc/tx/2Aj0IkYat6bkPo1cc8F+kG1Tv/
         dxbO5jk7tSzX641/CrTMDl2oF7/JQHScYhgtnPYaa9TsCJmL5wIm3th7bd9NBfN95wro
         ScNh5FT0zBmOVZ2tyGVUMFoDV5l4kI8gugw4rOm5syJUE9HsSbdoeVeRKg5/iSx3/OOi
         pIn/PlsEEaw2z3sA7WqBw8PGhYAhBxDO/k5iD2hSXdeghTmB0jP17G3k7m6Lh9rIeP4z
         Awkg==
X-Gm-Message-State: AOJu0Yy3btCKxOBHUBhbzh9Iy2TZNbJcnJhuNTfaEKO4qRUtEVonM+QA
	JcVBAJ55DX3fOCFmoTAZ0fiO1iFGiuVScDKMNqfi3RHHVEjebu14JMXsGTLdxOaHG3b6cIj1lOD
	P
X-Google-Smtp-Source: AGHT+IEXeLoAyuTRV7Ikf+edF8YztBDNB7JM+Qh0jNwTreTncGJyibFkDOsbyC0QWQi4uGyJ734CMg==
X-Received: by 2002:a17:902:e80d:b0:1dc:b01e:9aaa with SMTP id u13-20020a170902e80d00b001dcb01e9aaamr3882594plg.0.1709044388870;
        Tue, 27 Feb 2024 06:33:08 -0800 (PST)
Received: from [127.0.0.1] ([2620:10d:c090:400::5:6000])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090323ce00b001db9fa23407sm1607377plh.195.2024.02.27.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 06:33:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>
In-Reply-To: <20240227073213.1200023-1-haiyue.wang@intel.com>
References: <20240227073213.1200023-1-haiyue.wang@intel.com>
Subject: Re: [PATCH liburing v1] .gitignore: Add the built binary
 `examples/proxy`
Message-Id: <170904438797.804695.8878932757433155400.b4-ty@kernel.dk>
Date: Tue, 27 Feb 2024 07:33:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 27 Feb 2024 15:32:09 +0800, Haiyue Wang wrote:
> Add the missed built binary to make the git status clean.
> 
> 

Applied, thanks!

[1/1] .gitignore: Add the built binary `examples/proxy`
      commit: 1e8eae47d0cd9be0a51b95e1b0ca54f322f7e4f0

Best regards,
-- 
Jens Axboe





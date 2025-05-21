Return-Path: <io-uring+bounces-8056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA4AABF598
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8AC37A77EE
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5096C270550;
	Wed, 21 May 2025 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nybCEKJT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943852673BA
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832936; cv=none; b=gHAVW59CvJo4jRsp0LuWT7tSoHzj7WtIxKTCsq52Nyjhv67y8fCaaJShTiwZGZ9yGfRUlcVXTog5OX9ktaheljn2/ZOWlOO6QBoOV19RlKl1TBBhBgOlEXZtAYTVYg232vXjnrfAa2C27d0nSwnoWPZJGKb/oPgk0OM2ZwVx2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832936; c=relaxed/simple;
	bh=TzHo+T44+YMJuhpwvP4snVEXdnpYzkXgHo79GJOlPTo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TzyFP0nlhNZ0S4HbiVWUsrlPZcSpkL/zacUd7ydAl3j1o1Qf5SAQHJ1CPZ/93REKz6Ot49PPdCrEaYUt/70OOqKKhoFvO3/1NToolDjQUOLPKXRtTY8PDSPqFlFun3qUbHg+b0fAY60+winJneDPMbjelCtUcmco+bZPhfBFwPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nybCEKJT; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3da7d0d7d58so49765385ab.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 06:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747832933; x=1748437733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxY7A3HgHdRO8hTwXatjRDscVmEbMfAHdTK2ipAJycU=;
        b=nybCEKJTTmQtegnRw60cFiWveXlAgYiSCvtD3DlJbW65gqTuC6fS8EX75PJDiYJKfa
         frkhy4viqKWHjLlagKajqetaqIb6J0S1zCzLX6r0/Sne1d4XkTuap13C+Ag8LOytrSJN
         efXLOBkGo58hMLuctLJB0YIYSL58n9Lx7aFSqwkC1MLCl2TuhUqY+IEKSn0W4EGu3vAM
         x0B8kGjbRywRekIS4Xr/nmYjR0PaMB/cgoGGUFVw4UiTTTIAIJovSQvIOOSkYV2rPeiy
         BL4ZfprHs1f6AAf17HlaDGkWvgP03zadYgwa5R8k28WQUpVE4ogKXgKmWZbAEugIUUZ9
         ga4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747832933; x=1748437733;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JxY7A3HgHdRO8hTwXatjRDscVmEbMfAHdTK2ipAJycU=;
        b=gVlen74RZGHgGpwkuLFpLmKn5NjIIWtgx231xSHjnO6aXeapAYWS332z7xZ6wjbCa5
         ileyo1D+9zBKi3eobcuhRoppJADc3J8jtJ9dTKQPjnUKxeFqGgi4LEDaLYNO8vHdg/19
         ZHIeakBhRVKc2VXaURBctTdawuibHM8uROdAzFGr7yNkrLYglotdKm9Ea/mND81b7607
         ZgQIgfWK6UGqX6wIbFQ/qr44aUTAyo48fKGulVe7B5yMA8+GoEP7ES0FVX47jqkxgyD1
         JuCnaZh9ZgEkkvgf07fpSLBweRrIDsEeD+kRoaly+L3Erz8cUna6aQg5K/Jfc6d1Cy0o
         bVFQ==
X-Gm-Message-State: AOJu0YxYmXckbGs4tpUXrzgmCqaRUq52IXrHa82kDHC7LW56wb2x6n+4
	+6UWKCOgpLp2kf6gW6v8MEGUMwzSkCT0Bi/i/K8q4tqlWdc+dpKZgHIBvsFhE1HQPU/NPQGng3e
	qIHbJ
X-Gm-Gg: ASbGncu4wtQc9B+FdJpZ+KpWE1szPSkfiFVbc86zGOTmFmR/ZHRdSn7TMQLzPTzxoRt
	mqxnmWmmYAIPHEc4oSHXEvYEK/spXbmm1RECJxglN6e2D1mlhPgXrsM8gky2I6RKFPq4fq2xTXQ
	5LdUZSRrA6X/QLkETxcxrhxt33IAnmVbtHB3t7zve+CLE3QyaSf44MVPvJXRQGJwIirpBm+9rFs
	e+L/D1/dGWhmJzAz8DbnDqGJFCx+5dNe6OLEwSP/UuDjLZYWoTrhVD1m6oy3BT6lBLbV7T7Op9D
	rPBGFUvVvx3sq8GeN+5H6lhSpPvi1SL7mwlu+NoSMg==
X-Google-Smtp-Source: AGHT+IEtt01r7Jygxevpzgo/E4j6RKEki7t31o5fCuNRph3zL8w+uOzYdFY7LHFGTnlUXSUiJyY1rg==
X-Received: by 2002:a05:6e02:154e:b0:3dc:875e:ed7e with SMTP id e9e14a558f8ab-3dc875eedc9mr17057865ab.12.1747832931727;
        Wed, 21 May 2025 06:08:51 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1c78sm2809169173.57.2025.05.21.06.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:08:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, asml.silence@gmail.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: joshi.k@samsung.com
In-Reply-To: <20250521081949.10497-1-anuj20.g@samsung.com>
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for
 vectored fixed-buffers
Message-Id: <174783293090.803330.4324280293776436442.b4-ty@kernel.dk>
Date: Wed, 21 May 2025 07:08:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 21 May 2025 13:49:49 +0530, Anuj Gupta wrote:
> This patch adds support for vectored fixed buffer I/O using io_uring
> nvme passthrough, enabling broader testing of this path. Since older
> kernels may return -EINVAL for this combination (fixed + vectored), the
> test now detects this failure at runtime via a vec_fixed_supported flag.
> Subsequent iterations skip only the unsupported combinations while
> continuing to test all other valid variants.
> 
> [...]

Applied, thanks!

[1/1] test/io_uring_passthrough: add test for vectored fixed-buffers
      commit: 78a86bc03ad3cd7ee0f509e317b225eb5994695d

Best regards,
-- 
Jens Axboe





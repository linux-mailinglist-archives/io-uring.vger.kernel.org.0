Return-Path: <io-uring+bounces-6829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F81FA46F8B
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 00:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907843AE6A2
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 23:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58DF2620D5;
	Wed, 26 Feb 2025 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hEvblqUl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BAA2620D4
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740613296; cv=none; b=PpslEIRnYgtVZkET2ABHyWDJGKbr1KJVEFY0gY0RZsOAsOBEBuRcjEIRGp0Gw62rcMXrda5db02e25h575xSuBYFiAnCam5AkUSz9irXp1CS8Wfrb1CSMh5Kh63kqI10dBfPUQmhEgJ9h8gksNCtaTTyAvD6uDs78ULJ3T1jutE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740613296; c=relaxed/simple;
	bh=PCZhV1D3DmrLHnB0jhvPcNF8Ns/umtxcfmD1DkZUBzs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XDjR/t+JhqvM+Sg+CyV8FCz6GqzOFKrU+FEgLaSUHK5JOqwxJ1TYD/9Q3MfKZtEpiRH498gTvLAvQJWltoaFhbU4tvj0ZaNsPTiUPYu6dK6mXPpOf8x+BlwgmjrU93NmsY+YfJTxTj0Ce3PZyzXpLDQvP0tXsFTPLKIw1A5spsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hEvblqUl; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-854a68f5aeeso12107639f.0
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 15:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740613294; x=1741218094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Stl6K5H9ErjJSpqsrfw1Ktv/Ek+g7zwlT0FkcItua9o=;
        b=hEvblqUlKxZUFApDTZu005NlZAHK9p+RQlx8kwGMlxfrODGBb4V1kksXuQUnJIzRjQ
         Uhaullsa2OOIXTcjBrX/BFmpAFksiG+fY3VzmJYztNvHkHbjqQZ+IPCya1oNAFaJIuis
         dGk6TXp69aBdgaV+KI4IA8IfhGPlUpRMOCCGhsULiFrIfqMcVFEgIki7i/jGfYevnJ5I
         2Ieq+F7j+ncNCN6K9kKhvALoTqoPHJHnO7RzjmRN1x8A+ckYWZMk/L1xmSPQoEsVZiSN
         wJkcL5ZGZCp4RzYwuQAzb0TFdY70IJFAjn8aDddhZVwovGS4JSmbmp1f5SuX5g9pm5dI
         CK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740613294; x=1741218094;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Stl6K5H9ErjJSpqsrfw1Ktv/Ek+g7zwlT0FkcItua9o=;
        b=M1PBBIqsC5j16pLAaZy0qRjfIWsVPEdxBLVnSRNf56jGyiT6JQ49zStK/fT5ViOi0V
         Trz03F6B2v9X0cprKl7Hdp0cbP5WszJrlaycsrnIyhFsQ3GyMzjSLv3Pp2uG3dGwiilD
         yVt9zvWZxO92qBqaEU0gqEH1QZgBZBSLPNKOTWOlCMtxj3QBQNAORSY91FJvvusf/fe+
         C4X0ap4+aWWiDr0LmtJ0amqQcupw3fQ9XjeEhwHYtNLtAI6fwbI/aHU7hy9oK9wSjoOp
         YPXPMKWZC+pyFa+gUKco5S+hAZ6FwrJZCRFgE9Sn6nrXR7ESnsmtrqFpQIwqJoZcv7BJ
         4TTw==
X-Gm-Message-State: AOJu0Yyeyb8c6mjD/MmX5oixcvSMRCTD560W3bYBqhoag63XRD+9n3AE
	5rFnAMG66FuaArixOBb1nD+iXu6DuqK7wSQ/UdMyMATPrMdRgG58EqkAPfWEa7s=
X-Gm-Gg: ASbGncvE9F80ZstfVAw+EFAJvawOsNYuT2e3+zymmzFVStlKSzr3nFbcmCJTbl2Qg9R
	YGgnSKPXBK8m1qX4PzzbUAQ0hbPEkqbrjHzz3waQ+RsX1f+9XJJp7DeifU67gbsdt301RGwF/EC
	u+y+TBQMFTfxm0YCgC7UvElHYeJ0i7jgZy59+be3DAK6+9wHB6alP2f/sr1yDFrJMwZ7gaFKXoT
	gm4spKhxjSLwWviAMpPkvpgf3Dg+yizGA7YwPy9fE3NgjI7/45/e2doTy4nrdq5mzwl88aG+HnT
	zuxCnxw0+xHYV8d+gw==
X-Google-Smtp-Source: AGHT+IEsTl5uEqWSyaVfM0qC8xbJ2FuhPDhn538V+GQuxcJwJ5kUnVS7CbA3WfilnCYh3bNZQ/M6TA==
X-Received: by 2002:a05:6602:1693:b0:855:cca0:ed2c with SMTP id ca18e2360f4ac-8562039da9bmr966524639f.10.1740613293783;
        Wed, 26 Feb 2025 15:41:33 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061c718f2sm85087173.70.2025.02.26.15.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 15:41:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ef03b6ce4a0c2a5234cd4037fa07e9e4902dcc9e.1740602793.git.asml.silence@gmail.com>
References: <ef03b6ce4a0c2a5234cd4037fa07e9e4902dcc9e.1740602793.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: rearrange opdef flags by use pattern
Message-Id: <174061329293.2398862.7714536188928920487.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 16:41:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Wed, 26 Feb 2025 20:46:34 +0000, Pavel Begunkov wrote:
> Keep all flags that we use in the generic req init path close together.
> That saves a load for x86 because apparently some compilers prefer
> reading single bytes.
> 
> 

Applied, thanks!

[1/1] io_uring: rearrange opdef flags by use pattern
      commit: 047fa0ba8f1bed6b1c5d88e31c4fd187de16dbc1

Best regards,
-- 
Jens Axboe





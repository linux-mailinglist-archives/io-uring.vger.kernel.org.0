Return-Path: <io-uring+bounces-6827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE86A46F89
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 00:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46F043AE6A2
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 23:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024E52620D6;
	Wed, 26 Feb 2025 23:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eQOq+7tu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913462620D4
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 23:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740613259; cv=none; b=dCAA0U9acH68KM/fKXEUBs96AboDA6ghy2dZd5I2RKt9R9zHu8UYOusvhOlNKIRfeFdmC4X44d/wQYhP7KtJ5w0lmuR7CPtrfP2TeyeCv3VK5WcudpQYrsK1jUQEdm6rLuL+xpN3sJKB5TjSGC2CLhnfy9zjdErVp3wr/QgBC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740613259; c=relaxed/simple;
	bh=lmvMhDGEU2iNxhRh1XoVShDjAwmQn1Lt/nH1CM37I3Y=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Zqitvf2kACV4KgSeO+hMca9MjGqgC2cxkU7yzEizI9wLrj9l3533FNGbLbzC7/b9JQKqNXXn2fxNb2KRQuaioWNE36wRR0+km3NMmqh+RUvPyOKZ8gc+08ORkO1dePxoBn4dtsYovPMYSSUKJvnhjhSrK5aQ/olkFLGKcCnDvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eQOq+7tu; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8553e7d9459so11768939f.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 15:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740613255; x=1741218055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bTJ8wyt+Kgq5iRkkK6d7fR0ZOvmAYB2xLlnCSZULf5o=;
        b=eQOq+7tuva6u6G/vn0D/R4SY+lY9H8z82/vqFNINVvwo2nhDOJddtm8nxkjZOp6Es6
         CPra5s1Q5jTkjKi/6g/piwjNWMaYPANUaQdscm3E6dyLrGCOi+mj+nqfnELKcFSqEGFF
         Tu4MrUrIm8qjV/EuztjX5bFxg8ve3fwIKFvupenGFV4KDKOZKk3XjSAiq+jJGRx5dBtQ
         vN+Evmy7fXEI9CLj6haBKvBorroT5qu7pzp8p3erUpPnTIhIe5X8k9O/G9f2j5gyOI+s
         04bwfZfPb0IzhCde2qNay791eFrPn4wbyrC3oNhPATFG/82/2KtdCjbNIGgaW1Rg5NBU
         fxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740613255; x=1741218055;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bTJ8wyt+Kgq5iRkkK6d7fR0ZOvmAYB2xLlnCSZULf5o=;
        b=BZk1qUu1I/abz/RQGNRI+nKfK/bHoOEhy4HFLyV2hcYx1jIyhIywPwEzUaQ1NHwm7K
         sVmjAeW0gLH9r7yzcPxYTNguhV1iWBHeAOBSOL67e9iqnYuPPrzBPS6mgfwRuKuYj4yX
         rqDvS4+Tv5Rz2RPawA4BwB9vqoPviR5bPxGOpOYTnQST7NnNlbDZlPCBoYrIdSx9Ch0A
         u/l+pV8pvAXx6CMAifaXpEVy/tv76xevZkM9ngqGA3gYo14sccO5P8qYTD+Sikl0R4ti
         DGfSpH4KOEGzpUUaTMW+b+ufLFJuJkslU+G1zQ3PxVdnMIakxg93K1RdwKYW/dGd9IIQ
         XTdA==
X-Gm-Message-State: AOJu0YzFUN7EHzQv+UjvgIEmfMJdL6iQaMf0QD7/pDRNAZD90zZWRWUs
	kTwPRLyL0opzjhKws0Nx6i81gfgDCoCv+6yaw8KkagmIg/MxZz+msrwLOPhvZexjit265bK96j2
	W
X-Gm-Gg: ASbGncuTU2maFVdsU31HGN5IFvl+f2+Pcp1gwaaGAxBlVDL9NCOO1YzM6MVuuernoEr
	ZaMCQG+J7R7PjzG5rOEgAxnmNQ7SpNGkfnW0Ukru6007wJb4KfZTwib9FTKw9dXHYbGWBaptgEq
	J7G/0ugB2socLDI4JcOr1VHPKtV10WkXujABEFhOygpAoLYSDp6kPXT11yn6JlvouE+1gf/dYjc
	TYpd7WUzNSZ/uDS8QH0kD2d6TIACmksMrSgFyaoFUbEKVZYwaNfkT4x3s4N+iy9qZWkI8Hx/8t1
	baUahOBQsal3RPV5ow==
X-Google-Smtp-Source: AGHT+IEDTfFQ+Ew7/L7PAgzO0hrpR6kDCkXvwIwJS4jbq+kvpKnLh4qGVwElVL76dOlt0AfvsLB9VA==
X-Received: by 2002:a05:6602:6016:b0:855:a437:141d with SMTP id ca18e2360f4ac-857c1774047mr635656139f.6.1740613255229;
        Wed, 26 Feb 2025 15:40:55 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061fa766asm81936173.133.2025.02.26.15.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 15:40:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5748afaecdf24e8ca1f1c9d407e809e8a485fe16.1740601594.git.asml.silence@gmail.com>
References: <5748afaecdf24e8ca1f1c9d407e809e8a485fe16.1740601594.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/send-zerocopy: add flag to disable
 huge pages
Message-Id: <174061325419.2398306.6441127942694229864.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 16:40:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Wed, 26 Feb 2025 20:36:15 +0000, Pavel Begunkov wrote:
> Huge page test is too heavy for low powered setups, so add a convenient
> way to disable them.
> 
> 

Applied, thanks!

[1/1] tests/send-zerocopy: add flag to disable huge pages
      commit: d507f1da3fae04ffdd61ba939cf2f024683e900c

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-8549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4760DAEE985
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 23:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AC3A189D9B4
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 21:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27588242D82;
	Mon, 30 Jun 2025 21:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fTpt2g1j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA13C2036ED
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 21:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319587; cv=none; b=lIG5gjEv2Q9G7mpTY1vDBXAka/HxBMQt/T8wAe1N6+tt+r4vV8EEDNHZ47zX3HsAqQJkeKhBRyco46IV2hseXXM9kBgKWjrbruWLdP2euQcceZ3Vh6SJ7bNOz1990kGPOXcuTYCuL06qLi8UtZvUEgdPsLnrbBuvuqmDr5gTWYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319587; c=relaxed/simple;
	bh=pwawUxuTJKMJ0eihvMj0l2HZinYV17lWiqOb1DIZatw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KT7Kh/JruWr3Ubf3uLuEWPH32TZWK93bEaIge2uHK34JAPBeuAGCFovBtqn5Deu3uaXrZe2A2p5Czuxa8KIe5NHNd+LVF4CtDGoq40tnLFSY8XdZkyNWL52h4vD2gnrBUDvX0TkSDmfflPIzSN2RLZqeIRe5hHsgD2X3WiV9hTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fTpt2g1j; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3dc9e7d10bdso8312865ab.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751319583; x=1751924383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nx5J66R25s/M941oKLiPzdOIFt0QLiFvc7xJpi+QQqI=;
        b=fTpt2g1j1KaXEoiQlHeafM9hSlJkAR2Qsvs3jJN7+mxW9nzt2Ciw/wAYWnLlmUa6px
         oYoXhP7k3ZWKykhbQxfxJNIqOZ3ToS0eSxFXbNItFMTUVpbbs4nEjBFDV5e4cFt10EMi
         lzuHzV3VWvPcad5e2A3tahg/5luICcErhzUYTNMUbT55rtlBQitBzyXs1ZImdVg1egH7
         V8/p+38KVRsHLI0WtGhVdAj1OVxmLkMulbO3CkeR5VrX/SqxIQJCAIncp6+eq6Qd2VhH
         BhyC8kjNoXBOZHo0Qtk5WFJflS7Ut2v7G6p9uG8VozLxniZJfgsMjVepmnbTQNEYzlXO
         jHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751319583; x=1751924383;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nx5J66R25s/M941oKLiPzdOIFt0QLiFvc7xJpi+QQqI=;
        b=lG/v2OS53HLYoAqHwAR8x6RrKgUM1179Ajyu5aJJWgDrieuVHzSgMvVnRLdpPxnhco
         zdZD3mhA7wPF7ReOTchqxqNDGdEtBT20sUEKAhF+CQ103gn59MLjG5gGAInK6ws5d3PT
         ty+j56VT1Duj7J/VDhGKlJcP80rXfgHKjSC+LG5wW3um/ntKQDHh4h5GvJf3OVrEYkH1
         Fa2AxlnUu55GAblAvcxEIKXdJM54qrxtbQGZPqH7Ka7h4t13jN4JROtuW+SRuaCdoJuh
         V3L4sPujhbVLkGXGT1kDGisZqMvHw2t4Brs8/Zr41fnjyfi5v7r9bKV+aijCW0/DHnA1
         DjXA==
X-Gm-Message-State: AOJu0YxH3HxNAZh3AIj7MSRgBD6BE9hEmiA1GxrGGGSzvHIDILlBvgNT
	TeIUXFeqCgbcLD2CDyEFUYe+MDGXiSLT4pLjGhD7g2e6BXJgmumMtmX5vyFKQKu6w5uDRFV+mR6
	jgnrR
X-Gm-Gg: ASbGncsUoShXHLc71NFCGevfqwn6p0Tl5+a3bxpxiobnPWQ2AaxkpT76KXEq5IsmSRk
	qzdDhoY46C7GDHFnVfPMlKUn0BkEEX2ONlYY6hrIgKd+Mytfp8p25kCKbfv2IP5wXZ3o2cf21xQ
	HlUvZq8/3AgvOjRmHNJAQ3Q/1jtOFztXtPe8ZsDqkuwR0LdF5S6zZMC1vb9eVJFzWMHxQbs//tA
	9JwE6DXNBE8VffU8CjI41vrO0BLyeVfRoXYva4ZVT3IwkPZWwEPTfP99kO5fO4VbflIuRzTWnJ1
	nerRMjyCnWqPEBf9x7msSAIilFwjcaPKWDDs4lJ5S5fM30jBBMUnEw==
X-Google-Smtp-Source: AGHT+IGFZ1UGeRClqiUXKlzMceHpj7brXENqsvG+bvfkY2FdCvIG9Gw0zeAAdhwMDcM3lkPL4MxhIA==
X-Received: by 2002:a05:6e02:4506:10b0:3df:4cf8:dd46 with SMTP id e9e14a558f8ab-3df4cf8e0bamr92283245ab.10.1751319583358;
        Mon, 30 Jun 2025 14:39:43 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df4a09133esm25220145ab.41.2025.06.30.14.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 14:39:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 Christian Mazakas <christian.mazakas@gmail.com>, 
 Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
In-Reply-To: <20250630203641.1217131-1-ammarfaizi2@gnuweeb.org>
References: <20250630203641.1217131-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] liburing.h: Only use `IOURINGINLINE` macro
 for FFI functions
Message-Id: <175131958214.269614.649326071375683625.b4-ty@kernel.dk>
Date: Mon, 30 Jun 2025 15:39:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Tue, 01 Jul 2025 03:36:40 +0700, Ammar Faizi wrote:
> These 3 inline functions are for liburing internal use, it does not
> make much sense to export them:
> 
>   uring_ptr_to_u64
>   io_uring_cqe_iter_init
>   io_uring_cqe_iter_next
> 
> [...]

Applied, thanks!

[1/1] liburing.h: Only use `IOURINGINLINE` macro for FFI functions
      commit: fe1fc8c0516954d345ee5f7613b8e4740b69b9c1

Best regards,
-- 
Jens Axboe





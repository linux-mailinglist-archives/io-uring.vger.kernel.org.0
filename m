Return-Path: <io-uring+bounces-6026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EB9A17285
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 19:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 274A4163C98
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 18:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D3A1EC016;
	Mon, 20 Jan 2025 18:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wkZAwit1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E939C1EC00E
	for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737396428; cv=none; b=h8g5YC6xpFNpsmbI7pIDqnI5koHATyl976yfeIgATuNVUj3iH5H5QBQQA2GSKlK9v8ow38+J6nMsKAfrhUDEqNfug7a/VcYniZhk8FD0BmD/cG9wORW2zog7KJMFRaO2lshM6dezEgJ0cJraTew7JkSZ8dU8v+b12MssapMdDso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737396428; c=relaxed/simple;
	bh=8AdyMzVl3VyDGO8YGEbcZY38N6ptSUkUngU1LwT4/ik=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EKRfZh2puoWvIx0uhqmtFfjzBXiaq3RewYmoMqTyCfC4x3PYyjjcFS8gpWsgfn1R8yRLNZ8ab13kjV5US7PViso/SWgwMlPO4b642hJEl3XFLKqvp654LJt/olCMbAhKrgR4wE6d9J7vKqCSru1D11YHygsssVJzf5hWuHHvrWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wkZAwit1; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so374431939f.0
        for <io-uring@vger.kernel.org>; Mon, 20 Jan 2025 10:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737396424; x=1738001224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tc6EjsY8XkMBH4MPv8CRSs+PVzget+pwyf0+O80F6gI=;
        b=wkZAwit1/9DhYwcvlgfDSsZySc5dUwv54Rsnwlj1jFbUEz1srYKpZ92nDRU+obm8Y8
         6zKgSWleqp3R500F8TA+13SOGLiuaJd8/icWlkaKJDJAre1dp66PuPJyFRdKHoxohZE8
         RLefVQKnolCKeGEdkusuD7xtxTn4yzoBnmOByVnBma1Wb/Jjdye8Tj8ERAhFCnZG8h1J
         jKbltXL709EgE8JpBMuDlMbO+10gy4N8Gx4IN51Dy2LPfKunbCkTmxVXThPrbOZ/w1fx
         c2XRorOQYoNNz7OovGYFR0Lms62m37g+GinAwbTCn/dY4zX16SVj+cUvYy+/UrJOxaRC
         3Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737396424; x=1738001224;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tc6EjsY8XkMBH4MPv8CRSs+PVzget+pwyf0+O80F6gI=;
        b=jXTROFeX/w0Ih5XMQyulIWBKfn7ET4msmOjZ4pnEQxxkDXT8fDVXaTQjQ3ZU5Ll/Yc
         k9F0lQUOxvgQqh/eBq6g+6dfwPy8IC8FrOmB0ijmb+vp32FTfZVyGbTc20LBrPPwqP9P
         QDfOssqaVBWmIVcNprVHJOPW46OAq/BYKU55SBE7GZj0C4tDpLxch1F2sbMjpIKE6xML
         bcpjCJqemIH8hAkIYlZV0SGxDfF42REFyisyTPv/4j/uNEICfXKFm/uU3puE40yhJ7ay
         qrpxTqUTG6dS3UX4354TQyQ+u8B2cPw5dDA3PCQyVOlhaeS/VBivDByQ1HSse05yOzIU
         dk/w==
X-Gm-Message-State: AOJu0YziJTni7S5UHJZlgx2XMoTmksoHFLff6uTzWhjQCmgX+P4/IqFT
	iF44U2sZJ6zXENIyzsp240wtIoepP7MI6GMPiJX8bawTDJQZitePcKCHHzW/UeE=
X-Gm-Gg: ASbGncsDfrSJS24V+h7qoRCwr7IRmk3A0e+rWEv0uW1sTkJc3peA0+FoEthrrwa7N5/
	O86iANry/6Yz44xeSH/REK/ucmqTCgy1MiYpO6YFRZFNGy8qdqdzSiZlVdZax0LougVtJRBqMFI
	BcAFMNKlSMJnyZRlh/f0DDN3A1ve6cNmCvD/s3u4DoICMsFTVyOjt2VG/yo/w75oWLEFr3BEtVO
	LC2QuLwBs+fw5AtMv/p5dyOU/53+tEukv8mIx3iBp/KGfzu7FwHW6lOoYd4OxzgH/21NTL8
X-Google-Smtp-Source: AGHT+IGPw5HyUk2SgXUvSBgUaH4W6NMJLND5LcuhdKNVUETW9RBbUW2uvTreOCdvMesDSPA7wm1JIg==
X-Received: by 2002:a05:6602:394a:b0:844:debf:2b42 with SMTP id ca18e2360f4ac-851b619fc96mr1314858539f.2.1737396423709;
        Mon, 20 Jan 2025 10:07:03 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756bae75sm2661825173.132.2025.01.20.10.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 10:07:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250120-uring-lockdep-assert-earlier-v1-1-68d8e071a4bb@google.com>
References: <20250120-uring-lockdep-assert-earlier-v1-1-68d8e071a4bb@google.com>
Subject: Re: [PATCH] io_uring/rsrc: Move lockdep assert from
 io_free_rsrc_node() to caller
Message-Id: <173739642251.137076.1833330906555536038.b4-ty@kernel.dk>
Date: Mon, 20 Jan 2025 11:07:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Mon, 20 Jan 2025 17:21:57 +0100, Jann Horn wrote:
> Checking for lockdep_assert_held(&ctx->uring_lock) in io_free_rsrc_node()
> means that the assertion is only checked when the resource drops to zero
> references.
> Move the lockdep assertion up into the caller io_put_rsrc_node() so that it
> instead happens on every reference count decrement.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: Move lockdep assert from io_free_rsrc_node() to caller
      commit: 8c4b2fd5908d2260dfac8d4b74aae1bb5deea379

Best regards,
-- 
Jens Axboe





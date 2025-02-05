Return-Path: <io-uring+bounces-6276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B27C8A29607
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 17:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19CAC3A3637
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 16:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A192F18CC1C;
	Wed,  5 Feb 2025 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yo4v88w3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C69816F0CF
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772260; cv=none; b=J47mmUBTmzJm45h6ykyyEH4P6j8v7cSfOTm5zdgGEGVrZdeIbzOOgPdQZ7z2e6ujf+3Z2hYGHCIoHVPywWULzjkKVEkVfMOcMsWLZ4RoeDCmhgLOCLovAjEQJhvnph31tSXc+QMrd5usS9XlxXV2i22sP4KYd4cQJqemZyzwpJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772260; c=relaxed/simple;
	bh=W3MSlFjahOVIws0rzaiqoOjmeTf4lSvp/oe/xS+dCik=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=my+DLOktGxWr+PaLyWDVUKOKdTkPFYfotWJtIjtt0VZrV8PAu0Y6O3dHFVUhSfSJ7SuwyUbp7/RgWhL9HsaRktrAs9bs1jEp7NdRzYzgYd0vekJlKs8wC5hKBoQ/CqKZ/iPwYMRVrAIzTvOYwBQ5BzXfD8uHUXLAuMhHEIXY4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yo4v88w3; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce87d31480so21468885ab.2
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738772255; x=1739377055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QA+8DliALI9Z2Spldgca9IGZZV/iEIBlyAMHDhodVoE=;
        b=Yo4v88w3MQedac74CJBaVwo2YnHhorNFmjUoocEbdgT0lDtnfULTmL8l475vsB/tHO
         Gu04FcOU7qzcP/B/nyGWGzF/+0AgR1/6GH/YKaWH3l+Kd7nLL/XG9T2faV/LimqAuH6r
         1wa/BPtLN2MF+s4HRaM1KdhAGYnx2LhtIEAkNuJqvJ93MP5+7ztXXikVydFd0P2VPHii
         i6mcvZcovqjwnm+WV2ME+r12EyAEX3V3oGM5RTZ0uySCrDnu2L/eiclT0Y/5h5CdyGpo
         f4RS8WEDuLJSxpf4f7AKX3/Mson1iGt1iEbZ136F1ySQ/aaPHnpt3n3cMeq5mt7n2XmL
         pJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738772255; x=1739377055;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QA+8DliALI9Z2Spldgca9IGZZV/iEIBlyAMHDhodVoE=;
        b=a2lstqpiO+yHm5Bh9j1W7iJ1b4VrVjFP77H9mmucSqX7lPIsu1DvRCeeQs8Hj8/s2q
         219ixpjauLelijqm8j6wBWjc8QWHpDJ61efuGLEvwhK3rgJh0B/ObCa3yGirxTxOz5dX
         SxC39wBN07VzxoCr3WncoEV5PFzPZYKgCTbusYcD3EI3QCSzAs6HxQaszs7t5vzxwdII
         nY2izEh9UPZWImPpw1BWlqI+IoHQ6a4SA3cjpWwGIoNoHm0pU1FyrycjoLyQHuasOk1W
         iduzuSbUt5iHL+sJ8Ge50NfdsG9Twd3POqR452/hl639Mz+Fnjcblp/lBRmTeJo4Y9zX
         xtuQ==
X-Gm-Message-State: AOJu0YxLNBYr3k3a/KdqahK1xyQE+m24ShFFirzXsr/kzNqNk46fIxRt
	w0WWQCK95+FKoxfuME/U5PpTzsHeq/jLN+63hXUm9sn2RMKEMg+hWgVEOtpEPXgbIV4dZSJmyOS
	P
X-Gm-Gg: ASbGncuNjdPQLYl4UsP0kifwWNwm+PAquyZltjIuxcWyNJfTHjHpI+5ErHl/Jfor+ou
	dHp8tjKTkkg7nOu13xDsqbwv36ykMRYF/1qXO0Z9SoREO5cSESvfBc02F75ftZlXdenTEXaydex
	wuzsB9zsuImnSaF5F4tcVQtdAUGqGBZRLJRWsNqdNmnvqJ9JOvBz91xwal1aVmDHL0wxvvJ35lP
	fozAEbl6tvyb5LJjvkEiwLbQ03Qwm6xWk232gRykm5SZkclfVxDYAI8cnWNpp7t40o7IGHAFHNk
	e6dSpg==
X-Google-Smtp-Source: AGHT+IHHKAeSPgdDo4HS7KacPzGWhCV57cCjrLwR9AlcMPDI5iGyMSiqEiFKwRILSTOrIXheqHo+KA==
X-Received: by 2002:a92:cda5:0:b0:3d0:4d38:4e5b with SMTP id e9e14a558f8ab-3d04f922983mr36060825ab.22.1738772255207;
        Wed, 05 Feb 2025 08:17:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d024b0a2f9sm23807825ab.42.2025.02.05.08.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 08:17:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/8] legacy provided buffer deprecation /
 deoptimisation
Message-Id: <173877225432.553753.6796684271469860272.b4-ty@kernel.dk>
Date: Wed, 05 Feb 2025 09:17:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 05 Feb 2025 11:36:41 +0000, Pavel Begunkov wrote:
> Legacy provided buffers are slow and discouraged, users are encouraged
> to use ring provided buffers instead. Clean up the legacy code, remove
> caching and optimisations. The goal here it to make it simpler and less
> of a burden to maintain.
> 
> Pavel Begunkov (8):
>   io_uring/kbuf: remove legacy kbuf bulk allocation
>   io_uring/kbuf: remove legacy kbuf kmem cache
>   io_uring/kbuf: move locking into io_kbuf_drop()
>   io_uring/kbuf: simplify __io_put_kbuf
>   io_uring/kbuf: remove legacy kbuf caching
>   io_uring/kbuf: open code __io_put_kbuf()
>   io_uring/kbuf: introduce io_kbuf_drop_legacy()
>   io_uring/kbuf: uninline __io_put_kbufs
> 
> [...]

Applied, thanks!

[1/8] io_uring/kbuf: remove legacy kbuf bulk allocation
      commit: 95865452e8b06974bb297891acbb7e5a6afc8d4c
[2/8] io_uring/kbuf: remove legacy kbuf kmem cache
      commit: 6ad0e0db0d81c3e5ddf3b7ce84cb937590f724a3
[3/8] io_uring/kbuf: move locking into io_kbuf_drop()
      commit: 615da6b1d03b53efea22faaab3f1a3d21888ed72
[4/8] io_uring/kbuf: simplify __io_put_kbuf
      commit: a6fe909acef9535dc56327b1a872466f080be413
[5/8] io_uring/kbuf: remove legacy kbuf caching
      commit: 30205b4708dcd3f2823377ae55afb953a05a2672
[6/8] io_uring/kbuf: open code __io_put_kbuf()
      commit: ac6757c5a032c800f927cef1245b81a3b4fabbce
[7/8] io_uring/kbuf: introduce io_kbuf_drop_legacy()
      commit: 3d692b5b37fc755eb35881c0f612ed6f00ac7b11
[8/8] io_uring/kbuf: uninline __io_put_kbufs
      commit: 641492f1733609b7abebf74ea9ebba6c29b84e79

Best regards,
-- 
Jens Axboe





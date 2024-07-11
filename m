Return-Path: <io-uring+bounces-2498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEE592E15E
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 09:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774FD282185
	for <lists+io-uring@lfdr.de>; Thu, 11 Jul 2024 07:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB80B14B943;
	Thu, 11 Jul 2024 07:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IRdbCcLP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C9814A633
	for <io-uring@vger.kernel.org>; Thu, 11 Jul 2024 07:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720684472; cv=none; b=KawYa3U9p7Jsa3EShMp4/4S7NaE9jsUlsTAy0TV6RHJ3N7FCu32P2NBHbkAnGBgvwtm62XgvG65vYf8QCsUheOZJYoaXqS5Ib8Hj18z6prBug4lISGoEJB7wPOilmzRToYIX4IL9GJoX4aqdRLwxsb1TcYmktvk7aDcmx6LtXc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720684472; c=relaxed/simple;
	bh=A92cYfBEW7Y3ABnWziZPRpDNTgfCIvtH4E/vUiYo7Us=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LeKtIviQ11FOezq0Pl8tdri+oHStn9FKQYieh0+X2B3JKuGzOiptPbrYzGi5D69e6q5hIo7PFDvm6cypzjcsOS+wGv7fRE5tcX0aVUHHlN3l+Y55Uw+V/5IBUPLNd4b2P+9H4tsSTbjWxTYwf1Bx+ytBFVdhV1ufNJcg+/zIfII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IRdbCcLP; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ee94169e66so276881fa.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jul 2024 00:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720684468; x=1721289268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIvPtYGCegg9+pbyH7kzgxVBSj+brhikI982VwxShJc=;
        b=IRdbCcLPJyajc8nRRPOHpsNhMAwJJkR1L4oMgUIOdxAcWg+d8xfz5IPXG1jjxur9Mf
         SbNQO29OPhiiGHYqYGqcVfVvbQG1D8WrAdcWfLwAI1LsfU2WJJlYUapVJmAjSvhBXYZK
         U/b9TQQvHSDZ1Kj9q6ZU1D3LBS2o+keeF68PLoxA7dp/svxgpwkJ0ARWgYg8slMc29WB
         LJ5z4+YYQYFatYe+lFBMvtoA/9m+KnUdQzkR36J/vJ1bUWZ/izQPQlxb55SvbFv8XWLO
         h8A+Q6t11EK97zGVP+lTjFgZTofugPol/jDR8xb5L5gINQqlwxvr7qN0d8/iirLySdzh
         BT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720684468; x=1721289268;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIvPtYGCegg9+pbyH7kzgxVBSj+brhikI982VwxShJc=;
        b=YzwC9k8Rzc2K4IqLMbHwbJ9S/XL7V9STSjwMOq3I9Aepk9RuLDezXBGNFIpsCRCeaG
         NK2X9swY13tGFOjwcH7pK3BcuoFHcjIIZdgmSkB6UB5QR4qBGNNKrZEsgN6VvwldDSnV
         LQJR2Ge8iXnyMJ6tEdWESc0EQ++S0dJeRzo4N9xVVz5AKpyR7a6xAi9wkSl4OahhoVwE
         KaZwi8S1sL3QQxaPQ4iBmifzBze+3S7LoQW5NgQWoulRIgYNWw3GthTTJJ9KGKBWnm5C
         V77FUyt14I/NRPWMhTav3ZmAoIuK0KfHobDuBLc4mbEGvO64Do50iGpi6CWSX3bzTXVX
         EccQ==
X-Gm-Message-State: AOJu0YzCuYtox2XDPFXLDkyyL6zdvykm9u7W9KBOGDguTNnl2pxnSMPD
	wPyEgV1a18P3nn1HBEOlfKDl1Wng/WwZmgRE8wHSzTpuuGoLLP7Evm7jSCWanLEst1s9gETf5Dm
	yYDABn0nV
X-Google-Smtp-Source: AGHT+IHFZ82UsJR7gXGZBhnud53dyW1eXMgpAEcT6yABHF3RycaKBs0ap+1Ma+a/PT2YdTmftJhYfQ==
X-Received: by 2002:a05:651c:2129:b0:2ec:4287:26ac with SMTP id 38308e7fff4ca-2eec98c72c0mr9505191fa.4.1720684468016;
        Thu, 11 Jul 2024 00:54:28 -0700 (PDT)
Received: from [127.0.0.1] (87-52-80-167-dynamic.dk.customer.tdc.net. [87.52.80.167])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2eeb34751c3sm7778181fa.94.2024.07.11.00.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 00:54:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christian Brauner <brauner@kernel.org>, 
 Tycho Andersen <tandersen@netflix.com>, 
 Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, 
 Julian Orth <ju.orth@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Tejun Heo <tj@kernel.org>
In-Reply-To: <cover.1720634146.git.asml.silence@gmail.com>
References: <cover.1720634146.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/2] fix task_work interation with freezing
Message-Id: <172068446669.395668.14041206933640697434.b4-ty@kernel.dk>
Date: Thu, 11 Jul 2024 01:54:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 10 Jul 2024 18:58:16 +0100, Pavel Begunkov wrote:
> It's reported [1] that a task_work queued at a wrong time can prevent
> freezing and make the tasks to spin in get_signal() taking 100%
> of CPU. Patch 1 is a preparation. Patch 2 addresses the issue.
> 
> [1] https://github.com/systemd/systemd/issues/33626
> 
> v3: Slightly adjust commit messages
> v2: Move task_work_run() into do_freezer_trap()
>     Correct the Fixes tag is 2/2
> 
> [...]

Applied, thanks!

[1/2] io_uring/io-wq: limit retrying worker initialisation
      commit: 0453aad676ff99787124b9b3af4a5f59fbe808e2
[2/2] kernel: rerun task_work while freezing in get_signal()
      commit: 943ad0b62e3c21f324c4884caa6cb4a871bca05c

Best regards,
-- 
Jens Axboe





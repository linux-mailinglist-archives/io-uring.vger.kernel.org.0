Return-Path: <io-uring+bounces-8053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B57ABF517
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C417217E794
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418D72D613;
	Wed, 21 May 2025 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Tfobp1va"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809DA26FD92
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832534; cv=none; b=MgetuMux57PrMDqHWMchBuEXwAxR9Toh0enKeqQSjHjk+fLK7fM17jFzo9ylCxLoZcgXmMMlXZHqipWFetBpN/J4GXLCYKvrP3JVbUNdo8J+llYoolgqJkFNsTCaRQ2+B9xkEjebveX9j56wfQif1ptgT0qzaZfr+HBp3guwH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832534; c=relaxed/simple;
	bh=mxgL0rLrZs3SIXWy3kJYU0JR4DO0Frc5fC+X6w3xA6E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZKBut7l7AMqm0fcPfkzbB72f/KN3YX8skvXuFBdFlWVqAp7Xj+HqoD8DenwDI8U9G0KcLS1gh4Ch58VHGoMqRiCQwgn6XRzKDxU06TCmoegzvisV8IpnJXEiGtHYFwtaWxZGYWVz2+Exv47P1v4InJa67aR7VDeT5Ha60T+NoZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Tfobp1va; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3dc73b1bd7aso17482935ab.1
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 06:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747832529; x=1748437329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uGIxR6q7gPTeUGmIU4ayMh8hbEC5ns9ioJ4KiylS2pk=;
        b=Tfobp1vaEw5t2RsMfYEPxiVRyhT1l4xcSKftuOb+31Z7GJhupWd5zPCJZQcN8RfXMw
         dmOAV8D+woDVnPOzG1RDFykIxqh9RX0ObPj7naeDuwU0YaNbhN/pfSeZDjqTJCFPzNmH
         imqA9fMPt3WHrPhqCZBm1DRTEFN/8iW6zFpo1DHbVuR8/J+JxKIPRD/T89gSzRezv/Vf
         XWS9cxZrJafJ+/3DWhVYKY5if3ZGUHwsAI9s8Wj9tmK8I6ymLJ2ZoXCtl3XyCBFaEbow
         VmVTOM2FLsvBL/M090l1jzyl5pPtc1/GuvWPflU4RVRpt2KkNxd7ffHN6ZX9k0IOEtM5
         gZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747832529; x=1748437329;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGIxR6q7gPTeUGmIU4ayMh8hbEC5ns9ioJ4KiylS2pk=;
        b=jSAnUHRDk3qKa3xlVLXZFbegzWb0/NvpPBm+n5qW64Ya6OY4501zvdaEHS3NASRP1i
         pDNZW+cocK1SMzl2uw2ibF6gmqVc6qL+/ro7hMGLm+kSZ6RQ7lyW06rXTnCad2/liEub
         dtLoXagx60xeRr9nVeY5lADtnYF0OwNLjKp+yv6+vP/O4seYUFAJCFP8Pa6NBkAqvIRc
         HW6UPr5cD7hY5wlnU7ba0ln8ka0LeFIrJa7VKoxTXnyOVsNTonUFkegQk3gYtjBbq45A
         2+FLxdQ3iIBepTqqh2uEY2gJVz4xv4Ng2Cac6z9pVE+hCd+JVAQAyrLoAqiNq6bh66i4
         j+5A==
X-Gm-Message-State: AOJu0Yz0IQxnoMtTMjSvnMxz+9fSXa3CYORMv5Qv0jqihr/sbt3qYH/P
	64ux8OyYpBFdaWBOJTG6fwH+EkWNp1pGS8UkesUsbxzvPwlLFFFb91iQZU1kKaMeSBpRxmlnMop
	stSgX
X-Gm-Gg: ASbGncvOf3nTtVgRyKkyrHTzdQlEqQzPKB+0wzsNfGFWklOXepmPXx3C/GisX3cvhia
	8CDSDmNw9OEa2JtAqG0y0HTcSnmf38GGUITJicKYcS+ReawE8ybHTsbQx7vsh7cyWgAqLhZMb4x
	gZ9fCrCiMyX1MD4kKiYVqIunb4IWUMe3wZdpZeqXvOwSKGZ54ZzriJu2qGg2N1xWRT3W7nqaysx
	tzn7juFEbJqMH/Vq4/ha1nsQ7WDNjL5D67UxSXIx5vJ11s1mgabNjCrnL8N91rbN+4Z5CWSldkh
	FwnYMIzMsOl0/IJJbBynDHDb5S/u7+CITNtAM81CRQ==
X-Google-Smtp-Source: AGHT+IGPlooLitYGbmGjh7TEUuZKkczuR1LXXAE9g7aHTCvfB8bI12hue3bl3DgueVlAH8H7JA+dGg==
X-Received: by 2002:a05:6602:4019:b0:85b:3885:159e with SMTP id ca18e2360f4ac-86a24baec5dmr2875752839f.3.1747832528675;
        Wed, 21 May 2025 06:02:08 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86a2602eb68sm236955239f.45.2025.05.21.06.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:02:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH v2 0/7] simplify overflow CQE handling
Message-Id: <174783252768.802301.7494120185111906318.b4-ty@kernel.dk>
Date: Wed, 21 May 2025 07:02:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 17 May 2025 13:27:36 +0100, Pavel Begunkov wrote:
> Some improvements for overflow posting like replacing GFP_ATOMIC
> with GFP_KERNEL in few cases and debug assertions for invariant
> violations.
> 
> v2: nest another lock to get rid of conditional locking
> 
> Pavel Begunkov (7):
>   io_uring: fix overflow resched cqe reordering
>   io_uring: init overflow entry before passing to tracing
>   io_uring: open code io_req_cqe_overflow()
>   io_uring: split __io_cqring_overflow_flush()
>   io_uring: separate lock for protecting overflow list
>   io_uring: avoid GFP_ATOMIC for overflows if possible
>   io_uring: add lockdep warning for overflow posting
> 
> [...]

Applied, thanks!

[1/7] io_uring: fix overflow resched cqe reordering
      commit: a7d755ed9ce9738af3db602eb29d32774a180bc7

Best regards,
-- 
Jens Axboe





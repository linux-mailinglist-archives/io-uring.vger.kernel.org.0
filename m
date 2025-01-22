Return-Path: <io-uring+bounces-6047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F93A19935
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 20:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5F517A02C6
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 19:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626AE2153CB;
	Wed, 22 Jan 2025 19:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xHDpUigU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD11BD9D5
	for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737574733; cv=none; b=WoG6E4gUGovm4AO2qsSAJAYbEAKbQZvrbs2S7hqA77bqLtt6Kt/1x7XVAB5DRhlUGKmmh9+4JCKa4Y4HCSw9ErOySztp4imgWNtKTgXMi2md/kfvfs52IpiqtycKqPT54uDM3fWwnw+EFPHqnqGAsXm8xrcfR8g7eMbPy8m/ZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737574733; c=relaxed/simple;
	bh=rUGb53kbsuFhIKozJVIulpwD5zMzY00D2k+JS1IIyyM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rhn4gKdf4640jO0ML5/HMaSk5MIjGZd/0kXmUdCGtOiGMebRZZVR6/ODo8sIMFD+MYnSrH/L3QlBOO9pEcp3epTvmgZbobMLXDIKY6uLktg1k8Nvvp5yG3zpsQ5cl/d4H5zbkj1nU+ml3hNjsWHo45JQsAGvyzOVihngVbTX1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xHDpUigU; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844e12f702dso4584639f.3
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 11:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737574730; x=1738179530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5S5Q979Dml0jATrPlGh8wDbWpJUJWKPaPtmNGE8cbE=;
        b=xHDpUigUUSziL6JjONGaCPtHsAVa7NIg3dnIPHE2FQUD08J9VKiY7SUkwDb5S8rmAS
         g3BlV4/TgKFLKJUP7Nb+mw+i09HM65tTwjU0odINu8NUV0i0IzhYf1UHTJ0DYSo4H2dp
         EmlgQq7cA7VVV9/Ayi2H7AsTrTh+2ZOo8EsQK2l+8FQwQYe26TOs6ttrGFGg7LmRCZ83
         pOQdPqCVRdw97PP3HbQ3oXwiDFE1Jy6Xwskhamm0w5/LaXMyqCObs/GamijfyQQlxb80
         +WquAglRNau6AR5yys3YN1kOgKi0BrPeY/N7nhWRTcijXKiRHQeVV38ptuLvBvpU/qdO
         4AKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737574730; x=1738179530;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5S5Q979Dml0jATrPlGh8wDbWpJUJWKPaPtmNGE8cbE=;
        b=jAZmmaNjLBbnJOUQF6tSRi5Hw649nDJdOcozk4UhvoDrISnsuRz8aGqZ+yljEqnq1X
         4KEZEYHDbsiIoGjWJmwwzOuB9u4j/nxiHrbbKxYcbEo1EQaKyWbs1GOjdX80pI7FlXy0
         ajlT52VWtfIFZzIZy53MZaFGcb/PV3PTsfT4S7opRtffcRVcKUSQA1HWQErt4AVI+upK
         K5B5xmV5s6Oy8c7ISNGEmdE9ruD6kYInvijwu3RrZHK8enkrFsdljzpOG/RaeRICIQrE
         cy3uK+3dUQLjrryY9Vzb/ld1OdsggjFxsVfUV2TendltcEr5jIrRyIqw777YNuXfaxbp
         MXBw==
X-Gm-Message-State: AOJu0Yxq6Y0FBg6DG26jn8uJFuvEHgvX3pkPKyW6mfuaTURDRgwazcm5
	jZF3jVnfJRF5s2isIH/EwryMtp6nXc+bqeBoJ52RAgXlEr93ffJS6PZvYY4K5z2iokRoSUL0r8j
	e
X-Gm-Gg: ASbGncv5Gc/sRuv2+9/gDpd6YdQG4VS0uHjDrFNXn3ZGy1LjGgTaTSap+UY2/BFNwZh
	QS0+qP9P99vKhUUxrFI9zh8TlU0uBXDSY5SLDT9gC6bEqnPxIvHe9ZHpX9U5Q8AHhoHu8Sz/c/t
	X5uYFVPKGe6DCzQY9rPiH6UW9gViNT8q9KeiWkCUDGzqcnE9y/zrAO/F8Mv79K6KqfqY1KnykGJ
	UpOGdM3yJIbYlgYUwgRQsss0qHlYk8MHti8DA3gaec1POGArOuHMZ+pUpu6dWaMGFmBLfs=
X-Google-Smtp-Source: AGHT+IFrd4pRfYIoTGvmOE8EKiN9TFK0tdSHaF7aFCm13yY2ZSQhs96GY7+fsWlT3IpfgxU7CoEaww==
X-Received: by 2002:a05:6e02:180d:b0:3cf:b012:9f9d with SMTP id e9e14a558f8ab-3cfb012a0f3mr54957055ab.14.1737574730626;
        Wed, 22 Jan 2025 11:38:50 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71ab33cesm38072785ab.42.2025.01.22.11.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 11:38:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
References: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
Subject: Re: [PATCH] io_uring/uring_cmd: add missing READ_ONCE() on shared
 memory read
Message-Id: <173757472950.267317.14676213787840454554.b4-ty@kernel.dk>
Date: Wed, 22 Jan 2025 12:38:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 21 Jan 2025 17:09:59 +0100, Jann Horn wrote:
> cmd->sqe seems to point to shared memory here; so values should only be
> read from it with READ_ONCE(). To ensure that the compiler won't generate
> code that assumes the value in memory will stay constant, add a
> READ_ONCE().
> The callees io_uring_cmd_getsockopt() and io_uring_cmd_setsockopt() already
> do this correctly.
> 
> [...]

Applied, thanks!

[1/1] io_uring/uring_cmd: add missing READ_ONCE() on shared memory read
      commit: 0963dba3dc006b454c54fd019bbbdb931e7a7c70

Best regards,
-- 
Jens Axboe





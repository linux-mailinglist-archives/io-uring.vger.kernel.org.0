Return-Path: <io-uring+bounces-3064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07DBF96F5EE
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34FF61C23F63
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DE21CF2AD;
	Fri,  6 Sep 2024 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YYFe78Sk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F821CEE9F
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630881; cv=none; b=g526MquqkCmemklQwc6ihdTpOrXbVQjlUS9sVrtpZOFCiDqr/A88M6KUmB3t2Qmk9ZAvkYxOEMKxqRxQZOYB6qFt9LoCChi6R98h/9mCUorINbVmWYe4kL7AoDsv1HkVWfZu33ioGUWHrNDtxoXo6p48Ubh+g9CwTi9rbyjRsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630881; c=relaxed/simple;
	bh=ZsGwDCIN+lDkAH0gWM1wJTTqQhaU7HhvybspK0VLThU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I+esN+vkYg86UVh4SlrQp8eMN9fEw3Q9fDfN41niDHEhWNVhEz6APWMKWBIPEc6lsYXBRhTooyvoreZwAK0gZSz+NioDU9aDoSblTPcGz/14uu9RiaRHGFxqiGocsMaxMyx3B4oaGByBjYEe50hxwIWFuSRYv+BxAN35Bgw5ljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YYFe78Sk; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d8a4bad409so1553564a91.0
        for <io-uring@vger.kernel.org>; Fri, 06 Sep 2024 06:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725630879; x=1726235679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqYsgnZduSGZisr5s+mTNUF2F6DJ5arsb6t0aHDlSwU=;
        b=YYFe78SkxEujY4PqzLLJfKnmIaiRmwRhpNwySzfM+CHuCz9kjlCcG++OgqZs3fYbhz
         MuI9eCWnJYHpZYUHXnq44e7jFSue9PZxEVaqwMeZwlDro+eY5HcT4y6SFG2Em2N+9jNd
         sLC6RqTq+WZlwMS5dcon+KeLb6DrAcSZrF3C2vdMeG/MLzwyVdd0TJt8wJvYUS/EPJTt
         RD6qVXd9n5fx7f7ZTPXcNh74ScZo6DYK+rOesftYwkf2A5rmptPMkfNfvXQW1qYnlP0G
         57AuaC6QkgTF7Os79DqrWxLXgESAJXrZoNODZFuigsbIlf3+NuhiGHQcJgoM+D4LEjIP
         be4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630879; x=1726235679;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PqYsgnZduSGZisr5s+mTNUF2F6DJ5arsb6t0aHDlSwU=;
        b=RYlgKXn9RxG7u52ZW/aMPAOtqInqrhrnE2fYDrLoyxP9/F+Aq1VPJOw1DJYpvDTfTL
         JWxy4kyZZHtErr9AhvNla3gST7a+MciTcxsLEBqD/aBToYoo/kcbiRYCO4rZbx+Ar3iZ
         1QNzmOxaIDtd0jpHMIsrZB/PKGwAbnisQ+S+1McPCgUaIYPtF3ufFyyzc1GHeYfSCCu6
         +zTqX/lqmCq92nhIhOmMr6dR4YguxQaaion8DD8t1exgGqw6vn2FFb2sCcM1bviNsRai
         REAGOeGhn9FKCmX6TlFsCMsXLjX1/UAbm9DvWkzgC6xsvT3PRyN5QxYLieS3IWo49j4W
         /QlA==
X-Forwarded-Encrypted: i=1; AJvYcCULvYVdfp0OFc8LYN80BtuaqDfMLMW29OFciFqEAvrNyFz2V9L74GfQPZuo8soVAYM6YFN/DBlpcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxerKFXf3VTEFmohzcC804FS0mFTV/qFot1TeLNNaUIVf660vnP
	F9zp6NP3jVrufcnjrphpFXGa+o9yBO62+ByWfwJjQr/pDRXgY/IClLkn0zIznfA=
X-Google-Smtp-Source: AGHT+IEz3x1d08wxVHCd6TlcJdggI5Bp33DTbD+8QG/YjoVqsrYJ6hQirWBBgpD+XKiiMM8NyQhzVw==
X-Received: by 2002:a17:90a:8c0e:b0:2d8:8d62:a0b with SMTP id 98e67ed59e1d1-2dad5131fa3mr3245141a91.23.1725630879052;
        Fri, 06 Sep 2024 06:54:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadbfe47a6sm1595151a91.4.2024.09.06.06.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 06:54:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
 cgroups@vger.kernel.org, dqminh@cloudflare.com, longman@redhat.com, 
 adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com, 
 stable@vger.kernel.org
In-Reply-To: <20240906134433.433083-1-felix.moessbauer@siemens.com>
References: <20240906134433.433083-1-felix.moessbauer@siemens.com>
Subject: Re: [PATCH 1/1] io_uring/sqpoll: inherit cpumask of creating
 process
Message-Id: <172563087777.168448.6960752734044926743.b4-ty@kernel.dk>
Date: Fri, 06 Sep 2024 07:54:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 06 Sep 2024 15:44:33 +0200, Felix Moessbauer wrote:
> The submit queue polling threads are "kernel" threads that are started
> from the userland. In case the userland task is part of a cgroup with
> the cpuset controller enabled, the poller should also stay within that
> cpuset. This also holds, as the poller belongs to the same cgroup as
> the task that started it.
> 
> With the current implementation, a process can "break out" of the
> defined cpuset by creating sq pollers consuming CPU time on other CPUs,
> which is especially problematic for realtime applications.
> 
> [...]

Applied, thanks!

[1/1] io_uring/sqpoll: inherit cpumask of creating process
      commit: d369fdf0908a8a026a8a4b8729d2a193b75fd2d6

Best regards,
-- 
Jens Axboe





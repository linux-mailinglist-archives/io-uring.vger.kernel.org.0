Return-Path: <io-uring+bounces-4921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 793BE9D4E80
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2541E1F24A93
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDE51D90BC;
	Thu, 21 Nov 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NN2PKEOY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878961CD1EE
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198604; cv=none; b=XIghgRCzpVSAhQ9oFiwkuRZ8D6x6TbKhrVyTOj3A/x03cX9EHk3BZ1P0AfuiP8fPnxl+cNXXlsKJ/h/cPNgMueHCsDhW/vWFtn6HCriVgx3rrZrqF0htYRfSeJJhNsDAAdCEyXOT3EsbZz74gmguOZBoPrhgyhaauRQPB7j9qFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198604; c=relaxed/simple;
	bh=22ofPIMO61nXKNyez7NEm4UXsTVoK/VCaKa6Omr+pFk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rLKdkCPYHHilId5UL6vmgjrcotMSycTpg6d4hbwQ8uKc0D5OYVviG+7GYJQHcu25coQhXvqX4pNY8lVcHbwRBoZQGLb2jLCZOqoYb8ub1ZsRqb0k9PoyrmM4aQO+ytb5287sH3hs6W+eiwCH/KhJTk8NS3CGyHca8ct1tn7xOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NN2PKEOY; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-71815313303so502670a34.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732198600; x=1732803400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbEq3/SaEKatbqa3znpVp3arQmdYQgAUgmDOwzH+9mw=;
        b=NN2PKEOY2gRHGdzgEs1nQzHM0ztC86ebZ7pUB57O4ndZdlY4f2mlBkDR1FNf/HUCfo
         fqDSO++OCQnBALNWlV4fET1n6FoADIcqAf1sXVz6Ixdjb+qrdtuAzQ1NkTMlXOpXdIeE
         KsKFXIDDOcUgA2KaZztummrTDbt0Kj5VaLGsRVqdGfSnse6bUzRia4JM6KYGJLBYNelC
         FOzpzdm1/zxmY3/KY75Ya5q/Q3Dsb6gj1e0UugYqsRrNpaueoHbPyKS4SpM1Zv650vaq
         i+M3Wk2zRMn2D4IetfGgW4RD+4GptNf6UQE8qlwcB+uaHsMffmrXJQoGZgm1usPQBgV+
         GZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732198600; x=1732803400;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RbEq3/SaEKatbqa3znpVp3arQmdYQgAUgmDOwzH+9mw=;
        b=rNFGgYdLPFW0azky3BXmlCNwY0pH3eFI6xPbxmGf3WxtWeoSgTpdwBbAxUGHhPyGur
         t5OrRLPUcQTLqmzjTMVt7Z2l6lLpjkYN8gMvbVWqnTVGxqh7gWYvPRoZWhEEzSkzDvZD
         xZCVr+zsbBM59Sn9qiodGr15LawVNgPRc2kAN2txbKC9uJxZ0wlEI0uYzdn63AjLyPuL
         ZTWneD4eUF/wWEvu6aXuoaI5eKz1AXLLE0xkuzwzkOQTrS85gbgJYwGQ4Zxm0zKWLEsO
         +6sZGW0u4/w5S8sadyV4bQNjLXu0c4pSdPRF6aO1ddhQzcAnVPKGmlsAHGEZtU1hJtR+
         NzXQ==
X-Gm-Message-State: AOJu0Yx9j24Ifijgn1Be/IcAkpIZTYJr0cbr+e5PsqFSPmKsKVWezpBR
	X9sZ2PJtEQ15K1x4B3WdhxvFpU0KZbLrNMej6hmjAxrCAZ0u/4A5eTNZdAEOXDI=
X-Gm-Gg: ASbGncunnD6FJrsmjT3cVQOO2gb6KJn9mxjfghvNkb9tMZrCD+YoWKBTVz71OFzgwEW
	nR6INIhQo5M/S2+jnXDSZGROv3XvRj3UPsoxXoX1ZQjYVKDIf0yIRAO5z7K+SlQiTiECed7k/Et
	+OXMb8ihGaJQcp28Gb9BVjoRcjSrI+UmKOa3IXG2ituT5eY3rLBJ3iJcqHmADfUPDlCqMmMqJVq
	jawKkSOLIJkNuMfth1Geq1w7u1qNE6hjqDW99e9
X-Google-Smtp-Source: AGHT+IHE/aHoYnpBdUjxFY+DYepblLfCoHMwlbuiRgF66zALddKfGjo4c6Gs/eXZ0W8RP08muNJouw==
X-Received: by 2002:a9d:7d86:0:b0:710:dab2:684 with SMTP id 46e09a7af769-71ab31c4202mr6580437a34.25.1732198589022;
        Thu, 21 Nov 2024 06:16:29 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a780feccasm4507115a34.28.2024.11.21.06.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 06:16:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241120221452.3762588-1-dw@davidwei.uk>
References: <20241120221452.3762588-1-dw@davidwei.uk>
Subject: Re: [PATCH next v1 0/2] limit local tw done
Message-Id: <173219858825.218425.4062596623404932485.b4-ty@kernel.dk>
Date: Thu, 21 Nov 2024 07:16:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Wed, 20 Nov 2024 14:14:50 -0800, David Wei wrote:
> Currently when running local tw it will eagerly try and complete all
> available work. When there is a burst of work coming in, the list of
> work in work_llist may be much larger than the requested batch count
> wait_nr. Doing all of the work eagerly may cause latency issues for some
> applications that do not want to spend so much time in the kernel.
> 
> Limit the amount of local tw done to the max of 20 (a heuristic) or
> wait_nr. This then does not require any userspace changes.
> 
> [...]

Applied, thanks!

[1/2] io_uring: add io_local_work_pending()
      commit: 40cfe553240b32333b42652370ef5232e6ac59e1
[2/2] io_uring: limit local tw done
      commit: f46b9cdb22f7a167c36b6bcddaef7e8aee2598fa

Best regards,
-- 
Jens Axboe





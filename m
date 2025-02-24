Return-Path: <io-uring+bounces-6677-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6E5A4253F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60AD119C5247
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8518727701;
	Mon, 24 Feb 2025 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PwX9g2LU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4E31A239D
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408829; cv=none; b=aQ02EB2Yh+Slfa5FxOfmb2i39APwBIKeC3EEIGIn3cZPFgOXy7sZvO61YwblorZOlm0V1BflJKodHWEPvUD/YpyEE4/PToYiIWRmf9eBO6PqXAZt9IyDyw4Emcl/NIR1gyD91ILLd0kphA0P98mMAAoGusQ+4UcVjhZN4wbcApc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408829; c=relaxed/simple;
	bh=Pw0qsbOnKSl80U69Wblfs//Jl/N/8AJIHqq1IVcZfrE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Qvme+txUzfGIO8+Hw8QIYzunjHUbDsmIIlZN/nYpApIyOco09w4fj+t0qS85mgcjH7+Kk1bwGZUH8Pdt6F12lx2ge43MWVUnuIfa5sFtYCgXVxj24wbqppUVox0mvN9Np9f5mvpf0CpV45CaCS2Rlh81SmxBlGIbQjI7gw6BGpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PwX9g2LU; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d2b3811513so14895245ab.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 06:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740408824; x=1741013624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lTpmeoWGDnV/vXbc5x4QUFHecpQJ/7DhOpcDHgnzB0=;
        b=PwX9g2LUHSfrI7ZVFInBseGU55Dh9XHDkQEybg7QS6ZMRUh3ACU/KsXTti6LrUQdF6
         eb58ab5mfFwB7c0bpyEjyDkQkfFLl3jYyElwcEhPGtXxaWEHp9X+QRBob6ynGbNtciPs
         VL/ZPY1eHRqz+U4FB7ynoR+rdekNV3yG4Is4ZkswFLr4K3O2yimbgOYFgnh4tNUAZBps
         5paMeYHx7OiSt6uwWvaxNMenkkP0Ajy/PzsmappHlboo/4oYgGzyBiDykPvUGRN/DpVa
         yL2JQ+1SLecvqo04Sj6gShSqeC7A4bhve4SGyRL7GMQQkWg640uuGpY7TLYXs1Bkkscl
         65CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740408824; x=1741013624;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/lTpmeoWGDnV/vXbc5x4QUFHecpQJ/7DhOpcDHgnzB0=;
        b=nlFKxTBqF+pFq7gTFDfwHbhlt/0DGjp+f00xZ8wgjsN3Lf73mydLH3y9Dj7QRp3gYx
         y8sMbuwWqH9BpefRjws+qfj4gkPv5dCibs3Qhk3cDbuV9HuuOm/evB5q7ndLhh5UZx6b
         DX5Gs4VJdpXs2CNU4jGbZgP6o9K617SnWKLgTdFkZiXHQiqS5RN53fxhSDGdRUcUYfib
         l7KehfW/hCOu+9rqkc77R6WbxAaUC541J5yHetTIZ1wW4d158Clj336bWrtqikldRD1c
         uq11dVMA6Sb1LxOM6JY15cppwM53YvLcHaF1aZ0egvi05mFw3myFwrKeGSe7ayhr16R/
         d9Eg==
X-Gm-Message-State: AOJu0YyyMoBraqGhXnYBiCuaL5eT4YCwfS03cTcKyWJ7JtHw5MvEkAxO
	IE44EDkxfC4grb8h0wDccRszqqVX54w+tYcSJhAxmwzfy77BosBZeH83r5WWaQkFBzRJVWpN+f5
	H
X-Gm-Gg: ASbGncsVWc4cBPrE7vJmXSdOenQoWKbkjq+Ql01/4z1YaMwb6HePg38scOzxQMrnMyB
	ocl2QHb4VNEvE1cbHs8ImsLKEw915mi9mUI9U2Fjb82x6P5ys1YetGvm/YMWo+IOgbDfe2NjokW
	+BJw6PXvjMF6qxcOMkD3bZjS6eH8w0AK37nr6UzPY1+2ZKGDVBFQ2NmoDFgJ1ifcmdjWIN6OpT5
	4WBGeeJL3Bf4BW9QlgFhbVvY5IizkZ1r6iqhgvls1JxAp2noonn+Z2p2n2f2hL5aLtn9kaGCwWP
	4ULLwEEv9k+MPYlPmQ==
X-Google-Smtp-Source: AGHT+IHL1euburSZsQsPH+ngg6mRa3EWGG36bOz0lGTwZ/42sLhYzSQbkOrjfMT86LLxQLdXg0Q7WA==
X-Received: by 2002:a05:6e02:791:b0:3d1:9bca:cf28 with SMTP id e9e14a558f8ab-3d2c0239750mr133044645ab.8.1740408824392;
        Mon, 24 Feb 2025 06:53:44 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eebd9d6b6dsm2697733173.79.2025.02.24.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 06:53:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1740331076.git.asml.silence@gmail.com>
References: <cover.1740331076.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] multishot improvements
Message-Id: <174040882381.1979134.2076646474553775513.b4-ty@kernel.dk>
Date: Mon, 24 Feb 2025 07:53:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Sun, 23 Feb 2025 17:22:28 +0000, Pavel Begunkov wrote:
> Fix accept with the first patch, and make multishot handling a bit
> more saner. As mentioned, changes in Patch 3 will be used later to
> further cleaning it up.
> 
> Pavel Begunkov (3):
>   io_uring/net: fix accept multishot handling
>   io_uring/net: canonise accept mshot handling
>   io_uring: make io_poll_issue() sturdier
> 
> [...]

Applied, thanks!

[1/3] io_uring/net: fix accept multishot handling
      commit: 6a1ac63e91a70c9c35f2fb7ab4f0b74acb8a903c
[2/3] io_uring/net: canonise accept mshot handling
      commit: f474b328b527616d72419a23029fb8bd7e2bea52
[3/3] io_uring: make io_poll_issue() sturdier
      commit: 0243b56ffd3c69b030b90e046ebc38d5e54249e2

Best regards,
-- 
Jens Axboe





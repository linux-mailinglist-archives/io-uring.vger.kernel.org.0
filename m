Return-Path: <io-uring+bounces-6368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA156A32E4C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:17:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 735F23A98C6
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD02426136A;
	Wed, 12 Feb 2025 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P+Hc0nN5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33729260A3E
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384209; cv=none; b=bf0HIqb7UlrrmNwjZv4uocMhzgQfkFkNpORJ+lB2VUzsKpupCF/xNoOYmqGQ10dWOzs1bpS+xIVYt/XNNlloeWG5sWq5oyJWpz4jmPcpySmr43CZ8nVhvJqFPvQiGbfWAWgarxOjzcuCs+D8gqSLwlEtVJm1gXthW40/lHEq2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384209; c=relaxed/simple;
	bh=1hb4KJ12VZdUmipnIFFuvIni0qBelor7VkXCwkCQbek=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FRrvcJg4z/7O80xG9DGP3NYptCc+wuIgPpeHs6dcV/gO7ziqshP07qGvfdMt2Jup2mNuy1PokzAksky848Zoel+hCzu2igO+jtu/hgkFPCDmrdZ6BLbXQ23vnkP1aMvOlU1OpOzajRCUmgtPphI9kX5e/KJCTex5TsNrzfd1Qlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P+Hc0nN5; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-851c4ee2a37so544585039f.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739384206; x=1739989006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMlWPAv3J6OkYtRrXxRVeoZm3nrZH04zwlYBVDf5xD0=;
        b=P+Hc0nN5LSGeQ9iXQNxxtdV5ZYV5qg317Mk4V0LzyAsGoI4wB7woEC9eNDmSLMmWBE
         gANGBY7RuzXF0vYqCWWj68ug5h2lGFqKt+SZWztxs9E6CJvM5HrUf1Kye7cRjW/cztvF
         W/mMtB99Gb4W3oWvs/QGOQKaKS0HQfr24pXYntBbLJyjv1ackLgrmeHebgJIeFXP0ORl
         tqAFZ1UiA3I0HF+GYewsGkB18qYgMH54YvwnJOALMDJ90Yor+kS2KzSwJc7zUXr/kN4B
         Rnt4EkrRucSJmlBgnEPX+K+IWavQLbcocIs3TQzrgAcOwVK3CNJg8HHpN+iHdXhYA1gI
         Sqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739384206; x=1739989006;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lMlWPAv3J6OkYtRrXxRVeoZm3nrZH04zwlYBVDf5xD0=;
        b=wVTFg/NxBt2ly45NB4QSmAeURh9sNlqE5l+BtSYBbIbfNB6wnZFDURuzs1qq9lN8EN
         srVWKCpVYDDn1Vx3TPuFA2UCKwGrPU2gUy5f3jrsR7GgNka9Ev5EC+DsXpK52fNkQA3c
         b3pyPVLS+2A0KKQ//OBBMGRjMV7+bxBoa2ou8T0QAFzd4uQNJsB4GkwTiTF1QyO21dvC
         xgTIR9HqtzobhkVWiXDfMUTbETn63RrsRRwLjETMdprhpVFBtH8DsImD4Z4t9HCvhS05
         aGkj3GnGC5XTBAe3OCr0vqrpQzQqWvWPveP2vvbdmSLUo034ZPFMmJcTeE+Aqlsq6KxT
         8siQ==
X-Gm-Message-State: AOJu0YwELun2c0mSJltwljHgqYpoFdMeyTfW2UBuwefqvAkdPNHhFwm4
	8O2x0O4qCBVg+/JaSsr1coc7aw3Nt7Lp4v1cN4+SZrvZU1zNM9+6x4q+gk/PywtNe18REXm75QC
	r
X-Gm-Gg: ASbGnctzeUJEJitq+tIRkqF9RFCW+SGyf4TmJZwQV8KMCw+W9nRhaveXMtx+kTcxT1N
	pwv9FODKjTnOxDpTCwnl6LLKFkNux/f1VLKc3JAZw2kmW//zAw8NJGnqpkcS9Z6hNbBnXDSS55n
	umuhB5McuPOxP+Q6KFqSYt/CM2pZcUYRPZFHiL8RdveaYe169ibwqeHsl5UlDXs9j74kHzP7r+a
	L3v+tQbOVTpg4WH0Ye77q7jy5lgFtySEef7OfiHABfxTklyeVIKD7jsc8msjCHfVEedTgBR9nz9
	OURzow==
X-Google-Smtp-Source: AGHT+IGVQe/1y0mKHjL8agjFLUdHgyInbDpN8Z+e22BfS+Za7kvSCaPWEA3qCdt+ZnC/iPpa1INLdg==
X-Received: by 2002:a05:6602:6081:b0:855:1c54:d0e1 with SMTP id ca18e2360f4ac-85555cbf2e8mr453678739f.6.1739384205963;
        Wed, 12 Feb 2025 10:16:45 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854f666ba26sm328049439f.14.2025.02.12.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:16:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250212164807.3681036-1-csander@purestorage.com>
References: <20250212164807.3681036-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: pass ctx instead of req to
 io_init_req_drain()
Message-Id: <173938420478.36938.14753182485522583191.b4-ty@kernel.dk>
Date: Wed, 12 Feb 2025 11:16:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 12 Feb 2025 09:48:05 -0700, Caleb Sander Mateos wrote:
> io_init_req_drain() takes a struct io_kiocb *req argument but only uses
> it to get struct io_ring_ctx *ctx. The caller already knows the ctx, so
> pass it instead.
> 
> Drop "req" from the function name since it operates on the ctx rather
> than a specific req.
> 
> [...]

Applied, thanks!

[1/1] io_uring: pass ctx instead of req to io_init_req_drain()
      commit: 5fa0beffc75910a694a90ed0425bb13674b10256

Best regards,
-- 
Jens Axboe





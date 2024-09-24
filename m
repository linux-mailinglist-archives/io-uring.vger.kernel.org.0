Return-Path: <io-uring+bounces-3274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1BB983C17
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 06:33:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89FB31C21E79
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 04:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E8920328;
	Tue, 24 Sep 2024 04:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TEFt3jpU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FA61805A
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727152427; cv=none; b=upqZb2G+yFMAVaAu9kW/VKbKrVKg5OdfROqbDRE08Hxprp7KvGugyWhNfTU8ZAJIJ/+AVe5c7R/Ay/+oPXQPPGPN91KLpPPzc9OyOU65+YcQa8/y/97OwbEpOQszQ4h0Vc+dxRnz5Y9iRINHr2GjQGDCsFh2MjxK66wRn+hjqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727152427; c=relaxed/simple;
	bh=xBJvL1jV1L8ehCD/cDNZuAzqsm3KHQpG0EkJi8ZsmxI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aF6Nyf+UyVqpmkVZRxdmxR8TYyY1V53UjxUPrLgxRKDVRRyqeSj/2fZhw+G/KJLDXhlEqryJn2ue+55tkKS9CCvhxLT15HweG+r8cFAYyTzNgoh8rk+/7U8evR/dT39o6qtpHBUjZrKtNJux0AjNCh/QRM0bcWLBbay2s0Hl0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TEFt3jpU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42e7b7bef42so32276265e9.3
        for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 21:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727152421; x=1727757221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hf/Vp/SfwiC/0TiVr8LyphDoxrV5aU2JJLr9TNeH3g=;
        b=TEFt3jpUkERG92ZL2PFRwel9c2b59mliYnrxX7wU69QxKEVL/bIgEomAPV5DiJWR+6
         948qOMR7qam+8idtJYqvEzXbBZbOiabt+h051N9ryMpb2yWKBrlT5EksZ46VfQnROCGG
         Dngy0HtqnBFLeIBYZRBNVbBCc07EGTLMFZ1fENk5DwArYc/JReujxfr/cJZT50hex6Bj
         LQdkVc/4WsgwpZoN/Yx3uDm3JlufxaIqCTUwluW//Htk3/UFBEwb5AeDrCJdP6/hrRmD
         xXeL5qdmVNekeS9o7BwlcnW51umwOxvM0gIolQ/vqKMvLi1NOQKbs1mvA0gPgUgl42pk
         HsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727152421; x=1727757221;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hf/Vp/SfwiC/0TiVr8LyphDoxrV5aU2JJLr9TNeH3g=;
        b=mtYmzOdhaXUBrXiWJ1Rx9mz2IiQi5mmmF2aTR120yZ//GkJSKmAsCPsG8QYO9xKODg
         8d/MQEZSwyarnRiwwsKxTE3sHodRxR6LX3XBhiV23v5ITVjen75O/kGqCzI78BmPz2vN
         tV/NZaIXNtIJWttKIBL2B1KYxVvy+kX+Z5nCrHSOjkseK1mLWy7PbtdKW6gQW6+rtPtU
         SNyMuTxUI9DPF5NyQTjsMvQ6AbNPYn3DijsX32nVgMtbKBQXs8uq1KlWcIjkhMeKtGLa
         vhihbmQGQDi8gk33NEuGPBDzHuN71iZnDJkkHkDn16Fscvq9IqsK8Pe0qs3DrLbqBkHY
         MW0g==
X-Gm-Message-State: AOJu0YyNg2jgfIkAhimWB4Zn6IMpSm+Ocr42TBsHtZdM5+7S+tcqdSZB
	UGu8yw3ODg+28jNLCJZudUfhz13pwxJyp+HgFmq+EI4l1CvNzfg2gqYCt2hmYiQ=
X-Google-Smtp-Source: AGHT+IESPk0zoBSPZ5okrQz9qS7P1BYTLy0mSSQWu4Er7zywwKztwRuTs7pZGQ6pMwQdclfJEmXc1A==
X-Received: by 2002:a5d:58ee:0:b0:378:c2f3:df01 with SMTP id ffacd0b85a97d-37a431558f9mr8029979f8f.29.1727152420466;
        Mon, 23 Sep 2024 21:33:40 -0700 (PDT)
Received: from [127.0.0.1] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2d2588sm514131f8f.63.2024.09.23.21.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 21:33:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Guixin Liu <kanie@linux.alibaba.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240923100512.64638-1-kanie@linux.alibaba.com>
References: <20240923100512.64638-1-kanie@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: fix memory leak when cache init fail
Message-Id: <172715241799.15171.10855838978862285530.b4-ty@kernel.dk>
Date: Mon, 23 Sep 2024 22:33:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Mon, 23 Sep 2024 18:05:12 +0800, Guixin Liu wrote:
> We should exit the percpu ref when cache init fail to free the
> data memory with in struct percpu_ref.
> 
> 

Applied, thanks!

[1/1] io_uring: fix memory leak when cache init fail
      commit: 638e6c7dc0d957018e466e6247fea2932c6cfb85

Best regards,
-- 
Jens Axboe





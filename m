Return-Path: <io-uring+bounces-10019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBDFBDEE87
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 16:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AD95A502160
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 14:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1BC1DF748;
	Wed, 15 Oct 2025 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3SdXAG52"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6676026
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760536952; cv=none; b=eJeq2HozvcdtQoCyxjLOYSwSwY+Iu+B8fvvEumfDLZ2lXUeFb2ct2a1gsDawVL3ZOD99wkb34oixW2kBHQ2A++2xKinDd3WXdg04moeYXqVrHvqjMwbmGDbfDA4t2Yy4LdvmJkz5hzf045vc20MpQHRfc6XVP5C+pHt2aM/bMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760536952; c=relaxed/simple;
	bh=7A2Huo4cECUmjmZGP26M2kOMHXpj8PGejHYB3rK2ufk=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WamM8zRruuH3r76cr0m/FpyzCxQkeg1ea4uo1e2aJfR2yE4pwLEVNQsF/YZRG63vJkER0dxnLIyAO4SO462dfy3jVdesYHKIcrFiBgSX3NBuYFBCzAqvWqls8TU92doy/62EEhoWKzq33evMOW/X6LGCc5biniKfLr1wXGlCfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3SdXAG52; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430b45ba0e4so4395ab.1
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 07:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760536949; x=1761141749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ku59DU7PADqYGdSkF0Fj+zvTY2WuFhIGLFOswj4e7gY=;
        b=3SdXAG52iq/JOus6nv02+FPkZGSFRCo3ubrpZpk0T/EcOlLF+b2pWW/DrTOdl3+qRr
         d9iM1fgMPTOSq8i8qA09NiANsvR34Y828yWTog9yn+cgreA+1z9boqp/BLxDUa8NzA9a
         +OU49EEGKy9YqvrxG20hZf21Mr+9QYN6IDNBhIo7epelq65QGSb9XV1ZN0mw16ncIi+M
         41w1hmk2rPJbd/6wqzdYZGFqa4G75QftG+I93ZT6GSjNb8N2c1pqSek1nqp9TyS/sz9O
         xUMmp78F7rZ/Dijp+knsBwajyncPaaUVA5oGAq0OgOqLvSHWEnwmYH4iWo+fYO4KzR5q
         9v/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760536949; x=1761141749;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ku59DU7PADqYGdSkF0Fj+zvTY2WuFhIGLFOswj4e7gY=;
        b=FVRznJVZH+5Y09tqrgEmKM9qSo9W0CWKyy9URvrvCX4HaqiVA9Ch+uLJwXptEgGWnt
         RFKrpFrRaCnjH++5aS9ZTP1tVU/xdTo15eeJEjTC+EoO1rk36gnH9ox/a9Ufh+S+U3Xr
         hN+nlq3n5oVoEPhxIuMzBySZjK2TQfJKhxeI3fjr79tgdeL6dSR/Kc5Nm0XPdNNHwA2g
         cro3qK9T0cxr3/RbHOB/nNJvuw0cWRpRpJX6QquAwdUCJ9ZC1rbkfIy0gqPIBFJdBGAZ
         Huky0HW2R02E2NnKN78AWGsLw6EKKRKkN6KtpcICrtKEhSEuM4OFW9e1UG9cvVpp6tWS
         ZkWw==
X-Gm-Message-State: AOJu0Yze5jyVIda9sUhzb7NK8ATjSmGQpseGgwDfxhYPQWMSxnQNMwli
	Rb1B73lN99neELuAQYqaEM36ev1Knn8YyssYdMlxt0MRhcWmZCrcKV1LrJ2PrKbu7vmZIY6Yqfi
	j0OxcgAY=
X-Gm-Gg: ASbGncvJrYBqPJhqvP+OidQ+11b6SVJoRbDzzPSzlm8MC7Kqv0Bfi0nsLwG1s9AwENK
	n+ZCmgSRqOhvHhEXhtVdxEbQTbQV1wcWwbzt/THx0KnUo4bnxgQdPeCxXatwTL+d25+IsRIFz/j
	3eqiBRtFBbmmJyOfXsY6MrteWvqZAISsvgDZ5008XhfEeEEIP3DT3j1bcuBTRwAoZ/XFz4wtCSI
	ydidr4qj3ZqYcE1sMNURrz1sabcNufyItRaHVYbMBBiPte1I6C6o42iKSwvQAJ6KIrUxinF8Sw3
	1Et84eTTGmZ01M1JLjDUimfaASKytL7OO3qB5LGz/GnZz1Fpuv6ho0HqwP6W4jeppXxRhF9Gcwm
	vuIPIEY8GhsV6ONGLc3zXrKJ7KiuEAf0l
X-Google-Smtp-Source: AGHT+IHxVv9Or2Hs5zQpAEaCJujOT9OnrWqfC5OBwWW8DkC5Vn2TdWbIig9/miRTTI1BWShujbi58Q==
X-Received: by 2002:a92:cdad:0:b0:430:a6e4:d75a with SMTP id e9e14a558f8ab-430a6e4d7abmr63636175ab.0.1760536949109;
        Wed, 15 Oct 2025 07:02:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f90386a49sm71031005ab.35.2025.10.15.07.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 07:02:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8842bdc39d78941e83e14e27d8177d9f0a451695.1760530000.git.asml.silence@gmail.com>
References: <8842bdc39d78941e83e14e27d8177d9f0a451695.1760530000.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: protect mem region deregistration
Message-Id: <176053692788.32600.2139324228239839708.b4-ty@kernel.dk>
Date: Wed, 15 Oct 2025 08:02:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 15 Oct 2025 13:07:23 +0100, Pavel Begunkov wrote:
> io_create_region_mmap_safe() protects publishing of a region against
> concurrent mmap calls, however we should also protect against it when
> removing a region. There is a gap io_register_mem_region() where it
> safely publishes a region, but then copy_to_user goes wrong and it
> unsafely frees the region.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: protect mem region deregistration
      commit: be7cab44ed099566c605a8dac686c3254db01b35

Best regards,
-- 
Jens Axboe





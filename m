Return-Path: <io-uring+bounces-4755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 801729CFFF9
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 18:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46EB4283895
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 17:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28B2156C6A;
	Sat, 16 Nov 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JfWj2ZmO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4B818660F
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731776869; cv=none; b=f07bQBOQCEIqQlS+NUXV/9jdaHUx2s7RqHGsNVovRhpI1n0Z4CBgJ0YFSj9Po2yiK7UK86ZIwHN0GAEfKX2EGINQva5t1VfyIaJg0AvtWDBhoZigV3L7uOSSye3Kr9xWQ85G+gipLLdZnX4jG0AdknHD4OxMhpp+4upknK6Ht0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731776869; c=relaxed/simple;
	bh=qgbl5/ZAtyGw3MoKoK58tR0mJb6gsWgMVgCpqVM3v5g=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jponIaLrH47gTBuFrNdr1qOVO/Lw3JoRjx8a7Eoo/BO5pHJVkB0uUpfEJ3IdzIKe5QjHNTzWwTmkfwdHlgURIhrlzFEnnkRnf+L/XI+vG5F0pbcCxK8+9XpryRisIo7ulaWIY9i0+PzCQecqmuFEUIvwho+WImkOv6Yj3wDe0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JfWj2ZmO; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cdda5cfb6so16204435ad.3
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731776865; x=1732381665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KYUfIdQqI77MoDxLqz2bYBLMFoYP9KJMfJfPCAjIeag=;
        b=JfWj2ZmOQgePtVJ1Mzo6xBomzcG599PGXWcKc1eFQhhYy6NhQmj51Ex1a7P+QkE4op
         9u5wIuyRQUYAuGHTN2V+kWgMlXtlxjTArP6WkfGWHexbimKDA4pBkzhvu9JhtK6abakk
         KY1OIBM+TMaH7kV03/hVXJxVroD0HwJ9Rmlnz9K79V8kSntCPNWQneXOggXQL/6cOIyl
         1V5m5ZRwGhG8rpasz/p93LIatB5H1LeA5QqVgCxLOqjYrnw2CFVhYDkRpGRwN+XZfrGp
         LzbiE1WYqj0tso6mV5ScB5KJUn3ht5QiVjyyPRH5zWlhnexxspXV6gkr5z5WAQBTLSSs
         9QsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731776865; x=1732381665;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYUfIdQqI77MoDxLqz2bYBLMFoYP9KJMfJfPCAjIeag=;
        b=gO/AWNtPlTKxv9LrKQIGh1OSHqZPftnnxsOB3htUfMBxPXQgRD4abGnM0pjv5OeBEi
         uYs1vayKriqp7SPj9vJp2u2coLuxgwDokNALVp2LY3wek61f5yECRj8UUX0e6pz2sYqV
         I/1KkljQRH2Z3DoVH0m/BQDuDbymlBKIhoiGVLzH3iZePL8YMh3NUFl7qH1okOLIfW56
         L2RUnDj6aUWsgfBjcAscPgUO1b0vvMHmhuaMtZVDmWuSQx/t8K+zFNyc32xw0nbKVIZN
         tP51oL9wyunZF47H5ychFCPrci0haRDsS62tJzODtNT1+hf1A8XnMe2jrvs/yYuJQSl8
         Mf4w==
X-Gm-Message-State: AOJu0YzuXJxkzB1SYlrHxAsTDGIGR5hE7hseQYE7G5lz1QMjGk6VYAug
	8pltQ7OKvdgAFoiDl6QpouggjpMqA1FBd8Yo1Oo3PjSojqN165j0b5rQPixu1u/n+6FevM/aKVB
	CBNM=
X-Google-Smtp-Source: AGHT+IEymG6Axfksf+sCpnVJIhSY01nMmiaxuti5vSi1OeQ850MeifgiGK2llWv2Wdy2KKTjXpe11w==
X-Received: by 2002:a17:903:2d1:b0:20b:9547:9b36 with SMTP id d9443c01a7336-211d0ec8f17mr98462085ad.46.1731776865567;
        Sat, 16 Nov 2024 09:07:45 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0eca49asm29633525ad.108.2024.11.16.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 09:07:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/8] update reg-wait to use region API
Message-Id: <173177686460.2579123.6342106723099182212.b4-ty@kernel.dk>
Date: Sat, 16 Nov 2024 10:07:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 15 Nov 2024 21:33:47 +0000, Pavel Begunkov wrote:
> Reflect changes of the kernel API for registered waits and fix up
> tests. The only thing that changed for the user is how we register
> the area, which is now more generic and called areas. It should
> also be done now while the ring is in the disabled state,
> see IORING_SETUP_R_DISABLED.
> 
> In the future we might want to improve the liburing API for
> regions, i.e. adding a structure and a bunch of functions
> setting up the region in different modes.
> 
> [...]

Applied, thanks!

[1/8] queue: break reg wait setup
      commit: b38747291d5034ef8392d1b76ebe748c9ba32847
[2/8] Update io_uring.h
      commit: 4843183eeadaf6ac53ccf6121950d4a254636cae
[3/8] queue: add region helpers and fix up wait reg kernel api
      commit: e37a3bdebb8814888eeec67c7721b8f365d08ec7
[4/8] examples: convert reg-wait to new api
      commit: 12c18dabafeb89dd95250b19f3d044c116f57938
[5/8] tests: convert reg-wait to regions
      commit: 00b42a502f23747f353d3a3f47baf34259d1d1b0
[6/8] tests: add region testing
      commit: be7bc8538b748f5f43b1c8f43a84970034ca98c9
[7/8] tests: test arbitrary offset reg waits
      commit: 65d67c0f0f046da401bcd605029545e1f15070a0
[8/8] Remove leftovers of old reg-wait registration api
      commit: 425cfec1027af251b3128dd0f8be51f2095b8c0b

Best regards,
-- 
Jens Axboe





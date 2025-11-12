Return-Path: <io-uring+bounces-10544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CF4C53530
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 17:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ACEFE507439
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 15:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A82833D6FB;
	Wed, 12 Nov 2025 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0pXpeRpE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02FC208994
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762961168; cv=none; b=Lt0JnSUYd0qLyCqBbR4u8M0Wp8P67/qv58kjbwUOV17+h06y/V5ysfANkIJ4WpkDf1LsuQbGyELnJqWyOGvkS1xmQ7wZIp1dGMxto43uUSIdG75RaH+slj5NwPS7i6GqjYAAfy9jEyWbeFhA6iiJwoMCv0OH800AN319KnMDoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762961168; c=relaxed/simple;
	bh=S3HgcwMVfZzHMTxf+gvcGSq00lyXdOZbvgaMm4vD83o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OCf23KnemZO+FuNnRjrfUqCaiUp0yCAOrb2nJDWWVozsNEPzH9eNZsRO9oPfbPYRYe5we082mWhZST/F0eUoHNQ76tJYTCWgVECAJqtQIrBRT0RjpAijbaJIQzgACe+MIIQSKpiiJF/DPahR44l18w+1ndkrbubf6PJaxdUjzKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0pXpeRpE; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-948733e7810so35502739f.0
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 07:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762961164; x=1763565964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhfi1JuTKDb5v2cN/vHFWbcXiiQnvSefPdXao0zAnOY=;
        b=0pXpeRpELAJ2GDaxwqZ+8ZRABbERL+ScFGuWSu8hL2QOcCWw2Tegey+8OzpdLsf5OH
         NJwrVtJ07l024X4JsoV5L122Ic1XV+pwxuLmkhWcs+C9K24mBfrjvKTw7jusV5JXwK1S
         r25zQ2K3C/I5H3078KIc3B/Cz9VaP3bPthlc9ZkTo97bs66EARkVjTcxGcPAckqzNL6F
         kboH7yGvP0VhwqgliKJ3oQAsXFGl1z7R+tfuUP4kD0MYsPB4VmNcePM9EDB+7WoL21G8
         S5MJLAFzglwj1BbYCzQmFitltc+b9+beb1o7y0QEJn4Uq3d1z8Oh2EaN8ysQw81AkTt9
         1f6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762961164; x=1763565964;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uhfi1JuTKDb5v2cN/vHFWbcXiiQnvSefPdXao0zAnOY=;
        b=H1JtHedxQ4jgjhkYrR9b563V95lp/xTt1ZBuxcQp/x/uM5T1G4wxfvlqf1nEw5FRha
         9hLBwyQUMq2RxRtVwCwcbrTORIM/sRtKU2HRK61pEY4NGEDe6QtrnIFOeWVht26N2Yad
         wyIDCviRICjR/bt/5hgNQwUvB0FzLi4I8HLBP0J7eZNy4VxO9aEaTZvPClNSRZsAvXJy
         JMd4nwt5faEJh7aX7fo3P4+QcZEOmDWTqPwYJs8gRfkF8fpVSF8h16vlp5fWt9V5vgy+
         FUPw0TdMu4bUy1H8DObEgCwd7HyNJ+i+rccW918tM5/FZZuziJ4jv72SSsInJ5O7iJaB
         uYKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLhLYI/r5Raahd1LACQB6CqEEQW20KsCMp0z2G/26zjRV58t9L9l7OSeOcFUaZ/HvjupzAsdrGJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzDeEbvp+VnwQ7ajjptf3ArMsbd8cSh53+yUOMyLYbzFjraEIl
	AObtPR+1SwNCYtDGn/hykjeUV5XM/7Dug8PMmX/BUf6NgpM2xzlhfdJjVEm0avwTCZI=
X-Gm-Gg: ASbGncvlKCtkpYRLThqEA9jdhs9K/rZsE+W7RMQDJ2fb+rJ9vzSGN5TL7cnd1dXkgcF
	cMi0ZHl1xikTp6Az9j8pkdr8Ea1fkqZ4qAqIuYc4/8pVAkycRtKX6GDGldY6+JkkNCXgBvLywS8
	qkRvHUGNbVY11seD3ey723k7MqI/yX3xGZ/9XZ+nRL93+wcVkO4z/hrJBuFi0KqpkB+pM1iNivK
	LqO9W1vpvuNO6L871IlEpOsdbML2G5K89V1LeGKjy7jNxGqTONXKyEfn7gSOjtqgRufQas4ngOP
	ppuaTDSosBYpXzWSYw9xtqj7s9+ryCA1CaHt24LiJeMxND5uL37O7m0BGfdIFxidX0c8afsjX71
	g/yBgIqU/jKcoiSBYzAIit3vMQsvTBtEwkhl2Ay1qw16sdJGxKyTAzE1mrV3XfKa2pnuH
X-Google-Smtp-Source: AGHT+IGqo/ElyNGaDcWY1T7XkvUdBijvAO9psWKrSyA4l0qa2YEYORSe/5hiqsBqgoiwFhOiCOknzQ==
X-Received: by 2002:a05:6e02:3388:b0:433:7c86:74ec with SMTP id e9e14a558f8ab-43473dcf6a8mr41773375ab.23.1762961163853;
        Wed, 12 Nov 2025 07:26:03 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43473398d5dsm11421195ab.27.2025.11.12.07.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 07:26:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>, 
 Chaitanya Kulkarni <kch@nvidia.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20251111191530.1268875-1-csander@purestorage.com>
References: <20251111191530.1268875-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
Message-Id: <176296116216.24001.10740596505863921319.b4-ty@kernel.dk>
Date: Wed, 12 Nov 2025 08:26:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 11 Nov 2025 12:15:29 -0700, Caleb Sander Mateos wrote:
> io_buffer_register_bvec() currently uses blk_rq_nr_phys_segments() as
> the number of bvecs in the request. However, bvecs may be split into
> multiple segments depending on the queue limits. Thus, the number of
> segments may overestimate the number of bvecs. For ublk devices, the
> only current users of io_buffer_register_bvec(), virt_boundary_mask,
> seg_boundary_mask, max_segments, and max_segment_size can all be set
> arbitrarily by the ublk server process.
> Set imu->nr_bvecs based on the number of bvecs the rq_for_each_bvec()
> loop actually yields. However, continue using blk_rq_nr_phys_segments()
> as an upper bound on the number of bvecs when allocating imu to avoid
> needing to iterate the bvecs a second time.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs
      commit: 2d0e88f3fd1dcb37072d499c36162baf5b009d41

Best regards,
-- 
Jens Axboe





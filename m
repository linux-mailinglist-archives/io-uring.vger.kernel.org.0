Return-Path: <io-uring+bounces-1419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1D4789A859
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 04:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14841C21434
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A311317BB5;
	Sat,  6 Apr 2024 02:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oMrecyWh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FE12E78
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712369217; cv=none; b=Obib4MtNjW32AKz0554e768ml9MD6UjQGePGU51SmYirIGxvIEwOH19UVMZgfbMnYqnYmBQuq3hZ2lzxU9iAVfDEuNb2n4R4eZpP7L9S/yYgcCxubKQxQO5FiC1+tuBATTjL2wDuAxzD9sLEsl2CnGd72ONJvHMunAC3J2sb5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712369217; c=relaxed/simple;
	bh=CqcXItKIrCabLQCCUe+qN+fVM1cCQGSSclG5twqLMWo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mii18GC3S/0RC76wd+iAZIjpfndqLmyUkK8xLr8feAAhxP71/uIPmUtZpPGEMqMyY63EyuYASWF2g4hatBim7HGP3Shs0C5WoR5GDPVbyPjx2tWKd6LzQ8ZBGS0h6c2OG7Xk1U01WTnuUmPcFqTL6FtEywJaDVFVKwK4hyuCAUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oMrecyWh; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7d341f3dc33so41292739f.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 19:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712369214; x=1712974014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vd7N+5TXTc6sxvH7QW/2ZyGamLmkZRItDumA/9uAIU0=;
        b=oMrecyWhwufcIzfIgRxxg15JBdQb8hA1wPUgkfh+eqmjaccudmIgAEGFjanq9OSHUd
         YKNjIvADtsojJAMGQd/eNeherD7brMT6s/hxOboq4ZKXf4yseDpK/N9wdY8BxTZl4Vwt
         hpJ/3uszK/tV0cBpoi1DGT+UV7slHNLIZYcNvBr8dkxCZCb0EOxMmbrD4HRKmvKpDg24
         xZ3a4w/b4I2Yld0GOXN5OgDjFx0CpFBPBEbNkcrgO8W+HuA1QK6y5DywRumw5UXa2EFF
         71jH5Ef/JbUHKcdZGVC0SY+EwObdO59wj+svZus/T+j8fBsrMoRl49v8PU70iH6hjcEm
         VKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712369214; x=1712974014;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vd7N+5TXTc6sxvH7QW/2ZyGamLmkZRItDumA/9uAIU0=;
        b=QPzYAjM3817pLShTV7UzQBz5EGzKw2CFXuTG7v35iaRACl4Uccn6qKjfPewUP7XSfk
         DhFBG27szL76Sd+judG0g3YLZg1Vb8jX5XWQkqYNCpPQTzFD3pFTWNt40/RWfQ0Ze+Jm
         o3ezOiUqMoi5anEKDGTITQjpgCFDnBSsTMqqkLftrrdj07+RF3gsWP+TabBgrha2RfQ7
         5rFT4S6XuClIiDqXy+Yr0BX02UuNMfQw6tPValY1sHegw0UrSNIIxTqzE7/uyq5ej1j7
         ACel8iAsaq18MIbBZw/xrGwHmV69GMqDc58duTPTta5pRCMoiF6Egg75HwISFC/15vWH
         kF9g==
X-Gm-Message-State: AOJu0Yxt34AvzuhQCqV3hMO5suLL5bInTy/ffwcAt0FC7R/F+Y/7ls9Y
	AW8rQg4Y4pweQ7iq8AOgzZgXo0HgClDDPnraIBscVEXNJdp2/yBE4GwKVmeB3/9nhdeCERaxDZ9
	+
X-Google-Smtp-Source: AGHT+IGtIrUKQyCIymnsfl93oO07z/6HtkI3GgLWqkSOVquKFJB03RgbZYb6gjV6vvrpJ1tAw4WTKw==
X-Received: by 2002:a05:6e02:19cd:b0:368:9b64:fa7a with SMTP id r13-20020a056e0219cd00b003689b64fa7amr3934988ill.0.1712369214331;
        Fri, 05 Apr 2024 19:06:54 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.135.167])
        by smtp.gmail.com with ESMTPSA id c13-20020a92cf0d000000b00368b9c86edasm721411ilo.46.2024.04.05.19.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 19:06:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
In-Reply-To: <cover.1712331455.git.asml.silence@gmail.com>
References: <cover.1712331455.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/4] clean up io_req_complete_post
Message-Id: <171236920863.2449875.7144685921843197110.b4-ty@kernel.dk>
Date: Fri, 05 Apr 2024 20:06:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 05 Apr 2024 16:50:01 +0100, Pavel Begunkov wrote:
> Patch 1 from Ming Lei removes a good chunk of unreachable code. Add a
> warning in patch 2, and apparently we can develop on the idea and remove
> even more dead code in patches 3,4.
> 
> Ming Lei (1):
>   io_uring: kill dead code in io_req_complete_post
> 
> [...]

Applied, thanks!

[1/4] io_uring: kill dead code in io_req_complete_post
      (no commit info)
[2/4] io_uring: turn implicit assumptions into a warning
      (no commit info)
[3/4] io_uring: remove async request cache
      (no commit info)
[4/4] io_uring: remove io_req_put_rsrc_locked()
      (no commit info)

Best regards,
-- 
Jens Axboe





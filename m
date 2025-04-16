Return-Path: <io-uring+bounces-7482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1538A906E4
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 16:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05E09163DF0
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 14:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DD77E110;
	Wed, 16 Apr 2025 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vm9dIVJa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8681E
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814889; cv=none; b=RlNNAL2+7jFD0mVXVClpP/b/AAbWmQDZjpA+hXjISsQbi10+jNioWN5ir5jCEHnAJPGdpc+iMNIgj2CAewLsubuK3/RlUMsevJYYD+SBNd3eTXCG4h/jDmheM26mSyjaAQGlpkutG8yJqkKCqmT0Q77AXZ0kc+HE49kC+8fczCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814889; c=relaxed/simple;
	bh=K9u6qju8uPbBtfMTuHW4Zfa2EXt8CDs7OtfeVdZ8soU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Xi7dgrsZhl45OnUF6sSLIlNUNED06/eLGVObLKBBXcnINg6UODXMzk+gqtE/n7/IiXxB82zHFep07KsJqLkXiiikC9gBkYmu6XIoHK/Bi7jDDIPYkyNU5+lW2rwmO5NrDRqsf/hcO9YQDdY7m3F5JbXsRRvtQxryAs5zvPf+Yyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vm9dIVJa; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d439dc0548so23328645ab.3
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 07:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744814885; x=1745419685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ6eUAHnXm6ngzc6Y+R4E0QjjI0mFAYSeyQFy9lQmoo=;
        b=Vm9dIVJanNE0K5h6rO+ma9OsmvCvjT0Toz4jJBs1btj7AzJAdmSxLp/SwmMp3YlYrj
         v53O0hjS53+58dHC3ZLKEhqJ+epvfnVrdO6kRQ6DTcRXXdH+u7QK6F3ZLo7bTXfhm0cA
         FkQTEASGAbEn9vWbJnyhFOn1nHbyT4Jw+ia0IEHa/3lwu+eH6aoyy1WVT/yigkPG2auV
         QPE4grLaabB+AciHQ1/1itii7e+/tdY5jFRZP3080ywBPnICoPWs7dXlYgBo97c23aV5
         x62QnpARlRp5hzbzXzNjfbngshl6XYH5zWjpGHAVJRUFVIrsBP8Plz5d9EL/Z1L1LvoZ
         rOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814885; x=1745419685;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZ6eUAHnXm6ngzc6Y+R4E0QjjI0mFAYSeyQFy9lQmoo=;
        b=npLIXxSnS7bXpsaZ+R3NMwOQSr3xoFHw69WgAArlkdUU5tksdBtvfzhxuLGl62cllT
         seKvl1Zxy+WnE9161SQnyaqLbzNu2ntGuuwRowqU2PZob2kGx9kl0lVVCG1lGoitXPOH
         AwhVy4iY/DnJy+BRwRVONJO1qMZgCSPz06jvZFev6E2+fL01FCqi8jQcx8/ym6flRiQy
         26Z8w7As2mogysrLDE3iWP1Bf0B9DSHwSNWQD2KE54OhePFBwt9JkV3WmywO9nB69NTv
         FO3EjG8P3FTOow8QaesoR2F3+11ZYKXit1bcQgM0a4QK8OGmjmfCy07kSRR8DA/1etkm
         8vJg==
X-Gm-Message-State: AOJu0YyFUbJ15QOqgk4/DW6X965fug8l14WdPzX9S3/0TAPw2z/Bki5n
	jFiWrm0pLTMQMa+wC53W9YoVLu79W70/B7eBg6pzUCdPmsGtxs0/5y009pjCinQpWtxG6zZsRcB
	Z
X-Gm-Gg: ASbGncvfmbwRQzZuc35mtQ12fBofSKbY8Woz8RKN1ERqEsjISRvLZgGzYKAvN/zMMty
	1FJZXTMfDLMp1l5g2PX7z6eRdcuAC1D14aKs4GcI4at9oFZOAzWx0rfJLt4c+FhIX0EFrVBszBt
	IWAU1j+jWqPntogMVIwpLTCiQ++OFyJ3Je8c6LrTp+1zy2rKZuIQ4ERwCVnLgIrSPiT5A/67Jim
	NvA6ksuYPfHNaTT0grGH6VEWfhTuW2fylSPjuAWbOwxb6bkGhrjSq6FpSS7/J2umI2I3ZumjuDV
	bmAVngpKgT3hD6uZl9YoschwYLhRE6ZoMvmGeS/EGA==
X-Google-Smtp-Source: AGHT+IEJIITrZwADkHN7Ju8BdcceDkouhm51fqj/BQ4Eb/8tKjSeL4DT/J55Fkz2O4vKZBzXPSSsqw==
X-Received: by 2002:a05:6e02:b4d:b0:3d3:f27a:9101 with SMTP id e9e14a558f8ab-3d815af46b6mr20330215ab.1.1744814884717;
        Wed, 16 Apr 2025 07:48:04 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2e63dsm3630764173.114.2025.04.16.07.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 07:48:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>
In-Reply-To: <cover.1744793980.git.asml.silence@gmail.com>
References: <cover.1744793980.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/5] zcrx example and other changes
Message-Id: <174481488391.330050.9226351914108896133.b4-ty@kernel.dk>
Date: Wed, 16 Apr 2025 08:48:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 16 Apr 2025 10:01:12 +0100, Pavel Begunkov wrote:
> We need a simple example for zcrx to show case how the api works
> and how to use features. Patch 5 is a brushed up version of the
> zcrx selftest.
> 
> Apart from that update headers and use the kernel return zcrx id.
> 
> Pavel Begunkov (5):
>   Update io_uring.h for zcrx
>   tests/zcrx: rename a test
>   tests/zcrx: use returned right zcrx id
>   examples: add extra helpers
>   examples: add a zcrx example
> 
> [...]

Applied, thanks!

[1/5] Update io_uring.h for zcrx
      (no commit info)
[2/5] tests/zcrx: rename a test
      (no commit info)
[3/5] tests/zcrx: use returned right zcrx id
      (no commit info)
[4/5] examples: add extra helpers
      (no commit info)
[5/5] examples: add a zcrx example
      (no commit info)

Best regards,
-- 
Jens Axboe





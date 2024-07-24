Return-Path: <io-uring+bounces-2569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E055893B22B
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 15:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA291C23651
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B42D158DA7;
	Wed, 24 Jul 2024 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NckKWYH0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE2F1581F8
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829511; cv=none; b=YKyzI25qUgEZ6vHwwZ0vzQMMoMAsIAQw44VqbiaWdH8ni0474xjiOtq8Fg1PN//HjtB+LUOUV+i+gjhOqO6BHduOgCkep4GpCkpwnBx9au24iKRuyffaYkyriu2wLG38tABXhbNvSy5u1W0DQA7O0WxxQvUOwK+WUl8pbL3ix/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829511; c=relaxed/simple;
	bh=uD93jHyPh1u9UscXa+29/QSrBbgu3UD9lV/WCgO7cSs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XrKPXc0lA7XgRANCvQACmbF3VRjuNBn56FidycJOjilzJJ8Y1ZrR03Yt4MAt80PYhGhCafSry0mLikNZbZnHJZttMzS9Emg6nHLO1VSzI1FjlT1B0RWcuYoZwc7ZfObsipSn0bBftjOYRWzP/FhW+k/no5cC0LM5lNufP+whpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NckKWYH0; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2610c095ea1so424786fac.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721829506; x=1722434306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBPjl+E7bX6d1sYy2cDZQ1Mj120NFRnBDduTqwLlsSg=;
        b=NckKWYH0z+otHQB1Ec84yxd/ZaIDa8omnWWZXNGsEM/VtLFGo/xJpUl71I+mqK2kJD
         CEkaSl645tK7Vqs4tL7CS7kG8v3lo+xx1TvRV3iCgJP0U88AOSlCIUiL9+jMVsaAXIMk
         IP/GMyrxtyPN1VAorXzh1TGGpB2+hMPMdcuDjaZImOclQgRp6WBMFz8o8yLM4p8+RLCy
         UER6uKAkgDfo034PeqFljbngtjeluCV6cXizulIQBYNxBJIfKrKmEpKKe8Wb1KJtqkZ4
         3rv2XT5AvthjG/kDp5Lshpd74QMqeZO4ErEJZZn2ILQ3IV0RYaYcPfGyQNSXzNJ2D+D+
         yk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721829506; x=1722434306;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBPjl+E7bX6d1sYy2cDZQ1Mj120NFRnBDduTqwLlsSg=;
        b=E0a9dCsFI63P4cmgAiNMt7WCrIoLhAuXRZofY8QOH9qA72avBrso/9Zk46KNElv/PD
         bSenWyOc73bhazC4Z/4eBP36+BVBd5kZrcvGYa/+GRkwokl39q39v7/v8KDDKR6FNu3T
         cyRmYiwXhQKFb/jWC77fRsL/SG2cdKt1gfjJ7Znek+xDK4WmmcohYdX28Ue4MAHZle7o
         8cdFNT6goQAT+GnSK43T1FNFk+fhHXE/kQr3oZs5jfh+27Gcw1zhmjfHwI9DJ7ps47Vz
         2XqKwwiz+1bZgtnxcwPWSONWBrX5Zk3Q+zfudrc9DeiwFdU9JONEIMqNr8llVvKvBD9p
         mlgg==
X-Gm-Message-State: AOJu0YzJMZRt1BYfQN3V+TFPVVqNNXuZ2XJSt0ECZ2CVT1dCIILpM4tn
	RcDCMuOLrTaAaq/HK+/hULA87AlsP1K/uRe+1PRFQF2HH3jvhOdVeXYCsK0tRL4Lak5SKz4YHgB
	VlvM=
X-Google-Smtp-Source: AGHT+IEAdB0P2NTOm8cljUaha7obZYRvVJ6LJ0m0pWms3mZyz5WN17/PMppC089dUUMo4XCbx+5RqQ==
X-Received: by 2002:a4a:c811:0:b0:5c6:65fb:d734 with SMTP id 006d021491bc7-5d564ed2f39mr8010161eaf.1.1721829506596;
        Wed, 24 Jul 2024 06:58:26 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d59ec2be86sm356361eaf.0.2024.07.24.06.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 06:58:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e8c3ed425b98c5924f746cc6d51c9bdbd90cd948.1721790611.git.asml.silence@gmail.com>
References: <e8c3ed425b98c5924f746cc6d51c9bdbd90cd948.1721790611.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/sockopt: {g,s}etsockopt with io-wq
Message-Id: <172182950594.4497.9286187085603562525.b4-ty@kernel.dk>
Date: Wed, 24 Jul 2024 07:58:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Wed, 24 Jul 2024 12:10:17 +0100, Pavel Begunkov wrote:
> Test that {g,s}etsockopt interacts well with io-wq.
> 
> 

Applied, thanks!

[1/1] tests/sockopt: {g,s}etsockopt with io-wq
      commit: 3d152a3bbca78d11f8841895b07137f651de9dc0

Best regards,
-- 
Jens Axboe





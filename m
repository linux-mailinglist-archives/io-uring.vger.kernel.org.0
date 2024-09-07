Return-Path: <io-uring+bounces-3086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B85970272
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 15:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B6BE2840B9
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 13:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3513015CD4A;
	Sat,  7 Sep 2024 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uniWXxit"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB11DFE4
	for <io-uring@vger.kernel.org>; Sat,  7 Sep 2024 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725716440; cv=none; b=fFMKdDT15uBTaC2nfbhoj+1uqeSgss7Yw+rGScTN0PZ/thnftQGjew3fdhOaPoHk3yqLijhb97xFRp5WXDqg93dpwThIc/RqpdvAZ6lUL8AlcLmjlMnhIteqlYnXnhH8qFosYQUtXLzZkaAbsOuiLrjv2ReNhvb9AO8HgnGYI7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725716440; c=relaxed/simple;
	bh=OaqPvacqn6/a9sSDdmHkzNo3Z3URadX8+wQz0oAN53I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nnI1e6tVKALHWMnBlp6kubI1aAIgluNWO24BoUfaVvT1K9EY1N/jpQw48jKrY0yHOyj2KgpegCWYJxykHZR+qqBQIknpcSGC2VMqhN61c6SZtj7GBosb7Avhs3PJ2ZdmcLRihQSvcKYm7D8IDTDYUyN3IijI+LXaQWbF7cV+1xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uniWXxit; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7d50e7a3652so1664712a12.3
        for <io-uring@vger.kernel.org>; Sat, 07 Sep 2024 06:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725716437; x=1726321237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0z2NqKEDUroec7DxNinieI4BqCY7iLkxEiBrhdUI5is=;
        b=uniWXxitIcKWLwnLlRalerHovn2y24ZO4ovMg9d3k8POA3K2q7FAOtJReXMKOXkR0j
         29CzRcuT6c+4AUOqtl8Jz/X18WW7XQlFc2wMC665vvoJ2COW+fLmePIrFNFqA9CskTDH
         cDDuzaInRC5uSuKBW2tyrcIvAilehUqUsQTNShjtgdeinXYC9Cy6OC8NLPY8ITLNSX9q
         71kELuuBOgRFSrka1eRZ00kXhbwlzsD5dKsZiIkly8eJXT1gFBo+KolXLbeUHCUN4v9F
         QHOAonTnRlcuSBvFnkABfqQxaiVFwE8haNV2VNaaVOelffKEXtA1jPd6czgsZerFWTIp
         EAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725716437; x=1726321237;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0z2NqKEDUroec7DxNinieI4BqCY7iLkxEiBrhdUI5is=;
        b=FzDebLtE5L1C0L0sGSCwovZp7vPvHtUtWguTBlGDdFLmCCNN3PimMn/78BskOK6Q7e
         XAmtJcWPTb0DJ4FXxW3W1qBDdX3/WEkxSvDzDRzixpvy/Z7j+QirOmyPkQWCvZbNOoXk
         ndsieA4nMg8WELzDj9UGp0wIMz60XZ68ZTrC9LM5qK7Q391Vg9Kawu19ut4wxfVTU92P
         SmS/nfMgHP3dxyc/SQVlEyGdiFOiMX4hw42JR+Lm6PoGSZqo0AkMB8jO269PgpGmwjzb
         oZSOzAbD+Nz6HwbVpQydi95GpA0LrHYmIPTvmjsI+A86u4KMwupvKdUH/+KH//h4hyRf
         5TCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiXW8v3WmyUuDBbDZrz1s7qazl+jVI/XjuinVIUMeHPdeFrCFARF/TTKRR96rLIYytqOC1ekz+Gw==@vger.kernel.org
X-Gm-Message-State: AOJu0YybAKrrdaZH+CycmZwvx32LGxZCZs8CIhDyYLifup1vrx2uF54m
	3dgJb5jbpFoo4iX5gU7bhRzQyxUQ8oD+y8QNHpxg2GBBLCK00XTCcygzfQSO2Fs=
X-Google-Smtp-Source: AGHT+IEhZwbieHskPJo4Uyj4OnCXHu4QjPHSgjLqpiJL1ZTfT5B9jQR8sob0cT5Yfw2RSDaiyPHHbA==
X-Received: by 2002:a17:90a:d150:b0:2c9:6cd2:1732 with SMTP id 98e67ed59e1d1-2dad4bf1ccdmr6610025a91.0.1725716436796;
        Sat, 07 Sep 2024 06:40:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadc12dfccsm3368356a91.47.2024.09.07.06.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2024 06:40:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com, 
 longman@redhat.com, adriaan.schmidt@siemens.com, 
 florian.bezdeka@siemens.com, stable@vger.kernel.org
In-Reply-To: <20240907100204.28609-1-felix.moessbauer@siemens.com>
References: <20240907100204.28609-1-felix.moessbauer@siemens.com>
Subject: Re: [PATCH v3 1/1] io_uring/sqpoll: inherit cpumask of creating
 process
Message-Id: <172571643542.244981.10331950852185495338.b4-ty@kernel.dk>
Date: Sat, 07 Sep 2024 07:40:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Sat, 07 Sep 2024 12:02:04 +0200, Felix Moessbauer wrote:
> The submit queue polling threads are userland threads that just never
> exit to the userland. In case the creating task is part of a cgroup
> with the cpuset controller enabled, the poller should also stay within
> that cpuset. This also holds, as the poller belongs to the same cgroup
> as the task that started it.
> 
> With the current implementation, a process can "break out" of the
> defined cpuset by creating sq pollers consuming CPU time on other CPUs,
> which is especially problematic for realtime applications.
> 
> [...]

Applied, thanks!

[1/1] io_uring/sqpoll: inherit cpumask of creating process
      commit: b7ed6d8ffd627a3de8b0e336996d0247a6535608

Best regards,
-- 
Jens Axboe





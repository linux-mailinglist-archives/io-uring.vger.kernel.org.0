Return-Path: <io-uring+bounces-7933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B84D0AB16B8
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 16:04:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A6E51B62F7B
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 14:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A86126C02;
	Fri,  9 May 2025 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d/V0279O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F76828DF2D
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746799337; cv=none; b=pSdKywIBuiTIkGG+Jb5WXsg+N9MukEn/8jI1qYidqYlHu2Nme6UbNtrQlAlojKl0SKah5ufqhjhl+T7aBTsiJVW1jF3xKLwVJK6GMw0dQF1I9PnUcvkFAKBmijtM1fWKk26yfLgduPPVDBSV17rjBSVLX4eqYghlVhMTNp9b3C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746799337; c=relaxed/simple;
	bh=hAdXh8t0jzbfeYWVFthjJb6/gxxBfEZyqopo4I2lIFg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uywO21bpe2vZ9HqTCeCH3VvbEpCOn6iMIhfo8lvehFlcIKeGjF3a/iIlPAQxlnui3XMiEVLLOK1tp/3Y74xhjRUPlMg4s017s0ajl4YcKhNsEm+S1KtZ2yI2a1xAjOA0knQLuHuvpOy1xeM9AGXDqkIhs9uuBkczAM3GIL9yHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d/V0279O; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85e15dc801aso189101539f.2
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746799333; x=1747404133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EghSvoxJi63AVLtz66ATKV7BJZgm/25ck8qxZDgiY0w=;
        b=d/V0279O6xSQd1aT7Az266Kuj6CXIsoZy0P0ExPUQc2w0iVLTYekcGEjByo/kwZJLi
         oLDYgtOpzKsF10AdHs5KzvN8EbVjvwBiS6WuW1ax+ApaXCsyktUDUS+ykQtZZNEQ4wJ7
         8zQzengnCC5u8yoy0kWxC4E5313pjQz0rkE/qzBwGdqSirQlFNsHD1cJkbciyraR8z1a
         eXZJZAw6Bo/z0tO0Kjlem9dUeS7EQaBSOFRUIgN4d5MglkucuY/F3H5iLR9mLp00T21g
         5zvKwB2lvg7Ys72ddLiLk6yxywmY4cWs1z1vAx/psdmVgWo1zytXamWJG+rrWhiF6i5v
         iNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746799333; x=1747404133;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EghSvoxJi63AVLtz66ATKV7BJZgm/25ck8qxZDgiY0w=;
        b=S3n6tKcrl0Fwj67FEByPElK7p+v4TTSOlzoz7WyqWilU4cI1zZSWOprFBsM7ZD8zR/
         TwYNvqCpHscDFaqI1M7iDxdozWe3FuwiFRLaxyMwwWfqNAzDGSIL58xLuLvNSE8W+qgT
         l/1Pr3HZ/lScLhFBX24dQHQ4jFUxcK/4ovuBKn5MobqY1dJMp1R4rLlBjpGatUbs9Qiw
         PNuOms8yH1ZsQaq8ACH7j0gOUPPiPBuJJm+6hEqBfK+anWruyDVMRSp7Bp6SSaH49tj8
         Mznda0o2+/vvZhi3Gsl3A2B1hE5mV2wGk8DriTsDRwd6ZzEmJ7Y5H/hcPAsxfbASO6T0
         4Nhg==
X-Forwarded-Encrypted: i=1; AJvYcCVfdSAf/xbB2VRLWF1r0Kht1dwaMfAHp0jW+e7fy5B6PzzNf7C1nzZLO/WB2dyQ9bOSHG029pJo7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHcqG0kW2LFnWkgIvsdlAYeG7dMcFUEmQAB8HfS2Oxhri3xGh2
	JgFT++6zllLp0GEFxMWRLjtncrt31U6+kXgh/n432sn7QZCyMQIEh7WH0PJeR8s=
X-Gm-Gg: ASbGncuXEv18r+xWVmgo29cx9Qj+erJ0rVaA75aPEnyt0kdoT9igCNprIcKzfBNiSC0
	T2gpAfHuvA80miyg/BB6GIiTcTa5StGAiYj2XY0vSKXzKxU89FkZFGnFL6do3KAo02TRUdfpYpW
	Ee85jTx2aYeexp+kokaB8I0b5Y4IJTZ+xbb5V42sxDwqaF//W3nGXc6t5vHg6eLFUYvVLOaqvQq
	1gF4vxyZUrnxeVTG9j4NghHwJdKIV6iUkvArddz2ee4hyh01zFPFz0jq4UajmmGHpuQFc7NCjx7
	i20rStJ892FoxPyTLlA3H2SYZClw7hkHWxQcToe6Yg==
X-Google-Smtp-Source: AGHT+IH+G9ukAa5eEuMKDl//riXvRnKbAmeCejE2HbXDym5vFQpuyg177jyZg7ah9fDVEOyALgs7hw==
X-Received: by 2002:a05:6e02:1809:b0:3d8:19e8:e738 with SMTP id e9e14a558f8ab-3da7e20cfd3mr40148925ab.17.1746799332793;
        Fri, 09 May 2025 07:02:12 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da7e113335sm5768685ab.31.2025.05.09.07.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:02:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, leo.lilong@huaweicloud.com
Cc: leo.lilong@huawei.com, io-uring@vger.kernel.org, yangerkun@huawei.com
In-Reply-To: <20250509063015.3799255-1-leo.lilong@huaweicloud.com>
References: <20250509063015.3799255-1-leo.lilong@huaweicloud.com>
Subject: Re: [PATCH v2] io_uring: update parameter name in io_pin_pages
 function declaration
Message-Id: <174679933189.96108.13103638202892311862.b4-ty@kernel.dk>
Date: Fri, 09 May 2025 08:02:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 09 May 2025 14:30:15 +0800, leo.lilong@huaweicloud.com wrote:
> Rename first parameter in io_pin_pages from ubuf to uaddr for consistency
> between declaration and implementation.
> 
> 

Applied, thanks!

[1/1] io_uring: update parameter name in io_pin_pages function declaration
      commit: 6ae4308116f1033ceb11b419c01e9c5f17a35633

Best regards,
-- 
Jens Axboe





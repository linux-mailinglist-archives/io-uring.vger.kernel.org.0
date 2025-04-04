Return-Path: <io-uring+bounces-7400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA1BA7C14E
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC11F7A538B
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53616207A25;
	Fri,  4 Apr 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mS08HwzX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA4207A2B
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783051; cv=none; b=t8MsaTQ1VpcOczXc4oUzUpGSf34AYN6TOUYX/1ArpHE3iN/tG5IwAhkMT/9qT7KxfeD2zC5rhdnYkrZ6u9ZbVTmQEqFsIlVyNAKndsqP0FxMIWLc0EjdvPwdkQQ+R3Y9tFrLbfyysN0B5brZT5NXP8WBIFzeMRRvqirY+Ch7dvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783051; c=relaxed/simple;
	bh=dH7n1bCbEKUHfly3Cf2T0B5zTTA3eaRZ1R1M+yM/mSE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mB1dqcSDf1kO/XFs2qQkd0ZR39Mt35lLx03EMMuEehnzeKEorJMlJ9d5kSy98bWmAmZBdmKd2bR2hZ2X9lAl+41HrgGzhUggyVE56Zj/3BsexHc+RX+XAS49xxh8mWMCAbOgGwrZipSdZmwdvVkzP00w5j54lhgfmN3vNyLf4t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mS08HwzX; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-854a682d2b6so149007739f.0
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743783047; x=1744387847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iXTFkvfuMKmPJyHNkHpgG1/2N6q9/85PJng+4kyTYs4=;
        b=mS08HwzXstLbmjElzvH6yMGnoZUMRQMGpPcFEkPvbirSnLVWGwm9Azh+lY0LoTmTWF
         38H5p+1PT30DaHzKvLk/OfqICzVWohM+7KcDgnaPZvgFwVqjw09rAPy3/yWTb94PQmGj
         fKl0vyJQVWBnWElEpCsPOMr28SwluINwt9AjRZpYXE0mKghOzthDk77s+q7Kn3XJMUdb
         BRpMed7zyShE7Ez+p+TIXERSvGPYKVb1j74jr06Xu8OeLr4+6LUQMasqc9hpyawp5L8u
         5DxWG4EvC9FG17xKm8UFbem1ZBysHkCVf2epWfLcw1BavuDQX1jIj9PyrNLrMcD6wIkS
         KGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783047; x=1744387847;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXTFkvfuMKmPJyHNkHpgG1/2N6q9/85PJng+4kyTYs4=;
        b=E8VoBdw9VZn/eEkSvAEKxoJn2HzIp3OZ2eizR5mvVTm5uT91gL+MFSYBRw3chRHZYh
         PnBJN1+jy3CfsfcyVq/znOf3BURSNhy0b9qyTi+SEFalEDlSU42zxuUpeeYfjGCv7oyy
         nlHKIMkKg/wY3oLTB2AyNAl+EIFAbx20XaObcf5tp6RohET/OAuQI8rcNoazKSK8MT2+
         Ka3YwBpZCnwM5wZOL5QukQGPHGyypvb35wAiEaRhNj3DfBqBIK+Odwb62C8FKQT4bsZV
         drdHtQ0WdKQZpSPVC/6dElwj9E3JzYtycpLhaC7a7mYIhsxoIh93s85e8H3fcJmn/nSb
         voOQ==
X-Gm-Message-State: AOJu0YwumBLNZ0MlLEoLJu2yrV4vtvn2QnsLCLePNoVtI6aAo6vfAQeo
	KZPVYuy7lSAqz/tIIC2mplHiczlSefIRcWa5SOenaQo1fZMr3QcCZtu3LgDnw+I=
X-Gm-Gg: ASbGncvpEmgZH8fLizGVWR6dsTrIXNCGZ5SWQ4GONf9IgDcxwUQ8U7+vxhmbkmVHev3
	N6brjJzqSPWxXXoPKW6eIfWz1PJw4sPzzs/SpR+OUuyZrKbd8IOnTPJMo9sccbTesgowbsEOWKQ
	1rrPfoxUolLAbQ5os/wYinYqXkJiNPkHksrMOPmbcIqwmWVuWTuCQ+5oDTpwXgjE5AzmvQK+rE3
	r3FIqN7y+HvVfQjz/KXQ37Uqs0bW/o2ThgmRZMM5yQ8KY1PF03r6HtFr7BME9kInCkHFp190D1q
	QB6khVRuYtlQoquc3BDZSYaDBqYgiftLR5w=
X-Google-Smtp-Source: AGHT+IErYKeulg21aauRhuacZQ8N6AdDK9n0nWdNZpOOSXo2dSFv0G4InljewqEUEcYf7Ilec53ohw==
X-Received: by 2002:a05:6602:36cd:b0:85b:3c49:8811 with SMTP id ca18e2360f4ac-8611c2d47e5mr464481839f.4.1743783047083;
        Fri, 04 Apr 2025 09:10:47 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861113a73dfsm66668939f.39.2025.04.04.09.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:10:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8791bcaf3c7d444724055a719c98903a83d7c731.1743782006.git.asml.silence@gmail.com>
References: <8791bcaf3c7d444724055a719c98903a83d7c731.1743782006.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/rsrc_tags: partial registration
 failure tags
Message-Id: <174378304645.1210676.14305087262376058485.b4-ty@kernel.dk>
Date: Fri, 04 Apr 2025 10:10:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 04 Apr 2025 16:54:03 +0100, Pavel Begunkov wrote:
> Make sure we don't post tags for a failed table registration.
> 
> 

Applied, thanks!

[1/1] tests/rsrc_tags: partial registration failure tags
      commit: 5272830fcd6a66c3b8a8044dc9692650b7643212

Best regards,
-- 
Jens Axboe





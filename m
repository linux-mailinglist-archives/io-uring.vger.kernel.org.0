Return-Path: <io-uring+bounces-10456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7606C42C9D
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 13:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E5394E21B2
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 12:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9181A4E70;
	Sat,  8 Nov 2025 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oYHL3X8Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F27C2F659F
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603944; cv=none; b=LFbvkyOBDaYb3D/HMVFhhs49LDW/VCEEJK4K91Hoy0b8EoF9v0pS5l6nvxBSnDdnJt4LM1h+ITiXqL+KRCZ4NqvfJJzybOnh5tY5EMLO2ULPfBZJ080jIBqy1zd1y8v/bnk9vRN2iKSf8cnrHct2LluVKhIKl0Ja2TRGXUA9gO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603944; c=relaxed/simple;
	bh=68b64aw5fPlMuL27gGBu+3iE4JJmaDelN4cAcj6/JrE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=L2jrkQfNe7TxOc23wxDOv/B5yOgq2bY2dNswKuh6ACTOOTzoAjh0EAAGu7LySUaX+cGwtVG+ZOsOkS7QkC1blVzATxROWO/fmBCoviksURxK8u4ob48rbwj1ARATKg/yqjOFbekJ4edyldhCLc2AlL7Posmk1YUxItNhEwiCStY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oYHL3X8Q; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed72cc09ddso8196721cf.2
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 04:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762603938; x=1763208738; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YULD/KTxfXW5uKPAhckXFd5QOFUyxiLp8MsHTIZ0FYY=;
        b=oYHL3X8Q9eU9+iEKRn4NsSk+mcZMEMDOmjvSQ0WrgGPgfACWsAzHLCOoUiC+V8BoIe
         5GPP61fyM9VsLJmWJjkmcsZ3LB+Rdz5d8lL+YBm6rxyCgAXEFvWkvuLI8mvefqVHEuf+
         /7PCw3n5a7ozk0ze/jP3QG30I0TZQAqx6RmzrgD0xK96wleFm5HMQLS8kfjdoEt+5MiO
         I3qiAmzp5l2D8hQUELRRWHd6C4Q1oKIvHbUxKJzED+BwDnHII7Pl27HH0xhylT+zAfY9
         vwom2STTKE3dLdfox1S7+34QtKyL5Byp4gdMRCf0ygrVT0t+RApN4txguaRfp0uQZGRT
         bNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762603938; x=1763208738;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YULD/KTxfXW5uKPAhckXFd5QOFUyxiLp8MsHTIZ0FYY=;
        b=Gss+RgW9XdA8UyrF7KkNyU/ts9w+6zA9J5M9dwhKQGU9GTUf2174vuLoPlWlEQkN8A
         OTdABspVT43Uw5OsFlpL7yeJKYuoJqEBNoSFOffVjFU+66lIFP3fcAaFGknpLSuLTCV7
         7odRDQzGMx80pQhiPSRHThkJ6ANmlbzUyR+l4j2c3lIEZBWObnMt6tdIp+7TSBV7p7mD
         JwN9tX1hyH9A0Ub+cVdSbUvKuSvjIuJQbiAQuLm91rkcw5HXBtqvJdIhvNmcel4uGkEf
         d/NJwvZ3zFIQAtwJa1YJ7rAF+Mp9H2UtByJn1YwfnMQJvY080rQr4X8RQLtLJYm2ScDV
         YQLA==
X-Gm-Message-State: AOJu0YyAmiid/lWcQQHVJwMctcp89kyZs4qyZE2Lp90nQOfM+sQWjk5m
	uUBQRaC/bu5nd36Lj08pJikJovSQvRvFtQ91jp5zWhzQ29ONC808AZBhIGamRmWzOso=
X-Gm-Gg: ASbGnct3mnxt+S4yV/6DnJ6eTwUClHRqMY3YLyW9lvwHhMpaMr7cetTvBn1/ZRWjLpG
	MASnm5h3CcU82VT2MvcLK3XJnI7oOvPlmFqv8wcm4kCZr5fS7Vsa7EA3S0iC6fvg3xOYQIvPqdB
	HCfhswCBU44SaToGcItkZ1Ro873LLr68xtC+LXuEg++XVyzTfgMeam7sJFediqM3Z79Fikg+J4w
	V2F86Rj7TWGmH/L4XoD5rTXzeC+M5CZrlRvVffFZIYY1Yq8G5zch3F1JqOV++n04rfEE2zcKTc7
	5Lm7X0CquJp7kkPlsTjbb4IgyO9rrWf7Q7irpX3MHro99z3ykbYb4xqlRP6W4/B30qBr4kS4O64
	Hoi/UgrxP+mf8wOX2CLxqa/L5XMX4JkyodRii/MZgrqYW06d0jAvD4BEYUaP8tzFMNtONI/th
X-Google-Smtp-Source: AGHT+IGvhl5UVu8z7IAOlxV4ufD8HDcjndP04zdPbrhQwByqjJ0WrOgfMmLHTe5am3KGXhus+hog9g==
X-Received: by 2002:ac8:5945:0:b0:4eb:7dfe:44a1 with SMTP id d75a77b69052e-4eda4f7bb8emr27898941cf.38.1762603938010;
        Sat, 08 Nov 2025 04:12:18 -0800 (PST)
Received: from [10.0.0.167] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b235809f79sm601974085a.47.2025.11.08.04.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Nov 2025 04:12:16 -0800 (PST)
Message-ID: <62289a4d-089c-4f3d-af83-74b50a929025@kernel.dk>
Date: Sat, 8 Nov 2025 05:12:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.18-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Follow-up pull request for 6.18-rc5, as one more fix got posted that
should go into the next pull request. Single fix in there, fixing an
overflow in calculating the needed segments for converting into a bvec
array.

Please pull!


The following changes since commit 1fd5367391bf0eeb09e624c4ab45121b54eaab96:

  io_uring: fix types for region size calulation (2025-11-05 11:45:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251107

for you to fetch changes up to 146eb58629f45f8297e83d69e64d4eea4b28d972:

  io_uring: fix regbuf vector size truncation (2025-11-07 17:17:13 -0700)

----------------------------------------------------------------
io_uring-6.18-20251107

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: fix regbuf vector size truncation

 io_uring/rsrc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
Jens Axboe



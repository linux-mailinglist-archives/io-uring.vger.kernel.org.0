Return-Path: <io-uring+bounces-10433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C46C3DD25
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE5624E8C1E
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC65D309DD8;
	Thu,  6 Nov 2025 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QOPvLMDO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BA4343D8C
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471542; cv=none; b=ZmBzLSoIj8+R0obQ4zqPwEihWGQ3Qu0+5uVM3fNOj+DlxM7k27MiSg9rlSYrSZViXIUkKD2V38xS3lgqVqa4fTZbr2litCS+i83DmrkrjWfoaaY7QEbg8ILmMjkqiG6Pl8vb8AQxGwh5nSZYedgoqFrQo71/OKelA1hbudVnQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471542; c=relaxed/simple;
	bh=qpXXvnAuPbbWIAT3zKOAww8+bFVHJJLCcRXdTcJJOcs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JYbTVBZSrq7OrFMd9SkJZxV3pJ9IdUQyoxVuk7fH13aFmPU1vNeaFgI0NAq+zKxqZpcUugLswW1MdgTeY9nJ/KzCNqlfx+AvnFB9NpNFPC4sfk+ULP5CbIlGmstr1DmYEGwaOS86aYyXVOIjkDC8bZ/pNPi8a38zruOomnD5uAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QOPvLMDO; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88051279e87so1788476d6.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762471540; x=1763076340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27ZUjANjtJJiOH3XdrUxaFGSrUOJGXOVG1rVYSEVLow=;
        b=QOPvLMDO4/o6/y6rluEhi6FywWCkgjij05QWla2/5TK+TOQ+gW6Kk8l+NtDFOPlzsO
         IYzt1driHbc2jrYnLrWmZKuWK0HwVpIA8Mt6gDJaFZwDWg62QFsRmqyaP1EeSZ2bksS0
         t2VSJChZMrRYnmptbAYiRo6dI04N1Ik9puvtq4xiPLtOgzU2ThvLDvvDtYVIFOxkEccy
         k2+SoksYcYK0EviszzVh5OLTkZzaVoZgFlFCLO0rU2NsI0KefGgfoLnD2wZ9sxVasHSu
         aysC4VKJOZ/WF6g7XZ8qKA5ywH4b31N/s2RRQAoOPvAZkNN8E/IEEhDYADT5XGY1Wo3n
         DDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762471540; x=1763076340;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=27ZUjANjtJJiOH3XdrUxaFGSrUOJGXOVG1rVYSEVLow=;
        b=ouwXjhaz1x5OZewsb949kMzapTuDzj1EBZACurcSD56sM5RNGzvqRcYhux29Ran9X+
         4Bt/x++SaBUMbmnm1mPTZBUxuExU++kcBPiWiPPWQsNJwCsIewXfsV+H7+5MJ+bPA86S
         o6MZiMyOtY6FCz3OSwDGtcghqeLQOKSdYrb6USpvgdqgEO9wzTkZgm2VWzcjZdCRsxNU
         2O+Zl3O6WYcExYzfEZ8zg8PqC5141xsMoQ5DM2MEy8RHTRXWwuAE+weckaYWmvzvVrCE
         ghWlZrnW1g+iLFBdwCxzlPM0Hu74yuOHneVyb4VYFfKdl90WatiiAw8xCX7GObgguG/6
         FTBg==
X-Gm-Message-State: AOJu0Yxj8g7mlSId/keKX2WwCs3rMZtaNIRLl7pUBRTFuBe97BjnFuvi
	U2vpbNwsfUhcnB6kmZ65e5+JOaG3iOas3pvw77WXfjvN4o67Nj52M3iF+I+mgHZTn7eaecCxVmb
	rwy+F
X-Gm-Gg: ASbGnct92+vbh6MPsON8jO3U5464IR9wi+TJDktjDBlh3+Xtf/VqcDCwtdXaWAx7iKG
	LQXyi0B3jvpJ8P3ZjRQK4NtE9L6bOF9jotsIIpc+LNxoWTWrMx6E2cAJh6kPp9s+fxN+cV+qnbc
	02uS1RsPHJMsm1Q7chzOtpBPSBtnYDlnE+yBqUg/1yuFVkeKrjJ+Z3XG7w9VIB1x1IscXj7WrYz
	MiuO129mY8nFoqq2SMvso487JkCr+FNqA7TwXVXkp8dFjgmDzGNZTzGtI6RJTVYB+BdHrYOsyOU
	MMuvm596pe0jBvfn5brDnNM/T2/6vJcViiP0SVmnSo08uT3Gm2KKjhfu7eBOc8XD/FsTGbUUyWv
	ve+1AqpbmrZbqgVwlztdZxpLixJaT+7N99ah83LTpkUoYEkhCPwI9rFqidoJDK9sHOo7oFdQ=
X-Google-Smtp-Source: AGHT+IGGyTuj032A+czYfiJGzgZFTU+QU9GpQ7Wur/1D12ZQihpWI9YHZ5riUKTK1/T04BXQG7d3VA==
X-Received: by 2002:a05:6214:19c4:b0:7ef:d35f:e1e3 with SMTP id 6a1803df08f44-88176770c25mr20829416d6.57.1762471539891;
        Thu, 06 Nov 2025 15:25:39 -0800 (PST)
Received: from [127.0.0.1] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88088b7addcsm18224696d6.32.2025.11.06.15.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 15:25:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5b7c8fabbb00cd37be00f828c48c2a238f06e60e.1762433792.git.asml.silence@gmail.com>
References: <5b7c8fabbb00cd37be00f828c48c2a238f06e60e.1762433792.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: use WRITE_ONCE for user shared
 memory
Message-Id: <176247153625.289461.14747272057136679645.b4-ty@kernel.dk>
Date: Thu, 06 Nov 2025 16:25:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 06 Nov 2025 12:58:19 +0000, Pavel Begunkov wrote:
> IORING_SETUP_NO_MMAP rings remain user accessible even before the ctx
> setup is finalised, so use WRITE_ONCE consistently when initialising
> rings.
> 
> 

Applied, thanks!

[1/1] io_uring: use WRITE_ONCE for user shared memory
      commit: 93e197e524b14d185d011813b72773a1a49d932d

Best regards,
-- 
Jens Axboe





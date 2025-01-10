Return-Path: <io-uring+bounces-5813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3172A09CC2
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 22:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6EFA188D417
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 21:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B84824B25F;
	Fri, 10 Jan 2025 21:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XeT/SPAH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510924B25D
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736542864; cv=none; b=jQfBMyW1HQBq8CCnwIuIkk2sqqYHbfrbpkMovgEWO4T6ez3KyMnH7mNnK2cm12yTinr1lVGZ/YrnTN8jgSBT4DeWModVmecI2C8Qu5jTXpO4FcOr/TvKS7Aaz0kKtnaxJ1eUh5V8gjhyHj49Zp+Xc/0ExRqsmnYfYqs6YPFhqmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736542864; c=relaxed/simple;
	bh=pvFbwyHAlywHXl72KmzFNduQ2TLqQ+XmAWdt3AKUK6w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T7LNS4nb3zUVj06A1jYwCB1ybe/YqT35oMWILp26U9sKXYU6b0gg0/WGtYOSRE1Ry1gf4GRSQHV+fLJesV+KTDpJX5B9nVDrJ79ZKbcC0ZJ82iSlncxux9zuEd/koOUWQVKOMd4kSVAQrGlUeaLekZp/z+OQnZ3TJ8Mm134DA8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XeT/SPAH; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-84f1ea04c64so127696939f.3
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 13:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736542860; x=1737147660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vX43EvcM+xp/7B/ohXjl27wdYlmUD7JPhiSY38g6F2A=;
        b=XeT/SPAH2n+UmFuutGFP/D7V10qELFjIWHe7c2RGIQCzyA1yKOqiiWwXJZSxSV8UFe
         pUrbUjJSihNIQ3jQbRPZbAbv2nbggqBsiYr83FAS2SFNLV6ykHpboc5Y4U3KekhRMALe
         PdOhpnmCHIQiMdP0F6iBW80eCh5Q3WT/uIcn+jO5TbE6oyThWGgS+euXZfU5SXIsdSJq
         RaAK5YqZGutfjvQtAWEewOQEJrv8Kr+1da1RD0nei8C8adZYSdEURHaGZpGsi97s3dnw
         TsT7gwgE5SkEkk218vUBdwyBWjgly76XDhmnfE9gesbY+x9Fsv2Bhh9MY1e4YjtLsfYZ
         TVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736542860; x=1737147660;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vX43EvcM+xp/7B/ohXjl27wdYlmUD7JPhiSY38g6F2A=;
        b=QFPXwKVWikv0CmRrU094qmhauWBmHiDlMbNed0yaAkX3lw4H1xbuxer96/l4RqMsxm
         BZBSyC8Ot4Lbc2Y+/2I6taDTdaKbTWRnpMC4tWB5IG/zU/4V32+NbBaGqHbhC+CooZMX
         aO2GvHpO91tXvOQbg3eWCUWxszzPcMQwHAOP3pYY8n8tcNq6HQRzGsEXiymLrurh+f0G
         3Cq0LtlAsiqrawY0b2co6XBVrZX3pbn5cEb3QP2plLkHsibDKfNLsKiY5+nuAsCT0l6X
         aHb8aFDYYiy1m1tVeey8GLvrdD1GhhqxLdwiMn0azHHmRvFFsw5kA9J+02DOY6dlO8/7
         WwZg==
X-Gm-Message-State: AOJu0Yw2yaRhAWmn5cgvPIDiO/WAMc7884w1Y0uCuxPvB9OJ4RJVj+if
	S/1sV8ly5KnG7GgVQt2y2ouzb9QBVO4IxyQlZsFSUDHGczG+aFK+19IW5aH1Xa8=
X-Gm-Gg: ASbGncvvQxdwHnLmhnZcmd7ubL81OToW/48x+/Z1qyw8FnLczmF9VjpSdwAzYSFPuzV
	setOSM6WQo7KEO9VxhVD9ikX39qQaFtSQ7/EjxmQNcDWEcdnGVa3WCkIJ5PYKC02ZbDrZFl8jkZ
	WCbZM8Tf2Tz9Dza3xj6tzfLSEEZKKTl9zAb+4tfEYYYxmNVaWtJmVFNY+yLVpBUHcZQhKMXU2Od
	rW+PcKLXwZzjPfT1L7k3F6ISM09QVMbGixnLZ/g2s8OjLGY
X-Google-Smtp-Source: AGHT+IEccjC1AYAGm7cksB2xFI4rTsENftQLQ+MZqPfqPAJV2278y/rySdDjpduUxRi1jb7s55EyxA==
X-Received: by 2002:a05:6602:400a:b0:835:3ffe:fe31 with SMTP id ca18e2360f4ac-84ce00a0987mr1171280839f.8.1736542860384;
        Fri, 10 Jan 2025 13:01:00 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b61510fsm1073174173.63.2025.01.10.13.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 13:00:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: lizetao <lizetao1@huawei.com>, 
 Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com>
References: <1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: don't touch sqd->thread off tw add
Message-Id: <173654285960.870565.9353820235118737791.b4-ty@kernel.dk>
Date: Fri, 10 Jan 2025 14:00:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 10 Jan 2025 20:36:45 +0000, Pavel Begunkov wrote:
> With IORING_SETUP_SQPOLL all requests are created by the SQPOLL task,
> which means that req->task should always match sqd->thread. Since
> accesses to sqd->thread should be separately protected, use req->task
> in io_req_normal_work_add() instead.
> 
> Note, in the eyes of io_req_normal_work_add(), the SQPOLL task struct
> is always pinned and alive, and sqd->thread can either be the task or
> NULL. It's only problematic if the compiler decides to reload the value
> after the null check, which is not so likely.
> 
> [...]

Applied, thanks!

[1/1] io_uring: don't touch sqd->thread off tw add
      commit: bd2703b42decebdcddf76e277ba76b4c4a142d73

Best regards,
-- 
Jens Axboe





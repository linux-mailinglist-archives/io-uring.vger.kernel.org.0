Return-Path: <io-uring+bounces-10457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A179C42D65
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 14:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE0A188CA64
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 13:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF2E215F7D;
	Sat,  8 Nov 2025 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GRpnoNfY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003501DA0E1
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762609217; cv=none; b=PLKwsq4J9/OLqqZuMt6SN6TBt10tfrKGnrLNKKqnxq4E7tJgN2ptBhfYfGjdM0ksHwjLO/avVUKRSKODyquVl4Ohdfwdbgx9DaQevAl3EJYK3IYK5DvHS00tN/iVqTDdi4BbkPMcC/lTqRsIngT9iYdaAiHR+qemMmvMDuZbzQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762609217; c=relaxed/simple;
	bh=J/oaoHydRfVyCYQc2A2v32IR90dPMmhCvGOFpN2jGYI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aGRcHtSY5F1mQetflnziHMphpPZpjlv1FYbH0u4OVBWiQK7snYQVAyecUzPCDTU6gxlBN4L9zpkMYia6jpSVkwocElTKP8N5ZGFxgK9MHEqVe3LiGQL3M73r1E9md3FwWMIitMy53o0tBkfecW+MLx9izmVVvkMeH7crKc8WI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GRpnoNfY; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-882360ca0e2so8159856d6.0
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 05:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762609215; x=1763214015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DafqidA7/7+oFb78vkkjycrUDd/aqV+55S7wTivPUo=;
        b=GRpnoNfYS6HrUHi9tBETFFEda0ds2FbPF06gJqUKO3xbNP/vXagAWztKH07VYGBHCn
         ZHaR64+8K5Q6oe0J7lQxwZ/dmOjH9br/ipVBbURg9Myf/pRSmilUjJsJBi2fV3780SkJ
         sNn6BN2V9o3uSIraZ/zmOa+pq4YZw0cycXayZsPFckCfdzkVUAKIxBjUsF+5viTgLxHx
         JCshKUDU6tqmA3AuctzLACFuZP3KPKqc5/exP96ro7xA9clKq6PXP87S88nwer01U9yu
         uEbh7uUoR+TLTTSExu/aV3EdMrzWC31LH3Ou9yrbgR7OKoMCUwIJemiLerSu6bh9tsSx
         2Bqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762609215; x=1763214015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/DafqidA7/7+oFb78vkkjycrUDd/aqV+55S7wTivPUo=;
        b=GcPbdU4hQp79IRT2n2lqtWIMDe9gdPniEQiEHC6B+yU5ZrZUu0TOVEX+MQ/U4R3jSq
         E0xr8qJHCs4IhsUUm0J/gCoMIbkAiiLB6uviV4epE8AS2HxzOIqd25DGicghUWHLj3Gt
         lqy5johxBhsdU0+E7shYJGEs+xmfbZob5McC2kEKVXYvl9HbAy5Fhxf8sFCG4aAIpr2O
         g5O5pucsyqj0TRYOM4tqYo+ILZyKhLc3b65eoFGBdTgu3alAF22elHymR2H2s0drpFhS
         LgD4Q5WoijNZ5j153+gogJ2OYN+0jAi5Di2Gg/zw+ZYtJjQnrKKwp4N3kyTNtAx1Kc09
         9xSA==
X-Gm-Message-State: AOJu0YzQA8YWc1VczuhtwIOn5jEaEln0I48NS+A4v2hcwLnbFoo93lbK
	6RSKd1O0sv/uWfZgRpAct/mwhBjPu0Oxcdvrb08PFBTUMEOVeWrIBhmAjgG2KS8AW226Q4NZHHC
	cuTJi
X-Gm-Gg: ASbGncv0W4mMyFkhIbIMfVA/Z6fjZkL3Ejps4aBzVRCVEDFSs+5j2stGwduWrcrhdgI
	TP8tRBKCjkzcucTYL1hjuUJPHQUvVZJ4RMn2+clG+H85QXUDZlVjnc7d6jYUS/59kXLX/urtbzu
	eouwmRQJblng5JIKbDR3Eo7IihiMY7ML/Um1BJUA0aGahrgJPGK4VND4R/sccRISTx4k2VXY7JZ
	q0M0kGGF8uM+BLgyyE+cpPazhBjYaTR1Adm9SWWpZQ43c+vLPIYNn7FWkwe65Gt5Fymc0eJPjan
	+5wQSS5RqpNPwp/coIHOxKRUw+Qjh1RQYGe3GsznldGHRh1bGCFnGU22sC+9RVNp3cq/vxsT7ed
	x36ligH3Gj8SqFTtZRdKwoEcW+xaQrPuKKFHsC8v5avjZuRVPoRJQMbJZX4hMRX/vc0zfr3w=
X-Google-Smtp-Source: AGHT+IEhm1Ln+xXyl7KXzfxPxsItBaalZpt5dEp6ySB98KPQRR+gUt+Pga74ZVPNAqeiCA9s5AW6aA==
X-Received: by 2002:a05:6214:402:b0:882:33ac:824f with SMTP id 6a1803df08f44-8823872a410mr34063366d6.53.1762609214865;
        Sat, 08 Nov 2025 05:40:14 -0800 (PST)
Received: from [127.0.0.1] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238b290eesm14808676d6.34.2025.11.08.05.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 05:40:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <669d1e9701194fe86c69d12bb629b21242adaec7.1762432299.git.asml.silence@gmail.com>
References: <669d1e9701194fe86c69d12bb629b21242adaec7.1762432299.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/query: buffer size calculations with a
 union
Message-Id: <176260921306.52069.7107119231471996539.b4-ty@kernel.dk>
Date: Sat, 08 Nov 2025 06:40:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 06 Nov 2025 12:31:56 +0000, Pavel Begunkov wrote:
> Instead of having an array of a calculated size as a buffer, put all
> query uapi structures into a union and pass that around. That way
> everything is well typed, and the compiler will prevent opcode handling
> using a structure not accounted into the buffer size.
> 
> 

Applied, thanks!

[1/1] io_uring/query: buffer size calculations with a union
      commit: 20c1da7ee5cb181fd67488c91856233d9c41d3c6

Best regards,
-- 
Jens Axboe





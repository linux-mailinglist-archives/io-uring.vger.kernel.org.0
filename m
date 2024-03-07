Return-Path: <io-uring+bounces-855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF67875651
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 19:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39D4928166B
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 18:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE49F12EBE1;
	Thu,  7 Mar 2024 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NDhWQ0ui"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5DD12FF9D
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709837297; cv=none; b=e54wt25aVi1u+lxGVB+jnSQT8JNozSchy9zlKGyqQ80OQWNS7EdTyi616oIvTOlPQ/VQl5zk5Rx3+lGkN8AQ+hGnzbO+OVVyt87IuIQfj/ny1uvZfOy655IRBgcscb0y9iznRhrSowMW4hSZGLIrczGIU5yGeCcusbTgdpaTQ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709837297; c=relaxed/simple;
	bh=0Luay74zJqkyd85M8MHS2dBebrRVrQUQU4k1LBxWEMw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F9Ezd8IQ7FlDMXuOPOXwqUHT0pWqiYXNe+xCCevSAz7oGNnkNA7M9ufbBAotPoYGyCXx0IwBlzi3TRQXfoNvLXB0/dpUTcMLkXotUcFTc4okNeokr2cvTXz+qQ9GNvMr7/Db3xLFLD0zzwyJpA8JC7UMIwp2A6eE1dCcuyTtfQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NDhWQ0ui; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-365c0dfc769so1422155ab.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 10:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709837293; x=1710442093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+OY3LC65T+lGHqqw2uslj05kUY5VaPnzv/z4A0X5L34=;
        b=NDhWQ0uiXWBMXTMj5Nf7GFRZpDQR6Gpp7A+4/FPKZOx1MCUfp2Za63/8veEK7A7HiX
         E6fjAfIgwFUInl2oBHYruSoeo6vQi4UlZbUhUSmPg9KedyonVoZcZr54RRn0LmxrOt/Q
         Ji2B5bQA2WWZwZGgBqzRKFAseFj969QYP2vD+T3+ldzvsi5ucO+XDmWk6XgQgvXe6a6j
         ULtXKANgFfT1nOjYOYm9KxwlcFJE+05hdG6r1yvzPwYi0gM7AUyhHE1zMFNBqpnSytkW
         ULwIy7qJXx1UVriOXkMp+JWEWRbW1ElVHeEgWUwYVZSJZwE6zbnIUgMVgMYx5COPIxyb
         vDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709837293; x=1710442093;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+OY3LC65T+lGHqqw2uslj05kUY5VaPnzv/z4A0X5L34=;
        b=eArU3NVmthMO9ytszyZ01frlxp2qwzA48d3Q62ThMbSv6WcYXbf3v0m7Nn5Uj2+Wb8
         54ga/q72QL6B4oIlimnn/JAI8YYZ2JvDdqgjVSPb/0+jZzH40qGEKzHkT+BkrsDzqSJ/
         623UGSX/EAbkJYxymHr5B/oFRnRT8SOLyJUTh3OWl+OkWmVUhxMMsTxBrYvbIQKxQ7EJ
         GWzU5lDFQ0u/RJhnD6VU520QfY0f/QUE3A7+PgU3WGfpRFUHz84K97np0qpGPyKC3RGD
         QcqT2ZsW3/LQJehRm7ZhfxJ9G9NA3DY0DDmBvPqwN7pw+5P59dYBo8qocUADaSIvJkLn
         KgJQ==
X-Gm-Message-State: AOJu0Yw9jF4d7UyEU/KZju9Gq9rbsSRV877wJjyWHFaQezrQnAw+U8PZ
	ckB/SY/ClzmUjmzehPSB7B8LjfCJWGNVRdkzUd9w9KHeNMuQQOOOlVmE+HwETpc0VObA6T5cOji
	/
X-Google-Smtp-Source: AGHT+IG4TAOT5KrikYoMclr7RIaxi7uc6grgWueKNWko6uiK1FjNDf7rzgpz09W92lDLrALDqLHp+g==
X-Received: by 2002:a6b:f306:0:b0:7c8:7d0e:f240 with SMTP id m6-20020a6bf306000000b007c87d0ef240mr3089854ioh.1.1709837293393;
        Thu, 07 Mar 2024 10:48:13 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a8-20020a02ac08000000b004769bc4c986sm684001jao.32.2024.03.07.10.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 10:48:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <455cc49e38cf32026fa1b49670be8c162c2cb583.1709834755.git.asml.silence@gmail.com>
References: <455cc49e38cf32026fa1b49670be8c162c2cb583.1709834755.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix io_queue_proc modifying req->flags
Message-Id: <170983729263.487614.1608581285097755405.b4-ty@kernel.dk>
Date: Thu, 07 Mar 2024 11:48:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 07 Mar 2024 18:06:32 +0000, Pavel Begunkov wrote:
> With multiple poll entries __io_queue_proc() might be running in
> parallel with poll handlers and possibly task_work, we should not be
> carelessly modifying req->flags there. io_poll_double_prepare() handles
> a similar case with locking but it's much easier to move it into
> __io_arm_poll_handler().
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix io_queue_proc modifying req->flags
      commit: 1a8ec63b2b6c91caec87d4e132b1f71b5df342be

Best regards,
-- 
Jens Axboe





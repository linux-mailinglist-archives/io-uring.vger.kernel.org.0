Return-Path: <io-uring+bounces-1815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D9A8BEC6C
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 21:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F13441C24104
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 19:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D662C16D9DF;
	Tue,  7 May 2024 19:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ITl7Ivsl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2114D2BE
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715109459; cv=none; b=SjtIT4+gzuWjRoQnXrDuPX5XzuAqlBponwue0bMKWaKWRl4YDt51CE4rQcbIThDv8LNZ2ZklH/mEAGs7RzioHggRt+EVO/KSULlz+h4hK6FthNqTLbrNDmCd4sYRPtg+eQlkovvy6Kow6A0/e2DUn1QS6BN57RUrS/WVkbqtBLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715109459; c=relaxed/simple;
	bh=lFe6PLJLyMEdG0qUciQpwpKkHPkogNZMbmqjjed+jG0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mOSlFFzAxixh6+b97MageAVxevJDYE3NhgdfWIIn+8IrJDz8XqZxbVPpOXSC7iDPMA8678Ot5TEIiDoigEaLxUHzbKCGxZGUeHzNjDiFFec7t2ULP382gOGxigxRm4Tmc2oZgxTlVfl/NJExIYVUKu/ydl7KLgF1OnJfg0312as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ITl7Ivsl; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5f77640a4dcso184165a12.3
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 12:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715109456; x=1715714256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJ05ivw5+rga7TzuAAcMhvPRoPZ5bNll4/XJScG7k8Q=;
        b=ITl7Ivsl7q+QAotXe5SCjBIwgmdGhb/2EbdkzwOROHjp+w9McG/c9Zd0BRfd8MUFGg
         tY0wpfAU3BtHZE4qCL+C+ZjgFCxDSN9DASuK/VprTGtc8ixqKuXvcEPr3y6n/rxC6fxB
         l5YDr3v4bIGgyoqdyWFp1xRa2PLxwHiK7tUp4i85jgJhjMtWOX+r3qn/2MDRxt5RrSGe
         dlqGjs+aDX/SKcOqm6ee2EXLDH9IQAURut2DRKf4TyyLNy2mlcNeApcWLIlPAOsoHdsd
         2nWZGDnxhuP6p0LdINd4yUxvDjULjnrlIaSbnrUlcy3+3tciQKj9/Aeenb884xES06Fy
         iFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715109456; x=1715714256;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJ05ivw5+rga7TzuAAcMhvPRoPZ5bNll4/XJScG7k8Q=;
        b=Emg9EYRUKnwcWf8UuG74A+9HH8XT14nj6mlYuie42PiTQomhoHHnF/zOiDlPVNs7G6
         ZwwX9WrlOHLkz8xeiMO12nUbv1/EIWs4gcRdLTbbTv41PvB1c7D/+EaSiFNLnE+07OwT
         SmstVHrSV3yGsT4g5Szi92JnmuOItYCD8bJ0qkTE4SWNviJV3VioYmG7qG1FQDZ1uDor
         vY+i4hD3WBpc5FV8FQk7Pmr5gJ7KI9CuE3dRqCfbeAmsM78+JSsU6TEHKzhOkhq6kohu
         saUkTNNaLL4OJABt/tnT1f1Jv5w8svAkrQEocUWNMUeXVniRJLp4BR5WN0DXRONhpC1J
         SSUw==
X-Forwarded-Encrypted: i=1; AJvYcCVCE5i82eQe1qMogs1QS0X9Pz8fqS7QG8ygOAIQUICk7vG2+5Oq9SGOAYnHea7ie/gCG9LWmOgKzb4SOk6ZzJ5m5J2nj6/zHk4=
X-Gm-Message-State: AOJu0YzjudXyVTkTWufYBLMEOyGARDFYWGssICenlYDXUyT1RfL6uqwd
	e6WE0G4kNSJFE6WKXvVYMMBisi1wZdcrXvyFgey4q9Gu+jMOwmZ3kYs2sMsVe8pp3CvWx4dG+xF
	b
X-Google-Smtp-Source: AGHT+IHEFI6jOT0orjmfXNCVZ+/GA9aPYVnzkkhuI46G8zz1yX6OrIm0AVkoHDAyOF5AvXkFW+xmXg==
X-Received: by 2002:a05:6a21:3392:b0:1af:acda:979d with SMTP id adf61e73a8af0-1afc8d516femr758154637.1.1715109456056;
        Tue, 07 May 2024 12:17:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id z68-20020a636547000000b005fd74e632f0sm10126797pgb.38.2024.05.07.12.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 12:17:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Breno Leitao <leitao@debian.org>
Cc: christophe.jaillet@wanadoo.fr, paulmck@kernel.org, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240507170002.2269003-1-leitao@debian.org>
References: <20240507170002.2269003-1-leitao@debian.org>
Subject: Re: [PATCH v3] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
Message-Id: <171510945496.45805.5070549169318056486.b4-ty@kernel.dk>
Date: Tue, 07 May 2024 13:17:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 07 May 2024 10:00:01 -0700, Breno Leitao wrote:
> Utilize set_bit() and test_bit() on worker->flags within io_uring/io-wq
> to address potential data races.
> 
> The structure io_worker->flags may be accessed through various data
> paths, leading to concurrency issues. When KCSAN is enabled, it reveals
> data races occurring in io_worker_handle_work and
> io_wq_activate_free_worker functions.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: Use set_bit() and test_bit() at worker->flags
      commit: 8a565304927fbd28c9f028c492b5c1714002cbab

Best regards,
-- 
Jens Axboe





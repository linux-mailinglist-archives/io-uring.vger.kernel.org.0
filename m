Return-Path: <io-uring+bounces-7863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B06AAC6EA
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67A154C3A05
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 13:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41D828152D;
	Tue,  6 May 2025 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I4exoWp1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F22280319
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539318; cv=none; b=N3P7taRn40mqL2Z7HgYC8wwh3LEbwQkjSlLncWYNqz8TNTU0UJffYcooYTDmAssiP0LTfIQTjqvjGBDu+d5uyM4ZCQSL7H9xRcruP3cf1v/Xwil1+9nVXeaFGmhuju1Dgr2wM3hlklebwyWYevI6/o27D7+k5AaeXaEQsViDG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539318; c=relaxed/simple;
	bh=yPMp6BTborMMB6gIxg1F6UFsVCSFyVGtbkXVzRTOX0k=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mk43XwNraUtmcssK1M+2vGPXEzMbGaMRHdsjm4/b30YS8cihT19gGdR6OWu9+sy5P8Jswh0pqL4wxhuSjvgooZ2B+6Wh6FDd92wawIwXRMq6cu8cow8Q3WTOTB3MmbWQDJAmaejT9iJN7nxFvJDu9dx/a2ypmhz7YB/9n06VIpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I4exoWp1; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85dac9729c3so583014439f.2
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 06:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746539316; x=1747144116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99iIn8pVW1DI1nvlxYJCgLCMsqipr6UwM3hMn0Zizfg=;
        b=I4exoWp1YpRjV/sOOt+KT3Jg+RJu9pGdaPDPruIH1dYorK22RK6Jc3EcejcSIUAb2f
         gQm7NKLgYuT8nWrXW2tCfpNd/IpOsO65IiKJh2swWr6+k8bXWRMsd33HFWaHtc2TUZFR
         5KViN/vaL6/t4qFEBYa9AihZovqhfcYuYOxjGZvaFS0yp484oq7Pqyt8dxN9XEi3ea8u
         cwgQ6ihZxxnOwIgLHp80DIkZ/PzzVZm/R89fYAFfktX7VKKge2Qe2lH4VfBCfVbHVx0F
         mWG09Ljgm6zmG0+PBLz9fSNujjVMzbIvkgGnOnZzapr4pnRzRJfBVd9+nEv9AdsLTaV/
         3gTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539316; x=1747144116;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99iIn8pVW1DI1nvlxYJCgLCMsqipr6UwM3hMn0Zizfg=;
        b=oYLxlBjoqcX3aShx9lCmQe839GElm4uDaqFC9yrAYa6XqT0zi4b6wVHTBlsaH2zMZY
         q0zAJjx6emcd0D5WqBljtrH42nNvCMAT17Wby/k5WvirVjVXXY55l7eKmCzP7A5wo5LO
         WrjszVePgioOyFbz7v/KSJ0ivNgyT00PCEqYfAkT8Q+M60SbMsyuzq204wYZs0a/VbXr
         NSuZ3STsS+u0PDcM44vc9N7lyO0ORGuiPsS6MHjHDnjW8pdYTwFmYWCbNdFtOL0g8XRE
         TYhdXsj4u22DdelikW9HR8vpkWZgQFG9wiA/3Vor8y7PcCJrtWw3oV781Y8JDEDd/mVH
         7n9A==
X-Gm-Message-State: AOJu0Yxv9QamRuJQwuKdVTGjRHQJidoA2Qk8VeUyjN6eetgdyFlXoPj5
	d+isqER41GsINBwvo+NssWSnhBeuKUZgn4M3FMcdeWW399gME6GeUZBzGG/e7tuBrvl5BKcigl8
	n
X-Gm-Gg: ASbGncsLEKdWhC+uaQwfc/UUoqYA1/lSo1uMQyIfsGSHkcF6kxpVdl0JU8kK+IYmd33
	KKYMpk03bs0GcyXvMPxOANYSx4bbTfszHFDcfhE0arG8w/kHogNlIPAnkR0qy1nHE/PDcx4vkSl
	m98siZOnWFPHLBUlwJWV+mpF4T2uIEDDFXxln4VaNgQt1bxDsSjOs6QAB85WpzAj9x6UnRgabmQ
	ejv4OSoRqb3ltE83jWXX/zI6oiaKf1b04zxCh0tvLh5IKYAvNk3rSoIGjv6cREzqHmE6Xc1b4Mk
	kjQ0mQ3iaVrmkpirPmykNNOdT0reoQsaQi/PqhZ2Og==
X-Google-Smtp-Source: AGHT+IFs/naK2985yQ//mEnT4FZRd8HuHQJQaCcPPGuyKaqs98NOkiwNVPiT5C5qofMIsT/7BVUqqQ==
X-Received: by 2002:a05:6e02:2183:b0:3d9:2fbe:2bb1 with SMTP id e9e14a558f8ab-3da6ce607c8mr36281335ab.12.1746539315986;
        Tue, 06 May 2025 06:48:35 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f58be3sm25930915ab.58.2025.05.06.06.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 06:48:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bb73fb42baf825edb39344365aff48cdfdd4c692.1746533789.git.asml.silence@gmail.com>
References: <bb73fb42baf825edb39344365aff48cdfdd4c692.1746533789.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: move io_req_put_rsrc_nodes()
Message-Id: <174653931451.1466231.11286677519959786849.b4-ty@kernel.dk>
Date: Tue, 06 May 2025 07:48:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 06 May 2025 13:31:16 +0100, Pavel Begunkov wrote:
> It'd be nice to hide details of how rsrc nodes are used by a request
> from rsrc.c, specifically which request fields store them, and what bits
> are signifying if there is a node in a request. It rather belong to
> generic request handling, so move the helper to io_uring.c. While doing
> so remove clearing of ->buf_node as it's controlled by REQ_F_BUF_NODE
> and doesn't require zeroing.
> 
> [...]

Applied, thanks!

[1/1] io_uring: move io_req_put_rsrc_nodes()
      commit: 9c4dfa5b0c0256661a6a9d26729ce01e725918c4

Best regards,
-- 
Jens Axboe





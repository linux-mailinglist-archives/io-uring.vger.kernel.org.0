Return-Path: <io-uring+bounces-994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3FB87D6CE
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 863CD1C20D2A
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE6E5A0E5;
	Fri, 15 Mar 2024 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oxduklnU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879B65786D
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543205; cv=none; b=ky9/xTJsu0S0B2Zep+6GZMZL+gsidGkW+fHpkmpUVQG/nAHuMks7gOvAvgxS7qHT+iYEMWP+zGQxHr6C3DQYBTPJMHZcOCunsirwxUB5BQbsZ9a4exUu87uFHKJhGS4vj5Rcd9ntUnL8E2MKnoaRhVTZieY08uPEcyumG3rUv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543205; c=relaxed/simple;
	bh=KukBDF47a2o9oLJYgrlrmtHZXua30WLdz55X9f1BMeU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SD1/1l5zxeCjv1/1T5j+hLd+Nd6/qaG9ASUT6mbCFMXNqc7DY49SZi3EvdPMsrRrcQfyfjC0xRIFPRMSk6BI/q1seqaIpnOotQfo6bFnd7NphxK/QHLGbnoc7MCOQ/bEXd64pub7kYyYoYVP4yiOL2Q7rm29XvOFnij5mWVC1y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oxduklnU; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e694337fffso608849b3a.1
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 15:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710543203; x=1711148003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=En6z+lg+gwktvkY6m+MElKf4+jRysCg/5WE78tzLxP0=;
        b=oxduklnU83OX8FuMUd1/ArTXuqU0Jw2f2V75UnT9sbgHs1qNm1HFid5KbZ4WqnaYN1
         wNNsNyfbpQi3kLJGU1d8R4SxOn02Wh8LC8BK62Hsy/YPeLQThgqXc31fXw6bpGD1xYC8
         YROcXJv1QrSqpIFjcl6UHE3v1GdcY2iDlup36ikWKkikAFyfGUXMcDZp1Dtm4eqU5L+N
         Qw98ZFHp8LXYpZBNOJmCvmB/fmT7P40apZ6NR0Y4ZtmU8tFtyu5cQ9Ij18449hDnSrA5
         5yZByWuYmlQZblEMbFiFw3AwDK/L556UJ08KqbK7OJG0NoUmr9k4VALvXuISYRTDt4iz
         7azQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543203; x=1711148003;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=En6z+lg+gwktvkY6m+MElKf4+jRysCg/5WE78tzLxP0=;
        b=VDVh1q8sJwEw1mQ4w8qH3WeCB4CEF/bZdQ28RQ7wqAgYy9Fv0bZrGWj4TdLWS3ZP17
         bap/bvTKWm+x746CCiFdI/Ir0iWjkhFiWkmErirG/7dDWiwY4CqMeA7FQfDXlEN86MYg
         RPegzeDu8aNtVrroDU4njmoW4tJkmdG16XXcOPWlU1dJuuINJXYdmvVdinmupszct/GV
         qm9k5KhH6si2rmgk6kfDtHYNmLpSm4zQoIlBvzsEEONVhwuwTtmdhlZ/D8Ryyn/O9rBG
         NMLig6qum7np9TmeUrCZ2w7oS8zsOCr9h71ZJS8Rn/bL0Lo9uql319mjKYE2y3LIE/ch
         +3MA==
X-Gm-Message-State: AOJu0Ywd6rSBZ8DQsWNzVBKLp5GIupUPkGbdagQcp7eByT8PbUiRWqKu
	K9wanXvEWvmaLwmzvs+ddRl09Ky6C3P8qjWb5CDOrt+Hx6iZp9k7n4WMGzpp27o=
X-Google-Smtp-Source: AGHT+IFsZXgseueBAmDMJVF+oQwU1cC65fn42Y9GYzFcYhYiZnAwPnhfGYJqqNY+B2UZcJ6MWC/ARw==
X-Received: by 2002:a17:902:ce91:b0:1dc:df03:ad86 with SMTP id f17-20020a170902ce9100b001dcdf03ad86mr4997005plg.2.1710543202831;
        Fri, 15 Mar 2024 15:53:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b001ddde0fc02csm4443948plg.129.2024.03.15.15.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 15:53:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, 
 Ming Lei <ming.lei@redhat.com>
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-Id: <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
Date: Fri, 15 Mar 2024 16:53:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> Patch 1 is a fix.
> 
> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> misundertsandings of the flags and of the tw state. It'd be great to have
> even without even w/o the rest.
> 
> 8-11 mandate ctx locking for task_work and finally removes the CQE
> caches, instead we post directly into the CQ. Note that the cache is
> used by multishot auxiliary completions.
> 
> [...]

Applied, thanks!

[02/11] io_uring/cmd: kill one issue_flags to tw conversion
        commit: 31ab0342cf6434e1e2879d12f0526830ce97365d
[03/11] io_uring/cmd: fix tw <-> issue_flags conversion
        commit: b48f3e29b89055894b3f50c657658c325b5b49fd
[04/11] io_uring/cmd: introduce io_uring_cmd_complete
        commit: c5b4c92ca69215c0af17e4e9d8c84c8942f3257d
[05/11] ublk: don't hard code IO_URING_F_UNLOCKED
        commit: c54cfb81fe1774231fca952eff928389bfc3b2e3
[06/11] nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
        commit: 800a90681f3c3383660a8e3e2d279e0f056afaee
[07/11] io_uring/rw: avoid punting to io-wq directly
        commit: 56d565d54373c17b7620fc605c899c41968e48d0
[08/11] io_uring: force tw ctx locking
        commit: f087cdd065af0418ffc8a9ed39eadc93347efdd5
[09/11] io_uring: remove struct io_tw_state::locked
        commit: 339f8d66e996ec52b47221448ff4b3534cc9a58d
[10/11] io_uring: refactor io_fill_cqe_req_aux
        commit: 7b31c3964b769a6a16c4e414baa8094b441e498e
[11/11] io_uring: get rid of intermediate aux cqe caches
        commit: 5a475a1f47412a44ed184aac04b9ff0aeaa31d65

Best regards,
-- 
Jens Axboe





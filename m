Return-Path: <io-uring+bounces-10604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8956C57FA7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 15:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A861F3B3477
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 14:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAB519CD1B;
	Thu, 13 Nov 2025 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="z3ookapM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE529B795
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763044092; cv=none; b=mZRn3IZsljfsXOf/41WdpcHdZlXHoOPUwXPQS4kfwr59iFr2cvzw4ziQ4FivZiCefLaMIvmA2p8LeDZp60/JjjanuOytUNf+SdJhEZQ5jaMaZVZ67mrfJRWeyPmiC6JfZDJ9lkr35iaLD91888c4X1ElhzGQv7zCnL0O9nttcI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763044092; c=relaxed/simple;
	bh=n59YPYP1jBUeAsS5/86kj6b/5FsUcIzXpjXidXExMm8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pNzJIqxiY8Fd5XnG/y6EJUaeKkqjWxzxsyhgT6//GjrQ44bqZuwhlhc6zaoTFn6qxZhpRli3u5DPGOf27PdGFydNi66q7eJPkZnjDfkNLAX+UaQXDD+H12CN+frrNG4czapE+7Pv3YDQ9vIVHIMRURkp8tEwe+2pTDAtNzeAAzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=z3ookapM; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-43323851d03so3429675ab.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 06:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763044087; x=1763648887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CYekBu5POda4r8R8/zPUVaYHe6CbJSKAhujHtUQkznk=;
        b=z3ookapMaMXUpSARIdry+nRUxkM+lsN3porM1QhH5ZH8n60EdZXOiosEvnYxmaekP2
         8XCqkVZ4J7d+x9zaanEfshOYNsyO7NLL+7cHsWTv/bY6uSSaJNT7h0DsojxR+4+1nkQT
         bCtOZe9ju+hPOyl6bZEHQ2p+d3P37TmNgNDZHFLANxJ7MgycSozS4rPY0LzhxkKl8sbG
         VAYP2JVL1R/HPCMzO5j65ckgtu7x5jJS1ZTDHmPmv+LZ3tW2PInZ+ba00QQYnUfysx/D
         U0MSbs1OOghWetf8/AIdkDLdC517bUmHDeInG/cca7nxDxFLJvOsLpGfkYKi5NGhT9F9
         zVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763044087; x=1763648887;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CYekBu5POda4r8R8/zPUVaYHe6CbJSKAhujHtUQkznk=;
        b=dy6FA3ciIT7EfQahrKsQbxsuAN6tDAwn56SmAEu4sr5sylVGs/TwjD0tjcMmVn2zx6
         +onHwrskcTQ+EGk2xjkk/OHGRjcOYdY4H0AzyP/cH7TaxY/ULmQKu69EUz/SnQS5hCpY
         /NSO7Kqmbm8jTQESmFTwyIEIiglIdhtbDqqM25NsFY0qPOOqkzbde+3Brkde7jvTQKjl
         lxTGaleTi60dt1no0L8WA5Ytlfp4r7uP5HoSDeoGg5+raCpHGuzpLI24WWpOfnvYDsHA
         WgVRtcJGSiqmTeHIyKv5LpkVRJMClQeUYAGJmP1PUd53lmMO865r08e61y5D5AGaniLo
         /ISQ==
X-Gm-Message-State: AOJu0YyzvTnaeizh20QRQOOVYSYHzgVO1ySiTDQNIHMVZC+JTsm1X2kv
	M0bGYVQVgKbkqnqcZdMKueUtuoa+SJ+GfUx+oXdroPuDaVaXqn+CuiP6hDRdQ1MZUKmkBUxR7Cg
	Cr+Qe
X-Gm-Gg: ASbGnctHhMeLtEOZgAWxsnNmxX3XiUGYAureCMGW18m3RXgO78BwXpi79R6+lSF5soO
	XUZTzyOnyMkS8jf3kyXSZKYemAd9Sy6Jo1op4FuH1X723VLuX5DBVJ6pbTjq1bPq3cmVeoUDk9f
	DjiL/WIx0qlLYEaPMiILxaplkESri8K11naSoexRE62pwbxO7O+ZspaDfpYcYmAQmfpIF2tmipV
	MP33EqODRHPRcY9pAtnhhTpcI0A5Ms/kebf7gjg5dYkTAxssihezPu9ySg5HU5NPPJtJT9kt32q
	+BAnW0Iv1Yl6LXaeSCzhqGC6HMypc4Mtx1c3U3p/0KBEjdCkjYL3ngtMGwdT58gFtzz20Ty3awp
	a2+nEqAZL4q0b/iJ15frq7GKmKHFTvovsMwbg60lL6jtn4Su01JnmJn/KZIi1/6XJndMiv0U9h+
	zeCWQ=
X-Google-Smtp-Source: AGHT+IGlH90NnJrb77oQid5TwzFXfZDnjKb57lLY53rG8CS4VrSgNt9ER40uzj2ynelR3J1hRYdNEA==
X-Received: by 2002:a05:6e02:198e:b0:433:283c:ba5 with SMTP id e9e14a558f8ab-43473d6b892mr84034605ab.18.1763044087657;
        Thu, 13 Nov 2025 06:28:07 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd34f25bsm740174173.58.2025.11.13.06.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 06:28:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] further ring init cleanups
Message-Id: <176304408673.118919.14554820634187942302.b4-ty@kernel.dk>
Date: Thu, 13 Nov 2025 07:28:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 12 Nov 2025 12:45:52 +0000, Pavel Begunkov wrote:
> There are several goals for this patch set. It deduplicates ring size and
> offset calculations between ring setup and resizing. It moves most of
> verification earlier before any allocations, which usually means simpler
> error handling. And it keeps the logic localised instead of spreading it
> across the file.
> 
> Pavel Begunkov (7):
>   io_uring: refactor rings_size nosqarray handling
>   io_uring: use size_add helpers for ring offsets
>   io_uring: convert params to pointer in ring reisze
>   io_uring: introduce struct io_ctx_config
>   io_uring: keep ring laoyut in a structure
>   io_uring: pre-calculate scq layout
>   io_uring: move cq/sq user offset init around
> 
> [...]

Applied, thanks!

[1/7] io_uring: refactor rings_size nosqarray handling
      commit: e279bb4b4c4d012808fb21ff41183a2e76c26679
[2/7] io_uring: use size_add helpers for ring offsets
      commit: 94cd832916521d8d51b25b40691354c24831c655
[3/7] io_uring: convert params to pointer in ring reisze
      commit: 929dbbb699110c9377da721ed7b44a660bb4ee01
[4/7] io_uring: introduce struct io_ctx_config
      commit: 0f4b537363cb66c78e97bb58c26986af62856356
[5/7] io_uring: keep ring laoyut in a structure
      commit: 001b76b7e755767d847e9aebf1fd6e525f1e58c8
[6/7] io_uring: pre-calculate scq layout
      commit: eb76ff6a6829a9a54a385804cc9dbe4460f156d6
[7/7] io_uring: move cq/sq user offset init around
      commit: d741c6255524f0691aea53381219fadcd2b38408

Best regards,
-- 
Jens Axboe





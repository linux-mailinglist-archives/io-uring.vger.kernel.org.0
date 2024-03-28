Return-Path: <io-uring+bounces-1305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B85B890E2E
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95C881F23B9C
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C634F894;
	Thu, 28 Mar 2024 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="whoze/eT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717BB27446
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667123; cv=none; b=VFgfEgOGlLcJcTVoekVOToX4tVT2ZTTwQtSxGjPVEk8uuIyX908FLVrjmdpN7n+O1amPzIirYWhEiHpsbRaWtOBC1IUU+MYiSumFFqx1/ZJNDBwLet1pDosrhWuQZwRon2hppfNsXrVff850CCKuQxscXGI90qqTgc9VFAHWUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667123; c=relaxed/simple;
	bh=z3tf46ej8qpBQPDevbtFzGy9O5nWOl/MaSu7nJvWxGA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U8MQWTY4cJu2EhM1nbH/k1q1MQk8iXn+Zh77p8B3jPUkp+GA816zCFPhRgjibl5QMd2dqUrouTSsIvpH7gcLBDG3oaGhfHmJu80mqslBSq0CyNxQxFwgUndEi3bdNRMcd+Ahosboe1gQCyNFctEMk3Dn8hh0i9YI2WhM6JJ5Wrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=whoze/eT; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29df844539bso403133a91.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667122; x=1712271922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3aFzydSyExlB9BmbA34QemVRJ/ZXxJRv4umeOt6fqw=;
        b=whoze/eTuQ7WCfQ2KvL3NhiXL9NdmAEclm+rcZS0cncIpOf/Vikox6zms2HxC9Ae2N
         4cWzjapfm+Ag5yRjl++DCupMT9G0IjnCYZ3nNC+kJfMkiLbw5EVML96+SqYgGbQPf/VS
         bAegt8fbYFAnyvUsUkMvGFyBvyRQ5XH1TQCwZ8wp/hMoUEc+ou+Jdrl/U/B/9hbIN9Pz
         ca5G59PaLbaPt/Ea3p2x0ca8jA0mNfAZEvQ0udRXouYnoxRhALy1hoiVPXZMyYFszsBy
         Y+cdwWib2eaKcRcCvB5aEASf2HOtQ3qrKmO1UrZPwMKUknip7iwA4w74FrCGZOhdUpof
         hOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667122; x=1712271922;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3aFzydSyExlB9BmbA34QemVRJ/ZXxJRv4umeOt6fqw=;
        b=WD/1dXCEg9KtlOHdmMMtEVPbLALDRGD++2efUR4dZJdKWYuZ4WTGc6DWEj/UPFg3rj
         avd4ZxQA9+9qRBwM2vF+oEUahZVhiHQPRx9mMI9cRLZGNjjKGoxXGxnEDfvvIO5TfSdF
         VLtt84pHNlADU9svV3J31I3/txJvbpFOfxobscNW46Sc1QBroLLhhjpk5o5/w4pbNTS9
         9XbAlXS35OpbdzbB35O19SDhPJ8Rk4km786Pt4De6ZdVcnDxaHkqy6LEWbz+PogLf27D
         YRaAV7fDkiMs3k3XNHKEceoxQWcxztOzB7VNxsjB7j5QNLAPYGggJ4TW1KR3aKk7h8Xy
         A6IA==
X-Forwarded-Encrypted: i=1; AJvYcCUIxqfFbX1dgCorP5MLd8Fj5JNeTsveViIyGZC6Aas5zZ6tH9s6WvQDX+jS7KcFA6bbE9JNMxNiZ7DKfCVdUKo9Dvl9BIrholg=
X-Gm-Message-State: AOJu0YzFFS+s7r0LR+pWSCJmgLYqinU4CF0IkwA/8rXOJ8tsKErYZCJ3
	v5Axrjlttm7lTCXlb0cBKf05v9oktyzWcJwkqiK/DrAmWRAaI/VtqhysfcnrwrY=
X-Google-Smtp-Source: AGHT+IGt0gkc119snKbJARF7UnrFMVXsS7gpTXjZzbZBfCEKd0wr8mr1SMS6Ds7kY42qafqSBM/uug==
X-Received: by 2002:a17:90b:3504:b0:29b:780c:c671 with SMTP id ls4-20020a17090b350400b0029b780cc671mr907698pjb.0.1711667121826;
        Thu, 28 Mar 2024 16:05:21 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b0029d7e7b7b41sm4013902pjb.33.2024.03.28.16.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:05:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <naoya.horiguchi@nec.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Joel Granados <j.granados@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
Subject: Re: (subset) [PATCH 0/7] sysctl: Remove sentinel elements from
 misc directories
Message-Id: <171166712004.796545.8747989552701562593.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 17:05:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 16:57:47 +0100, Joel Granados wrote:
> What?
> These commits remove the sentinel element (last empty element) from the
> sysctl arrays of all the files under the "mm/", "security/", "ipc/",
> "init/", "io_uring/", "drivers/perf/" and "crypto/" directories that
> register a sysctl array. The inclusion of [4] to mainline allows the
> removal of sentinel elements without behavioral change. This is safe
> because the sysctl registration code (register_sysctl() and friends) use
> the array size in addition to checking for a sentinel [1].
> 
> [...]

Applied, thanks!

[6/7] io_uring: Remove the now superfluous sentinel elements from ctl_table array
      (no commit info)

Best regards,
-- 
Jens Axboe





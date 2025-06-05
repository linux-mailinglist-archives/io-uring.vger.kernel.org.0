Return-Path: <io-uring+bounces-8223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E01ACE7A1
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 02:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB8A23A889C
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 00:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A36322EF5;
	Thu,  5 Jun 2025 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+qu7ud2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4EE1E89C;
	Thu,  5 Jun 2025 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749084736; cv=none; b=ATqISxnsCd3mEhD6miXCnGBntTPIuTfDFFsjcwws+IRARx0tDJgQRykVRtXw0uXyK1fAW3noeSQzuz9AEyTU0syw1UcTaP1vKMy0j2yT+7vDOhroJ2sq9Xzax0ePTv4nLpII1B/aU3q+RNQdRGS6iAl63UbLXoAdv/qhAi5RRKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749084736; c=relaxed/simple;
	bh=vt+Pta5l6VKjBGY0bOoA33qviYDttG4cdTNnsvCbKOI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=FV7oI4fgd2kvugKbMhRsDdKDqBFeNvtz5cB0nvdaVL4yU2FAI+2a/3Rb0NKeaLoYzRQWsNdl+YYbY0zFrfnDfGcbyrAs/FoKop/JKJ50UuJsn1NVnUuNJRajeApcWOZ044qK3guTAmRIyENKzJF68igeVUjS5xXpleBrIHkvvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E+qu7ud2; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70e75bf727fso5572247b3.0;
        Wed, 04 Jun 2025 17:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749084733; x=1749689533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glu8vbkBrFWNWoHGJ5RBuQpTGB2a4rq3PbUqccEpoxI=;
        b=E+qu7ud2ZVXe2+Nr+luHdUmVnMSibQB6WOtY/S0d4L2MJ+T3ScJ8AFSyA6JYa8dRYA
         w5VmkE8WJEWzapd//IJDloGB//FhABj/Iai+F6MTDRk992NfPi0vUPJMLAgAD4JgDNzh
         OQDNLbnQkhnmRiT45eADczK0VwWui8y6wDfJLqEJhBhz9ymC00NBXzEeGu7MGaYxJ4C5
         4DlpiM7Qz4+NWVibkbj5o1iR/39QPlSAEzpuuR+8MpFl4CNP7MJwSpJ2Xlp7D7DDk9Ge
         qta45h7OOYe60mlyiCAPO4J0ucujLT0IYnukEyyKaSvbf7S23c4vYQkm55aC6pz/YjcT
         HIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749084733; x=1749689533;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=glu8vbkBrFWNWoHGJ5RBuQpTGB2a4rq3PbUqccEpoxI=;
        b=gerfN8xecdp2kea/+lu/DPpbxvTxz+LeTQH5EHMW7FddPh4EdCx0EFfgfhlv/tIiGg
         F7zu1XdaTesCzVnISh63By13EEfCUFH4Py1rcYErRdHcImX+LJJZmU248W96zLixSJtC
         UUWXLAWxu5gDnn2BxmrC7eQe6dxsR8Tb7wIYStm9XyJ952PJcHp7I5XdFLoahymPKkfH
         kv5lO301S13vDddtbJ0CaklpBmTtT+r+iTFm/TaqQcjBFIhctgMWiJSvl1hUOUVzyifp
         fNk+mbgIZgXf+4qEAHc7ELda+Hf+Ud5W4cGNbq5kWJAKTMTQpPe7173ZQBcRp4YhQMCF
         Xgxw==
X-Forwarded-Encrypted: i=1; AJvYcCUb+0yzeyaI2yTRjUH3G2hbFjzcxILXPy1XKI8uANyVfYt4avvdeiY8wdyv6vGzfiNMRuRMTY5J8w==@vger.kernel.org, AJvYcCWjf3e35fAuB97AUGfHStRRFEyT7hUd2AxPvQpKJW8Bc664aDEwH6Ydv6MalocZdd+2B9Fkfx2D@vger.kernel.org
X-Gm-Message-State: AOJu0YxadfYpJgjDuZLzmYe5+sTlKjrvw119waffKZEnKBztahNOQlRX
	L2OEC10fYjil80GJBCWl4qOefGv8CvQiEUHqYgpoXljzGsSGQD7VMWQj
X-Gm-Gg: ASbGncvROgLroEnti6uV68id0vzX4TWeZjxTVzIxxOX/9RHvlfQN8mQQKaUYQhC6jAQ
	JrbYEZR9+8qWfJY30gG7CdO9PZBhSDADtOoqVHuGJxsgx30S3XGURi6S785AAgf3Tm8/dvW6cGP
	DllEcb2Dz9plzF/waDcZHoVfFYUO9RqkWd4Jyf18RWwrQIsJj+AXzeo1GFsFrFM2IiH4/71kmRe
	W1IV/9lbMugUY9OpOw5RqnYA3egJlBuNDW32CwNzpma2YOW0ns847MPfMu2HeY4puDHt95sRFtt
	raUJL7DJmeOUsTj1mgxSr9d3gRMUd85Dbqz/liaystIoFEKCg6ozloCn0utaTGu22PHooucfxEU
	cZAA1+KkE2GitmTrAfuSqDG0yeo7fNRI=
X-Google-Smtp-Source: AGHT+IEP+W8LTR+OikT/YtPqzkTGEqdr/cGF3bG3tLMyRTWnxd778ThyB3tquCIQgrIXr+ObL4cskg==
X-Received: by 2002:a05:690c:5c0a:b0:710:e7ad:9d52 with SMTP id 00721157ae682-710e7ade8c1mr22240517b3.14.1749084733416;
        Wed, 04 Jun 2025 17:52:13 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-70f8abeed16sm32434927b3.48.2025.06.04.17.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 17:52:12 -0700 (PDT)
Date: Wed, 04 Jun 2025 20:52:12 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com, 
 netdev@vger.kernel.org, 
 Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Richard Cochran <richardcochran@gmail.com>
Message-ID: <6840ea3c58328_1af4929475@willemb.c.googlers.com.notmuch>
In-Reply-To: <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <3fd901885e836b924b9acc4c9dc1b0148612a480.1749026421.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/5] net: timestamp: add helper returning skb's tx
 tstamp
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> Add a helper function skb_get_tx_timestamp() that returns a tx timestamp
> associated with an skb from an queue queue.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>


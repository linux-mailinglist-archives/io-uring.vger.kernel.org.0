Return-Path: <io-uring+bounces-8062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1747AABF796
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E87DE188765D
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3265618AE2;
	Wed, 21 May 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ETDqaagQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1907D194080
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836998; cv=none; b=YE5UEPZ+bjmRvDOnPdcKVizA7n/5oHa/DQ7oChMhRup5J2IiBoC+y9gQ3OXPrFX7Jz/NuJMyr8t7FphSAN9ZMrd/jZVOo4vAQOC8lhZ3ysVDEDt7m347leA9LINZnu8VQ4ZZ/PBkyF5peBmu4qycGHfsguvSB0mXu8PY+WY5Ap0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836998; c=relaxed/simple;
	bh=qlIbgAmin0j7AtrkUICf6prO7E7P7mkNbZ7lDLJoQ2s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bn7a2WBj7hNwYrL8p0nE7I70nFzl6ahj7+iBeeiEr/y8u5TTBtJ5SsbOlowlnXdob4pXLTjxbwjUkXMUxXQBZJOTfQLYRhHy4diNRuoLM7ZPFcFkYar3lO1e7LgYUGWmZ+qU/8TsmDfMS5PqXwRR04C+Zupwfo8+DmLiZ6EkkWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ETDqaagQ; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3db7b3de375so50943015ab.1
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747836995; x=1748441795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iLl/8st1pWkaj5RyZa068m6OGzEu8miLzXYwfRZATw=;
        b=ETDqaagQ50zL25EVxWpw2ab47/PH7ZKmwwgheBccE4CRDb+88bxuSOqg6/ugfh2d2T
         /v2HAfxs5qxl9Swl0xTl+iFfasAT9K9ZBTxqVy01cxxesJHOd9WLsDFFhkkVwiEJ2Ufq
         ART5jtOpxAqTuRTWWCi0jsSbI0lG8VrJZ5Xt7WRY5Bf2sp+AFC4ini0N3bg11tmeGGMm
         GHbmMR4Co/NlLBemXl/B3SPXGaehYK384dsn5HihcrMuImk4AJqGvTXfldxEE22jAdBx
         2gO6c6uZJ5oUd8smVVoIsOHQ2KJnaic40DoC/WcIpVdHYfgKR9heQ+Lh1MfMmjMvuC43
         SXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747836995; x=1748441795;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iLl/8st1pWkaj5RyZa068m6OGzEu8miLzXYwfRZATw=;
        b=ErEIVbFGcW5p+Oac1KhDwLtz8i7UIUBCdtPQuX/hfHjmfyKrwwVakVNiytDdLkIlP8
         g1VQZBKj3ZE2gs4mzZwrbQTGfd6XCt6ermIcM+SHmLptlwYkp3tLG4pITtMN2RllCbKU
         AdZTCIJV690SfGiizx65icRmSGKNCOAr6Q/KJXay9KPO7OCubfqWlNN4xJnSwxSDBCcm
         ENuoq0nX1GxLv+PDfFi3zkeTYQhz9iLDbJb0U7zworAxve8no9llV42n4Bzr7Fxl8Gym
         ZSiHOe7WBuQs3uwLSp1SxpRfng3qSWJU7bL3t3rEI030KqtnqPfxTUUAWOOVLfFUo4sG
         tmwQ==
X-Gm-Message-State: AOJu0Yx4AGgGknVmK/0iJwbNmqy9hUVbLuTIZ/EwcVfiT8v0vH/iWyKl
	T/tQYHQeAIgvY7AJadpfx6ugtFL2XYNzA0PBwJis8AEEkevwnmhybxCiURpecaXhGBI=
X-Gm-Gg: ASbGnctydd6MbtZGhh4YF0NAHYel7CNQsnvuxxwAj1POzKsyzKwMckHt6arxGHL6hkT
	UstWWNGKbv20mFKcKw4A5J4z9+7kp9bf1LZ0HcG6CqwbyB74Mn9yciGnPL+X8kvoF7CeKmbhxX4
	06mu311N8G+EeqAlyUZZaNMLsv6WXRfgtZLenrNnyEXHw42DHO8O0cimYhpcWs0m8NMj4Vz4k5U
	ORKnv6LltY6tMKqMDM11wolM0Qs0XkT7o98kvhtA9Q8GNFm16V3L1E3H6uNgA4D48DQqr3csQmf
	bmP9PY0rSzhCD6qBEhTUdvlN+fuPq/p7p+iI81tmWVOw92SyspUR
X-Google-Smtp-Source: AGHT+IGJv3ngG5p5LSExCy/WaqblqpNWYFxiVFxZRvUawEw+c7kchUc/xN1BwMvQaszU7uc0dNsCnw==
X-Received: by 2002:a05:6e02:3a01:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3db8573b700mr201674645ab.6.1747836995042;
        Wed, 21 May 2025 07:16:35 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc669b21b8sm19406585ab.37.2025.05.21.07.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:16:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, asml.silence@gmail.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: joshi.k@samsung.com
In-Reply-To: <20250521133303.8272-1-anuj20.g@samsung.com>
References: <CGME20250521134959epcas5p412e2aac9e57ccda2e81b416d5171a53b@epcas5p4.samsung.com>
 <20250521133303.8272-1-anuj20.g@samsung.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: remove
 io_uring_prep_read/write*() helpers
Message-Id: <174783699405.820570.3003190028402273833.b4-ty@kernel.dk>
Date: Wed, 21 May 2025 08:16:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 21 May 2025 19:03:03 +0530, Anuj Gupta wrote:
> io_uring passthrough doesn't require setting the rw fields of the SQE.
> So get rid of them, and just set the required fields.
> 
> 

Applied, thanks!

[1/1] test/io_uring_passthrough: remove io_uring_prep_read/write*() helpers
      commit: cce587856d39bc589286342830a2686fac174feb

Best regards,
-- 
Jens Axboe





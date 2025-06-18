Return-Path: <io-uring+bounces-8429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9663ADF225
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 18:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28A501882B5E
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 16:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6566D2EB5A3;
	Wed, 18 Jun 2025 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qNceykLg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451131E47A5
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750262710; cv=none; b=n2Mz+wyW5NkHv20EI+JTFlLqlUtKBmBq1v8rP1OLQtTcaTJUHBzuQ3IQ10CcXfGO81EYX5hb5ydXcmbDwb2hdnR4t8eozyihHUrjDfzHYpuQojPO1l6X7fu+vcq2O32LCvlgj8NswmTNAHRYZNRNc7KJ4sdSA6v2ul+60lleNdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750262710; c=relaxed/simple;
	bh=CvalzuTJTr/xQ/8YqSU8zWYdFESXvli+w/9NE/yX0Yg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I5EiM4G6RVfpHoussqGFPub8G1tDDwXiV5g7janhonjW76BlWt3YQBwIK+rIYHnBkjrd15fhw8Qd+KSDjLpkm+ksLYepoujHp0mKDd73yJfNy94089OLZ18/8oSCXRVkUP/ta8kIgQHM5LZ5eoIMGWIbGs371tIo4sinbx3Ki7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qNceykLg; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3ddda0a8ba2so69758765ab.0
        for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 09:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750262706; x=1750867506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kY9pb2w5U/7ZA/i2Mx7xXGyHN6hWwcWkO+v8i1+mOSw=;
        b=qNceykLgULPjXfY0slDKFhrTdAusBGuZU356Pwi7lG4D5Krq55K1453eNcwpaXkGFA
         rvOn/XIm0NVILQtFM6eDhLWvKwxn1ZM76dtHq15BmEN9GVKedL1xEiNE5Mus5POrD04D
         3veWmjNzBdt2LJyvGmHRP7NqZ5U8aIvA1/AKqiMAsGkNeHLD83VrW4eBSfPj580r9YMM
         hsM9GUbA6+EJDpCY7pP672AXn1OxIFtBsa5vSJedA27f2NNsxcNTIpixkx1UJekGz5RJ
         3uytolOLcP4gVtT+bIykK86xgO4IdDYrAyFp4LvhXEj82r4n8TqvJVEqWIbYIideMc5j
         q0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750262706; x=1750867506;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kY9pb2w5U/7ZA/i2Mx7xXGyHN6hWwcWkO+v8i1+mOSw=;
        b=ds2u7nX9DiL4f6S4Wqk85npMsrMF3g5uCaJFdAN5IimgjX/+d4/4cz4+7hF0sMlVZW
         5fVulQB0ji7ValiQQxlDvOzW9yunTFvT0LEW5ogEjT5+1VTzz21Yy2eZ5A0pKh3Aq3p6
         98VQ7M7yOXW6kmKAIuIF2k5BJ5g4K8UqVORR2noLNkRaykjMg3DXPblGq7C0hY0Yi6PE
         hzeeB5jJY6T+pvgH7GJHNpd29hwz3nQ6xvutSIQIFpl+zDPXKJ6AmJ5KfDWYfrEr+agZ
         2Cu3Ku3dojCnVocaNVBC2KPSKOaTo/lhwYF94tEYdrqE5WJKCxLnmXxeWYEEdhMw3/Sr
         3HxQ==
X-Gm-Message-State: AOJu0YwoQbR7vL3nCjpfpzx1V/QrqrBwMK29ZdgXxDJeEdbaWdZFpD1v
	iBnU4tWcUWSIJJUez1QeUwdjPEtPfbm5l1P742Y74amfHWgSypIu+iJuwKp4vuMiyIiqj0g+4WJ
	uMDhA
X-Gm-Gg: ASbGnctbBRnmdTnE1GoWwUq0THjM43LOU5uarWtTXAQ8W7jhYcyPXJC613uAZFz9gZ3
	4HlmeIc8VuWk/WrT7VrGAjqFmqFkFv6jtxyaFu6QQRMQ93Y1K2PcZSxWZHm96XE8pG8ce0veXz3
	pw1g5VM75xSoXh6q+WbqTTt/ZbX2gCFbpUCuZzZJvoN4nxQj3yrdgSEY/9vHPEi4HUCipDdH01o
	rkgrg0jnpAWnwFmmINqt3eceZM2q6Q44mEpPBlt4359rk4YlMCJXmegAD5/sawTwpplTjlS6/0v
	ual3sHcNQSEQ/cZn+uM6pmfcsgcMCrLDYboM9XEMka4yoBnOlp7YAReH9mO+hLU=
X-Google-Smtp-Source: AGHT+IGtpcIxq0gPGqxSojUxocNU0dp284Sa0Ni0UaQyXtR6phyq++qUdGN/7bxL1UMmut0Z+LH7/A==
X-Received: by 2002:a05:6e02:178f:b0:3dd:be49:9278 with SMTP id e9e14a558f8ab-3de07b9b644mr196923335ab.0.1750262706076;
        Wed, 18 Jun 2025 09:05:06 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5017eecb389sm642738173.26.2025.06.18.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 09:05:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyue.wang@cloudprime.ai>
In-Reply-To: <916859AE41FC06CF+20250618110034.30904-2-haiyue.wang@cloudprime.ai>
References: <20250618110034.30904-1-haiyue.wang@cloudprime.ai>
 <916859AE41FC06CF+20250618110034.30904-2-haiyue.wang@cloudprime.ai>
Subject: Re: [PATCH liburing v2 1/6] Add uring_ptr_to_u64() helper
Message-Id: <175026270523.1507493.8726750465152127655.b4-ty@kernel.dk>
Date: Wed, 18 Jun 2025 10:05:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 18 Jun 2025 18:55:38 +0800, Haiyue Wang wrote:
> Add this helper to convert '*ptr' type to '__u64' type directly.
> 
> 

Applied, thanks!

[1/6] Add uring_ptr_to_u64() helper
      commit: 74cc0d8eb1b6bc6d875eb3ae3bcfb332ea0b2e8e
[2/6] liburing: use uring_ptr_to_u64() helper to convert ptr to u64
      commit: eafce79e41a53faa8c25f80356f2e8326b2fd299
[3/6] examples/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
      commit: db4caf372864c9cbfcab6c075830f26f1426cec9
[4/6] examples/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
      commit: 1d90b6b0466523f2b5b323a4a5a02f7613748a2f
[5/6] test/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
      commit: 1f79da0ffb43d14a5cd0880e42c344b7665ad5dd
[6/6] test/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
      commit: c2b3a104304b5b67702efe09e2673079932fd1b0

Best regards,
-- 
Jens Axboe





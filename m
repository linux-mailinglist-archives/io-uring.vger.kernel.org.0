Return-Path: <io-uring+bounces-7704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05964A9AEC4
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 15:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17CA99A140E
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C7E86348;
	Thu, 24 Apr 2025 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ocSTkIpd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7B322ACEE
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745500597; cv=none; b=qaAF9dDIA7JX7wjXrcn8vnYEkU2Qq4tLZtMQC0lBUg7wbrQdXNw1yn0YOQc+BVhRQuXdc5xQBy3KiB/k6Yg+BrN9rXsbYbVJTJA4Ijcui60qMEI5uphQMFmSsB3cBr0AMMZn/+YlHBk9JDxQVULLVKlLOHiItDokM46TBo0e7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745500597; c=relaxed/simple;
	bh=xKr7/B1lOprS3H5rgTrneo2QJi+EdA90aQ4vYcV88OU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dxmFdKfWiEUO2rIMIheWkYWk4P+cGSJkA3DLbSj9gu6O7DApc/RXdMzWoM9/S2XJ4cloQUmIn7Gab/zBvCkD+ywMKH+xl60NfuJu+elAp8hOwfUszLf53seu3Qpf7S7tCKqHhkK2OjnxiTEJ60dz9CFFOnx/1KDnDK3MXsR4AwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ocSTkIpd; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85da5a3667bso34665739f.1
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 06:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745500594; x=1746105394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VaAzQHOC0036zs4CGqjblUZgLUTS416+X0DEcPhGjOs=;
        b=ocSTkIpdWRDopKD4YegRDiax4/sRclwllCKQJE5xSBhsSSQVh5+iQp+X8rd0PqQzZ5
         x4ns9SfXBqFnJbuGEAHzPsUrUk1kilIfVro+b3B9wBz1rO0737pKH333OUU5leqBzd52
         dOYFn1h708O5AGpPP+/yUr1174FUFwMEPvM/GK2H0Fs4lLtPPggBIOCbOm21b3ArjIyI
         7NkfSRaVLdNJhGhsUYTVmbTR/LXoLsnhZRMpM5eMkKtc2eUs58o21vZqOtSaGOpOQ6VH
         gKyKd2/zhz3d7M9bVWYXvOvpdg8n7MsGkrPyVgnnj4JmPRnWIShAWp1f7Ti0YONbnAMY
         7UlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745500594; x=1746105394;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VaAzQHOC0036zs4CGqjblUZgLUTS416+X0DEcPhGjOs=;
        b=WA1qTjh8I4/GYIhgZrDhasAFbXCgiOYRJ/LAKlZT/vKxL2NnYbLC0CxLpsC1BXa7D3
         Xvhy7qGvX3AS3PA8PQYODs6g66/tOYxrXKkJuMFDZQVTkPW8fl2ZFGbz7eciQtOTFA9Y
         jWkixZDFTjgCSe4zdT2lXoeLELgK7S5VDEVhweUM9WwsdhW5KWi46HaakJ8Gq7/PFrH8
         f7wg8KacK5o0Qia6E89X/k+JPK6CQkhGDXUqRoaHt8g5gcvvCi43I58zkDsbBFBQgSAE
         J74m0s6u98xX3pUlrz24c1iwxJp0urd9paxuZyeVwEb5JnphYqIwT4rbNKBmQlS59vrV
         uEZA==
X-Gm-Message-State: AOJu0YzXiOwNjdiog9mvJskSPazLKNNACB1gNNwwC3VjZ61HouH+xxLv
	HQ9vLT4tztCb1staURnfl1lr5INXgt6ZqHopKYq6umnBVgi1m5Tnibf6JEOkv/uqp8JTbCz7tLb
	k
X-Gm-Gg: ASbGncsemp647aFKTO4hGg9iwyHfm0/Rd83aWiHLnA5JTEOPOF678sxSS4iczOf+vrh
	shzL3rb45k+waYFqOqQ2XBLZ+9JayYY50h77W4bdyRiHp0MFAuwzlb95XUK0bnH0hs2fqyLDdsr
	kwCP9tB1WmkUQFCU462PXJlY3H2FWTlwomzFssqM1b5ocWFqGbd3LNLJzj9dD4Qdoi0/lft/YAa
	p5WDgX0zz5dhDZGHxOWUN47CCFQY59kAMk3y2xoUchApskUZ/4AbIC0hhxOTUAdhmtQ5IwFZ0dl
	//YWdSiChIvxF8cK5ERIJSuhrBXdcc8=
X-Google-Smtp-Source: AGHT+IEjBLAWhHBaPMRqehICaVt4CUJEuSQPtUpS31kkQuNftDNGTk9je6ustXnE0gLYzvJRJln/2A==
X-Received: by 2002:a05:6602:3429:b0:85b:538e:1faf with SMTP id ca18e2360f4ac-8644f9e322cmr288856639f.7.1745500593793;
        Thu, 24 Apr 2025 06:16:33 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864518c759dsm19180039f.6.2025.04.24.06.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 06:16:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1745493845.git.asml.silence@gmail.com>
References: <cover.1745493845.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] eventfd signalling cleanup
Message-Id: <174550059278.632322.12955519450592754816.b4-ty@kernel.dk>
Date: Thu, 24 Apr 2025 07:16:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 24 Apr 2025 12:31:15 +0100, Pavel Begunkov wrote:
> Get rid of of conditional rcu locking in io_uring/eventfd.c,
> fix a sparse warning and clean it up.
> 
> Pavel Begunkov (3):
>   io_uring/eventfd: dedup signalling helpers
>   io_uring/eventfd: clean up rcu locking
>   io_uring/eventfd: open code io_eventfd_grab()
> 
> [...]

Applied, thanks!

[1/3] io_uring/eventfd: dedup signalling helpers
      commit: 5de2c46e0f46328b5b35ea1f86299af3cf7163c3
[2/3] io_uring/eventfd: clean up rcu locking
      commit: b27f1209b3efe0e93b033533874e982d1925418f
[3/3] io_uring/eventfd: open code io_eventfd_grab()
      commit: 61dceb2a1c94b3e2c5ec8335bfb7acb83c6fca6d

Best regards,
-- 
Jens Axboe





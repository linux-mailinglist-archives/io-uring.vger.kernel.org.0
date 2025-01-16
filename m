Return-Path: <io-uring+bounces-5919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 739D1A13BEB
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 15:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E82833AAA02
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923D122B5BC;
	Thu, 16 Jan 2025 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OuBY6BU0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA822B585
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737036820; cv=none; b=EtD95n3i5Rcz/r/CJWu6mfZcBBctnex4HO+D4CGoHlzk5c/VeqN+f1z7Xp+q1mV8dmkb45+s3JkhdD07htF79qHyhKnE50NKRUMUmxiiIhdqaokR3D63OcWWHygZTNpm65Li04YOTb6qtJdzEXsiOQ+hK7qHLRWcrzlte4nKqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737036820; c=relaxed/simple;
	bh=pKYDRk2WECgf44rkrVDaYxhkS0l0IUcr7YEmGhmiqDw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nZSiumIWluY/klzUP4gnKSr5SIsOsB7olRh8v+wI0XArlv9XhaS/wY7/4kfk9ImM6oNKquFUWH4q8l5zuNtwIQ2f6+7enQf6VEsDtmpeqLi07sMn4zGKi8zmgDyPoan+tsyH1mBw48GGGFszsvB2MRQVYk6jhG7vTU0HxR6MLt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OuBY6BU0; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844ef6275c5so33185139f.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 06:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737036818; x=1737641618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73Xsk4nOieqWZAERxpkYR1gpFoUlUoZPTA340hSMmvU=;
        b=OuBY6BU0oZIwREuVGx5wLUla3w0xC40mKk6EYR5edjsZH0p8l+kLuTJ0hC96xefQ4G
         JcKx7m26Wezv2iSTlrd5fzyo2PAH/wlIokg9ptRVDkvLouYiyekbO7AHxX5ViWtDEqFv
         J2RzSIWD4UN1vxnoFk7Ip9rMVKdV8OXhuP5Ml5gVN+HI+nDnn/fLWKLlpOvjqOSdXiGy
         pwTODoCXG+/yxF3wypHuPZvOzaZK9JTom7iEmPZjmzbPhGuR6OXORVpcyi/6u0YzmVWN
         YEO1EGI1+T9rfUJru+S+0V06b/FzPnfdLlbvy/eBQBjh4FptK4I7pWfX+nLcXz98Epzb
         Bp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737036818; x=1737641618;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73Xsk4nOieqWZAERxpkYR1gpFoUlUoZPTA340hSMmvU=;
        b=Sz1JVZYS6vyOaPZ291sPl+Xi2Z2wlpFJVPcv0Ofjgy6j24x115vaG2oz4U3YdCNbJ7
         OyHpu0n0VKVDvQz8eA6DM5z5ecPSqQsSkCKSd5+R06qpKHY9Km/ScgR7ShwB5g9+FkMq
         WPCHw2Yf5ZQkTHRKu4O5BVhu0ssrPcYXTtGWtwlfiuIhhdBfGFIow+n19ZleLhgFWDdf
         ld2IaVtHVl/MY56XpwJKIg0MyfSyTnHPFViUIcGxa8Ru8U3tLCkttySc9OOJdDwHQbfh
         s4jt4KpDw6Fh5aKP3Be7k55sRX+6y6mH6ixaLBMFZJ80mtQJZU14ms9yGM1xuaJBfYrn
         qNrQ==
X-Gm-Message-State: AOJu0YyIqKhfTC8M6l4XyAsSfxufYsvRNa6sYVR/qpAY/mjK6NRmnTjr
	UBsxRsI+Y4t9N/mV5UkYQtcbLOh5oyjE+MpxJ2PhJjCTyhtzbqiZCzc83UbX0c0=
X-Gm-Gg: ASbGncsP4wICnhP8eoUS580+1ynFSKEkJgWaOv/DIHmIZlRdTnN07IvMTeN0LxrcwXb
	9Q2lOW2SMtlS6pTtzOhRdLxQjg0pTKcAjAb7fvPMWKyxMnjd5R6DTkU58yU4AvbunFomgbJ+ks4
	oezIqBYyJgHrTcslmrRGYSNHIq8yLmQlCui28W/8CFay/9G231LR5G39UR32DVFdC5JHBNa5UVm
	2gDaoXCeYhaClP5vhmtperWVOZD+lvI3Wxbh2jtt64ILsE=
X-Google-Smtp-Source: AGHT+IEZT3OMbNB9hMR1Hh+4WPFGVXgpJZFzYM9mDhNCiBuk82d/G3Z8rXaLShU9NCVebZnfOuroXg==
X-Received: by 2002:a05:6e02:17cd:b0:3ce:9cc4:aca0 with SMTP id e9e14a558f8ab-3ce9cc4adeamr33040665ab.17.1737036817930;
        Thu, 16 Jan 2025 06:13:37 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756bae75sm36808173.132.2025.01.16.06.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:13:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
References: <0d0b13a63e8edd6b5d360fc821dcdb035cb6b7e0.1736995897.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: clean up io_uring_register_get_file()
Message-Id: <173703681679.10865.14781700583746866036.b4-ty@kernel.dk>
Date: Thu, 16 Jan 2025 07:13:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 16 Jan 2025 02:53:26 +0000, Pavel Begunkov wrote:
> Make it always reference the returned file. It's safer, especially with
> unregistrations happening under it. And it makes the api cleaner with no
> conditional clean ups by the caller.
> 
> 

Applied, thanks!

[1/1] io_uring: clean up io_uring_register_get_file()
      commit: 4415be009035b67b9101cf96b02cfee95621b3a6

Best regards,
-- 
Jens Axboe





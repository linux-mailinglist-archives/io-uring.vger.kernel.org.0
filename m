Return-Path: <io-uring+bounces-8047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4DBABE1AB
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 19:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EAD97B0BC8
	for <lists+io-uring@lfdr.de>; Tue, 20 May 2025 17:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99959258CDD;
	Tue, 20 May 2025 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dWmxF79i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B108C22DA19
	for <io-uring@vger.kernel.org>; Tue, 20 May 2025 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747761326; cv=none; b=jHbwFXQNqw/4zzbztMO6rPtmJiVaJ2324yBidRwedWEhQrbrMj0RV1dtWvod7uHLZdd/6sWpgKd4Q580ZumDR/em7PAmGRZIojNSZLQcikXB0NLzpHEqzuSDAVtgEv1YjdXWofpY87HvS7T/MN0cP/tqM7U6GBju1QcAmYCLKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747761326; c=relaxed/simple;
	bh=ALEIQ38bT3fg1jVcwADhY3fnWIU5eSpHm9SnhIsQj/U=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=svKfqjwYu8Dv04SHSTbtkL4wHxwslmU59MZHaqUln7DlHdum7tZ0rvbbxMceyss053+Jg9Jc1Tu3PLPc/VzVxsoTC4NgYVBld6zY9Sq9+O4dEiTY84VwP72TtAOz8zXXWazm5ZSWnNAuO8QJIwRUZBtNsdERr36a+JNCTN6ueQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dWmxF79i; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d812103686so18055045ab.0
        for <io-uring@vger.kernel.org>; Tue, 20 May 2025 10:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747761322; x=1748366122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLseaMdSRgDI4XdPl/ds2UWfxE6oPHaARX69KQKLCQs=;
        b=dWmxF79iN1k0zBB8JU4BAfq5WR/now2m31MQosHjrgGyv7Yv0SRiskBBJ2fRQJTpqI
         7ogdOYBIg6DOKrQEX4veS5/KJFHJDTFehRKxyYh+A736bXim0BPXKPcUp3CXSHnsx8D2
         A020ZeME3xcobV72A6a/AzkNpPvjTLTR4PC9qe6e/SHKr2EgDi4xQQlHCMnSS0tqv24J
         ZthC45c2Vmgz4HTz6ZUGx2ZnbvqwuO0gpJhoF+5U8wT47nZ2iUbGxz5KnynJZcSVDb6K
         mJf066RUFrGn2HVB52SLWRlieqW7JMUUofOOW7jfvXqLSdKvjgd6QV/1iTub8Z51fj1r
         hYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747761322; x=1748366122;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLseaMdSRgDI4XdPl/ds2UWfxE6oPHaARX69KQKLCQs=;
        b=l0WOIgKrWjY+Rb4MUQKhLW/YzqXzvBrHDqwYcmyDIHSifqMkuskJZOE3HZjnxRNe19
         nKXFPvnnX55aydrSk1SfEGHdDRQ3WcvdfbYpRTGUvMbnHWQfSA+LsKMc9mPQHXupKYIl
         Oad52DtM3IdXUF3uKIaW3ab45d+iOhNcdwLxRoc4uJVNW3Wf6FyAlD3fuM/MLJh78Qok
         n46dkNKwG2M7bpDFc+vuY/ZH5/ArcZKUBp3S0yROrVqv1ExsDGEzgrjeO/zIBOxNztJw
         dlut0E/3iJwngm2WXdfuM6XvCyhSaK22k2qCZ2ovOb099QV+H8PJbEIkbA8DFKFRdjTg
         T3xQ==
X-Gm-Message-State: AOJu0YyIcfdBW1hnlq7wCKs99xWN/bYEq12HSh9c7tBNUNcD0ITcPFMC
	xnvjiPuMXoiErl/qfXc1fQ6EtVfsU/PTwmo/Zhlw1g3qaZ+cvxsrRBVD4egnNLKiI02fynZtkLb
	Kxinv
X-Gm-Gg: ASbGncsW5UgOAH8qPWVCC8tDcx+29NMLiiUApGGNt0PFwfuW+zgzgLnCgIOMupOEZOa
	WZ/xXcS8NLoO/WYf/As/OO11PVJT6M3QXk54hQXNrRENzWaw0uYgS+60se0EgUc2kB3TCNQe2zq
	RszLihTPOwVjq0im8pn0E1jpmPp4dKc+bxmlUnY+cGhl7ZQzDVRct9QmZEK+rp5NQ/Rqu6XOFS0
	oN6TMqKm6Z07nwazAaGvXNVQDrEPYSpBsS7OvH5ywx3zeNnoI+SnVZEhf7/mU6+gQrowWIjmz1s
	A3B4s3LEzY7llTI75dbFPr1wJV9DNEPDFlrJYZkASEHNU0vh4Q+X
X-Google-Smtp-Source: AGHT+IEg29/FnpTP/VSyJSyRO6Zy+sSpmHy6q4dPqRUEdwXBd2vz6ukLFq+7gKDU6szoHGo0vj/UPA==
X-Received: by 2002:a05:6e02:2191:b0:3dc:6824:53ab with SMTP id e9e14a558f8ab-3dc682457camr100064685ab.8.1747761318370;
        Tue, 20 May 2025 10:15:18 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c897sm2314432173.98.2025.05.20.10.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 10:15:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20250516171351.1735-1-haiyuewa@163.com>
References: <20250516171351.1735-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v3] register: Remove deprecated
 io_uring_cqwait_reg_arg
Message-Id: <174776131748.750061.13622972096742731154.b4-ty@kernel.dk>
Date: Tue, 20 May 2025 11:15:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 17 May 2025 01:12:25 +0800, Haiyue Wang wrote:
> The opcode IORING_REGISTER_CQWAIT_REG and its argument io_uring_cqwait_reg_arg
> have been removed by [1] and [2].
> 
> And a more generic opcode IORING_REGISTER_MEM_REGION has been introduced by [3]
> since Linux 6.13.
> 
> Update the document about IORING_REGISTER_MEM_REGION based on [4] and [5].
> 
> [...]

Applied, thanks!

[1/1] register: Remove deprecated io_uring_cqwait_reg_arg
      commit: 3fd9ebb6889461736774a7b3c797b165789674ee

Best regards,
-- 
Jens Axboe





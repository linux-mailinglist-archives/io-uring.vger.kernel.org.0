Return-Path: <io-uring+bounces-7028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 587F5A57359
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 22:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BCCB3B4DA3
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 21:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4ECD241665;
	Fri,  7 Mar 2025 21:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n201nEU/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B0187346
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 21:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381776; cv=none; b=YEeOLzutb+oQPEoYAkAQgnxXad71NZ6MQueH4PuO/DE28yMSg2TesbGqD/Zfu+cChaGtX8pWd8DlB3an9Y2zlrgKWA2YJaP01kfj1W8P+dGrk+SkQatB41yTTIGy9drULhqa1yV3o6sR7CBSZFpZA3G8mvtDvojhGJtMBFdg5mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381776; c=relaxed/simple;
	bh=MnJqSez3QnP7+5tsjkp7EcC/2Q40YfWkuABhHyzVpPY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Jz0D+z8lwSKHll8HYUEam6J+YPjSHGs7N1kYtMLyaFXbMpuZQpldj+ZTDucLd/o/ywlE0Ad+hOQuslrpJfuJnQHCalsQClglRN+baxYFb2yyFJ8AI0vwdzZLAs4Q/W9PKElAKuDXA+KaihYBXMx7UGerPn2iRPalFPpJwHRvMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n201nEU/; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d445a722b9so2906305ab.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 13:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741381773; x=1741986573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YzFd4E9Lufa9FfWsHU1RBfEO6fdHd7iDybQW3EVJSI=;
        b=n201nEU/7kP/8JfXu3ECdKuBRYbJnCuqLaJwNndORwfEtzjBuFCrWe5frF/xMXD1NR
         xERJsIhZvfoHCRA9YM4ylCyXVCiQQUQo5yNt5kOKjttlt7wZB1sUzg6a/NNEl6d8FHAH
         jpMo3TTtJYMRcvnaKefBi3gFat5zCISelBs7qTkbr3syvPGv4EVnJ3glWBjJ2sCal8Qh
         DzsQFJnFD7fwfzGk71BPmPUr95bKyyrZLl1Imo+CtbY102Pt2xRQp/JiT9oTY4O9DybX
         7uieetXyjEx3ItSf42ew1GroB9CLR3yT7242MyMjm2hr0AzSLqktmjxLI7nTLR4CNLer
         8CEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741381773; x=1741986573;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6YzFd4E9Lufa9FfWsHU1RBfEO6fdHd7iDybQW3EVJSI=;
        b=iC9/++TzOP7ENbeWI8KJ7EB/HzkAL7h68AiCW21oBRiYB/OT5CNTTcBmW71ZJIEhFH
         OjeaWTGq6n1LCnw2ZzscSeDHt3kCkP78tJUsZvbXquhLGsC72rqq0AFpeEoWb32gQUBK
         BAeF22slL0JDW7/e3ULqC1Ya/iu5KkAG4u50EceFforRZAqQwUfKMbCx37pbMPhzvWSc
         dEhKyK+TpH38w6jdTfolZ3GWg7sS46KNSi4zXyT7nK2E7SeArQ1zxb/dw8+LdbxNYkI+
         4mmTebUWZzznVME5EyJXettzaPeNhsG+yHmMFnxKqjN+IjuJ2cpdINV1jVuWQCZuhWZy
         fs3g==
X-Gm-Message-State: AOJu0YyZRbfYhDhHPhUUtyC8Vg7TEOL1YhFWlCw2lSXIS2uYMbiL+v0R
	o4IKO8RmtZEZ9JZFS0U9QPCQhBgq5Bg97NgM+Rpytc3C0h9abaZ+yXN/ni7lTGTWQ6Wx9zE4Tsk
	w
X-Gm-Gg: ASbGnctnUtRmEKj6qzR/UL6HtJzZn/UWORcya1WyzkA6OTPMoU0tdsDs3SwoqdHUzh/
	Vx2HT4B0JV39GHKOkRU8SBdfmxSO11SZsLuwF5gvNiL5ZIqJ377EZO2RqK3iasdKfJw9adVICRr
	DkUuTH3GxFeKq7n2ZkBHpwSIntchyY/sxe3zVmXW5dddVj0OqoWk4iYGsO20oVdLxjyKBg8XZ9b
	NU+7XRZmz7zdOoA+9qkdjZC+15e9/+kQWYzKtb6x9mpNiSwghNNaqc0GQPA939/25GRCOr4FW0D
	ZOmUXxvLymU523jxqfcmscYt+i0qTmIddWCg
X-Google-Smtp-Source: AGHT+IHxrRV2S8iufrU4N6r9tmMryzLqUeJG9zpUFdFUimBoScchzmlls8eX/8sBB/9IDRhqU9ZMRA==
X-Received: by 2002:a92:cdad:0:b0:3d3:faad:7c6f with SMTP id e9e14a558f8ab-3d441933118mr54168385ab.5.1741381773699;
        Fri, 07 Mar 2025 13:09:33 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f219d8f4b8sm501688173.100.2025.03.07.13.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:09:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Yue Haibing <yuehaibing@huawei.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250305013454.3635021-1-yuehaibing@huawei.com>
References: <20250305013454.3635021-1-yuehaibing@huawei.com>
Subject: Re: [PATCH -next] io_uring: Remove unused declaration
 io_alloc_async_data()
Message-Id: <174138177254.441913.2825147745807855695.b4-ty@kernel.dk>
Date: Fri, 07 Mar 2025 14:09:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 05 Mar 2025 09:34:54 +0800, Yue Haibing wrote:
> Commit ef623a647f42 ("io_uring: Move old async data allocation helper
> to header") leave behind this unused declaration.
> 
> 

Applied, thanks!

[1/1] io_uring: Remove unused declaration io_alloc_async_data()
      commit: 30c970354ce2a4c6ad3a4c70040accd34082f477

Best regards,
-- 
Jens Axboe





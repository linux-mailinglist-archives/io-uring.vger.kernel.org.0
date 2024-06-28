Return-Path: <io-uring+bounces-2381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E326691C477
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F77E282458
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5BD1CCCD7;
	Fri, 28 Jun 2024 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETkypuZA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB041CCCBA;
	Fri, 28 Jun 2024 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594418; cv=none; b=iO/p2WaB1TyqBJnbGDmu1UnVb9jolNm1N7jmrUFynnctnB+hiQvFlioYzctvglP5TMB59tScYb23OsqFSrziCSyr4dVpbnUF0eRxi9/8QSpUTzLbjQjJM/FrJ9lTRrFkEh2Gso4Uxv/Btf7MWq2Yz1pWkcwMeq5XBb4ZzCKrJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594418; c=relaxed/simple;
	bh=4Zr+nd3J+yxoza8a1PYlgqPSpsXgUDmKkU5O+po44bk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=QQmcs7SC4kKk41VvtJJfmFMFIzL08Eadolvj5fNNLYBAhCW9IvGzs3PaZjdtvijYJYhOeqyxMawE2Z35csbjWqwjsfNP3Zp30K4TZJXgLIurYr2HpvWy9v4Cs2JajRt3GQ5NW++L6bqbRbsK8IdbOEZKIujVJy+lfQuZ2kEM8Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETkypuZA; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-79c0b1eb94dso51407585a.1;
        Fri, 28 Jun 2024 10:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594415; x=1720199215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F49/bFlGo5lDwPRdmzFXCo73h73jegYIC4d1yF75uX8=;
        b=ETkypuZAH00F3G88grVle6pIwbPqne26cn91PVrAR7RO0Qxj31LzAw1gQ1FdgaTM/W
         UbbgSz5gqGSkfnJ9GJqAJDwbZEJWYMwqxamiB9+nEhd0s6/jz5m9jY+mIAhuDGbmgMpL
         sLovTsU3sZV7SEdaHLkJZtSAgkOagUwS/x/x0RHp0cD8Kql0HGUOvwJHgnC45meGaHsl
         c3Y162WBHIhnX14i/bcuP6nX8vWMjzrZP/v7LabxLUmFAARrWhAuJgYU2lB6zXadJ/pX
         V9xNjv5Leu28eI6FBOThr/x8VlzawHQZIQczBBf8BtrjkFZ+4e5As+DV3wiF1hEEOxvj
         FW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594415; x=1720199215;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F49/bFlGo5lDwPRdmzFXCo73h73jegYIC4d1yF75uX8=;
        b=YYH8+FNEtyqyZeMkA/WDkDb7CfC27dWtk4VkTrj9ggok0SsSnoUNyAzd3nZIB5miCy
         T2ktqulKTrcVBIryfobanpVSK8XyFsSyyQBMc+k1k7ho8MEihnwh0/rfE5NiR32ZMgSe
         3o25hZL2xf45Dtn30uTlwj0pK6/v2ipIp9JYJJBPWN2eTSr66nmWRo/ogzE9h40DD6yO
         spblvvUdDeHuky4UY7XLhmY54rnFerUFxgH0L2OHespCvbHh9k033GxZNswjcFcNEt6S
         K2s+DyslRSQvWTyedQVT7v4JM8a/fz+ASu5wShn8F2CN183EkL2JGUQPP2AFGaOvF0xm
         oJ1A==
X-Forwarded-Encrypted: i=1; AJvYcCWEWpYeWaX+Sbw0484bMLFtQuNo5v6SWeVWjntBiyiOXJcxqHJ4xKkcg7geVwdwzTV4t9nB40ZXZqL3tCP56B0sULp99PfYr2DLQpVeQQq0t48bQgi0ofo9xomO0EViRIQ=
X-Gm-Message-State: AOJu0YzF7ZcCAFEOqbwU2DzFibMBZ+AKZd0o6jbWYMQNasEQCYn0RQVm
	qQdKBHajE80ESVin57xzVPlFWwoimFFUrJYM0bMlvqdoXM+sV+bM
X-Google-Smtp-Source: AGHT+IFnaFbpMfndZjxwChsjzI0JcCDDjvuqFdZSQ9ffBjSa0sh9+sNFL8uT0vWL1GGjOTonSrG79g==
X-Received: by 2002:a05:6214:2468:b0:6b0:7fa6:c004 with SMTP id 6a1803df08f44-6b59f136c91mr37829016d6.59.1719594415144;
        Fri, 28 Jun 2024 10:06:55 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e573914sm9383576d6.49.2024.06.28.10.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 10:06:54 -0700 (PDT)
Date: Fri, 28 Jun 2024 13:06:54 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <667eedae8096e_2185b2948@willemb.c.googlers.com.notmuch>
In-Reply-To: <1e55ad85b726d50a45bdd35fc04e1565d3ba7896.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <1e55ad85b726d50a45bdd35fc04e1565d3ba7896.1719190216.git.asml.silence@gmail.com>
Subject: Re: [PATCH net-next 4/5] io_uring/net: move charging socket out of zc
 io_uring
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
> Currently, io_uring's io_sg_from_iter() duplicates the part of
> __zerocopy_sg_from_iter() charging pages to the socket. It'd be too easy
> to miss while changing it in net/, the chunk is not the most
> straightforward for outside users and full of internal implementation
> details. io_uring is not a good place to keep it, deduplicate it by
> moving out of the callback into __zerocopy_sg_from_iter().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>


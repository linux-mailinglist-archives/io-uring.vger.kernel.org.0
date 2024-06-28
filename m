Return-Path: <io-uring+bounces-2379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4232591C45D
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C6C2816F9
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB4D1C6896;
	Fri, 28 Jun 2024 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yu/4oIfu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA901CD15;
	Fri, 28 Jun 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594237; cv=none; b=f1bHu67EyYBc4eA27M+J/FBgAncRwwOMXrIsCgCCY7U3EZ0FfS+YzvuB9CC9gH4AQkfJ2pBfwf7DzykO4JoWuxQaQgM5W3tf72mpn7Uez3Bths0KbLBrzskiHWJFiLTjA4VMDENHH0+e2cnZrknR2oVnIFV71M7hHvTHiuFEg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594237; c=relaxed/simple;
	bh=Z+1nSjx5df6B3GxvFHdjo4RmU660+fuN8prgJvDaecc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=LN248pLlFBKml8yZYUkLqJIL8dEPIamNGAeq0LvJWQiBEIeWWV9Ncp92PtfrMH+V+eF0jWaRSsiGtbIRRrlzk7KRCPjowzgqrFQpvZIs+FAJOuUWH3NLepSAjm5u9Ma4gTAVEeEVjG2Bv5APXDZdKgFdv3N5QiRSNybc2Qc5vcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yu/4oIfu; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6b56000f663so4055526d6.1;
        Fri, 28 Jun 2024 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594235; x=1720199035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YV8YNmXHr3Soxj4acZQlBarHinHioDKRKUv49Xn8zg=;
        b=Yu/4oIfuhYLj/PL0QdFA5qui21BeQKzjkM3swCEhTGMjPwkoXVBZAc61eqYANtX1vT
         tLsl0AkBRRTuO/m7J2duFtjWSVvzXrz1PwKEOWbrtO53oImMTqRSjMIzZ9Ogk8/sAd8m
         E5HkK15dvA+hFqBWtU3gZCIse8KedXagGF+etmpS7DIiuePXT+22IiVEOjfRfT4jSv42
         phz17EceVzl97eNfXQE6qKjuH3ap6quXDGgL/Q67C0EQhLu/X4VOXHBi6Dm23HKqPJsl
         udDYC7XzyUZyLNFYu5PV4xM7mbDBceLSJCFAPqjPCWb5PJYTv0tLL0+ttJ3zE/XQaamo
         HBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594235; x=1720199035;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2YV8YNmXHr3Soxj4acZQlBarHinHioDKRKUv49Xn8zg=;
        b=ha43aa/pjnDxVshaOVXWj5XmMMr4f+6Z6ipQTTVwBdgo1hcWllzeYRmyL6XHRA0a0I
         yCLJUnNBv5cC2nHlh+d6uTJLXV+mVCs4Rx/EsCyFMJyZaVNODWrYoDRy5ftVyL+FtFl1
         6mkW/g8T+Byz1NNflKLCUU5kLt2a637mcPAhWhZVvhcPdrTLCCDfd9Wgc/ftClPJRpGB
         hQB3Hwj3lPxs49pZwjpl1/yZ+2LHsdHndiu0lxGe3CJbw0fQXCB50PmdhPRuKOToebmU
         RPcq991CS7zAh/RTMVk/NkjWiYe7I3cOAI2+1/DYYrwwZFGZT/Ks3yaPHXJJFxHgAwJu
         kMIg==
X-Forwarded-Encrypted: i=1; AJvYcCW7WBwD+tFx0grRAjynoaB0IkxqVJutoe3oVppuWJ3LvCaLdEfaoP2aVG+zkrZLAEaJFBplxolT04bukCKQZ4xmd5JxI4Fi4//VMoNxPUDtLr5xstDaajONWHk2onQoCK4=
X-Gm-Message-State: AOJu0Yyf5u23JY2VDXZ51h9sww1rxH8JHbei9/QtDyXR+caxuOpssIa4
	6Ma6Hdamsc/qZ+p6fNYfUUjK6iAiS645glGlWDMOWCH8X4lwkOqC
X-Google-Smtp-Source: AGHT+IHYABkLuOzdNK2uCdOx796LHPLBOc0YPOixhkyMY3ZXUApL9sC18PGVyQfko3C0eVVqjzvoXQ==
X-Received: by 2002:a05:6214:29e2:b0:6b5:4249:7c0 with SMTP id 6a1803df08f44-6b54249125fmr208270706d6.5.1719594234720;
        Fri, 28 Jun 2024 10:03:54 -0700 (PDT)
Received: from localhost (56.148.86.34.bc.googleusercontent.com. [34.86.148.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e563230sm9433006d6.35.2024.06.28.10.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 10:03:54 -0700 (PDT)
Date: Fri, 28 Jun 2024 13:03:54 -0400
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
Message-ID: <667eecfa17379_2185b294cc@willemb.c.googlers.com.notmuch>
In-Reply-To: <e128f814a989914c27318dcbd8f8c7406c9b9fd3.1719190216.git.asml.silence@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
 <e128f814a989914c27318dcbd8f8c7406c9b9fd3.1719190216.git.asml.silence@gmail.com>
Subject: Re: [PATCH net-next 2/5] net: split __zerocopy_sg_from_iter()
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
> Split a function out of __zerocopy_sg_from_iter() that only cares about
> the traditional path with refcounted pages and doesn't need to know
> about ->sg_from_iter. A preparation patch, we'll improve on the function
> later.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>


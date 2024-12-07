Return-Path: <io-uring+bounces-5290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCBC9E7E35
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 05:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 919BB16639F
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 04:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC0138FA6;
	Sat,  7 Dec 2024 04:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTDDRcT7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BA52E822
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 04:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546018; cv=none; b=skfbjj+CUJ2BILTjtrlETD4mh+HCi03QnEtYZhED7beDJAimVCTr/nhf58HNq3Vyc5+QFqpRi7a6cHnXC7jZKINV/GOket3kRO5fNuOPJ4DohiIp2E3kpIUmeZFXfJM/Wx6+nXDH5q+fD9J4zPomMJWN4toAE5AaMH1bO8zgWAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546018; c=relaxed/simple;
	bh=MqMMIGxYbYF4+DRo7FNW5WJTo6sFyFp0T9m21NkHwfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t2MBa3y3Nh9HZ0rxzKdzf4/x9hqdSQ9YoBUPebYgEM7F0H1lF3whWkUoVMhOWyQp1KJxztfe3+b6z6kp6woREOidZ5G1XfNca/YpbEXpS6Lk7aMXPi8rD0FG122mOOoBmyhLmRRebukAs3paxman5kgVksTYKE9Y0/ek1zSYQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTDDRcT7; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9e44654ae3so441401966b.1
        for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 20:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733546015; x=1734150815; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MqMMIGxYbYF4+DRo7FNW5WJTo6sFyFp0T9m21NkHwfU=;
        b=aTDDRcT78bwjc+7z4U4uHj7Sy6ZCEMzLOtQOmekKHGe0AR0ahWOPbCtqvRTtVXECR7
         lVsxgy6dyk+APdhdPXVuMVEMqHcSnc7LBIh3givX/Hs9h+giLlsRi8xkY+mBqX7CPP8j
         foAhAK/dnmZLEyMi/sZmvUCb8pWKL5bHtGG12IDXut22jUFeiYl7G1xFh9VXrosiqDWr
         wtwJ3uqRCxKOZvtwi60o+NKGlzqXJ7cvHtd1oL2rowJqppAoP5kLETHZRWrYw0e1F7ZU
         BFUmDNCLp9xMb2XzWFQJCUxkch1PZoLZEZXM3DZ+9xaXEEYZlfjk95XvK1/P3NR5yExo
         92Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733546015; x=1734150815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MqMMIGxYbYF4+DRo7FNW5WJTo6sFyFp0T9m21NkHwfU=;
        b=hljRzWhaNHR12bl7z79FL4URYQOBGK3+r68NjS9RM9JaIH/dHeYXy/gvzt8GXRNaTt
         FQfTxixAWtNa3Sq4UmZhANaIfeAaFRWDPejxWK7n3b9ynia9AxFPE1if0P3YevT7j1Vx
         mKiKCsbpwYIckMX6U4Fo48Rbfz115VqzBLV2NjLzVFg7CDOPA3M0tYlgznq2+Ervdrvo
         ey7NLyFJswx8qwChS9mtyrv/To5ylwwDKyutnN18LsM+sSkvxz4NPggf6cezdxThZ1wg
         JG8H9cr+iEO6XMfjTrJwkjGqGgfhCUUKJVRG32vOhFEBafKPs5XjdA4fzfJ6CFHV+1fJ
         jRCQ==
X-Gm-Message-State: AOJu0YwHbzR5n9Zh9Utf5yTVmf8CZGjjP0CKIbJi9EF/NjWKIMxgycUd
	j8rwWMPjte1Djin1NnjdGd0Yj27vJ1AEQz64gA/5Wsw8Iwxa3GFZ4ttxVY07U2MsAZ1s0XzsemL
	D7o+pW9TmlKa/aRR+PRKBXwvy3w==
X-Gm-Gg: ASbGncv3LW+V3vqlLZP/M3nPoiVKHakXFEka3XilMvdOgcKqu2wEgNMpoM2hmh0t9mI
	uMDFvynoIo/pqkq41zEoFPPnqx7uA/uD2NnFiPrU5Rd1lY7sePNazKC0NXNeilg==
X-Google-Smtp-Source: AGHT+IH0jTV9cRshdCyNhCnCQvzaVBReQt5Qjfb7MH7iopBiES4/qRMs1p3TIiybbuwCZmlxRg0auz1JXUrXwKJlPnY=
X-Received: by 2002:a17:907:3a0f:b0:aa6:3f93:fb99 with SMTP id
 a640c23a62f3a-aa63f9405bamr415767566b.36.1733546014802; Fri, 06 Dec 2024
 20:33:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241207004144.783631-1-dw@davidwei.uk>
In-Reply-To: <20241207004144.783631-1-dw@davidwei.uk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sat, 7 Dec 2024 10:02:58 +0530
Message-ID: <CACzX3AvtPS-GZ0z1LdL7NJAEzOdSguMtqX56rnzjDzfbU6TKjg@mail.gmail.com>
Subject: Re: [PATCH for-next] io_uring: clean up io_prep_rw_setup()
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Looks good.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>


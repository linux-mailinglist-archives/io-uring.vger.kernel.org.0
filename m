Return-Path: <io-uring+bounces-5565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3DB9F6978
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 16:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2D6F7A1673
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 15:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552E81C5CDD;
	Wed, 18 Dec 2024 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPZ93I+W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9361A1B424B
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734534528; cv=none; b=IGqRNNemUqOS/LtGJeEfp9caFhBjeGPptNv4SY/5BvMxqGLy4ZB57YFSznFOdJGT9zaG3osq0b2J8UzoIO1nATUWozF8Rd1L8nDqw9Zb81cBVAySWRyH1oS9AeVItMg92XvnSeXZXM2y4oaP6U9nb3HRQtpbixE3SZ5KUOzRAfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734534528; c=relaxed/simple;
	bh=2IobWro8Y20zT5lhzrcnBd6Vkq66vwV9fdn+vLxw0Xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O7uEonsyBjipCYbtpvvYv7rS9JZIMDaYJlsZTdvwyy/O4CZ6mKrBdC5B3hK+yFAl4/q61E2pC93tNMfuOuR7uZk4zF3Q8oL0b/OWUgJJKhwTmNco/NE2RzAVt6t+tpalVveZST7Uj1YcCK15tfJmJazHDE3bjTSlW9OIzW96v0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPZ93I+W; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d0f6fa6f8bso10486817a12.0
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 07:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734534525; x=1735139325; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2IobWro8Y20zT5lhzrcnBd6Vkq66vwV9fdn+vLxw0Xw=;
        b=lPZ93I+WpQ3vigp+dF2BXdusIFlv+BxIE4KZlqHiBVwC2WPW14gswGAjg9cPUpBf2u
         5MzBGooiMpKtjYWIyoIei7LTwQkk1ey19F9tOW+oeHAYSbkoqMoBCH1Oik8Exw4u24KD
         hSkP9mLLEGe52/pr1ZLlr2FgMzeWQwt58rE70dSF6ws0vliqzCuTiPD8dzzPGU2OA01d
         Vs/uGHL//X9J+AjfYZy7tEKLx9skSf3mpjux32hUp9hi+24HGw/3cWJzL+0n/77JiHsd
         SZOxcH3syXrIpqayAAvpmOwws8S1b77ysTZYJp1QLIuqtaDL0oBn0r+Z3SdOnSIOpJ34
         jnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734534525; x=1735139325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2IobWro8Y20zT5lhzrcnBd6Vkq66vwV9fdn+vLxw0Xw=;
        b=I+Nl/T4MuUaJWG1zjNYtF5Vyz9coRj0g+v/JHVsHl2m2/1rBtuDsJ5kSb5CN4oyPyu
         C504sz4BxrwDWaYzPyech4Oeg+z1KSRfmFHLN78SKQj8RBqTKaOQG/yhNUIPL4bLQnQh
         rlf2tunZ7ApGFCbKD6yV+HBQ5B/MEhwze6f8PQfO8zF3FMYcUGa3BdgrLySWmdWhhFKj
         itCm0EXtiMsEKYYWPhibAhbP97yisf7MeFL22NNEiGVzS+xIH4QJdHyL4Kqja9nTqRx7
         4sgX/ETp7rwCvG6fcy5MfOkf+10m5lM7qgtrj+SdJkYtEI/peadhFQXaCDU/WdWYjts9
         Q7Bw==
X-Gm-Message-State: AOJu0Yzb5SHWWaQA02SabUnemQ343kxChwCNBr+eCvFBM4yVgfhj4Y+x
	+nwJuhC6k9kB8WLWRoOnjHefWMyMEADXK9AWaXMoEgLjhK0RnsUnDpzmJOKnU6+n0WjRxEH1/Zv
	271637la4VBRcQwLZIdhU8GZ6Ig==
X-Gm-Gg: ASbGncte0crqU8/xsfHP4rlvvBi2XSu4DlRqQ5BkfRxSZOJYCHUsOKC7F/HA8q5ej3N
	u5R0JeTXFqgcMjO2nuCxkPjU+WcEva2UYD02lgTfHZ7d8z8//aCKXMgcWL60rRIwIFFxm
X-Google-Smtp-Source: AGHT+IHEh88+eFZUT9yy9FbQGNtBPRyirycD31/BlSJrU0zAqBAsiff350TIfXAPnyagmINiBUV/ZeLpQmKYKnjETRw=
X-Received: by 2002:a05:6402:26d0:b0:5cf:e894:8de9 with SMTP id
 4fb4d7f45d1cf-5d7ee376624mr3186230a12.3.1734534524548; Wed, 18 Dec 2024
 07:08:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c89cb7e-ddd0-4e22-a04a-4579855b52f2@kernel.dk>
In-Reply-To: <1c89cb7e-ddd0-4e22-a04a-4579855b52f2@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 18 Dec 2024 20:38:07 +0530
Message-ID: <CACzX3As-h6+=KXm3mfJ6+9ScB4EJKad+4phEjiTPY-e0t3ndGA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rw: don't mask in f_iocb_flags
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

> The identitied commit breaks test cases which end up reporting -EAGAIN
> rather than just blocking/retrying. I have not tested this with the
> metadata path, so please do that...

Tested the metadata path, works fine.
Feel free to add:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>


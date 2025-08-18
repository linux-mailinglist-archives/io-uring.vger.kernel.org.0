Return-Path: <io-uring+bounces-9046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1FFB2B514
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 01:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98E145231E7
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 23:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F292737EA;
	Mon, 18 Aug 2025 23:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kEjs35mY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D71A2547
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 23:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755561030; cv=none; b=eJdlPhx34uYKR1TT5M2SJhElCYJARr0FQfMy2KxxrCBYkN8/jxXoJqq9uyKrTi3mnycYhbW6WBwYysBdK2h/kUL4b2XgRAklmQI7VGWTfiGqpc1316Q1MXNqXnT8YcKSQlPZxVbl/9YSVaspsthe09tNeyiERwSUbqjPUZg8bME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755561030; c=relaxed/simple;
	bh=LcsNuZAmmSgBbn7Rx/F0jKuldnOTvv9gOB0r7oIHRPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fiw/b614HeKVxeYBpNphzKFQFN1E/SK6DQdUqp5ZmH3/hJu6Go1iK1klzwmeKKveOBm33G3qVlKtEYa6TjXI8FX+6HQ/CadcCpkbjwWS+czSn9Z6/OoUudT2nsxe1SCI7TAF88O8sI6F/UeqZfMJKSG6aJ505ZA/C0e/lvVx5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kEjs35mY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55cef2f624fso1981e87.1
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 16:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755561027; x=1756165827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcsNuZAmmSgBbn7Rx/F0jKuldnOTvv9gOB0r7oIHRPo=;
        b=kEjs35mY/abuBvRXcO10QPH8S6ZRk31NPSrdR0MCCAQkyIIOAv/SfHtJ4N/US1LPef
         i/I8jM0Mhxy1gBQ0AzsabvyDg8xjtqck/Nfh9Yx1IZv20xHuokHS7WLRbTNmYN9BUDil
         xwh1f8zGh7cEjQhwq8p8n1PGZ+HMFyvCqzZXCYhunBemhUojKo0yfHyFOvzj2McBqINc
         pPrxjwXNu381/fHTr6R50CLBIJfn7UBbKeDdUxmyAMpMH38GONFiZwgjtAgwDkj5PeA1
         Vz4vhz19VZ2UESv8chQbJ0WP9FyBv1m5C8qBhVDMHHABH9RQd8c46T/ZJ/8Guhbqvf5m
         Y7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755561027; x=1756165827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcsNuZAmmSgBbn7Rx/F0jKuldnOTvv9gOB0r7oIHRPo=;
        b=sJ/mVNy5sDubiz+MqHr73qjSGz2WXtZactjJ+NT6QyAqmd0IpoB5fgnACopmXYb2sP
         FRqv1oNkzWD8ykUJdLoQmxBYJz7SsaTI+hN0tdzqBtojW/+eN39fucNkw0o9vulSZUVs
         B/Wu4q4ULMYsRZlwlzdq2/O/ddS2hFQ+GBafq5/EGrA8ZCgC4ubB19Tda0NRHm3ANN3/
         af4EbYnpu2FAwfpD4J5OcU9h6KSwdsAvoBazHxdOFyvF0rVbmd+PooAaX37p/j57fweC
         RCKL3IRjl7jxi4GBGMaQUxgWzE3yQIZACl2E/z+QBpCk7udj9Bute/oc+VN2DkYGOTTM
         TRVw==
X-Forwarded-Encrypted: i=1; AJvYcCULvguxDCjWyPt+dn9JogLPuNsotVPTsOuKKdVE8xroteMa0b4exkjua/yLyE3x8GsRSLunYEY0hA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvpsu1nUulfnmxCS5mcLv07kSEN8VAoytYdQCD7d3XRCzC9/QU
	sk7VYNdg7lByB7vupa0OHhEw9gBqR42mVcpA/fT+eKfw7BG4V94A6Yun0i3sT+sxKW4Tlo0BZqx
	9U6SFpz3wXwnyOYzoaHu7qW5VpjJJthztv2BC4yS8
X-Gm-Gg: ASbGncvRORfctnFR3Eg1K8vkYIPVwm5uUCEeG5owj6co/JdvhMXuOdzPPBpPrwz7/lX
	UKHXdBZz7l7eGbNNCmg8jMB+TXQToUALh3a4JKSP0W+K5e7BV4m5UJfy+xvJcGX4GBap+n09P/M
	Z/pv9rC5OHG/JjE6C+yOupi7rwwueY3G6X0An37stzidyw3C7OZgnt1wMoLAhoRV3tSQq8oJHW6
	86euiqwZjyXHKrNC2WtJ5rsq1o0kymKajrO39WC7mF0
X-Google-Smtp-Source: AGHT+IEz9461t1FLeYjqAPV9IC+YLeWd69snIPkzWT8jdh/N0oHfH1jree3Vr3yZo117hlh5lONNshD+tvF4WSbIHxw=
X-Received: by 2002:a05:6512:250d:b0:55b:7c73:c5f0 with SMTP id
 2adb3069b0e04-55e0095dfb9mr92067e87.2.1755561026720; Mon, 18 Aug 2025
 16:50:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <353e0195a0f44800c0b5aa4a6d751d3655d9842b.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <353e0195a0f44800c0b5aa4a6d751d3655d9842b.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Aug 2025 16:50:14 -0700
X-Gm-Features: Ac12FXym-AdI0-6m9FtombEI_KXbKYd4WM0Qi3aWvTpPx0DSoGpMt0F2tRTsGrw
Message-ID: <CAHS8izNEVecwoh+f1nUBmTOGHKS+A6Up8R-0KTFMSwPn4+VzdA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 02/23] docs: ethtool: document that rx_buf_len
 must control payload lengths
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Document the semantics of the rx_buf_len ethtool ring param.
> Clarify its meaning in case of HDS, where driver may have
> two separate buffer pools.
>
> The various zero-copy TCP Rx schemes we have suffer from memory

nit: 'we have suffer' sounds weird, probably meant just 'suffer'.

> management overhead. Specifically applications aren't too impressed
> with the number of 4kB buffers they have to juggle. Zero-copy
> TCP makes most sense with larger memory transfers so using
> 16kB or 32kB buffers (with the help of HW-GRO) feels more
> natural.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


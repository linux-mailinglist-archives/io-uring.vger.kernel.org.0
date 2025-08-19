Return-Path: <io-uring+bounces-9087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5A9B2CF80
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 00:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F766724BA3
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 22:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913AC23C516;
	Tue, 19 Aug 2025 22:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDyvCsyk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77E202980
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 22:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755643776; cv=none; b=U4nOUCRxIg2HPPZFR5jfrmxiMlO7HnHwFYjfyJCvz6GITsAe1lH6A4P5QGeFEA0m68jDtcuyf/HZOI7NanQ1IAeJDOOVt1w3mmy+oVrqjx8WIzIzv/QKu+kVj7Hspn1nCh5RHy1RzdUmndtDPWXIUtC4uIw4Au9EjN/IWj/p0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755643776; c=relaxed/simple;
	bh=fvxwuSCfRSD+twSz5Gb0eEyXaCFiz+gsVdWdoqPh9lk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FXQoA22nXZ0b0FPKiJCRzveaBT4L7qAXbBKxWMI2UwxUDmM+mGV0Zk9+MJhnlXNk+JIlxb5ZeCoe7GlbTR5wp78EPSfxHvngcunyoX4GlEKMORWqUzDy2Lnxy5YkbkLp8sIl/SlISOl1aslpwwxNRxVPtCwbNcAWDBEwCvH1R0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDyvCsyk; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55cdfd57585so1004e87.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 15:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755643772; x=1756248572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvxwuSCfRSD+twSz5Gb0eEyXaCFiz+gsVdWdoqPh9lk=;
        b=iDyvCsykgJZcsYsXTohLvX7Ylc1S4wklpRgAb4ynFcENavI6NxuxPsVrXtCOCbu9ey
         foMfJJVbT6mXW3hdUYt8BhHl3/DIe72aXhfZ9Wd7IkLfCAJrM9CQgBNPHtRjEuUeoJ5Q
         z6eocIeH2oGMdRsYDfbWZd5DtgQr9rZWCR4NLHzTu75V0QGqHXHpkl6MYLVxy/tYs5dh
         9xu9ziiK51RjVCTgDeDmz5q78SwNGFlCQpgLh2YkTW1kbvrgc17SFeNYvs6salU3dC5h
         hUybR4tx+0LPa4MKKKA0ZUalYimaZJqXqPHr/LSK1yX+LJgQxJ1g6mKtUvkYmseGhPyn
         SA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755643772; x=1756248572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvxwuSCfRSD+twSz5Gb0eEyXaCFiz+gsVdWdoqPh9lk=;
        b=V7Pf1PfeEePKTo47rK0AmQ7dcYF/2Ywdztq0hG7ezXKOraS5/pb395n5ossSR6ajXi
         TnWW5NjcmJn0oci5HX50D5wg3kLPAg2KGbLDhZBFGOqJ6dcC+XbQraj7SEFBx12qFnZ4
         QAmh+DEQLNjlC6bqhB2gTzFtRTfZtLGktqJXTjuZWb5GCU/GbeKcUtM9SbXtsGn+ANxR
         /s/Lotehgq2G1MOUk9g71d87hmhfibTva/J2Hq5PbGcWVSUvlEHuIPuvCkDabnFyRQSI
         htrkTebhaDcYlJHTIi5yOQ9VaIhabMb7T0fG9OfDyDhqJQjgWzA/FD07IA/3JivznY7o
         rrsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQjLkHxSzYDvUeafnrSa44bZYgrCLFkTJMUexR726wIZPSBUBXwDveGH/n68njYc3t9LuZivQ+IA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjjgESpRupI92xTzCpNlvvx9heRABrQDLcowhtGfIVSQ/wEj6Q
	na8+pXbywLbojQlzuF2kMTjYaJjjPBZHWJX5bbULydfeBzvaHNlWUZ2/OMeTlOWgPPbS/ZempyK
	Cvn2RgZpJb4TC7AZ7VxIV9eSlPv2PLYSSZiqYD/x7
X-Gm-Gg: ASbGncvwkecq0v7f1/qKS4B/R34Gu8cf1ixo8d+oKa7w2lpGP122xkXcG6utkRBe6sK
	LncDqKBZnFw98vofvAC969A6JMa9guhBcgnFyuXAcem2RyiGPI+WRrX8mLq85C5KLOZ5WIWa+/i
	ib7DsIxVUHhf5Br9t5HEhGUN4nqBf/dkMXD4xHRtakyfzWuf0qxXQl+qKhZDr2AMct4q/TkcFcG
	kIb9UB7nFY1LkAZ17tRwlBUf+s7WvZ7JBWgTPqqb8atDJVBg6dty08=
X-Google-Smtp-Source: AGHT+IEmYxxYzU8DjQH4U3y7gdcuj6fyI2P2sUFUnAoDbFPxhCsmZmBLl5HbvLkotXIKN1zE2OsjYMUqPyw5kzo6ryA=
X-Received: by 2002:a05:6512:4388:b0:55c:df56:f936 with SMTP id
 2adb3069b0e04-55e06818947mr113782e87.6.1755643771563; Tue, 19 Aug 2025
 15:49:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <0ac4e47001e1e7adea755a3c45552079104549b9.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <0ac4e47001e1e7adea755a3c45552079104549b9.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 15:49:19 -0700
X-Gm-Features: Ac12FXzsId0yCBo7YoLtpLEhq9SLD85yb1Q2qrwcLNfXEbhtrBTCgGQJ0OuhPvo
Message-ID: <CAHS8izOkTpdMSn+0kWYL=qi+WrTy7b=qARXxWjOMHWEKdHZWaw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 19/23] net: wipe the setting of deactived queues
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:57=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Clear out all settings of deactived queues when user changes
> the number of channels. We already perform similar cleanup
> for shapers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


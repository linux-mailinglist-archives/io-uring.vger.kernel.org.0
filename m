Return-Path: <io-uring+bounces-9048-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62868B2B532
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 02:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1BAA1963307
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 00:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8543C4C9D;
	Tue, 19 Aug 2025 00:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dCBBE1A2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E259A4A1A
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 00:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755562043; cv=none; b=CKPQgGiNHeK/6KM7vtulVCH1adisLnyYZK8reWHtplJz7oVmrwkodEgTDpJQ8FTcuZmjrQrtob9fik4gU6zvxhr1qfIaeRaF/HSKbd8T+Ffn5xI9Irmrt0W5F9PSySUcAsckBrSqAHD4MRE1EP2DNDkb4U6sovxcd9lfrCjerp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755562043; c=relaxed/simple;
	bh=N3pRRETvDbhldeHYBaWwj/U2MHd/CSkmqAYUU00fkCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n6XhfoU2TlxQcQKttfzTBZRGPhEooOjp5DGMEykkmmo22bx2H14N0UKXvLYyxkrmZV8g0Ccb6MuCexSrCUmurMun/RlfJe0COSZZk67TsTNIL/QqHh8reY4cmtFgE1FCCsgIcAuZVl6gjRMxo6J71crm3Oz4SB4GUXEJj8rFqlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dCBBE1A2; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55cef2f624fso2062e87.1
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 17:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755562040; x=1756166840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3pRRETvDbhldeHYBaWwj/U2MHd/CSkmqAYUU00fkCQ=;
        b=dCBBE1A2MlkuYtxvbmUansJU1Cp7lGhUCpelkoEIbwZIpEUotb9TzosHXI0arG2w7y
         d2CnPU/s2yejoJb6U+HdFxoTAnxOnKWXnuS1Eafb1J8oOKrwYPaslGIvWWlBhLTSarD7
         u/LdkycVgXdTi/A0z3DO9QcIG0wirxP1NG9k9fd+ZZHjdWsGhU14opWx+P1QIrDDtoiX
         Sk2KLyGt/1Kb5btcOOmC+zJOEPXbWfg4kXI9t9oHxkUkVVNypFh2GUvcG9EGrU2IZVOU
         MnjpLmhE7Koeti5BjzbqRK40qL7wgdyZpVZk2LoU5C8NyeE7cJaQrBj32Lk3zQJP7gkr
         F5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755562040; x=1756166840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3pRRETvDbhldeHYBaWwj/U2MHd/CSkmqAYUU00fkCQ=;
        b=VO1DlZvZIOV9ovbhkZEx37eap+hcPJG6vcM/9ioMf4igrSDGGPtu/G02Ng4oClOcun
         AD/3hYRPxEPiHoJcR2/+Uz63ASdUKU/IhxaGbmlOf08p66mLwS1Z+t0O70Bw3hnYJqDv
         RyJ5sqc5AZj82NTz49dFSO7EJ8B1+u/hJCro5XNbqwOqN4d3xOO8c+EG3eOt6Q4v1QpC
         Y+u1vi1gmrtyNlDvZ9BKidUu0zQRCsSkGxQ1bHxZzx1J2Dbfafzx14nNraxK6dIyirXs
         VSg2HWEs8S9K1dMmEPzM00lYB3suQuRB3ihiS4OLHLdNbkwFLSniuM/MrQW3rhjmQw08
         MAng==
X-Forwarded-Encrypted: i=1; AJvYcCX3ekK0UvhAZuoXa7guwmidvCX4An4k4VLb9v0wzjPhBHakw2HJukaj6LPvWxXgvcX7TVUsZs558g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwViveCniyrmBgbjs745Il8y+6ZxKieeFxa84+uho9En920Jkpk
	BbJ4/5NSxkdMze1rFu+N0zCn6Br1v2Bg5MekfGMwi7+7/x8fi2jmyp9tuO4+J6Bs39FfvaXT94M
	PgeqercjAJ6Laj+vYEFmugmgCe0KQgRL7IIBQxbvs
X-Gm-Gg: ASbGncufnsMjIXUJp2NljAyFQ056OkizHrqlZn9EhBn3SBtjlK/gKgmeofv/4A5rxts
	3IYlJQO9p1T+wpmeTjrLKV/bEmL7wbJqPhTk2w63BpDI3Z1QqfYx6sd/i8VXZBfSAiiqmfn8NuH
	IwZjdBdqF4zwwINHde000zkWO9nTFfzuSSVUbjdzOpa8Wp2uw8Me5r1D1lGsK17ki1kZUFk/acq
	MXO3U+qpfIdR4UWp6B+Yw5O53G3mq3i/9SHGz0A42W4jcQ2GJ83TI0=
X-Google-Smtp-Source: AGHT+IH8QR9XM3HVwygeTPkrgKju8SNdrS1lWW8eUw7kKiB8f808XKy73VlR0zxzRFL1iygyhjeNQ1MNS+CqwEdg714=
X-Received: by 2002:a05:6512:e86:b0:55d:9f5:8846 with SMTP id
 2adb3069b0e04-55e008bca39mr96231e87.0.1755562039838; Mon, 18 Aug 2025
 17:07:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <d36305d654e82045aff0547cb94521211245ed2c.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <d36305d654e82045aff0547cb94521211245ed2c.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Aug 2025 17:07:06 -0700
X-Gm-Features: Ac12FXys-FgbC9QrXib0NwGDYjFEejqhlssYCN6AMvN6gxmzcokZAnqcu_SvM8o
Message-ID: <CAHS8izO_ivHDO_i9oxKZh672i6GSWeDOjB=wzGGa00HjA7Zt7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 04/23] net: use zero value to restore
 rx_buf_len to default
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
> Distinguish between rx_buf_len being driver default vs user config.
> Use 0 as a special value meaning "unset" or "restore driver default".
> This will be necessary later on to configure it per-queue, but
> the ability to restore defaults may be useful in itself.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

I wonder if it should be extended to the other driver using
rx_buf_len, hns3. For that, I think the default buf size would be
HNS3_DEFAULT_RX_BUF_LEN.

Other than that, seems fine to me,

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


Return-Path: <io-uring+bounces-9047-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A883B2B52D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 02:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 463503AB413
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 00:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0311E5714;
	Tue, 19 Aug 2025 00:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ptk8UqZQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F48528E
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 00:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755561630; cv=none; b=KDImg+28SmBM7n83BKyySb6v/lYBS7ICHRgI/jrFHo0vaR6Q0qurqGV+acMPV/KiPaYQ0DQExuNzpwFHsd+ilhFkhCZsbRH3yT8XhAsgz/hNF8nZSwJSPWZMsrpUPQ0IDrlGB0JppB7EgCocGyzEvvclMz8CjV+fu58w5t4FnMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755561630; c=relaxed/simple;
	bh=eVGtw0RifMH4dB6Opi7sPhmBoc91u4F4OTi82OGM6p4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pLh+sv9xtzlxOvlTmWOY+YpxWhh5/2e06iZ8T/tQfv+ibmD0j6TjyIyR6w/wFd/Gp+2+P0ZObvzo3MWYRyp41XOtQPpK6YrShYp4imSY29ZpOR5+2Lz2tOb0Csw4Fpnb8r9zvXXcKAJqPx8l/j2bZCkVvfGXjfCbZ2R6wtCxhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ptk8UqZQ; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55df3796649so4241e87.0
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 17:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755561627; x=1756166427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVGtw0RifMH4dB6Opi7sPhmBoc91u4F4OTi82OGM6p4=;
        b=Ptk8UqZQFh7GWEjH3RZOwJddEK0mC5FrBAa6v5snwrpGjprloVaf0kJNgNLO/RrdNB
         OeY7mKaLFgLo6io7HK7BY3CAwoQstG6gLXUXRzm5Z+4O4L3UH1rekgDqkgKTI+u5kfuH
         mfNlSBUpjxvQInHfzjEe8UN7r6JjyCH5W+h/1TvX6GTRjbVhajYtS9GWfOwksyf8R9jv
         Ps+3IgKbzK9vafogJo8zEtARe5lFMJUwZRZDS69oh7tKPMhRHLHQNpvnOlVRqtIR3X8o
         Y+5G7SdJ+TrWi/9t6NjlpuR3pto9JXGcfFhUIDuJRG2GNxN5lpEkmaRfOSnnrXOBucx8
         yIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755561627; x=1756166427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVGtw0RifMH4dB6Opi7sPhmBoc91u4F4OTi82OGM6p4=;
        b=GeBlPF4JaiIclA4XY45ps+Q0b4v2C/6l+g5EXrhJDOaKpW3XKdE1jzJFnyQpvPUoBp
         Y6v35L5+s51/8WPMKi1EfXhGW7Zmrf2B4NFzWFKdEVh/6vduuZBFqZBnhc9L/oR5FjcY
         WApqFtzhzI7mfLGOLhJ9rUH5OcRGRfuDRiThshq4jQ2rQsZRjzU0K8rRoKTBXi4F6nMe
         eK+rJbuQoLzCWPCrg3Qu2YR/XcpHPFzHHiauHUNdxcRCNTZyUpyj2+bjbrwS5XQvF6Pp
         +kMeDuoWwXvtx55sbV3S0Tx0NWihpzHnEs975t401q/qoORUM7ip1P41/JCc9SImsdH7
         EHMw==
X-Forwarded-Encrypted: i=1; AJvYcCVXX25UF32jzB7LCkdekFDGf3u1YAqx+hqdNmqz2/NQuyIgNEi7wjn2TySJhmyhbr6Ek4MzVuN0CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz//gwiU7FS3FX4DBsTCJ/TnYrOdiZ1qKkaa4ve6IlBzRxc1XQ4
	xIn5gTEBAT59J0INyznWvsxg7vuTxBd/6DHvAIWHHtUSgacV0NukQBFWGetWHHz3n3LeD2a1jow
	p0aw4fBCvdQOUrdl2O96g8BZwicWrjhlSzs095bKw
X-Gm-Gg: ASbGnctZHdTPYFVRJ4VyOAYAwVPqEw882OknPmBjk+1KAW19BaHvfiqj3bObkyPDzcK
	f46xjJRH9IOYGKRIwvsfUfgtl2xjV3PF4X22H48H3X+/f62f/D+N4LjFGTQjuMI6PSGo9MMbaKk
	vlA7omzuHiVb0j6n+5rJSNuQebdhkB8PRx31YMXU0bkaWyGl4B+tBQZtfNp39qsx2101x9oiQDH
	QbhzHtPEANf7yVIN1kn82CIfXVNUxHzgI4btrL275aT
X-Google-Smtp-Source: AGHT+IEZEaETdAR6zcqYMOSJMAOQypdk9OIqzaXxKsBGtn0E30zwjU1WLFWapWhBelD0iYBZ0U99b4mUlXJ5fCSa36o=
X-Received: by 2002:a05:6512:1092:b0:55b:749a:35b6 with SMTP id
 2adb3069b0e04-55e00c43a89mr47660e87.5.1755561626616; Mon, 18 Aug 2025
 17:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <d25ecf7a633d5ec6d86e667ef3f86a13ea1a242b.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <d25ecf7a633d5ec6d86e667ef3f86a13ea1a242b.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Aug 2025 17:00:14 -0700
X-Gm-Features: Ac12FXwnRiB0WNJpRl44QeJvz_0GJSGinfE7h26oEfh-sETdFXD8uKnYn5wG09w
Message-ID: <CAHS8izPyDDxtDM4KcnuHzr0BJ3WYd1mv8gJEjG3zAW=Va4yG0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 03/23] net: ethtool: report max value for rx-buf-len
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
> Unlike most of our APIs the rx-buf-len param does not have an associated
> max value. In theory user could set this value pretty high, but in
> practice most NICs have limits due to the width of the length fields
> in the descriptors.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

The other driver that supports rx_buf_len I think is hns3, and I think
you can set the max_rx_buf_len as RX_BUF_LEN_4K there? It only support
2K and 4K.

Other than that, looks good to me,

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


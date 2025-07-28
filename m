Return-Path: <io-uring+bounces-8845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81868B143EA
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 23:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B69DB3A6AD2
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 21:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5167F23182B;
	Mon, 28 Jul 2025 21:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfcqf1bU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBD1E5B7E
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 21:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738613; cv=none; b=pW6KUAmdLLgd0Tksje0FNIjVvuO1P4uWac3mj13Ynn3zBJGrk9ElNMK4xnxHlToQvHBi3XvgP3NLHc6ijAFp8dNXFqwVHdnUfdjyrxVz+9bilhGQsn+mYBvnB+Fr28a3RcjJbtypmOZ9yM5L+R2YxOz9mMchnfcBxnhX4aRDZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738613; c=relaxed/simple;
	bh=pC6E4e1pFw5Tg1h/Wcoj5h/fhySjlom44Y9GCN3alPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ODzw3cC9rfSCW+kkW+B1okwJQm1RUA45uEbdklxiljdiFaBGpRvjbjm34rpDu1cZ2AipifHR8lA/Go8307FGSQSEMH63UFKlDpd2RokvSu2T7asP9maMewy+z2Ftvqb3N+f+ghXpTKURcyovyTDc+D4R7y6pYWvveUWyG6fwGk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfcqf1bU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-23dd9ae5aacso22935ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 14:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753738611; x=1754343411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDWYEx10s7OSSw0WiXrQw0XUOuryeX9JB1jzqOHkgiE=;
        b=pfcqf1bU81uwlqFhunZUVxYACIstSPrQ0pjB48BXXYSuu+KmpEpxxaf8k1YEzZ+whl
         QaRmPA+RCTdKNNp/2jLKTjiJNhwZ4bPbA0HxeLlps+u180P3otCAkgrBwiKJ9TeCo6Q6
         MvMoWZB0bBqGINlPKKrY/Xj6Ji9r+0rU8sme5WKmz5ZMs9Lt2JNLye973SeLjtj7vUsD
         a38FXWL2D1eFx7YHiMAsi+GQusU/RhUWvRODTxEcBvXPD5TygrYJeEZGXoFXrClgcWcU
         YKV3VAiWvx2/lr08QZBRWsSQbqFSTzYU/Vn6MudEDyNhF7fRbDNr+KMfvz664Yk3jE62
         54Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738611; x=1754343411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDWYEx10s7OSSw0WiXrQw0XUOuryeX9JB1jzqOHkgiE=;
        b=DeQ9OJBluGdCYoHuggnbyI6OVbUpmcIWqhr/O9mICYOGIvqZy95XaJ/Q7T9GrgnmkL
         jSTVJKmLlIsYerSvZWr7lmdzjMFy+87BHumjeW4hAGnZNgFSKyM3W0KhBxwjX0q/Wman
         Il9aWH+iExiWYfnwKIRugQEeQ5y8tz1dIsqCpVWnkaeozAMDnrmKeFw48Nv9VMkM7GgS
         qodyY5h4u9Hp1msNCWvxVgBl2i3pmOOXsTZDx6+mgcuGY1b/AXrtqsMEnmRdIxuT59Xa
         XWeADCq3rGJi+mLBTtgDdbBetIgmmJSSOs0K3CTYpnSqaQc+gIiuqvQ3eyD+lWw4L5uU
         FUAg==
X-Forwarded-Encrypted: i=1; AJvYcCX8qLPPMnRv0PycBsjflyPQLhMEyNaiKxMPmq3YIYmvKkm3PTAVv8i5myZanLtcjoCvHHIcVoS6AQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlGoCcqFUlTsCEYurSRuncI3xXRqy1+gZmTogx8rxxSayJkVav
	aOSP76RYxWuYLCfM8FWe32y3tPEqvgKsErJUcYC1zt7rA4FTP22iZbbJXnIXNpkXA7czvFh7+RI
	xPZ5sVaB1Kffgo9cuS2JbRVSIPKtdzr6HrybtxKx2
X-Gm-Gg: ASbGnctFR51Pj1s3Gz6s0GtJT+Z+cIzrzSTqFcovrcbaAyx8l6L7S4oR/1HlsvNuGdb
	HanrnSBmsP7l9KN/MsJpTRdBv4T9tnSQzLesx5RE0HDg5oDUC1TNv91GNfPYz6J7Bo6uVJtduE2
	elFveczj0BvWSGEbxIwnMZeJSzcZbRPf3ui70GoUV6JxcS8F0FebZVFZepibDu9T1NcEKWaSYfB
	S3+490MgsFRfEbTXNftNa1FiIbNhwxFzVKJQQ==
X-Google-Smtp-Source: AGHT+IGZbqmNGqKnZe89PS8y4b0wOgugWtUZ4WIllnyheeyARKxW++bTxIQlPPWNY25d//QiZo436Mh40dBcnLWqzqU=
X-Received: by 2002:a17:902:c94a:b0:240:5c75:4d29 with SMTP id
 d9443c01a7336-240677b20d2mr989935ad.0.1753738610366; Mon, 28 Jul 2025
 14:36:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
In-Reply-To: <e131c00d9d0a8cf191c8dbcef41287cbea5ff365.1753694913.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 14:36:37 -0700
X-Gm-Features: Ac12FXwbaoeS0oVMui5KmZ2YoYCOea_WrheqAtcKIGnTrTrih6VTuiiMjwsUvSI
Message-ID: <CAHS8izN_TEY3PuHmW6czP0Ce00gfCOgUCW0vJNzakBeYRFAGgg@mail.gmail.com>
Subject: Re: [RFC v1 01/22] docs: ethtool: document that rx_buf_len must
 control payload lengths
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Document the semantics of the rx_buf_len ethtool ring param.
> Clarify its meaning in case of HDS, where driver may have
> two separate buffer pools.
>
> The various zero-copy TCP Rx schemes we have suffer from memory
> management overhead. Specifically applications aren't too impressed
> with the number of 4kB buffers they have to juggle. Zero-copy
> TCP makes most sense with larger memory transfers so using
> 16kB or 32kB buffers (with the help of HW-GRO) feels more
> natural.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/networking/ethtool-netlink.rst | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index b6e9af4d0f1b..eaa9c17a3cb1 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -957,7 +957,6 @@ Kernel checks that requested ring sizes do not exceed=
 limits reported by
>  driver. Driver may impose additional constraints and may not support all
>  attributes.
>
> -
>  ``ETHTOOL_A_RINGS_CQE_SIZE`` specifies the completion queue event size.
>  Completion queue events (CQE) are the events posted by NIC to indicate t=
he
>  completion status of a packet when the packet is sent (like send success=
 or
> @@ -971,6 +970,11 @@ completion queue size can be adjusted in the driver =
if CQE size is modified.
>  header / data split feature. If a received packet size is larger than th=
is
>  threshold value, header and data will be split.
>
> +``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks dr=
iver
> +uses to receive packets. If the device uses different memory polls for h=
eaders
> +and payload this setting may control the size of the header buffers but =
must
> +control the size of the payload buffers.
> +

To be honest I'm not a big fan of the ambiguity here? Could this
configure just the payload buffer sizes? And a new one to configure
the header buffer sizes eventually?

Also, IIUC in this patchset, actually the size applied will be the
order that is larger than the size configured, no? So a setting of 9KB
will actually result in 16KB, no? Should this be documented? Or do we
expect non power of 2 sizes to be rejected by the driver and this API
fail?

--=20
Thanks,
Mina


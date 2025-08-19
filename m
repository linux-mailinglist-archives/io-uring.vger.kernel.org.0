Return-Path: <io-uring+bounces-9083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6C2B2CE8D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 23:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B203163E0D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 21:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0EA284884;
	Tue, 19 Aug 2025 21:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zYSTnI3o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69B1FC0E2
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 21:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755639063; cv=none; b=rkTsqn8YY1FoRjgF66due14Q2w1wdCsvw0cOIpMQVS5dpPezdf8zRCcgsYKip1O0BfqZv2vEGIN/+7jNJ5Gvh7fxszT8LKqBVPA7kBAoXQw6nvvThQSAX8cYXezLKB35jR60LKl3hWaBEkeQ/j7kn9nG7l4iqfo4nRyyEojPGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755639063; c=relaxed/simple;
	bh=/UQSGrmwmn8YczXd4v1oRryMb7Tfx60LkhNyEHK8aRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=em/T5IsJXi4A3+crcLcvF9Vq8KabWKwLzhvRyNDVec8Xzr0blgAk72ur6Gac05dnSnpbtY+ag9fGDiN70rDZVYuVeV8wIpgbTSUqqurc3kj3+cjwA+QEk65RXdUsZYUDeNdLBh5Be9Cj5ESWPwsXveeEDivKMKKHnmmmzkEO5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zYSTnI3o; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55cef2f624fso473e87.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755639060; x=1756243860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UQSGrmwmn8YczXd4v1oRryMb7Tfx60LkhNyEHK8aRo=;
        b=zYSTnI3oVfFKK3nY8DKfD6yS2+e3kP9Nu7iHeV+BJ7hH6fFwVEevGnCk//QWGs/BYc
         Rp4PRy95lltrOQfXmNvxF/iT3iKT4WMHF7uMeWqstefWI8aJpaFGLS69xeKRCsQAlryc
         XkiVTFHItSWmWde3cr1lz5m38nB2Mjp92VdfE6YGCvhsRMjojIkgc9Up31YEfxCbif0f
         PGFPFc/oCuE6gEXnXtqOw8TxsH35cM0luBSAq6fhyNLobp79+XNi+zrc/rkyINFumZ5m
         GZZPrgg7fqF7kQ8Y/hfVTb62ceRZ/aNK9HWPNW4uOz+khel0SeEcOBEXsniv6/NMXCeZ
         goAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755639060; x=1756243860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UQSGrmwmn8YczXd4v1oRryMb7Tfx60LkhNyEHK8aRo=;
        b=piKhubKA6xhSQgRP6BhZyO/kdvRuFtTxepBV8kn+wM8KFF3XautlxcdSEKmANt4HqY
         lEVXj4EMP2HDwXbNpnvY+inC1bAdumcil0KrguXKdN+lz7AiSU1yG8zAXwtINYoh978B
         KGe1V9J4xawvVFsvCxHFu7g4qlsm6JLxet5cqssMiL5Al6cMFPqN9Ty9V8r8yxNDIFMP
         ea+2XCiT0YVOFTId2ZhAhksrVIU3VHh5lfoHCwn5hFh9RWeTg8314Jlvy4aux2tf9Zxd
         /cvh8w7PKCEvot5qnpZgBi/z6rtKfJo9D0HZWSkMa0CsO3FxL3To88Jb9LH8HQxoezEV
         /WXA==
X-Forwarded-Encrypted: i=1; AJvYcCXUtAeDGn3WJDUSdszYwJSJCPG1zIbl5Ua7safwn7poItKK/KJlrLLvNRBYACJofjgSTxijFY8Uzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNzq4Bav9TdDlwl7DWN9QBluhd1mjvqZnVkK3zpsrc5xWri6oP
	5fSaNNlM2iELMIC9m8L2lZnd5MQYtOblTzlyUGD+RGhk2M8ivlkcOV+n9aDm/xe/UKlFWZPuYu5
	sL2Bj5mkB6GRuJ9I173G2OPqQEtYUdtq6jReolvwt
X-Gm-Gg: ASbGncuynFwxIbx7JlcZ8C1RLS0m+yplq44rF2gxruGzHrAi3j9jlqkCGEh7a3w6VNM
	Yneem+Xvfw/PiTp0Z8G0jN+gNhOVLROohIf6hOGS0ZAjnS6PXDcTVgt05FZGAykh75LAGZcEdVD
	UBqzI4eukVW0c4xbCBvGB5KO71l44dbDW6NKjzgvVGXZOxFJ4QlpKJHiwbFshPJDNIAQdgqO7Sn
	1DJK+5gY5Oy0j8m29QFzwN5yEYm24jdfRPSsHmqQKrEQfzxjTYHFfk=
X-Google-Smtp-Source: AGHT+IGdMHPs1GsyML54rmJWwEz/UgGgdUvH4DhmTG5Te/uyjIvvo9Y/djBh8mKSRlBD20AX/zgNoduJqn/WAGp1obU=
X-Received: by 2002:ac2:499b:0:b0:55e:24d:ee80 with SMTP id
 2adb3069b0e04-55e07047031mr20680e87.3.1755639059692; Tue, 19 Aug 2025
 14:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <bc5d49dc4dcc97b4dcf2504720e9d043b56c911f.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <bc5d49dc4dcc97b4dcf2504720e9d043b56c911f.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 14:30:43 -0700
X-Gm-Features: Ac12FXxjiGJ4UU-vDlsX8zgDS9DbCBuv6ltBRKcrZz6FLHRi0lrhBZIW9GIkYsQ
Message-ID: <CAHS8izOeM0rXEmbQTfKb1RL+itS4wwH8J+pCxO4F3Adq_b-NnA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 13/23] net: pass extack to netdev_rx_queue_restart()
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
> Pass extack to netdev_rx_queue_restart(). Subsequent change will need it.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


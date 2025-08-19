Return-Path: <io-uring+bounces-9078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72068B2CD11
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 21:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A3861BC389A
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 19:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB28338F20;
	Tue, 19 Aug 2025 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BxeatVFY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDBB32C335
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632294; cv=none; b=hAzVsq3/GnFTNZXqrumJ3go2m8TgRPZkMgz02rS100B9snjow/Oale3dM9pXTjYsoms0avOsLSWeJOA0ad8O1pr1qsOwbKDW942AxneAHp/bVEXPwg1IXMSYtliZuOxL9aAuaDNy5gVpUb/yTkiQJ6FY591IHfJZtLP1wftl/dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632294; c=relaxed/simple;
	bh=KyBUNB2sq09QvdnxFRddWehNMcaYqyV73YsWqTqEkSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j8aXYA6QCiX5zwPpoVF8KU8JQrcOM3jxrnQE0LUmJne+/uYZ/D400gqMfPjvS/aJ6cB30Y5NqBDJtgCskPy/P2yvk0JZMY4giytdHHiVIPSav0ZG51gLR7GnhYa/4TVrPBkxxKDE2Qi3cnU5ctLKro4GMGYAnu+spmch6tbysTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BxeatVFY; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso47391cf.0
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 12:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755632291; x=1756237091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KyBUNB2sq09QvdnxFRddWehNMcaYqyV73YsWqTqEkSQ=;
        b=BxeatVFYwJ0DeTiGmhhmBYqyBFhikIt81fy2+Ff1GvRp79lzzGu1mbPpGJo61+VkFC
         ZdvMQpRJesWHpwqk+RroPOrAeIT31K1mmGO0cyA0Co/Fu7qGImHHd0KDJHBwc4gbQPKN
         9mxiWdJIV3MWZGoj+2pHUXagAIFE210LOSz4dVYSYkdJSIdHlEFCAWgW5MciycAmvdwJ
         BM84s7S8Y4cvEnc5whvRBWbuRIxoHWl8Au41Tae5d3Mpfz9pSE6yPqmS1/ESeUFIw0ia
         vli+xZB6Gp9t92RJO8J1FZrEMMkAjeWqspmpt47m+6wS8eaB3I/JixMp6BXQuxXMeBBf
         4IfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755632291; x=1756237091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyBUNB2sq09QvdnxFRddWehNMcaYqyV73YsWqTqEkSQ=;
        b=iUdkMiJgC17fzFqARURfhtCGjtwYFj9UZX6aiRL/o84XmCJ+8sNkFqFSwDq2EZCGFi
         HiM/25ywS+/MGsO48GpaV08eu0tXmqOmc3bP2R6wCyyezp9KwB9s96QD1+9iBPBVQOQN
         R8JQ07nt5vHltbMwNHwnSIm/j8csvHVKp9Dmf/VbQrMYIDRJQP9GmuRWVJYwE9lybH/o
         2a3WMIJ+masoomdoFcr/TFkZUZDOLIa7Wjoa7gEvE8RHZ3su0bJRJ2ITjfR1NyYPmxs9
         YudNbSLnoAj+0pbheIZoUz65s7fXh00wk6C6Pq9POub8UQfcNt839THs6d4Fq8tiBg+6
         W1GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtXJl3igfRj6JYBb+1NUsaWDCG7xk5f2Hc8I/8RqVF6arXQxI2wpNw5MPxQqA/fHI8ujtWgbASwA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1MqJe7cOZPOWqasoIOt9thF/WQqubR17G3UUsqt4bOXbaxzN3
	D3WJ/qgVjwu2J7LxRIGA7HBxPKZZ3OzJRnNpYB4P4gUV2AIYVdD7sR75ZkrrNoiM0JKWQNRgN6t
	ytjS53DxazpDHPfd7cT0qUm4QaH23VuS+wg95nLZK
X-Gm-Gg: ASbGncsiVCJwRmgjOxXUDgIMkCkvLssUm3fGw6eqVcgZvkfrzeMTMWtj7YutgCD+9dx
	tm78k/dF48QrzuGVdpmWnZyP28txDG0oiYGk0DCpY83CittfC1eWfF6QdUkKolhRRNaueLPs0f5
	RHHoo5E3cjcOXjMKlBX9zwRQma3CCrC/URE7ZSxf8YGf/0sczyjrLQeqwBuns17/TsofVtBpyTL
	+3NkDCjNmPOuq+st+thSOyECugQBxK4cUXKlN6BHDSwr3tq+DJvWghYBl7rMvOfWw==
X-Google-Smtp-Source: AGHT+IFR2/iMkStKZ0a8zzBrBpy7PAaXOuE6GtKGvb6nOuL663qM4JQSRroZMOV/Sebi5i5ZULUxa18gYqkX5fMTTAE=
X-Received: by 2002:ac8:5fd3:0:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4b291b9c1efmr693801cf.11.1755632291072; Tue, 19 Aug 2025
 12:38:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <43a256bdc70e9a0201f25e60305516aed6b1e97c.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <43a256bdc70e9a0201f25e60305516aed6b1e97c.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 12:37:57 -0700
X-Gm-Features: Ac12FXzh-xPyuuuSr3t5QlnJu8i5ZGtJ2KSJsIVV1_FY-w1P3-CyOqXsgUqFpw4
Message-ID: <CAHS8izNq8wKXwiZs8SeuYhsknR=wAwWPEnBOxUgcMhCoObQ=xA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 07/23] eth: bnxt: read the page size from the
 adapter struct
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
> Switch from using a constant to storing the BNXT_RX_PAGE_SIZE
> inside struct bnxt. This will allow configuring the page size
> at runtime in subsequent patches.
>
> The MSS size calculation for older chip continues to use the constant.
> I'm intending to support the configuration only on more recent HW,
> looks like on older chips setting this per queue won't work,
> and that's the ultimate goal.
>
> This patch should not change the current behavior as value
> read from the struct will always be BNXT_RX_PAGE_SIZE at this stage.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

nit: AFAIU BNXT_RX_PAGE_SIZE should be unused after this? You could
delete the definition in bnxt.h if so.

--=20
Thanks,
Mina


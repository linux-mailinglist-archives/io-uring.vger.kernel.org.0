Return-Path: <io-uring+bounces-5240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 779159E4632
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 22:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C4D4285CE9
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F6B18C345;
	Wed,  4 Dec 2024 21:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uytQ6QdQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D0E18C034
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733346015; cv=none; b=RG67vJTVkZ1/FQrAIFvOi7Yw2oR19JeNZxxaKjWI3KVtrItlcE9l5bFWs29xUpvfwhVtJnPPWn7WhjCglm/LX3bRXt0B5i4ZdYYQx9V7cw8hQXz+hnzYNT1500hxra9S6dTSSc0Q/t29cwxpj3ERH6rq/T9hS9aVtTBLHucgR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733346015; c=relaxed/simple;
	bh=Mu4+Hq09Af81qAStelPfifM2BedqrrH7oH/SDXWGEMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzx8slDR9Hv93vkM4Bsk9KTkJnvO/6G5UuCa7hmNloC503OwtDiBEQi7sjOvCYjgPpEc/mbRltr3Dn7Ii69N0q7ZYUp5o4L3XPsvX4aEPb9n1TE9VY+ORABHaugItILrcS/8G5CsA2z2aeQAhMBsXj4cS0NVcTB4CiBRBCce1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uytQ6QdQ; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4668caacfb2so8351cf.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 13:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733346012; x=1733950812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mu4+Hq09Af81qAStelPfifM2BedqrrH7oH/SDXWGEMg=;
        b=uytQ6QdQZvUeCqb+LWcDt3jLwV9xYmmp+fOy2YVGj2DJ8FUhR0k2PxgGb1JUlttvEV
         C55y98yvJY0l8GhtX3kwsk5muNeT33MH7wxykfjG1w8ri2kUuDdhUe4wJlNxjCmnjg6n
         aeBfP1ImbmbyHUOgFgWm0/e8il3JWKNpR3JLLJs4gQvqYDQvDlOi/N46FKxDsrGASWjl
         9opFyDj4J4XoauKrF41H9/weJ0juzBUqWQinkpThPtsDvEfNGzS9GLHzKrP8Jvscfr6o
         QCzrQB3GpvR5Z7SHl4rpNIsIg0DM9rTLQnDotmqe70joDFMJkLVJ+s1wR9uWtx1NX5vM
         1faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733346012; x=1733950812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mu4+Hq09Af81qAStelPfifM2BedqrrH7oH/SDXWGEMg=;
        b=j458Swm7u0FALPuLYWNFaVEhrTrSo7b+M9rYq/w6+WlwLLwzvcgncFK2lb20enMcMi
         tNKANlat3oVBj2kmBcWehGprR2I9dafBjhws4ihbQd1tOJxPuGUqtkv/hp/j2+RyT2li
         X0zw8+RpNXlYdjRNQyWPBK5Ge95y6wNaRFmdjekppsGQiG3BU530ysuHdGHmpSq8yPrE
         cQjmPPePIef0MKJxhKRsJM/IoJNyrPDRIIL0BzO2LqcBoziPpuNUrvPEItkATvse9JCP
         LLV/kOmurv+vR1LTVrQBhvxi2QjocdEzV/ncD6kBcACrp5f0VpRZ+KKl+6VtauJQMJy+
         Gkgg==
X-Gm-Message-State: AOJu0YyqJnwdfMj3egy+baujExldNCv/Z8JFC1JEpFz3Pvzk64KDkDyC
	UJIK3F0PLh2RJYnnsaVL2tEPiMnC1r8LhzvAWhPCstOkSLi+vvoRN7rR4FRLUluylQ8/aQ7kTIt
	4ZQ9CuuTaD44g4kPt0yjE7ysRWsOJAhICNYng
X-Gm-Gg: ASbGncvq3+YjM/8Hw+HGlJZTmTeCRUeIS2Xu04ciVi5Z3EjUJWCr9MuoWe3wN+JLjK/
	122NtA/96hSYlool9W7RaBxBZDFdfJZ0=
X-Google-Smtp-Source: AGHT+IEVcm+wR8hfrZA2nBPT1KRyOSe+vy06Rc4HRfcjCgHqa/2qsnfB/00ICUGl/r6x2oXce7DxYcFOlHa5ofl5Jpg=
X-Received: by 2002:a05:622a:5807:b0:461:3311:8986 with SMTP id
 d75a77b69052e-467284fa59fmr658351cf.18.1733346012210; Wed, 04 Dec 2024
 13:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-2-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-2-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 4 Dec 2024 13:00:00 -0800
Message-ID: <CAHS8izO=8C9nv2e0HKWA4Ksv-Hq7yoYH6c+rbZcUXvbVwevwwg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 01/17] net: prefix devmem specific helpers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 9:22=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add prefixes to all helpers that are specific to devmem TCP, i.e.
> net_iov_binding[_id].
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

It may be good to retain Reviewed-by's from previous iterations.

Either way, this still looks good to me.

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


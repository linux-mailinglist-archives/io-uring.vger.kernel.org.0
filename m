Return-Path: <io-uring+bounces-5345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC569E9CA1
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DE49281CFC
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CE01547D5;
	Mon,  9 Dec 2024 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36pxaEIn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCFB152E0C
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733764101; cv=none; b=RmuhRaH3N3Ca4d3jyY2gGmzT8F370bCcPbhRBs3QmwLJWISAJJumojhoVqIEkvcYFLUp/pRhOijLFTHeq77yWrHNQ39w3DESSaHiyiaAt6/+5NgHVmOikM1I+bpwe8nQRWpKIeUw/0wk3jq0lex7a0BXKH4mgMN3psvgjtnG9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733764101; c=relaxed/simple;
	bh=XftrnEfg+GuY0cyTaFtHNYuyzky3F02KxQKZel1SWtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HnblZVi6usd3jgF1FOLyc6qYEpNqJib33VNT6HlldcjuIk0LQAOrBjy3iJqmNcUuv6RnOrdI1cDpVUJBNmgccxmGKx0g5IEbQo8EDQKDiROxF/u2NLPt+HeQqmlb9tfDr5PTutMUcTovpgjalVd7ahlD3o4AajoyPlWDHOpGHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36pxaEIn; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4675936f333so306941cf.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 09:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733764098; x=1734368898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XftrnEfg+GuY0cyTaFtHNYuyzky3F02KxQKZel1SWtE=;
        b=36pxaEIngb5kXpEB98KA6VR2BXLM1yPbMXEC5h1ydP4YAcuMEm8ypAXeA/isw2+kLu
         g08QVVll50lW3lncjxGB8J6RkwmA17enfxhGC7V0zs/JVXgjFN50cUm6nGtAO2LIlGEx
         DktKAms6q65iO2vAX8ou7v45jRrCWz7Li527ssRqLNg3SGGW/5sLB6IFmzlatZAwPcDn
         boeR3yGLmz+j3bTvMkGoV8nBmQrQiQWQ1cfCQ85iLBQqT336R6zFBhzvpUb8v5Bxhdlp
         U9Wn6VCv85DKAQ7Q8kY8D1++g6UIHOEX5x/FnT8BdVEDvhfwcGuPeiyCvXERD2SNcojo
         KYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733764098; x=1734368898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XftrnEfg+GuY0cyTaFtHNYuyzky3F02KxQKZel1SWtE=;
        b=SYHZxlgI5UnfNWBLBsY9sMRzP80d6lDUK8RhT/X149F/2ipel6K6Gi2PC8ynssURWB
         lLpFSOzn6yDVYuR9AWBFulnaD123/gElletQaBAxUrQ/OemkhZscPiiwJRh+PZZdO/o7
         /DJRjmsVf6RbUFJNwLqX9+55sMlE+dFlM9tfa7JBkUyytMzYGZiS+JnoQiBMLfArL1x+
         DlGgOS8dZMlnK4/p1DrgMLqD4DlXsekNDD3blUJmMMlFcyUsCCU108gkidMNMjGBOri7
         u7tRxYSTWFPJfwLSRunrGEeYJnOiycGD34/QgxLrKitEDimfaidNoeUB1z92O7Eg8wRM
         FZUA==
X-Gm-Message-State: AOJu0YyIYXX+TSQOsNW3pPC+2vCH11Lnj+zAcZE+3yA1zl8SXxaWm5Uk
	7Hg7oDtaEHg/lA04vzgcnZfA+m8YYg0aR+tNau839GJ57BAV99GywFPgB7MNOELw4yrg4TBz9G8
	g+LPittho3nGw76rtI8eciHeRSUcMeeXqgPKA
X-Gm-Gg: ASbGncuYHoKC/avr8qbZCN/wo4MiRprMIgCQYoF6AjiwFXszUcw1SAvkPOO2VTsjCRK
	u/TzN0hfOlv94TJ2FiTdz7U8Iy0g5vSgjEBvllqKKQx8pG3GARNybl0TPery8bA==
X-Google-Smtp-Source: AGHT+IGeV6Sg1dvO6Ay82bghSQYKpO0qY0K+S5ujSVGXWSjhRfpqCgtwGSRFgftx2kyBpPDMxRyasb5mx4JgD0XGf4Y=
X-Received: by 2002:a05:622a:58cf:b0:467:462e:a51b with SMTP id
 d75a77b69052e-46746f67fdbmr9222931cf.14.1733764098474; Mon, 09 Dec 2024
 09:08:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-6-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-6-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 9 Dec 2024 09:08:06 -0800
Message-ID: <CAHS8izPQQwpHTwJqTL+6cvo04sC1WEhcY7WuA_Umquk4oRCGag@mail.gmail.com>
Subject: Re: [PATCH net-next v8 05/17] net: page_pool: add ->scrub mem
 provider callback
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
> Some page pool memory providers like io_uring need to catch the point
> when the page pool is asked to be destroyed. ->destroy is not enough
> because it relies on the page pool to wait for its buffers first, but
> for that to happen a provider might need to react, e.g. to collect all
> buffers that are currently given to the user space.
>
> Add a new provider's scrub callback serving the purpose and called off
> the pp's generic (cold) scrubbing path, i.e. page_pool_scrub().
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

I think after numerous previous discussions on this op, I guess I
finally see the point.

AFAIU on destruction tho io_uring instance will destroy the page_pool,
but we need to drop the user reference in the memory region. So the
io_uring instance will destroy the pool, then the scrub callback tells
io_uring that the pool is being destroyed, which drops the user
references.

I would have preferred if io_uring drops the user references before
destroying the pool, which I think would have accomplished the same
thing without adding a memory provider callback that is a bit specific
to this use case, but I guess it's all the same.

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


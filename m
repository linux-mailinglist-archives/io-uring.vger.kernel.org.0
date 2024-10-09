Return-Path: <io-uring+bounces-3529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B25E89976E5
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 22:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52473287E42
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13861990A7;
	Wed,  9 Oct 2024 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l1HSWrG9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EA21684AE
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 20:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506989; cv=none; b=qvsRrS9a31TTLg7M7Hu5YhKLAC//Hqv1KK6GEda4WDYT5wbNdPfHO9kvuQz0g0+i09dyJwBSodhTOzcfFL7UkVFdXbX6DrcGf1hR6OBnvCSAxMycujnJCuqQt78bo7Tg5GY+k7jhqZrhnmoZLg1mYhMyVhQRMoOFCjQU6mQtXrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506989; c=relaxed/simple;
	bh=+SVBWlsiC3ODodPCQT2sCAKVJ0SSJC6zb6Go5eSkVdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJQEkQG2O5leIxARknq0SnTGAoDGteXbZngLFIDGkWhwVGsAThWwBMmwyau+a6FUeTO0D9RbNxro9e15tdg6iXnwNblsbIyYcNnI6jHiYPGn1YFTZKuNstD68N/8PCcGh+IAqjSoL8ZLbBR367FQO0rZ+ykt8Kz4CDKl/Qrg/lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l1HSWrG9; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-45fb0ebb1d0so26351cf.1
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 13:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728506987; x=1729111787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SVBWlsiC3ODodPCQT2sCAKVJ0SSJC6zb6Go5eSkVdA=;
        b=l1HSWrG9H2zlRn51qJBMRxRhiyxCy3ky56WpXuuSe5kU+fhyeb4A1IJlEeImcu/YWb
         Ad2KYhDXIlkt2dqwNmwGQHoSXCJ6z0hNbxAD4SDfnwExRt6Ia+O9P7GmAmr0IqCB+wDN
         x0HIsjU0x07olyKzHGG2E4kw+WGpEuPN/eBA6rldMWmNNpjFobidjtuht3l/pAEmJLvt
         XVNsG/myiTxOGyQyRvpBcZaE7HhL4hL3zghzuHSSETieRWOsoqJCgNDlwi4sKrqqRjSq
         rAp8ZxmdERnjjbQn4APzJh0GZ7ebPqLCGcE+/IPTNR80ezb+zRXR7FmNHMvHH0VLsan5
         KFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728506987; x=1729111787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+SVBWlsiC3ODodPCQT2sCAKVJ0SSJC6zb6Go5eSkVdA=;
        b=OqXd25kLJsJYL7id1wefDNWx53vZ/CDAVeQWqJpJrQ2bHa65U/GgdOs95B4SaScLyg
         ZPAn156f9lpxZMjEi91UPHBw/QXJ4eZ+8JQKtK4uxGvq2coNt88OIDUSWWpPNF2quuOl
         gD1/QMBMEwVBHC7tYrb2VANtnUOszeNpOaOJTgTwhcWYk7wttmK40dWJ1L/KCDLOjbHA
         ZPEr0Y/nerLGyHq45lNbLW3xGeNp84hljJKSHhXToQPtQngeYQuO7U6/94jtPlFObJgD
         4kwvKY5MCg9EXrfyJq7bcBuKzEXMccOdVn9WoJvwJQV91ao7QZVHoibirTlzXT8fycgf
         aYrg==
X-Gm-Message-State: AOJu0Yx3PG8HJqywGDEAPP0QalX+792LsRYXXLbgh6YviTBpyBsY8HGp
	OosUvp3V7fQnDtiAvZATMpui8HX2K0bY3BiBoiIkF1WyomL39jWlaR78WE1LOcjozVjcXew7DGG
	J8Ij/v923cOx/UhhAfonTOBbDmfkvyzngKrCt
X-Google-Smtp-Source: AGHT+IF98ze8/OAlEOTyuIZZyZ52YdLYLQmWY4kBh8GHmx1f+JntV0iBVlFL9cjDzL7X72vW/CEyj/Y/qvuvWZw/40g=
X-Received: by 2002:a05:622a:7c0a:b0:456:7cc9:be15 with SMTP id
 d75a77b69052e-46041276c4dmr128921cf.29.1728506986656; Wed, 09 Oct 2024
 13:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-5-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-5-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 13:49:31 -0700
Message-ID: <CAHS8izM0+6c-xymAPYU3MCjq7T+ruUj0ZdxrAK7VE5yoxbGGvQ@mail.gmail.com>
Subject: Re: [PATCH v1 04/15] net: page_pool: create hooks for custom page providers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> The page providers which try to reuse the same pages will
> need to hold onto the ref, even if page gets released from
> the pool - as in releasing the page from the pp just transfers
> the "ownership" reference from pp to the provider, and provider
> will wait for other references to be gone before feeding this
> page back into the pool.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> [Pavel] Rebased, renamed callback, +converted devmem
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Likely needs a Cc: Christoph Hellwig <hch@lst.de>, given previous
feedback to this patch?

But that's going to run into the same feedback again. You don't want
to do this without the ops again?

--=20
Thanks,
Mina


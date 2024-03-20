Return-Path: <io-uring+bounces-1160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9518812CC
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 15:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8A71C23436
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 14:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB25241C84;
	Wed, 20 Mar 2024 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cc3yuqAR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D2A41C7A
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710943214; cv=none; b=E7ZRlgVBCtL9KD3EKuBqONjUBilYOypoWYHy5GJaOsVcVsxtOjYm9gPC8qKnj+BIshey241bOygnm2zm08dW4MMU7iYbRggHp63KGjL9g6shIKBsIIL4UeQdG6Ws0Jtv7mN/gdCHMyO1KRsxWQETEqAO6EnQDTDN08mfLsQD6OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710943214; c=relaxed/simple;
	bh=tlIQR3Ecdg2K3ZPSviZLrDGr2rj+ytPtqDcmsXNAtiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r9YHlf1Uzek2yD4WAUmYdazDBkyP+nTkKJ4eswMjsCaT5ukQwPQ+/oEjCN2sFvoDAG4a5/uT0BzlG0466uN8hUyjzm76YFWmtGjPW+t2EPFwb7dkXwYhK+cq+e1JJzsFhE936to6brF7xbjOqnffRYRn7PqccG3xp9rhbum+fgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cc3yuqAR; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dbed0710c74so5477324276.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 07:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710943212; x=1711548012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3214NrLqTG2L20ytWAndCoy+EbTs4fCxdVdmcc3nVcE=;
        b=cc3yuqARZs0Cb9oIQUY0/QJArcxrtiz5Ss/LWr4TTYh4Da8GwVOKU2wTGN6RxsatXh
         IXQuMnpXXxbmzADnDtBIGuBEtzslHaS1TWuEoq6oaCGyGC6f+d2mPrzqj6le2CBznZiS
         CF/ZTK4QNCv6on0DDPYLOwPAP2IZSZfR6BvXGyvW9N3XXd2Mt79F6I5/ks69DE4Yhndb
         VOpeKlUdCzPMsL9OBXv0FZFwXstYSNOcD5lmOHeL4CL0IEui0i++DaSl1xRok5knlewk
         +VfcdPN+fgTLDHnzb+dtcfj1GqHLdP320DE3zBj5+1u8eWDwsjtzMqKYrlK9YdhvJteV
         noAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710943212; x=1711548012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3214NrLqTG2L20ytWAndCoy+EbTs4fCxdVdmcc3nVcE=;
        b=MWSaVKqMaA7aDoenEZ4LUFWpQ4r7jTDJL9BvisY5DunyFcKLN9CXXZFL0x6hvp7M9X
         A7kOFbny+BYJRI2wX/Ef5tuxgwdPOPdesQQ1Lhgwo72eEt/G8dbHgfKSkNv4H/B/C7v8
         RCuYcWXM8aD/xZJig9nCmUzaqw9e9WIcBpsyUK6FbkjAsoF+BoZGgwotOFoEDkGSVaO2
         BTVdPcoAhVMwbmCivFMJqYmdzAehPKkI1cSWOZK/8401TdrkCfM1ih+BuCnjViyGufL8
         g9JKge5F4BpJX/HuoCcLSJZI34W/oPnxM5AjRsKtqPjQecKyB8qb1hZh4dnG+jblc5K1
         a6wA==
X-Gm-Message-State: AOJu0YwPwmWUSjAR8rUT2bBjrjO3sXRcfysle/bcDsaMrL4E322lGRQF
	wHlFhhchzCsTzxc626ba5ekYw5eZSC5gaCDWp/jNlHQdr6nG7ryOq0y/iKx3QZmciSpBIZjjZzS
	EwzrGvohZTvsJ2GXx3Vd1lcxsvYNSvarV
X-Google-Smtp-Source: AGHT+IF7oqIXBRIYM9qVdc/9GltN0fLWAOcLD7MMuktYJUpOmEEKjWkpU4CHVEovizwpS49km+u+2bhZxLzXkJPEbY4=
X-Received: by 2002:a5b:b10:0:b0:dcd:3f82:e803 with SMTP id
 z16-20020a5b0b10000000b00dcd3f82e803mr11757875ybp.39.1710943211879; Wed, 20
 Mar 2024 07:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7366e668-7083-4924-af43-5d5ba66fb76a@kernel.dk>
In-Reply-To: <7366e668-7083-4924-af43-5d5ba66fb76a@kernel.dk>
From: Dylan Yudaken <dyudaken@gmail.com>
Date: Wed, 20 Mar 2024 13:59:59 +0000
Message-ID: <CAO_YeohJmpk=5463u3APYjqfoDB75m6rDZtQ10SPaL7TLG_D8Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring/net: drop unused 'fast_iov_one' entry
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:37=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> Doesn't really matter at this point, as the fast_iov entries dominate
> the size of io_async_msghdr. But that may not always be the case, so
> drop this unused member. It turns out it got added in a previous commit,
> but never actually used for anything.
>
> Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/net.h b/io_uring/net.h
> index 191009979bcb..9d7962f65f26 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -10,7 +10,6 @@ struct io_async_msghdr {
>         union {
>                 struct iovec            fast_iov[UIO_FASTIOV];
>                 struct {
> -                       struct iovec    fast_iov_one;
>                         __kernel_size_t controllen;
>                         int             namelen;
>                         __kernel_size_t payloadlen;
>

I "believe" this is used in the async paths, where fast_iov[0] gets
used (since multishot always has exactly one iovec) and so
fast_iov_one is just a placeholder.
I think that means it's not safe to remove until after your async patches.

Although I haven't verified this by testing.

Dylan


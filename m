Return-Path: <io-uring+bounces-8801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89127B12D52
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 03:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFF563BA014
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 01:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8405213AF2;
	Sun, 27 Jul 2025 01:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="U+AdKmWo"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CBB29B0;
	Sun, 27 Jul 2025 01:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753578876; cv=none; b=e1QOIKEwLATXxhITZX/uc3VvpazS3HWUM2KzRU9et9LqoF4n352qPTe3aiqIyxMIXah08tMHLrsxSIwsfAUiKpHd8R2+wvrT3DdrWLro1dApmTcgdPVPd/MGNnmCAMPxwXeJuNyr2hx2gsJCXvmUP7QiuOJ7B/1qIHg1nX+UpmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753578876; c=relaxed/simple;
	bh=wzinlsoUVOxocRmy4RVmAJHPPykjrIta1mdS58uTdTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X/1k5LXBZ5k3Itz9evWIa6u99cGg1SHeEpGKShivT8GCkwY1aiwbDsYk3vChfLXLacObn6+QwVRhQL2A0wtBdYPZ82/4SBJ8gH0FXdcMaCOfNib/9LL5XlVQoHW9UwSzG4eMAt/Ww1Yb+1um4yMqxKkZTXjR6iW5OAyd7QRBO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=U+AdKmWo; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753578873;
	bh=wzinlsoUVOxocRmy4RVmAJHPPykjrIta1mdS58uTdTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=U+AdKmWouYxZo1hg0URaDWJZ2xsB6t31CEc4m2cbkahUvTiSwZGszFjsT0ykN7aln
	 zpgd6u5KLqOwvc/hpAYK1WcKV2MnT+olwoP1JDBTEnKBlH8MgTWluY1bvU6CE6rohj
	 QgaAyMrydOt3N8RFVMFThg7+HtDsPV0E3utgD74CS/5Lo31zhhdJSa/JHPeYxWWPE5
	 Faq/dLOFgijQltWipDkQGyoYMeE4kyPvTWHW69kekPsiRYqcAr4+hI+IJ7/oprGYYH
	 y9fR0TGu0AL2PXZ3HxQ6czcWEgSN69QlW7QzyDq4ajiRVQdO8PHKdcgCNCshh12vWw
	 0LeukWSQ/PoDg==
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 213B23126E08;
	Sun, 27 Jul 2025 01:14:33 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab814c4f2dso64216231cf.1;
        Sat, 26 Jul 2025 18:14:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUwsPfruhPGxgGaaH9LVaARIcyIXztj8dUzssgUBcKP2C44n3okSqGzauNLb07yT7PZ924cApnLVQ==@vger.kernel.org, AJvYcCV1itqiHKVsYNHozhojBhP3eiq4GdhgA6bjPkjXTAYUDg8JldQuY23t3ZHs7fHtuqjCCKR2MjiGsKHKdgVN@vger.kernel.org
X-Gm-Message-State: AOJu0YzZt1nA3UFcvj3DBubh3qQuAIXZ9yETeEdcwqLBE8+eh9v9EI94
	r6aIklWcg+cuyW7+a/bf/D12xwQXutiIf1Z8rLvTNn9jHKdsvrl4mSa/7lI0ndsSJSapPyDAF8j
	gmcy8+U1feSGz1O5dhoB2xhAabVNoHu0=
X-Google-Smtp-Source: AGHT+IEN/MNbPlBlwUJd6mYjk2C1H6Qy1E66YSTTEVwA8422JYUfrqD3QJ3Y3sCZthS4rGWv/VIiXXuMAKrQiDCj0f0=
X-Received: by 2002:a05:622a:1892:b0:4ae:5952:a54c with SMTP id
 d75a77b69052e-4aeaab03578mr30453841cf.55.1753578871806; Sat, 26 Jul 2025
 18:14:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 08:14:15 +0700
X-Gmail-Original-Message-ID: <CAFBCWQLA9XCSmJhDmo17HFV_yvarw3srPPna-hhdvZmSOdNs2A@mail.gmail.com>
X-Gm-Features: Ac12FXz9VIlzeaXzolkksBXnYGDfBNKQxJaj4YJaWaoSVzFJnnzOaFS6aBvzvQo
Message-ID: <CAFBCWQLA9XCSmJhDmo17HFV_yvarw3srPPna-hhdvZmSOdNs2A@mail.gmail.com>
Subject: Re: [PATCH liburing v2 0/3] Manpage updates for iowait toggle feature
 and one extra FFI fix
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>, 
	"GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, Christian Mazakas <christian.mazakas@gmail.com>, 
	io-uring Mailing List <io-uring@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 8:02=E2=80=AFAM Ammar Faizi wrote:
> [
>   v2: Keep using IOURINGINLINE on __io_uring_buf_ring_cq_advance
>       because it is in the FFI map file.
>
>   Now, only remove `IOURINGINLINE` from these two private helpers:
>     - __io_uring_set_target_fixed_file
>     - __io_uring_peek_cqe
>
>   I have verified these two functions are not in liburing-ffi.map.
>   I will be more careful next time verifying the FFI map file.
> ]
>
> Hi Jens,

Doh, I missed the To header in v2. Good that it's accessible via the
lore kernel.

--=20
Ammar Faizi


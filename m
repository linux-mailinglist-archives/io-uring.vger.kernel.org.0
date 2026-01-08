Return-Path: <io-uring+bounces-11544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1092FD06666
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 23:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 27F083012A75
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 22:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14B82F39B5;
	Thu,  8 Jan 2026 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGaRWH2e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7422D7810
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767910239; cv=none; b=u2mMtUpvGzpThxF349gC7/v75zeVojFclxs9P0i8HNgy/Eby61d8z/jTEBlSpZUVA6FqQjZdDRP0zrrFp4OaH4kC1c7mdNueWchtOxcaBApqUHu5D8TaOTFNfhqQdtX1QQAtm78pBrYvdhsu29nQJwfGT8oXT+8CwmcFdgW+J9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767910239; c=relaxed/simple;
	bh=b316XBdUU02Fj49yv5rtvVFny1bUFiev3rhHsguOJBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j4uq2zK8xJFxNpYD6Hpkc3Krs9JVA00/ZpsuEYCcTt5Rfg5ORJyWsC4kiDOFXTm72Tu4k2xCy0j8VYOEUGGh49bDyknn/5FjcdoEOyHnRsHrkq3VBOaWYcgEVx1qy1u+TlBUKi9LH6aYi0BxDIxIYBzJWR+wIRs6nGm2qG9rfSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGaRWH2e; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee05b2b1beso35165471cf.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 14:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767910237; x=1768515037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxOWxzYxBLwJhC5XL586rxmsz/glktXfvjYFujmhZ3M=;
        b=SGaRWH2ePhzDteR4/3tnxZeoIzxyjirqymjl54mUw3D06S37vp8QAqlDWgt91NL0JB
         x70cnB14BO3w4L4gBfi5loncXsRUHoGvZHwqtzxaGAgwrYHfHUID1Ky8t66A2W5DnoA7
         TEIjaujkGCN54ljvbCwfXs4UV88VlqTUE4Oox18xY/v4of9iEJjwvpdUrnLM+wu71DsN
         H55tAp7q6veYxwJqTsk4VGKgw5ywYdealePyrGN3vjWAZjs37OoM/9UKwLLfUGMh9gPc
         N6EUyKWDEjgjPGit5MDiQUXYmwz4ED7dfVqFhi3LPfMnOU9TOFwgbPd7WvyIxxMFd+2k
         Ycaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767910237; x=1768515037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bxOWxzYxBLwJhC5XL586rxmsz/glktXfvjYFujmhZ3M=;
        b=GDzfe2IlkR7MmNSFfERqoVCn9tdqW2enqeajUFMhpuOwH4uWBYP/gL8dsvbFQJ/nrX
         ciE3BBVoKzwoKzf+THm796LD1kAR+FrlN+QmyExJiT3jgal4fFtnGhAWx7E1rvAytkvu
         eApXokZfklP4/BauQRTqrclhlGzVR/NaSu5eVrbLFchgooRNq2Xkzmyb6P4B8w8NeL2B
         rRB5kI2z/m/xbw+4ptWKUQcpA7ZzdOEzukk8nN7nnZEzscCUpgVUz8GUDQJfmqrGJmxV
         PSqeXghDCHntLsjxsxGGyk/KaUhdSZ1o8ttVcHYNWJMlIfqFc2rnCZSrW1vXdqKwedDq
         hB8g==
X-Forwarded-Encrypted: i=1; AJvYcCUA6rOQe433vYk1HroXrzPA+AHH9xvnjtrhU4SdlEMwJsMDn/WKBWYE+qunb5cveLLoXX14vvexGw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjnt0DjkMHWh4NRweTd0Y/VyzPmyLE6KS+BN+VNeV8pHaIv+lt
	KwSz5aCasefUQYm+6hO86PbGhLPMUWp0Yz8icBvLdJTO9JYMqOG5cOKhQPr5XOzjIMYczS72p6Y
	/1gaX/1k7WAsFgrY3DPH+KMEtGn+goG5YPlal
X-Gm-Gg: AY/fxX5rj6z/ZT4AmZmJyOsvN1Desb1pKqJ5tOcXGHeVkzqC/jcsrKZzBR+SnioDP6E
	n6av66sqvgGBtn0o2bzDoIBdMfwVwCm5DlNw66mFM9YClN/qls8Er4XQuX7SetoL7BD9bLAJilo
	1CFvKwehtURfAYlbXDQMBbEy4pDK1mK8wyRr2kh+ReARqYUA/E/APATTRT5bpmq3ehvgfienOSJ
	VYFGm/tFT3DTYeOqi59zv6/xpRYbB1RWYoiy/fc8fUnqy7o5PGlytEeMnplcN1sp8rWJA==
X-Google-Smtp-Source: AGHT+IEusL/+wTPRduVKy8K/Xo3QQPbVJ4QJ0UjyMxdFsYMyXMQ2/6H+6i1V0DUaDFmi2fQxFz/pKFqG/+E5JOFCG6M=
X-Received: by 2002:a05:622a:48f:b0:4f1:e0fc:343e with SMTP id
 d75a77b69052e-4ffb499ad6amr109038791cf.37.1767910237420; Thu, 08 Jan 2026
 14:10:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105210543.3471082-1-csander@purestorage.com> <20260105210543.3471082-4-csander@purestorage.com>
In-Reply-To: <20260105210543.3471082-4-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 14:10:26 -0800
X-Gm-Features: AQt7F2ruN_3jfPUmzQhKB32F0sKwCayQ0qzK1FDa2_g5C1vl0bFINgW8DkivY-M
Message-ID: <CAJnrk1YTzFTxVEV9kBoj_dfXo1FmZ9jVhMi3sAdiuyWeoN-4PA@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] io_uring/register: drop io_register_enable_rings()
 submitter_task check
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 1:05=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_register_enable_rings() checks that the io_ring_ctx is
> IORING_SETUP_R_DISABLED, which ensures submitter_task hasn't been
> assigned by io_uring_create() or a previous io_register_enable_rings()
> call. So drop the redundant check that submitter_task is NULL.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/register.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 8104728af294..78434869270c 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -178,11 +178,11 @@ static __cold int io_register_restrictions(struct i=
o_ring_ctx *ctx,
>  static int io_register_enable_rings(struct io_ring_ctx *ctx)
>  {
>         if (!(ctx->flags & IORING_SETUP_R_DISABLED))
>                 return -EBADFD;
>
> -       if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_ta=
sk) {
> +       if (ctx->flags & IORING_SETUP_SINGLE_ISSUER) {
>                 ctx->submitter_task =3D get_task_struct(current);
>                 /*
>                  * Lazy activation attempts would fail if it was polled b=
efore
>                  * submitter_task is set.
>                  */
> --
> 2.45.2
>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>


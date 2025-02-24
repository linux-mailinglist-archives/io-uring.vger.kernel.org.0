Return-Path: <io-uring+bounces-6678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E924A42682
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A061A188EC19
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 15:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B52B175D48;
	Mon, 24 Feb 2025 15:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LnyNi9M1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158318828
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740411243; cv=none; b=EtKSAuOTMw0KDtbEBfABXV4VgoyCY5CYfG0Wwn8Q58t2bF1fOAlf/RuPTBgoC0pdW40vb0Phzd/lI3juiVSHS+iJIxsbBHON5GVS20ZOs69W1zkfYrIvLNeCuiCoKmMAKy6tTUoHVGBZjiWbBHaZflcRupHx58gjKR6d0rR8MKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740411243; c=relaxed/simple;
	bh=8dKY1ibuD9fHuQ/vlRApCQbeeeVe2ttV0mgI+l1gAXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kw8xFavj1Yez0aZFEty4b37P4KJVdGEf/URovVwGLSvm9CoWQ9nfXvoaRSRCZ7YWqGdBKX2BG2WJoS884gxIyesw0HbtfVR55Kd1OjjFGxGwZkCNvwbI52J0kOQVN5Hyu2pB4OBTJFU7+Pz+rWdLaOEc9cyyQhmo21yVFE741R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LnyNi9M1; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fe5d75ff8cso117131a91.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 07:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740411241; x=1741016041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5ehSULC0DcypJeS0d4TWcCtVe2Y/tEjESnBxHCNNlc=;
        b=LnyNi9M179wHGu9pKHh+zcNPtatxJcuhNTpRjqao2rfyk6Z06mHP/CYEGf5ta84uih
         3y6qgtJKMAxfjdL214EmQ9uzsI4JxHh4f5O/N8eaN+Nbq7F0jl7QiY+MjtBiWwVGK5nH
         OIuNl6a7FbLOonHTOhuFsbwARDLnLUplZGcBWEDePIb7tpIs5GqPKBqW+wqNw+sUrL0X
         KjizH9qqCcrZjO48OqODIGmu+1oTkVclXIAIDoCj34CX2bQJYiNasmir8yPIZWdooHjn
         AoJMmECEFAA8T4GAhhzYg/H0bOQym1uhzaQ0sVcQI9nad1faPBFcmqb03SR0dqTvAu+w
         cyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740411241; x=1741016041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5ehSULC0DcypJeS0d4TWcCtVe2Y/tEjESnBxHCNNlc=;
        b=sh1ShtP7c5hiTviDqVvnIcWxUWAMGUC7E32nDPTM0TwEkYb2lP0tGZorPyeAiNQPdp
         Et0gLOMTbrKE8NBZ/BT7jRxN/naCzTYXJdR8dOzcUSxevTT90FewAbb+RCyFoaGiPl1s
         nMyAskI4w3+cJjpeS/hHu5xgtGBGK3LUtK6Q4SdTiXE1+N4M4dpmhIkpALUAU6UyihUo
         g7vPr3Rnrtn1g0Xgeqfo8xxCDRUyj+B5LRKN5Xj4FPMpyyJErLsEK38o5TeisPNZ9Xyt
         TQmSqNHYYK//35GSofQLL6/pDKTpt9GcxkV+tPqZiBHoScF8daA52rkP0FSt2Qm3CD2l
         zXYQ==
X-Gm-Message-State: AOJu0YycWumP9onymwQk6u5AjB8OpcZVZFK2ooEmAidMq9euNUW86Qfn
	pWzDYRnQIqaINcY5DvBpEUnjfQaNp0xvpaG43coSTcLI/lgmFw1Zk8XlhXpFptZBs4+cBGdHkp0
	87D7aXyHCl2fd4hA1jR9FmDv8IieE0qXOsQuu6w==
X-Gm-Gg: ASbGncs19MWC2qp0Whbpp1TlB7oxKf8ey/ZEy/NbIEROq0HHuK+7GWimln1uPIBOnwf
	i4uqI18l1wPjS4UoCI7gYxcEK7FcfxSIDqOQvUNiP1CuguPKAhxWPnTS2Ly+8p1RzGYo+DiPeLD
	WZKsJr3bs=
X-Google-Smtp-Source: AGHT+IFWEoEGMcVNc2jNwLU/di/M4fruxDF5+fNx++ZnW9eJlf9GEiB85KMBzIDYKxmsgABnthhgaUgPNGMx6t8I9vs=
X-Received: by 2002:a17:90b:4d0d:b0:2ee:6563:20b5 with SMTP id
 98e67ed59e1d1-2fce75d75a7mr9197148a91.0.1740411241306; Mon, 24 Feb 2025
 07:34:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 24 Feb 2025 07:33:49 -0800
X-Gm-Features: AWEUYZn-Wv0jthD0ymJgJAaNcfbZOafU6kGy3SZIjIzYFNrDNbFXGX8_NYy4LX4
Message-ID: <CADUfDZqjL3iG1j6pv=EKa8goQE7A21sotwyZmnK_26QY=_ZtAw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] io_uring/waitid: use io_is_compat()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 4:48=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Use io_is_compat() for consistency.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/waitid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
> index 347b8f53efa7..4034b7e3026f 100644
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -78,7 +78,7 @@ static bool io_waitid_copy_si(struct io_kiocb *req, int=
 signo)
>                 return true;
>
>  #ifdef CONFIG_COMPAT
> -       if (req->ctx->compat)
> +       if (io_is_compat(req->ctx))
>                 return io_waitid_compat_copy_si(iw, signo);
>  #endif

Would it be possible to remove the #ifdef CONFIG_COMPAT here (and
around io_waitid_compat_copy_si()), like you did in rw.c? The compiler
should be able to optimize out the if (false) and the unused static
function. Same comment for the remaining uses of #ifdef CONFIG_COMPAT
in net.c.

Best,
Caleb


>
> --
> 2.48.1
>
>


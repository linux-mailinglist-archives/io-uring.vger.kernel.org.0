Return-Path: <io-uring+bounces-6087-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10748A1A64E
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56CAD161221
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F2938B;
	Thu, 23 Jan 2025 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G8R36FYc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF3620F971
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644046; cv=none; b=RGzhx8reRCvMp6Nvt8rGLydP2ntV6ae5Es+9/bK1gOvIbgOz+jyHDS+JjG4SvsDvPg/F6ryp4/2kfetm0BjoQEHKXGh8yo6cZhgr3L5ouhh7wLz5I2eUYUtzwdmdjtDiVlx5eerwh0Km9tt+QOcd88/4WTOwTUFYmTo634UKnE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644046; c=relaxed/simple;
	bh=XMJ7rpvZLRW7kNIrttsyPeNAdsEBlQXJc2wPh6j8SDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9NMBzypNtaOdzxjqlqmKbFS7pjQ++X1cdCMiRTbgj+Mj7pgSRA/EYAhWvnqzkq9+W3lQM3X1pMdpn7HLzLUCDRLL8CTWPPkF49/Mviz1vSTsIixISNUOCnGoC4nmytc3A21iPfAbUWWPlyz8n9H0J+UDi545LnSwIOYk0X94Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G8R36FYc; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5dbfc122b82so9928a12.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737644043; x=1738248843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPADjceqbW8lvSoMiWDTNctuBqQB8r+L+izlnB8bczg=;
        b=G8R36FYcydSm5TqIjorHs7g7OWNvPqod+BmuV/L0WDopfbjmI2TxLv+0p9AwFS+nRH
         fFmb3CH+bbZJu10wInaEKB2gj/MSuO57+mlx0Gtjg7CQu3GkgYzlCWscIphCdnmzdghb
         m8skhjnwtN6HKcghzk6iyYY7azM+qgNwnA3xDwKOZhL8w7CYLX98jrogitxoCfY0uLx7
         aJx8Ss+OZprl/Nkh3lEN1o7uwSK5zyL/PCGTFZztO1yyn18Q99VECPtoyH81aQF/I8ye
         MrQcQSTtN9hJ9dstYcLyJjlCx7qZAh9BkF0mjetYFsmk3vaCyrSK1PFjryTHKzYty132
         8KQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644043; x=1738248843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPADjceqbW8lvSoMiWDTNctuBqQB8r+L+izlnB8bczg=;
        b=G8MDampzMseQqlP8D/9eMb4xOeSQFR2ikNc85H0imGy4rxoyhDPiiEOWVsnKJrC08c
         NAeriRQUtftWPb9z8Gfyeo9Ji+vTAu8qfamXrvV2azJhKMiERh/lcnPorMqxDbOjJKKm
         rI7ggJS/ehpfrBq3I9Za8b8NQOC4GKJ0ZFl2kVY8IrPInhTSRz/hXBJFIrvvhnjHHrp1
         qV6GhSAZMj/7qAPPGsCDYzn0EFUfEiZmC7WfITaZJMWXuJoHelpNytf906LxYWLoOD7E
         yWh1cuCINpiEaAEP+SgpdKbGL/oTlaYbOoNNNxoiGlp1s+9xXH7cIYkTmzDnLp6cnL4A
         HlFg==
X-Gm-Message-State: AOJu0Yx7rSo8aCDKcBReW9q4CW6q9CCBGeDT7C1eO5U5xFBzM9SAOE+F
	4hARkTnozjzgA8/rldhR3cpN4oWmKNj6JiR3vqVRR+59jk8DB/iYr12/Bx+EUjxIwUyWsDJQuS2
	03qd56E9d6WSid7V+3sUvisFc29jJ8XN+fZgL
X-Gm-Gg: ASbGncsu7ZKzLhKqnNpQVv5fxzPJl9ufSWZEqSHDHiF5NiO2F+cymJ9DVeyOY4Mr/d1
	UFAwv3IU/kIJ68aOHh6sN72OOqMnk+tZPnSVfppaG2VNUv/l03NtguuASznS6EO64vzh8PCt6JF
	0ztc0ZIbVFhe/CoA==
X-Google-Smtp-Source: AGHT+IG4byndEGkgAnDmja9RSqQFSRFk3dIEaTpFFTk+bXqhI8J0qbW36AREdcPN+DiT0Qcs5hAgHGY50v+gKN8V2rI=
X-Received: by 2002:aa7:c049:0:b0:5d0:b6ff:5277 with SMTP id
 4fb4d7f45d1cf-5dc089b1f6bmr112068a12.2.1737644043025; Thu, 23 Jan 2025
 06:54:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5301f9fd-70e3-4156-bfe2-864adda9b71d@kernel.dk>
In-Reply-To: <5301f9fd-70e3-4156-bfe2-864adda9b71d@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 23 Jan 2025 15:53:27 +0100
X-Gm-Features: AWEUYZln92kX9V1Z93dW3uiZvE4ilDL9l6LmYDrofIne-ggYCc28KmZhoB_Vfpc
Message-ID: <CAG48ez0fYsKJe7+RxT80is2E17K1ODx++skZ=tKDKeeX_7O2kw@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 1:32=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
> io_uring_cmd_sock() does a read of cmd->sqe->cmd_op, which may look
> like it's the userspace shared SQE, but it's a copy at this point.
> Use cmd->cmd_op rather than dip into the allocated SQE copy - it's
> both simpler and faster and leaves less room for confusion.
>
> Link: https://lore.kernel.org/r/20250121-uring-sockcmd-fix-v1-1-add742802=
a29@google.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index fc94c465a985..3993c9339ac7 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -350,7 +350,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsig=
ned int issue_flags)
>         if (!prot || !prot->ioctl)
>                 return -EOPNOTSUPP;
>
> -       switch (cmd->sqe->cmd_op) {
> +       switch (cmd->cmd_op) {

Ah, yeah, this does look better than the READ_ONCE() I suggested.


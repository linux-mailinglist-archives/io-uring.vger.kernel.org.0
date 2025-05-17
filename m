Return-Path: <io-uring+bounces-8045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCFAABACDC
	for <lists+io-uring@lfdr.de>; Sun, 18 May 2025 01:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 909237A8FEF
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 23:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB7A8F6F;
	Sat, 17 May 2025 23:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HD2rpwet"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86F8F58
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747524743; cv=none; b=EEVulSzijjBZevTKC9eMThBZ7k2h3nApAljx3DQJiG8N2D3y4YVufJdxRmbINbi4puVvZkPwoZc06JpvJtmwfy0vjhaTNrJFUUMR8HJxY+dBzdxJyAnHzImx43QsHK2Z4cXHJL7QXGwgX1tuY/iHxuL6B6I0YMBLPdCPXXJvuM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747524743; c=relaxed/simple;
	bh=b9nf+A/GKok+vH177yh7F7u0h3yP73a+5QGrDODQd+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kndYCOz1HuRnxgnzaVsmxvHKXr0xSxXKUHv7gk17wiEXR6W11LCpolFI6QCwShLgLRS/LW78oxSvSJsEBSHWHpMqRMXPp1ZCSgByFstwL6QTzNmI7jIrraVcZDQ9oRn3yZqDXo7PxmVgF/b+OoYqRxyLvVrEkfJ/S75TBQ1UAn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HD2rpwet; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30e5438316bso192236a91.1
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 16:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747524740; x=1748129540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9nf+A/GKok+vH177yh7F7u0h3yP73a+5QGrDODQd+M=;
        b=HD2rpwetlJcS85KJGAwlY7o0SX+GxFyUvua0ie10oI9AnU8V0TUVV1aXA2rotv4nUB
         nqgLaiZAczKPczITMYmwUfgVsnzrygHIz6Tr/6lPCdGavacKgBPCjmL95k2Wktw8UOsg
         awLr22TFnz6h3GdFKfGTJRe7FzZmEVAbxpbNJKhlfVu3RafBKE3uvKwRz2UUMCVfcBTZ
         j7e/papue7TBVqKUdJkTefvkXhD4Ht4iPmft/sXUQUkIn107M1mXevrCRKJy/ByPOndx
         cl35haPv0miR0sGHRKZHxsYAQt6kXuOG0fDwfR01z92hQyHYuToaXENce3lyLJZfeLrX
         7NIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747524740; x=1748129540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9nf+A/GKok+vH177yh7F7u0h3yP73a+5QGrDODQd+M=;
        b=U8Jk1Ezjd4PT6ttmmV/Mm5EUr37VvM1BuJ5ellvgdjxoO5esTSRNNXfprDRAJl65yI
         WuBoXPoPvRmlYQqWRgUvcTDwd+OdHIxPOv5983Q3tJ89QFJWcbTkfGAHx3jkrHFWTj2B
         1U5rGIA1WDz8aASmR6rdAyPYd+yoqep4YSGUXyQcEMzvil24V6t1QbLGGVwB7ucIhoFb
         2Lk4+NXMgrZ2411yUwWzjO4nld8h01ds/wcMb26SYmVCqSeSXPHpWdRgOjGGA0ncUgCh
         p+kkarM8KieUCe8maigKA/kSff3caDGO4QVl+NFRuqQrt3pKonmmKgh4D+DXYipAneun
         MyKQ==
X-Gm-Message-State: AOJu0YzJ6yHWwDajsppRCR5sWj+Jb42PzzQICNIS5zdAj+I4nsvyNsRt
	BW+i5FGmJseEsC07iaWLVGyOBTP88oFuONCjaKdsvqhYSeEIHVI1zTFjFbluv/W20soYkrjCXfv
	mI1yvNMeQ1PFe4LzPZLugOf7d8HedsmKOyeWD7UtBMw==
X-Gm-Gg: ASbGncsmVkgLGixAc9VFV03m3QSUVx1z5nsU5+wRKJtC7Xri49QWDD1KRDtX69iVPli
	jW9Er7AcYOjkB9L+21cJBMXrRMOGWJcerip8PlXKnfr8GOHM9dXsoEJ72sHpr/UY342VdQJfjym
	ggq/C3pTlUKe2TSVe3Oy356KxbP38JdPI=
X-Google-Smtp-Source: AGHT+IFyHGH2Y/nkehC/y8nWn66nh8DzbG3EcWy1Uq1623MnhXpnjkpxGRBjlhZTU6p87XTLyMJSCjbC4FPSzG12Wcw=
X-Received: by 2002:a17:902:ea0a:b0:224:c46:d164 with SMTP id
 d9443c01a7336-231d43891f9mr37356305ad.2.1747524740439; Sat, 17 May 2025
 16:32:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250517114938.533378-1-axboe@kernel.dk> <20250517114938.533378-6-axboe@kernel.dk>
In-Reply-To: <20250517114938.533378-6-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 17 May 2025 16:32:08 -0700
X-Gm-Features: AX0GCFtvxNt82t8oGShH2UyiIlbT2Kh6U2jaK8d-g6rwifuplgdGTf6pVZ3r_j0
Message-ID: <CADUfDZpxAgzGDSPpUcEvrtTPuRYPk0uqhnsDt0B4D5mFgsHFkQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] io_uring: add new helpers for posting overflows
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2025 at 4:49=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Add two helpers, one for posting overflows for lockless_cq rings, and
> one for non-lockless_cq rings. The former can allocate sanely with
> GFP_KERNEL, but needs to grab the completion lock for posting, while the
> latter must do non-sleeping allocs as it already holds the completion
> lock.
>
> While at it, mark the overflow handling functions as __cold as well, as
> they should not generally be called during normal operations of the
> ring.
>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good, thanks!
Caleb


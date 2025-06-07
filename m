Return-Path: <io-uring+bounces-8279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9417AD0AB3
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 02:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 813051892BD8
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 00:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A620A18C31;
	Sat,  7 Jun 2025 00:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XVfwOsQn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026A1D2FF
	for <io-uring@vger.kernel.org>; Sat,  7 Jun 2025 00:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257461; cv=none; b=RCePucVl4Tx0tT+f2SAorqDC0DZWeQ9ZnWH//FbKSINz9XlgfCEFpgTIfqHqGBnOAUOo53Npe8FmSqBFEmvknE1JSZbXnRZ21mquI2VdUh++sFn3q00Yf/XhHEDEm0IRMQb5MqxQ9EvMT++/rGNLWHVlMAvAu6tPzz8ejx+2lLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257461; c=relaxed/simple;
	bh=3D4DYqqF1/3LDe/72Ppb9HfoqgFvu6YK/kFlTif81sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lJ9EXWu5TPC7vTYQUe4JOPniispbnBNKdnWhFUV6GhfKJd+pPOebNWLbN24Jq8w2r2/LZKpP5WEIWhwhAAW/OGMKGF3eTx1jo2BjOQfcc8c97kca4G9TIpTBpWVsVt7E82YYHbB5cwyAorqF4nMnwwP65grOTHVQS2pqaEV1Upo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XVfwOsQn; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-235a6b89dfaso4305305ad.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 17:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749257459; x=1749862259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OTzcw4NkPS1Xn/Qs9rAWe4w5cK6LdPmRbMW4JRKCfY=;
        b=XVfwOsQnZvWwlOPAY9E3rQ8In/VoTingwLNkcvE+FxyYqhajFdWh7/K8FwOIAgOuaS
         enWlVLryksE7o98MBH0ZKcH5lT0+driE4CDA3iDjkDfxNXQ/sk78ganktc+Nuy8/b3da
         ypBt3q5GpCohtIj2gbtVHfHQs79xIQvkVXqCgk8J6/rMPVdEjzzvpK66yv2RiA9u4Hb8
         AJ2RSZ7QNrCEUjlc5a6Jn5jnuEiE4B4P6Sq4imqWDy04vEssjQZ9zWAzGxSHBKeESimK
         WbvH0G+WjvPkt2h5p40hohrXxcmaiRd8sNSIpWlpDSjWqqlJQlNZIJx8kORAcP5e8sGt
         jB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749257459; x=1749862259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7OTzcw4NkPS1Xn/Qs9rAWe4w5cK6LdPmRbMW4JRKCfY=;
        b=KNZg5G+LxoPo1ciEiMf70qmLcIl69Si5qcyA1/Kp0zR9mJyiCJBVb9Z+ayQ+b+3fCo
         uuEn2gGLPjFAKPX8LKxfIOs2EEzYn86kGhUhe189yuYTsieZ13cSVJTC9/TbfenyOUVY
         tfXLoUCRm0khT3gcVHHqBuLg4+Z0NkBf02wxsgG2TADywhP7gBkMPXJhW4A5eh5LdhRh
         KOnkDJtADS+SWruAlFnFIkXktM3tKl7KzGVFmcD7pCFjHkUSzYPTgrQSPRK4yBm8ANU2
         9jd/m2WNpHxiIz3sTunUc4UOXxUmQR/ZOt6Iswng3Mf9mrXWev/iauBTadfxxCmsfqjX
         U79g==
X-Gm-Message-State: AOJu0YwOi9Fhs68XKuTYZwP64vEx+N3T0CUT7VtiaAcjOsRYrc5mXQvx
	dEO7WTnLUmDSVkoZrGwzRq3LjtWFLEJJHIurklPVshtVqNd2+GwdDyH8nP2S3pd21bksP9pnh67
	fVoi4JUV8RJuwDi8Aj/60TKyOgU5VST5rghsIeyOICfVmZDlVCOYH
X-Gm-Gg: ASbGnctTx2GBqUO/10gM2V2N68g2dzZcB+QyRYw0btsja6sg7pA9Z47a978+fEDWCjR
	sgWHaUQc/e3lU3mVxBQijdzHqrOCFJMDiRBoGJty8iVvj6HpD3emM+n0z+g/HTHPtKzCX0eP5mj
	XoPtRS938mmmCSDAN8CQTHbxBKjt6H0PNZyyl6rUBgnBg=
X-Google-Smtp-Source: AGHT+IH3iBsA4asX8W7yCmtqzzgosZ92qD6VCMm4kIGdOMvB5xM0EDoxXyJAE2z369a+AI1w9IaRmv9jdbIGXywRjEM=
X-Received: by 2002:a17:90b:350f:b0:312:639:a06d with SMTP id
 98e67ed59e1d1-3134e413149mr2602955a91.5.1749257459236; Fri, 06 Jun 2025
 17:50:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606215633.322075-1-axboe@kernel.dk> <20250606215633.322075-5-axboe@kernel.dk>
In-Reply-To: <20250606215633.322075-5-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 17:50:47 -0700
X-Gm-Features: AX0GCFvpsqHtPEhoW9G71TPlm-SGilS-wvQB_Jxe1HdldsxpT5cd7ahy9pF8tBM
Message-ID: <CADUfDZpoH=moy_cFvr81g16fw8dFtyLrWo1DZHc_gdbm=nwSeQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 2:56=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> uring_cmd currently copies the full SQE at prep time, just in case it
> needs it to be stable. However, for inline completions or requests that
> get queued up on the device side, there's no need to ever copy the SQE.
> This is particularly important, as various use cases of uring_cmd will
> be using 128b sized SQEs.
>
> Opt in to using ->sqe_copy() to let the core of io_uring decide when to
> copy SQEs, rather than to it upfront unconditionally.
>
> This provides two checks to see if ioucmd->sqe is still valid:
>
> 1) IO_URING_F_INLINE must be set, indicating the ->sqe_copy() call is
>    happening inline from the syscal submitting the IO. As long as we're
>    in that context, the SQE cannot have been reused.
>
> 2) If the SQE being passed in is NULL, then we're off the task_work
>    submission path. This check could be combined with IO_URING_F_INLINE,
>    but it'd require an additional branch-and-check in SQE queueing.
>
> If either of these aren't true and the SQE hasn't been copied already,
> then fail the request with -EFAULT and trigger a WARN_ON_ONCE() to
> indicate that there's a bug to figure out. With that, it should not be
> possible to ever reuse an SQE outside of the direct syscall path.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

With the parts about IO_URING_F_INLINE and NULL SQE removed from the
commit message,

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>


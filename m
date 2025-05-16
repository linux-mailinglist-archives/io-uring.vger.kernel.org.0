Return-Path: <io-uring+bounces-8017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0A3ABA624
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0006C5061A2
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8DC143895;
	Fri, 16 May 2025 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bK5miH+6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A101AA31
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436470; cv=none; b=qJ5gdr+ZOARycjdVLkx92bNo1NIH/GLc7K8P9f1BI1uGxnJLcG7ntJHSVs/zYM3WWUIVIJ3ATsDojQfYabHcwPKWua3pcG8MTiTdL1cezXSGZ0O+nf83s1tR6su/t91nviw0YC4cUuLuf15667I3C6uayW4adyKSqCaxESNG7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436470; c=relaxed/simple;
	bh=McfFNRJrHQbk2DZpk7JKMk27oCrbnvnDzfxpmfi2f2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atB8HNhH+AxOQRHBhQ2crfVRaF9KmzwNNFLXgOdOnlgeek4nxQl/l8jf6OvQ3RaWUlWx3L2grfOgHI7JtJ52R8aNpQtItFiFa88NrVl+cDtVBwx8Np26gRR9TG1MmxWGa4//y4Dq0lB+oFSTBMpAigNfAW7YiwsfXQgSQfivG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bK5miH+6; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22e19c71070so4533795ad.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747436468; x=1748041268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McfFNRJrHQbk2DZpk7JKMk27oCrbnvnDzfxpmfi2f2U=;
        b=bK5miH+6N7iQoVMmoAf/xWJ5uknAIta5PdcYb7S4bfq2WsXtTgSPoruW+88TmW/SXV
         bOQG+55Qn5nD6OAdNs16mP2RPkM0nqttit3fulp75Z3GZuZys/AWyLOK0aDkXrgTdfDT
         qXTryvKwwfO55BJZzpXTQ1lBF4gS2jOs+q98lelOWq5OenlSIF0S5mffPrf9gOtN166Z
         ofJY9oUZWmGck7q08K8sgPDiQvMruNS+zL0usai6syHfAm5O00BziDkT7tQLG2/uBdNF
         nSVM6idW2XOPziVS5HZWEDEw09LmUJAUL1hUJoXsYhcXL87Vipr6EdHYs6RCxZpjgAgZ
         TBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436468; x=1748041268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McfFNRJrHQbk2DZpk7JKMk27oCrbnvnDzfxpmfi2f2U=;
        b=L4Z6w2xJzFVLTUEJc46AVCFTKmyAkBIE1I4SkqHMpqo4ant8wLAhlKCfEBsw1ykprY
         veEQfEk7bByQHDU+zGzLOB6HFYNcf/XIVFwssdrwEdqRp9RsofFj7mWRFs2JuHZ8tD+a
         mJRNGwAwsJhlVfq5zn3LbDkK3Us6wWX+USrlza+DYheMUiVdhShc6HfGop1B5wJBBBDA
         IhiRr/rJoXcDVOpvnJUFnvAvx+58kek33KlTauAKzG+DIiIfu49ecjVn2tW0oedCCVw3
         w0+Hr5FfAPrdAEL+DqxCYXj4kbL236eB/dttyGIifSLzI2inh3f2EkegrqBxCj52zbi1
         zG1g==
X-Gm-Message-State: AOJu0YxkIBqpmVziXXh/5DPc8VaECZib9KpS3AsEBVu+1r085xtseqIc
	WNPOrlcEz+tkgiFDODSOrzSv1P3ZtHt04AwDT7CfnUVucvwAzj4+9uFOi9wvWonih0DpqJl+W1/
	u0uATxUef0Hk25Wz9GLb2ABvUwLnebtCa79mej6osmIDP2SEqG3EScucNoA==
X-Gm-Gg: ASbGnctza/ZFtyjimMF/1P3MjsM0wUBL/vmSexcKNIf2HVrMcaQgRCJPk0KCkuewcIE
	GkUZezU8hqpnWs40laFWzAoJLF1Ow327yeQqZ/fFlFajhkqRoAX04+oXYqbt7iA0XKyyHzM81LG
	5V4z3aK+95f/+bEcLHawb7WDrLnvKME4A=
X-Google-Smtp-Source: AGHT+IEpSXUZQpn/Npi+Ur7JHBVWXLORYJQtR+7kqbTZPUcivoRtmiiwnVmpYizk6GTv7gj5f4Z82er++0jg41irIjw=
X-Received: by 2002:a17:902:f691:b0:22f:a481:b9d9 with SMTP id
 d9443c01a7336-231d43c5f71mr26991125ad.8.1747436467788; Fri, 16 May 2025
 16:01:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516201007.482667-1-axboe@kernel.dk> <20250516201007.482667-3-axboe@kernel.dk>
In-Reply-To: <20250516201007.482667-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 16:00:56 -0700
X-Gm-Features: AX0GCFv9YCfU9ljdIprsHUyEJBuqWW-6RpRGvel49U2w3_1FT89NRy2h-EA2EoI
Message-ID: <CADUfDZpK6-2bJcXtRDG=MiLdKZUBZFehMFwfCFienX7XeUCkNA@mail.gmail.com>
Subject: Re: [PATCH 2/5] io_uring: split alloc and add of overflow
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 1:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
> overflow entry. Then it can get done outside of the locking section,
> and hence use more appropriate gfp_t allocation flags rather than always
> default to GFP_ATOMIC.
>
> Inspired by a previous series from Pavel:
>
> https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.=
com/
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>


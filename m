Return-Path: <io-uring+bounces-5692-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F20C5A032E5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 23:47:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6064216474E
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 22:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E271D63EA;
	Mon,  6 Jan 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/FjEgIy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151C01E0DEE
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203627; cv=none; b=QFyANUWWlFUb/naw2Pw4gTnRnLxA9323ldz9bBnhE0B5smUOJDPnMGaAONCBrHJdcw+dlpOo/C+2snSFLXqS7V0FJ16BKBSLNruqJ455i7Rbkmqjm8nG8fQhlmrEpNrdefVTdRpxm5KVSz0vLW4/UPYDrFViFjyyjJIUsFGeNZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203627; c=relaxed/simple;
	bh=4xMwGVLUCCgaQ/8O8Jujn9YPf2A3107E0DPsqCxXbsI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lY9vREOF6As+zNZXs3QN1I6raoOHwfzsBMmjxW8l26KcSHdvVC2skKq3CuUaqQ6Z3Z7KPjDEQrgAS2y2R2D2vKMiMGyLuIOry4KuRBiP/9vIQ0nYzNOlSfjIvY7jZLIe8HAPpTmhDhTvkCO/NgflGxYmRkizDpd/PIXZ/nqxINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l/FjEgIy; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-467abce2ef9so79821cf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 14:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736203622; x=1736808422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xMwGVLUCCgaQ/8O8Jujn9YPf2A3107E0DPsqCxXbsI=;
        b=l/FjEgIyWNJlqBYUlV6MYTphKFhjYiXVfLtvZzGJ3iwo9nEAFig56dxXXZARI1/vHn
         m/+dLN9xh8DrG5tzzefkU6QiC07mbv9CXAN0arGmfzH1OhST1qDVckP8TvFdEnfbZzsX
         0Cj4ru5K+tDg7j4eXP9MONsdVUxe0JZIjJnZcSU6P1fxajcA0SW2vD0rj6QZLIfOE1rs
         QvH7cnmU0t46sy3ee6Sqyz3rg2I4n2NXhRbMIXNJTaMYv6hTHvnTUArPZogMzUVwCoN5
         ULVqY6zOmV/vEHk8bW05NfqnoyQYixJe64lyqdeTO38hnejWMb2nKTIURXtnnqoP5knJ
         5B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736203622; x=1736808422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xMwGVLUCCgaQ/8O8Jujn9YPf2A3107E0DPsqCxXbsI=;
        b=gjqSH3Aad159RqM+4mygK464CzsK5T/dJJcDHFHIUEgAmR6WcMOfL8RSp11YahsAn2
         chb/HeujGLiV4Wt6itjqNgzZTkHDYMuf8c/ReD65moeyJ5DTufqQ/aoU7miGJ3ENlrrS
         D1WQu4kNGQAN/9GXmfoVj7bpjpcVmjrjzHBqhd77XAfmDBOCs75mnCqL+0AzS8ZqI/w5
         sZzAT6stSmxCcGhSe70Odn4r4vTyYXSteuAwj3xK+ulRNPQbvJf/DCYFZZAEC3PpYL68
         VS2TRZJR9fYTdmiivsC0Pox2Anz9J9itWLgQOmNoLQOKCUOQrpc5ZSqwNc1S01284uwB
         LOWw==
X-Gm-Message-State: AOJu0YxmT2M6VGw7hzGjWxvY6SBLjLPE5Exj/KCtXmUGtVtvipeOE46f
	bIbyTtpakPWY6+U7XMNIce+z4ziUFbYP2Y0dbEZP8OisZMCvWc3Cf/ut+2gfMLAxGqWddlU4N+f
	C6q5SOybsEVqb2tsJXEEfYx9cGGV6sfYuv7lW
X-Gm-Gg: ASbGncuxc8LFpaLc9kMM9cNqaUqOIirMcBiILbSrjMC20P80LfD8CzzRLo9+zCEd+rf
	Nam/vhaF34FVJ4vq1mfYm7zhF7E6jGmKNJjxfnRP1GuXAphPyZr3Gn+QDDTA97ntvYblz
X-Google-Smtp-Source: AGHT+IEiZJt//myIdtbS9bCZwMtEKH90oeFzGFtaSVrgVBQbRk91zxkAsuD0V1cwR2OgMNHqd4aPW9zGP/ykZihj+oE=
X-Received: by 2002:a05:622a:180f:b0:466:a22a:6590 with SMTP id
 d75a77b69052e-46b3c814cbdmr266081cf.9.1736203621507; Mon, 06 Jan 2025
 14:47:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-12-dw@davidwei.uk>
In-Reply-To: <20241218003748.796939-12-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 6 Jan 2025 14:46:49 -0800
Message-ID: <CAHS8izNCfQjhmywd=UQgFpk2OQZinnWcz8beZTROzJ33XF55rA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 11/20] io_uring/zcrx: add io_zcrx_area
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

On Tue, Dec 17, 2024 at 4:38=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> Add io_zcrx_area that represents a region of userspace memory that is
> used for zero copy. During ifq registration, userspace passes in the
> uaddr and len of userspace memory, which is then pinned by the kernel.
> Each net_iov is mapped to one of these pages.
>
> The freelist is a spinlock protected list that keeps track of all the
> net_iovs/pages that aren't used.
>

FWIW we devmem uses genpool to manage the freelist and that lets us do
allocations/free without locks. Not saying you should migrate to that
but it's an option you have available.

--=20
Thanks,
Mina


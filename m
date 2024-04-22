Return-Path: <io-uring+bounces-1605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8251B8AD2FE
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 19:03:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B430D1C21579
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 17:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C964C15383F;
	Mon, 22 Apr 2024 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ee9fMw8i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C224B15383C;
	Mon, 22 Apr 2024 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713805266; cv=none; b=Mr1pslpGU49worA6FQmYdGeobdpVC499chpE8qnAAYIz1CCrtqMmrDV+QBfgNTPvjOyCRSwsFtexc7reTfo8ZvM9xGuvRvI6IyYKAjB0vy7tIM4G22LRcWZL23vY6aYizmoh9n76VFzNLSLRaDIbmr6MRVdpCnVTQ2IqtCfYlIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713805266; c=relaxed/simple;
	bh=unovcmM/F2dhfHKF77+gvQUVhbqPaiyizesMAyFjp2s=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=GyhaB70undLyC9Ispob06pKVHpQ+voV9YXDOLf4P2aFaJFLA5eIKjqYiK6xY0eC5Clyg90kuW+ym7OTLJdtKLxWaa0ojHmLwOI00cSt7Jy78P9O6H4a1rxip35IeDG/GmPcTrQn/T6w4x4azD7sC3rUch2Dp+1SsgwtarPezvGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ee9fMw8i; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-78ecd752a7cso309802185a.0;
        Mon, 22 Apr 2024 10:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713805264; x=1714410064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qanenk0rOwdnK1RUZMGAjBSg7F/9gtEp8HpQbOgYLJw=;
        b=ee9fMw8itTJwZ7FFED5VuCVShbHIXx0+/lmX3HiNX8aClt+RQrqHKxrxxwVBuzSRQX
         QkbdXqQ2b59gQGJ33QuqIFaTfVvNFKlG8ZxelNkHhU7aWKmAVd5yXo4U1Y1CnJ7pVxj4
         MvW5a9HBGhh5rhmsTqr4XevXYlpX9HhI3LO1PFTux8A/9Fpw3I2eAtHTpY01swhslMV6
         8Jyxx43q5EPUb1bmJ0vWVqv8TGTJdAuaVWleAzmKVjREyQ/UQXkpw5Qmc3SzUAxpsZFG
         kswF1Ztgsnnv4BNRdC0je+aGrRtJd2Awa5m9NG7gnqy6DPG5zlnT9PqqKGcwptrxPfGz
         uS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713805264; x=1714410064;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qanenk0rOwdnK1RUZMGAjBSg7F/9gtEp8HpQbOgYLJw=;
        b=ZyfubgbfuBc8xQYjee4m9TTItajqyf0vG22yY5f4p/fFIO87191KN5sgsNfjetgNFk
         82ZMEC5fb86LhohCInFvts+iqbPmKeWkrSpgA3pcWW04BKs61n6wVGH6garm0GKjt1t2
         CEVuvIET5Nnb1wBMCS/aH5YkfnimuJZABdK5Vx5+KCl2U8do/ZYyzocensudaJYxyOpI
         XtFLASo/5p+HSujszSPFIUZJFoF+CxF914Dw0sVEhfxQmV910vEw4vU4cc9Dsiv4P9QK
         nPRsVDZuM+MhrKaEgF3y4I2klHQFU6QgkdUMkjduVTt1bW9mCVjC/XMz5qKnkP5rvLap
         yiFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjkc1fshhfhSBVtxfr0GW7uUOG6YSR5MR/xZXOVNywcx6OUD+6wgxC5wJ4l+Ep73cAdI5kHsVqUxVrtINHHFfryHRm9U7pV84zssuJu7/TqCqwnRmPxyRIZMuoIftWnCcfOj0N7MA5tQsFUPjQrgt7D72EwH8=
X-Gm-Message-State: AOJu0Yy488dY/amyaz+kA1agY06sjpCG5EPWnDmwKuOMPAVduI2btuXZ
	rk20mA4PoAGKkYrQib7JRMexqzaER3fQdrDKHigtzpzSeogge67JoNF2Muvf
X-Google-Smtp-Source: AGHT+IFCpIo7/SLWyIv8N6OtBqSGdbVdoaFQ0NI9Dz45ssmy5gm1tR1kWrL5XUahomCwRIDa2Lt9fA==
X-Received: by 2002:a05:620a:4ac5:b0:78d:66b6:a786 with SMTP id sq5-20020a05620a4ac500b0078d66b6a786mr12207280qkn.35.1713805263653;
        Mon, 22 Apr 2024 10:01:03 -0700 (PDT)
Received: from localhost (164.146.150.34.bc.googleusercontent.com. [34.150.146.164])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a0a4c00b0078d6120fad0sm4468257qka.108.2024.04.22.10.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:01:03 -0700 (PDT)
Date: Mon, 22 Apr 2024 13:01:03 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 asml.silence@gmail.com, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, 
 Wei Liu <wei.liu@kernel.org>, 
 Paul Durrant <paul@xen.org>, 
 xen-devel@lists.xenproject.org, 
 "Michael S . Tsirkin" <mst@redhat.com>, 
 virtualization@lists.linux.dev, 
 kvm@vger.kernel.org
Message-ID: <662697cf21177_753929488@willemb.c.googlers.com.notmuch>
In-Reply-To: <b7918aadffeb787c84c9e72e34c729dc04f3a45d.1713369317.git.asml.silence@gmail.com>
References: <cover.1713369317.git.asml.silence@gmail.com>
 <b7918aadffeb787c84c9e72e34c729dc04f3a45d.1713369317.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-next/net-next v2 2/4] net: add callback for
 setting a ubuf_info to skb
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pavel Begunkov wrote:
> At the moment an skb can only have one ubuf_info associated with it,
> which might be a performance problem for zerocopy sends in cases like
> TCP via io_uring. Add a callback for assigning ubuf_info to skb, this
> way we will implement smarter assignment later like linking ubuf_info
> together.
> 
> Note, it's an optional callback, which should be compatible with
> skb_zcopy_set(), that's because the net stack might potentially decide
> to clone an skb and take another reference to ubuf_info whenever it
> wishes. Also, a correct implementation should always be able to bind to
> an skb without prior ubuf_info, otherwise we could end up in a situation
> when the send would not be able to progress.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>


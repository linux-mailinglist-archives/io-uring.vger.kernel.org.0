Return-Path: <io-uring+bounces-9013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2A2B296D8
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 04:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF5C34E726E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 02:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095DE2451F3;
	Mon, 18 Aug 2025 02:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fZff3jbE"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0A24502C
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 02:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755483395; cv=none; b=qovg5HGqbay+GTWiRG06txKWJ83RrP7/+eh25Q3UgXaBMGwPmVv/EEgm2+Cb3YT/5t4puVLFjBesCnJEQ6S3xH2NPGZexW2GmZDpvpf6aT2AIIkr2cETCKR6JUoCjP3q+c+CMomahBoepjvHO5zOL49Bn/48LntLT/5ieZWRr64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755483395; c=relaxed/simple;
	bh=bUlf+g7ceLj9XEE6WyhmFD9xassTabh/9wEvEhXj6MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABjUMz+Me5mXcbC1CTESqFd8RHwsh9KAmOX1rM/bi6vQJm8Bzhv8D5PD/p5/Ltf7NwHKGTXz6J7sU+T0tFarbEhFIspobP3pDtHvwK2aac9HH4+70wEPT8YqxrXq8gJpk3tXiJgN4kIW0pdQkyBWTSMk4TwGfDhGyI1OI+ipla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fZff3jbE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755483393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bUlf+g7ceLj9XEE6WyhmFD9xassTabh/9wEvEhXj6MY=;
	b=fZff3jbEWisbml4YFkoV8qntw1N8klan4pSno0rguHy7gpGZFf8yZV2Uv66hoWpIuo+R80
	upN5nUN1dpeY90RzW9PJdfhDYHMTiD3YA41E27LkiNJC1IOffor/hk8J9uW6lCRMmPpPB3
	LCBmTpWtcNQ4eJQPlCDdaNk7RrbAhOo=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-8G3Gt5E-PJWRqR2TrlNKSQ-1; Sun, 17 Aug 2025 22:16:32 -0400
X-MC-Unique: 8G3Gt5E-PJWRqR2TrlNKSQ-1
X-Mimecast-MFC-AGG-ID: 8G3Gt5E-PJWRqR2TrlNKSQ_1755483391
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-53b175568a2so2011545e0c.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 19:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755483391; x=1756088191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUlf+g7ceLj9XEE6WyhmFD9xassTabh/9wEvEhXj6MY=;
        b=YiLwQIH6DOjPtNmjvWb4I43wCYgxAQ1e8OvKxzFDh0YQ9TS5IYWxrcqfK3Ee2KDmTZ
         aaVeVPFEALBSfuL82pvQ4x8dL2TRZBVGkRtaWYR2kxahlVBfSYgkZbSi+hi6e7KHqi1R
         ojpUof44hZrnpEqHXoY9KEn2WUxfR4fKPymwryd7pDkjt35VECzb6/GvmzhZoFKn1ne7
         tUy09Ju7Xu5L82kLu6+X6j4u5XzPGUHxps2EGYZ+Zd0pRtkvQ7ic8h5cvm7S+uqjSCAN
         Lgt2RT9W9Uf1cE6mxOaBmh9tw+SqY75Q/f+QDiGHj5mVlgzJg91OOXLxMPU3osqt21//
         /Usw==
X-Forwarded-Encrypted: i=1; AJvYcCXRLmezC7qBWuEw5NHbaKmdeSCHd00ypmGQ2SML7tvFiqPdo21H6OYuTYsYvKINtQnwour17ss8uQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNEylWOUvtBSn4NrOoV3Q1CePgtp2UCkjSCc6OCBsQcApp7F4I
	xUBCgGR9+Ws0w9cXCwiU75gJBDM9Fa0lwOkcQGGxhX5U8l0K9P67szd5pcXPrff5y4TEk9VgG65
	viZYMG96W4mLZEneZ+Gl7TaqJxRwFeURPD57H1uij1ZTaPcC47i8+bgSLdPNbk2A1mxmbVHPfxq
	Oei61cm86SutB1RZc/WPbT8LRVI2eC5pYjQwE=
X-Gm-Gg: ASbGncvAG3UigVRKBHqftE845pLV9POKKZg64pWjvmp5Ivg+PP0/bAwlMHU5wEVTebv
	/0gGo1n0fuXh7RQ0JC/bUTUxhW1goxMbgka0C5kN+/cUyb1WNOjVxQoEYf2b6h0dX4yeCuwqnRo
	pYTZd1bQr53bDTAaBqIc3q1w==
X-Received: by 2002:a05:6102:1622:b0:4d7:11d1:c24e with SMTP id ada2fe7eead31-5126d02aa65mr3360092137.21.1755483391457;
        Sun, 17 Aug 2025 19:16:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/11picNEpbgex/Ra/hzcVu23RKQMaoluayH1bJIp4qygkpZuAsAMpK3Qt9RCwb5hw9IIfgw8jvproFsPZFm0=
X-Received: by 2002:a05:6102:1622:b0:4d7:11d1:c24e with SMTP id
 ada2fe7eead31-5126d02aa65mr3360085137.21.1755483391144; Sun, 17 Aug 2025
 19:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250810025024.1659190-1-ming.lei@redhat.com>
In-Reply-To: <20250810025024.1659190-1-ming.lei@redhat.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 18 Aug 2025 10:16:19 +0800
X-Gm-Features: Ac12FXz9uEBxc6BOIzebGiEq3Jz0QfZek7H4lQf7NvJ_o3hYenEdc0604l58Sto
Message-ID: <CAFj5m9KuQ1322uFe4nSELW_uGXRHE5K9Ns8DixaYXn45a08N4Q@mail.gmail.com>
Subject: Re: [PATCH] io_uring: uring_cmd: add multishot support without poll
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2025 at 10:50=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wro=
te:
>
> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting naive multishot
> uring_cmd:
>
> - for notifying userspace to handle event, typical use case is to notify
> userspace for handle device interrupt event, really generic use case
>
> - needn't device to support poll() because the event may be originated
> from multiple source in device wide, such as multi queues
>
> - add two APIs, io_uring_cmd_select_buffer() is for getting the provided
> group buffer, io_uring_mshot_cmd_post_cqe() is for post CQE after event
> data is pushed to the provided buffer
>
> Follows one ublk use case:
>
> https://github.com/ming1/linux/commits/ublk-devel/
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Hello Guys,

Ping...

Thanks,



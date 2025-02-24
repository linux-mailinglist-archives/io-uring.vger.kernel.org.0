Return-Path: <io-uring+bounces-6657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 673CDA41EA4
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC5E3A70B9
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814CCEEB5;
	Mon, 24 Feb 2025 12:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="K2AoVVtm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D762571B2
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398922; cv=none; b=UiPjHEIswAwcZaZQN9EBt+2Bys4W1O2E8KfJFZecF3q5EfnvwaMLJMkZxq+oy6QKOeyD38M7qPYrG9UzDP3EWH5LSHBcP89EQQ32EpDOfzGxXdKpExXrLxhmep3hHY/XJuAvWhnokx5yEpMfNdv2Wlkbd5ymITVgpaZUKDjvb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398922; c=relaxed/simple;
	bh=kzXecNHRbFh50ri05wtHLEf3nbWyqUbonTy9wYBKhgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XjjZupd7Q9hkqsEkaKmyKmMaEOnXWRvX1x/noD2JrL1Ce7ZRG5ZDZoFy4VrikBbkT5gGN9YELvBc/aB69+B3NiNw/U6uaTKHz8lmVLEr2RJ6j0bK+87vB+WPJ6ZBrf6dG7cnLblyWnA0Px72dqqYGB6QFQ/UV0eXUXJIBHBpvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=K2AoVVtm; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6e41e18137bso34564056d6.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1740398919; x=1741003719; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bVv11kkNbpnH7NXv2lzx1aD/s83nOcC8I/9VECVC3NI=;
        b=K2AoVVtmhAL4ocNQQD2juN/G/ZsqtcHjBUUjt89X4mgdV2Fy3nW/BGgLCyZOwVqqNk
         TAQ+J3uvFH+2PxgYIgmtX375FL39wD2GYcdarSrtURFodNOINtijcn3QtRNq+qio4KdZ
         aOuix9jr+rx1/AUyzFPHSQO186gLFra/YXhTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740398919; x=1741003719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bVv11kkNbpnH7NXv2lzx1aD/s83nOcC8I/9VECVC3NI=;
        b=hVi3X5oiaR1rTAcaOai5WiSjAIgUrFElSCnr+KHfpIoq+a7K9uD5fjiIQl+e+pVnhM
         FGfrxa1sytfpcEJonOsSsZRxQfZ8SbRcEkPKnIebhQLKckyfNR9peB8itvLXMJlenHhc
         Qzdj/ytltoc380IiTBiGN9Q+LEXpQ/xZumbriMj5dpr22Zau3dleDdNDtqkTHD48K1sh
         Cc2yez4Ye44gcKz2Nw+O3Re+uLLOOnfC7qwZFLDNmTu3wbwlCf9iix8/lwEYC+QKrm1+
         wih6hLS0tqTu9UYh+AaMgDySBBbr6Z5DMqQRXyI5GdobibBM9SVh6pWcj2FcCDC8OLym
         9xjA==
X-Forwarded-Encrypted: i=1; AJvYcCV9FyWr6AGrxAQuiawTw3a+BQi47YyHyKILJIsdptwycpe+CeH3wgyzUgUcpX0az3BrQtF2d8N6Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUBNn6VkX4SmFsEieG648/ILDqjfEHdguL0X1ySHhXKGiqLKcZ
	Fpwmy1lG+dXUDG6ogyzM1Q7oftFgiiWWI2rrftUQShr9df+4yyWAUzFf58LeLatS5w6lTRsthz8
	Vhb31k//L8MJWblneTuQHTrZNFfiUastElkF39g==
X-Gm-Gg: ASbGncuHlJ1pioG8K3KemKpVo7/CSNENJjKFOgm7ZD9RD2tL1puQjw8cO5NvB30slDQ
	s2AgmOkX/WEwCujojWlatl6dnJxnb3C+1unRUK8audSs6WL+Nl7DfQR99sJSOF4oYn/Fq7+GYRp
	bokqiWdLQR
X-Google-Smtp-Source: AGHT+IF2r0y7EbNOX9gJRfKsXHY/LXgLrKwzLJKXRKjlFly9zjR0pj5HmRk0WrXZFUAysvnGfunzFL4WBXbCOUHaJ14=
X-Received: by 2002:ad4:5bcf:0:b0:6cb:d1ae:27a6 with SMTP id
 6a1803df08f44-6e6b010e18bmr147394186d6.24.1740398918714; Mon, 24 Feb 2025
 04:08:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com> <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com> <CAOQ4uxjhi_0f4y5DgrQr+H01j4N7d4VRv3vNidfNYy-cP8TS4g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjhi_0f4y5DgrQr+H01j4N7d4VRv3vNidfNYy-cP8TS4g@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Feb 2025 13:08:27 +0100
X-Gm-Features: AWEUYZk15tnAHQ1Hkw5t18U-SlRj-CYMpL4j2TOzMzjG64Wee9bdrcLfCeK8_WY
Message-ID: <CAJfpegv=3=rfxPDTP3HhWDcVJZrb_+ti7zyMrABYvX1w668XqQ@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Amir Goldstein <amir73il@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, Moinak Bhattacharyya <moinakb001@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Feb 2025 at 19:31, Amir Goldstein <amir73il@gmail.com> wrote:

> BTW, I am now trying to work out the API for setting up a backing file
> for an inode at LOOKUP time for passthrough of inode operations.
> For this mode of operation, I was considering to support OPEN
> response with FOPEN_PASSTHROUGH and zero backing_id to mean
> "the backing file that is associated with the inode".
> I've actually reserved backing_id 0 for this purpose.
> In this mode of operations the problem at hand will become moot.
>
> One way to deal with the API of FOPEN_PASSTHROUGH in
> io_uring is to only use this mode of operation.
> IOW, LOOKUP response could have a backing fd and not
> a backing id and then the backing ids are not even exposed to
> server because the server does not care - for all practical purposes
> the nodeid is the backing id.

Yeah, the backing-id thing should not be needed for io-uring.

One complaint about the current passthrough API is that it adds extra
syscalls, which is expensive nowadays.

> I personally don't mind if inode operations passthrough
> that are setup via LOOKUP response, will require io_uring.
> Both features are about metadata operations performance,
> so it kind of makes sense to bundle them together, does it not?

Right, this would be the least complex solution.   We could also add
an ioctl(FUSE_DEV_IOC_LOOKUP_REPLY), which would work with the
non-uring API.

Thanks,
Miklos


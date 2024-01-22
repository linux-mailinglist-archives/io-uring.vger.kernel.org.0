Return-Path: <io-uring+bounces-444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55485837353
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E36471F29A11
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 19:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A5E3FE44;
	Mon, 22 Jan 2024 19:57:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3981238DF1
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 19:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705953424; cv=none; b=UxXSWfJVK/cWtIsaNNpWCvV1U+0UReiIFYuStuU2h0t98c9Qg0+aAF2RdmvZxwZruItMpqn0Q1xxRSurfKy1vSYHJCiKi1CytrSfSpNHdKhs/6NFlbnQaIrOPif4+Q5I0XyTf2rih+YvW8E31xHr0JQPVWnJHvBSakQFHhDyfsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705953424; c=relaxed/simple;
	bh=jN0loH6TcQ+eseP8q3x02N7fhXc5ChbxnxD50Zg92Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2BlvWPFgW/V+fr+9Mpbu3r/9SVmxW2L0tPvkUlj/GyMuAu7YApqCaCKEWVHUzgmMlBs2UhZxEj/WIK1x5aSCgJBzc02xTNAfgA+r6/cWEjj4N0UE4j2WTUROif+7F0pPCWScC5E2jNIOG2mr4trqt9Fy9+KJ8si4DGF60+l0Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a2dd05e02ffso356316666b.3
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 11:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705953421; x=1706558221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mcwe/3vpnI1+GLBpu6RSMS8ijLdksN/KMKWAipw/YU8=;
        b=bpJv4EzHutOtZkgYL754CTf3zOmV1fLFLPvZwfxcROlNJ+o6Kgv+pdbWL7iNBdbhaK
         9g7fdE2OgJt/JuVEUizh2htDhIoYQacL9nzkVmUY5sGz2GnagVVfQZgXXdGx2Me/5RiI
         d3y7IovSOxU5H0SRRB4T4FfYcUA05rGPq8/pxP0sU493vERTjCnmooT593eRT1OWoDN9
         kV8IM0JaE/hBFczd83ZKrMG8XWqtYSKRtzbayW6WLCrEv/sV9KSPT7LR2VYe5ZdAHafn
         w2hcOu6ebaIyXoi89pDiOEoB75QDXimUYgpL25cueGp2dVDfx5QP/CiDB+JBjeKEoq3B
         SCQA==
X-Gm-Message-State: AOJu0YzBm7Q+FGVcu0vn5ZctZrE8ERz4TOItebC2ZguF2VD7nv/BYna5
	qMt/tcT3gntcs0LhiCyCdllsHcOLs90t2Dq28Eyk0ZlBdZn7yGoDArOZDtc0bog+/pxk
X-Google-Smtp-Source: AGHT+IGXoCnBLGKugnzimvgEGiYyKKyQBezZSZYj8Jj5xcOg9NWFdAoDvpY5aq2SUD07YFYM2bxqwA==
X-Received: by 2002:a17:907:d048:b0:a2f:c9fb:5ebf with SMTP id vb8-20020a170907d04800b00a2fc9fb5ebfmr1977327ejc.146.1705953421208;
        Mon, 22 Jan 2024 11:57:01 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id a13-20020a170906274d00b00a2b608ad048sm13644650ejd.28.2024.01.22.11.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 11:57:00 -0800 (PST)
Date: Mon, 22 Jan 2024 11:56:59 -0800
From: Breno Leitao <leitao@debian.org>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: add support for truncate
Message-ID: <Za7Ii2O0Jjfb6rz9@gmail.com>
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122193732.23217-1-tony.solomonik@gmail.com>

Hello Tony,

On Mon, Jan 22, 2024 at 09:37:31PM +0200, Tony Solomonik wrote:
> +int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
> +
> +	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	tr->pathname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	tr->len = READ_ONCE(sqe->len);

sqe->len is 32 bits. I _think_ loff_t is or could be 64-bits. Isn't it
possible to use a u64 here? Maybe sqe->off or sqe->addr?


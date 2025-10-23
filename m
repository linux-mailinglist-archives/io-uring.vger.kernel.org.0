Return-Path: <io-uring+bounces-10176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 67324C03E01
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 01:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 177B94E6672
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 23:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297AC2D3204;
	Thu, 23 Oct 2025 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGkgBn+B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472A214B06C
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 23:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761263080; cv=none; b=jdt1a2FODmgDFVZGkJqVLi8nVcCMgrRQ8sJ2dzXHX5m7lQDA9gZ+ETFHoOKdH86kAjlqMiFDQ7o2hBoA6TJvzlUWgIc4M8ZYEqmYlEM7rkrUpzlHCXIoYaIofbsT1zjB1EZzgQD5temaMTnXkGrpyDTudgwki5AHVg1NV1TADiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761263080; c=relaxed/simple;
	bh=+73TE0LUJk3EHBZtSrvfA2iuWg7yqVR6IZtWQcGL0sI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0093s4eQKN33u0FKR6MACNsvPXYOKIqb2kZ7Iy17Hs2loqWykgkSdbIoobDtbdjgK0vKUU9/2+lLe3BE7ZjLZPZvkPwxALMsytQHcTq5qgq+bEyoZdKTVermLHCulqMJznydbFV4eH2XqpS/KyaEVB5HgUOlO5Gly+aKlSQ4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UGkgBn+B; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e89d2eaca9so9195281cf.1
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 16:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761263076; x=1761867876; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UXqCBtIeIyeVeN+++avkFc9AmHHco/PM3jJYvlfy7IY=;
        b=UGkgBn+BOgtP0aoMJ7v4elUL+o1mZIqqduaHtLNVltus8AoKgRbFBBlgxfinwICTgc
         p/U8TZPt+KZfG8QCDnhIinoBdafU9qENVQi0i24NeqahgbdPLCBgNZ3n9/iMCH984yKW
         LwAODBzsBT6R+r7sTyX2PskgppZ/b+m0t2zs1qHJ0AcsVMxuPVifrA9aNHGTn4KWupW8
         HdV3XoUOcXNg7Vk88VKXBvhGUQISTLnfNhLgYJ1N3bWHhO9evr4zTRNMATo19qEy3lU/
         06HsMToYE9Fn1ANXTCMtlomO4652coyOfXQs05NY4qIASN3wmo4XkOGv9VZJnS3r5Y9h
         5UWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761263076; x=1761867876;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UXqCBtIeIyeVeN+++avkFc9AmHHco/PM3jJYvlfy7IY=;
        b=NiOzHQ7CjgxgQ6PvNoWYWzkpaVbph7jIrhIgrWHbpFO480VWXLAdBsRgCvebp4ZjDM
         Vz+zP7txvlJwm2M2/TLdm3A4d2YLZV5o0LSmzwKJ4igpDvhi7XZQW6k6XC3aVAViTb5r
         if8sPH7ewp2JAwWRUzy4ki+AWdtm/jtJbk7mDSNTFk2x2ELTbgQu7ej6ofUY3iMdC8vj
         YwvQY4kRUyW/8ni4qvclfql0z3qsowEJb5+K1Edyyi9c29LF6Q+Cm9KnsQhBFsMEhUjd
         dy8yT+hdAtTVvub2/OmYh1w83410mo4XwMQH96JU/163TO3nMUvDGpRuyMu5/NCVLbBd
         zW/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8h7xX5Ra3f5FOlXPa7kDdeHviHtKQMwG7o8MBJjFxRNn5UMFAOwudDzvIgmsKHf9mJ1zr99+lcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMvDwwjNif37hDmXo6ICdRYeByP7ZL8oQeqb1T87UCymZ4jIT5
	te8UN8O04u53F4SSHuuGWn407GbEWtRMo8FrOQhYKzl/7WUp9j9RS8/zKMPEI87CzSRvBM/i7o7
	YCthJ9Eii/2KerkvXYAvMtFhWMvU9m4A=
X-Gm-Gg: ASbGncuOgNpigggNJvcKgmBA4p1Gv95tUyzSoekpp944Bx9J0R59G2kKZ77knTG4W7E
	3zHL8HvkAUlVtHLCf1hGDWRLgTXzQfJMcetmAkvL7CyqNyEeOFOHTdJZ6snyVIDyPAxz+luF9ZS
	amybLmvD6HHn+qBiD0KenC/1rw7aNpOh5yWqKHWUfW5ASvnI913KZp/GeQpqIQdvObyD93EBNl5
	p1gOm8v0Rkjr7nActv7i2EKIzkahNDUJY4TSWNwAcTOmXf7UK7gsaRSRpKKkaxW5y2Tk/taiJl0
	OZmDSqqcJ5MBhGoJSQvv/jWSuw==
X-Google-Smtp-Source: AGHT+IFfKFcBw3GFrPn9bPh8oDexYFhT6MlUZOifmThWFzTuYEuhqR/yL3g28XjR2Rdspj+zz/eGO0LoM7bALqdbCfY=
X-Received: by 2002:a05:622a:4cb:b0:4c3:7101:8861 with SMTP id
 d75a77b69052e-4e89d20d74fmr245657381cf.15.1761263075982; Thu, 23 Oct 2025
 16:44:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022202021.3649586-1-joannelkoong@gmail.com> <20251022202021.3649586-3-joannelkoong@gmail.com>
In-Reply-To: <20251022202021.3649586-3-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 23 Oct 2025 16:44:25 -0700
X-Gm-Features: AS18NWCUeOyyQYcs_PpyeP_rFldTQGSoTEysf2geuIz4a2-n3KFNW91U42vYFHw
Message-ID: <CAJnrk1Y9KjhchEMqb7cb6gBBFKs-vcxp1LSAL9_jP+8WaJFnmw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fuse: support io-uring registered buffers
To: miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, bschubert@ddn.com, asml.silence@gmail.com, 
	io-uring@vger.kernel.org, xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 51a563922ce1..748c87e325f5 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -38,9 +38,20 @@ enum fuse_ring_req_state {
>
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
> -       /* userspace buffer */
> -       struct fuse_uring_req_header __user *headers;
> -       void __user *payload;
> +       /* True if daemon has registered its buffers ahead of time */
> +       bool is_fixed_buffer;
> +       union {
> +               /* userspace buffer */
> +               struct {
> +                       struct fuse_uring_req_header __user *headers;
> +                       void __user *payload;
> +               } user;
> +
> +               struct {
> +                       struct iov_iter payload_iter;
> +                       struct iov_iter headers_iter;
> +               } fixed_buffer;
> +       };

The iters need to be reconstructed instead of recycling the same one
since the buffer could be unregistered by userspace even while the
server is running, even if libfuse doesn't do that. I'll account for
this in v2.

Thanks,
Joanne

>
>         /* the ring queue that owns the request */
>         struct fuse_ring_queue *queue;
> --
> 2.47.3
>


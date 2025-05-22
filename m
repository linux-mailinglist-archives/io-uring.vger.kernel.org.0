Return-Path: <io-uring+bounces-8077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A8EAC0E2D
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAE7D50168A
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 14:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BACB28BAA5;
	Thu, 22 May 2025 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eideWIwA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC7C49625
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747924466; cv=none; b=dSErSwUKnlmunhqLl5CXTThJBlPVhpubu1WjhYA9ZCzaGJlt+Xcow1zg1C114AbbiQtPIhxpfmf9cOqzOpZMWOIFrPq4dd0rLCYMb2IA3dFZUMQvwSMmJRUl4q8a4Go6VKi51bBDGr0JSWDL2FRDp73MeuoNa2bCe9K64WB6idI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747924466; c=relaxed/simple;
	bh=RaC1uURdOyVfgSvUTIHPl9JVM1ZPrU9Co8xAGlfBA+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLRIBlz7oSyM1hdiF2fU6CSoXVfGNY3FDmPFsL68ITisxpFnc7w/QYKdhnz093ZFVNl2sSXmqX7pHzu3OzTqQrly9cArufjzEsUoLQPwOm/m7nhIK1WIubuqPiqyPIXE8ipovM98ls0KDPFpyf4BTMmCq1Q3/NpB7OP/16c09Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eideWIwA; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-af90510be2eso796384a12.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 07:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747924464; x=1748529264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAFxDxcsV+O01UOyfhZfQi7+2P76SbnGLqYLGNFxF6A=;
        b=eideWIwAjaZu9wBQo6bYLmwMf7NPpdbgGRhBzVLCssB0LlThAsXWsBx3I+w3AWMWQT
         qSBAnqnfDgWlyJKIyI0p8yKl/04GFnVP1wGypesUXb5he0PbcL7K/0TvckKgU6US2NAt
         FW4EmZfUf/ubXaSdx/D4mSWFLsBXV86fYqMkvk+kChdz5oRcQAacN2jUSO3if9mi5TCl
         bWF6wvZTr3sOCezcwni54bdExFXsq3s77X4RQjeH2tEYRV/zYAydOacbVmwML2yNQLIY
         sDbqLCsdUcfSggtC/dWhShbJnMrBAd44XX3eFmOhLJfjoN9OxMCmegy2uZ1WrWOwqWg4
         yUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747924464; x=1748529264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAFxDxcsV+O01UOyfhZfQi7+2P76SbnGLqYLGNFxF6A=;
        b=Z62esvQN3n2zGlAfu1CQUREmCOAXkPhB7KgaTzLEAtiCzu8c/BopK/zmpF48rB3+M5
         4/JTi3kaTO3DbUl3aIKpoF/IHyR1dcJQ/XCcd35Pkz4JGA/yyANbq3t51MjuB7iNQoV7
         i1/geUGAxCU/7kEE4qg9O3drGQaoT5vf860IAgZT+stPTqeMJ6fKlfFYwvTvq/bhxN+L
         7CwDYXxexZEw5x+mgHvmCaBv7+Dx4kQvbq1Iv39yEYgEYiMu+LFHYq8grYoEELDmJOat
         P6aspoVQBok1fJnTDDh6PbW0YGPzYCkD8Kee/CkDy/8ULZHL7zrGDJ4xOLV4W724hscC
         hTow==
X-Forwarded-Encrypted: i=1; AJvYcCUUJ06KqM71vEuaCGhXkj1uNPsWnBD4pkbrBdMUKD8OI8+dJy+fLf+5N4KGj3jYncq0f5bDqZ8SoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfPtbKRBgIfQ5TtWIARnJRuWlH6hdQ619fjN38NVYbAhAJtvuD
	FWJGCiEkQUM6XxgdCaeoCT9fUYl0QOyZmLidOaxPXSrE6YSetcmegLeN2HBQmwVugX5ZPsDlC6d
	vHJyVuf4yZXjQJQGiElBNDsQWq0JN2tCaKOxYwqRz8A==
X-Gm-Gg: ASbGncsr8GMhpHudCUAiV90vS//bsRFlA3OIZ2JMg3MPyoeACZJYSOaN90ry74t20nx
	/l1zyeHW7c0yLsP9OfQNx/daxoelHHrSU5JNzoYtKAO2k+0rQxjbsH98EB42NQ9213QDnM42Nur
	Vlg4I4n3xYxu6ENNnKfkzwLr/CELDJpSw=
X-Google-Smtp-Source: AGHT+IHfVA2dllWqoa1e6AwwdxooDk4eZjcfbtmo8xZnZZG7eMBTZaMm3RZ1l01SXZMe3wwZIjAlXdjS7qv1SvCjhz4=
X-Received: by 2002:a17:903:1987:b0:22f:b902:fa87 with SMTP id
 d9443c01a7336-231d450f7b1mr138668925ad.10.1747924463942; Thu, 22 May 2025
 07:34:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522135045.389102-1-ming.lei@redhat.com> <20250522135045.389102-2-ming.lei@redhat.com>
In-Reply-To: <20250522135045.389102-2-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 22 May 2025 07:34:12 -0700
X-Gm-Features: AX0GCFtx02V3ZXj8RDgeYPnY48s2AdWzi_kc6hpsciFE9vh2CgQTHTaeo-nFVwc
Message-ID: <CADUfDZq5V=7ah8bHgPosjWk=Pshgw2S5jKuX7LhX8HVGRSH5dQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring: add helper io_uring_cmd_ctx_handle()
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 6:51=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add helper io_uring_cmd_ctx_handle() for driver to track per-context
> resource, such as registered kernel io buffer.
>
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/io_uring/cmd.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 0634a3de1782..92d523865df8 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -140,6 +140,15 @@ static inline struct io_uring_cmd_data *io_uring_cmd=
_get_async_data(struct io_ur
>         return cmd_to_io_kiocb(cmd)->async_data;
>  }
>
> +/*
> + * Return uring_cmd's context reference as its context handle for driver=
 to
> + * track per-context resource, such as registered kernel IO buffer
> + */
> +static inline unsigned long io_uring_cmd_ctx_handle(struct io_uring_cmd =
*cmd)
> +{
> +       return (unsigned long)cmd_to_io_kiocb(cmd)->ctx;

I would still prefer to return const void *. That would avoid the need
for a cast.
Other than that, this looks good.

Best,
Caleb

> +}
> +
>  int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
>                             void (*release)(void *), unsigned int index,
>                             unsigned int issue_flags);
> --
> 2.47.0
>


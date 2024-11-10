Return-Path: <io-uring+bounces-4578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1390E9C3224
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C12A91F20FCC
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 13:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA88C13C;
	Sun, 10 Nov 2024 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4suO/9C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579BBD27E;
	Sun, 10 Nov 2024 13:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731245102; cv=none; b=JEZhpb+P2vzYmGejpa+kg4wisyZNpIbDL/XfwK4bmhOCz0Iuw5CE/m4ppscgyPnjZiGvb4JzaOD/Njg0YrWLlGxcI3kI4s//RHUCRFiDz6a2RNA8BUbA6RVeBndryllXfYQSfOm1L/bSBa+XsEx7ZB9bdHP/zlC9Ked+hbNf9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731245102; c=relaxed/simple;
	bh=40+qsqgKX33ZoyG1YGe7cEFMRsXS0F7LcLnIA/0/rHg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=EaoHQ2C/gbrY7TT4DVAa35CajSyoC78x+IHA7JPNr2bh4SywHMGfvv2TgvnTTDqJ29Wo4HwOOU+87ajPAiUUQ8aKduEDsWf7NtGhbn4VhWgq/T2pn/hIDLhD5/X9dHwSEJKK/DoLLISv2s0jrr/95Ng783MC4AkRrxXQzcgY/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4suO/9C; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e28fea0f5b8so3295031276.1;
        Sun, 10 Nov 2024 05:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731245100; x=1731849900; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=40+qsqgKX33ZoyG1YGe7cEFMRsXS0F7LcLnIA/0/rHg=;
        b=m4suO/9C+m4isyg9R9XvKYi43Pe1/xxq30ZSfqSGRlk5BHGFL5PeUH0CY9D8UYnpzq
         9Pb+j7oYIvGIOIyjU1xlUEfSMSLmWbrb2pOsUai/ZSrAkjf4XY8ykdvVlrZ8tlhbsl6X
         x82P1ojIHK8HHPXIocjXzJj7f78LHZiliL8j9IDhc0Qx1VWBr2HenwSI8Cb+hRwW2BAT
         SyO5zVvzTq4A1iWVLBVZxsQ4XdtVfIYRM+wl7gpCGdptYn82o2D8mL3bGpi2FXAwcVho
         hyPVr/wGFsYo9L7+HGeDYTHqOrj0np9g1oSC7YW2siF/0nXyegcHmP917VQ8yzGud3dN
         Mr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731245100; x=1731849900;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=40+qsqgKX33ZoyG1YGe7cEFMRsXS0F7LcLnIA/0/rHg=;
        b=lHmxLlCW/6hTwcmfZ9b8kDX6IYFs4RkuE22VNul+IgJgNdnxJW+ylUP9pRO2X0U/WH
         b9YINVtwcaAPpjsmOOP66kN6H639ckSjSFjPKiNP2Ih3+Uj25rp8ASexxf76PAtDLzo1
         Mz9dKgg4Z+aYg3xo01lhXPlcw3WQBkjV1q4+Odx374NGCQlkBlF0DXkt6BF9d3SAO+cr
         XMZ6B2gdxZ9/5fNeJUFDNaIjHTPLOyodXMBjkVy4PD1IsvlDJsavnUItsR1Q+ZELEYur
         +0d90p1psBhSI4F/ejyKqpSbd6gfII8OjtUfw6lEJ0FwPcNNF4hIC+ErIyIyGrUrZoQv
         hLMA==
X-Forwarded-Encrypted: i=1; AJvYcCW8kLn+odauWYKDc/NO9gG+izFFIOS5aF7e0nUSRHQ9FcKz1TskGjRWrWbrE37/ln8tfmh30jW273ZwCplr@vger.kernel.org, AJvYcCXrsvzi7Dong90Al/8DBLmuScG6a7qD+GUNHTY3h30xt2z44zUxcw9WEcQGW6CBszpoGZ/HoGzosg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/581E3cYITqe451mKnkVPiIc1bIDlI3YnvWq3XQNfwqo45d3I
	Bd9MdDoUy2Hhr9gQstol/tAs2CyHA7+L/M0zw3+Fga3KFt9La7hB431yGuQvMZWp47bNLNb0Kl5
	LcDi9cWChE9l22X340yqF1RVn5B6GDwmX
X-Google-Smtp-Source: AGHT+IHbXRfYHB4ceWNd6O8ReaGNIZU8Om13tl/xHdCFFBn7Ln9+Co1SobqkXvmADKKjt4BwJZxtl3geO8TDkpbLSOw=
X-Received: by 2002:a05:6902:c11:b0:e29:1def:1032 with SMTP id
 3f1490d57ef6-e337f8c7023mr7564696276.41.1731245100060; Sun, 10 Nov 2024
 05:25:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chase xd <sl1589472800@gmail.com>
Date: Sun, 10 Nov 2024 14:24:49 +0100
Message-ID: <CADZouDQJOe-JimRj8f4ELtKOzHFiz7yDqnqcpSMP8oU=RuypGQ@mail.gmail.com>
Subject: Potiential nullptr derefence in io_do_iopoll
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear maintainers,

I'm looking into io_uring internals and find there might be a bug in
io_do_iopoll, but I'm struggling to construct a POC due to my lack of
knowledge about the kernel internals. So maybe it's better to put it
here for discussion.

After [issuing an
SQE](https://elixir.bootlin.com/linux/v6.9/source/io_uring/io_uring.c#L1920)
in iopoll-enabled io_uring, if the return value is
`IOU_ISSUE_SKIP_COMPLETE` and the op supports `iopoll_queue`, the req
will be added to `ctx->iopoll_list` and later retrieved in
`io_do_iopoll`, where `iopoll` or `uring_cmd_iopoll` of the req file
op is [called](https://elixir.bootlin.com/linux/v6.9/source/io_uring/rw.c#L1167).

IMHO here we miss a check of whether `iopoll` or `uring_cmd_iopoll` is
implemented. A more understandable case for me is, the custom ioctl
function with [IORING_OP_URING_CMD](https://elixir.bootlin.com/linux/v6.11.7/source/io_uring/opdef.c#L416)
satisfies all the constraints and will go to this path if `uring_cmd`
returns `-EIOCBQUEUED`
[here](https://elixir.bootlin.com/linux/v6.9/source/io_uring/uring_cmd.c#L192).

So this requires that all the ops with `->uring_cmd` returning
`-EIOCBQUEUED` should support `->uring_cmd_iopoll` as well, which is
not the case for
[ublk_ch_fops](https://elixir.bootlin.com/linux/v6.9/source/drivers/block/ublk_drv.c#L1967)
resulting in a nullptr-deref in `io_do_poll`. I'm wondering if this is
legit.

Note that the related code changes a bit for [newer
kernel](https://elixir.bootlin.com/linux/v6.11/source/io_uring/uring_cmd.c#L261).

Best Regards


Return-Path: <io-uring+bounces-8004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CBCABA28A
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C212116DC53
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8DB2E628;
	Fri, 16 May 2025 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="P218QAM+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A1B1AAA1E
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419048; cv=none; b=HmgrNmLeyY62nldxbGPnZNNIt+fdCY8Js9agr1TF8sYjFPYY2H3iDS8Dzlpi+ax9uDnYQ/iNCfOwEdcAXoCnaEhkvDZF5JMA+dMrusSAPqZ9Vqk1LMKYt8hYNwwCDDOTWufXa35WzUVRyo1d0QAYqtpo75nY/8fMPBtt2DtfX4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419048; c=relaxed/simple;
	bh=OuKJZTjdA0CZmbVdm+dSmqPK5tAh++NDCTgR9KrKWVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGXwbUF+QamTDlaEb6hwSVwTQfDtZXHEYjicaQxM9LVhmk/U1kNdrHVR7t4DJVII7mcPiR8l9XpmfRWEJ/yQyo2ElG4tTrQ3rb+GdT5z/HuNZhceaEK+9/9X5qNGupe/wggOH8mIa5R/S0l2tC4IMQ90N8d9ZVWH/rFAy7dwsB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=P218QAM+; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b078bb16607so163672a12.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747419045; x=1748023845; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OuKJZTjdA0CZmbVdm+dSmqPK5tAh++NDCTgR9KrKWVI=;
        b=P218QAM+80NmIzSuxX7g9hGymwX7hRX9p5p5Xhiu3C7WfLziT/hSC6Y+FkQShc+IhC
         1D2y9jUAC51/ZimUwfYb2UhNwORIUT9Ggwc7vyGoyfBvsWneWBvcQ9XBUWi95JSNKNqo
         ij/3GoqEmGOssB2B0ss7CfE1E5CDfvQu75X7R+kQF9nZEDhjNnxcIwwoG/X3rQ94qBqF
         8kouReBPZ0WFbVOXti6bYKYHeoJG7tX9lMOBNLMG7MyIKEWgVJsZs1uaFJ8AB8nIcFMT
         jQNwxGPk79FnMMOv5yNuUgWsTPHdwZScVpm+5nKYBFd9YNzFVd64P1nDXjMxWYj9dwMg
         lppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747419045; x=1748023845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OuKJZTjdA0CZmbVdm+dSmqPK5tAh++NDCTgR9KrKWVI=;
        b=anBseRuzcoLDogpv/xeA5i+Uhx/4TawpDZSRm7AgFacERkurV5RF12GPvg8umCBMFO
         maxqX/PrkwZiOZ1K3usjRTwJxequxWK9H1z7mQbKw7vH74ODqyU9jEyvkr+p1G3SzkbA
         2ftSRl7nBgCeNu/A47bk/fKnu+bd1Pn8M8vMFShn0RjE0klq6ZMFZ56VYDgKiNP88kYP
         BWRIVSdCNO55Dvc7Mywt//6uP7xAB/fqhBDrH6TJk2TM7nlnoFXi37FUfOMNnbegHRaC
         YC1huFCfKMgEuvVHeO7F4Abb5HklLlaix/L06E1yuRl3E9y+izDoBVU3wFnqDZI+fmhY
         77hw==
X-Gm-Message-State: AOJu0YwEr4ZAxqKudR/yK/HEe3Ote3+OVqdmo5qaKWUZaFAe37ROdvyj
	sZklRoLv/XgQ3FM8j4FJM7VuUCRcdsKhIAjVA2f6dDz/axfz4wbtxnJG6BaI/U1y18KauIceAue
	YThPWwpRf8nhQBCLfkkkLbEHNnbtnxv7P3pLOhyXOurN/S8WBEhTQ0QE2ZA==
X-Gm-Gg: ASbGncuzmtcBDi2eeSyYOiGQy4TqPDI3lO6LIONivP5qMJnT2fy6qoJa1ZGjgtWFd/g
	LSTgD8Qfz18Ksp8JIrqk2csiWiqCiBFckszYwGVw602BIpQ8qapJDbRma5Jt+WFzpAxIxkTcdlt
	XqXHvZoow7eIXoiNYMy8M+ZI7Y3ulnz4Q=
X-Google-Smtp-Source: AGHT+IGBtkEzTI7hjZxBww+K0YS21g/GwOm25YcC8E6rgR9zXTpWMjLSqzake4kfyjQ92QQi7cZ0OklNo8EISNnewbo=
X-Received: by 2002:a17:902:c951:b0:22e:72fe:5f8c with SMTP id
 d9443c01a7336-231d452dd8cmr21948515ad.13.1747419045411; Fri, 16 May 2025
 11:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516165518.429979-1-axboe@kernel.dk> <20250516165518.429979-2-axboe@kernel.dk>
In-Reply-To: <20250516165518.429979-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 11:10:33 -0700
X-Gm-Features: AX0GCFuytvvk9oc47LFwcsOZfXw_6yreMCq_Ku6WeS6lYjf9MxL_ysT0VnGoOTs
Message-ID: <CADUfDZrSbZTke3kwdgtUgOa_8hNGi7Bem5-_Ge0OUpAttaML+w@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: open code io_req_cqe_overflow()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 9:55=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> A preparation patch, just open code io_req_cqe_overflow().
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>


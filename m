Return-Path: <io-uring+bounces-6922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 695D4A4CFF5
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 01:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7199C7A3691
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 00:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767D0522A;
	Tue,  4 Mar 2025 00:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cdzwxvpO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECDD3234
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 00:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048463; cv=none; b=n0ZOH355f35a800EJqv2uYfUxwB6Lx2TIoMUGWmuXOL57BsWHVp8VSHGobnXz3WmLvFs/DxvU0fYDb+huZ5OxYpFBWq9vAHFNo7E7u3DR1n4h3my3q/wphUco7HTxwWcUtARAKwqX1BXT4ACDh2hAp59hpX2xPnciXRtHASJy9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048463; c=relaxed/simple;
	bh=+QGuRG0nKSPY+zOy4RFkI2A//pZ4+bVKdAQ3R5oRnCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfQMhcvMq7euZTKwU0JsQhyEb9234xXsRZoAuCX886yZloYrtdmxbBdKE/70yDxtd173LyAoLNfh9l0NkUtm02ciPemw+9Yy0jkmBtX/EQAbxT6IvnkKmGEk5H8DQ5xxtaWwOoCs4w4kvOz7tAumRRhJy562pUZ7hujzZ105Ahs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cdzwxvpO; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2f9b8ef4261so1364180a91.1
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 16:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741048460; x=1741653260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/5SD61QdWYtIHb9kGRO3BkZZmDQ7G8hojM03tEamsw=;
        b=cdzwxvpO012lb2n/f6vSAc2mp1f1VFuMgPG2diGSb6ro93bcujG9xx+ApdVRR/pdP6
         SRfMhIAuzGUWbdRbadqv8gLHhZEmE/FMJlKXzmvdYmRDnxJl2TkT2vIk2V8bLaHQTWgJ
         F1Yt4issJHbggj4l9GvkEUFdEX5QxgS5Xhpwhd8NOopckhAfxVt5Mr9Exl1X+IJ7r/Xt
         9xgQ8Hs8M+yzrS/h6iy6NqK5OhCqUk2SBb2o9td0UJF+ECUh/Fk7v9FMgaH1jWxtEe6q
         Azvq2XO0xVD0a0tuv2vc+nmJSqA0JdlXHj1/iJtD5xTDrTazHhTvLlG2PO92uvJlLaB9
         3o1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741048460; x=1741653260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/5SD61QdWYtIHb9kGRO3BkZZmDQ7G8hojM03tEamsw=;
        b=L8LCaSeme2JkL84h5sxtDj/LKqxRHBuPomwlZ3DJiTkDvIUqqbYh8F5l0U52FKCJXs
         hIdzCSZtMx7P31AV1OAbVUPn8Ix4Qms5cKMcNBiCFNa2nyeuVlGpr/ykgw6dP8wjZZ15
         AzKlEkBOEooUsXxcWRxPjRo3bgA9k1KF9IIniTI64wv3CTBuftDlHM1KUCa3ZVBP+9+5
         PZzP8TpHob8CAqfO/JHwuL2ctt57nAzpuLrL0EjOas3GoJTa6WiRCI52WbXYcrSme4Ar
         JYMDdYZ0mgt0+ogns6zNfJYkGl56PsnSrLwdWL/iQW0EPeZQkH3vjWI55kO5swYEObhS
         lULQ==
X-Gm-Message-State: AOJu0YxwYKKke9Y5Rty/Rzt5VChyrZy+DaSv2R1I2v9Um1rAP/D+kzCo
	4rylk3q2Cw+sIf+/wNzGMaXTiZ9iAJa6pGzDM4656nS4PoT4T+FGjOB1reBUZyiry61qYMHwQ6U
	2gb1fHbZBHfxtc/v9QQXEN9bDt93YCUTb5tIxvQ==
X-Gm-Gg: ASbGncvDi4WSWLe3SgdBthVQ7MmMff6GG9+aHj5WyFJoGwXuuIt/3yovS81WQKDKbQN
	NNVudC31APcCPIRshKY48YBRF25w/IAijqIlVN3Dql6y7Cm3qCGKSC4KUl7Y8ERZuatwhDWGkjw
	knT74i8Uroqsrkq25I/zRmmVH9
X-Google-Smtp-Source: AGHT+IGqbdPaWsRPEVhyfDT9Y19kixDp11oacVA7Xu3nGcntUnimuKtM6R0ZH83xlFjNh0zEh7X5i5MYwePZP+aHVL0=
X-Received: by 2002:a17:90b:3509:b0:2ee:f59a:94d3 with SMTP id
 98e67ed59e1d1-2febaa7f72fmr9416490a91.0.1741048460635; Mon, 03 Mar 2025
 16:34:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 16:34:09 -0800
X-Gm-Features: AQ5f1JrngwIxYI5W0H3udAWwHG3pMY1VsOn3Nx9UZRrVWegA7QjTGxtAr5emBaw
Message-ID: <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:51=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Add registered buffer support for vectored io_uring operations. That
> allows to pass an iovec, all entries of which must belong to and
> point into the same registered buffer specified by sqe->buf_index.
>
> The series covers zerocopy sendmsg and reads / writes. Reads and
> writes are implemented as new opcodes, while zerocopy sendmsg
> reuses IORING_RECVSEND_FIXED_BUF for the api.
>
> Results are aligned to what one would expect from registered buffers:
>
> t/io_uring + nullblk, single segment 16K:
>   34 -> 46 GiB/s
> examples/send-zerocopy.c default send size (64KB):
>   82558 -> 123855 MB/s

Thanks for implementing this, it's great to be able to combine these 2
optimizations! Though I suspect many applications will want to perform
vectorized I/O using iovecs that come from different registered
buffers (e.g. separate header and data allocations). Perhaps a future
improvement could allow a list of buffer indices to be specified.

Thanks,
Caleb


Return-Path: <io-uring+bounces-8287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AAD4AD28F8
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 23:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B72F189232E
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 21:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F36421CC41;
	Mon,  9 Jun 2025 21:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GT3rbZsE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6821401C
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749506000; cv=none; b=UaB8bLHRwXbBPUvSOZRGjfXNy7t2gk9L36vla9ij0RMcs7nnUE9rcZ17UR/Dd9sXZldkg9+MJZjsHkdVKpvfndI25tQCpf3IHTXuslCSxFkko9J1Uh43siJp8lLmHVkDXiVhLJOFefQqPEm4RhwYqnHYBscFpvizjd+0sFQIQaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749506000; c=relaxed/simple;
	bh=ZwgZOCAo+wDDgAYidLGuY9roGj8BM5BlXQ0ip7b3wTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S3Qv1IVNjdxPlnO+7/BIk8o4FWzIzdBBelbcZCa31+SPh5g1R+RRynXGjaMAgOaq2RNnlgSQ/oFiQPUPvRyBphBFOUwU0jyAeIiC5z8XAqAAsJfvqUIwE0rHPAw+8FBkP9LPkL5Hp3id2f980epXqG/U4JizkfnWH2kPH8u2kqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GT3rbZsE; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73de140046eso410029b3a.1
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 14:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749505998; x=1750110798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwgZOCAo+wDDgAYidLGuY9roGj8BM5BlXQ0ip7b3wTU=;
        b=GT3rbZsE+J+fg8JMbHrFR0V3HrxNPO/nxIRpWxi2talqNUGeqzI3xVwAMhgukL3JEl
         qtVJkf4oB/bj7MUQ3aISbb/RKRk2WdCIuYnbhMAOXyJaIojhDPhSLU8fu4Wb3AOioDKQ
         MCWNKTWxQpAu8MnAaf2+fyuk/VC+d8yb3jhQ1t6X+O1JaeMTvZytrbdUh4tsCPTGi/O5
         h8ghB+W4oIQhO60VRJSjCF8nygJJ9LLxsjQsssuGH9wnPI1YOJMvUJBq/vLubNcKYf10
         CxgH55q6T/nSXajM5pdGcBwTOBjb80c6ifbXq9LMMGYC+oKV4vK3w86z5k0H8JvNUDnx
         oqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749505998; x=1750110798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwgZOCAo+wDDgAYidLGuY9roGj8BM5BlXQ0ip7b3wTU=;
        b=Vrkch7GkhKsdPofTjR8l/6GrmEMYnegzRZwe2e1viZDcWEtzubgABnpCRIvUzv2RYT
         fVFRwC2pQHg0tCSxO4RsGD26AOdJqRwLMUG6MSQM1GHrYox8mxY4TEfNP6xC4DYjOIyI
         si/Ot808mYxJvV7e/gQ2GFh16I8Snje/9arhIS2vHCcyVAk/faG+B8MHY3pPvgUSzbfG
         d8ZvckI3WW8VZvHBAEuhVxkjOAJy8n5JqMFwZYIplrOqICM7EfADU499EzHV9CXJkjdQ
         XoAJhuZpuGKf4eoCVfD+BDz3yVmG3692S86PmIbIP1i6/797ATARpFQ1dMKDc24koRFL
         Hr7Q==
X-Gm-Message-State: AOJu0Yy39DvPfZLHCoFUuDq2mGtwPNurB5EEVlLn7QrGdV2vP9rR3NW5
	/oKKSpJvzIzO6LyjmM8JH5LZy7pgD8daOtPDpdIwsB42ZBzTZ6DxyWBC0viEecRF9YDA7vHIRAl
	QsbIl3Fm2TpGUupjmF+qm01z6Pe95DY4YMwI3MGdNsh+8z3Hk/i+B
X-Gm-Gg: ASbGncu3kHzusNqFI/9+RqrdlXvGVIoaVgcEW+mk1vHgYjtj2jpdTMoZ6xc8rLcEBc0
	oe+hFDfYM/L9jr+6xSAoj/6fMqpfDhGf4kHwhHSkv9HuhVDZEsbyBcu5PKj7SD8Ve5IZqOwGV2h
	XXpq2U8N1Ydujjnns5Rg/5Sq87ezYRQ4XlnpYMvQDBZKA=
X-Google-Smtp-Source: AGHT+IFIuxyCDWhofq6eXeWFS/L+t6dTYrYBqc+8G9PiDPlzeZFOdXrh6iCSSVAoY7O39MDEjT3HhVGfCCV5yxs4EqM=
X-Received: by 2002:a17:90b:1801:b0:313:2f9a:13c0 with SMTP id
 98e67ed59e1d1-3134e2b90f8mr7299230a91.1.1749505997846; Mon, 09 Jun 2025
 14:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609173904.62854-1-axboe@kernel.dk> <20250609173904.62854-2-axboe@kernel.dk>
In-Reply-To: <20250609173904.62854-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Jun 2025 14:53:06 -0700
X-Gm-Features: AX0GCFvHAYEmxykNTb5wwpLOcgClWv7sOLmgV7jidp3P_NjHiwcM7XhGpZRuFmY
Message-ID: <CADUfDZqrQrtZgvthjyH+qw04K71C0BuU4JG_jjEFi50ZB974Ng@mail.gmail.com>
Subject: Re: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 10:39=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Set when the execution of the request is done inline from the system
> call itself. Any deferred issue will never have this flag set.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>


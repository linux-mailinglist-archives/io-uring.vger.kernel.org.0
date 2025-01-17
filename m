Return-Path: <io-uring+bounces-5963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B525A14BD3
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 10:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6599C163F6E
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 09:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73AF1F7918;
	Fri, 17 Jan 2025 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Y1tpCXbF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0081F7914
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 09:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737104866; cv=none; b=I3cFILsI10qV80T7/5TKTih8Q3gD/qjUq5gN5jxKzluuRsiDM7tp17eVUY55R5E0yI53fkcY45HQRdrKgElJAtz+NYDEcrRt4FwTjT0wkRVA3ke9JqsB64ENfoM6qAeCLRKNyMr8yceMiHGZKo/Y/g6IKqzSxJ1OqFj/QVKQcD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737104866; c=relaxed/simple;
	bh=UFZLFZVOSPFTwx7bGx9gIu1IzEKeA8HNkjx+6oyAzLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R43OkCF9ZP0gY2iiZewdQ/t0w2Ow8Qml8ILPbrRMrRcBB8rZcnTffjidKAQziFHIw1BacTszPoSq3IUsJRuaOtr4YpPXMpcBKg4jGOghyBSIOkqGud01UblGsvCnBqxIJh6dza/sZcdKrUmtAwgKN/Zt9pSFY2b1Hv+GYh1LDo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Y1tpCXbF; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-467b955e288so22351521cf.1
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 01:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1737104863; x=1737709663; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n2D0doGdFPmRbwuIzISntkHAs9R4c9ifeS/tzPGrUjA=;
        b=Y1tpCXbFr3tMpaeZw4ua7HxvfhOLkjznmWmv9NgMkQj4e5Yw+6Dj+LZg3xCvvyflWL
         yBzrHFNsV07MrkRp//NOndsRdSHO5MqWoJzQ0zC/2f0CcS9y/H6BlNRyIg7o7Ccon6LR
         +Ip4KVD8fMi19obD8Soj1LZJptO03GHteqOjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737104863; x=1737709663;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2D0doGdFPmRbwuIzISntkHAs9R4c9ifeS/tzPGrUjA=;
        b=bcO0M6DcrerJzKAKnjjKW2Z17IS+1RC4+mgnfW24qme5NYOGaxplgLq6F3f22b57tu
         /leNjUiclKgZVAMLH/QfDCuNwRKwNrJbZZkZpviVrCXk49UHHK5zUN3cuPDrr0Demt6T
         YHooNS7Kp5LMVuPCZdiszP79RFAWMvQ5+od/cwfkrCyBH3SOOVPtQLIcHf/SCJa+1K/h
         ZN4NflCU7Mw4T1hHdh0TludYsuhencq5x6KxYzBllclzjeeuRNcNJ8Qj+qU0cQKbM2JO
         j/SXmsU0EFJxX4r+umEQHQRWmrMiAX6saPOlyBztIReezCBHLH5uahD1T7KkI1Y1QLGX
         0o9g==
X-Forwarded-Encrypted: i=1; AJvYcCVNa89OCT/6Sd8VmB6XTF7n7muBbovruuA5ZRrPvSbwM7MPSrPborV+PH9tDVfiBH1NF78rtBx1TQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk6zHWustLuGpj510znA+zL+QhLMDMBnoiPw5ZEvv0yAThBsKI
	ObF7nip7E02XFXYbYnQ+QQN+xefLMqf+tPdOHwhAKVFg8m7dvu6lH4BiOiyUVh2V7oySw0QMuGo
	rmW5PAFxbSrrf9FGyHTkuIAamcNq7ZGpA/qzGOg==
X-Gm-Gg: ASbGnctZoyNxZ0QS/UpEZ9rGFgPSTGAr8nChP5cZWf9+1hcqzsSh+E5MvJaBQDkoJVu
	QwxTrJuvUuzDKAMaIM57QY5WMuZvUu0baq4FS
X-Google-Smtp-Source: AGHT+IGCDFXeS8ZzLEXccqU7GkD35tBBU4jVnwPVdQeOUlK2kDh1P+jQkHKBdM9rdPN3md+V9k3szdCmf8EjZ/p4ims=
X-Received: by 2002:a05:622a:303:b0:466:954e:a89f with SMTP id
 d75a77b69052e-46e12a60c6fmr30515191cf.14.1737104863020; Fri, 17 Jan 2025
 01:07:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 Jan 2025 10:07:32 +0100
X-Gm-Features: AbW1kvaGPCBOasgyxU3CSVJGl8V-5w868NJSd-B2xqXvfntoT4JB3vfn4s7uhQs
Message-ID: <CAJfpegvUamsi+UzQJm-iUUuHZFRBxDZpR0fiBGuv9QEkkFEnYQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Jan 2025 at 01:25, Bernd Schubert <bschubert@ddn.com> wrote:
>
> This adds support for io-uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> approach was taken from ublk.

I think this is in a good shape.   Let's pull v10 into
fuse.git#for-next and maybe we can have go at v6.14.

Any objections?

Thanks,
Miklos


Return-Path: <io-uring+bounces-5686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B70EDA0318B
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 21:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03D367A12F3
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 20:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B131E00AF;
	Mon,  6 Jan 2025 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxhvQEui"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEB81925AE
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 20:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736196347; cv=none; b=heTPCqZz+KneYwAoPEHYfKyqzAxDEcQq/rFFVIGMJhH6cnvBX3iqxuSNRi/O2SrHG6b2ywXyAYp4Y3HT3om7HMOR7TkSCg18kFPj8kZYQLD1VLmT2sXJmQNpI7134qMaalDZoqKwJkvoiWaYwOa67tVF2q4yBoq+ubwyrHrYJ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736196347; c=relaxed/simple;
	bh=FAxg+SkOU83c6OaYj6SB3q3Ukat4X+m/uYn/jmu00wY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oDDEaajzSlRJg99/71BK+rWuRHoxOoqNqF2YWSQnMPKcAgX1SawPb1HoBCKXvwEjbqk9+H67AdhP0lgIWEz2pmu8lA2Xg+GFV63BG9dq4bMeHjpd4YBgF4EHyXVt8zmCvoofklFCt8o/YXb7AwuRFfCg9zZlt9ECa+mooHOkt8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxhvQEui; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467896541e1so56391cf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 12:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736196343; x=1736801143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAxg+SkOU83c6OaYj6SB3q3Ukat4X+m/uYn/jmu00wY=;
        b=QxhvQEuicN3/bLG2ZyoZvIzfPHyIqSaCZVashhWlwS4lv+i/kZNYTQeXXzLx8Nrj6s
         G6A5GBic0QXdOUb6DcHBhg/ut90yxfVlgd/PJ5CXPbQ5KQibBTG6ZP6VfZ45nQFOYp0x
         bnRR6UWukA/fD4VyDcllCI0uU5TOqF76MnO/vYhm6J36OOrn2Jc//zbigB+cJ09yG3DT
         1RoNZwhqKHpj+4lciFyf5edAgnJk+gUgvCNhbONmjJfkcNDwJzFl9338B4EzqK5Twn0x
         j9nksNPIdxndEds4M/o6s0XHU3kJjwAvaF4kH4vj0ckRvO6z7X8yqFH6cvjYftlv87ky
         J9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736196343; x=1736801143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FAxg+SkOU83c6OaYj6SB3q3Ukat4X+m/uYn/jmu00wY=;
        b=jMe8i82NqlhM5MnZdAwTIE8Uvj/i7LVHle3rdST60S6wTjJsOzWz+Y7FveKl34VMhZ
         SHwW6DvdTAsJMy51FnpRo+/AxjjIh56kWbUUdA+sYo9DoxwgzmRkvswf+8JYvuP23vlV
         T+9//j5ZorSf7enOsF2OwzGKEZr7Ftli3OaTq0MIN3cbFjD/2kaL9Mu7IlHB13vMwF6f
         IS+xzNjHYNhADXg0lGAti0IL/XHIw+9m2BT/8Tb9CEj++fG9WMeAfiHtL4CgQKWDBIQS
         nj6r47/bQhJ44kKk7rS3Ibe7lcj3l/B69phRVySWTcvB9f9CBiXWqXYzJItwN1WrYPx7
         wk7Q==
X-Gm-Message-State: AOJu0YwXShPBIFdiuVZpEWp8SnbD8sz1jW3NabSrh1Ql5FUn9rt+U6G4
	IRR8TQX+uIB9bbBiN7H3Ukiw2XNwYaM6DAwLKxPEFHN4X80NxLrpUDY8QP+hBwhDBKaIAxhmReL
	BNh6phcdN/c3abm+jzy27N7ZmLU6ehOh0yuVz
X-Gm-Gg: ASbGncutpfQ6swLbWKIDsSPLqb8d+nO6Be5anjl62LVv3CvTzBVPIGPuVAZvpmixChh
	CkzVpXbNYohh/y1xc1wCa4axbtIATbG7e9WD/XeXzf6uSvz3wsEeCLRDUAHzAFcllbshb
X-Google-Smtp-Source: AGHT+IGtTpH+G0YJrloWbIQEvhPngqSmxsGSqBlWsCji6r0Gk02n1TRnD4QGY79JM8qFRdYpkknRQBlJ2Lwh/ytKxIg=
X-Received: by 2002:ac8:5a48:0:b0:465:18f3:79cc with SMTP id
 d75a77b69052e-46b3ba239b7mr400181cf.11.1736196343404; Mon, 06 Jan 2025
 12:45:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-2-dw@davidwei.uk>
In-Reply-To: <20241218003748.796939-2-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 6 Jan 2025 12:45:31 -0800
Message-ID: <CAHS8izNS0FRj79jjwfxBPam4-vR3gX54xyXxjjGpE5NJzaerpw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 01/20] net: page_pool: don't cast mp param to devmem
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 4:37=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> page_pool_check_memory_provider() is a generic path and shouldn't assume
> anything about the actual type of the memory provider argument. It's
> fine while devmem is the only provider, but cast away the devmem
> specific binding types to avoid confusion.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina


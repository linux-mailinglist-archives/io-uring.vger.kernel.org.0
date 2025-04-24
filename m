Return-Path: <io-uring+bounces-7715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD9EA9B6B0
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 20:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 019FC4A7BD6
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 18:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B720289369;
	Thu, 24 Apr 2025 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylzR3I28"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA81B14B06C
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 18:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745520571; cv=none; b=AaGZ1RgfNIoyTJJ4MI+cRUZSbw+5Fk7dE7OuJ/z0QCtLAMhAFFrEL15n8d7P1h/C8EyoKUqNc96ocsoi148CxCANgeya/cdxWgZQ5hmSGr6XsU1whs5RHpy0TWhKPkXGP8yZij1FNoZmm0jWPHIFt7Z4uMA6MReuj39gYyXmmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745520571; c=relaxed/simple;
	bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hBOaEcWCAhZd+9osiz235Da4BwYzd3FAeLCthz1HfOqzpcVY+HJbGobo57hKxE+nCXhwru7MmP1h2pD7rSN4kiHft5CICfSaPnCOFYic5MI7QmV8BBdE8GmU3hHE8MPIkueAqaVWddXpXB+9vRFCRQIMBcqcVKWD9vhu4J4ZlCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylzR3I28; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2242ac37caeso17355ad.1
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745520569; x=1746125369; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
        b=ylzR3I28/yHFuETRVx8TQjGviT85wGYNO9xhZfMuqph6DIlhaSNwaWlvkbtPK+qs6B
         ElMVBnjACjOFiHTrBVLwYd0Ca2Bvc55SIR11MRMKQdqC8pWDQ02LcBDNfeiyTRnZ5NNU
         VMrctS6S7a6mrVAt0zxIvDmckXP/ME542w8bOGeXP/yi/f+pdH6jDv3F/FZqfds1HJIy
         CmMS680r1gfHpGVYwT3Dpz2TINkurECqb7m/VPrDGvlHQ8N/F80q96LKwbu+ATbjBkLf
         pAIcJXHi1I9IhYCmVJiTMIOvpxgVkg4KgEzzvZCM1nspYuccVgdk/hS2G9SO+thvSb9j
         Wi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745520569; x=1746125369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJThV8OU+yLTh48RfiUdm+OTToDHsoL5U/oCrdFEqDQ=;
        b=nORKyuXF32zefT62N8vr6hBbEBUFgKH6L1TC5ESLbZXDVLwEUp59dwmEE/jhyI2q2P
         11sQuND67nj4GMrncKopwSWEiyPcPXr7cHg2KLbyT1Es57of6Lbn2iVkC3IBrRu07Id9
         QqtSk54TP9pwyKK5v2OSYIJ7SOUnnJI9LqpK+KXM4XTDM79h7CjuIxYWv3RmujSKDcQ1
         AbNZ/0/90IcKZFV2/tHOGk7CsP8ymltxpWZBhhkNZd2va6thqOPW8LpUKbTi0Ndldnfn
         nhK9Lcle7WjvTohfJtb4n6hKK/L0CjSF4MVH2HAFwnu5KVslvRIVL1PHYmR/Z+pS4eaN
         HuSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh7mCHm7W/LJv5gDYQmDWVKoQXFFiNpouqzLcpbNV6owEJ+5d07+XiQIvTYxOBt3Vo57iJHajKew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQt8eEhZARjg9wEHNfaUj15QEqC4SA6m8v8J9qu+FZv9tYeWwM
	5z7fncWIZRSMNxbd3K9m1PMl+TdbziCSqFTHOv88SXk0Q+BIpawzf8U6IHYemWtrXZi4UIu5W8T
	X4yorroTBQVyo28lkWglnNvQqyr6lptCa8gIp
X-Gm-Gg: ASbGncswow8fkZ6vCHMGeHebzHC8SbLVgiY97xK1k/9Jr8WvNZe3AdiXcL6AUwlaJGg
	NIk+fNhb/DPxRGYET6v/pELhn2taY3laT5sGx6ZniVPa4qYu9Wl7Mw97Bv0MRR8114EaPCUckJB
	0HJzPtBy8W+1QQCUqn4nIzfkRENnexUQXEygjyk7wJIXAnRRp7RAWG
X-Google-Smtp-Source: AGHT+IG7TvFiypkSdm6cFL8QXv7Geze56CiuyUqiMCDjIy5B3tjxrLsMvkElYIkhtHnXIN1qIRY0zGBcPAIono1A5h0=
X-Received: by 2002:a17:903:2053:b0:220:ce33:6385 with SMTP id
 d9443c01a7336-22dbdb49fd4mr181535ad.9.1745520568724; Thu, 24 Apr 2025
 11:49:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424040301.2480876-1-almasrymina@google.com>
In-Reply-To: <20250424040301.2480876-1-almasrymina@google.com>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 24 Apr 2025 11:49:16 -0700
X-Gm-Features: ATxdqUGSuXy2A5TP0CkyPakNQ5S2ontOlQJJboyrRu9J3Ao5kJdPZ2OrP3y4P5Q
Message-ID: <CAHS8izOT38_nGbPnvxaqxV-y-dUcUkqEEjfSAutd0oqsYrB4RQ@mail.gmail.com>
Subject: Re: [PATCH net-next v11 0/8] Device memory TCP TX
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 9:03=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> v11: https://lore.kernel.org/netdev/20250423031117.907681-1-almasrymina@g=
oogle.com/
>
> Addressed a couple of nits and collected Acked-by from Harshitha
> (thanks!)
>

Hello,

I made a slight mistake sending this iteration and accidentally
dropped patch 9, which contains the selftest. There is nothing wrong
with the selftest in this iteration, I just accidentally cropped the
series 1 patch too early.

I'll repost after the cooldown, and if this happens to get merged I'll
just send the selftest as a follow up patch, it's an independent
change anyway.

--=20
Thanks,
Mina


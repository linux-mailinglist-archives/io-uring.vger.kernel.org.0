Return-Path: <io-uring+bounces-7697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E717AA9AA0E
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 12:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D1921B8065D
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 10:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7825722129E;
	Thu, 24 Apr 2025 10:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzgpgHEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4071AED5C;
	Thu, 24 Apr 2025 10:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490287; cv=none; b=oymrijihsY1QTC6WioDggbnFtXR/NfGFO+D78+5UfXLMC6sa9H90yRSgenVElQEO3ck2jyRVQU90q9DNV9qOMJ4KqSNpaGbmczYGsOdc9Lx9iRuLoccKwJF05NfvKSxf/x6N4pvt78zPwkvzLb1C+5M1XGJ0KMdiJGlLF+Vqgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490287; c=relaxed/simple;
	bh=xRGlQ+YuAfq0yjKo537Wvq+MxdVlDxgBBdCxFEB1sqw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=fhNS0nuufWD/2erYPvzrm24NnzJJLljVmz+6E8T028BPLZmaa2M/hSGDzMf6VBJRio/UKyR0afZblPM4H1jbVt+4wZqClYHVIdRiopih2WiNqwpB8w8wZi9IYEAKLpdLj4ThKCkUQfFDb+OhJ5FRn2nYhgCz2S9cXPDkqLMgl/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzgpgHEW; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39129fc51f8so658757f8f.0;
        Thu, 24 Apr 2025 03:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745490284; x=1746095084; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xRGlQ+YuAfq0yjKo537Wvq+MxdVlDxgBBdCxFEB1sqw=;
        b=RzgpgHEWA8qQetLQSrwWiOGfWTGwLA6ArjRUvGU7JtwK/q5BjJnXFBF+oGWjVs4oEm
         e2jLEVgBmaPbZ6slJVBnJZSAJLFcbwhAQOc/CVdvPKvStaI+w0YTe7+sNadU7F4ZkJnH
         QEcTjyBEjYXjYe+3gN6Kdts5CbohE2Dr1uhjLhKsupBgZkQ9NnwsEpYNE0VML9mUOrmE
         Qj5a6lii00eg29QxE4dLW4Zuzq1+h3f8OTUyCLCTjWu7oA06t+2P8MiCJ671sP54/rGP
         iErA5LoSviEovRF4U9OvK+iDscgD9FQ5XWHv0RlxANgrIn+293FosHp9cgH8pvX4XBqB
         keBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745490284; x=1746095084;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRGlQ+YuAfq0yjKo537Wvq+MxdVlDxgBBdCxFEB1sqw=;
        b=dhnuwwXV83FcCKFW4fmpb4uat7d6QjM5qXl50JWHFvSafXlmwyxzJWZQZxj5aReQpn
         djsZpfZ8o6yE2DwYswA52TwHFhek2w9USgteCp3iECIhayAqFq+yuAeQZoTAznPbPKKm
         zZw9tFjEkOM8GLWVe0AahKW1SeYR+nX3VUUhJ4/oYboHiuEBBBKPYTzwZmrkXsQcOEmx
         wdk4bWVg3EXbwOeyOSJGOk8CBUa18ZP0pQZx8QaCWqVxO2oNovgTXzphM34e3n2DRNWS
         +KJQ2xDLLm30zHyFKTuFeOHPuaNREzeLgMVXFX+kyDPTbHO3H/eH32ITmrxrNF1K4dN5
         d/hA==
X-Forwarded-Encrypted: i=1; AJvYcCURZD/iiSkYM5jq7zc8hPo5yyTEB0bOFOyeF+GArJ3XfBMsqXlcw5HGnFb9twEJvNGPzAdz4XSkZadtkyx2gPrh@vger.kernel.org, AJvYcCVYa8gwn7OLIrf+6fr6XP2fB/sMA8hgSaCvzJ5t1KwjQRcI4Glm4eN1Px378nUk1+zMx7LGtCyNFunVR8FZ@vger.kernel.org, AJvYcCW7cirSayhcy6QbZ15JbSll151ih6Sn5SLwJx6hEWsf3pscj9JIjbeC0knxi7DbHaea0zICVz3uJsf8@vger.kernel.org, AJvYcCWTpl7WibZmDd7mYbOf2Ar9f/KMa+wpGUV1j3YF6/yL2Bh7Mza98yZZeAYmV+zM9Nk3nwNC@vger.kernel.org, AJvYcCXic7Dr+Ubb0rDt9AFxTS54UNA/eXr9Hty6DJA/6WGIPcLaJMQzbQd/b/TFbPplmJW555n+nN6cdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1PBt0m+5F9XucEx9qyiICPcE2oeBFsXdt035xFCGiFuXlekTt
	l+EQb4MAktEBfQxFx6Y+h3rrn0Xt1taz9ulGZkipsR7u6GqFniX6
X-Gm-Gg: ASbGncv8zjOh2Ql26IxT/ZQJ3f+Yhn/1xGKvV0RGbeRSdnfkUqJOhIgT1sZgePInHbO
	5MPaK9pp+2tq0RjX5cub7RR4cKfJSCl284eVclQ90N3CIBGBU9Z7kFCS6axwVYaF5v+62O4Gvzn
	jtavxQFkrj+4V0ZTpi3bARrWKcGyoHdKaNbNkUPD8cLDMc6l60pO1V75hcCx8jyOwkiPeoX6PCI
	KZTKiRnHS+on3Y6AFeDBgBIz+fIj5uFwn+ZiVD3YWUzi8kSPvr3fWqvZ/Sf/xZTa5mDGb8yz41c
	1iEw74yY2VZUUhP4AHxJ/cxYeBWyPkmwjE9BMbrxr7UbQL7Cb4S1xsmEy2c=
X-Google-Smtp-Source: AGHT+IHEb3DW07bLAA/VXg08jEDjB059mOzNk65AI9NhSRJOViAxq2muSv9evi1rARkf40X091csiA==
X-Received: by 2002:a5d:5983:0:b0:39e:e438:8e4b with SMTP id ffacd0b85a97d-3a06cfab546mr1827774f8f.50.1745490283934;
        Thu, 24 Apr 2025 03:24:43 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:7d34:7f0d:292f:fa10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d569b38sm1578696f8f.100.2025.04.24.03.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 03:24:43 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  io-uring@vger.kernel.org,
  virtualization@lists.linux.dev,  kvm@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  Jakub Kicinski <kuba@kernel.org>,
  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Simon Horman
 <horms@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Andrew Lunn
 <andrew+netdev@lunn.ch>,  Jeroen de Borst <jeroendb@google.com>,
  Harshitha Ramamurthy <hramamurthy@google.com>,  Kuniyuki Iwashima
 <kuniyu@amazon.com>,  Willem de Bruijn <willemb@google.com>,  Jens Axboe
 <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,  David Ahern
 <dsahern@kernel.org>,  Neal Cardwell <ncardwell@google.com>,  Stefan
 Hajnoczi <stefanha@redhat.com>,  Stefano Garzarella <sgarzare@redhat.com>,
  "Michael S. Tsirkin" <mst@redhat.com>,  Jason Wang <jasowang@redhat.com>,
  Xuan Zhuo <xuanzhuo@linux.alibaba.com>,  Eugenio =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,  Shuah Khan <shuah@kernel.org>,  sdf@fomichev.me,
  dw@davidwei.uk,  Jamal Hadi Salim <jhs@mojatatu.com>,  Victor Nogueira
 <victor@mojatatu.com>,  Pedro Tammela <pctammela@mojatatu.com>,  Samiullah
 Khawaja <skhawaja@google.com>
Subject: Re: [PATCH net-next v10 3/9] net: devmem: TCP tx netlink api
In-Reply-To: <CAHS8izNUOO-X0WHFTMd3_yEjCDu4sPYADE1oDEtWTYFNNMB5wQ@mail.gmail.com>
	(Mina Almasry's message of "Wed, 23 Apr 2025 10:59:17 -0700")
Date: Thu, 24 Apr 2025 10:06:42 +0100
Message-ID: <m21ptiszbx.fsf@gmail.com>
References: <20250423031117.907681-1-almasrymina@google.com>
	<20250423031117.907681-4-almasrymina@google.com>
	<m2y0vrtd5i.fsf@gmail.com>
	<CAHS8izNUOO-X0WHFTMd3_yEjCDu4sPYADE1oDEtWTYFNNMB5wQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mina Almasry <almasrymina@google.com> writes:
>>
>> The bind-rx op has "flags: [ admin-perm ]", should bind-tx also?
>
> The omission of admin-perm for tx is intentional.
>
> Binding a dmabuf to an rx queue should and is a privileged operation,
> because basically the application doing the binding is taking
> ownership of this rx queue. For TX, no such queue ownership is being
> taken. The TX binding just gives the netdevice access to the dmabuf
> dma-addresses so the netdevice can send from there. It's very similar
> to a normal dma-map with normal memory. There is no need for privilege
> checks.

Thanks for the explanation. I couldn't find any mention of ownership in
the docs.


Return-Path: <io-uring+bounces-7664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03167A98943
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 14:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5AAD3B896E
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 12:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB12214A91;
	Wed, 23 Apr 2025 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RA/IakGU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A460214238;
	Wed, 23 Apr 2025 12:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745410294; cv=none; b=llFNTFFFxB+rCEjG7eU03FDUcLfenujYoWN2VgK9vTv9YRay/xiSsFZ7+Ansjx38y0olOEsrnu6C4m3cXIUKgF1YOHP2OlPhRMTDICbRdorfQy+6yV4o0j1ZDMkNFWSbhw2mKrqAMJz42+P3Ki/UnqWLFdrEXlMoGdAySuRr2Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745410294; c=relaxed/simple;
	bh=yQ1UlwAJJHcI/OsM/WOjpj6zZr5R1RBZAV3ItX0DC38=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=N+E4GB91T/PomlOsrtzww4SOOq7Zh+32cIITrX7auNyPgx3VWMQd6GYhf88pk66DC7O6KQL2f3BgDMlwtgiWg+iGR/CkcLJouaI3KU0Yr4hwWR7dgUMLUPLAuhJjFwxsn8p8O9KXQx42mCInMnJpPxWF1x1e31l0xGWspatb6CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RA/IakGU; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39ee5a5bb66so4518732f8f.3;
        Wed, 23 Apr 2025 05:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745410291; x=1746015091; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X3ENo7G6TW6MBK7yQ4g9B813KgFySi5deAa4vwegzbo=;
        b=RA/IakGUAE314HKgCxzSRavMmLjLVqVOywIwiiM6mYBNWaips1FG7WGC4DmitIqk6X
         +BmqpAeMPYNFpmxVMBalFTt2Ozli1SavYqeyDEuElNPxrkXU5pEXedbD5xZk8yKs5VZw
         rYUKkc/OA04td/Ok9a/0WapdC98OQkXlRM39KdI3Q+41k1LFCIQPmJNPutQD80WPI/Dw
         MeQPrRTHh5hbcOWmuGp+ENR0xiq2uQqHiMWVL1Lf0Y67JgXUJU4S/fS1Yr/BQcZ6Vrb3
         boB+Lia+UztsUdY9kpe/16SWLPk2f9LHD43qNtWko5o3IAoEVzHXjEXr+77RA/LhFnOG
         /Yug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745410291; x=1746015091;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3ENo7G6TW6MBK7yQ4g9B813KgFySi5deAa4vwegzbo=;
        b=i95qrxRgoro0W0QeSGXiFeecNWLObRKTRG0N9wL5fVmRQZafPHD5ke/o3/jRDmFUNU
         t9+Q/ce3DpclvVedzhL7Y8MHwTWFmZ5jLSnjbyEZKBBO+T/vi6taybTwc+jZZKNJvS/k
         vXcF7ZuPKPjXeK0t1WjXU9xo6eTHsmGfZdOnTdOLW5zR31U5PKYfcNFT5Zp4JMSWY237
         VE6XvXDQLIir3YDj1jc4PjADOopvmdNrAw7efJSei6llViQRu/wkbyIK1/e8Aasf4loh
         tDcWKJaXMmxzfSqo5jBG464clnV8ujfAa7tgScc4ra7ynZntiS2MLc0wK3Da/NMt8v/4
         1P5A==
X-Forwarded-Encrypted: i=1; AJvYcCUE340jGHA5GeRGg2oc0Zk281QF4cfMEy8mJn4ngPSH9iW5bpyelbbM8eUR7FJIs1SHRpyW9yY/mt6VSc8vk6gk@vger.kernel.org, AJvYcCVhuygUCvyYhYt/IfW+CFJYhyGEJVftx7feUiqtqdB06kjyDPGTNkTEIIKPYZyeQe5siKXQ45h1Bc5iGWTA@vger.kernel.org, AJvYcCW2fMJOPO3fE+RyxLSpTpgJNylKfsGWbJdWl/sg86ML5gyRkxxFBRZnddLjklpFQ2ipxQSB@vger.kernel.org, AJvYcCXsPhFy+CwsWSs1veMVV5EXOn3CFu34ykI9kMm+DVl7sYMJtb42ZooyTOuGCRPV3nuDl+O/KD2rzw8p@vger.kernel.org, AJvYcCXu9dzhluoAmOl+jAwrRC9w3QBnUbR1J/yMZ6dBh7yVjMdrl47N3N/xKqG6y+sY5jpdC9vDMU9b8A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1FUndCMvTWT3jAV3mB00v6KyV5sZcL2kG6FkdqcH0501HafHs
	ooNVW4Ogw3xuaEupW1BacGN187BmufxDj1LBUbF9uHlnqYen1eJC
X-Gm-Gg: ASbGncswlP4cMEFKAtNyGi4PAp5ecOLypw2x7vwYaOUAW/VsXHr1O2N30HiDI2TUfBQ
	+mDLE56i6QTBdAdmh2WbFZCyR6/6JnuwGGiExTZj0ji6sFa3NWdTQ11zuw4MutVgk9ksfpAJwLI
	2iOfeWlzwvK0BORsuITkZ+EZbJKqX9FniT91Pxn+hoAnVkFambsrI2eJ4SFLv7B3cYAf5huFcOM
	pAFwBNqUAXKjXMMq3SViE+JabCmA26FESnNtZF94EPLs2NnxMwcU/STNebdp9EgVgogoGeFYt2k
	tPaxrLLbFdUN+jh9ENVlFLTsUairbsxHDyauiOm2EDbzTFJKaCfZHU0v3w==
X-Google-Smtp-Source: AGHT+IFZ8D9fn99GBdz1k+wnK9Zxq4FNrQ2P/nZKAH6ZFy9CpCQ91xB95fWpKA6Gc9C9vj8lWI9UZw==
X-Received: by 2002:a5d:6da6:0:b0:391:2f2f:818 with SMTP id ffacd0b85a97d-39efba2619bmr16139209f8f.9.1745410290643;
        Wed, 23 Apr 2025 05:11:30 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:80e4:de9:c3ea:a346])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4207c5sm18334945f8f.6.2025.04.23.05.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 05:11:30 -0700 (PDT)
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
  Xuan Zhuo <xuanzhuo@linux.alibaba.com>,  =?utf-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,  Shuah Khan <shuah@kernel.org>,  sdf@fomichev.me,
  dw@davidwei.uk,  Jamal Hadi Salim <jhs@mojatatu.com>,  Victor Nogueira
 <victor@mojatatu.com>,  Pedro Tammela <pctammela@mojatatu.com>,  Samiullah
 Khawaja <skhawaja@google.com>
Subject: Re: [PATCH net-next v10 3/9] net: devmem: TCP tx netlink api
In-Reply-To: <20250423031117.907681-4-almasrymina@google.com> (Mina Almasry's
	message of "Wed, 23 Apr 2025 03:11:10 +0000")
Date: Wed, 23 Apr 2025 10:55:53 +0100
Message-ID: <m2y0vrtd5i.fsf@gmail.com>
References: <20250423031117.907681-1-almasrymina@google.com>
	<20250423031117.907681-4-almasrymina@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mina Almasry <almasrymina@google.com> writes:

> From: Stanislav Fomichev <sdf@fomichev.me>
>
> Add bind-tx netlink call to attach dmabuf for TX; queue is not
> required, only ifindex and dmabuf fd for attachment.
>
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
>
> ---
>
> v3:
> - Fix ynl-regen.sh error (Simon).
>
> ---
>  Documentation/netlink/specs/netdev.yaml | 12 ++++++++++++
>  include/uapi/linux/netdev.h             |  1 +
>  net/core/netdev-genl-gen.c              | 13 +++++++++++++
>  net/core/netdev-genl-gen.h              |  1 +
>  net/core/netdev-genl.c                  |  6 ++++++
>  tools/include/uapi/linux/netdev.h       |  1 +
>  6 files changed, 34 insertions(+)
>
> diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
> index f5e0750ab71db..c0ef6d0d77865 100644
> --- a/Documentation/netlink/specs/netdev.yaml
> +++ b/Documentation/netlink/specs/netdev.yaml
> @@ -743,6 +743,18 @@ operations:
>              - defer-hard-irqs
>              - gro-flush-timeout
>              - irq-suspend-timeout
> +    -
> +      name: bind-tx
> +      doc: Bind dmabuf to netdev for TX

nit: maybe add "for RX" to the bind-rx doc.

> +      attribute-set: dmabuf

The bind-rx op has "flags: [ admin-perm ]", should bind-tx also?

> +      do:
> +        request:
> +          attributes:
> +            - ifindex
> +            - fd
> +        reply:
> +          attributes:
> +            - id


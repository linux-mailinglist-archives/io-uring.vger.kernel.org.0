Return-Path: <io-uring+bounces-9650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD81B495FF
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 18:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD54D3B7E53
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72FB30F52C;
	Mon,  8 Sep 2025 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aRSmTrDx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5760E30CDB4;
	Mon,  8 Sep 2025 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350050; cv=none; b=bCkw/s2wDbdyLBWwKxLyOnZd8WLp0ViRO/FRZWyrOH+Inmf2uO8gMaLSG3OsTcjZkEOhyErtzqUZUQeWGJniHwH/pM2pybfvv2+zQAUxo2UYhVz3Py9PzV5AujijSetFlD8efNbr6KcXf4jdQ5pqJnUYd6RZ4jNStFuuOTlxTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350050; c=relaxed/simple;
	bh=lHuXjtnGIwA8Zzr3bT7RPQh03xIe4TvMRJ0gk9Qtcas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HvhJrUz24KhWjmQ08cXpUiopmj4NdsuMP667wXLwhVVPK0k05mh643Jhpr7DdT2c88wDtmX6lsxAeIZojXKElXDJWKyuHzqQEen5k78yhK/VXlfQ9yRTY9/ZZsiBicYlzx0qJT942LSb7Ur5cclI50vTcFwcpQDX8D+iDekYhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=aRSmTrDx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D15C4CEF7;
	Mon,  8 Sep 2025 16:47:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aRSmTrDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHuXjtnGIwA8Zzr3bT7RPQh03xIe4TvMRJ0gk9Qtcas=;
	b=aRSmTrDxIs6NpeGo93fkReDvlHN1nyKT78wEVvyAxjkAXAC2k2c3mxuz/bJ82L8IZW1yN6
	pwkX2HXRtMpvSadVNNy+vTEk636HAjXuttfeyulU58v4gROvgN5dbku8+cv8xe9AeoEtRt
	vJnlgruF24VRNpNpSmzpwMaYauNKy6E=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 51884059 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 8 Sep 2025 16:47:23 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-74382041c9eso3354814a34.3;
        Mon, 08 Sep 2025 09:47:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU7Pv6YVG7Il5lZNPuFKdPV/ZNth31owx4UkUqYzKhvwZcw/HdKcdTJ8e1HQJSLBka6oWH9bMmomFMm@vger.kernel.org, AJvYcCUOqaYvG5mFXsLXXedQa+gwRe38TOfzwr0BGOcM5aNi7T5uvLIG/AYDllG6P1P/CkcyHl0t4WrQntqOED3h@vger.kernel.org, AJvYcCUigQYViV2GND3DmxJgbv0/kpp7hN2XucT5RTvsIU290xbGLhCrCQqrePRpUgvYBaphjhj72aUzyqrXow==@vger.kernel.org, AJvYcCVJi51fqijkdCF2YA0vAvPR35tRUY5itSeWU0keOGdm+StsUtp76juMOK/fcBwbDbuGr2JH@vger.kernel.org, AJvYcCVMirRgZKwR+bdaHvMMJFGZ985+jekUAe0ChGlJHxgdGaoOFfXzRHcm2xIvO3/Y2mF0BR30gU46jA==@vger.kernel.org, AJvYcCWN3RMpo/RZptUyTpqiam0AEveYrqwi7qyDloDf0JjytbpFdzHIE5ktmF94iAi0LuNUfN5cUCoraOF2rK5czBdi@vger.kernel.org, AJvYcCWiptBKvnbohr2ztuOXCUWOJhi+26Omn+OvyCW5EnqXGuFH1mBl2eAoQIEDv+ndnabc3/tToOu6g6s2Kw==@vger.kernel.org, AJvYcCWqDgHOfdhEr9YjxNlqZ3glhY5p6zS8PDQHcxbabxg4eXkoOTzmeJP/x+L7F8o/ow49oahL+eYz3mFk@vger.kernel.org, AJvYcCXpsnZWMoLrguQns5x81vpEW7ks4lgFtxUVCnB8WHYeLrNvWr76TM++aVDw/T0R6mv8zyNOyC/YIPgXHQ==@vger.kernel.org, AJvYcCXr69qyvZCcDfca7Eo4w+6MzSLcQNn0
 uVOfkqSQmq9VY6cJXsoopTMmn0qiZNAWjsS+BkCGEuX6@vger.kernel.org
X-Gm-Message-State: AOJu0YxNpSyF4gzzGVujRQez0aqYHzvcoow35dour5xkma1y0Q5HA7HL
	RfSAA0s90jFehWKpobcdB063kBKReopAJ6B1YxzYjlH2nNVpRVf+La4DMu3FFxMWugaXKQap5oy
	BQWd0sE0NNefEHFxWpdaP1oc7XCcUmgM=
X-Google-Smtp-Source: AGHT+IG1lksSpt4e4b7wpOLuoBOgU4CtzIVFITSYKRy7vIMNnTgG60R226zI8so9rVaf/KD14awSBHuCM8l64s4kZfU=
X-Received: by 2002:a05:6808:2e4b:b0:438:37eb:62b2 with SMTP id
 5614622812f47-43b29b952ffmr4287499b6e.44.1757350039548; Mon, 08 Sep 2025
 09:47:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-6-david@redhat.com>
In-Reply-To: <20250821200701.1329277-6-david@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:47:08 +0200
X-Gmail-Original-Message-ID: <CAHmME9pO-g4qUUsbF+XZqcPcwfP3-N7AxR+MX6G73adc2-NAkA@mail.gmail.com>
X-Gm-Features: AS18NWDayNVnEOpkO7Cmy5o2hUWkz6cio8gfE7ZsOxyaASSZD8l09i-KslFVPvE
Message-ID: <CAHmME9pO-g4qUUsbF+XZqcPcwfP3-N7AxR+MX6G73adc2-NAkA@mail.gmail.com>
Subject: Re: [PATCH RFC 05/35] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Applied, thanks.


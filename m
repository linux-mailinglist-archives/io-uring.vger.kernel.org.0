Return-Path: <io-uring+bounces-9651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E294B49611
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 18:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAA134C23E8
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A523115BB;
	Mon,  8 Sep 2025 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XK8UCkAO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE90B3112DE;
	Mon,  8 Sep 2025 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350106; cv=none; b=Y8Ylh3uVdDD+YeyiZw1WGPYG5pT2LiFvcoY5XqsVTpCHoWhOoMRyJtbRx4f9MhC/zlU/HRutYiEonXYIZHpCWWcFYOwu3A5JHfWrVSqa1kCUxjKmfujfdTcOy2h3qlPLDAR9LV4snXTRAj9/BVGZpSI7p3L6/Gut9BZ3eFrRPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350106; c=relaxed/simple;
	bh=uSnlDYAkih0wYrWYP/wGKkJTrA/JIOiBaO0koXzi78I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zz4Dk8eWTnlxU9IuGi5MdSagHr8Gmr8WytrGCUPNsvJxAtpqJpFzfOTCR3kkr9BKmNqOzGPUpmBcdkWEfF4pz4F9wLFFMCKzntLQWti/Oxao6TlFRj5HrpaQNynYqC/Rycwz7OgzX6mMkQ7gyIPiceEDe3pqvE+/LxXoJ/9Npc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=XK8UCkAO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7092EC4CEF1;
	Mon,  8 Sep 2025 16:48:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XK8UCkAO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSnlDYAkih0wYrWYP/wGKkJTrA/JIOiBaO0koXzi78I=;
	b=XK8UCkAOFuRTAaMghbMkYhV8T2QJaLjrkIRbiSC744iVovTaic60Zp5rZ+bImztc351gHd
	RfVyIShQIvu7iaNMFAfleIQgTZHVZIHMKALN8K7z4nH5u5CE2QvEyp5Ifj4Cu887WIjTUu
	PPaVKxR6lJFHUjNXxFZY/txccNFdWt8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5652cb64 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 8 Sep 2025 16:48:18 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-74382041c9eso3355444a34.3;
        Mon, 08 Sep 2025 09:48:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUFa09J8ADacZFD6GFFLhtLMrC1Kv4vOM7yirdaDesXprFRy6XJMZm1pQ+FFmJJjp76mNwf0McOXG67@vger.kernel.org, AJvYcCUITdV+3djMnTeXEM49XI2xlKItfbJRdrl6frokw2q4lA5kIO7jFkrHIBr2XIFmfOoz7RFz0T1LZslzBA==@vger.kernel.org, AJvYcCUietkr0D/6O/6pV7vA9iaAztB9cHoIdor96HGmin2UnBfiVCkLGos6lvCg0o6/Ro16zzE4WJq9Iw==@vger.kernel.org, AJvYcCUvN72uIIQcSrTCktfokcf+p6h9icfk7OnYNhTofsD2+GucpUu/DqBBKN91h8s/2o4C/9OIUfsHkOG5eQ==@vger.kernel.org, AJvYcCVG06zb1URoCM7rsvDbbqTOYFAi9SbIkGSpaKtp4ixPmjCdkRvfrmi3aT++psE3UnuFzYD2OHgpEkH46Q==@vger.kernel.org, AJvYcCWBx+ktbHsyD2+CfZlRXW5tIYi8JAax2hagsuCDYqv4IyNPMUjm9FNPIhznGfhaP45MscnZ3wIxNCNi1ZPdFSOD@vger.kernel.org, AJvYcCWLYz6nYNPklDuzW4OtrUfTQa4y5NKvVr9og37qbnguJdKBA3ZOW9aucuzRJ2vFn/zyT7t+@vger.kernel.org, AJvYcCWaaeoObgjWVH95UhcEaBFoL/aidvUXfeei+sALTFv8vzkyP5DxqbqUVtC9BdcYt1slOEHB/qwDdvjb@vger.kernel.org, AJvYcCWmLpQeaRpTVoX1csInCZFkA79raIM2EKqQPrxqTw4XZhLW1+v+fxxMguSlsVxFkBQKNnK7juDF@vger.kernel.org, AJvYcCXvmhn9pRuAIuDHzRQODU3K4EIiXPqug5QG7DKO
 hVhQyVsg9o1clw2+OoCO01/+TFEUSmhOjalgt/JsEpOd@vger.kernel.org
X-Gm-Message-State: AOJu0YzGlYkNuz+S4mFgx7NsoIJx9Qaxoo0AL8Ogv6Mbpik5dC4BDDWR
	uov2NYh48MiPzMrZmWnWCVYP7XyprPXkWelIG9eAyWEmivcyR6cwFOG1OMD/D9MobFYNjVjkEvC
	mzJqrnx9WN4C7hOucIrEOWRwFYyNq1zM=
X-Google-Smtp-Source: AGHT+IHX8XF6+e0fkSbHw/Gno/Iv8TyBoDNhQdZJKrK/fMw8uizEVVlHqvT1474ZbZbBOA/u0TsCp2SBgWidGOb2gVE=
X-Received: by 2002:a05:6808:3447:b0:43b:2976:6080 with SMTP id
 5614622812f47-43b29b4b108mr4340525b6e.23.1757350096055; Mon, 08 Sep 2025
 09:48:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901150359.867252-1-david@redhat.com> <20250901150359.867252-6-david@redhat.com>
In-Reply-To: <20250901150359.867252-6-david@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:48:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9okig=9NVGS_vSt525C-kR0mAyCnzSn9iypvu8uj0zA_Q@mail.gmail.com>
X-Gm-Features: AS18NWDEbovQfzN2Y035qma21yXmLeYwXyIh1FHAB52eeHDgW6bSgyj_MCTfArc
Message-ID: <CAHmME9okig=9NVGS_vSt525C-kR0mAyCnzSn9iypvu8uj0zA_Q@mail.gmail.com>
Subject: Re: [PATCH v2 05/37] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y
 from qemu kernel config
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Shuah Khan <shuah@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Applied this one, actually. Thank you.


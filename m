Return-Path: <io-uring+bounces-9376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5242B39583
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 990237A51C3
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0951C2E8DFE;
	Thu, 28 Aug 2025 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h5iPz33G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7E12E1C6B;
	Thu, 28 Aug 2025 07:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756366558; cv=none; b=BoLgScPuaoGtvo86CJ7ycwuxZcwFDjsOCi4gBc0kG+F/6m7cwTW4wtw4sEc3BhmF8DtMa85Oubql5YFbNHZQvgx1ZXgnFiFpUS5epkm/5ENgWMc9E3GUx5L18auAYQrEZ/8Cgld7FtZHlQqrzgDLklZxQscTgCw9KtahrEXhgy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756366558; c=relaxed/simple;
	bh=hI4MNrNhgd37xtYxr2d1D8SpHFCU2xcnAfxMIHmVPQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAatPv3avThPuVtDFO60x3x+O+YGOSdSjhdFFv4hK+dhJsX6eJ7wAhbZFWVGTgKI1j1YgVCzZSz9oPO78eO8aJAcklpG6fku5CRMI7lX7WEY5m3ZkU3aJ3yh3BcMR+/9W4zUWdGILUC2cC+Uo+3YVlaxUvH/WPKXxgbmloxyzhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h5iPz33G; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so725843a12.2;
        Thu, 28 Aug 2025 00:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366555; x=1756971355; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0BfjvXaX7EhpBrJcO9diF40ujDlSeO28TY40tQufFs=;
        b=h5iPz33GtuMtQhrH+nSlaHl8vlDhQDfzIvqcspNCcTLwqRyI3WC1nzXHu9QaCJBAri
         Ojj/0k16w0EVxczYYGPKeseHXArQtz+egsGUGUpwz+iHN5wIu+2uArYeDw7R6csirKUl
         4k5GnrpJ/185R1RBlKmv+vuNV8dpauVkyrgvE/nLn6JHGLDSbIFND96AeYxcn6HuuO+d
         jm+ewNF1Y/ej1ykWbw3PYPJ+UV63GEHJ/peMG91w6uVKqdOiVRH9cUBAMuVI52RP6Vfi
         0kodLod/z5xPwrG3twtNF/+wcpnkj8NST9eae/QmyJMIdXQzG0+UiOx8N5jzbLzHt+x9
         I6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366555; x=1756971355;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0BfjvXaX7EhpBrJcO9diF40ujDlSeO28TY40tQufFs=;
        b=Gcb8QpPxSrioegrl9q2iUj7xCnjcl3LeZLRgzkCMkl3RnPd11PfOZGXQq6HY33OZiI
         d5dvN8IlDPv3HuSShIr44tE4Ftz6ABx4i2nOeNLICBHpaVdD0YnCJ4kmZu9Zv/7Uz/Uw
         fP61F6B/YgzAK0mpYfzjgn0Upj9huT2B/momF5RPe6Y8vap6c4sKnp2DWHGjoQCXMdFq
         G6EUFNtkku2EeQiJkcyAYalIzkd6BlAqKNpsl1fHfEFOZHvw1+OuuAJX8tNDpUUG4tJq
         I2N44EztgUy0rnyr6Zy+5t6WBiMeBoGl5fJq9zlz77VFk/T5txVrqVdxYlBAWEqOd1Wp
         bx7Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5TDYZA+E5goF7rG+wBOblWRBo4QPl+WenBvTCVNEpQs/J4kMzBV0yZ9Fy0F6qTT2ftk9ki29/@vger.kernel.org, AJvYcCUIMD6anuCapmV8Dhz1VE2qgEMwmXspxMvfUjZvJ2LTV8F56VV183JApcKX3xSJL7yBCGO4FBUNU3BBUA==@vger.kernel.org, AJvYcCUYg3uZ59meKIod+eUrDc15n2AOIIsUCuRLoB/Eyg/1GclxuGqaCZsmCnYxTkYL60rRo2bBHZkpRtovWYnP@vger.kernel.org, AJvYcCUn+X8nPLmFBRxbsUcsrinZKb7pcKfPokAmhatoV7Jay37bYKwwuMMMvJg1xInGC9KgdGRrIjKgSHzM@vger.kernel.org, AJvYcCUqj2eREfW2ogtVlXqUBjvq8ZharszDNm0gb4gkd89njvMOTiIJg6qhoHsLsnUCQVYPiEd47nfyuHVm5Q==@vger.kernel.org, AJvYcCUxOc21D3fIx48gDfHoIaVtV1uyODv8FD6Hi9ObwQ2DdILmXa6nYP4BXKl1b9Y0eQ+d9FdWsWp0BQ==@vger.kernel.org, AJvYcCWYTMbzqCP/MiB1oFuomK4wPKG6WP2dFoM2ABtzu0ro/csa8Kapqs1UZVt3b+bSQRTj0acbw88wcfHa5Q==@vger.kernel.org, AJvYcCXDR9OfbuOyYTkCdEQ6l9RAc94SGSyFUQBHzdkhgcEmQ6qKNt+ZRD4H+CLvnpKhwDw0WxtU@vger.kernel.org, AJvYcCXsvGcaNY4uL6OxbfXAdIYAwzr9Kl5z7exCuYkN/gbSXX1EvChhB2LzdadBSK2RHXC0GdHzwJwSfo+JiAgL+4OW@vger.kernel.org, AJvYcCXwtAZSUR/pXrQv6QNi7R+AhRHwat3A9iWG
 +XjW8ugDz5fBWwIvyC5ieVqNRX5StfWFct9WROZhF829@vger.kernel.org
X-Gm-Message-State: AOJu0YzBrhD6J16pY9xiw9b9dLfhl8Q0sYUEX/X10r5G21QgsG7iaftx
	E8OSin1zImyW9asDrsCMitzHiT6HOVpgr7IuRgCTZWyNSzZ+PaMPp4QJ
X-Gm-Gg: ASbGnctKhTQPpPk271uMBvGziEbDo31m6R6UAT5qUGV9uN5ATxuvfy1iWSz1U7DszFY
	Sdw/da1ccg+lH11U4s9I0/NFMXUfiFC3N9IWOeHMMpvJwJdCwSfYsWzkPUbIA3yuTbSmtHUkw0G
	XcCUOQ9Lnu944nLALfVwTJzSaUAgSdstFK/42r++9J5ecxFxVzTwJj8alVxBMeO8QitVgDsPcGH
	M+ID6swApiI8dTC5JhpzJTox7DwE1SUjqxLyGFg2++bq5cU1XxTngX22HDatePGDl9bCECzZUB+
	O04ybZMjkGu3AEtewHyJFUVNUSg1gDhtNHd7pd8Fqua+9ClIAMtKAMpRHxR0suAh96U2DNtJMar
	ETgRdXq6H0p0gaCjgp2BZa/vYKg==
X-Google-Smtp-Source: AGHT+IETTLjGc3PPKg04ncd1zRzcObVAV207MWaWJmOCZt1EmbrBQuEK0aAe9NGL4LI6P2OcE9HkdQ==
X-Received: by 2002:a17:907:fdc1:b0:afc:aa44:bda1 with SMTP id a640c23a62f3a-afe296bcae4mr2097332866b.54.1756366555363;
        Thu, 28 Aug 2025 00:35:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe68891cefsm988052566b.66.2025.08.28.00.35.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:35:54 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:35:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <20250828073554.evipmbkxrint3tbs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-11-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-11-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:14AM +0200, David Hildenbrand wrote:
>Let's sanity-check in folio_set_order() whether we would be trying to
>create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
>
>This will enable the check whenever a folio/compound page is initialized
>through prepare_compound_head() / prepare_compound_page().
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me


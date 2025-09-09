Return-Path: <io-uring+bounces-9659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FDAB4A0A3
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 06:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA3C61BC23BB
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 04:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C262E1747;
	Tue,  9 Sep 2025 04:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9pJ18PL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B151A314F;
	Tue,  9 Sep 2025 04:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391923; cv=none; b=SofwvnAlRbCl3ihwkHIUHG/ZBfaayEOoRYV7LpfYFi8sa+yqXynx0BnQmEcVBvz8Vd25YuWfahxjagaUmUUd1a8Zke5SVrc6GLzypi+fEdmeiS+RQ/5e76ryv3R5O+equ3z+tJ6zMHeAUrXmiZFb9kKWh/3FM4Q4wLg8DiLyL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391923; c=relaxed/simple;
	bh=RrzY4SDc18Ci2TyOyhCgyGYX7hmnnBCU2e/pxbH8zRw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cUW0WCiRKcepZh5XwvNunFtpOtrgHBbW/VBNMJBSlAOJT7V/truq5opGB6R77PuEFHLv8G12bdOvtlhhkFAhhAZqGtdgMQyC1dU+0hNwJGnJ3fI0p+9G0IuCiPiyX54SO2JoHD8jXuhcW+zy3rlY9eVdm6ZLB2v/d+4Ly7W1y0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9pJ18PL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9D2C4CEF4;
	Tue,  9 Sep 2025 04:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757391922;
	bh=RrzY4SDc18Ci2TyOyhCgyGYX7hmnnBCU2e/pxbH8zRw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i9pJ18PLXuxKbzs/Iruw3PpLBgKXy9ssEffV+i7Q9gMAvoRB7kzd+iGGYRZ4Vjd4z
	 nsdDoX1b8RjqFfB2U020ZMoVgWz32DH/3KHr9yu4W24HNyAdp4ShFmw5Gwb3/8dyxq
	 YI0F046jfWbWEKO92OxW3X9LzuK+WjtFkn1xH7Gk=
Date: Mon, 8 Sep 2025 21:25:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Brendan Jackman
 <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou
 <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe
 <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
 <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-Id: <20250908212518.77671b31aaad2832c17eab07@linux-foundation.org>
In-Reply-To: <64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
	<20250901150359.867252-20-david@redhat.com>
	<5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
	<20250905230006.GA1776@sol>
	<64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 6 Sep 2025 08:57:37 +0200 David Hildenbrand <david@redhat.com> wrote:

> >> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >>                  return 0;
> >>          }
> >> +       pages += *nr;
> >>          *nr += refs;
> >>          for (; refs; refs--)
> >>                  *(pages++) = page++;
> > 
> > Can this get folded in soon?  This bug is causing crashes in AF_ALG too.
> 
> Andrew immediately dropped the original patch, so it's gone from 
> mm-unstable and should be gone from next soon (today?).

I restored it once you sent out the fix.  It doesn't seem to be in
present -next but it should be there in the next one.


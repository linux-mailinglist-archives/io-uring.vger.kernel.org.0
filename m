Return-Path: <io-uring+bounces-9375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB97B39576
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C4F218809D0
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 07:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77E03019A2;
	Thu, 28 Aug 2025 07:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKG78Lv9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E2301025;
	Thu, 28 Aug 2025 07:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756366532; cv=none; b=oAOi4zP9cAgRgzuhEGwIJY6OgjS9aozlLIC0WeZM095F8osWRZnRbbMEufc9+ClLF3NfGeb1EY6ux2LWf7xR30QgkmIrHDX0rUx4UL9Ci3eJp+jlVtsY9BYHVlBEnMAtyULaU5T1g9L4j3Z8D+nGovxWID8K/W/e5la6mUtWs8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756366532; c=relaxed/simple;
	bh=HM+OHjGmq2TcnjkHfcjXG9OSRqGR45uKHnDS4eTuII4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJUmIFIUioNJS/07y5791+SD3BxaLJxVBpYHWb1GJ36H2MDXjtV2tWwqhKoF7H0UEdOelRL80jnMoy/MH9tbFngQynFFNgSdPLOBH//GOugsqdIAqpHa+lw3/s9hW/6ucAeoGKV05J0fubfGKhtem0+KWSTOKmoxG7owBIPBIxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NKG78Lv9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb78f5df4so96774166b.1;
        Thu, 28 Aug 2025 00:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366529; x=1756971329; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wdLKdu3gRydbgkaOExgCyxr/LuNr8ANanTK9VurXYA=;
        b=NKG78Lv9T4m5PcTC24GbPa+4bVp73ubrKX87gf8VuaKTKFrCPWCgUHAMwwjT00pn9x
         UAXM7QCRNGguHDKjoxoGvoiOXijBhEqjaNQMfRDtl4W/aKagdSjfjLer/kNip+9GC0hA
         Xqk2cNJSuzJqJ+KHmoAD9gVGeMtKoaSvoSeHdhca4Ku0wvXqX1iwYVp8KNgwqtAJoLAC
         S7nT4c56E4W3t5qO555WX8BUxK+FuAsv3trCiUJrLnxWY7H0nyU5CyPIkLg0ZH5utALD
         QxSaOfWp3gggzg9WvV/CWVrPK1da9X3JvZjThYn1jopOQR685EBMTwpfc9SkDC2STadO
         0Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366529; x=1756971329;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7wdLKdu3gRydbgkaOExgCyxr/LuNr8ANanTK9VurXYA=;
        b=IhBA8dtYsYHmTK0TZdDRi5dPOUtD7gAAvBr3tCIy2OaFMpkLlfeK2/5ujVbCJtC0Jx
         TGMXIMRgVl9pmn5yP75jZpuf94+zzSMez5o4pgJe+u4qUIZt2xHJ0+rFfGpG0ju/+jEv
         bSQY8TIphgEu/L1rqdg/9vBXYA1d8o5j7+uQUhBPtKatPqBHndAVnlQ3xC/GKM+AXz+t
         S5agX4lHh45UGVa+ImeGM0lPlAPJUN7h+mnYUVln0q/ViMCZWpn+iLQthe5TmFwi3nYa
         EpId+jX8hXSh6HE8mc9jeoMU+X8YvHVXaHoVUi5A/XWmimAwtW8tihRqgc8kasc7T78w
         Ymqg==
X-Forwarded-Encrypted: i=1; AJvYcCU1PZuSF9BF4PD54UDJY8xNf/IyG1NRf0NkysP2m8tduDGcKmEIRY9lcR8q9Wjv8ysMd2nMeyPmrqF4WQ==@vger.kernel.org, AJvYcCUfE6X9j2MkIbGmtc0fxM5taAx0HYqHlTd+caHBEFlGWaPh/G2Dfx3Rmjn8o+wz0VHcY9HnSngJqmOBKA==@vger.kernel.org, AJvYcCV4ZOUCCZd1NIReXGOEsNQ+v7SGqfFuOUgl4uMZ3FxwsE4gduY4OT2Y6i6ZPg5oX1nil1Vd9NZXWM7Hwn2d@vger.kernel.org, AJvYcCVeRanI2iaLVfIjjpTaWJ2Tdzio6oEtVQLkPMOkQUjbbdhBw1lf1MxKMC2NEZGJXW/jzu+TM/HYuw==@vger.kernel.org, AJvYcCW0+FJnoXzA7//3uXKtiJQIZf7ybkz5FmVoNZQb8OYxQ23Nt4+YgMZKG3rE/zcmmJKnICdg8/cJeKsBqA==@vger.kernel.org, AJvYcCW0mduTnHCP5xKutK3qRY7nVsw0nYTK/X6GXkjsia59PxIvibm901d0dLm4qA9EAYdn7GSX2W9o@vger.kernel.org, AJvYcCW1wr6IATcS6XDuULYwL+1g6k0q7uxPWwrKHFdEGtKkskOXhz1IU0NrB9yzl/8E9Z0AevORw66jFHHy@vger.kernel.org, AJvYcCW9Ovk1HATYwvvnoB89dzjMQqnwGNzVCRl1AgBjT5wIzu6Mo/RDtDtbOuuKY6HKGGpml7VH@vger.kernel.org, AJvYcCWI4ZSRFheXd6lYIl9mrx6oDQU/SHkVYLJlFMU5dvDE3Ubam0JHv/rOCeuMfc5npmWE1BF+XA1nWSIC1R+r6kjJ@vger.kernel.org, AJvYcCXtoULGx8jf0fjXC4jbOR2ePrx218T8EfPx
 x69NlLFolz9ZyioV/mrU7CKbsg/p5jUMyIwLqxTPUQ6D@vger.kernel.org
X-Gm-Message-State: AOJu0YwNRNbPqxOhZC2V540LuwVGZSKWHeGGfBXS4LFrbcxu4TZrncoY
	GofB3Ghs3OVt0zkiQC4Zc+oX1pL7LBH0Pauv0q4trEQsAt7cnLF9G3gD
X-Gm-Gg: ASbGncuIR12Le1SK0/wgJsDA8m6snKYemdyL+kNXqUhl33ZhhYGQaKJ308eoMHUXr35
	LZwR5nUBSY3g2qUFkYyZggMgQKBoGsK7ut3PAk7IjYzUJRf5f/PBbS/C75l2Tqfq7t5WOWxWJUs
	o3KRvdYv4jWnErclVtFSfnPJIhn7epar22STEt/27ErOcEDsmFSOH0AcOYeecsGGaW+y3QaY1m0
	qMo10DErornqARX+ZQotDAdWVSgMKWg8+eFzoXB73qdJ6Z5qPHVrJvTdM/jT9neU5S6y8qcF9GZ
	MNtdDBM/375n7MiBUiumsbYo8N5nSgqua4n2EGawpwtKghLrIVU4hzsxN4ONsZaLh0jThTwBTW1
	/vCEfQ+ikdkUdBOANmsFbtSc2rw==
X-Google-Smtp-Source: AGHT+IH+/HdQFSXw/W0bPc1NEIz4PAWk+piUx/7dt/vdSor64JcoeKILsFtoJ4Brv3+pRvjO+XdeaA==
X-Received: by 2002:a17:907:3f0a:b0:afe:d590:b6af with SMTP id a640c23a62f3a-afed590c109mr310258266b.20.1756366529084;
        Thu, 28 Aug 2025 00:35:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe77c2b758sm886311466b.84.2025.08.28.00.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:35:28 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:35:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 09/36] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <20250828073527.u4k47fohaquzf3pg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-10-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-10-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Aug 28, 2025 at 12:01:13AM +0200, David Hildenbrand wrote:
>Grepping for "prep_compound_page" leaves on clueless how devdax gets its
>compound pages initialized.
>
>Let's add a comment that might help finding this open-coded
>prep_compound_page() initialization more easily.
>
>Further, let's be less smart about the ordering of initialization and just
>perform the prep_compound_head() call after all tail pages were
>initialized: just like prep_compound_page() does.
>
>No need for a comment to describe the initialization order: again,
>just like prep_compound_page().
>
>Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me


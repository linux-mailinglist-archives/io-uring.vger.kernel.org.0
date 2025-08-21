Return-Path: <io-uring+bounces-9189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC4DB3041E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16F561BA5FC5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831602C027E;
	Thu, 21 Aug 2025 20:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2b9wZzk"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A012369980
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806848; cv=none; b=ElG6jQ065pwszDxD3Huu7WimdsFFjn/9sYXRw6xHmRRMdac76hgsiKDYAbq7G99CBFNlGjbHLlmGWnU8gg+gQmm41Ds4WPqX+DdyH1bCc+jCEwWkG9jA6XYsCyykd9MK7O/Mq/HiQvO/ti9YK9frj6cuvA+xa04XRU2vnvlbXf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806848; c=relaxed/simple;
	bh=vLP4m8ubY62ddowshnJEYGhNc+fB41I1n0umGIUlXAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCPrUxWXNCBkbqCtkn3PL8AQLf8pjF2foF3Z72GCYpXryeJwn93FFG6r4/55ApsVaGVVNd606EsPsqAq1LpgE318uhySsDBJ6ew5bjdyGdwohN6oQEYs+iwMoVcYwvZAh0GJq8MNpQ3c6ia8BGBMYuHjqE2BTHw9vF8qxO5OE4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2b9wZzk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
	b=T2b9wZzkC/xtgKn0ukr1t3QPXzSS8koSErP70VVlBJTnOOS6+oUpk4YqREoCKecgtdFRIx
	kGW2IIM/tgsuWykBgbG17G0j4gTen4UC+bNsSqM6/3hdTCdVEEjGP6KqUCVvLPRcpMl4xM
	kkKGre4Sb/rfgzVn3cYIqgkm329u0Nk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-QoKicqK5PXq55bT3F9fnbg-1; Thu, 21 Aug 2025 16:07:23 -0400
X-MC-Unique: QoKicqK5PXq55bT3F9fnbg-1
X-Mimecast-MFC-AGG-ID: QoKicqK5PXq55bT3F9fnbg_1755806842
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b6466so9581175e9.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806842; x=1756411642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
        b=ne+WmS+86iyb2QMBNZUzAE7CxVBf99iN8Ntvv/yFooQCukJKWvTye3kgyianNLwWZS
         6VCvOJm/uvEecnrD1/vDCurl/sJ5RKXPNtxr8PZkm2x1x44XUhUCU+UOzVsbLShBHafW
         EnVHmkTTMOLnE9Z0jMw/SVuHmNtEEyLLd+SzWljPsCzLNpv74wLNVZCtYKvqwzUnt4t2
         bduiBUsAk0/S/8O116LTqbqTmyJvTMq+4F7VYu41dWkuS3xBnnsErsYrB013XUyxShSC
         6eZalTeCwZgWrmxZZr5fghlhmonWXhO2Fhszj5UjJoM7V7AKCMNSgekzbu/2AMs9W3dY
         vsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT6nvZFuag6S2D4DJbMAUGDB8iP4GXxJmsaEiF0aINTz2rJagY916mKwvXeDAq9HoH5iSMZsh3tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzUtMD0KIXrJx/CF/MiA3F5sdH7ZurKrQSHSjkBTYQgtTjVspA
	exh7riPTZ1u0oCIKo8Lxh1Hc/gGBCL3C0/w2xzX5VaVTKp5+K7b01ElRRyvFG+P5NZa7/tqTGzv
	5mBHyKrBrCRthLotmtnakO2iKOWYEn/kTA6vDKAHjOLsHuexyLZ7TfHijF1qR
X-Gm-Gg: ASbGncunZGk257Q/DEGUfH3NYYklmG2bQAojSXhGiYKFQt1oEjmQRz+pdxVsvqScWGT
	xdKzrnPbEmItZQ9nKYF9CI/rKHwhzXA9h+OFlZWkTluX/VSnLlAewjfsHN38P8kn8STn9867nU7
	3Gp3bJXLhOTHXPJB2iJ2okdwGc6pYfh5OHeNB3JuhSLty8aT244gGOOTlHNgDh/UdhxBwfEU6Tu
	oLvfn71GNyjvhsd8Pc87XgSbe5plE3Nbosdw3loAFkICSau6owEN4nxalCVsM07YgZe4BgkZdf8
	QVNNyCtDYGs6z43r9Y3IWaCT7QR5b5wTjdXatMFJeT1EdJH718FJKddc/DErZD8DkPGHTgwGaim
	PhplOxOXsN016znClIyBzJQ==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412705e9.14.1755806841717;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtBnzBdejX2oNj8vG9iZBZKJew+pPrkGWxHzVnhFEnb5RkXIsj+cBFTtJrIXnzr/4lYhSU+w==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412295e9.14.1755806841198;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10960275e9.1.2025.08.21.13.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 05/35] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Thu, 21 Aug 2025 22:06:31 +0200
Message-ID: <20250821200701.1329277-6-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's no longer user-selectable (and the default was already "y"), so
let's just drop it.

Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 0a5381717e9f4..1149289f4b30f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
-- 
2.50.1



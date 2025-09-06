Return-Path: <io-uring+bounces-9615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5E9B4683B
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 04:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972011C23CE8
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 02:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA5718C011;
	Sat,  6 Sep 2025 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CjVF4omc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E70317A2E3;
	Sat,  6 Sep 2025 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757124094; cv=none; b=hth+gdOPf46+GtAzjeSWb2SsiEUT/V3tq6ht8HXTOvehGpi0Ckuyxyo12+U9wnCAo7zxF2WPvmOe4v9BI1f/njLDHDyN/dOL6B0hJR3+Ar5HnzaxXw3sktrICY7bYLjr55Ye1Bz3SqX8Ev1UP59cHm+q0Sop/Nmw7ejMkJ7VIko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757124094; c=relaxed/simple;
	bh=dP6oNf7882GnNfl+JkQkuVanApVo+jG2rJk7o9IZwnk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dYXrG/PIhdPceV0Jq4Fy29ClcKUDvoinD+qYPxkm1ZOi2b8tJKaFJLtoGvHqIofxMTvLmuKgFpt38t5Cs77CPFEKEl1xb0wX5q/SdmZCSsWrr+KGaluN9TJSpZAaLuNxUN+6husoL4sf/DbTliDH0d5fTYJR/dbMP/H2TDbUzoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CjVF4omc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18E6C4CEF1;
	Sat,  6 Sep 2025 02:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757124094;
	bh=dP6oNf7882GnNfl+JkQkuVanApVo+jG2rJk7o9IZwnk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CjVF4omcSEJYQec4M0OK/qARwDPUJkE/p0rgNtEW0tQJgImAdqHUB3y8K8HJGPh8R
	 ieIu7Comp/Rb6fhxpMC2Uf2AMfzlyEuGqsm5FkjHCA5nJkYCPwtoo6+r4WgbYui7Vh
	 +60gFXRMoEVSmmNRRcDKDljwjIDrQGHoPu+XjMok=
Date: Fri, 5 Sep 2025 19:01:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, syzbot
 <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in
 io_sqe_buffer_register
Message-Id: <20250905190133.345203b8f0332490c0249f66@linux-foundation.org>
In-Reply-To: <cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com>
References: <68b9b200.a00a0220.eb3d.0006.GAE@google.com>
	<54a9fea7-053f-48c9-b14f-b5b80baa767c@kernel.dk>
	<cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Sep 2025 09:42:55 +0200 David Hildenbrand <david@redhat.com> wrote:

> #syz test
> 
>  From bfd07c995814354f6b66c5b6a72e96a7aa9fb73b Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Fri, 5 Sep 2025 08:38:43 +0200
> Subject: [PATCH] fixup: mm/gup: remove record_subpages()
> 
> pages is not adjusted by the caller, but idnexed by existing *nr.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Cool, I resurrected "mm/gup: remove record_subpages()" and added the -fix:

From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/gup: remove record_subpages()
Date: Fri, 5 Sep 2025 08:38:43 +0200

pages is not adjusted by the caller, but indexed by existing *nr.

Link: https://lkml.kernel.org/r/cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Tested-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Reported-by: Jens Axboe <axboe@kernel.dk>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-remove-record_subpages-fix
+++ a/mm/gup.c
@@ -2966,6 +2966,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
@@ -3009,6 +3010,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
_



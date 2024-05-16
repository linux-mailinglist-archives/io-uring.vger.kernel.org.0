Return-Path: <io-uring+bounces-1906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E84128C7833
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 16:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17D281C22AC8
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 14:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8F514900B;
	Thu, 16 May 2024 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nq+OOXuZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941AD14B97B
	for <io-uring@vger.kernel.org>; Thu, 16 May 2024 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868159; cv=none; b=gnlqYEWLQO1LCLO5GKAmsZod7CNn/lvD1fEJ15PS4LJg0IQyndCHI4n6NvRDb6DIIfN1Mkb5A5qofMSCQAVFg1kpddTZ0w+6bNKa4nerZiPd+f5oKydfDPZqtjJlXWwxGL58ml7fwh57tik4jSmhUWlCT1rTL3/RZIIjR7xl75M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868159; c=relaxed/simple;
	bh=8FOhLzyhxO8vH5XeYxdb43OT/QgSJwu9Qpov5SSUKGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CE7DCwiWishPFiPqUQCPFYsrnv7IEaboAydaYpprXt3u2DnEOd5m8bB8/QKUFHjiIDuWwYGeWeC4KF2wyUcrhwpvkBhWkOwFAEHPrlDp/NYnYU+PV2M/XvMoMG7Rux4l209VOXrexN8lBW1LZN3IrRJWJGoQlB8nC4c+JddCWz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nq+OOXuZ; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5b279e04391so138855eaf.3
        for <io-uring@vger.kernel.org>; Thu, 16 May 2024 07:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715868156; x=1716472956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dFWk5ZMAtsa/oQVA3t20hYNOMr1pefF8T6nvU3fAio=;
        b=nq+OOXuZ+14O17ss27CvEmz8Bba0nQQkF6HgEnhkAeCJtC8gsoMcHHzQQOI5SqRZuv
         OOOPrCBeztR6vLU6FJcSZssg764tLKACEcxConN/Yw+MefNtgoGeTgO4JafRJP9gBnhJ
         r29c3rk6fpuw0OxO6OwoiIBgFLutJLi+Iy8nMk4GDMPYVfdMBcgubnF8sblo0507FvBX
         ToQKyUJrn7fvsfdWgnQlo/7pNX97QQBP9cWWkqewvORRNtTYwn0vVZf6ng5on+XLIrlO
         FjRc8UY2ePGbhT/y57z1rCud/r+nwpBQ/nL2tg00p/SPCK0E85wVoxeaObAKRL/OzQp3
         0WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715868156; x=1716472956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dFWk5ZMAtsa/oQVA3t20hYNOMr1pefF8T6nvU3fAio=;
        b=mJrI51xYHOMgexH0pNaPzhx/doUiSxPNGHye00/5k2Ytjbe5sNPQn7OqEd5lfWRs2c
         CdhgGfZ4vp0bAqTlkjXO/gg8sk8wI9oPXWv23jN829y2NpWmcaM8oJCgs8Gia9F+oQXg
         huYE+lGkdwYTq/oAgvL7znZpRNNbxJ+GPK5CxuNXJ9uWTkpM5vW7hPZ01S/DsfR5rZQu
         GvGITg/QlM3DAGFqCMbNsktuPVLbd3J48q/jpUUKCGPdAzkjFZSFnhgfEBS+r+qHcfT0
         Be2awHMRXKfMuCgOamTWeLbxL40qW+3VWNtCDqGnWBYs61Fq88fZxT1moQ/gyxZxueIa
         4Lkw==
X-Forwarded-Encrypted: i=1; AJvYcCVncKWFSkw6unEU0mdbUUPROj50uaFev4kfTIP3hFLXFPt6C+MUnwVlueFR8MdXOd7FbUbBS7fJausD6WVKQT710JqWWmeM4lA=
X-Gm-Message-State: AOJu0YyU/MQmLZljKDurMbweZgi7MvG0ri4j0p+YdPSsvde7JAir4U+d
	JxbXyQ4fCbVpHZKmtjYYCJPZm/sKbZHNoO4TRAe5+eT8rVw9FvojPo3QVj7SldF6LnFrKf5fgf7
	AHq8fX2olplRNXN3j4o6N0xbV/Q==
X-Google-Smtp-Source: AGHT+IEe8ln1EhxNJAjHiu419y6tdAXuekIeTyfgIIdsijgURvUK3GGGursXnxBxJcAkmWNA+dViRXkDySD1QOYmZG0=
X-Received: by 2002:a05:6358:7245:b0:186:5f1:3827 with SMTP id
 e5c5f4694b2df-193bb64d559mr2362262855d.18.1715868156300; Thu, 16 May 2024
 07:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240514075453epcas5p17974fb62d65a88b1a1b55b97942ee2be@epcas5p1.samsung.com>
 <20240514075444.590910-1-cliang01.li@samsung.com>
In-Reply-To: <20240514075444.590910-1-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 16 May 2024 19:31:59 +0530
Message-ID: <CACzX3AvTUJqmtD+qDhLimGde2WZUuSVa=sY+jYJ8-OB43TkoWw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	anuj20.g@samsung.com, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 1:25=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Registered buffers are stored and processed in the form of bvec array,
> each bvec element typically points to a PAGE_SIZE page but can also work
> with hugepages. Specifically, a buffer consisting of a hugepage is
> coalesced to use only one hugepage bvec entry during registration.
> This coalescing feature helps to save both the space and DMA-mapping time=
.
>
> However, currently the coalescing feature doesn't work for multi-hugepage
> buffers. For a buffer with several 2M hugepages, we still split it into
> thousands of 4K page bvec entries while in fact, we can just use a
> handful of hugepage bvecs.
>
> This patch series enables coalescing registered buffers with more than
> one hugepages. It optimizes the DMA-mapping time and saves memory for
> these kind of buffers.
>
> Testing:
>
> The hugepage fixed buffer I/O can be tested using fio without
> modification. The fio command used in the following test is given
> in [1]. There's also a liburing testcase in [2]. Also, the system
> should have enough hugepages available before testing.
>
> Perf diff of 8M(4 * 2M hugepages) fio randread test:
>
> Before          After           Symbol
> .....................................................
> 4.68%                           [k] __blk_rq_map_sg
> 3.31%                           [k] dma_direct_map_sg
> 2.64%                           [k] dma_pool_alloc
> 1.09%                           [k] sg_next
>                 +0.49%          [k] dma_map_page_attrs
>
> Perf diff of 8M fio randwrite test:
>
> Before          After           Symbol
> ......................................................
> 2.82%                           [k] __blk_rq_map_sg
> 2.05%                           [k] dma_direct_map_sg
> 1.75%                           [k] dma_pool_alloc
> 0.68%                           [k] sg_next
>                 +0.08%          [k] dma_map_page_attrs
>
> First three patches prepare for adding the multi-hugepage coalescing
> into buffer registration, the 4th patch enables the feature.
>
> -----------------
> Changes since v3:
>
> - Delete unnecessary commit message
> - Update test command and test results
>
> v3 : https://lore.kernel.org/io-uring/20240514001614.566276-1-cliang01.li=
@samsung.com/T/#t
>
> Changes since v2:
>
> - Modify the loop iterator increment to make code cleaner
> - Minor fix to the return procedure in coalesced buffer account
> - Correct commit messages
> - Add test cases in liburing
>
> v2 : https://lore.kernel.org/io-uring/20240513020149.492727-1-cliang01.li=
@samsung.com/T/#t
>
> Changes since v1:
>
> - Split into 4 patches
> - Fix code style issues
> - Rearrange the change of code for cleaner look
> - Add speciallized pinned page accounting procedure for coalesced
>   buffers
> - Reordered the newly add fields in imu struct for better compaction
>
> v1 : https://lore.kernel.org/io-uring/20240506075303.25630-1-cliang01.li@=
samsung.com/T/#u
>
> [1]
> fio -iodepth=3D64 -rw=3Drandread(-rw=3Drandwrite) -direct=3D1 -ioengine=
=3Dio_uring \
> -bs=3D8M -numjobs=3D1 -group_reporting -mem=3Dshmhuge -fixedbufs -hugepag=
e-size=3D2M \
> -filename=3D/dev/nvme0n1 -runtime=3D10s -name=3Dtest1
>
> [2]
> https://lore.kernel.org/io-uring/20240514051343.582556-1-cliang01.li@sams=
ung.com/T/#u
>
> Chenliang Li (4):
>   io_uring/rsrc: add hugepage buffer coalesce helpers
>   io_uring/rsrc: store folio shift and mask into imu
>   io_uring/rsrc: add init and account functions for coalesced imus
>   io_uring/rsrc: enable multi-hugepage buffer coalescing
>
>  io_uring/rsrc.c | 217 +++++++++++++++++++++++++++++++++++++++---------
>  io_uring/rsrc.h |  12 +++
>  2 files changed, 191 insertions(+), 38 deletions(-)
>
>
> base-commit: 59b28a6e37e650c0d601ed87875b6217140cda5d
> --
> 2.34.1
>
>

I tested this series by registering multi-hugepage buffers. The coalescing =
helps
saving dma-mapping time. This is the gain observed on my setup, while runni=
ng
the fio workload shared here.

RandomRead:
Baseline        DeltaAbs        Symbol
.....................................................
3.89%            -3.62%            [k] blk_rq_map_sg
3.58%            -3.23%            [k] dma_direct_map_sg
2.25%            -2.23%            [k] sg_next

RandomWrite:
Baseline        DeltaAbs        Symbol
.....................................................
2.46%            -2.31%            [k] dma_direct_map_sg
2.06%            -2.05%            [k] sg_next
2.08%            -1.80%            [k] blk_rq_map_sg

The liburing test case shared works fine too on my setup.

Feel free to add:
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
--
Anuj Gupta


Return-Path: <io-uring+bounces-1270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 594B988F347
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 00:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AFE11F286C7
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 23:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BF2153578;
	Wed, 27 Mar 2024 23:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VeDqzRFh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E91143C4D
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 23:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711582737; cv=none; b=Kban8udhPCF6pnLkwZJ0BGtPRhZEyo4o8Yl+L/HricS78t/EWw0DaylUH8VM5wsYK3huEd7yKXU9XhSWOLWYlwGIQx2XZ3/48iv+c0sy0W+z/2AA5WdTm7ZSpVnW/l9TXImCsY3pasUTafwRTrsyvVaP6Rs6na7sH1L4XB2vIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711582737; c=relaxed/simple;
	bh=wvSXB0knqAqJBrImaqadLtzC8HJNPGtvjBIlPI5oI8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJaqOHaRURRDBm0RYh64ZGJKf90djJUTSanrVXM4OyjsFJdR7iyiU7cgdz/vs1Jf3y+Y+fBb8rmt1T29nqwQMrYhyRIgDBD6CRGPI7SighkNvjENkHOYHiZK32vlLpK6OlmFK0O7Dd8p4Nj9/KxE0hg2sMY8ED6D8i0wVPcwN9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VeDqzRFh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e6c38be762so59381b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 16:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711582734; x=1712187534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f7kWfsxPD7iY+Qsk1bIPND6pnpaTaGNq4jBESxEEGlg=;
        b=VeDqzRFhgX2vuIjrq7dPqdy4oPergAY+qJ4T04IZ6iQ2EY9PVDndbwGhCK26kWBSeX
         cYm2fWukUi6pvsf6SJ5I9eS4GYtyarstu/s0EZBP11Wh3HaBcPXB9b16zK8HyGU5AbD4
         YKU306qs0Yj/lABbE3He4u8e6LhbYmFKx6MrBchaX7GPLfnAxCC4tq6kEI1l2WMVM371
         cYP5ALUzW6cYHFj9q7eaHYOACONd8gmi9FGJO1DryUk4xmxe8ZupgoooTUdR+vissWlx
         Alhgc+yQtiTaomDPoOLwbEsL6kVoMqnr8i/C3xwbZMfZWh6HQps5+/UlS2nnVrG7rM0o
         n3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711582734; x=1712187534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7kWfsxPD7iY+Qsk1bIPND6pnpaTaGNq4jBESxEEGlg=;
        b=fZNGf+eTkWP58kJenxUGRIr5yu2aMWhex4mdtRb75Z4+79MuwJetBARcWSw3xf2fLU
         GaonXwU5stH8ArAEAvHCzRKNDZKmrj+h50D3HNC+Hgt44S4VnblKLY3RQ3Ws9e0Eo3d8
         vN1TN8oTTinoOBoImFdA43ndicnVc/00aaisuuNsWfmhXE2vA+01RsRexMyOr3lStbrh
         YM5mjlyjMNlNZ01c9yntmXnF9eCR2clsrPTfXWUj8PRwffOfZ0D2orp1jSOwY2L9WR+C
         YUJylSvaSAomL26LVuzyKvsvdVJYkHTLfdICMSG0Ng2YuIIP5LLiZDI8/beWTUSxe8z+
         p6qg==
X-Gm-Message-State: AOJu0YwCKDnZIeNmBB07xptavhfjVtAXvLcnCbvc6ZbvlWldFefPXj03
	3XdQcBl6RFpHAL9QC9xy20qWGbb4qJFvecxKsW4oBroUWaq/cQ00g1ZvMZxB0q3MMFir/MV2Al4
	K
X-Google-Smtp-Source: AGHT+IHwY0YLe5mCPNW29nUnkv+uRYRKxNmvmxuH4NeFNFAYmSKwthByc0hwtOYhGcsYoPv6+MVSSg==
X-Received: by 2002:a05:6a00:2d2a:b0:6ea:7f2e:633 with SMTP id fa42-20020a056a002d2a00b006ea7f2e0633mr1469020pfb.2.1711582734126;
        Wed, 27 Mar 2024 16:38:54 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id c6-20020a62e806000000b006e6c5cbfff7sm101638pfi.169.2024.03.27.16.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 16:38:53 -0700 (PDT)
Message-ID: <aa6530b9-6c85-44ef-b3d7-8017655725c5@kernel.dk>
Date: Wed, 27 Mar 2024 17:38:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Read/Write with meta buffer
Content-Language: en-US
To: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 kbusch@kernel.org, hch@lst.de
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 anuj1072538@gmail.com
References: <CGME20240322185729epcas5p350c5054b5b519a6aa9d1b35ba3709563@epcas5p3.samsung.com>
 <20240322185023.131697-1-joshi.k@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240322185023.131697-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/22/24 12:50 PM, Kanchan Joshi wrote:
> This patchset is aimed at getting the feedback on a new io_uring
> interface that userspace can use to exchange meta buffer along with
> read/write.
> 
> Two new opcodes for that: IORING_OP_READ_META and IORING_OP_WRITE_META.
> The leftover space in the SQE is used to send meta buffer pointer
> and its length. Patch #2 for this.
> 
> The interface is supported for block direct IO. Patch #4 for this.
> Other two are prep patches.
> 
> It has been tried not to touch the hot read/write path, as much as
> possible. Performance for non-meta IO is same after the patches [2].
> There is some code in the cold path (worker-based async)
> though.

This patchset should look cleaner if you rebase it on top of the current
for-6.10/io_uring branch, as it gets rid of the async nastiness. Since
that'll need doing anyway, could you repost a v2 where it's rebased on
top of that?

Also in terms of the cover letter, would be good with a bit more of a
description of what this enables. It's a bit scant on detail on what
exactly this gives you.

> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31
> 
> With this:
> taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2 -r4 /dev/nvme0n1 /dev/nvme1n1
> submitter=1, tid=2453, file=/dev/nvme1n1, node=-1
> submitter=0, tid=2452, file=/dev/nvme0n1, node=-1
> polled=1, fixedbufs=1, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=10.02M, BW=4.89GiB/s, IOS/call=31/31
> IOPS=10.04M, BW=4.90GiB/s, IOS/call=31/31

Not that I don't believe you, but that looks like you pasted the same
stuff in there twice? It's the exact same perf and pids.

-- 
Jens Axboe



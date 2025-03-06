Return-Path: <io-uring+bounces-6976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 153E7A54A5F
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 13:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA953AD3EC
	for <lists+io-uring@lfdr.de>; Thu,  6 Mar 2025 12:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A130204089;
	Thu,  6 Mar 2025 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tC8cNoba"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B97201022
	for <io-uring@vger.kernel.org>; Thu,  6 Mar 2025 12:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263054; cv=none; b=Lio62LM3mS9AqpVeYosQCNTNrsb4F5wHdQivQNhixCdSwfhdtVMdcUP+gha1lNva/b7o2AJkxEFDZVcVVcwX/6YGy0t24QFi1nWXb4MKQ9fzaYX0tbzHUPFSfKrbK6qs768pyOHK8ZRWe+wFE3/Y0xt6e+ZO/M2LJKd92SbrDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263054; c=relaxed/simple;
	bh=ZI82FHrJnrqMLdwjv9/8Rv/Z1lQ4MPmdX9ktdZnLV14=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WW/md8YIj48C5z/wrcGgPmjBVnAgyOzTT5zE8PEj5SVPqLI0/6gxuMR1FN7Elz+OHtKVLXIhlEyI1FwsGmlY+3uTUXTrfrgNuXF6yhgdBNcm9xd4Si8Qfg7/oLcWbjb3LUQOVH6itnrZHTJvY1TecegxR1K7xoTvhyEb1ClVnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tC8cNoba; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-85aec8c95c4so50059239f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Mar 2025 04:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741263050; x=1741867850; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G1TUfmYE4Ast2rXNv2vwzGtUQeGQOGAmjv/rsLymZIo=;
        b=tC8cNobawfefoUUfR7dsv6hUwCxffYGiyUpvTmIpdYMhgdCq2INtUiDqH9kVA1RP/k
         lSIyhu7AwPBZ2y4gu1riQXLAG/DRicn/D5RMIK+GGYXpocz1oRInIGrJe/9v5XmPXpjo
         9NWnpnVwyf22Voo5L1VKKBBWrZ5FuQ/5vbaL9Tl7T22wi+qcPkVoHNXrilAaoVBpGwDF
         igmZlG0gqLalkSdQtZjhovtdJXa+CgJjHyKRG1r4BGmEiQI3xVXJovTd1kzKtqhGoUbm
         mvWdRNVpwqcdMUc606G1CsoLf0ugtNJj3jQ1ByO28zk0CYC8DigbL+J226YFRGJaqWvJ
         sU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741263050; x=1741867850;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1TUfmYE4Ast2rXNv2vwzGtUQeGQOGAmjv/rsLymZIo=;
        b=v3wUpY7FzKm/waTfTsO9ifBMPgUVXk2tuCT3djjuxyiu2uoeSGcr1AE82+lCiokru6
         8JVd+QWcNfUSd9kpFAT7Ga5OSk34wkNiLuZQkZtBdaV84xwafZgP6Sv+0mHXQ4B8t+u1
         bpcsHMUMDnPSm3Iceev2aEtE5stMNdeLe6/ej4QNAfFbF3+8LJAt6mivdsB5xlAUNchD
         xYUQDZleG3I7/DWazCI7g1TPtxyPRdRRpa2ZJHwHdvrr2sqxRnO80U0XEs3FhskcsD32
         LXbgBJzuTVafVyORw7ZFY/YHfm4dZAckWmO9y5qrNXlGC8mKJGUNmm9Ebvlv5ii3udnT
         pkdQ==
X-Gm-Message-State: AOJu0YzBidEy2q8LJ0YDAl8PsTf1qUqIRnoXNZZcoYso9GCiLVR1DC+M
	v0WZ4p1A9q38dnr7n0QP/UO6GwTVaC0MaxCsg55FEqUc9JArYJH7yTXnWxMUUCGi30F3iDHO2NM
	b
X-Gm-Gg: ASbGnctqWc0BQ1BkVTNGx4bADxtEt1iRPT4kg15XYZdAyEiFC6Kvf+147fC6R2qgdAe
	yxwn+kQncj+wsluLTRfzLBI295zPurOWIlNXNJuAMc4cwKWJa9Kis2Pb923tvIUJwcHNn8VZZLo
	KsxSR2cfY8n2PhhXE47ZAB+P3+9zMV8hqIMIbIz97Il3BQ8l7/rftv1J+RgGpIe+cWEF5XQGZY5
	Tq4g1oRWSDJ1ZNtQBCa41s8PdLNtKPritDFVuj4EtBpvs7twWka/J2ErQFujV/70NEYLitbmR/D
	O9LSu917ht4maUNgFCId2owPjXqMcko++eKcBQLDbw==
X-Google-Smtp-Source: AGHT+IGN/oIKlHveEjXgNbNHHfr7htJlOujUolwBj2q8FutbWoRnsJ8e7Xd311tkRf+KRBI6sk+Kfw==
X-Received: by 2002:a05:6602:4c90:b0:85a:efae:2f15 with SMTP id ca18e2360f4ac-85aff87ab0cmr925621639f.1.1741263050061;
        Thu, 06 Mar 2025 04:10:50 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b11a74db3sm23636639f.32.2025.03.06.04.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 04:10:49 -0800 (PST)
Message-ID: <32fb7fd4-3e70-45d6-afd2-fae07ed66b1f@kernel.dk>
Date: Thu, 6 Mar 2025 05:10:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Add support for vectored registered buffers
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Andres Freund <andres@anarazel.de>
References: <cover.1741102644.git.asml.silence@gmail.com>
 <174126247411.11491.2089976822738509043.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <174126247411.11491.2089976822738509043.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/25 5:01 AM, Jens Axboe wrote:
> 
> On Tue, 04 Mar 2025 15:40:21 +0000, Pavel Begunkov wrote:
>> Add registered buffer support for vectored io_uring operations. That
>> allows to pass an iovec, all entries of which must belong to and
>> point into the same registered buffer specified by sqe->buf_index.
>>
>> The series covers zerocopy sendmsg and reads / writes. Reads and
>> writes are implemented as new opcodes, while zerocopy sendmsg
>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/9] io_uring: introduce struct iou_vec
>       commit: 32fd3277b4ae0f5e6f3a306b464f9b031e2408a8
> [2/9] io_uring: add infra for importing vectored reg buffers
>       commit: 1a3339cbca2225dbcdc1f4da2b25ab83da818f1d
> [3/9] io_uring/rw: implement vectored registered rw
>       commit: 7965e1cd6199cf9c87fa02e904cbc50c45c7310f
> [4/9] io_uring/rw: defer reg buf vec import
>       commit: 5f0a1f815dad9490db822013a2f1feba3371f4d1
> [5/9] io_uring/net: combine msghdr copy
>       commit: bc007e0aea60926b75b6a459ad8cf7ac357fb290
> [6/9] io_uring/net: pull vec alloc out of msghdr import
>       commit: 8ff671f394f97e31bc6c1acec9ebbdb108177df9
> [7/9] io_uring/net: convert to struct iou_vec
>       commit: 57b309177530bf99e59da21d1b1888ac4024072a
> [8/9] io_uring/net: implement vectored reg bufs for zctx
>       commit: 6836bdad87cb83e96df0702d02d264224b0ffd2d
> [9/9] io_uring: cap cached iovec/bvec size
>       commit: 0be2ba0a44e3670ac3f9eecd674341d77767288d

Note: the vectored fixed read/write opcodes got renumbered, as they
didn't sit on top of the epoll wait patches. Just a heads up, in terms
of the liburing side.

I'll get the basic epoll wait bits pushed up to liburing as well.

-- 
Jens Axboe


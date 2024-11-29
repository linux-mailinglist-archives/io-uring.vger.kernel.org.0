Return-Path: <io-uring+bounces-5153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F309DEA1D
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 17:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A266FB21662
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 16:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37A914A098;
	Fri, 29 Nov 2024 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CKB83FSa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD7914F126
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732896256; cv=none; b=gn6aYj4L8hf5ztlO867fVF5VRRSvFWCAUwN/HoZUuqPtaC8TkfiPdkhveXg1q1MXM7dsukvilIx/KzKXf4xAdg6LmuB9zA4Jqbj+t0B/UYugozUzzpv5Kd66timFPldo7OmI/VkE4jfLUrLHiAXEOwyz2SWeaRnrpSqq+6PEqpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732896256; c=relaxed/simple;
	bh=Zqci7O9j5rM8ZCG21LOcWaj1xtRU4bg8AN66phncH+Q=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iBWCgkrZs6s+ESXxghhaf3oAxu4jzziErlRsmx9dafs+CtJgrGywri7dBmymxwTUtTvju6nFOxI86KmpQjWlrgSh5iqxSIt2a7FzJrL/ELTCHcnmL3hC/PpKnvlivJIk5RE292oK3D6Y4zY/x+1W+66uuwxLFinjYtGA6fEbDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CKB83FSa; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21260209c68so21087195ad.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 08:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732896253; x=1733501053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5NhEbu6ESbP8r4lc+93ETbodXsjweitvDr6notsG0O0=;
        b=CKB83FSaTUw3rPNiwf9FTV5ZnyeX2H2kdIDHPNo8q00YzeSwGFLCtLxMwAPiL5hRG+
         Ut6uq1dnWe9SmtwFBMptDExF5UqPS31uNREhjXgXqPX8FIdLE3Mip2xo5+EKmQleezvC
         Vydsak/mp89An4e9YxGj/DwV2AuuSTx8TLf44u2FJi9zvMBWV9tWJzNt171kHHBeuh/f
         QO3aWTjNGNBzS6xtU/cOl8xTDDTu5LEfk5qdYeFZLmMCyLButKF0i82ICparmtLZ3+rr
         2ncuhPAr+iFRLz1NPNmXP/nx/rmNihdc0m5bqoHxzdLr/FoSLqtSgEcuw7aZO2Z5LvXD
         INCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732896253; x=1733501053;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NhEbu6ESbP8r4lc+93ETbodXsjweitvDr6notsG0O0=;
        b=HsvfgVA7KF/73s3BrHqaSR4UY76Bx+escny+zZbxnbQDiINd+2MshU0KPwz4OTTIEs
         iRk0RsJKj1Oco0KdG99YFLUXErOyCBXrBZXre3+kUyvrEt4wPErv+3lWK8TQsSx6WRqu
         wILv57LQ9oZDFwlC74d/AeZO+VYclUeBHneMXami/C3a/yEPXPguByXmBcyvKKAOKres
         fBcZ/gAOxDF+KKMDkThsPWuKa/oPOYppuV5o8VPcH+8fOyTFToWAZGX/2/SHq6DJmtZ4
         HQJgeSoO5eyNxqQWjhPZy1QS1LCi2kxjka+5vGw8fIzhydr/Urrie1He+JF+PBbFT7/r
         Lcew==
X-Gm-Message-State: AOJu0YwxnsKKnNGn7pHnjug+D9i2zjjXJJBY45f+Ndjwzvb3Y49CDeZp
	DEGm6rSS/+wxwrjdYFs+wTbfSXHBgXHtMlEazqPfw36AoLhTpHTGpQFgk60b6D5ikrKnAogta59
	e
X-Gm-Gg: ASbGncthXIYvKrx5HzedwA1CxTSb1WPqx/5J4OV5AuX/xMRlB/mMHmWrS7hqILi3suq
	GsWIOwjKLILqlhesHd5Lzg98EOWl1M7q0GzP7V8sfLTxdY8ORMDZpX8/p51GfShHGvZt/zoCdox
	FFle4BzPShu6hCKCcOPsRmUf+WQT0WPNXvWOGiwdNJ4u/CeGLceNl+/xFrN/dihKEiPGc1U87bw
	l5Ewxx04n3N4j47PwYkrDxYkP/u1vxpKcWw/gMSLA==
X-Google-Smtp-Source: AGHT+IHHSLUtU8GQs5Vpi9SSUCFn2H328nWMS1aRj7198UFAqJ/Vp34+UoMrL8vq+rW7ZMTha2ORbg==
X-Received: by 2002:a17:902:f104:b0:215:531f:8e39 with SMTP id d9443c01a7336-215531f9156mr6245375ad.11.1732896253079;
        Fri, 29 Nov 2024 08:04:13 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215218f46a1sm32302925ad.39.2024.11.29.08.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 08:04:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 00/18] kernel allocated regions and convert memmap
 to regions
Message-Id: <173289625227.195012.15675729738665564524.b4-ty@kernel.dk>
Date: Fri, 29 Nov 2024 09:04:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Fri, 29 Nov 2024 13:34:21 +0000, Pavel Begunkov wrote:
> The first part of the series (Patches 1-11) implement kernel allocated
> regions, which is the classical way SQ/CQ are created. It should be
> straightforward with simple preparations patches and cleanups. The main
> part is Patch 10, which internally implements kernel allocations, and
> Patch 11 that implementing the mmap part and exposes it to reg-wait /
> parameter region users.
> 
> [...]

Applied, thanks!

[01/18] io_uring: rename ->resize_lock
        commit: e4e0f7d04627a3a8380bda82c4690f598b095b66
[02/18] io_uring/rsrc: export io_check_coalesce_buffer
        commit: b5c715ee796dee285f902276c38c808f6a7799cf
[03/18] io_uring/memmap: flag vmap'ed regions
        commit: ea57c4c88ffb3f7247200275435bf4aa4894f965
[04/18] io_uring/memmap: flag regions with user pages
        commit: 67b855ba258319abe9fac15e6ddf07e57c1589c5
[05/18] io_uring/memmap: account memory before pinning
        commit: 85652c20eda52bdf2ecb059da0e5d9c50f2824b7
[06/18] io_uring/memmap: reuse io_free_region for failure path
        commit: 3e0b1575a596cded61eee4ef75870a741a40fcc4
[07/18] io_uring/memmap: optimise single folio regions
        commit: 1e80236d16da642240292194c9e34fb37664f606
[08/18] io_uring/memmap: helper for pinning region pages
        commit: 5e015f23f7d382ed1a301d015284bc8cca87335b
[09/18] io_uring/memmap: add IO_REGION_F_SINGLE_REF
        commit: 8acfcf152fef8566a19fe9cdbacdb6a6bdec5520
[10/18] io_uring/memmap: implement kernel allocated regions
        commit: 9407cfd8c016024e23ef9c37e422b204dfaf435c
[11/18] io_uring/memmap: implement mmap for regions
        commit: efd160a19fdb27db0436a21194972a4ce49bab2d
[12/18] io_uring: pass ctx to io_register_free_rings
        commit: 458b0ea4de8d5045e446035a1cdb49f1e6f01789
[13/18] io_uring: use region api for SQ
        commit: 5f58f826fcbff03f392fda796445992d59d34a80
[14/18] io_uring: use region api for CQ
        commit: 9c0966c93e771eb17da6a41721c4f6613f616212
[15/18] io_uring/kbuf: use mmap_lock to sync with mmap
        commit: 8dec4fa7082c0f8dd9692ac110777a994258a798
[16/18] io_uring/kbuf: remove pbuf ring refcounting
        commit: 6a2036aec3830a293a5ca2d6059b5e4a450a4e0e
[17/18] io_uring/kbuf: use region api for pbuf rings
        commit: d67839c6abfe5dd505390710502e2f9944a51126
[18/18] io_uring/memmap: unify io_uring mmap'ing code
        commit: 17f5a7960c70c9a1ec4cb9a63be0898a47af804a

Best regards,
-- 
Jens Axboe





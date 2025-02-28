Return-Path: <io-uring+bounces-6860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF080A49B42
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 15:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D792817481D
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 14:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296A725F98E;
	Fri, 28 Feb 2025 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IWW0hqCj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD01276D02
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751578; cv=none; b=uvOiLlUJIr96XCtXhmMhPQN7B6aHIyItZhbYNv/vwUY5vmEAE3rhWeGfLsgS+YhkArXPKrqfB/kAUNi+M8RJe5iZtzAbWFIrA0QMlYek7pqupMOUJYrQjfbtExaJ9Pma94T6/crAaYGrInA5MjH0NzIpy+AzhsIB+kKRNQ2pao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751578; c=relaxed/simple;
	bh=+Ws/a2TVyhGsR8GBCEetRNGRZC8CzU6l0Gi+3IWYu/I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FP/mqJySPoci/DJz0ImoFqtzI+8WSbLxFlmo86RtDvx3r2+Z9HjXCpC3brTdSYBndwbK5BZwv31rw2E+sENXWT6wXJMKoKWKhVQKqoGUldlGUVViLng9kR0xfW0NWQa6fAkt8E3Oq3U5VM+tPv26uk7r2PJi1Ds8AHRDGgt/1Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IWW0hqCj; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fc291f7ddbso3582479a91.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 06:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740751575; x=1741356375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wejv4BYNHQOXgDDBtI+W8fsgrcH5ND5AwtMfHnIPJBw=;
        b=IWW0hqCjzClGZxlZDTEy4pxJSapjl7r8TU1soCpyEhzvESCGvrLPA97Ae3GZ7TOoWV
         +Mj6CmU4SZ9B4ni99Jna/o15t3uniUYNJx+2J2CFjgDOgLzZurXQ3XRBgHuL5fX4hteG
         7NXSAIlWC0sF7e4lldCWonz0js2IfidPDzFmPdnM2mFUC+wBrSORxV+g/RF5NZS+B9uB
         QnGwRqKG3TGVm6SrftkjL9+WRkrzxJhT26csdZYJanphcnpc5SZmr06HJEz71NTbZE5W
         LINjnPX8g6MDgHHcG0a51+YtrOwJDeNiEt/VrNuLMei52wR21Yu0g8hCw543VfgTvPzx
         DtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740751575; x=1741356375;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wejv4BYNHQOXgDDBtI+W8fsgrcH5ND5AwtMfHnIPJBw=;
        b=NvtZN2NXdhBNlr/HkXBPvI1UADxHCJC3DTROa2ad9AXcx7Y2lfhBrjCxAql+J3qipe
         Qsv2sZVGzEUZEP1xyd9fooNafSvxHiDQOgf9h9/vXyLas8ETvAXiWcv1OrdVUi7b6gM0
         hJEVaJ6lkN3JWmU8jCPDVgU+Yl4TIZFlRj08Gx0U/J1FsOJh11qvqgMqAGRVy5HNQvvg
         YZ3wmlxGnL0vwbo6K+pBdCU3vsqt7lXlfYImvGsp8T8zEIumvFYHRaIVCCqyiF6txtIh
         lx16AWvwpJ6m92p9UIluaRPkQy35m/Gxg2DkV9wXqQAuUdNFUpdLQiml209MZ7QSsWQG
         jK9Q==
X-Forwarded-Encrypted: i=1; AJvYcCU//QHeINRui+BRt/kLH2npeEpGTLmQgLExonRYFFTf6hxsQ6WviJDjrN6XTMu7Iql0CrnJ8imo2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVZ4EERUOFkXvtrjGtKHQ54DM81O4g/3PKJ/yS0ylmYX0iBlyp
	HJc29aae2pTqLUdC89mlVYqkfSwKxvKmtl9S78FwDOg9NwcZm1Jnu7OMdoaexp0=
X-Gm-Gg: ASbGncsBwKb5+iAJjPmd0uylfHQZWeJqTrvtxHk32wWH27pBXjs0Xu3nOZC90PHY9gX
	no7umh9siMnCC+I+wmuEUrLjwFKZdh7xUxu1EUaRjkuleeZfz+qA62N9Oe/fitLNrtC6ZDSx360
	TR/poGiTbaDc9OSIBAM/DahFEI/qGAvA07x53TeheX9vxTHSLO9AmMIniOoceHasWQViVq3sKEU
	xeMHPASvOd4sDd1Hs30U5Y0z+kGs/WjDx7Nz2vlqdDbsNlWYn7K3XTVxJFwJ6OVmrLbfUwj1Uwn
	2o4wrnfi1ryge2+j
X-Google-Smtp-Source: AGHT+IH8m6B9bONZtggc5TOaP8SNcq84OAlI7zJ06gGNTlOvv8IU6LI+DzSn+79wPg5Fd/r58sopOA==
X-Received: by 2002:a17:90b:4990:b0:2f9:cf97:56ac with SMTP id 98e67ed59e1d1-2febaa8b67fmr7061106a91.0.1740751574773;
        Fri, 28 Feb 2025 06:06:14 -0800 (PST)
Received: from [127.0.0.1] ([63.78.1.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5de5sm33062875ad.134.2025.02.28.06.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 06:06:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: ming.lei@redhat.com, asml.silence@gmail.com, 
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
 Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, csander@purestorage.com, 
 Keith Busch <kbusch@kernel.org>
In-Reply-To: <20250227223916.143006-1-kbusch@meta.com>
References: <20250227223916.143006-1-kbusch@meta.com>
Subject: Re: [PATCHv8 0/6] ublk zero copy support
Message-Id: <174075157357.2559329.8032266585029864578.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 07:06:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Thu, 27 Feb 2025 14:39:10 -0800, Keith Busch wrote:
> This one completed liburing 'make runtests' successfully.
> 
> Changes from v7:
> 
>   Prep patch, mostly from Jens, that removes the "do_import" parameter
>   from the generic rw prep.
> 
> [...]

Applied, thanks!

[1/6] io_uring/rw: move buffer_select outside generic prep
      commit: 2a61e63891add7817e35a2323347ed8d354acf84
[2/6] io_uring/rw: move fixed buffer import to issue path
      commit: ff92d824d0b55e35ed2ee77021cbd2ed3e7ae7a2
[3/6] nvme: map uring_cmd data even if address is 0
      commit: 99fde895ff56ac2241e7b7b4566731d72f2fdaa7
[4/6] io_uring: add support for kernel registered bvecs
      commit: 27cb27b6d5ea401143ca3648983342bb820c4be9
[5/6] ublk: zc register/unregister bvec
      commit: 1f6540e2aabb7372e68223a3669019589c3e30ad
[6/6] io_uring: cache nodes and mapped buffers
      commit: ed9f3112a8a8f6e6919d3b9da2651fa302df7be3

Best regards,
-- 
Jens Axboe





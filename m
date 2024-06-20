Return-Path: <io-uring+bounces-2287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD022910496
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EFED284905
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4BA1AC769;
	Thu, 20 Jun 2024 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YRQlNuPM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5CF46BF
	for <io-uring@vger.kernel.org>; Thu, 20 Jun 2024 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887947; cv=none; b=KPp30/Edq18wFkyplT0plhkbYI/AMZq/KmjfN2IkpqT4ksDLBeDKaVP7GMzHQQPR15UK9TpLLOJPGX6vseLOMAb63EKg3AlTRzhsmAOIly23F0dJYXa1KMr2FLGCGvJMz+vYBFsJsz60YO8L8I0mJ+1jlXbCQyNf8j6Iwm3Q7nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887947; c=relaxed/simple;
	bh=zryAm5ANDYDpm71kMc3IMzOAjxnalVOZMcnBUHF5Bcc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HY1CzIeAMrD8CYXZI53qNT4gFGtd9mKOKJy4opItfxvtWwVkOdELMKhXtYlvP/a9KqmVdXUxOiDueEy5J4HjjrGigrs1V8es/HJ3uabKbW46JQOacGHu2EI0Xw031Z4yhZx+Q+gurD5Td5KIKWOqVMkEOL7m2ogTOrB0iroxW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YRQlNuPM; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6e85807d306so77702a12.3
        for <io-uring@vger.kernel.org>; Thu, 20 Jun 2024 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718887942; x=1719492742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uG26IFrt1/zJCACBnvZm9Qzvu4swFniEfWB+pYRcaQ=;
        b=YRQlNuPMw7n5BrDWLcqChxWaoLeq0LrD6zxGdHmdNwQRS9XumlWZiggE4ZL4svBKvi
         v92H+vtg6k1bhQKjmm2ZMdNzWxLZmTzh+QRUC746PQ0x/WEnS0dYQDp6QFkufLbzBpli
         PVqnjtRmvUwTdRid0Xq71QT8CluvBrlzmB3i0jluhV/YsI050g0P7jPv9TKqLrj75atL
         hyOX3ax+wouzy1y0qz2dov1HQNuApzV78RkpdMC3susi6JWT0pGFBzLTvPrgBTBhounV
         6OToNBZy5R0qmXyX/1mp/g8CiBbESUzcxONsr7wlGLB4UN1gOV+LDGq/UXWi50kRxjmN
         biQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718887942; x=1719492742;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uG26IFrt1/zJCACBnvZm9Qzvu4swFniEfWB+pYRcaQ=;
        b=S63ZvZ6idBIffir2VGCbmeyRok7+bxselXhm4SjAc/LjTh3GNT7XSwWagNkaL+/WQ7
         pYUpLVtrsIA0ROXXOT8e7NgrSS4MmcyAwntUosVaZQBcope50cI4xNVQ7du2dfWNNAvo
         B4HSzXiz+q6hWqzQReLdHuS99B0vv2R/S67VpyT2vrJLQMUXhY4LwkKc3JrNV3Qze5sM
         WGoD1rQsRxlhjW5QsitCEbXMbbRshTw9Rv5ltXIMf3DKPWdvc+JaNWTkAIZMoWpVpoFH
         AOYf0x3eZ+mchnkIuMB6E6OUQQ06N6FT2s7/a0jV3/R+9zVZmR9bvUfPGj2L+fWKV4a3
         cRug==
X-Gm-Message-State: AOJu0YxLdO2qpXYlKxBmwE2p1UbKLVCM63yFMuKyCUUKc5dd7lamRnfn
	69U+B2I+LKLQcxjXviikV3CsXOPAs3e00ZhOvZwYo4raIVefzIB17kC5eyFcZnPo/rDXq8fKIc8
	7
X-Google-Smtp-Source: AGHT+IEzXDmcIpZqOovKzaRBGVvCKUMJXmSFzi3XsT0X9/rHwfi5PhHYO7w4PlDDTkinIuBZk9xSoA==
X-Received: by 2002:a17:903:1111:b0:1f6:d81e:cf3 with SMTP id d9443c01a7336-1f9aa3ca418mr53811995ad.1.1718887941902;
        Thu, 20 Jun 2024 05:52:21 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9a38f9ba2sm44336635ad.70.2024.06.20.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 05:52:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Chenliang Li <cliang01.li@samsung.com>
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com, 
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
In-Reply-To: <20240619063819.2445-1-cliang01.li@samsung.com>
References: <CGME20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b@epcas5p2.samsung.com>
 <20240619063819.2445-1-cliang01.li@samsung.com>
Subject: Re: [PATCH] io_uring/rsrc: fix incorrect assignment of
 iter->nr_segs in io_import_fixed
Message-Id: <171888794078.137921.3762107776389915417.b4-ty@kernel.dk>
Date: Thu, 20 Jun 2024 06:52:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 19 Jun 2024 14:38:19 +0800, Chenliang Li wrote:
> In io_import_fixed when advancing the iter within the first bvec, the
> iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
> bvecs, plus we don't need to adjust it here, so just remove it.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed
      commit: a23800f08a60787dfbf2b87b2e6ed411cb629859

Best regards,
-- 
Jens Axboe





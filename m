Return-Path: <io-uring+bounces-10971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BB259CA5A49
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 23:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 63BAC3009630
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 22:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27536398FAC;
	Thu,  4 Dec 2025 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I8QDHwr4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25A398FA3
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 22:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764888431; cv=none; b=pqk1YIkMcvoTnDSHmijJMNUlSJb6g3ztbH+8aHhsb9Dx7USVH2kCijw3SLNWQyEtuyScseemYUZbBbqJZAs7oVTrAtJVU9eM6ORpCSWXYWhCvKZBMwhESNk1vZS0aZ74ewxsvcZgXJh2vepQynmTCyr9mbObRuVsebvAGyS9lws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764888431; c=relaxed/simple;
	bh=hVNBPFopdbEQqYXKONMvrT+L7g0i1z0cd+8sdf6b0SI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SzDSAi+N0OukOmiRLbaMY8QKIGzxES1BMyUT3LNCHPccEV352rnkDp/VCn7iGJvOgstIobx5UfB3pFUHKmPDabOsTKZIvRR/B+OXhK9phxxMUb1d5hl6cAEpstmgIbO+Ea8NvdXMLDm/t6seZJjg5RL96CeGFSwa3TcR+3KJN0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I8QDHwr4; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-3e898ba2a03so1124625fac.0
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 14:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764888428; x=1765493228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiBPK+KaNj2bIXACxKleBDMN8Wx8S+ScjGT4TvVckK8=;
        b=I8QDHwr43KmSkxCsTsaef7d9LLoLYs1YXW17K5u7vkkIRqQdSOjZ0++q0r1mE9Rh54
         6WlnRdfjLmnuTqSAmqMbRfvzeyq0hnf+kbkVn4ASOOSh2IpM2UppTpZWHjzJnAUHtl/B
         ewaD3BQE02N1DS+wa+kyl4RjcpPlY6V09focdWiY5VZrRQgXYpVNPt7BFfRjT1HXDxlv
         4aci259sHiI03lE+erU7gg0w2rbaMy1mlBzll3hy8BdoSlQFtxTlCIbLIfKWS/Xnfk6f
         Zvgf2CKwoY6wmDJlfbemFB9xTP+Gt9onw7c2yMw+frtQKV5ldwQQutRT4BjVnvoKE7rA
         VVBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764888428; x=1765493228;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hiBPK+KaNj2bIXACxKleBDMN8Wx8S+ScjGT4TvVckK8=;
        b=ef1vUtBYvIp5ni3P4O39zkpX1mIdA5C4YUb2uMD19by4tgOkPtKAhAq3VVP26XqcD+
         MZ4g7SoKbA0YAF0Kw0tDqlXbuJuEx02V/l4TVOTVyASPjF8znSMtGnar9ZCk3BRdRfrn
         kMGAqmWXEp3Vd1cWV291X0ZXelbA6JeDr9QyVdMSdN+XvV61rkJTfJ0EXu5vI/vnR6nv
         TXlYVF+sx+27nnxNONwCRLxhtszQeatAh28IA/D3GOTQ4ZRuVjgbLFkvfKcR8keNLXdr
         mjITThG6qZLKFE/iBgmRUFY60JPMIRY9Ui2WCWIm4MHjRxnCU+6j05NvKX4OxwLfRKcl
         ausg==
X-Gm-Message-State: AOJu0YxgmfYU3R7YRt+lzIFh56PqH2iuX2bg7548C94lzoVg7FeJtpo5
	pXyH/LbRxfqbghnvGTEb9Djx8WA6hZZ4kQqgx9EfPriXG1apwUvWAZY8fyRRYiniiWOcfE4yzjW
	W/KG0/CI=
X-Gm-Gg: ASbGncvzWwhflFUqZmVoH1vPqJPcdNiMVqVUYJU6bZ25AyYZrDrPr7ZvQFUJa7YWgHa
	NQCqcxCUaVCoxfeGl3wpN7ouKZxIfR2StIRqkR160r0giWfH86f6a8PFPpSgs+nNIDDwvC7DGId
	AG2AJXpmfrW9EHqlu+MA30Riu/mS658tKhMUomSIz3PZ84ioEz4d+Nu9NYfJHabWn3Ju818HuxF
	At7GnslM/NfdOVO53Wj3C6Dta+i/S/3ZqGom21oNDQHcAEMI3tsEjMYIwl6J5Z/sUPdfXx0xzt8
	6rfxphS/NrXl2c036ntxBMuBc5mv9ibkdL3ccYDPD2KSJ9gPAUE+e8PwThYbGNRGHzW/y/VblEI
	OO1KhAa4dJx4juheaTq6Sr9mVefQ9piiZonP+nwyMCAaZNeWLG1JIfJYvNwt+B6ShaGAYNB5Zjb
	O9qVE=
X-Google-Smtp-Source: AGHT+IEU35w39aNjg5H/Qw/yjMm3KRA+GYh6s0MxIc+yi23u/88vEMFooG2aS3UjJ3MC3t8R+nTVEw==
X-Received: by 2002:a05:6870:8308:b0:3d2:5173:7022 with SMTP id 586e51a60fabf-3f5063109cemr2570732fac.9.1764888428316;
        Thu, 04 Dec 2025 14:47:08 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f50b514f8bsm2180533fac.10.2025.12.04.14.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 14:47:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20251204215931.2825510-1-joannelkoong@gmail.com>
References: <20251204215931.2825510-1-joannelkoong@gmail.com>
Subject: Re: [PATCH liburing v1] man/io_uring_clone_buffers.3: remove
 duplicate IORING_REGISTER_DST_REPLACE text
Message-Id: <176488842759.1025884.8353381206425348587.b4-ty@kernel.dk>
Date: Thu, 04 Dec 2025 15:47:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 04 Dec 2025 13:59:31 -0800, Joanne Koong wrote:
> Remove accidentally duplicated IORING_REGISTER_DST_REPLACE description.
> 
> 

Applied, thanks!

[1/1] man/io_uring_clone_buffers.3: remove duplicate IORING_REGISTER_DST_REPLACE text
      commit: 203d9fec2d18b4c59da6c1d095f1bb7c5cd31280

Best regards,
-- 
Jens Axboe





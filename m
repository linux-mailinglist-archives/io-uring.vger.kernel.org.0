Return-Path: <io-uring+bounces-926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A840387B2DC
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CF0728894C
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DD1535C4;
	Wed, 13 Mar 2024 20:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="16/J9fSd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AACF524DD
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710361656; cv=none; b=Fs7qKfS7cXIeFI6PnQQHGY+VLKIaUAgLawuB9IioeSigK5DuFNA6k0rm4c85pWGxOFdgp2yMQwycWbjbpncZSK0xT256ALYm+D/gMtYQLgPTiAtaZRU8/1o9CkRFo1F0rwWY/jOvGGkBunJ+gWq+0mtNuFZiYbAWlrrrUnud5jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710361656; c=relaxed/simple;
	bh=dm4X/KFCB/hRnDVS6uIzrihWAT+vLCaAmbFwUdi231Q=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aHO0zHnAYkPTnusEUBhiClFX2CTCqi8fo1lMaQhMHiwWJDdnjKzBMlnaPB2+M7A4hdnGvCwuvOODxtm0StOf5k9CJZakN7ooNWYAp2Jg/3TeFcxr/YIO8rE/2v+GzRqui6tKSe19jbH/KKMHSxyCXFxQ4GEeKd+QsJYJ9hFfVtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=16/J9fSd; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36649b5bee6so427005ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 13:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710361654; x=1710966454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRtYQ8NiS8lH2p1cq8fG2QekDjqgxLONgWEPx9Q5PCI=;
        b=16/J9fSdWh2BkUI4B2Af40serJjqjuo1MuOcV0Qj+BUWKj9fqDmJhnS+z7Y+Fa9Su2
         reZBOw6yBcpoBKNdxEb0WWHJWc2lcsxeEmnvTRoMid7J0AIF+x/fTg98AwasMzP/GJCl
         yo725fPUTYi5LWQF7/LcepK5NbCzSYXeewx/s47jMmJ93kf7wYl6yOQ6RpcftERa5TDt
         9gx2J8W/9l5q91jYcOCY37NLODTMv1XdfwVVZ0LbvlJoSq0sSOz4GLm9QM8fXfsnJ5QJ
         kV0ulzVUoRDrKdY0TiHXwcT6z4zQYtDoFg9mzgy1Zuu6iOKXdz84bHHMbHaYJohLleCA
         7i3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710361654; x=1710966454;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRtYQ8NiS8lH2p1cq8fG2QekDjqgxLONgWEPx9Q5PCI=;
        b=McLAeg95W1a2rkJAUdvilZeaOytHDRQ+GPI6bj/fkYciyNgapJzybdp4OmQnffm9n5
         JbmYXdMJKm+WDckGZv/vYqv6pc8ZXDJ/gnpRLZXbW36JF4HCVP/ipNc3p+YaH59qbtXK
         SKwXJjnZ1iBxUOY43RURhXg+4unYV096rDLP1rjlS+gqhdSc7tMvblbx4epu8AJ18dQR
         kWNbcxT8Fo1xj+rsWh22N+LNVfHuVPGRKWuhA9w7gi9BgJ5a0GFKzpKqCaqIsNXcGOG+
         GjuIdjeDx8LI/1J37h0k6iIEwbja/9jIu94mdNGxLEPx5G/cjhHUQiIfiXUDDyr99E4p
         xGYw==
X-Gm-Message-State: AOJu0Yz6BgnLlNmbTMd5GWew8gjyhA6AuTYGqnlxhWfvm0FPtrpyd/8m
	iKI/hQekE6/UufHQxUY6zKP/d+KKppiHeMKN/SYyqPD8NHxxlVybQLZS7oq92o5zFoCpTfh5TML
	b
X-Google-Smtp-Source: AGHT+IG2B9clD3eR6/+b5HsF4oLpe1GGBQW3Q9srTsLoesdPvmeujt/i3B7OG0jBazotCCQLvvMz2w==
X-Received: by 2002:a5d:84c7:0:b0:7c8:9e3c:783 with SMTP id z7-20020a5d84c7000000b007c89e3c0783mr88449ior.0.1710361654119;
        Wed, 13 Mar 2024 13:27:34 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a42-20020a02942d000000b00476cca7d5b9sm3081057jai.166.2024.03.13.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 13:27:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1710343154.git.asml.silence@gmail.com>
References: <cover.1710343154.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] small rings clean up
Message-Id: <171036165281.297831.7116796850399805279.b4-ty@kernel.dk>
Date: Wed, 13 Mar 2024 14:27:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 13 Mar 2024 15:52:38 +0000, Pavel Begunkov wrote:
> Some disconnected cleanup patches split out of a larger series
> as they make sense by themselves.
> 
> Pavel Begunkov (3):
>   io_uring: simplify io_mem_alloc return values
>   io_uring: simplify io_pages_free
>   io_uring/kbuf: rename is_mapped
> 
> [...]

Applied, thanks!

[1/3] io_uring: simplify io_mem_alloc return values
      commit: ccd2254dfe739e37876e984c44caa6c7f318c728
[2/3] io_uring: simplify io_pages_free
      commit: 91e0c2c9640c959f1f50f6f80a6a7e93562a9272
[3/3] io_uring/kbuf: rename is_mapped
      commit: 585abfacf0c33b11ab66a69ba884a70c9459a63c

Best regards,
-- 
Jens Axboe





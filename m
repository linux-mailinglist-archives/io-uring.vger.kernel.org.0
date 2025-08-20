Return-Path: <io-uring+bounces-9109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174CFB2E4CE
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68D93B44B4
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFBA24C07A;
	Wed, 20 Aug 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tDEHv7Js"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FAC23E32B
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714051; cv=none; b=rHdJhbxw6Zy2fJ1VbV4X6/eqPzou/34UMi4bKtZBsl1lGwRXIGmRS/fCnXzEMcEsrdTt/wYj8K+Zfqbq6Ip0Zzw/pORBzYzcInhmcDUOCK3/0NOtn70zyZuPzuq/4TcKL55Ier4p++iaT5BO6mIlNUE7NIt+iT5knTBIRU4+dAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714051; c=relaxed/simple;
	bh=U6x4g/j2phFfuInwVkMpXQFhyn2hqzRKbF7qbaDqqTs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=vCHIlVw0E/jhmIPjxvLiValDOTNZtC1W0LDbVLb9t1YdwWSnvjfnBX+TlEXIn0YPOaJi5emDdT6K1oH6LG4T3wCoDccljJ4wjiGtuZ9AuM33DvDQszdoo+zI4ZfWdD5w69zOgCZByURBahIW7kiCRCebfqXFt61A2xlp3VyBSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tDEHv7Js; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-88432dc61d8so7140439f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714047; x=1756318847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pYYySig8n81HBiCNDWpyJRJjaS61vi55P9N70coNR50=;
        b=tDEHv7JsPbN14LI/7uviLaJJ+Dvw0Phd8KMfcvCzZzfcD6raVd8/bUG1cJmzyochGe
         /v6L+ayYw/Tg5Usc5esZCQH5RbqXkZx3XZoXt6hA2966LZd9gWZk7nsiqZ83pU/gpmVz
         5UyyAVr/rzz6YJCd/jteNbJzcWv/4R4db5R/vVorQblvwvTGeTS+0nmpuCpFSusPAeGG
         QFwU6WejbwOeP1HCF8CJlFdSF/+utOoGXt63y0+dY20FB2LPARPGrCmUtw6NdE4Qk3hg
         XiTLiwYZlI89gIZijxtXHSi2lad84takXlu8x0v5pVY2M1awjXP3zCSSOTcSA50kTJBw
         Zlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714047; x=1756318847;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pYYySig8n81HBiCNDWpyJRJjaS61vi55P9N70coNR50=;
        b=JuHws/3rAPXdKfh7MvqI1UdnGa9xoORgsQT1rMvq+V5ayIzhHC4bi3N8xtivTaVaOV
         XaAk5XgD+gAc4Ngtqbtn2xDZZZRpsQiE+OvYQFAii3ip9diPsUCrsQ67NwuP9iaZ63Jo
         /BEqBvuhak/sD+2w1+2+y+Dr+YgDtl+kMVjVlg12D5elCtQZY5sGeRQPzZAB489W8L8X
         5T4xzydZkt44bSQQkFK6AWSdQhgDHSEF2z6XLmjdDnuMtTby5dnv4UTZInI0StWL48B1
         0XnZOr61gXnecQjVTSTbybaAq+2JstWvAFxnvFmDVUy8wKa2i+ANd4gV0Ng1uhqdzKDU
         461w==
X-Gm-Message-State: AOJu0Yyx5t9CMVU+X4hSj9C2awO9EMkKpfFpZuGdyGokGiNmq0iPIJDc
	32DPuxwZKWJ/c/tYx73UqL2hpr+84O0dOLzPQExxpvOs/4CaOp0b8JmdX1EkrceXMK1RFF8bx+a
	Y8ftN
X-Gm-Gg: ASbGncstlcHfKeafVRv4T5nk514QfSPyZXINlbGNCPY16RXBzPKg+3Mr1PbnN0KpYHI
	ZGwRoY9Ku08zjtk+PBZKRdpvLkR0OGuuWeF+EXbndW1+MFZqf5bX29Ab8oh7t8ROCb5EhFddNdB
	eKDSTH86mbh/H3Hymf0PeoGJbydSwLRuifpDfqST/0whjmbPDaO9wgDPko7nk6M3G2aV/GVYIAF
	xJQRt0R4fgkDoGgKxojM8PerS26DSpXqIvCabSb2eOxW6qiuEuNa+NQUxYqxtt62o6J9co7GSEm
	vgkfiUwr0V1o+RN4UNj+o+mTgyR7P8YYgPRFy+4TKR216/JZaN4moAxhpsF/EbH96R2iWBaeLO7
	qxcxdnl+ilqpWsaD/tLJYZ3pd
X-Google-Smtp-Source: AGHT+IFtxav+JM4YwtQbhnXrGCjlNWDZUMT/3C3qBwIB7mEyYbcc6FMhSGAyVom08yOjuVQWT785vg==
X-Received: by 2002:a05:6e02:1c02:b0:3e5:7437:13d3 with SMTP id e9e14a558f8ab-3e67ca67d9cmr68822945ab.23.1755714047237;
        Wed, 20 Aug 2025 11:20:47 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cd34sm50335665ab.20.2025.08.20.11.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:20:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
Message-Id: <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
Date: Wed, 20 Aug 2025 12:20:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
> Keep zcrx next changes in a separate branch. It was more productive this
> way past month and will simplify the workflow for already lined up
> changes requiring cross tree patches, specifically netdev. The current
> changes can still target the generic io_uring tree as there are no
> strong reasons to keep it separate. It'll also be using the io_uring
> mailing list.
> 
> [...]

Applied, thanks!

[1/1] io_uring: move zcrx into a separate branch
      commit: 6d136abdd1bdfce0c7108c8e0af6fd95e3d353ad

Best regards,
-- 
Jens Axboe





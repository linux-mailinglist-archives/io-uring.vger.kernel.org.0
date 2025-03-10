Return-Path: <io-uring+bounces-7043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1685A5A3E0
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 20:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59B1C3A722B
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 19:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F78322F151;
	Mon, 10 Mar 2025 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TKO0NWSW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A664C190674
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741635451; cv=none; b=ahYThjoFw0liWolBKSQlPJcytCUKg+ZjL+XC4yu0n59UJxoM24QEzKt9HI4FYrFkdy4/5zIvRVBulIe32RNFaELaP46Fwe+sOJ6qGmwpPKc1GBt2itlrY4KVpgr3QLZCpnBrPrSzF6CvEWqKeXWZfjvyChuUfrU8Cnrjfq0Tymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741635451; c=relaxed/simple;
	bh=6jhUd66hsJlnvrqhCjveADkqD/7MqXRSPBEXTOp2Sk8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f9RPez8fDqDdFGiogQZL79pOjbLxsqnk3Lo0yExOz0SX2RzsONenYe5Y0Bui5zGz8Zj/jJ1HT9wwRPsRwsOeS5dYO8bJsk0CPnCzrBvRDKGZ//i+c8GBu/pkl37+DKUq1+xTOp9T5Dv7aUsS6COrUXfqUSm7Qq5hk1/S9lgI2K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TKO0NWSW; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-854a68f5afcso110427339f.0
        for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 12:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741635447; x=1742240247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foBUAebzEkvbKyY/+pyPYJV+iTWNqY0bHT2GGed7lMc=;
        b=TKO0NWSWhCv56QYpVVuBNNd5tiGQU6byueIgRQ3sUSJM7U9E4dC0hppIfoFPKmzmKm
         2Ak4jR0E4UVITFAwYUQ2UZ5scVKQ2CuZBwTHIP05PghvJmkQAYZ+Rvmd/m7ylVCVHmm9
         pT2OZpwEbncPsJtcv/fUawAlVpwFF3uvo7BUglZPujCtOrh7CrWu9zMBbtFdoHrLjoms
         Yg0Y0HduUi7SYzk4jcbrPy95zUAFle79dtvXf31Bz/21qX9ONtvMe5ydgKQvRHCIhA5S
         JZFBm/Bmlt0rk3yeuLbUfsYXZ2ft8RXiryilhg/aMy2XRy5bM1S7MyEOtOAmvznDsqiM
         73GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741635447; x=1742240247;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foBUAebzEkvbKyY/+pyPYJV+iTWNqY0bHT2GGed7lMc=;
        b=buwNpz4Zdezu8W+kL+R7fbJBRh8mvmVoN+uWJDLIulXW8FrCnSzCGCHZUxPDcn4HbI
         LTCFibmzj/69BWB/DSexjAUkh3XuGF+2+2DX0qXQ3VRDAlKwVHKr4MMYIWVWaHAuPVua
         nMhfQIVX4vtGZJaSZIdvLwE47y6QlQS/ltXPH1A7nsEVcin59Um6Ob102BUxG5O3rHJV
         seWR1jga8l6TdPoHSB4dUi2SXqshNdiSFGUvYxgbUmcg0PMroP7u2M8MD8hbpnMvRm5A
         amabHMbeRRfdO8GxPhcZwoP84knqfbH2A5LMMZuGvmfiCGG/NE1tn78GrhwQoe9E8D7k
         neAg==
X-Forwarded-Encrypted: i=1; AJvYcCXLCIVhXHfgBlpddwaePRv3uvPSq0O6wXPud/Q20NBRPUU9NjeOU14IFmgUqEWWbNZbOMMHS0rTHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjGbi8fyzVrffiFdcsOciM3Lh3zdkUjuogR9kVl+kiqA2LIIw6
	RNpR1ZQKi4c4WqjO7lxGtdRh9fw9R0cHi5Mk4QKpR7mh13Gh65aD4twH4PGrdjqAOhjASIfugv3
	q
X-Gm-Gg: ASbGnct+9mvs/Sa5Bd/rlbL1V/RNu3nqFBJrJ18Ya+6Ugo8cT9wgSeixFT44p/25xNT
	QbBER2HmHp0SyWk4MeaMWuP8sApJGuMQPtjCGEo/p4ONCIrAQVZlPhEV1tHGkEUvD1eFnN0U/bV
	bjqhpeFKowJrWrPs2IO8btwQNmaB3+jvIcnyFxmUeLxFQ7ea+5J499YqnITE1Zw7pFLrKYek9Gw
	Yz++qN01d/tLiMXuoW8rvZlNCDHd1OKJWTT3TI4ZEDUN5eROgmPFUHyGRFeBxAU9l+nEOuaMagr
	jiHBJ3MIIKH8M6d1xG2ow3Jy/6aEnn8M9B3art4TQoyIoQ==
X-Google-Smtp-Source: AGHT+IFSRNl2t1BfKATaU4tjJ/8yGDhIEC64JYLWVodA+LG1R4ppcjMbVTx6hjtr99Jlnw5KeJ1o4w==
X-Received: by 2002:a05:6602:3a09:b0:855:a1f1:9d08 with SMTP id ca18e2360f4ac-85b1cfceeb6mr2121438239f.3.1741635447409;
        Mon, 10 Mar 2025 12:37:27 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2387ec6c0sm665582173.137.2025.03.10.12.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 12:37:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 Keith Busch <kbusch@meta.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <20250310184825.569371-1-kbusch@meta.com>
References: <20250310184825.569371-1-kbusch@meta.com>
Subject: Re: [PATCH] Revert "io_uring/rsrc: simplify the bvec iter count
 calculation"
Message-Id: <174163544639.254288.17689900817752557423.b4-ty@kernel.dk>
Date: Mon, 10 Mar 2025 13:37:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 10 Mar 2025 11:48:25 -0700, Keith Busch wrote:
> This reverts commit 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c.
> 
> The kernel registered bvecs do use the iov_iter_advance() API, so we
> can't rely on this simplification anymore.
> 
> 

Applied, thanks!

[1/1] Revert "io_uring/rsrc: simplify the bvec iter count calculation"
      commit: c93edef0374b203a7109e876ecd396446cb6e1d3

Best regards,
-- 
Jens Axboe





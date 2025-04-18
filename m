Return-Path: <io-uring+bounces-7541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD6FA93833
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 16:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D2F67B2672
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 14:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645C926AF6;
	Fri, 18 Apr 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W6P7/rLf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437CF1C6B4
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744984890; cv=none; b=Ns7XTKSejPg4DKrGtQ6D9AoLwlPs6wuqR7tbpuYNthmqkpUDV45pBhKjDQkLrSUHkKQ6Mc6uSQcPVoc19Tx8AELW3GlSi14xSxJx1L7YVRNAp7MzOpsJKsSRAW9Cy8jrIqfkGY7HXEAfx/yGCGrfaAG1SQiLzpPZ4A3FZ5rVDjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744984890; c=relaxed/simple;
	bh=PQJhYQhsMv0MpbePzzjBsZ++F0flYM/PygLw6HSKZcw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WlV6DCY+v2ihMW65PcLQl/TXIVkMQR29JNgucYxhctpk3RrQb1okvpYFKejSGLSeAa91HaYdx4bSkmTGwq5HwWkwDcUCiaUOM6yLVSrnP0eKXf3Eiw0E4ZF08sU8kCRfNemtLRyXUIayXW0ypWBlFgB5KbC1eKkrUrwDEFsCV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W6P7/rLf; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85e751cffbeso149338239f.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744984887; x=1745589687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sC/BqjM5mkoHmF0ZEZAC3mR2mFzpKmqw2rLh58Lnr/M=;
        b=W6P7/rLf4zuGzWdA7fyiwkikjTJpR/Qsqsc/hqa2BSxttkvLdpWkNddulz9J1eikah
         0fwK7gOvLTDlSgFYpxJBcfFHRehzrdhDYT7q0EoeqShm5dlZ4pD3X1Jxk8OA2n5DFWLS
         XnkID9dMdpXaKpZHQFhZ1NANqs/mKj0nVk0A3uw96WSzhHnGhX/LsmUfIHKMX3bfKmN9
         wIwVXCkEMhps/y9S12IHXAqBjTUZbkPpciI5PC3mNonIdf5YcR2KKNp4F0cBEz0csBfe
         ogNMAccLPBRr7MHcpxLcu+0b49mCiwBEJkjtLIYih0iWxOvAsEw7qeiT0VOgMt7kshgr
         ENeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744984887; x=1745589687;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sC/BqjM5mkoHmF0ZEZAC3mR2mFzpKmqw2rLh58Lnr/M=;
        b=V4Z6J3wjNISoaLNxVGCMbj6oJ6NmfpzgovNm0MaM0Pg9ukn43oGcloAQzf7wIrleoC
         Bmhla15OQfWk+EwxCLLPOJb1r4SdQ+aiGSeajJMonavzXkfa2PVZ3a+TrMyAwnB9FV7k
         a2HAkzfBiGTwfb9Ljk1r6OJIY9HPtzvBRnlMS96CgqB6UiNgD5Y4sE0wK+bqmRdyxAn2
         b3WFHA4q9AXeVtrpfI3lmaj6soZzplNdN85rhJoHbB2Cc89/JWUfTKGQWIalSla/DB+J
         9aSGakyR22/c2sjBu3NVDCUMtp3nFzlnyCcbrqXDGc7RAj7Y3esTGem4y5EUdqnJsUO5
         vB+A==
X-Gm-Message-State: AOJu0YyIaXnQ//+BxbkaTlzzzDQi7AoUEJuolBIfqIGVuHO7wiuhpiZD
	k3Fs2UySyH3+zshi7b/pTE2xRf9tmCRG0MdvuT26iRHH3KgpqtskCTHc1blyshFM88cggeTcwcI
	4
X-Gm-Gg: ASbGncu+sDbQYea4fiCT2Tib+B0j+nj2dLSzOYs7NqHeBK0/LCYbFN/e37qE6OQTLcD
	xZFQNIU8B0YEt6zHLH0wtT0A3hEjHD49O/+n8ZBlUiyzfs59NSiI3YQe/l4UHdMfQ8tyBU/fNhG
	Kbskqm31zEY5ck1IMINmltoViWpvIdEOaLsGUT/zbMhs5VNnD4VI9tlNKnGs6Cmoht8MCbUtkKO
	nBaqjym2tfNzXyjnnEAYgh7b+xwgzpqVAlfAQGswbSGOMRKnUFwkuYEzJVjPZuF6xG59F2U+riw
	kBRP2SWF8TZqPPdN98Ga9/l03XjgShM=
X-Google-Smtp-Source: AGHT+IGxSs5KjMlhBU5ReFue9k/mK/MwbQI1TY+914sEhLQKUPzGe8W+IItktORYdswpMLQPVCp3Fg==
X-Received: by 2002:a05:6602:370a:b0:85b:43a3:66ad with SMTP id ca18e2360f4ac-861dbe3b67bmr227329539f.8.1744984886849;
        Fri, 18 Apr 2025 07:01:26 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37fb41dsm463105173.38.2025.04.18.07.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 07:01:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, 
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>, 
 netdev@vger.kernel.org
In-Reply-To: <ef9b7db249b14f6e0b570a1bb77ff177389f881c.1744965853.git.asml.silence@gmail.com>
References: <ef9b7db249b14f6e0b570a1bb77ff177389f881c.1744965853.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-6.15] io_uring/zcrx: fix late dma unmap for a
 dead dev
Message-Id: <174498488589.689807.7439507318071758979.b4-ty@kernel.dk>
Date: Fri, 18 Apr 2025 08:01:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 18 Apr 2025 13:02:27 +0100, Pavel Begunkov wrote:
> There is a problem with page pools not dma-unmapping immediately
> when the device is going down, and delaying it until the page pool is
> destroyed, which is not allowed (see links). That just got fixed for
> normal page pools, and we need to address memory providers as well.
> 
> Unmap pages in the memory provider uninstall callback, and protect it
> with a new lock. There is also a gap between a dma mapping is created
> and the mp is installed, so if the device is killed in between,
> io_uring would be hodling dma mapping to a dead device with no one to
> call ->uninstall. Move it to page pool init and rely on ->is_mapped to
> make sure it's only done once.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: fix late dma unmap for a dead dev
      commit: f12ecf5e1c5eca48b8652e893afcdb730384a6aa

Best regards,
-- 
Jens Axboe





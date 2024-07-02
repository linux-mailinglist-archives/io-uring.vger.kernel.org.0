Return-Path: <io-uring+bounces-2411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04955924142
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 16:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB6FF1F241F5
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 14:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222BE1BB680;
	Tue,  2 Jul 2024 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MeQ1pD44"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506151BA888
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719931738; cv=none; b=G0Dkzm59H67KRXDJaS93iEat0WP2CqUx1FtHHrTnaOO4TFTW232K818+uRdXV3q/ZbVDsmUtVtqFE14xWPwQdnzthJSDvM6RBXHyYGweSusoomb9Ui51WmrmYsooemAfJkmmEARI4snwXr0xcQwtgZC/EfKRCdcXYwny04wskMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719931738; c=relaxed/simple;
	bh=kE2EMoMVi5HFrE1nPBPZXOK1mFJQfnUdd2goohl2xjg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ty4/2msl1yCfZpF1r4G8m+1ifaEVczMUruy6xbKfAfA8zgH3EgKAlKLGnnw/Al1zkJ7ofYX03vNDSQUYpAYVTfwp8ce0nkey2zzanOtLy44eIB9uTDoZNL+qViaxqyVyDSGkG26rI4YRyiZD2k0uT9pNDbJRog9RZcSIexd9Ay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MeQ1pD44; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d1b6b6b2c5so257955b6e.0
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719931734; x=1720536534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NS5FFp2fM85P9s0J5QJSSVoTtjXmywpLZYR8ZikQajc=;
        b=MeQ1pD445o24BLdlbDGx7b9fWB3xxOL99uFzA7dogfgP6jA4zSZrIukJ9M195AgPgb
         l/ExoTTF54BQAnzqPMieLmKS3pnqmCofpRPwOQEHcsqK4ROekwcrUE7xbVQpSnfXiM6e
         bhBaps7U4a5aBMKAihUyGUefzVuAMsyWo5cC3a5m6sDV4fYY8/O6vVNO4p9mS4IhqGnT
         Z6MliiswOC61yT3x6MU2szt57mCH+Za8BDjlqm+xFHh9DWvobMOsRSnR+ZdrFBUyD2Eh
         RTGz5+9Ar5147Y+G7vjmgRIMxehlsBnwE18DA3Fyyb7zX0b6BzMIIgbBTWA5AlFe6UOF
         OMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719931734; x=1720536534;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NS5FFp2fM85P9s0J5QJSSVoTtjXmywpLZYR8ZikQajc=;
        b=Hn1a5QFCYg+Izk/kPVR3Qj69XFc7497JOHIQatFnByNikNa2uoxvoy/enCCxj/a+nB
         2FkMR5ON4iudu6BhQtOLK1db0V5vMtUjfoE7LYNXgXr6yNeDG+yJceBNiBH2uKCz4i/7
         YVzdZOdBHB5D/wKZM9N4m0J1udczWZ9/9lWjIAsn3qXjW17hF+TRQn1SNQm/qAayNRqc
         g89H+5+TYjJU1mupsoE+7/gF4o8c1zqZ/A3ysFguVGYOkbjY5tvKXdjPGS71iFxdTwP9
         x8R1+IKjPDSiJ54+klYoUnzbB9Tkw6WRKnc5xlN0BqD+LXmMsgdDZy9yxeiPBXCL2xxo
         Lo9A==
X-Gm-Message-State: AOJu0YyTlzOp5uzss7ALMW+KMbQCJGqXh9J+y4w/PfkDqw22g87/kywl
	DYDB9DHgLYmit/0DBl7r6WoHSo+2NpbkwbWTy9ebs2HghqC5p3yjxVusJaMzqjj1NcZFQUPBhms
	P2dA=
X-Google-Smtp-Source: AGHT+IE5ELaoUG+USWAoIxcm0aSzaXm1EKkjahyCsmYFjuYgDqxmzRUHY/XgJxT4TQATgnt5MuvmjA==
X-Received: by 2002:a05:6808:1a2a:b0:3d5:65c7:c26c with SMTP id 5614622812f47-3d6b549a9fcmr9990952b6e.4.1719931733854;
        Tue, 02 Jul 2024 07:48:53 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d62f9b9029sm1743041b6e.5.2024.07.02.07.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 07:48:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
In-Reply-To: <c7350d07fefe8cce32b50f57665edbb6355ea8c1.1719927398.git.asml.silence@gmail.com>
References: <c7350d07fefe8cce32b50f57665edbb6355ea8c1.1719927398.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/msg_ring: fix overflow posting
Message-Id: <171993173213.106736.16405833046614898902.b4-ty@kernel.dk>
Date: Tue, 02 Jul 2024 08:48:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Tue, 02 Jul 2024 14:38:11 +0100, Pavel Begunkov wrote:
> The caller of io_cqring_event_overflow() should be holding the
> completion_lock, which is violated by io_msg_tw_complete. There
> is only one caller of io_add_aux_cqe(), so just add locking there
> for now.
> 
> WARNING: CPU: 0 PID: 5145 at io_uring/io_uring.c:703 io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
> RIP: 0010:io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
>  <TASK>
>  __io_post_aux_cqe io_uring/io_uring.c:816 [inline]
>  io_add_aux_cqe+0x27c/0x320 io_uring/io_uring.c:837
>  io_msg_tw_complete+0x9d/0x4d0 io_uring/msg_ring.c:78
>  io_fallback_req_func+0xce/0x1c0 io_uring/io_uring.c:256
>  process_one_work kernel/workqueue.c:3224 [inline]
>  process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
>  worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:144
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: fix overflow posting
      commit: 3b7c16be30e35ec035b2efcc0f7d7b368789c443

Best regards,
-- 
Jens Axboe





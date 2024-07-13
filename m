Return-Path: <io-uring+bounces-2507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FBE93059E
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 14:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A4BE1C20C8E
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 12:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CBC130A40;
	Sat, 13 Jul 2024 12:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BocKxkQ/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A924C8E
	for <io-uring@vger.kernel.org>; Sat, 13 Jul 2024 12:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720874453; cv=none; b=pBymH3/k06GGh4iUA5JDTD4PI1h8MuL1kcThGF0awmJHphznas9ovdVexaEEaobZo8BTjhmybWnN5lvL0c3HYSEmYvYv6vSZcTEjFiLZTg8ZDO3SEK3x41eCQuJ39udvXkAuMcszgisHiqdiN8QUBaoPrgKvQbDaVpKEr0fNVJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720874453; c=relaxed/simple;
	bh=4yFSu7XXmhJSzSwUYrnLbemHBPSoslS8OR1+wHBffNg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=idF1+zB9SGiQvwg2in9Xc8h/Ha++3o68vdsl6GReYR6ZrQL+0onrB+sKqpz/h5JJ7PGw9yKjz0mx9KpUPa3twZUc74CtOIH7CpjOw3wercAWRCeg4jlZvv6DbdWgvb+6H3LbMUHfO0Se9VKyndOrdh2LO+PyuzWoce+gB59u7to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BocKxkQ/; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ee9bca8652so3577651fa.3
        for <io-uring@vger.kernel.org>; Sat, 13 Jul 2024 05:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720874449; x=1721479249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ev9MEMcim44wSH4EZqGa+LQX0BIyzafscHDCWffwRWI=;
        b=BocKxkQ/HzQcpANfCO5t4JmrzMAHxH5Y8yw7LEbnv7wVQima6z1FIJR6H+I5VFLKxj
         b1jqpKCNgZrgrG+vE5qZiKP+PvkXJZRmxm4OSP8p8dKsUntHjoID36zdfWHGg7gpqKG3
         3Zw9H51p7SanxmuulCVD2Yp9Yv/tRLAgxYtwEKQvgmr3h/eniyCHBa1OmaG/z1mFT4HJ
         P+AGsaTT14W/vIE5FBI/Qz4+RDHvFCLyHwdX0YBBHZ8gtxk9sm+SW1RscVs4DlrDn0Qc
         S++NoikIXvnNIXQFStEEsWx0MxMM2yHF08D6MWCplKmbLXzepz3H8c5Gggf8MGfMXTSs
         MC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720874449; x=1721479249;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ev9MEMcim44wSH4EZqGa+LQX0BIyzafscHDCWffwRWI=;
        b=w2lRZYfC32zQyjX4C9OMS9sdn8DcS1ab3P6JGrNkQbQwd57Y11pL+Z/sBmhkm6RsdF
         CDkVcJ9QZHUHaCoG84Q/OrcE8kTyjD75flDmyX41582863ZdrSFkpGG1i+4Z4QbGzpKY
         Rb/bZbmIYHeJWCOp8UNxwnIvMBy6s8qmZv6l1J2w4e9Tu1ncxgB5oqn1cekem38q8wjg
         JEQLjbZ+luLtUf2YmDtNGeaTpsYTURdzTp5NMmf0xlvxiUcw63dyYcref+xWI16G7sbC
         RmWAVFCrNEsYKZ3KqcmMSxDlV4McAu25bt3cy26N3allvIM+aLQ/ypElLP7SMkTDx9VF
         3H6A==
X-Forwarded-Encrypted: i=1; AJvYcCWanNXdgo5wfQjw5nlaxLoHpX3iy4pmk3V3vshIIMLaKutATnJZFQ4TKgWfg0ZGvQCCqhi8j2tnDJTs7YQaEqeZj/9wmP5HoCs=
X-Gm-Message-State: AOJu0YyJ4p/grmcT5OIgVuZJfiycSQPxMx55/AgQN9vM/XldkbWVgQBt
	N51nzas/UGoAKSu42X4QLqtBkNyiN+pFMlIRh0Dihtpo3IFyU+rAA1NCNRYzU5c=
X-Google-Smtp-Source: AGHT+IEDmDpZI2HOW9VBq0n2GsPSGvdL5UM+HjYSsiEoOGG4Tzgtwq9ejM87FCvZTWOzaPyOAXNkUQ==
X-Received: by 2002:ac2:5b04:0:b0:52c:dc76:4876 with SMTP id 2adb3069b0e04-52ec3faf952mr3591414e87.6.1720874449263;
        Sat, 13 Jul 2024 05:40:49 -0700 (PDT)
Received: from [127.0.0.1] ([2a02:aa7:464b:1644:7862:56e0:794e:2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ed252d6a1sm177225e87.175.2024.07.13.05.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jul 2024 05:40:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+1e811482aa2c70afa9a0@syzkaller.appspotmail.com>, 
 io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Gabriel Krisman Bertazi <krisman@suse.de>, 
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <903da529-eaa3-43ef-ae41-d30f376c60cc@I-love.SAKURA.ne.jp>
References: <0000000000007b7ce6061d1caec0@google.com>
 <903da529-eaa3-43ef-ae41-d30f376c60cc@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] io_uring: Check socket is valid in
 io_bind()/io_listen()
Message-Id: <172087444804.7272.17982342612300126690.b4-ty@kernel.dk>
Date: Sat, 13 Jul 2024 06:40:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Sat, 13 Jul 2024 19:05:02 +0900, Tetsuo Handa wrote:
> We need to check that sock_from_file(req->file) != NULL.
> 
> 

Applied, thanks!

[1/1] io_uring: Check socket is valid in io_bind()/io_listen()
      commit: ad00e629145b2b9f0d78aa46e204a9df7d628978

Best regards,
-- 
Jens Axboe





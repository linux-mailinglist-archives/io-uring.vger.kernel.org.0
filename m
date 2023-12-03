Return-Path: <io-uring+bounces-210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9449580251D
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 16:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C592B1C20935
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 15:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C77B156C3;
	Sun,  3 Dec 2023 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mVOzcIvV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68731EB
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 07:22:22 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-2867ea3abedso216839a91.1
        for <io-uring@vger.kernel.org>; Sun, 03 Dec 2023 07:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701616942; x=1702221742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qRJ/T4VcXg2PrnX953egP1xy8Q6JFZ3ojEvgYTkSknQ=;
        b=mVOzcIvV1osJu7KCFTwVkCBx/gHviq0zMeU3zTPAVF9F3uo5Ku/fY8WRrhvQ7C9Wox
         hv5Hp7zvZEEGmmB8Z2RWyZkxzMf21PLxJjp1OCnSKE4zdJnMYZBP19Svi0xP1CoQF47p
         Gl/hjYQ+qptZMmDzfwfXWsCj7u8ttAdT+4YhIenmZaXwMsjddF+jhsGo0AgRCqXgbpuG
         gHbu+o7c/KNaXNh+tdJGmqA2q5PeRwmAK8MSpXQoalew3j8dtXkNPqojdDHMebYhFC1z
         nlL3w2vaAc00q7g7d9oigwbMY0/K0mR5yDyLg02kgzS7lnpkIyRPWhS87CSGlZQ2aBgB
         kheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701616942; x=1702221742;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRJ/T4VcXg2PrnX953egP1xy8Q6JFZ3ojEvgYTkSknQ=;
        b=NZ0GsxVrKHRLOK55wfJ5m/5aRRgn0I27syrHOv88Sirit1yd89Gae8EkFbAR4pmKgx
         FOZyNc5B/VFay7PAwKaFWV8D23squeRVF9aQ03T4OxX5BdpRXTUcREWqnOn6H26MCC0S
         ApnrQNM1ID7g6fGU2IPEpgGk8hb/C8j88+LYRswSh+IQV81WR+ZpkNf01VcwfW68/BcC
         EOPMC/ymH2+PDTUEM5um7V+P+swZHnUY+nnPGgWkLJCQM7QQnNtA+ibYoziDhcl+Zns2
         RnKwGcmwDXJXJxk4oq3mJZfg3wtpfaXiNusOPbWuuU/pr9LEslspI5V00sMOJp7Dzk5r
         qNMg==
X-Gm-Message-State: AOJu0YwIm/cxrnGhwF/wA0Q7EYw8XcRidwVMuishNYh0Vqv/xU6DObnh
	ZquuGsG1t/Hmz4kOOakur9A+sA==
X-Google-Smtp-Source: AGHT+IF1l9xtUh9/r3aR9wOxWNIDw/EK0jgfdjjKFaDX8tWRew3/P+NV80+88zsVWbs8QOvLJoNbMg==
X-Received: by 2002:a05:6a00:3904:b0:68e:2fd4:288a with SMTP id fh4-20020a056a00390400b0068e2fd4288amr36562020pfb.3.1701616941832;
        Sun, 03 Dec 2023 07:22:21 -0800 (PST)
Received: from [127.0.0.1] (50-255-6-74-static.hfc.comcastbusiness.net. [50.255.6.74])
        by smtp.gmail.com with ESMTPSA id p19-20020a637f53000000b005c66a7d70fdsm2111854pgn.61.2023.12.03.07.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 07:22:21 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, ming.lei@redhat.com, joshi.k@samsung.com, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 Paul Moore <paul@paul-moore.com>
In-Reply-To: <cover.1701391955.git.asml.silence@gmail.com>
References: <cover.1701391955.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/3] clean up io_uring cmd header structure
Message-Id: <170161694061.938645.776262768452153331.b4-ty@kernel.dk>
Date: Sun, 03 Dec 2023 08:22:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Fri, 01 Dec 2023 00:57:34 +0000, Pavel Begunkov wrote:
> Looking at the zc rfc, and how we tend to stuff everything into
> linux/io_uring, start splitting the file before it becomes even more
> monstrous.
> 
> V2: fix up includes for security/
>     Add new files to MAINTAINERS
> 
> [...]

Applied, thanks!

[1/3] io_uring: split out cmd api into a separate header
      (no commit info)
[2/3] io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
      (no commit info)
[3/3] io_uring/cmd: inline io_uring_cmd_get_task
      (no commit info)

Best regards,
-- 
Jens Axboe





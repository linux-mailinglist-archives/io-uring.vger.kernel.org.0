Return-Path: <io-uring+bounces-257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B757809258
	for <lists+io-uring@lfdr.de>; Thu,  7 Dec 2023 21:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA00C1F211B6
	for <lists+io-uring@lfdr.de>; Thu,  7 Dec 2023 20:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B0550274;
	Thu,  7 Dec 2023 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ezrYUG92"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9153A1710
	for <io-uring@vger.kernel.org>; Thu,  7 Dec 2023 12:33:08 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7b38ff8a517so5556739f.1
        for <io-uring@vger.kernel.org>; Thu, 07 Dec 2023 12:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701981187; x=1702585987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rONIwxaBNSKoSUUCBPLj6/pKo/BjmroATZ1I6ipi+0Q=;
        b=ezrYUG92Xfl+oBpuNPPFV4b8rQipPVK7Nx2t7poJUEguE/THmKk7h4lpODhrDksywF
         nFQJFdhnGYmwgncHuW7UICin0rvRvgi+MNS25ktVWHEgtmKTR35NTp+lSZ1RVmN+L0P0
         8aWMVX3UGgk8DfEcfPBZpHfBzW/4ctHSQ4tmMjEUw0psYutYs+SeXGayG9kPKH3nbn7+
         rdclNAziybS76ab4eSXmE2ZqmiNBxjqwfxcFUhQo/i7cqhc8TeCLS4OtmlX0dxyA+fgq
         aJAj9U5bUHds4eyTmgScC5+WzdVSJjBl+4vSK7nexPPvN4eO2KToVNixR8pj4QyjM5Yz
         QODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701981187; x=1702585987;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rONIwxaBNSKoSUUCBPLj6/pKo/BjmroATZ1I6ipi+0Q=;
        b=tCQ2CQTgAIgNwKyxSY0DDxwpyiobuAybmM0Qjm0gHOxunDexJdiPgnYEJvbpieysrh
         Wq0Ki972YXZinlfUMuGrVCnT2NkyOZ9BCVTrgJNa5lrq63lhAXYN9uWV4jPkTl3EjUfD
         YWLjChbdJ1NEJLLnZFXeiTC3RmBskP0clBt0QjC2sOvrVPwcrkiGGtuUJfOEYgZvmZ/E
         Ba0Yn0vvWRkFbUQOA+Zc1sC1AQ9L2xui+sX2siMVKrsiuyrpdIpF6fDcwr4rZbqOzBzp
         8lrc68gUVzVYUV3Z6uEgO7Kw40IWA+uQgOTpQ2GLk0RcdMqSLYXza/bLB0gefKxt+qKu
         4rSQ==
X-Gm-Message-State: AOJu0YyJeObcW2+sBA9bIafMR/saZE7cICp82JpZGyWV3HW7uL0usfBn
	CofbfaOH9aCyPZdGVTO6DjLdsgN+jkgcf7oCSrE4JA==
X-Google-Smtp-Source: AGHT+IGszBu0D8ts4Ntw66Ft5ouX7GY4EJFrpGjLR0GpcZtEm+Kakl/G2+X3O0WqBHL2APWazjQHkw==
X-Received: by 2002:a05:6e02:1c04:b0:35d:6600:fceb with SMTP id l4-20020a056e021c0400b0035d6600fcebmr7425882ilh.0.1701981187544;
        Thu, 07 Dec 2023 12:33:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h17-20020a056e021d9100b0035d3be59977sm104154ila.85.2023.12.07.12.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 12:33:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: jannh@google.com
In-Reply-To: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
Message-Id: <170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
Date: Thu, 07 Dec 2023 13:33:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Wed, 06 Dec 2023 13:26:47 +0000, Pavel Begunkov wrote:
> File reference cycles have caused lots of problems for io_uring
> in the past, and it still doesn't work exactly right and races with
> unix_stream_read_generic(). The safest fix would be to completely
> disallow sending io_uring files via sockets via SCM_RIGHT, so there
> are no possible cycles invloving registered files and thus rendering
> SCM accounting on the io_uring side unnecessary.
> 
> [...]

Applied, thanks!

[1/1] io_uring/af_unix: disable sending io_uring over sockets
      (no commit info)

Best regards,
-- 
Jens Axboe





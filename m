Return-Path: <io-uring+bounces-46-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A3C7E2E5B
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F451280D11
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB7929CF6;
	Mon,  6 Nov 2023 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MFuHcnUa"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDF29D11
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:42:51 +0000 (UTC)
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE5ED7E
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:42:50 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3574c225c14so6746325ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699303370; x=1699908170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIOeXxH5y7Jhns+ofOR+0TAbN+EY/lHQvzVJXsDlVu0=;
        b=MFuHcnUaTzVzY4nUh1gdTGqk9p1SR9n4f4DWiR0MGTC632tV5jTbzvFecXcs4wM3au
         DYj9pXThx4Ywo39VAPpyWSonhZLWgCM1yR1OFTD0h2+YDQoYnj6sjzhhX8I8uWfZ/Gdh
         hcG98TQYDn2aMNvZuHoAieV8V/u1ofYiMvqwbpLV49Mwni14kl8nQ7m+VbuKO68OkEGW
         72YZyGaPkYwavBNHrLRXXl7Zrkg/JSROVY0Li3aMgFwC8VQSAGe0+F3L1D3O8g/fQGYr
         fdUeO++lNB0g0vvkLKfvQu+Q/p281kgz9BlgrwZdedmLixUe9XuxbAgNLBE99BJlFUHY
         fGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699303370; x=1699908170;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIOeXxH5y7Jhns+ofOR+0TAbN+EY/lHQvzVJXsDlVu0=;
        b=dGCIbuq6RE4ZV92qsTwUaIlXZsAHfrO5pKRBqT+vaRJjy/iaTQPyapNE5itzjczLQW
         NERGpL3O1G4XPCTeuV7w49qRj9cMswTgcbMagLoQ0J0xd/9CQl+ZkuA9JhleVvc9uS/V
         1VeinFaaIg7noQj7gWernHOcBZSyAa5OyR3j8Ofp6ezxERzZyj/jkIqDuec5IuTj2nRH
         T6tymE200p1Ai3KTD5PEzRPeTnP+C+19y0PoZOXlisBtOpJE2sRdkp0vwL5vZFu9nSKl
         ts9ZlhVLxM+BQR68AZNPSN9chlWqSBzYM29kiIFb9EDXjZSt1x/iACx0NIAX/0BOSlZv
         tAUQ==
X-Gm-Message-State: AOJu0YxdoDMCDwE3OT1hPf3LPMIeNt2d2Njspr553iHYDc4yOkNnNFxt
	FYDFUcDO9oRcN1igoIvtdMUFFA==
X-Google-Smtp-Source: AGHT+IHQhbEEGIHp3U8wbxeg1NPMCrgS9kyctYR6XEIrFdFYbPiGHRZijOYmBBUiDg/ZRMZKvW947g==
X-Received: by 2002:a6b:500a:0:b0:792:6068:dcc8 with SMTP id e10-20020a6b500a000000b007926068dcc8mr32837431iob.2.1699303369751;
        Mon, 06 Nov 2023 12:42:49 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z26-20020a029f1a000000b004564b193674sm2346564jal.160.2023.11.06.12.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:42:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Dylan Yudaken <dyudaken@gmail.com>
Cc: asml.silence@gmail.com
In-Reply-To: <20231106203909.197089-1-dyudaken@gmail.com>
References: <20231106203909.197089-1-dyudaken@gmail.com>
Subject: Re: [PATCH v2 0/3] io_uring: mshot read fix for buffer size
 changes
Message-Id: <169930336907.203554.16139866523353846821.b4-ty@kernel.dk>
Date: Mon, 06 Nov 2023 13:42:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-26615


On Mon, 06 Nov 2023 20:39:06 +0000, Dylan Yudaken wrote:
> This series fixes a bug (see [1] for liburing patch)
> where the used buffer size is clamped to the minimum of all the
> previous buffers selected.
> 
> It also as part of this forces the multishot read API to set addr &
> len to 0.
> len should probably have some accounting post-processing if it has
> meaning to set it to non-zero, but I think for a new API it is simpler
> to overly-constrain it upfront?
> 
> [...]

Applied, thanks!

[1/3] io_uring: indicate if io_kbuf_recycle did recycle anything
      commit: 89d528ba2f8281de61163c6b62e598b64d832175
[2/3] io_uring: do not allow multishot read to set addr or len
      commit: 49fbe99486786661994a55ced855c31d966bbdf0
[3/3] io_uring: do not clamp read length for multishot read
      commit: e53759298a7d7e98c3e5c2440d395d19cea7d6bf

Best regards,
-- 
Jens Axboe





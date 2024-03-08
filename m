Return-Path: <io-uring+bounces-867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84379876797
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 16:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23F2B1F211AD
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 15:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3849C2577B;
	Fri,  8 Mar 2024 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q8D47905"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83CD24A1A
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709912827; cv=none; b=cs5yhSyPEJDQ7PxGBH6t/GMNmYhAW4PopzGnXqXNauM5CCbp4MVq8BfcVUUwwVaojTBAXc7GcBCQLJcErdFc6E6/LNwOpFMnQBT2AtIXvSfQf4ramP1BgBHsgHpG7TcVzNpwY8+WWb6RUs6mFhw56eBKbKPl7/OU44VGL6HPRxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709912827; c=relaxed/simple;
	bh=CsA0X3qXh7Y/LhKQUvqiTzlVFJNKAsfosN529X2njvc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RyzcIkRpWZuBi0j0gqv0bK3mDskHlWUIMCgiai1JKOCBiM4LrR/cZFrIs2xx9ZWicpXeOf9yygnRSbCCYpUYO5ARgwdkh3qZG5Gpo+ckMGpqbGa5hm7mUACdCwkRGxhxpAmlTdgj1rh6rA8N+5pWI4fo+T+6F2+7xKWDxrSjrXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q8D47905; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7c495be1924so32234039f.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 07:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709912823; x=1710517623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PC0EZ3oV5vkqGsa2ypGwNGHexUg8/yY75u6oX545LCU=;
        b=Q8D47905q7SFXgJgLAqH6FSJp+9b84kvJm3a9YpvwxsfqleIquBV7yl8F3q6SAoo2h
         gxLJUJI3m1FLqAJwN9hAiMyvnal0pP+/1x9t8RvjNxhhrYha5rTlcmtVxhr0A3bZrJGK
         Cv084hZ0lcMMkyfp7W2pHQRcygHV60NHdRw2LNLcbFNiK8nVCQ2XNRpCEvKNNyyOsEcm
         BV6KHDy62JMhWw+ZxFlCC+VOXF2BLOPxiAjyk+j4NjSGxxeaE8ALbrO5tKH801r5VZ8E
         rhcUImo9neBnbOvMaZK6chO4ouu18XjllsoEDeQZ2DbPR7zXsILapjApnvKORkjQSntP
         bRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709912823; x=1710517623;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PC0EZ3oV5vkqGsa2ypGwNGHexUg8/yY75u6oX545LCU=;
        b=rU0T/4N403ovuHH9KPPyWqa4KpDimd4k5cmh17L9Q0//y/dgU3cYw/R91epqktC/sR
         icqLvMKlAbHGDjqqlBABoXSzL3vfnCMDlEq83fkZHcqjUat4Svc+f6uXYiCkCSjPtZaz
         +3dGWarB3+h5iKW5NH6BFEAm+zTCfQ7yNYt93vineBPczGQX0GhtJ3DivS90rGOlPoE1
         npFI87Si+pUoTOOJpAXRuPFh7naFvyzmsUEjJiFGA039ApUM+rYnWTtEQp8v+WVBdH6Z
         G2ah3nRxU4Qxe6aqgyEkFsIBqBB/ellAd4EvVv+T5RQ6G26Gs7YDiP4E1gHzskZKWtvl
         lWxg==
X-Gm-Message-State: AOJu0Yw/tXsxBghYZTVGWdwKkEFXlpUHALqqM+JAQFo+I/UtUfdk4GVZ
	XqzWQcqa95Za96P2PE4rywzbJs2UL2F2dU6uWiD1qb5fsTH94kxVaZEnnlvskoFuiclas2pp03P
	o
X-Google-Smtp-Source: AGHT+IHabgnBiRBnoQ8VEJQ2tmLlrtJGBY1ceohRaey9pzqsW5Bn6t9yYarIXdN8bZQQdL9Aep5Vwg==
X-Received: by 2002:a05:6e02:1d0f:b0:365:4e45:78cb with SMTP id i15-20020a056e021d0f00b003654e4578cbmr2432463ila.2.1709912822780;
        Fri, 08 Mar 2024 07:47:02 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w37-20020a05663837a500b00476cca7d5b9sm169672jal.166.2024.03.08.07.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 07:47:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1709905727.git.asml.silence@gmail.com>
References: <cover.1709905727.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] net mshot fixes and improvements
Message-Id: <170991282225.861602.4486525896771390371.b4-ty@kernel.dk>
Date: Fri, 08 Mar 2024 08:47:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 08 Mar 2024 13:55:55 +0000, Pavel Begunkov wrote:
> The first patch fixes multishot interaction with io-wq for net
> opcodes, followed by a couple of clean ups.
> 
> Pavel Begunkov (3):
>   io_uring: fix mshot io-wq checks
>   io_uring: refactor DEFER_TASKRUN multishot checks
>   io_uring/net: dedup io_recv_finish req completion
> 
> [...]

Applied, thanks!

[1/3] io_uring: fix mshot io-wq checks
      commit: 3a96378e22cc46c7c49b5911f6c8631527a133a9
[2/3] io_uring: refactor DEFER_TASKRUN multishot checks
      commit: e0e4ab52d17096d96c21a6805ccd424b283c3c6d
[3/3] io_uring/net: dedup io_recv_finish req completion
      commit: 1af04699c59713a7693cc63d80b29152579e61c3

Best regards,
-- 
Jens Axboe





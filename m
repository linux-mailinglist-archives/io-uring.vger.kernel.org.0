Return-Path: <io-uring+bounces-4768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BEE9D04A2
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 17:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C160C1F21A08
	for <lists+io-uring@lfdr.de>; Sun, 17 Nov 2024 16:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DC426ACB;
	Sun, 17 Nov 2024 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2yVeWjHG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ECB1DA10B
	for <io-uring@vger.kernel.org>; Sun, 17 Nov 2024 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731859422; cv=none; b=APxzu15dzRaBz9j8roz46CSTrp7yYDSef0AxJL3WbGpE7ppl53hYtttx4QQOuPR3ZO/L37gHz2jthlzFMvifvttI6D0HdQxG5aGN6iT++81M4wwvCL02nG7mMZmaG67Hb6kG7YxFJu68+ESUBC/W9Z+R2CPXFPuGiEHI8I1FvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731859422; c=relaxed/simple;
	bh=Ju4q9yDux2DiOK/SSfMfe6SPwHu+g4c3bDJBYXtjOME=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h+IJOiCkOX/fKYoMZJpjvU1eCMzVTUY7wYMKTLvGEGoq/5Dxc4ZXmyE8FDUKl5vfh+U7x1YHb448WGA68LHRw4fGR6S5W9rs/CC+XGUUK1i3YpzTmXtnWsgG/6wvz7UB+UfBjbCgBZb4U9tWTpKaI8ykz5Wny3VKnYi4APUpDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2yVeWjHG; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7240d93fffdso1921997b3a.2
        for <io-uring@vger.kernel.org>; Sun, 17 Nov 2024 08:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731859418; x=1732464218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sTPNbKfuLOHmM0adWhuoo97dgJ5/zWEwLgt8/SkSbcs=;
        b=2yVeWjHGRYF+7ytqL4R3Dsjq/Nve43phwjXcmAGBprRC52Gri050H1VBuDr+D7fsPO
         deEhyPhLoW9e5BrzTijt/5buU6xBrCMTlW49ApG58arSSFHR4WHvjNlSG/Id3fFa2aT/
         2q5a836kr1Xv4tb+WEG2fQicnWOtkyFFrdF5i40K0/qzVA5vnCmcW9roIxJWkiI+R7A8
         4tS/ZBdE+r2F5FOGJPQTDgxtaXT7PR01eMq1b0WOWd7cHJle/dBelGXOM/TLwHidrOJc
         IBErZRficxcFDjGa+teggTdIyFc2dI1T4MjeQ1omB3xo7TVn3/5csIWlTe1MpgqqVePy
         kx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731859418; x=1732464218;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTPNbKfuLOHmM0adWhuoo97dgJ5/zWEwLgt8/SkSbcs=;
        b=Iu5mueAQfUX6hyD0c2va5Dlx6QhM9VpeAdV1dRLA3TbbwMxrT0sjlt3+wPPbmjbu/6
         NAoeE+LWXjdZpoGWfQhbLNMWsUoBWZhqPchdO78ZHOVZ7cmksfMAHgZZKHmLqKsTqR6p
         YEhUVlIJEfGZocTT7DY1GVlno6AKhl8gHc8FAD0ZXSD1CRWjI9TWQ8Lxu9kpVgxHrkx+
         ah1EHOfyh0ZeTADEHquw9cEkd6dbK+0LXyTY0vHpwXBxfd0SkK+C+tIfjWorBGykULc0
         fteymxYlm8q7h5e1CsGumb9q2dazLTXGaBvAshw5xbbW7I2OtIQ8YCmiCLbdIqF5F+FR
         GKZw==
X-Gm-Message-State: AOJu0Yx5hxhWG0bO8W+jRicjq/DeVX/u2osSKj0uzjNh8daPD6zbGRqG
	7Zn4Mhh49zWOpZQNfnB5C3+rQrkjGaK1DV7QL2kB7Bs9fj6NbcPjVWBplVZYhJwgY88YtAUzD+3
	0lks=
X-Google-Smtp-Source: AGHT+IGWXU9BT0+MehXxUtzZhZFD93f3VoHKCdoMykolWkND3IKNwDvUQFwq4dqgef6LGuqLVrvYvw==
X-Received: by 2002:a05:6a00:c82:b0:71e:67e7:1a4c with SMTP id d2e1a72fcca58-72476bb8a77mr11701436b3a.12.1731859418087;
        Sun, 17 Nov 2024 08:03:38 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7247711dffasm4584194b3a.75.2024.11.17.08.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2024 08:03:37 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/8] region test fixes + improvements
Message-Id: <173185941704.2591784.16734642089914845318.b4-ty@kernel.dk>
Date: Sun, 17 Nov 2024 09:03:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sat, 16 Nov 2024 21:27:40 +0000, Pavel Begunkov wrote:
> Some tests are effectively ignored because of bugs, fix it. While
> at it, improve it a bit and add tests for different region sizes.
> Not very improtant for now but it'll be once the kernel has huge
> page and other optimisations.
> 
> Pavel Begunkov (8):
>   test/reg-wait: fix test_regions
>   test/reg-wait: pass right timeout indexes
>   test/reg-wait: use queried page_size
>   test/reg-wait: skip when R_DISABLED is not supported
>   test/reg-wait: dedup regwait init
>   test/reg-wait: parameterise test_offsets
>   test/reg-wait: add registration helper
>   test/reg-wait: test various sized regions
> 
> [...]

Applied, thanks!

[1/8] test/reg-wait: fix test_regions
      commit: 2da94b9c3f16906e8b85c6a3bdbd842cedcba716
[2/8] test/reg-wait: pass right timeout indexes
      commit: 2a11ca289f26d8fb624534259f1fb75b94971e21
[3/8] test/reg-wait: use queried page_size
      commit: c4e792a8cb5836673d9654742cfb25d881958ba5
[4/8] test/reg-wait: skip when R_DISABLED is not supported
      commit: 4a1a872388defba685596709911ebc06530146a3
[5/8] test/reg-wait: dedup regwait init
      commit: 2f002f396e575f4ed2a8afbe2e10fea006773e00
[6/8] test/reg-wait: parameterise test_offsets
      commit: a2c742d8cb8ddd97348ed44f4cdd6f18f781aa8a
[7/8] test/reg-wait: add registration helper
      commit: 414c6a8f9c63d702f5c248d728693e027802b9af
[8/8] test/reg-wait: test various sized regions
      commit: f113218015556f41f3f06a6ffc07b194dfbf209c

Best regards,
-- 
Jens Axboe





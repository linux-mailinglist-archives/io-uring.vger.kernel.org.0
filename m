Return-Path: <io-uring+bounces-8424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7E0ADE9A8
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE5E3AC96C
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453BE28DB74;
	Wed, 18 Jun 2025 11:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TAzH4Brb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225C28C2B3
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750245130; cv=none; b=Tdou6yQNXiEDv3AVeCAaiVezv0d92AhrxELN4+2a0cD7WgSTXRWW3HRAf0x2ma74wGU60c8AWs0mFH5Vy0aOrFlOEq5ppCYH6SfpfJwSwj6DB/uWqEEnBjSMUDIFEt3xVV/ZekxkOdCanlBfgI5wgOVKv/ga9gxTZypQozazAHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750245130; c=relaxed/simple;
	bh=tvBZVbpFzdgWj/7ukLzP8VQVb98FCkFn5r2JIlMoCn4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qP0gjUtzbYxP6xTj6Pj5lo2S1Dy2K1eFxnQpykkDkx27GYmaEyl3FbmG4aRP1zIo/3SRMgeDniKlArJTRcVRn6JR5gDUUyL2YLCeqIw8zOTh2itCevy1fEyzD2d206B2pXXmcXXb6mrPhbC+ofALT0JhWWj+/FpTsua42+/jOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TAzH4Brb; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86a07a1acffso610666139f.0
        for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 04:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750245126; x=1750849926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRtJffEHvhJPO96jG3S/GnXcIBZq60zFE1OSNRuV8OI=;
        b=TAzH4BrbQOWXp3M5Joj4H7poSb92G0OwborMWczt9u4CnVy/FS806FgRZeOkkYcPTD
         mS9GS0HJoJ5JPX/HlAO9hRMZTkoYa8/YXie0uvZukFiRhl4htu8yxwhl9mN+EAjn5Q4Z
         c2Czq0bcPIUJJ+AYr+tv/FUU5XhQf+RUf/NUTQWRKCwFsZOzbeI5NzRTk+NwEAuzREWA
         P6G8wWxI13Q7OIE2slVa3zgJzTF7Wh6AuzX6m8hxvatQ64lt49m2XrjZT1DOCdvW1vDf
         vFvnZVrAgng8a+RYid0iqDfeI6zxIWbbtg8M1Ah4xhLBAm71dkYZTyp8HcJYKH6z5OIt
         TdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750245126; x=1750849926;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRtJffEHvhJPO96jG3S/GnXcIBZq60zFE1OSNRuV8OI=;
        b=GEsWQiOzmvPTPOaFmsIkkBS+8w4eKLNRUTBLzhgJOkzCBpE19qndDx0EWwXS2XuZYT
         ypqb5Wcbh9bWFJhlW4n0bVW0jjQYWBVJuVp8U0st74vx/uUBTOnIC8EsAViWKKA37W6Z
         aZW3n0GSzdkz3/zRjuAEDVzJ2lw/T2z0Jg8e8as7AO478dy0KvX+3E1wQTr2pTOkaLkR
         i2bO8ewcFSM+nLCMPq8aHwOysp8Ci6f5wYhWSKAqyLGTanLVd/APaSqOHzww33CusZoX
         5XDDxemAYTM3HRC8E2kV/XlBe1QAtRWdU94pcm3TW9N1TrGuJ2QIUP5sjdMdjFlMHaLd
         ZvjA==
X-Gm-Message-State: AOJu0Yz4oYUUSQ2egArBlzVF3qdd7vIXQ8i2i0biaNiM4mFsbnBrkq0V
	fQ2oqP94IBJNWPfxM9J16hNzj+rm9R6hPm2ugXCrlXeW4QI/MEsBTJ2pJJjlT8Wga4onecQdLBJ
	1b2JI
X-Gm-Gg: ASbGncv3jfTvrEwpg+GDFGoj0XMWw9bxJmDI4aYdNCRvz62ifL9oTa/bqwoymMLxzKc
	Ap8VBJWnWFEz9O9KE9wgJ6xgDM9J7l9XrsaRLsnu6jqHV95BsyNRCy7KJbroebMOZtrXxweBXsV
	y4BpoS/6oVDei1KwrFAuO6XLbAWagdvtEuW5NhJHqT1BeAQuycMel3h+LkTIuBqXZh2pwA8TEhL
	sAnV6nSQWreEnObZuAEjJ0vnPVqDZM8iENL9pbD804qGEqeoz1U/7KsPnbNreYgJDmbMmnbYMmf
	DYbjg2MTUUqJQnhQo1jzRGzAael8HPmENuBpCA864B+cpDsT4jTANME6XpDEhz6p
X-Google-Smtp-Source: AGHT+IFwjLmUQDTuH1qSFZ0XmxiGivDqXV70/Dw6xBeGhwzyFkDQp5Zpfj9W92w/KzLSvW/hYGjE0w==
X-Received: by 2002:a05:6602:1550:b0:873:bc5:dfda with SMTP id ca18e2360f4ac-875ded91199mr2243410239f.6.1750245126321;
        Wed, 18 Jun 2025 04:12:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d582dd75sm261124739f.35.2025.06.18.04.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:12:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250617165644.79165-1-superman.xpt@gmail.com>
References: <20250617165644.79165-1-superman.xpt@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix page leak in io_sqe_buffer_register()
Message-Id: <175024512538.1407393.13866658560955989017.b4-ty@kernel.dk>
Date: Wed, 18 Jun 2025 05:12:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Tue, 17 Jun 2025 09:56:44 -0700, Penglei Jiang wrote:
> Move unpin_user_pages() to unified error handling to fix the
> page leak issue.
> 
> 

Applied, thanks!

[1/1] io_uring: fix page leak in io_sqe_buffer_register()
      commit: e1c75831f682eef0f68b35723437146ed86070b1

Best regards,
-- 
Jens Axboe





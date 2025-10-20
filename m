Return-Path: <io-uring+bounces-10065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CE768BF2117
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C586A4EF11D
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 15:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFBD258CFF;
	Mon, 20 Oct 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="G2F/AEpS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE014B977
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760973776; cv=none; b=DzG3E3GLXvtOImxjBHQ/fW7wj/7xrRcG49E2EreOJCI3mwv0uovX6yap720nOEN/DEzicMl78PDf/PgUJFYarNNEN3NasTXD7YGx+PgEYXSwWLxnG95G317T7gzkAsJwbvgr3OAqgbCB2pkSYYoryLts6QhfPeCWCKbcCYHASHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760973776; c=relaxed/simple;
	bh=ODTE617mol+L2+MeQaIZe75wC10/6HIESwr+0dy1Jp4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=daUOAwC23DJyeHNxal/rCnxNzjwR9cjhUCicDUwbaRMb9F0Qrxnvrht1Du++jI+npctYHEBecsa9QxfIKdjTU+nKFTtdbNKVB39bGuXTlnPiGUjYGR1X5GzZHAe0V0OsRnnFXYIHIMjvvmjTJzNWDLTJk+N68rb12zrlmkNpLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=G2F/AEpS; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-430e1f19a1aso4624375ab.1
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 08:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760973772; x=1761578572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMlQSwmYkxDUW7fO1tZbtrfqwSMDSCCB1sEl91IVWPI=;
        b=G2F/AEpS77haxqfN7E5CA7b/jYSBv01zUibCfWn4X5waV+7gNfg6TTzXSSVMAm3C3O
         EEM9/VyhFIcr+h15IZbJxTZqzBXn9eSqKJgAtYvnmUexackwFjn35wrsuMCx554fpfvo
         Yyk3vVObLWalzC7dAaGYrjTHAhhuO5+obH15HiS7MmYA2Xq8OAyCOabOO8rOKraEQxdZ
         vfkZobGg5gVdtYlQGsAT5/xV3m7WaVOhRpCjxwWtry+EXJvPhw7hXhXAMvcR4Z5qiQIU
         WpdOzzluTDNE86SdUyn9sv3ItvbZbgocxf3D1Ggnb0QowSs2aHa/isNM4QnXqymt+hV6
         pqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760973772; x=1761578572;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMlQSwmYkxDUW7fO1tZbtrfqwSMDSCCB1sEl91IVWPI=;
        b=N7P5jmLHanTlzquu0LC+KmFUyzqTZTA02C0lQfqi5O/sIui3YCoKeY4NyOui9X9HtY
         +w7WwNLyFywIrGjyx2eXYbKiAITPMarxX/EvULqTaT/er1Ae6qCL1QgKCiIBoOX92UA5
         b3cZ3I0eVWpKa2Xg5j5FnC36VtyM6WL6YkkzN4dD924M+n2TYc7wZCb9Dv/40UhFpJEN
         4/JGp+9JFGlzny7JlP/BZdbe19AP5waOK4DshIUgIZV/hdNZirRUXIVjafFRktKZuwGE
         z8Qtp78R3kFGj9AmOLsQGM2Vr2FQO848daIXi5e4cZz2HYYZrSSTjkvOMRYzebfCtVlv
         HFmg==
X-Forwarded-Encrypted: i=1; AJvYcCULOiAKbief8TREBojH+PX0Xv1vHgC1IA5VzblCmy1gy31DejEflq/JPcIU1uGt3x8mOGHbdq0Z4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj55nHIoEAnXsHGIjLr/2NJOURF8vPUUiLjY5YrxPRPu7FWnGZ
	gW80+VwvZvRAK2jbHMJvd07DOP4ojd1GxgNBAiY2EbZypi/buUlhOt8xuYWeiYUQxHY=
X-Gm-Gg: ASbGncvlwSzhwWJksFJvUEk72ykLnf+JWjvbQ5sQtgJrrC80knj+o5ETNdwQxyyXXrQ
	57NtXcZ7xd0rmIJaPSVNfehWyljs0TwNBjqZJKsf75VMqek1hd3H0EfbIPlnT5pu897lXk/GEdf
	439WCOSMsL4iSxpzzGSGqWrFwnGeV479kLNpAKgdIUWV20XjEJUvGDX3qd91oHiR+2oOUUm4/q7
	gBxurJVerNh0JjG+PD6SzNqfvf/lmEjJr/rA4tDWX5Wzlk+f7uh1KcLjaL42RFXxNJwf2BOn604
	c8m5RK6H4qRJov+TlJpqr5DXn3s/EVSUmfIi3dXCWB2Iqzn5kOWZEPKaqk5QJe+uXM9azuxAobH
	IywUO/Hj90etMvSg+bkyhTd6pRZ22kKkn0+6wlk268Gdpu0EP3EGmYK15SvkJOf9BllY=
X-Google-Smtp-Source: AGHT+IEvTt7GWQlyQUwUBJ5OdF3T/ZOqnMoXiN2EjJBVwLnmZY38qIysjgdbxjs1Z+aEYbgl/Eimvw==
X-Received: by 2002:a05:6e02:1d9c:b0:430:ab1a:6708 with SMTP id e9e14a558f8ab-430b3ff77f2mr226835195ab.1.1760973772511;
        Mon, 20 Oct 2025 08:22:52 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e8661ec4csm304981039f.2.2025.10.20.08.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:22:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: csander@purestorage.com, io-uring@vger.kernel.org, 
 Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: alok.a.tiwarilinux@gmail.com
In-Reply-To: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
References: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
Subject: Re: [PATCH v2] io_uring: fix incorrect unlikely() usage in
 io_waitid_prep()
Message-Id: <176097377066.18128.4545746576618587852.b4-ty@kernel.dk>
Date: Mon, 20 Oct 2025 09:22:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Sat, 18 Oct 2025 12:32:54 -0700, Alok Tiwari wrote:
> The negation operator incorrectly places outside the unlikely() macro:
> 
>     if (!unlikely(iwa))
> 
> This inverted the compiler branch prediction hint, marking the NULL
> case as likely instead of unlikely. The intent is to indicate that
> allocation failures are rare, consistent with common kernel patterns.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
      commit: 4ec703ec0c384a2199808c4eb2e9037236285a8d

Best regards,
-- 
Jens Axboe





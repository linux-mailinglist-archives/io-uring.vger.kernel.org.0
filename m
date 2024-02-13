Return-Path: <io-uring+bounces-596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5F1852736
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 03:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500D11F25DB5
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 02:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB7D15A8;
	Tue, 13 Feb 2024 02:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1XVtFpr7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF228138C
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 02:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707789757; cv=none; b=N3vMorBfnrBTuv4hI9uFIRHLvN6zfTtUUHdD5lfB1efnaTfCvqcaHIDw66TexkD1fx4D/3OfX0PxMZVCeXKODISN7jO6LYhDOjDUfraKAu9QyuXNWew8lvtyVChS8793l+SP51t9xo49iCF/+t3z01XyTrbmDzgpbqaYiGeYz38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707789757; c=relaxed/simple;
	bh=j3ARRqAIkeyV86TmuaAM8stACZzYzDSPxu4DRWVN9cg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=r0rptH0vy7bnzJsB6tQvwz7APilMso0bI11Y+4dMiUMUi5OndABIO4lYK7c4T02iYX8JnL/phywqsspMbPJ8STPLCPqlcuqiJ2nzPHv4b6vcDEZ3us15fN19wnp4aY3xTfU891JnRqdV8SRB6t6tl14oR6+icYqbKh/PX4h2/qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1XVtFpr7; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d987a58baaso5055875ad.1
        for <io-uring@vger.kernel.org>; Mon, 12 Feb 2024 18:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707789752; x=1708394552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmC14N6nRv36D1LnPZ3pa9LkLIbeLRnRLpfPrrM3rhs=;
        b=1XVtFpr7i8Z9Iv/nQP6LdygWrObDi8r/wXvcN8YqD4W3Xh/IuIaiqdFaC+3NQMEq3d
         my3l6XQ5LvhHH83Tal+ufTgBarSlurYIcU8DZpTLfAyRe6+p2SXzwMfSJKtV/pi11Gpp
         KBLw2BmlztkLsLBRiaPq51qvdVOZJpjYon5e8UE1krNu4PHgfUPzc+oUwkgltVVxMbIz
         wlBHLeytgwrWk6Wu+36fszyy592vf97nyhH8wfSpQwaZqDsGaPd6fLchOxxn2JvKXMFK
         pDGEq3JV4POntDCUGG0vZHALddwdhZM5dC/ySVzwQeQU1R4O4Qs0TeOow/zBFT5Qg72o
         5AWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707789752; x=1708394552;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jmC14N6nRv36D1LnPZ3pa9LkLIbeLRnRLpfPrrM3rhs=;
        b=o5CixLpYRe3Gud7w6sGBlx0HSvuCXz9G7Wk4lEYIl38IvM1ilIRSD8UKGuiu0TCKL0
         9/lLn3TXdv0F0D5Fy35+iwzY1a6tg66MyJUYyulAdynUK/jJJ0I0Tmm0em6L/H15U2Ph
         U0NKE7tPQzWFyF1Bp0evs8/aNRpN0fzjyJ3Ec8mcVolUV/K9MOlC7gXdqRvQh24AY3AF
         ANocK7KyssjwXGKlpfvQgkEyLhLRdtYB4YjJRC+cvZ+dstdqQf3X4ewysikqLAAmlhwM
         mGzuLnDkkLWj8xJvcH/3b7RTVvA0ZgT0+TPFrb9fYwNFmcakwYq20NV4tHnQFNhuCEyv
         Ppyw==
X-Forwarded-Encrypted: i=1; AJvYcCWFkMc/YTBKUTVkG5N/p4Zy0wCtwruESYXH/qHfWWnCBDklVVsyULslHhcIH1ALlHg+GvC+meIagAc/HJgooJVIh+0pWRVlsk0=
X-Gm-Message-State: AOJu0YyW/V6isve/x1N797TnpfFwToOsoNzlDEVeZQ6Y3rRFrUMy9Yh2
	DrxTelpty3R1E99g/NBo2vnBy3JhU4yDMDsQO1goBWrVg5jb/pJSb/OCpbudVsudMdYRE24m9IG
	d
X-Google-Smtp-Source: AGHT+IFH2IqwG83Eza860nrKjxvKctWSTGw/eINns6Y1b2dBM9R7BXXh6db2vnDWzwTonplpzvRSzg==
X-Received: by 2002:a17:902:fe18:b0:1da:2a1f:5f55 with SMTP id g24-20020a170902fe1800b001da2a1f5f55mr6114065plj.4.1707789752419;
        Mon, 12 Feb 2024 18:02:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVcCaDsWmLeQjoGEdxES1dQt9EUKSfoibKTlaYw5vYfbPj6gUkZYZ8aPCFIueIBdvnTuY2WKpaMzpcbC2eKHrA9viZye5yNsMJRiuGhVqJsLjsB1W38FPIFN9PE
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id mn16-20020a1709030a5000b001d9ba3b2b33sm967427plb.163.2024.02.12.18.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 18:02:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <20240212234236.63714-1-kuniyu@amazon.com>
References: <20240212234236.63714-1-kuniyu@amazon.com>
Subject: Re: [PATCH v1] io_uring: Don't include af_unix.h.
Message-Id: <170778975137.2228599.2845417029143556621.b4-ty@kernel.dk>
Date: Mon, 12 Feb 2024 19:02:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 12 Feb 2024 15:42:36 -0800, Kuniyuki Iwashima wrote:
> Changes to AF_UNIX trigger rebuild of io_uring, but io_uring does
> not use AF_UNIX anymore.
> 
> Let's not include af_unix.h and instead include necessary headers.
> 
> 

Applied, thanks!

[1/1] io_uring: Don't include af_unix.h.
      commit: 3fb1764c6b57808ddab7fe7c242fa04c2479ef0a

Best regards,
-- 
Jens Axboe





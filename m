Return-Path: <io-uring+bounces-9845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D42BB899AC
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 15:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55CFD1C88593
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D16930DECE;
	Fri, 19 Sep 2025 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iNGQ47/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A6430AD18
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287226; cv=none; b=Dyplhc3PfIESCNTT+V9geU+YyG7p9YCf7SAhlDxWOiKufPEZmPdJFeIwbFjoh+Ebh4Wjh3mWQTJPiB+7SUUtJLUxRzGmAuJGciNthe4bhKavAkwbl9fT/kn/l0c5cBrJpKah26m+BttZ74QI4rGgLzfnAflCob8Ex4o2KOIZh/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287226; c=relaxed/simple;
	bh=BvozPfOu9cgVo3+z3oCLPmeDOWuZuMDmzhJ1aSO9F3g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=N6smed+AcG4vvm1lGyskgLkmEpcfYWlzF61g9qB0gQamBmjLaIPMGJgl6rFZTN1suP0c9dIA6jPQQop6bP//LM8DJQiSJT4FBwL4U98GkhSJTAB+SvK6KI2pMbVpYhKiNatPSk4ueUtLkJqyQ2LWP67dPr4S/4eMPAPZEL+lLjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iNGQ47/d; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-889b846c314so58144539f.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 06:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758287220; x=1758892020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6HNw9Ox+BfzVSqqzs28XGIZuqAsiis51k0WUWcPo0g=;
        b=iNGQ47/dsqu5GOqlfbxHJx2XYMAIX3ccJ+i14RfU/QHcMKn7874Dv7iDM8/YpIZqbh
         tIE4lzzf67kpfKHBBfv8KlrcrIDN3AmmHTEo4UMwyCmMwkIqmssAQsi0hCzq6Z+lGvKW
         D9N8S+FXMoxnlXViXb9J24ebBMqgHiQFVgL/brF2Q/phE3dPMgjddM44wBLsV97AopWc
         BvMqY35ta9M0Y7Nvf5MxRrSaetev+UZkgRE4Qlt1/xPT0Iiv+wRJp8OBOzDXUL1jw4md
         RnrIYNF4FNd2hsldEB2iMqBCxJ02/MUn+/Hj9pybNeqrwGnz003Qi1Bs+I0SiMp/FzrY
         giTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287220; x=1758892020;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6HNw9Ox+BfzVSqqzs28XGIZuqAsiis51k0WUWcPo0g=;
        b=ey3bbPcZ9LEJlYShOpucGTlOh4olvvDKTzcyAxbqdvKqg0ekxyldtmRpGmcO7/9Ph1
         GZZ65Y9LtG1/NJwYB7WR/KsMgDD5exyMxD2ZWTbMgBXxk/6yWCeKzE7JZeW40YppRdu7
         f/QN8qiFyLrNEnMe/MDhKtF+19ORgJteMUOUhvmSRxn3b2DmTqezxryJf9kPTjvRxOtx
         5gTtGoyar+f4Yiw4Gtlw92JD3OLKaDpx2WSlCKNvg0k/B2uGcLNqTu2BOEPw4yVkAGLi
         h/Fnu10F9tTGOX7GX8Mt3GPWWaqu9W78TDy8c3FhoHjXE7E2jUaBrTKfXinCofNYSliM
         wkkA==
X-Gm-Message-State: AOJu0YxBhugIaAPtRy4COW6q4xb9CnxQtsjKuTCOmlhX5tbqKae3vQ6w
	NotxPEr4TKIYR+xUqqM4v9xZrvLII6p4ikPL4XVsY5JeHsgopWO/3X8fhBD/MPaMMn8XKHL4T8z
	SB4tjtgI=
X-Gm-Gg: ASbGncvphprk67kRjPlO7l8ja3Z/h2qsk2QeXebd7x9DpeCW4O4KvEi+ujcslfw/dVc
	CnT52f7BJpDUHikFCnWCeYBg8AW+n2/Cvo1mQMaqAlgaPXWWyzk1EsiuT4ieC55jd5GDEGtyyf/
	LhhOBBsI0V2ldHvGpwiJXerPWjjn1bHwqC/DjH5/V2ZtlSnPcwgGwAwPu6xWCDwUwRk0Bq4p2wq
	XQBhjN6kXNo4V3R2lqZMcUQYKHhcUOTwp9qaKLqucOPzDTIWf0l2PBXg6J1pvRFCYdjI1bbSC9z
	bKes3fxNdoWBHt7av8iWbCGaXYk3qal+yEg6EYRrkAuAznJKY0+mesic00vuwu4IuBooSCwbucX
	Z3H4Y6Lir5XGUPg==
X-Google-Smtp-Source: AGHT+IHUR5dtE+wDDyAW9o7MEnpXItQqVJao4gxgHJzoa5wzQFtBqvABSptIbbVGXLj0CqPWjOlZ4A==
X-Received: by 2002:a05:6e02:2481:b0:424:8535:6521 with SMTP id e9e14a558f8ab-4248535660bmr25958025ab.25.1758287219729;
        Fri, 19 Sep 2025 06:06:59 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244a682a59sm21582855ab.16.2025.09.19.06.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 06:06:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei2025@163.com>
Cc: io-uring@vger.kernel.org, Yang Xiuwei <yangxiuwei@kylinos.cn>
In-Reply-To: <20250919090352.2725950-1-yangxiuwei2025@163.com>
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in
 io_link_skb
Message-Id: <175828721919.844104.4953119127361592887.b4-ty@kernel.dk>
Date: Fri, 19 Sep 2025 07:06:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 19 Sep 2025 17:03:52 +0800, Yang Xiuwei wrote:
> In io_link_skb function, there is a bug where prev_notif is incorrectly
> assigned using 'nd' instead of 'prev_nd'. This causes the context
> validation check to compare the current notification with itself instead
> of comparing it with the previous notification.
> 
> Fix by using the correct prev_nd parameter when obtaining prev_notif.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix incorrect io_kiocb reference in io_link_skb
      commit: 2c139a47eff8de24e3350dadb4c9d5e3426db826

Best regards,
-- 
Jens Axboe





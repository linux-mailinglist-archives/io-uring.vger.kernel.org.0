Return-Path: <io-uring+bounces-2556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F17C193AA2E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 02:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C0451F23763
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 00:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCFB23A9;
	Wed, 24 Jul 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GU/GWTdg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8723BF
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721780565; cv=none; b=VT8NLRclJbZATcMUQnu2xly2x7naE6YkqA7uyWwNl+hQhE/d9Oi2KVZg3GEbKrpskW2wlcPDFYJ/kWchFgl85GAVJSq/RimGs5P5GAkfNya38wKfS/YSFi7qMQ9FCAXFK/WgYK9T4mhdh0i6ESOOYts+/sbZPQOW0eeKCG6zJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721780565; c=relaxed/simple;
	bh=h2TrIyXWwxmYKFhzvvcgt41EBjN4YChDvoK3pGDgJLQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZI3W3XRgYWXGNtDwwrvvBGew7TbIfVT/XK5fzdNM16KitlOOCMXhh6qFx8SQzBTL0OoILMxCJQA1rj+Sqcpgk6IPyhKXKIy1thVA35IzihyvhlN02kj3AJBUgu7jPHYVAatxl3pNK6E3B8Y1J+w88nYne3xOGATze++u72NQxyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GU/GWTdg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fc4b03fca0so605455ad.3
        for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 17:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721780562; x=1722385362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1p23p+TxCkjoOTLUjLKEKWo0Yc87OVU88MRHkjXpU4=;
        b=GU/GWTdgS2AvhtKkoXBu5hX7pASF+o3HGnZF41I9T3lRdgCciimioL62/ZPwUbMaL1
         Q2EWVwBRxIYNmxirLoQ9BrDKHfT79LfN/EVY6BDlUm/J4GER1XMw1OzMfInMTa1q6E+G
         HoMmJsHHoZr7vJMQ/X8gmeyc0gnJWRJDXIadPHxqUAWmn9YkKUKcC9wd//NO5K0d8izu
         2AUFJzCpUdYBiL3o+qc+bIzfbrwfhG/tVI/An4vmKoRndf84bRdL575HD+kneIPOHpai
         vxlo5UG3+uUB4ZnexR48o+0EAfdxa2xGh586Ha2k3v7P+AsE9e8RN7KwUJeB2OKyCUS8
         7pXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721780562; x=1722385362;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1p23p+TxCkjoOTLUjLKEKWo0Yc87OVU88MRHkjXpU4=;
        b=pdRgV4osoSuSm65bn4NMdMPnozfVU9Ae5Mn56+WZh1JR1TKGaFv7SVlN32/9XBSPFl
         nTi35Gc6+TW/SjQ0oPgvR+cYTi0IBRbkK1iZjPwR+Xql3DWCOSoGM6HjsF3pp3+fLU6a
         pCsM8KUPfIG1et2boXsbV5ZPvrEWz0KXjFXQgbVkUDKnH+OoH21H11AvHDSC1NFpreBx
         M6f+xCziZE5Qpx8UvpMa59I2XaRxflQxMpqw88X3vQeEW0mkO6ee9WLAkk7tmVfGo+kc
         fiAAPjc++L7TMcIXNY4QRSDCPz/50qoQAKlTaGExR+H/Thj/fHYK0a6COP+x+BPxRRGA
         mWTQ==
X-Gm-Message-State: AOJu0Yzg7zwz/dUOFUbX0yS1asy7q3e7yf6HSIFvR94A/6QJfnfIPQYp
	mxYr0j7oMQtMdX6jCr8ACHxOwTfsHe8MkP8hduHTNHRm7gXI67u0Nk7bBjR37O+94lTmYXczxad
	aDsA=
X-Google-Smtp-Source: AGHT+IHVH18ArL7ZTH1dOP2+WhNayqp5Ie15wt0EWCPByz0/4mLWXGo4yiUN7abWEphlk9MCKFP6pw==
X-Received: by 2002:a17:902:f7c1:b0:1fc:72f5:43b8 with SMTP id d9443c01a7336-1fd745faef6mr95122395ad.7.1721780561715;
        Tue, 23 Jul 2024 17:22:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f470686sm81320785ad.264.2024.07.23.17.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 17:22:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240723232026.1444-1-krisman@suse.de>
References: <20240723232026.1444-1-krisman@suse.de>
Subject: Re: [PATCH liburing] configure: Respect relative prefix path
Message-Id: <172178056033.217902.10692198590897995962.b4-ty@kernel.dk>
Date: Tue, 23 Jul 2024 18:22:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 23 Jul 2024 19:20:26 -0400, Gabriel Krisman Bertazi wrote:
> When the user passes a relative path, we end up splitting the
> installation in multiple directories because it is relative to $CWD,
> which changes when we recurse into subdirectories.
> 
> A common idiom I use is:
> 
>   ./configure --prefix=install ; make ; make install
> 
> [...]

Applied, thanks!

[1/1] configure: Respect relative prefix path
      commit: 476a6a9e92f390b16d12a3d66c046d456b5783e3

Best regards,
-- 
Jens Axboe





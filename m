Return-Path: <io-uring+bounces-8744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 296E7B0B7AC
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 20:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E3111781F9
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E32121C9E8;
	Sun, 20 Jul 2025 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a3bHi0dk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DAF1459FA
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753036421; cv=none; b=OtnkeUHCC1LaTO4Xnhh4rHe9a/e50/G33Ncr1rWaiCHnyGRDxb3OE/yVs/RhYU4ZO9zopE1OWOLcynZvQWB2AbzLicoK/CDd5n2Y7WF3fQHC2asFk+dz8G7770eWZI7fHqRRvEWc09/SJ+p5jK3vLpzP4Cpa9LAqA7DwX4AvhWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753036421; c=relaxed/simple;
	bh=PqJuB6BTnlUL05uv8nlQVPJ/J+B6nFinOKNvYsNcWoY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=j0/GOItscmnAYcUKuFnWr2qo4WxNlkIe7ACGi1ceeZk0TB2Bz2a5oIeksN68oDZxN0ACC2/jbPFYnZdVUZ7SJFo0X/7wqCh8Yh6BhsfwRaR5LLjcjiAZoVCIviyuzhb29cApQ7DSTVYqRVBVMZpq0PxLWwu/gBtafEVWt7rBbFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a3bHi0dk; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23602481460so34734635ad.0
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 11:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753036418; x=1753641218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0AjEJVnMbl4XQ0rLjJcaPI92XEnzLpKwxDrSH3dYbk=;
        b=a3bHi0dk7z9FbvcZh2xMIPvB5T9Jow0Nb/eorlAo3ZlQl752oeKVLuRHb6DSEQVPTc
         Q3VTXCJi5w+ZoHh8BumdegQ0PYQF35sMTVGTrV5uH5lvB7nmLpYwWK3YnTVpCT6zMCj0
         +KCZ8KWcRjpKEiMCDViM7uaw2N3xPHKUk0S5JXY4+3Vkmt298NlC9wKpgr+oOjQ9cE6C
         hfxjZ717d1by8YtZerepkZL3Btmkl8ez6ialsh9L/0CnbxndMwLzAPxtOmdozLlKue3e
         idzfB84Adx+OIUXTe9vUXjmgXO4jUkipayb1886ZcF+Ltb3Mj7fSvwAGZxoRH1JLZng0
         wpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753036418; x=1753641218;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0AjEJVnMbl4XQ0rLjJcaPI92XEnzLpKwxDrSH3dYbk=;
        b=ScVX7/vxjC80kRzRL8EuBJ/w4UzNJCyznhqpFwcBDXpaL/xikJ1vA9RltdOvdLYsck
         Oz0VcXHmPP5t8gg9K4oWvJf3nMgNmXQaZEPqCAuj0XOUi2bFinoMkOilrrBPumrXho3W
         g2cxi9vXgO6uNqhE9aiLAt2mb9UxfLzxapncyfmiakTc0lGLfgQB+pZ6aB50DxsL7An9
         KQUl0ZMELgshYSh2oyZDQeTMw/OEyvvNHScEwpeJWNai5kie1SqDQRGTVQYEKsaiBRHj
         CUC6wPpbCGTx0a0MgNEY1+KVVE95/6s2w53sAoTuzN+I6whTviE9O5uK2HDdqss/0CdA
         wIXg==
X-Forwarded-Encrypted: i=1; AJvYcCUN5ggvVxge7CEi7fonpx7IlYkcKsS2EulzTrojPJxxpgEQjd2tjhmeX88hR8B8qK5zk9whop31wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2Zx05jBkZuOZEpL7CT7EzuMnXW7CLbCo0vaKKMTlqgORW3sRa
	5sbSYtViTgfYw+9+bJHGrRAWdk7zLhCBUTfkcCNUq8p5oziyUW3Xj7V23odjlshhdnA=
X-Gm-Gg: ASbGncvhaUx+6z2UFEqsK8Ici4U9R2TyJ2n0ZrzloXgfNrQW0vojigaLdVCgMydPw+3
	5VlxLHkmu8raTH/mCAaYShVk4cFWRf7GyAt3nmjtb+kqdIwKhYjnLnVk9+mkbfQMXvDnCSyc1We
	lf1pNyhtFjF1u+sY20I7sNe1FxrrJtbPfUsEjwpCw09bM8y1QiRdY7f166YFQr8tdJexrQ1az70
	xyfTaLFC6o0D7xF0CMGtsOBeqYWDv0LlUUfBpG1yDvVfXpsvObkxT/e9kKMr3r2noxVELlc8dEN
	Cp6dMXhkq2TbPKsvVSX1xWJ+4Lb689hkZYyekCAf2U/F/ohBJfaisRsiS+daDYVwijUd/38wFM+
	u0Ku902B0K68Qoq+B
X-Google-Smtp-Source: AGHT+IGQfg5BtWVOsg/XbnN9HxpcleMGwWsuvZ8KzthORtKDs0VSV7ilzMvJ1+Jl8WSVxY65b3tdxQ==
X-Received: by 2002:a17:903:2290:b0:234:a139:1210 with SMTP id d9443c01a7336-23e250012ccmr288632585ad.53.1753036417891;
        Sun, 20 Jul 2025 11:33:37 -0700 (PDT)
Received: from [127.0.0.1] ([12.129.159.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4e79sm44205515ad.105.2025.07.20.11.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 11:33:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, io-uring@vger.kernel.org
In-Reply-To: <20250720010456.2945344-1-rdunlap@infradead.org>
References: <20250720010456.2945344-1-rdunlap@infradead.org>
Subject: Re: [PATCH] io_uring: fix breakage in EXPERT menu
Message-Id: <175303641666.493216.2544644366989579120.b4-ty@kernel.dk>
Date: Sun, 20 Jul 2025 12:33:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sat, 19 Jul 2025 18:04:56 -0700, Randy Dunlap wrote:
> Add a dependency for IO_URING for the GCOV_PROFILE_URING symbol.
> 
> Without this patch the EXPERT config menu ends with
> "Enable IO uring support" and the menu prompts for
> GCOV_PROFILE_URING and IO_URING_MOCK_FILE are not subordinate to it.
> This causes all of the EXPERT Kconfig options that follow
> GCOV_PROFILE_URING to be display in the "upper" menu (General setup),
> just following the EXPERT menu.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix breakage in EXPERT menu
      commit: d1fbe1ebf4a12cabd7945335d5e47718cb2bef99

Best regards,
-- 
Jens Axboe





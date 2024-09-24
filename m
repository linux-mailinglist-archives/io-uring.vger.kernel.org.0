Return-Path: <io-uring+bounces-3286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8AE9844E7
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 13:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E7181C229F2
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35FD1A727F;
	Tue, 24 Sep 2024 11:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mM3hg5r2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7FA1A704D
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177741; cv=none; b=XwcDhetKsuBYIWDJwmQmWcVgSRtRaWgzILkjwOEeMURbZu+KlqHUJwPGjeLfcbZM+rmkro4YPFc6OND/r6QBhqhRvJg0lU96YbW0F8k7DsYzkOKdsKKbZL3RQFWje7ZJhAQaY6MV7XULVQT1HijwxXWrRrtazV8ui9x57mFGqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177741; c=relaxed/simple;
	bh=x/u1koTvDCmqCThGPPy59+E4Zy/cnzm9qG2d855Hew4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hV66fOWS8Kn5KQl2mzfGHOerAk1TI590UiEypCPKhR9ZbzIJv7orjW4CfiK0go3QrvXJK4ZdEOD+5zZv1t39DOeE7GbPSHKHXeFhrCDr+xvW1fAgI9ry3Tc1W3iMIZmGSvpHhoB4m62fUQmqpbF+nvBBLdJfgQX8snrlaYSdu9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mM3hg5r2; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6d9f65f9e3eso46312887b3.3
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727177738; x=1727782538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9DP3Lm5+ROAG/jDrE9OpwrxcYIAGIlPA1Z5y5IHY7g=;
        b=mM3hg5r2tgwHdKJuE24/5MMo6bp2wsV5oKbZe57HDXpinwPPtATMVna+MPnd7YdSEN
         /eGCn9uMC0Ga7bUDmhuKH+jVYNp7DyVya7WGgfYvvorSdYk1XskVCiqU0BkyAArgWFUT
         eCACTpo4oVjM4hOpOI/GPiUpDocE1zP5zYmrEzeOSaaGLV/NUoGUG6cI91jU7lVIVQDk
         wW7hc+ExuQGZYpoF6J+4ZlQxbHKuQA5idvuFof+siZ+jvN6wNTWheXGMo4kErr5svwrS
         qVCURy5N+GYbQogdxqRGa7T3sK5FPUtEeZq6T+ZzBGeHN2ibWA7JoDO8ArsLLKfiAiqZ
         upAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727177738; x=1727782538;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9DP3Lm5+ROAG/jDrE9OpwrxcYIAGIlPA1Z5y5IHY7g=;
        b=j829ks4od4M8n1C0nyfNzSiPXiIhqKRaRFF/6IWCn+EfxdDmgsKfVal1uc98o+7fKl
         DmceSi0iNh6hveR3ysvwOI2VO3byHPERJrpK2WptZjKFSZeqHct1lUPtHYDsdv1AfZMY
         d1osJXdcFR1EDzUr/bgtchW8GpgRIvnKrtZrNxqtwkIaTDJSgMFISvsDAYeuA52V0q0w
         bpDciNXPuG5NEsv9VpsnkK8gz2iOU73ZrSnfrd3FGH/HvWYZpGCDg9OwFzo16Qd6l2LA
         VH2YKCOwLeIc37/JeIvTRZEVu3yln6G6SyVoRSxXcVcwoyiSJRkk0CbaSIC+27QamiK5
         Etmw==
X-Gm-Message-State: AOJu0YyQSeV5rRYZsWSkdgQJftWV5KRs6IY6/DTAmGOjRew/9Ar+J1dR
	8X8+dCxSy+p4yTYRhyOVr+7KgCs8mhqgU8lCzN+2fkaRPz7sMbd8Nqdx9s3BcX0=
X-Google-Smtp-Source: AGHT+IG5v/WDo0X228QOoEmf9XlGtrph2Vebs5aFKzaxpljA5Saz3tLvVyTDbM05eyOURW1/FQKsPA==
X-Received: by 2002:a05:690c:b:b0:6ae:486c:59f with SMTP id 00721157ae682-6dfeeec5994mr113669047b3.29.1727177738118;
        Tue, 24 Sep 2024 04:35:38 -0700 (PDT)
Received: from [127.0.0.1] ([2600:381:1d13:f852:a731:c08e:e897:179a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e20d15b40bsm2085807b3.81.2024.09.24.04.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 04:35:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Min-Hua Chen <minhuadotchen@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240922104132.157055-1-minhuadotchen@gmail.com>
References: <20240922104132.157055-1-minhuadotchen@gmail.com>
Subject: Re: [PATCH] io_uring: fix casts to io_req_flags_t
Message-Id: <172717773603.81807.5961891557675583068.b4-ty@kernel.dk>
Date: Tue, 24 Sep 2024 05:35:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Sun, 22 Sep 2024 18:41:29 +0800, Min-Hua Chen wrote:
> Apply __force cast to restricted io_req_flags_t type to fix
> the following sparse warning:
> 
> io_uring/io_uring.c:2026:23: sparse: warning: cast to restricted io_req_flags_t
> 
> No functional changes intended.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix casts to io_req_flags_t
      commit: 5dc4669c80354d3d7fdf87ac853bd1246928f2b7

Best regards,
-- 
Jens Axboe





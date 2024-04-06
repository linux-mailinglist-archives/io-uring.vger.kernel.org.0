Return-Path: <io-uring+bounces-1422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7D189A865
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 04:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8651F21723
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EAFF4FB;
	Sat,  6 Apr 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oYD38c4l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570412F2C
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 02:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712369565; cv=none; b=Yc14A5AZirxEokwPv0rAljcp+SrxBMErgF7d2b5kifRSXv2BR1dAVpRmC2ZXA60yqJUt3esNtIhnXvVn5ct668rvXzH6qqKRt7WJ+jLG6PgHkfLrA+oQnuUoX7JtyThGwetfteeK7LsZiHVE3sg1VBfMxRBWXQ9b0dUnCBaZZQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712369565; c=relaxed/simple;
	bh=Hv+ZBTrR3b3jkctkmpEa8+8yLhCzvjhNaQB9KIptYrQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R4wMZTOviMzTVqJ6c93lI5Axu7DJH5L0Hei2mZcmTfkhmxrL4tU73pqFTHxjIRCvvGYD7h2H2xkgtpt6eJqw5rgH9UrfJHeHEO+0caiJ3KOkjeuP8upQseI19k7bp2RsUUH7u8aKlCix/6vPHHMgMrCz7JmnMgNVEsGZxO4KVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oYD38c4l; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36a125869ddso1371445ab.0
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 19:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712369563; x=1712974363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FyD4q6ixCjwj5yOJADA3wN1ffmgZlPVMA5sI5Y9IuE=;
        b=oYD38c4lEawTgw3ww//itUcgJVLKm9Cvs1dHwh7hQHAI0zxv9GDU3xUEkyiosslBP+
         XRUdH3oljJ88ZFd7xhpwxPXoNaxPrh+GImrwK4lmJUaVwHHmWQNQEoWNNGJbe47yo4da
         qUcFVpq0DELCJsebw0ymea6cqvkpoVtFkTJpUa57DiIOD/TEwk51QMYb2UTzFiBs7xlH
         QzCb4lY7XibyQPbCb6g/RdFRJo9Z3HLJGLqRrWKUvlOQixzNIxIWi5umw8bIJD925Khx
         hvwk0diEcRl3GN3nrLeOCqV5OttrZL6PAwfBfAlU142aTbktyDnROkXeG7t9TE/UyJ4m
         e3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712369563; x=1712974363;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FyD4q6ixCjwj5yOJADA3wN1ffmgZlPVMA5sI5Y9IuE=;
        b=xLT/gNqKYReZkyM6ps9ag4KltA1crzNy9shOVeo7oI0/dDViwccxugiq7LZAvIODOQ
         aA/iyIhlFEB2iLNaokYu9tmOY41o7SzNHN6kWs92FIOwvoI+KJup4n2oMus/ta16hBqU
         ZLH/nNeiPXKKzXdRRktIyzmV0+yIWXFAJpIgxhdbfvMjb6pdWegVihuWSdFfmz3J23l0
         nGkq2XSTb31JwzoQIp9w8IskUWuOsKniOeR5JWZTv1KUyDoTo7v8QL8NQhu9+LJZnGEj
         UTQqbNUnNRVUARTcKz810IRIK2i8eNKpMEFUWbL8FGKQCQ1oTNt6sAyRYYXzK/oPkLUH
         OHeA==
X-Gm-Message-State: AOJu0YyZGpwB1GZHVQmwuLBJH0GNi7c5aIhqGvMFcTokarvEd0/7mzv+
	aeLgQjLG7BQ+x1kOuZfDmeJRvCTM6JKkKT9KS4JIBoxLdbGdyu2jiYHepqEj0RCP8TkIsN4QE5z
	T
X-Google-Smtp-Source: AGHT+IHmZIAFq+z1zbUKP2CHuhmFjIrtTSEr+6GlmysPir0FD68YNc7fo2suHV9404ai4EW5LKUyUQ==
X-Received: by 2002:a6b:760a:0:b0:7d3:5401:e4c with SMTP id g10-20020a6b760a000000b007d354010e4cmr2970405iom.1.1712369563596;
        Fri, 05 Apr 2024 19:12:43 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.135.167])
        by smtp.gmail.com with ESMTPSA id x3-20020a5e8f43000000b007d337022288sm810032iop.44.2024.04.05.19.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 19:12:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240403164413.16398-1-krisman@suse.de>
References: <20240403164413.16398-1-krisman@suse.de>
Subject: Re: [PATCH liburing 0/2] manpage improvements
Message-Id: <171236955955.2455605.6666388976952164773.b4-ty@kernel.dk>
Date: Fri, 05 Apr 2024 20:12:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 03 Apr 2024 12:44:11 -0400, Gabriel Krisman Bertazi wrote:
> Just sweeping through github issues.
> 
> Gabriel Krisman Bertazi (2):
>   man/io_uring_enter.2:  Move poll update behavior to poll remove
>   man/io_uring_setup.2: Improve IORING_SETUP_REGISTERED_FD_ONLY
>     documentation
> 
> [...]

Applied, thanks!

[1/2] man/io_uring_enter.2: Move poll update behavior to poll remove
      commit: 501c78df8e76f3f6350207a2a1c89814bba4eb2d
[2/2] man/io_uring_setup.2: Improve IORING_SETUP_REGISTERED_FD_ONLY documentation
      commit: e4cfc721761a85ea6a257c77572546292d04bf79

Best regards,
-- 
Jens Axboe





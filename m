Return-Path: <io-uring+bounces-9170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A52CB30032
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84D9DAA7BD3
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0272429BD85;
	Thu, 21 Aug 2025 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZQA8Sm3v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BB23E359
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755793998; cv=none; b=T2OrSWlGrUsIEqOlVxChTfMPdZ9CblHkYsOecFHCWITeRK0fbgFXaBcQaGVm1U0GvFYhMLEiuJyD+chY/1NXGLc2+nzzyWD6mp5GPwJSF9hCM79MuOslXX2gYCsCrbIlLhNaZokc/xGMfizA6XdqX1jIZ4ZyAPmXCkfCTKC+kN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755793998; c=relaxed/simple;
	bh=fP9Tf50egQ+GCeQL9pqjM5xX0fUlDUI8thZE6mXoCIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=af9fuy6X2ZDqE3J5MXgjucV87X/QGqaVSBAKuQZoYD7xqY7uWMl2d4zI+e0r5fmTtysKGKKek9XPLfPjF8TCKEepVys93P8h/9m1wG1kmhkyul2OahqL4GT4cFnlNcz6OSVXU+TBu1ero13ZTynMLyHH2lCBcoMxkQEjV0u0fjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZQA8Sm3v; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-b4717384710so176463a12.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755793997; x=1756398797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aOOGMC2t0+wH/ll8Pw0xRdkh2dADqs4rhHMRAhaKoZg=;
        b=ZQA8Sm3v1G5sppBJqkERswlY7ZqUcQuFWNSASPN3gmoWnKyQIQHE86ItOLP+Faziz4
         avw+fQlVUem+lR5FxnNHmQHEn0yuINgm3FDEkryEu3d6AzgEE/O1Br3eRfWCbLftK5AT
         THoflrlUgnxRa4H9RCnza0jj9ibnpGdefw9PpGSyCA/Nzbnzd1fB8eyjysHkJlCM+yUx
         i9F3xjB6sa5tjD2pxGR4KMiIA79EnSykoWnS+hJ2pbaccSg+c4DnjA+Bl8E5L+Y1afBO
         8hLseYCYhhohoEkXA4ZieKpJ5KRkhypQ2NPhYPR5lqnvkKXyjiVil4uUQKfPFnZnxZgC
         De1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793997; x=1756398797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOOGMC2t0+wH/ll8Pw0xRdkh2dADqs4rhHMRAhaKoZg=;
        b=rV56vyuMGahzMSSIY3zvmTOFgimmSF6/9BHNnVNtuOW+T0gkvL9/9iX6lT0GamgTJs
         sEzokY8Nc3jYXq9AsEedc7k9LB/b8+ryBA7hsF/FYw68ApIXeDTUaZZob3eDrLsMY/+P
         T8cls6e2jFO6e2AqFHz2jPvzynjkzmKyAjP6YSdNPxfmprg6sl3fM8UF2nKU59I/j51t
         sf7C5v8s9W3hI9MEv3YSusu9c9UeutIY/F02HYRhGVEhMpntTguBNPhI81rfr53COahQ
         SpfGKV9Yl1aw9R5zpACKgHBsvlCzCgMsgoI0F7WxEOz6/H4kqx3N/oAyv4T1groJ79Dp
         UTDw==
X-Gm-Message-State: AOJu0Yy2RMWC3kjeHLxVTwAuA0XrultbGjp0vVZiRwwHgRZxp4LQU0an
	wavn4/Xm6sG8ffHNLn8iXUgjDi/wub0W+f6YeEJVi0ljVLzOat4BmonyWxMrsyolFiU9UhmRNb+
	4W6qLS6po/rulcmBkFoFnF0maqrOTVCxqs6oq
X-Gm-Gg: ASbGncstwxbzq+XlQTDjfdwnuNB+IcGhK/Z7xPUw/CeUyIJTlP93w6dJYgB0FLWV4Jg
	Qv/5M7dNZ72KfIfP3/P4M8tO/MhyZ+427Oy0JiVvVHAPnEj95U2zL9h6cchEvcutfYNTS4KYerM
	b2Z6BZ624tKSfIqpNto6im4tkqZmetVdE+JRZhxn4SU2pMS3uKW5QLu6KWwYSdHviPwmjYYC6rW
	O9F9lc3xaeCVvr43LbY/HIjGvqqcDeM+v13+S99TjcXqbwBvwsI+zmL1UCC0Gl8KNM23TYacXon
	agiOe8ncXMzHgxFgLKqNAXUN3Fw5NMlTdtzqtP54Gl8G2hxIyk69NLqiy33EIUJ3jhQ2jiqr
X-Google-Smtp-Source: AGHT+IFMh4tpcaKAORljnkhBk/hCcNgXht0XY2JfbWaZD8zMFA7gE9QAZUEQjUMm5/9AKpppZwMdYrX6owEq
X-Received: by 2002:a17:90b:164a:b0:324:ea97:21b1 with SMTP id 98e67ed59e1d1-32515ef2cf1mr74383a91.2.1755793996567;
        Thu, 21 Aug 2025 09:33:16 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-32514e5c003sm16954a91.4.2025.08.21.09.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:33:16 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F402634040C;
	Thu, 21 Aug 2025 10:33:15 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id ED21CE41D60; Thu, 21 Aug 2025 10:33:15 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/3] IORING_URING_CMD_MULTISHOT fixups
Date: Thu, 21 Aug 2025 10:33:05 -0600
Message-ID: <20250821163308.977915-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One compile fix and a couple code simplifications for the recent series
adding support for multishot uring_cmd buffer selection.

Caleb Sander Mateos (3):
  io_uring/cmd: fix io_uring_mshot_cmd_post_cqe() for !CONFIG_IO_URING
  io_uring/cmd: deduplicate uring_cmd_flags checks
  io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks

 include/linux/io_uring/cmd.h |  3 ++-
 io_uring/uring_cmd.c         | 12 +++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

-- 
2.45.2



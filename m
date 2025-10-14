Return-Path: <io-uring+bounces-9995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E82BD9806
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA7C3B358E
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 13:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5B5313E2B;
	Tue, 14 Oct 2025 13:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLEw4chP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E372045AD
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446834; cv=none; b=RgWIb3CdcvpwnAkcyg+l31QfuxrUPaGqIw+5vpdy7bQ2m+6Mq8+ROEiX09xJutpBdVbk7QvJmfcfQabDNaX21pePcZOEVYVbWQEYvusLkvogPjRvTrMkVCQ2YxkZAivdBe+Nr1f9NcNFxFr7yW40iekoBz2FJc+yK39W2d1bNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446834; c=relaxed/simple;
	bh=7sj1EbpAJnpeoVxMcwuWL5zaTTOuVyXNUSbxilQjCno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBqTkMjk0I5LS6xdhQbCQfkFi4LwQ+Z3kQhN1m5s1UR05xeLmcCsPC9YXWqvb+bw8pzIB9t/PDxEskSxixNEUe+RZffvAD1ZJ6uyjvZAc70ApGz2DD/TuNWV9NPdI0Zod/nzePIOrves1dKi8SOx/j8H1ujwgi7YjU/PsQ7xdd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLEw4chP; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f2ae6fadb4so6012003f8f.1
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446831; x=1761051631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqDy67Vpwu3GYg1tc86jhK5pz5tDZBEzHj59MW+Ighs=;
        b=dLEw4chPZtppEZHUwVBJMxSn8+VNCb8PF2T4mBHtWpSH0ZxJWIoXGWsfYniBIkQnN5
         SDHwk8ONNfEsmbHflSE0iq02HbZ6ylK/f07X5Y/z628Q0CuokMbMkrdKYehYPS7NZQJw
         6msR0rPwg2z/qgJOxuNn2dbxItqvO2B+BjtxkZXUSJpno72quEprPQlHYu1Xg3tm3zyV
         HABvlAS29aztIafsDzmgo2oIhqpUc2tjy8OMLtwQfzaqDJG0+wtStKqqaJi84lvlBXp5
         wAj6f9esI/jOzR+srFWsL/f9yGoYPz/c6wQxk5q7UKw3Z6xg+2Sf3CFpuE49KHx1p8DM
         sJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446831; x=1761051631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqDy67Vpwu3GYg1tc86jhK5pz5tDZBEzHj59MW+Ighs=;
        b=o11FuTAKuiJzk+HFeJRlsj3oWWd8SVzWqwuimYJ8NeI9OspVFmaQrT57woxhnhZ0mJ
         qHqYtwxzzubP6u3zO6hzsKwP63Es1IPFlCmSUyYc/uuSaVF+sZAnvMAfpTOu3G1wcyL4
         pF7Fjs+XMSckdCzHlTzXUqvi+1ol7bpjvYoPKKf/Lw9M7UQgUvg69KHOOX+sbwkd0JRA
         aJKtLlJ61vKccIxbRb6hRx/0rdI2MG3Wi1jefD55V+Kjmap9cEXcfl89chwDb7MsSOuF
         HTprF5ioXvACDRdVYUygrvbY/Tnm2UkG2VRknYzYxJmAv0mWdw3luue7WnYloB5WY2hT
         zilw==
X-Forwarded-Encrypted: i=1; AJvYcCXUa73y54Sv14qu4E/vD579IUzQDu3Qtz8wa3SsaF71VzkvD0jA3yhKfs7n8wMpZjcYUIxjEZT7cA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHnA4LoLBXMTOIRcI9YFI4+ZIIt1cvzb0zHeLdprlH8zsFFymy
	VlfowKvGBHaaRkGy9UPamwACQ04p+9SZv6NBOaCfH+uFh82oXaN0jeSz
X-Gm-Gg: ASbGnctxtu4S0tz/lzavO0+nkGvEwgBs/vsRSzk8qC81xgFnxxgQUgoswAKqr/owJne
	GU6H52yTBrHK+5VumzpLxcax4ID+Hkm3plMrwU026KKEJUufyMTSImQWeWwcVazne9rmuYcwBeO
	0kAZA2m79ToitQGlFphWI7EJoM9ZEDoF09QOz7djlTSL679ml6yvf0PAKSBauyGjK8zzR8zfU/9
	Pjfu9T9B1cEM3OQTRCL4yV7wYzIEG98VxUctHQJnZDL75p2QPJoIass/kR/ekqjq/osIRXQSOcD
	yo07k4Sj8NrcSrUbiI7BVko2rlFXtiDuSYsVzFIuEH5Nl/VU5V7KGKjfcJ00BRSTS03dasfkNuK
	myOe+cAlbIFN8ecNu1W2d3X6hxPp9MjIR8Gc=
X-Google-Smtp-Source: AGHT+IEU0HIsqzFENU6qye7d3i2PLdW3lTydX5soY1R/d6XQCyDdPxuPIE/paJs9wGzyPRz9zSdyOA==
X-Received: by 2002:a05:6000:2485:b0:3e9:ee54:af71 with SMTP id ffacd0b85a97d-42666ac48afmr16043000f8f.12.1760446830036;
        Tue, 14 Oct 2025 06:00:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582b39sm23296494f8f.15.2025.10.14.06.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:00:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	David Wei <dw@davidwei.uk>,
	linux-kernel@vger.kernel.org,
	Stanislav Fomichev <stfomichev@gmail.com>
Subject: [PATCH net-next v5 1/6] net: page_pool: sanitise allocation order
Date: Tue, 14 Oct 2025 14:01:21 +0100
Message-ID: <126a5fbb2bfdfb1c3aa9421c0a8e22d8cc0af602.1760440268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760440268.git.asml.silence@gmail.com>
References: <cover.1760440268.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're going to give more control over rx buffer sizes to user space, and
since we can't always rely on driver validation, let's sanitise it in
page_pool_init() as well. Note that we only need to reject over
MAX_PAGE_ORDER allocations for normal page pools, as current memory
providers don't need to use the buddy allocator and must check the order
on init.i

Suggested-by: Stanislav Fomichev <stfomichev@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..635c77e8050b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -301,6 +301,9 @@ static int page_pool_init(struct page_pool *pool,
 		}
 
 		static_branch_inc(&page_pool_mem_providers);
+	} else if (pool->p.order > MAX_PAGE_ORDER) {
+		err = -EINVAL;
+		goto free_ptr_ring;
 	}
 
 	return 0;
-- 
2.49.0



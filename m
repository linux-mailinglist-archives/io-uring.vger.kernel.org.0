Return-Path: <io-uring+bounces-9016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA9FB2A86E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309D52A26ED
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DCB31CA48;
	Mon, 18 Aug 2025 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9cZ0AHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5272BCF5;
	Mon, 18 Aug 2025 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525395; cv=none; b=KZ4SMuwENKLhPIME5fJjhGnr8QH+CKYwIvSfqmZaL+l5fUCVfKsFU27suNK4h5npYS7k3aL9pCjXxRKkDscbzWBOLelTz8YWMjNiTsKAYPCf+TW/Vv0WGAMRp6NpiDfc+fGhF3ujub/GKLo0rqkrN+BBJhY3Lr41D0HsMIlIARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525395; c=relaxed/simple;
	bh=2zuBjqmBIW52bVn8LC0IEPkZW+Z1BYOsbm6oKTWRbU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3ZQP71SynHxS5LMHhFlDLswmyNVzz9/LzQPBMxxOUWC/6RpRicxM0laaTuRAghmOWHY9l/5DZxhUZ4y218oUc2mI0tnlfR/42vlCcwjoPgW7UvF51QfnymdRaUY6zfL7y4/pv6o5w+0ga6N4AaJy09QZst2hHf3H36yrdIolls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L9cZ0AHL; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9e414252dso1975022f8f.3;
        Mon, 18 Aug 2025 06:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525392; x=1756130192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTLz7fw3dhaIWC1UvzYlzpBK+3xiFjrxNZ8h3LHn8bQ=;
        b=L9cZ0AHLtUJqeMgHE4Cw4urEQoD4R4mXc3cUn2EzACcWk4Slia9YXCRejZqQKTpJlh
         g/US3wfascafytqjTFIZe50q/t/ixtfaVKjVAt3qt1LEgSZm1jhFxifG8iFE/eWC1lyK
         jUwB4c/tM9fGhqHTU0JHQeV7OQCw3undxrdnkKO6bzhs+S0zE42l1hFrFK1JnQ9B+v1K
         Cx+fooGdlNpk2F+CHIbpSDcq/PUYHFVJ7gcCdOXMmCC+NuDNKMpxBx7Vvlb57kzxgk1A
         JhH5qdytYDSjh3wYvmLkuk778ESIkWRPjVk1l2khYQSCaLhw14v9YJ4xWvzdRbyAzCXm
         vkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525392; x=1756130192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTLz7fw3dhaIWC1UvzYlzpBK+3xiFjrxNZ8h3LHn8bQ=;
        b=RdbYMeKqaY6VD1cMg0oWrax7ExvAbBB4e0Xc/lAsWjZF2T8X/F3Bh1occ48kcWym7p
         b4gZ0PRtU4G6CPFoEtCC9E0NJFDOXHVnxOfzbocqisid/weSdOmd1CyIuFrTYjjqoQ8L
         OI8VDuot955fFJrjiFEVgo8XnyuBTod0xYgn+sV6+9c7wDtz2cCT+LC6B3autW3FwXab
         uypemkwN/bN6iljPwTUKxJZx/bjTTBv4SX53Igf88E4RAznuFpz8i+G/wKuQyCuwXk/m
         r0r+CWPtXuwfzG1lRGqwhbYDzqqF1rlea8ICs5VgxxQRf0Uskg2+c/i3EhP23RRvDCbm
         XT9w==
X-Forwarded-Encrypted: i=1; AJvYcCVau95zR13t+rX9SQ2858iDu53q4nxyD67DHD1nzWnDHAqnm2l/21nFyHPIwhs9VQ77KCpt5A7zog==@vger.kernel.org, AJvYcCXb7to6o4mqFdqo/3QPTgFD99phdRFmT9+nGSHXVFLs5StxXKJ29i3alIaJ/Nyiqo+E3LDla4W7ZA33pNVe@vger.kernel.org, AJvYcCXn9ywM89lS0YJsNL2mfZePpotgptGpXJswwkhD/CDrMa8hO6cgoiN8HCFTClr5bMIFsYLRmTWV@vger.kernel.org
X-Gm-Message-State: AOJu0YyZy6vwMnb2gs/NhcI1WqXQ9Fbcq6VcJT19bZHlnj6UMv7/w/2y
	/h2Mq7SHgZExMRKALOpp/PYyugojNgqqRxaRmnGt0fuR+9GaX7p9Vhh5
X-Gm-Gg: ASbGnct5NbFIZ0erUh8PbgRDSlvgHH0X7cPcf9TudfMuISC9PwEQZH2ab/ZAXuIgg1h
	2YmnCI3lwPBREx9pFGVFf9LTTNlxyp+RyBD6Kh+zRtYfqF/Lig9Xl52wex3pY85eJgAqW5QprDS
	EeUUvhUJWrXHpJKYx+cbWt0AcqCIa1Q5M5e6olN6fXKIG3GrHCmP6UC2HWHGS+48eNV3q0mZf9N
	6mCgWGEf/l0tl60DLJygIOD1VTGWFsafiqw5btD4iX7/gqAO7c/Atl54K6h6N0I6YyriJDrRcfC
	fL4ctrtVJX7on0vvPjPPOHWBlpJhzKVbjGpkJ0pebGnoEPhW5/KfCaUxcdJKIrOKNwSU9s5upwg
	j9NXSeK6Hq5spMkulQQc0At/BcTyRGarnNA==
X-Google-Smtp-Source: AGHT+IF0W/t9gHLiLe7UZHDACEfja4A9UmzLFxx/DpzIEp4/2WzMwE5UlByQLEz9LrANZMpZamR3Zg==
X-Received: by 2002:a5d:5f4d:0:b0:3b7:9d99:c0cc with SMTP id ffacd0b85a97d-3bb69699cbdmr10466776f8f.51.1755525391771;
        Mon, 18 Aug 2025 06:56:31 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 01/23] net: page_pool: sanitise allocation order
Date: Mon, 18 Aug 2025 14:57:17 +0100
Message-ID: <9b6b42be0d7fb60b12203fe4f0f762e882f0d798.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
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
on init.

Suggested-by: Stanislav Fomichev <stfomichev@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 343a6cac21e3..630e34533b16 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -303,6 +303,9 @@ static int page_pool_init(struct page_pool *pool,
 		}
 
 		static_branch_inc(&page_pool_mem_providers);
+	} else if (pool->p.order > MAX_PAGE_ORDER) {
+		err = -EINVAL;
+		goto free_ptr_ring;
 	}
 
 	return 0;
-- 
2.49.0



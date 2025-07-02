Return-Path: <io-uring+bounces-8574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8589AF5B1A
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A66A3B7FDC
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683642C031D;
	Wed,  2 Jul 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GC86GM8K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EB28983B
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466469; cv=none; b=ZIxmFCQwLfCMznH2kh72hn+lYTghd1zfFmLpn6dsPyRv/oDzhRXx8k9EGRiAQx3VgshyCtJKW5fGtVb8t0wVqL8BfFg/FOySVx9FesvP7VQs31q/XyTqa3slIfDJ9ldVNMfEdPa1fCVBmgzAUC4SQ0HvyDqpdpAhm7CHNvNW6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466469; c=relaxed/simple;
	bh=yAo99ruZxVLj6WPnzsNk9aMPARTGkzoCzr25RJMQnuc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRJM7eu57aBpHyg1phrKPVamwkW1PClJVlXaFgF93RARL06qDRXs2Lt9soUXaNqCqz5x2575JHXzCHYsK+tOfNsEkDot4o1buZQsYODqoxZS6DZkiCHJ9GytEcbJHoVXCGhnmLMTQGEq7NOokwDR1p3+aNCfqJvXSxurFW1kBsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GC86GM8K; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b321bd36a41so3992275a12.2
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466467; x=1752071267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/K45IxLw0TV4ZOyxmNxW0JvvhbwIZHILdgBwIoCFgck=;
        b=GC86GM8K4VLso3NzOMKcJrp7MJLD66BCjxiz702nH40zFA6rqFfmmFImYVD3xIQzWi
         5GR9xqZjE/MKVhuwts/7hmQaoGS4vqCjN5MbvM6LUsyR61us9ugJmbzJ543rvmZUAIdK
         qoDDm4Aq2+gfmZxD7ZM6ZiufOFZIfsIeoEF29oZestFQZ2ogTLlKBQSWc+a4b6JDu3kn
         DYKwDrb8Df1N65bzaq+Ao57Sj4Fhh/JSmpVPmZGWNzsNUqT+hm4W3kU4FQAGHW4XqI/o
         IfwaLKOd5SqeFO4hLw3C5QbtLh1UzaoXTqrLfoRJmQlq11SpCa/SJX3pI6nN8nf3pBC8
         Upjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466467; x=1752071267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/K45IxLw0TV4ZOyxmNxW0JvvhbwIZHILdgBwIoCFgck=;
        b=ONlm0s3Pl+9eePyxon5CvxsT3zCzXAkEr/A5mH97thxYO8bVjJ+jZ9LbwhFIquZb7U
         s1IUFff9kCatN78nfs0x/a321el1/6btc0KXhW+Sa+ZZd2DCyR9WgYm8v43pwpy9tnMK
         V6JtUZ2OEkYmbUWjMXe3RczSxFwfumFLOLox+5IOMWcHmxM6gT8WU0PXnB6Lm9refL/A
         1gubyFftAfnFESC910iXx9YNuIB55dRG6ZaV82ljdbsUQj6Bqrtn2KnTUB1ECL6a1rGB
         7wWPPeVGjAJ9pB7vod9B924oUYHuFtoXluQ8DcvUYOb2VwjBCEggS3qeYommJ6ajs+4x
         7Owg==
X-Gm-Message-State: AOJu0YyWCw/ew7NP5JOgbY1/lgvTQ30Dp7ETrkfzFZeDn7GjaFWaMjAK
	4mQD/DldG2PGElbZtbad1gKyr4STrG4hlqQk6yD4Tr+/pfKycELh5hmHS+f08d+I
X-Gm-Gg: ASbGnct6YOYTr/oMzHVWDIpsbHbbKK481eS4g5D1QnN0AIDychOfvb0QqexDwPQnsXG
	RZBwV9LDJ1JZPT4cg+6dRzd7CxSk1gpZIJJITbqMO1SVQqIyFRV3wYqW0HwgQuVEh48Vir7Xsnr
	Ancs15rw/6LhO6PJzm6FaIOaueAC/4SlLEpS6fQ/EBoViBJg2ZoIAkC261lZkV4jR3lqmEW3kqz
	E6tpImUSfO/Qt2IacMpYkNqfKEL+rb1+Y5SyR8Nq7FtrSmgNskmlbVma6m4iDP7U0E+7t4cPFkZ
	dSGGyUy9N3s3sMXrYwHL04raWgHkNQYTfHrVwTV2fruEL5KjUNjVs3VAIAE=
X-Google-Smtp-Source: AGHT+IEIIDJ7U6VucmGUCkuHkFY23Uh6EAbPp5/JnUVK8hYQedWqK3JkRBCuYubAIwglAjeFWqK+xg==
X-Received: by 2002:a05:6a21:6da9:b0:220:6cf3:eef0 with SMTP id adf61e73a8af0-222d7f30157mr5748530637.37.1751466466763;
        Wed, 02 Jul 2025 07:27:46 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 0/6] zcrx huge pages support Vol 1
Date: Wed,  2 Jul 2025 15:29:03 +0100
Message-ID: <cover.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use sgtable as the common format b/w dmabuf and user pages, deduplicate
dma address propagation handling, and use it to omptimise dma mappings.
It also prepares it for larger size for NIC pages.

v4: further restrict kmap fallback length, v3 isn't be generic
    enough to cover future uses.

v3: truncate kmap'ed length by both pages

v2: Don't coalesce into folios, just use sg_alloc_table_from_pages()
    for now. Coalescing will return back later.

    Improve some fallback copy code. Patch 1, and Patch 6 adding a
    helper to work with larger pages, which also allows to get rid
    of skb_frag_foreach_page.

    Return copy fallback helpers back to pages instead of folios,
    the latter wouldn't be correct in all cases.

Pavel Begunkov (6):
  io_uring/zcrx: always pass page to io_zcrx_copy_chunk
  io_uring/zcrx: return error from io_zcrx_map_area_*
  io_uring/zcrx: introduce io_populate_area_dma
  io_uring/zcrx: allocate sgtable for umem areas
  io_uring/zcrx: assert area type in io_zcrx_iov_page
  io_uring/zcrx: prepare fallback for larger pages

 io_uring/zcrx.c | 241 +++++++++++++++++++++++++-----------------------
 io_uring/zcrx.h |   1 +
 2 files changed, 128 insertions(+), 114 deletions(-)

-- 
2.49.0



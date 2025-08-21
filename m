Return-Path: <io-uring+bounces-9173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1732B30034
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC7E1AA7D85
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A841A2E03F8;
	Thu, 21 Aug 2025 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DL+oC4Q3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A12DCBFB
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794002; cv=none; b=nEpqauLghIOMTTJtvYhgEDH4m04szRO9N4uvYebWEpESQZvtchMlC27mFKYhpeG+IzGIS1oD2xVF8XExMS6k3NheynJp5iZW83DemlKXONx5xc1jAVU9Ele9J/0sxHTneNMbArXAbG9a5dWkfYwDWf8KLT3jsvYtETOToIQx4W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794002; c=relaxed/simple;
	bh=uIFURckHWirLCyHr5MnyG+vEhQY3dD6qjnSzQQkpAo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjtBmBeQAxvXrfrRZGuCdtDAreTBY2q+syvKCDvpbGZrey/OMLJenNPPAkRDmTdLTeSQJGg3+Lq3PPaM7QkCcoRjcQDoWZYblnhVTkWKXrHM3o02JcW6Ddg5PUfx0CJjFnltSV67tMysTRlxJ+Hg/n+dvUWyTvQfaQhDBTaSdq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DL+oC4Q3; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-71d604dbf5dso462817b3.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755793998; x=1756398798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vW00Pqo1lFm3cqVLsSAt9uZlT4kjnZ7QwQNjvAoBB5w=;
        b=DL+oC4Q3JIHG5UWeA2mT8+l1uL5Iv0tpSg26tPRp9/El5yPylHWxH7FyE3Y2MXgEcT
         Uo21LH7Bf8AeZOo4hRb1mh8Ujxoa7v4leZXUc4FETUqSKv3I7iADqpSavRC5gfJtOJv/
         ZU3P2uRy7IXYb4a7aIFenCkVECt1zgo+vmeFdW3LwNalmeLPk33NF1kUBkm6zlmagtx/
         q/UPSesdRV7c/zVaaGnnOFJuyeYLQsh5+EQKSsfxC1VP7W5wlffRi/vngtNdjYtNCGZy
         p0itGZyWfBWteMw+9ao0m+dUCg7FwPMh1o9r0HiANwEbnjAiNeFj6B3LgN6Fj80yxSzP
         vmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793998; x=1756398798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vW00Pqo1lFm3cqVLsSAt9uZlT4kjnZ7QwQNjvAoBB5w=;
        b=vrXCBVd0+R8cOQn9HdwKzsIovv4DTJSpndxx2eEusFvXfSyNI/4ZA/F2cxrKO7/8d+
         PCSi61qsgi7qanlMO+MTdiekTPQlwRlvy8laEZ8lcocFC9bK3s1tMis91h20vK5FkiV9
         XSIJaCdxobKSH8X2d9sYG+Sb7JfVBwtd1k+E5O4WPOWdMMSWPXC3nLFu8bUiA41n1UQb
         J3Mfs3x7U9j4fJynd9e7Xc2iW/hqJzjfse6CYFCjtkJsAgLQmAISvTFdve7Usq+ght0V
         uYfWFQZmBijqLu1i361IdR8SWfcVNgfgSQIh04j7ypd8B2ASRvGwEhu/3xDyDO3IZ3+V
         vPzA==
X-Gm-Message-State: AOJu0YwfNa6JTfQvMB3BSGib2qqd8CZ0aH+ABC9MgkdjU5bdTQH7HEgC
	d2h2Ysj8BpR+VV8gtc5Sunc+yBhvO8Su+et39lAhWBMr5Bz2H5VQczIeXq3VbZCnbkr6LXZhfz4
	931cvamcH/rSFTOZZQ9hKL8cKGuNeUOZzT6wb
X-Gm-Gg: ASbGncvAkphLQwajS9tT9hdtZ4QVEoypBPkCdMPYDCnPnu1JGC2m+8hzct31TAM7WbE
	jKA/bI3G5rWxaPlehg5WVrIiweE5XGgijyXoNfFltmRSiy1JBF/6xA9SFTQK3vI4p9fIPFrd7Ej
	7qKMd+iLbNvOxqgQx8+ct8jzydNU9hJSmUQj/Idcp+8WwmNwZlnxzkigg5irVUGk134ZiG5ecrK
	LLHVT44/65EN2fF6eiU9FCtJohlHKywoiJyWsUeigt0OQSLhCvL4PhSFBUOQKbBzBOhHqaDj8d8
	eHH3zjpJVqa81J+JjypFDLUH9rcGoVMfghHm07dzWs2Msrgg7dAqb7vodIE5vOUc84vZMTsf
X-Google-Smtp-Source: AGHT+IEVv0BeRHfxkZ+VXPcmHmvUfF6mdfsCIrk2zJym3pMxs/7O+2dE5Oc6vQ+rVXR5K2ZK24/ckq66z3mj
X-Received: by 2002:a05:690c:a8f:b0:71c:1807:993a with SMTP id 00721157ae682-71fc8d4088dmr20465547b3.7.1755793997987;
        Thu, 21 Aug 2025 09:33:17 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-71e750ee595sm11838117b3.20.2025.08.21.09.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:33:17 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5B09A34040C;
	Thu, 21 Aug 2025 10:33:17 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 58AB9E41D60; Thu, 21 Aug 2025 10:33:17 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/3] io_uring/cmd: deduplicate uring_cmd_flags checks
Date: Thu, 21 Aug 2025 10:33:07 -0600
Message-ID: <20250821163308.977915-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250821163308.977915-1-csander@purestorage.com>
References: <20250821163308.977915-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_prep() currently has two checks for whether
IORING_URING_CMD_FIXED and IORING_URING_CMD_MULTISHOT are both set in
uring_cmd_flags. Remove the second check.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/uring_cmd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3cfb5d51b88a..c8fd204f6892 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -200,12 +200,10 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 		req->buf_index = READ_ONCE(sqe->buf_index);
 	}
 
 	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
-		if (ioucmd->flags & IORING_URING_CMD_FIXED)
-			return -EINVAL;
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 	} else {
 		if (req->flags & REQ_F_BUFFER_SELECT)
 			return -EINVAL;
-- 
2.45.2



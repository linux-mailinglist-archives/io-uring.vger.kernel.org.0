Return-Path: <io-uring+bounces-7559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA164A94379
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 14:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F333A8A38A6
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 12:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05DD1A7264;
	Sat, 19 Apr 2025 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1ShWNRUu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C7E3FE4
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 12:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745067163; cv=none; b=qsk1pBUA3lUwiq8USSeT7HCr4dH+pPe+Z7LGpaW75AoBaDDXwJYgFUjlNAC6TDoh3oRGy36R7zPtOyCcFwTzrouZCCXpvEvCaWBijaE6JqRyWw9bo3/3HCREeBtVVLvGlGukpDm84KRQODGpHnAuFiyWpUAAXo+3HBpbULNfa+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745067163; c=relaxed/simple;
	bh=b8UQy+U7l0K1rfrDXI/nAaCrr7WkDklJZXyg1S2NCkw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T2pTmFjLP/baJwLxl0wVCb1uIIGy3/ykOQwupO/NHTzHT9xMwtrzPHV7lo+zz5cNoWBKXYwgxhOrOosRXEBsmVDYZ93T5rY1Fb6avrdsUSLvNhwekqW+re5LOF2b5BzTlg0IqYK1/FyfR1IHtPceHCfCyCUt1NqCg4CX87hdiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1ShWNRUu; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so8962075ab.1
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 05:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745067159; x=1745671959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ipfBuT0DPbLtPPbNyRlG/sfpKBnhZkzR6cvHSXsBsQ=;
        b=1ShWNRUuJTE1uIsr1wzgVEnRwHoXFzEUqpcpRUbGhOg10KmgXf/HcZJBtFqGlzR4SV
         QDdDKVEqOJuqtJh4qmvgpSm4B//7buHLznTD4EnKS9pNm55MpMCypQPRdBw4m/HGJHc2
         CBTRWoh7fZ5wFEJhUsnOyJtzm3kbIW22eSFosZK48/CpQarEU6joh9tCGK/VHiR9whVn
         XAQXPTKOXZ4AN/y9YK5z0mu8WVEn+/zZKUWNv22dbZG0AnuH0aTMGPgg4OssCa+Pk4Im
         lL1dYRwkervbFKai85GzGJ2Axvd8y7xaK79xXcbBlbrG6zWZ+4I+CHmNetT3YJk+jn05
         brNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745067159; x=1745671959;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ipfBuT0DPbLtPPbNyRlG/sfpKBnhZkzR6cvHSXsBsQ=;
        b=ucg8F2CD6xzKIwI7A8iIX9G8zaTwr335z7PUKpI/GVpo0Tokr5wmS9WmNOb9NF+Cpe
         KPJ0+qLfUh8r6hS6hiGyyNwNixodt3BSlM0YhxjiUa9iVJocUFYcXwUw0dB6faJfg8qf
         GOoKkNbKh6/0VkaPmOQLkU2aN7VrXYzU3nPw+Nh7iXu/z+KbiQCqLWJMf2Y2rB6L5Ki5
         phAhDr8JAKNVkrDmmbtgZYnqcfWB2kGaz1Jv0aYnJxytVfbARkj1cdiS9lmY0orDQe4M
         emSmSVFMwLkFKWOOjJhT9EzIFamL0N+WeB7dxCyUNetogeJBRrjktAoApreo+Ax5Gu/D
         brPQ==
X-Gm-Message-State: AOJu0YzoxyZxNnONtnpRXr2wAzf72YHdrTTpPbzC7LiS51arHYGX5y+R
	CsVqqeHBuOZ0eLjGAzEBFlxp/c6NI8/YqoSVysEBzcmfTc9Yr8FParVLaShL3lYV/3xtOGhszKk
	o
X-Gm-Gg: ASbGncvKHzwh7IF7nmGCI3EMkknbe9XZ0Jw4hqrL2KY47ktO2dfPVUayD/fpojP037v
	9HdLRfJIYmB11pHP0cHE/vBYuTuIqFNlOb1SmPR1Gd6vE9IsJijbh77if0ucsj1oY75iwOhnloj
	bNztAIlj4qfJVofx9tavyNusHdn4Gl49f7ZbV3YMKXAu7xLUu6VEHPVxCWz+2Y/2VgXMgtiV67m
	5HBzG3MEodGS8pvFc+aq+aMAsgON4by6+tyUzVS3mi4SJtqe5pbeFP43/X6sohl/PwoLSfcwjxa
	QXKBq4DNAeOPEwD9S3C2z6G02szhkGM1p0NQdyYybQY=
X-Google-Smtp-Source: AGHT+IFPYcy4DNP1ssuz23O90X/jJntjqSfGVGwf78fWhKoR4ciUGwJnD77iYJMe0WV9rYEO6q5lYw==
X-Received: by 2002:a05:6e02:174d:b0:3d4:3a45:d889 with SMTP id e9e14a558f8ab-3d89417da8fmr44387865ab.14.1745067159592;
        Sat, 19 Apr 2025 05:52:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a399aa52sm867318173.141.2025.04.19.05.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 05:52:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20250419095732.4076-1-haiyuewa@163.com>
References: <20250419095732.4076-1-haiyuewa@163.com>
Subject: Re: (subset) [PATCH liburing v1 1/2] examples/zcrx: Use PAGE_SIZE
 for ring refill alignment
Message-Id: <174506715864.776418.5826284103670915800.b4-ty@kernel.dk>
Date: Sat, 19 Apr 2025 06:52:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 19 Apr 2025 17:57:20 +0800, Haiyue Wang wrote:
> According to the 'Create refill ring' section in [1], use the macro
> PAGE_SIZE instead of 4096 hard code number.
> 
> [1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html
> 
> 

Applied, thanks!

[2/2] .gitignore: Add `examples/zcrx`
      commit: 7245359287ef984056d2ed1a62b110196492b93e

Best regards,
-- 
Jens Axboe





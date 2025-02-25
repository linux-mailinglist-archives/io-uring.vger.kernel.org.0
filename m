Return-Path: <io-uring+bounces-6757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02AC7A4475F
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 18:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA0713A30E4
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E92154449;
	Tue, 25 Feb 2025 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dUWljmuv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C77664C6
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740502882; cv=none; b=qYiNJRZUqQOqCJLS7N311JqS11BqZ3MEpK34h5rf2ucp9HGn/st1Wd1Qsl3cP2kmcvgP1wK8R5rKv2lzrCE4OUI8nwV2uzJOGqQ/1meipvj3F6VE0FCB/zw50dH6mLJrEG7sivNwSozpJtP7a5IDFHYS2BRZQeMxI+JY0zgucPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740502882; c=relaxed/simple;
	bh=pLAuf/Dpvj0u7A7Tjnl9enCxpyFmvZb3KNMIIcJhYPY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kTgOfykTBPYWj/WERoeW5D29VVD4ySO98pD4b8LpBqoTYBTW4EMt2p1/J4CeCb9V+bE/3E7WeOcFPJ3fta84zyzjFjQ7RbhKFZXMHe9KX7ZsUOJGS3ccgXBQJYoxv/k21w9qBA9e50XrqAKeEPE8v32+NzVTKC6cIsNDQHhQDtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dUWljmuv; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8553e7d9459so179178339f.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 09:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740502878; x=1741107678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=beajZc/o5FcVnwhbX6k5eNtLa2cYqhPEW/MgY847j1w=;
        b=dUWljmuvnpvPGimE9xWPU0qBFBeTgEqlXgZ5jRzIzG5WJr+dSo0s2rhbQq1KB1p1rH
         51Nd47AZDxoyBvB037jOP5tSvudYIpodnDVPhJAkMwCI4pSYLlD2PAWbPO3cfbGlXNwA
         3R9NSLrwEauMrfHsg5XEyWywqrrp7ozxLRJD566R6kGO36TXl53q+3AntZVUoTfsRTEY
         fvG5pbDn4hfiUYPijNmFECTu1cjRhIlvEdn2NZsJKPS63+AYM5ijAxWf8tlOqz/Uk3eL
         /iNmCBFT7fVlCl/P/l0rBnAvKRAy4cb1L7XeKg4rcEGlOxtmrQVUDJpx6pi9il7W4NoO
         f5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740502878; x=1741107678;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=beajZc/o5FcVnwhbX6k5eNtLa2cYqhPEW/MgY847j1w=;
        b=bW2jUrCf0CCAtRJ9ZVBCOfSGhyzXUPvJRxKuPMK9yAVBUqEyJeaKBvfof2luWIPhs4
         QC8MpCYw3TeqaUc8SiC5ZQywO1xs0GofEqBUl1EG7y9cmxw8EmUD+arC1MXqv0EODjl1
         bVOXAp9rlWDNWeBqPYWHyt1Shz6VhzUFucqqs0pJmt5WGFu4OTkUT2JKXEZHdk9axxfZ
         WQHa+wdUhXXlrMqN/SGqutmGFfjxHeBJvTo3YTa6WMKk38/6FTTWJyIJYyiwTUie2vXM
         QsS19viRAEXx2O7naz+7JzR9/nyYvB/X+0GTAC5JBF+VWBXDIL8+LKQCjoUezQugbrFT
         bvoQ==
X-Gm-Message-State: AOJu0Yy0sCQ+jlS8bDoA2bUaMytb4QUDN6gvcasdA4BRzE6yjxZFN+FU
	H0muNriuRkGNz3uRPShcge5LJPuyktOkWSNFbzlG822cTFrdc7ln4D0Co4iOA0gNDWf/gtyqMSj
	D
X-Gm-Gg: ASbGncuBzZJwBqKa+BJEcu3LA0pzlPNymx/1++PwQgQn6SHPkMi1Obzy7HFaaEYO5O+
	V4VF2Qa+wIpr3zEoKEvdbCCT2Mk/FKJFSzBbzIosPMtZUB+bATjqk6bKezpCnBjGjFt0ZK5+b/3
	kzwVSL/oP2vyIcEpUiv+Uq/ZfKu2r617l30YULgCcp/usV4ZMf4PnOvZJkAqi2SZ0V7qFMEKvVq
	WSCKkCPmUdHW3rPB4yNNxe2tkvWA0Wx/Yzdjt0Kimk4P2qnoZKBshZ9KvzHYQoqV4fb7FyMSEfm
	ENlc5I4PNNsyLBZj
X-Google-Smtp-Source: AGHT+IGVj7BSANTQgC0TFjSuD+6Gn4emsTNNiIOTOT286JPp/05CmH/WbyUaMjv+tb89iPruI7DuAw==
X-Received: by 2002:a05:6602:3f8f:b0:84a:7906:eeb7 with SMTP id ca18e2360f4ac-857928e7956mr4441639f.0.1740502878125;
        Tue, 25 Feb 2025 09:01:18 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-856208e4a3csm38023639f.0.2025.02.25.09.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 09:01:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2a8418821fe83d3b64350ad2b3c0303e9b732bbd.1740498502.git.asml.silence@gmail.com>
References: <2a8418821fe83d3b64350ad2b3c0303e9b732bbd.1740498502.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: save msg_control for compat
Message-Id: <174050287671.2154077.744765624189703033.b4-ty@kernel.dk>
Date: Tue, 25 Feb 2025 10:01:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 25 Feb 2025 15:59:02 +0000, Pavel Begunkov wrote:
> Match the compat part of io_sendmsg_copy_hdr() with its counterpart and
> save msg_control.
> 
> 

Applied, thanks!

[1/1] io_uring/net: save msg_control for compat
      commit: 6ebf05189dfc6d0d597c99a6448a4d1064439a18

Best regards,
-- 
Jens Axboe





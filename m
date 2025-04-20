Return-Path: <io-uring+bounces-7571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4611A9461B
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 02:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA6223B5933
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 00:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512973C17;
	Sun, 20 Apr 2025 00:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WSqC4t7r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47263BA4A
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 00:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745109559; cv=none; b=sTDjvqyg0ij6IQkHzYe6aqH/2K3dLlsp8i6a2sqEq9/hG2SOB83H2E9Ba6LhzrKqjHrKB+wqCC+vaWnqmZuAD2aIPEElpjG2iWsNC3VlxQJvXnE2NkV7HfP+zYhpuWSTdFBxfDtIxdxPays/RZOFDwoLnnpu/XNL2QLCjWgO0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745109559; c=relaxed/simple;
	bh=Sc2Ne3ng+epKJmc2DH+KCZ6FIgghccTTf5TC1w85hHk=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=d6TETZ0UAjr+m3rYIvi218To0sods1xMS2kN4YWz07w68t6wkRbLZNT5x6E2yjGsV2WCfK9OChc7SV+oKHx7+fE0Csy36CzgjQvqqPBeCaspoIw9jq05wLiwAGwZ1y59lzxeN2uHkmLeyoWuF35rQsMSL4IRPpZQCxhqFV/cIyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WSqC4t7r; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d90208e922so4053505ab.3
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 17:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745109553; x=1745714353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvvdhTPaQHBdYOG0b1ZcJKul+zbl304CR3YUmGqR9yg=;
        b=WSqC4t7rP55X36tkmRy6LEPef0hOpE0LPUmLKQ9qSmd/2Dw/zUj2naD0pbw+PIUv4U
         eHwO2WJq7PEXiMwUqejbpcmBQCK1JQYbbcAtK7vd6kU2z34kDM88lS4LWb6RJkKo+yyq
         Wb6eiGrqYHzMpYP2xDCKWAaLaQQYctqa+0eUiuA6wqURm+Ddzeb3amMAdzFzPymWZfs8
         Co1pi0an8P+Rj5UUdAYV/uTuPKLrpeT1NifIyJRq4OgywMQz4FsqKTee5XPSAgy3AyUI
         tS1hIcA98FPOnj/SaclD6CXvDmfAkRA94TedYnmR6MA3nR33pzCdqbGu82ZtzuqL/spM
         A/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745109553; x=1745714353;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XvvdhTPaQHBdYOG0b1ZcJKul+zbl304CR3YUmGqR9yg=;
        b=bvxQJa/db7FhctTBYnbwE75Nn1HDB7y0BgZFRf/oz4FpFI6zqanlGETk1U+BXU+LOF
         FJykoP9zGWuymhtTvWXXcDblrq34Hz0PgmtL83kHoWcZyvwVDaK60xLVqJcK6l9vXkV9
         0UPI6WeGc8XD6ofI5qBGoISJZKS2ZMM3BaA2ngHWCLmyI/Z2J+PkJEz2JD7sSHc5iw3H
         BixGR/9W++fuZQoZl6qRIDg3sAxvIvvywMEYOlxYw8+/jqJpXimPOenr4r3cqDvYVZbd
         I/OqX7bahyoeegugz0pEASu3BEU52gbUvfBUoG9Coz7Hk7duvsKeUM+ZNRm6cKpOY5WR
         MxZA==
X-Gm-Message-State: AOJu0Yzq1TIMwJSfYYFq0+ts5rBWauwuUXPzIZyVdO72wLqWdx+/H3VO
	SZ2YTkuzzhtYcrxDyPLFqajPQbTQKMAAgSm8qyiUY+dbcFa3wvctDA8LhBWvo9qY0ihvN3Vxf+8
	I
X-Gm-Gg: ASbGnct8mgKY8cRrxe3i4Wz91VlMT2RbpsOtnMqK/Gcxgs4Y/lxn+UEQFDtclVu9rqj
	ch2GTYwCSTQmg0PRhlCQOM7yk25+I82NxH57GV9ZlNgcd/w8831Tg3DW+R3z18IVsVtmmiKtzmD
	2GDnjHlDUomU50GuCL/ONom/6+wuLScigB6++RDpNp2vUayD0yKitaNiiDgNWC9pbvtJk3tH6iL
	GuZ+NYOwCh/XbsAC4qR4S184pD0E91mhTuax50P7PR99g5opx20LdyTO15C707SKtnMvLkUV8SE
	bPGFBLUbE/dznUT8V/wmzTDqddveN8PLlMK8
X-Google-Smtp-Source: AGHT+IGImMXnvsOeMiIeXSOB4b0hxzgeBwDVlwCr/huGd0f8Xi2xgCBu++GW7pvSMgy+YR6IM/d2Og==
X-Received: by 2002:a05:6e02:2683:b0:3d8:1d34:4ee6 with SMTP id e9e14a558f8ab-3d89417e136mr65724435ab.17.1745109553579;
        Sat, 19 Apr 2025 17:39:13 -0700 (PDT)
Received: from amd9.kernel.dk ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d821d1d7e0sm11254805ab.13.2025.04.19.17.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 17:39:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20250419170348.1061-1-haiyuewa@163.com>
References: <20250419170348.1061-1-haiyuewa@163.com>
Subject: Re: [PATCH liburing v3] zcrx: Get the page size at runtime
Message-Id: <174510955256.15819.15231858686325301391.b4-ty@kernel.dk>
Date: Sat, 19 Apr 2025 18:39:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sun, 20 Apr 2025 01:01:31 +0800, Haiyue Wang wrote:
> Use the API `sysconf()` to query page size at runtime, instead of using
> hard code number 4096.
> 
> 

Applied, thanks!

[1/1] zcrx: Get the page size at runtime
      commit: 4b1102ba64e29db81a9481bdb4ed2b8ecfd77264

Best regards,
-- 
Jens Axboe





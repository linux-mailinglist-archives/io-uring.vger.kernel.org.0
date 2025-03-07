Return-Path: <io-uring+bounces-7027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C19A57238
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 20:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB4C172DA1
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33A324FC03;
	Fri,  7 Mar 2025 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RufeUfbl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF33A25334C
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376449; cv=none; b=c6WGN4iG644O7mMmXSrl0+ue48NXtFiPhltXb+/sTGI2MVW6v3iD82/pSOYRypSvjZZIi7uWy4UXbTiv+hP5taz2GmXYt4CmJ9Mzt8E1gvsEH1Vxsl2CCWkTsg68JVf350TVJTa3ASHiX27ukyyYvaPRkublFt90ZAXeSJnDDRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376449; c=relaxed/simple;
	bh=g2M95c9uyjPTku+LMbJQbJX+W3aIPvfEmcUXXTdNxnQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=asrzNBg/wL44DhJ0vb6UDsQ2R1VJByzsa4nQElkPj3/xwXQP4briB0YtQp0MHMz6T1yMPzKGnZwXXNgiWLmhdCFQ8xIPTyTuPpBgdee2Yn/mssP30fRBJAtyTellvUvmbxfIpUJWPystys3QLHbY/f9m18Z2Ucwjm0Ng57glG+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RufeUfbl; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85ae4dc67e5so68261139f.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 11:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741376445; x=1741981245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IdoRK/Dp9lywBuMBjQHiGqo0ER9kzOC7dvpPl8T20Is=;
        b=RufeUfbln332WbhWDbNxF9A9E+kN9xmlYaa/35l0xAKZvduTYGqVP3xQHaY576oFzs
         TUdxjnHZYFGEmtAGoT68AjOj7HOzajQPpmXrKyPC6w/2pVgctGICGHqN5ZMw/stwCWc2
         XPMC9Ja359mwCiErrJ1k+7h16qujcpTKWDJF11nAJ8jVdpf9dhL56mDrftcKESSAnSby
         4L7GpjHruue6feEw6e4MiX/8G3BZ0cwT+he6fifXIhtQrNzd9tcWs6jke2P9khQW94Ak
         swFm7ChwPR0sj4s4+IfTRGItGcFywDgalO+FRjsrAqI2zlTnt9z5+P21oPRgFBPRkEh+
         E9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376445; x=1741981245;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IdoRK/Dp9lywBuMBjQHiGqo0ER9kzOC7dvpPl8T20Is=;
        b=ciQX9eDh4bqt9/9cXHlgJnqPzOqQMZU43VYncqfSIJew3JYChv2z0IG31ACXy3B9jX
         IpW4OUbeydeG3FNCfOANaH0mLEner44VLBVzfBFNscIeX+uUnamCPWGYNKtNAgigApYA
         k9Xrxpm8HPYVXetZrOIoz0tro6IAj/PbB0mbbMv/inGeQ9pHP1smJuQ1MmRJyXyFUD/z
         gCrHi2PSURrFmYZsw6rc5369nGOzWF/f23lyhs022ojEYDIjIkrQmTddLB8ftLXTgPio
         5m2ypxNMffqWZ/I0muATPsawJKPWeOLShm+x7k2NOegs3aIvw9UW9kVELqt3EULi+iJc
         J5JA==
X-Gm-Message-State: AOJu0YzzJrNRzUVUmN3JlkdS2ygTVOW2e5HsnZPH26+tSIQAIlGuBTah
	NOz7POarbCS/UiyZYSQIPZ3goIANT8Ah70sPwbyxvDPWkX/lFOawZMXyPTcyJkON+F+tq0+lBXf
	Y
X-Gm-Gg: ASbGncuRu0BpETjtfOgwU99VPeBNPfkgzmtMb6J7K9grH6Eg5Kf6MC5pdZEVM8wrE2P
	YJAg3IiGFwz8yn3MjK5RAhXiQQx6211OkoBQPSWb7b7o8FZhQ/aSU/ZORFQ1Gs/nJ9lB28CidNu
	744bkJuxY14CEAQWerJXulOwlpdkSltTzsApI3RqA1psYoVWeaiMxYF+4ucGXXtdtTfPSfulkOh
	lrRn5dXPO9K40LjxY3ZT7F6zurqKeP73xGmpQx6dKKCtPnF8IyHHaCGWe4bkgOHiRx5SdY+2p+N
	AXzslw3aM6whOpu2ZOHKvlOwElcx67aXYsXY
X-Google-Smtp-Source: AGHT+IFMpCOwW8PDhD59D+PLkRxBqeP/Q6wAeIYOFc8uCnHHyTwStQKBTVfHbW9xtKEIT32LzNGkoA==
X-Received: by 2002:a05:6e02:180c:b0:3d4:276:9a1b with SMTP id e9e14a558f8ab-3d441a06d98mr46982365ab.16.1741376445367;
        Fri, 07 Mar 2025 11:40:45 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b4f74b3sm9802135ab.27.2025.03.07.11.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:40:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1741372065.git.asml.silence@gmail.com>
References: <cover.1741372065.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/4] vectored registered buffer support and
 tests
Message-Id: <174137644416.409654.5023084386934699209.b4-ty@kernel.dk>
Date: Fri, 07 Mar 2025 12:40:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 07 Mar 2025 18:28:52 +0000, Pavel Begunkov wrote:
> It should give good coverage, I plan to extend read-write.c to
> use it as well.
> 
> v2: Rename the new test
>     Fix helpers opcodes
>     Use the helper
>     Update map
> 
> [...]

Applied, thanks!

[1/4] Add vectored registered buffer req init helpers
      commit: d3540589b4ea399af71aa1dd616a64afca590a60
[2/4] test/sendzc: test registered vectored buffers
      commit: 24f835c083eeea1e03e11a86042155b7f3068f11
[3/4] tests/helpers: add t_create_socketpair_ip
      commit: 8b9a92ac1bd3b8c752fc52e9590cd18fda14ac8a
[4/4] tests: targeted registered vector tests
      commit: b5b2e9f064b16a8f2390d52a0f290152c14a84d2

Best regards,
-- 
Jens Axboe





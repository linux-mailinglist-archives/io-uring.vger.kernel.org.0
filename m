Return-Path: <io-uring+bounces-10938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEE8CA18C2
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 21:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 603A9300EA23
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 20:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D549B30E836;
	Wed,  3 Dec 2025 20:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QhXFhp66"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9732253EF
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764793445; cv=none; b=bZsY9VNPwna97jiitYCMzFL5nW+vdVJFNXR8lazTTlgqUXjfgvayBbzSXhwa+bJjMQxxA16xoxA5gAKVeSnMynqeruuGcGKWyErio4FSYyGLMaJL8KWPRcLTwsLjkLaErW8X1NWdU1+5tBMKaSqZ9TiMG4Ggex30ZeoQMgIT5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764793445; c=relaxed/simple;
	bh=9rG2eA+H2O+vAw7ZOkaexplVvEw1IB6tge8skuSRt50=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c2lor4YBzewXMqFPFSiZTtIRRltxH9/M4gckrgmpFNZVywBoBFZD7ls9vVonpxLkmbyde3kORJAJaw3acylqiHgKL473Bzr4aiEypGu2nkFRxtJlgjWWn+1pboLu6GBv2KTjAapToI+lTTdcOuFAkHruaSsH0YmpIALLIyWbdHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QhXFhp66; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c52fa75cd3so145270a34.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 12:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764793438; x=1765398238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI/4vawysugcjmXO8uRAA5b9w6caFtOVp4sIZ4xGNnE=;
        b=QhXFhp66uKWreazc3+I7FgNcynXy/P0E6pRAdAA8dwVHhtlaH25CmrwEUDcKGhQxwF
         ob8VgZPntApO05numB9oKVqvs6u2++xuu4LbmAFYS5Xjqqsrbi6LYWc1+8Sp6+yf1+uy
         S686e3+aHyRwFbvHFjxoVPdEVarkclmNxxmtiyfnNDtHSzgImszkc3fV4XctGXlfeK5I
         noTH2PErEEpnPo7nACxj2bAlP+0ExHsfEw2enltRyfr2sUCL73WUkzEOBxAxS1mvR+tF
         wp6VN+vFZO/JWFArbDp7Stn7ZrmLDTpHUGnfdmZ0fhggKeLktRBHhJy2wDn6qJfJVrSI
         gYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764793438; x=1765398238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qI/4vawysugcjmXO8uRAA5b9w6caFtOVp4sIZ4xGNnE=;
        b=Bpl/PzvRX39TK6eSlWCccTjRuY+XrdsRLb4mWU1w44Te1lplOXY1c7NG1QOA7rt1yF
         HonGUMt+UBMEf5tubvt4lijbua2QuG41x5IIKEFl8CgOXtWSDNbOqVSlt/5WPeA8WRr8
         S9AJhuc7ITsmmJvSv69Ccj97XPARdHqierePW5jZWsk/sxhsmXS/FnhjytUynO688+Xx
         iCJ2C/OLHtPLmV4BUG8MPXIdtrsqMZSZLyStSSypCyfWnsRMQLKpslabPRKNyP18wjJN
         UniaHvLP9R5pRi8m4eH348FrPQ/aRJ9U/kzYrLYlU1yAoypQxDKiH8mLeT8CyXQhT8rB
         G7vA==
X-Gm-Message-State: AOJu0YwogxZy7q5xE8ZwnfQrEF4oBB4lZqnx0MQU8tNlQ0vrOUOTgG97
	hD0tGNFKVHoCHQ48m4rMtEhJTOOhQ5wexlJ+M2dTa7d187tkL+WY8r3YstihlLzxrL1s6ArQ89n
	4zNbKLUE=
X-Gm-Gg: ASbGnctVRvIV/5UwMvzTxpk/XUHT/M5N7OGMsJGKZZWq2Kwk5A+jJtnJcgW2n42pp+3
	DWX2hEYpnDtHQBp2bsTafOxg8n6nPX7GFT+CJ4YRvwSMTwwiBT5u9BsH1UzkHbdp2gw1756mBI0
	V7YMtXCxio+xmi2ImokpMO9Lgc9cx0IdoXzQmd9I7NTC3cspd9cqXHxufiZyUg+2G07ZONlmKjS
	VRjudD3FGr2NBeX/Znfj5RCgxixTYtb6mkYGgaHKzqgUGdufuQgmjcgSyjf7woOQQZsVqldNdKS
	pL1GmCim9hkhrrtS8V0kzypWCPX+paVQPbp3j6MmgB784Cbx0009430asQdQpBafsfKpArTOupN
	dWvVJTl+Gv7g0pCug9guVmmt1j6xhdMXTlRXSCXXAygZNflMZvd8hmDIniH51WGZFlFEw1C3sL9
	gwmw==
X-Google-Smtp-Source: AGHT+IG9rww+1VI4PnOaRg/sVycwdTuAfON2j/xbcdOzLvF0q7WpOnLxXRSHuWWPvj+Fi3Bf7hVMqQ==
X-Received: by 2002:a05:6830:448d:b0:7c7:6043:dd87 with SMTP id 46e09a7af769-7c94da8de4bmr2644878a34.6.1764793436058;
        Wed, 03 Dec 2025 12:23:56 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90fde21a5sm9353205a34.15.2025.12.03.12.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 12:23:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
In-Reply-To: <20251203195223.3578559-1-krisman@suse.de>
References: <20251203195223.3578559-1-krisman@suse.de>
Subject: Re: [PATCH liburing v3 0/4] liburing: getsockname support
Message-Id: <176479343527.889438.3714060142202075784.b4-ty@kernel.dk>
Date: Wed, 03 Dec 2025 13:23:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 03 Dec 2025 14:52:14 -0500, Gabriel Krisman Bertazi wrote:
> Changes since v2:
> 
> The main change from the previous iteration is ensuring the test won't
> regress in older kernels.  This is done by installing the socket fd and
> fallbacking to the syscall.  I avoided reverting to using a fixed port
> because that is flaky and would also require recreating the socket.
> 
> [...]

Applied, thanks!

[1/4] liburing: Introduce getsockname operation
      commit: c1541b0421602ea26ce1c5bba9f3a9403224f971
[2/4] test/bind-listen.t: Use ephemeral port
      commit: 79ef754d7bff5c8216b57b4eed42448f28a4e88a
[3/4] bind-listen.t: Add tests for getsockname
      commit: a75b1b69e437311c7b3c9839a7d4510fb9be20a3
[4/4] man/io_uring_prep_getsockname.3: Add man page
      commit: 419c9ca5bf5d6dd942504213a68a4862e733392b

Best regards,
-- 
Jens Axboe





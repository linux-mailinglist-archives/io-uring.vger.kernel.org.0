Return-Path: <io-uring+bounces-5336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E66D29E9A37
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7836C162B0C
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DED1C5CA0;
	Mon,  9 Dec 2024 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hoarOrYU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23041B0401
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733757441; cv=none; b=MLocO7XkLk3sLvQR1ShNOVWHHuZJGBOkdpaIt2BVGLuK4lj//tsT/OeCDzXJx+02ghXUf7FYn3D+UxYHVIEOkOluMAnrnem+ql4t8WIGQEU+Md15Eotu2EblxHOV+eZa4v0TZ1+tLnppGKo1Db4cQ51Pl3yv8CjhhkqLNyujaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733757441; c=relaxed/simple;
	bh=e0mc89Y3eLrmH+2i6ox6XXsl1un9AeN8vAvv4f7QQp4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=czZSVXFUSDyIry9xVz9Zxfpw5H0ld/lLFoAbtITWFZbiHfSYYXyi77yPkwPyxSkBGdP3p8RzXNz6kqx6But3NyYn3fwyqoda2uwv0dAWBCMbTSXoGQ62y93lWACZvVWLaYIo0qxmh5hMLEaeh4dNwJaRKvNWssSVio8847OA/wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hoarOrYU; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-29fb5257e05so368085fac.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 07:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733757436; x=1734362236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tZFASsOy7v1oysF+IIGAvltk6lDWEL6FOCndqKMAfU=;
        b=hoarOrYUaI7xxS2Nqw4V9gDY1ZJGvrbn01IwJGfvCTrf3E3E5awEm7EFMD+3zvwlLs
         qHuiMOgRa4Feh57KFptwtHF31yNdIBZFSqa9Oe4hMUwndXahzyegoq79u4v2yRj2NPpU
         t86mgiJme06BBi7hVRvllsUmWxBrnnZUPerFM7ffu46ERH/vu5dgwxS4ZkBjP/Tmqfud
         yRRUKIYHjqRZGh+FnFVAWJLyXsMa6r7UqQYqqQ6IdYZ+JdUlsCuuxHXLhFcLDzC5EcCa
         ffy6lxRBMN6DrQ0uz78QJc7u2e2Umu9Lq4TQ7QiUcw7iGwb4XvcRBpGfm2SG0oyLWLN8
         LcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733757436; x=1734362236;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tZFASsOy7v1oysF+IIGAvltk6lDWEL6FOCndqKMAfU=;
        b=fOc2BwlNBRoe7S80HMVQLeuZXLIKz1mnBDhiDZwgDImrn34NOxepfz5yZb6PHp/vg9
         EXyQFE3//v0yE4YGAMlLoxbP/bLK9c8pCiQSytWaneNuqDlsIiDYF1nfi0RzjQDAXTQ0
         HF/LBbspWR9cYa77BmhO8Vd0I1n2YB7Sok4H8NvyI0KvnptXZz6ULkppKmn+FfaB/ZQ3
         at88grUS5/1EWMmhtFNZQHlYq7L2kLirjUSFAnTs6cy0xB9ifu9U7pcth6VdNo3HQqlT
         8rtaDV3aEmGLa70DOqc6vCjjMxj3MWRKLpyR9PHcAu4Ee7vDU4kWaRjXavvL3a3q73hU
         T2FA==
X-Gm-Message-State: AOJu0Yzub67aHubeoNkBmBFe7n+7NfzILa34yQ+4zhOs+ye0gNEn/RR6
	L8QeOnsQ6CKGMyKAs1RIaRGPulPgfCZJc5fa+BajYic8i5jLpH4kNwXriYvp9wxqVIv1li76hHP
	M
X-Gm-Gg: ASbGncs/k8uzP6+ZHRrxz6vUa+kRmYcNBzyHCN/tTvznW4MJtQel4Skvi65U9wUjk22
	D0a+By2vxjmQ/tVyZlmaCm0f2kJfqIxXC0uHSlxXCzMo0I7BYp/Slfkjd0K85VuI/xN6PwCNQnO
	eTfo8NCTdXX6Re8m5mjU5/68Jm3IuKJ6bFpsaKH6eVzCh+ICBbEjuSQ+tAZS0IUN1jIWxDQoV5v
	brJwL9Qh0WrzPpr/w9JxlFPnatrpEcXnmeCZLEs
X-Google-Smtp-Source: AGHT+IH9+it4M6XlWSvH9yZ9aWn6aMDQj5vDXAGu069RjnCCrRcNpkBEhsa9WGPpCqUuJuUWPiEKQw==
X-Received: by 2002:a05:6871:4095:b0:29e:3484:ae1d with SMTP id 586e51a60fabf-29fee6dde32mr579509fac.26.1733757436431;
        Mon, 09 Dec 2024 07:17:16 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29f567c4a77sm2661779fac.32.2024.12.09.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 07:17:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cb83e053f318857068447d40c95becebcd8aeced.1733689833.git.asml.silence@gmail.com>
References: <cb83e053f318857068447d40c95becebcd8aeced.1733689833.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: don't vmap single page regions
Message-Id: <173375743563.192859.8677718830386159015.b4-ty@kernel.dk>
Date: Mon, 09 Dec 2024 08:17:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Sun, 08 Dec 2024 21:46:01 +0000, Pavel Begunkov wrote:
> When io_check_coalesce_buffer() meets a single page buffer it bails out
> and tells that it can be coalesced. That's fine for registered buffers
> as io_coalesce_buffer() wouldn't change anything, but the region code
> now uses the function to decided on whether to vmap the buffer or not.
> 
> Report that a single page buffer is trivially coalescable and let
> io_sqe_buffer_register() to filter them.
> 
> [...]

Applied, thanks!

[1/1] io_uring: don't vmap single page regions
      commit: 21e3947c0cd2ecdfc043089288973d40979d3a81

Best regards,
-- 
Jens Axboe





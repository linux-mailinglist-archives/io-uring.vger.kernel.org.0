Return-Path: <io-uring+bounces-5672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E90D9A01664
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 19:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 564DB18820DB
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 18:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167931CBE87;
	Sat,  4 Jan 2025 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hsqlyFZj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09171CB53D
	for <io-uring@vger.kernel.org>; Sat,  4 Jan 2025 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736016016; cv=none; b=BHrp9i33uv0WqGBKjDTjt74vJ20CkBFkCXtt29xZkMT757qV0xE4K5v/AUz82XXqfmuh9jRi/vTEzI7Un3YZOW+Ceo8NGVRKw7ZtOjqHky19VImlwujsxxjz+CMjMw9IX7Vb7kdKR4NjikmY1t/hZhcB8/y6DbLUQ4l1oZo6JbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736016016; c=relaxed/simple;
	bh=X7roU4wa2jGuTnmgrCNUw1jwxQteeRwdpSp6aeGiqOU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dLuO9fP74s9myqlzcdqR1zEqgcgZCzEW/GjpTfGnCf+plJBQuBOIGof9jkTrsQoFk7e8y5UaRqmCHkkeYyvGrLYzUBbzCDGOMGkQCppOfHGWH4WygpjnO5LkFD1K8TOcDksmtsfSTg4SCq8Z6rYVAjXW2iU4GgOO3v7AtE2N10M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hsqlyFZj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2166651f752so216690375ad.3
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736016013; x=1736620813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/QDhk0xIUh/vvoBBbGKwIYNGsNjkF2lyv3w0JDWCmA=;
        b=hsqlyFZjyMmD8UCOOTi6CjaR7xttd4Z+5iLmH9WPioqJ7eTIbFyD8QE3GzZkBgeZOi
         HOvSWq0bkeKwfpgsmn02X9HsvomwuLbmRol1gSJJn/JiM5bu2Y0wlyywXP3DTsF6AWCS
         yGjgZrX7M9zwYDxnHRiWCvw7v/Fi+2ExoI099j1Ha19a1worwwVJKP2RFxY0SzCOzIKh
         bYfy+wK9zaDqC7ioA0gnj/GajVZQRp2DPASNPL5xqk0OqT8wSu+jbSYrlY9FlzdeK2TM
         s277oMCHlT2MFJUBkDYF8223CoeW0bw7synMWRpALGCcwlCVYI+oGhvAXX2igAxGFwtQ
         F83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736016013; x=1736620813;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/QDhk0xIUh/vvoBBbGKwIYNGsNjkF2lyv3w0JDWCmA=;
        b=td0H8AGkM2JmC/k4c/tfFJ6nO9jti4Y3IwNQh53pqoo0CMTEuBYLz2R3yuk6flzvec
         0yvFt/WVGI7JVA8IdZhxDdzGRmk9TTzgveD/T7ceu5ehVDBMx4x2p/1NawcpJNtHDSzZ
         DsvvwA5T8WhHoHawkpPnNHQuHWqV7UHDEN6AzH2NJtm4RWU+DAVEp3ocEwg01pFiaSMU
         XaRYYbU1aGdGKo1V0GKqZkKL7e6YvUnnYyIjv51r0K6O0UMiH5Un0GyKXhfRTMwYdic4
         pGc+6J2YepKgTP2R2YUe/kQVSpDw1WiU4U8Nbl40RnjDQwHuq3I8QiiJYyvu1ryESWgu
         Jdlw==
X-Gm-Message-State: AOJu0Yx6yPy1Kx1ZD4xhsrzO+ZDSquwdTeMlxKGxLS3jInThCa/gVPGl
	NY0+bZBiCF7RlO500BIaIb89r82hf+DmQcY4WPeDPuoczGh2Z9+KHFelY/BEk90=
X-Gm-Gg: ASbGncuDAWQL0rWUuiDyFsw7aCYL2gSomItXBOuCINB63su0i8qc7ajdKDS99lokeb8
	7myAOlHeIj5zXUgDb0NawWDYhiwtLOE30nAKf/uHa1eAG3iJVVWs73HtzpFGFCgo60jvmnyOotp
	9LbHX4aKkyMK7MmeHr78ajt3FHRoidoQY3ILs/xPuQGo+h39yrnNdhb4GXYmIViZE80D/3HcY6c
	/5oxHQDlzU1pHDWN1N75ogiQU1WTKKNoGP8GKGGosLf4OiZ
X-Google-Smtp-Source: AGHT+IELhXD+sJX4KMXouljV/tE6vgwhqvah4Wmq6VwhKeCkPrEC62GnnpzDs/nR4ZOCFOFURZQ69Q==
X-Received: by 2002:a05:6a21:3115:b0:1e1:aef4:9cd0 with SMTP id adf61e73a8af0-1e5e044e423mr81375711637.3.1736016012924;
        Sat, 04 Jan 2025 10:40:12 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8315d1sm29265204b3a.61.2025.01.04.10.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 10:40:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Mazakas <christian.mazakas@gmail.com>
In-Reply-To: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
References: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/timeout: fix multishot updates
Message-Id: <173601601193.116534.9620035303214033083.b4-ty@kernel.dk>
Date: Sat, 04 Jan 2025 11:40:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sat, 04 Jan 2025 18:29:02 +0000, Pavel Begunkov wrote:
> After update only the first shot of a multishot timeout request adheres
> to the new timeout value while all subsequent retries continue to use
> the old value. Don't forget to update the timeout stored in struct
> io_timeout_data.
> 
> 

Applied, thanks!

[1/1] io_uring/timeout: fix multishot updates
      commit: c83c846231db8b153bfcb44d552d373c34f78245

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-6891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0D1A4A80A
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF1D177D42
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809FF1A23BE;
	Sat,  1 Mar 2025 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0VUi8dJk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF5190674
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795821; cv=none; b=tZiin8yImcpoaOMigXcPA5q0VpoEoFa4l5Ir9dOVpNOiKMPbHvHURb93XBkaXxxJIZV/oknEQepciI2pkmvWW+bXgzFU/ctNDDv5y1fmLTvleTDed8uDecfUxQPP89deMzAphvXvre10eDb5muzidnbumJDji/z+I2epJn/OdIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795821; c=relaxed/simple;
	bh=gwJVbUB8nQuOGaN8LbjoPuXKD0F5grY+dCQT7TNDyrI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fdC6Yrsi6UfYta3XY/L9b9+iYqrWFX3vYn1k+X/EMZpsluiS8SCuUCwVpWy392sENLUk7Nc7Dn9E9B0Q+NxvY8s4RlnPqHkoqe77GeGNUEnKHQK3rpvodJYx9rUk2mcG7rFWgzYM1H2LTWSFqN8RtL/QBVCiRyRsD5AHFHATfsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0VUi8dJk; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6fd3b6a6a24so18526707b3.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795818; x=1741400618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avdEeT2k2pMbZXLxs+RZva45RmgD9Orxh6FLQ+TRV8M=;
        b=0VUi8dJkmYQhRuBApZwmg/egbyCJwef5ogybqLfnDBI/fMWFM76lk6P5K/XzBHkVrz
         pmVTVhgOS9L+aE+GAPum4F4nU2xDy3s0Iy+Ha8WdAOjEUBGg2nrBQ89avPfp2Oo+zXVp
         NsLmbR6AtoheFY3zp17NGPBOeIGBOffci/PjItLrzsDhZofMuLsMKXANkbI8mMscYoFw
         rHsWooGFKcOCjQKEHMFjZxN6MV5gMp09SVQXy8o30H9+undrgiBxjfpfUxEdHmI7uQif
         mQre80JeHxcZKpgZAlVoZusZgsEXPuqUfMFCkMcUAL2Ruz3bJSTkUkIGDg28O7PwiHu+
         VCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795818; x=1741400618;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avdEeT2k2pMbZXLxs+RZva45RmgD9Orxh6FLQ+TRV8M=;
        b=Ta7dAmiOLJhPsy/nZzAPaitLUw4M9bXkkh3M1eXWQuGjsBy7vceqqYpVv6V3oc/jL9
         LX33lWkjK33NfAB8El4zEKTme4ZASWoII+F1+ZUR2mXV9zlomvT61vBDJOkLkmohl6gy
         wlUoFvIJd/U7SjgKd619VXQOfo7DrWCHCCBGu8GzJyW8Rr8kwPX6nNOXWAKpeH5hnbVL
         nJjmTc9r37SupcXE3V2FkQ8Xce0tThkOx0CF6sTwbEZGdB9U7UpLHriIXd5/R3YD8yPk
         aZHGYJSEaJFR5rEdnZFSvU5qpLHPDfQyLLCWL1Rf3cejhggmYgnf255sxzuVVG4aXlkf
         j1sA==
X-Gm-Message-State: AOJu0Yy3lyVC/80VH2H2/RKcUhlyhh32LK5A2m8Xgd5VSz7Vf11BSCrz
	8yAK4xG11DtQVoCyeBlK2V+RlJjA2fmZtxlTRvH4PwwMrB9BsVZK+Q5/I9f20XE0SwRCb2wAt5l
	w
X-Gm-Gg: ASbGncvInmM6wU8hXc2vhW5Ooo+SavqdqoiV1EgCCxS+sqRQLlevLDQpqwvcLoq8WH4
	kYcknDcNek5OzO2oBi6oZmnEFlzuP/GZ44fttP+fh7zxFwBKYPQhClROu+YHymcf5CBJdrFZxdQ
	Fbz+cblEtIS2IrREukdWkUBZHvyixRDpmJhXja4Jc9glsxV20LpShFqG5pg3frhkHycB6ktspNl
	PVI5YjIVNEtd7vnl/Z2+MtMHKtStQxBayN+8zhqBK9fYaviibXKsR0YJtVwqmEWO5vbP1fL69bO
	G2oB9s2PMR+1HfEJYi9sYkRQ2wZAtVVvV4fTXZs=
X-Google-Smtp-Source: AGHT+IGShNJw9AGz5eAUilvWsKkH/s9pd+G47t95AvidWnOxtGe7WBOU3FmTPmGidlL8Q0XHZmttjw==
X-Received: by 2002:a05:690c:6f0c:b0:6fd:4521:f9fd with SMTP id 00721157ae682-6fd49f8666cmr72420207b3.4.1740795818260;
        Fri, 28 Feb 2025 18:23:38 -0800 (PST)
Received: from [127.0.0.1] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd3cb7e02dsm10175307b3.84.2025.02.28.18.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:23:37 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250228221514.604350-1-csander@purestorage.com>
References: <20250228221514.604350-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/uring_cmd: specify
 io_uring_cmd_import_fixed() pointer type
Message-Id: <174079581706.2596794.9398482101853410174.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 15:15:13 -0700, Caleb Sander Mateos wrote:
> io_uring_cmd_import_fixed() takes a struct io_uring_cmd *, but the type
> of the ioucmd parameter is void *. Make the pointer type explicit so the
> compiler can type check it.
> 
> 

Applied, thanks!

[1/1] io_uring/uring_cmd: specify io_uring_cmd_import_fixed() pointer type
      commit: 0c542a69cbcd1fefad32c59cea7a80413fe60922

Best regards,
-- 
Jens Axboe





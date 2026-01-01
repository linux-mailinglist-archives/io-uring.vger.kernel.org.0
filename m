Return-Path: <io-uring+bounces-11354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D82CED197
	for <lists+io-uring@lfdr.de>; Thu, 01 Jan 2026 16:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C05E03004CA0
	for <lists+io-uring@lfdr.de>; Thu,  1 Jan 2026 15:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974DC2DCC1F;
	Thu,  1 Jan 2026 15:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="03vnNsZH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D471A3029
	for <io-uring@vger.kernel.org>; Thu,  1 Jan 2026 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767280685; cv=none; b=okUYdXqwxHjDyhW5jjz27jP4/lv6DTt2Z+VE6kTT+i5RWeMechWlJ/O57c852MUc6tYvIIyRkROm3hm+sRbbsV5PBD6TTHp+j8mN6iNWzQOXm5bE0rxFcuk9mgrmy9C2Sbfnn3eZ4llYIBMy8zFAsTbHHQMYhS/A2PXMBt/43i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767280685; c=relaxed/simple;
	bh=M78ASfR/OjMbyJeoEip+eqK0tOpKEEr3i+ASinWxBVA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cWdIeLNOxHd4U+A8VhK0XYbXYu/aHmNv0G6CVgFj6XRbTPmhgru2faSqo5IFW+9dpiDg8YmpqDRxaW9uPw0MoqQHgJJUkPCr2CE6BC8HCWcKkWPUyBdHdLxVIMoMmYqWw7diao3vTAvC3i0NYiQkCgh7yDhZmPuNFO7iDKb3Pg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=03vnNsZH; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-3e12fd71984so8088097fac.2
        for <io-uring@vger.kernel.org>; Thu, 01 Jan 2026 07:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767280682; x=1767885482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7apZCjlfhW0MIT5ACGk7fCOMQ9UbqlXUKESiisgzls=;
        b=03vnNsZH9m9M9JWd9EPEoibuXZo3tLMclp+cG6llM7FDKhVlX5T0/txsZluEX557Ai
         INIrmO4GFkjXppaAl+yLNc7L44+bNZm85DSvQUxqAHBhLMLs2eF4tvrcKLFfQak0zrzZ
         pIhhf9wk5KZ/Y/H8sq/d2dFP/XrjYJVZi7ZjQ1bLXLMRJ6lWy9A3u0XovXjFG/eUsK5M
         ZstBF/s3lZPt3HlbJesK8UgW03jkAAXMsmIFw0u0uwmcFlrbdB2P9Jedf1XQnrpEIdXg
         aZwWOldPcj830c+BI3737VGpQb08Lr2Ur1+sBi9ZRZUebvc9qcj6NWdJ91VO3VUdicXe
         fZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767280682; x=1767885482;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H7apZCjlfhW0MIT5ACGk7fCOMQ9UbqlXUKESiisgzls=;
        b=nSr8RUY2AZcfRB0drP014+02s5UmktozbyXCDDdUV86Ti+mW7rfT9dNIUv0D3KDQx8
         LpPQ7Cu0CeFN2KGC08Y2lOeAtryqGYti7/00sH5ipyz0Oeg2UP0MJ9IQzjwnx3OC5fR5
         dikrPobv4RNRFM+or/TsHH98e8sGmWFJKf0Dt5R+PZAetz7R48/rclAua/nKbTJ3xjNo
         Ra8HLJY9mOCs4CUFUyfxNDAyRMWDl1ngiCI35oERgMbge4yUKiKqkJdZmp3/C5mPtGG/
         aVcFCgT1fRmiNnQspcrnNHqqsQGrI3pSfJ84Pvrl3GSrfnolbcWqzsdz219mc/f/wUCT
         LJsA==
X-Gm-Message-State: AOJu0YyMbOOShiMFSz7G2Msz5OiE3XHeacsbcZVf9APk8sFb8hRGboc2
	TsHqbLfsh/mW/3nvwMXVCmRw1VgCKpSl4qHSM5ypS1utSLMAGfdnVwH1/8tEYvZmFAU=
X-Gm-Gg: AY/fxX7wHozZ7TqrNp2m+frbHdHptLbn7FR4COt00HXDEqekMJycAqISdP+yz/L2xoK
	qT8U4DzaPLUHhK3smEVfWSY9Ox9K0EHm5ASbEMBirDrPmaw/9lC9XFWBtcUqZ+xRT4yS1G6FyXG
	bbQsVyeEmfe8y53ONPQ5EnfL5H9o1fY9pfV2Tj4YAnAn1mTZmTe1mb9MieXEy2c7fYED6PiJGkV
	dBT1ppC1aPSBviy00xBgub3Q8uT5iHeqWIu1thzniEXFTxiBqIlzJ2djYPzbnIr6olb/oDwbUa8
	Taodcc9f8A2x//CenDmW2ACu4oJzXQfvBbbZbA/v3UH3N2/+XfBKXpZx+eJ2liksPcCPxK+fTTP
	URj/KSeP1BOhcRf0nIAC+GVtjofkhYmCJt4gx19fer4aC1Wuu938vO0tn0GCQwL+l4na5tlopAM
	UEfAs=
X-Google-Smtp-Source: AGHT+IHM6224sMkuUgtEbaEdiOqb+DjBIl+zhTQx0rtL96Xf8pGZcnrpgL8tktk3xtm6QAov7u+mqw==
X-Received: by 2002:a05:6871:28b:b0:3ec:434c:5a2b with SMTP id 586e51a60fabf-3fda545eb3dmr22160000fac.2.1767280682246;
        Thu, 01 Jan 2026 07:18:02 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdadbf8d97sm22910886fac.1.2026.01.01.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 07:18:01 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251231181908.4039028-1-csander@purestorage.com>
References: <20251231181908.4039028-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/memmap: drop unused sz param in
 io_uring_validate_mmap_request()
Message-Id: <176728068061.499896.16573208146602246886.b4-ty@kernel.dk>
Date: Thu, 01 Jan 2026 08:18:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 31 Dec 2025 11:19:06 -0700, Caleb Sander Mateos wrote:
> io_uring_validate_mmap_request() doesn't use its size_t sz argument, so
> remove it.
> 
> 

Applied, thanks!

[1/1] io_uring/memmap: drop unused sz param in io_uring_validate_mmap_request()
      commit: 70eafc743016b1df73e00fd726ffedd44ce1bdd3

Best regards,
-- 
Jens Axboe





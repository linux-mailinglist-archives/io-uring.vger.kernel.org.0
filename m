Return-Path: <io-uring+bounces-5293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE00D9E8060
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 16:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F36B16274B
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 15:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38DFE322E;
	Sat,  7 Dec 2024 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sGeyoYKr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE022C6C5
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733584580; cv=none; b=DPauqF25KKjzAU4Hnd9UN3JkDPUxQSgOfT/IlmDSK+EuezZGpqv8IrupWjuUbUXx8VJkuQFvz2zioGWytLRHuyEX8Ozwb7yNdWMsxhqJ1R5nZoKfV3I3vxgcPkXmxCiQiBmMDoP70AmLNqo/nccAZL4+4Xmz4Owy0Vricmqu7bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733584580; c=relaxed/simple;
	bh=81Pc2Yg/tYwL0aXiXMHaLyqlXU5TyzMY6qNnsI52Ccc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lhVC519S/8hT9ahECUtgmfOvGSEVkIJXOHugiII9zri4EyfKainjTWlMlTRbeoRo3Tgv5E4IpvNTHSo/+8j+raquphdU0uvv89PeNkUCsn0bJZnntf6C1KEbBaSohqJ9ZqBBoVAxPhszSjt1IlQXS6p0sqB1xgZH90U4Drt024k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sGeyoYKr; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21634338cfdso2733655ad.2
        for <io-uring@vger.kernel.org>; Sat, 07 Dec 2024 07:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733584576; x=1734189376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzLgfqnKvZsm4x8KKBJSDir07s9JVqUdD8ZIXFygGkM=;
        b=sGeyoYKrnQ024FP9ADmlo170Tiw/HfYym/xDj0pDdkeB+/zk7aqC0X1z0BOTUY04KB
         xXehW3VlKuQ9vhdmLztu0ZtZpNfkhUlgQ4Y27UqTj/FYq8KoIvrjShYE2ID2MUfTuBjn
         kHV+ZnGeloD1cfXlyhZ8VHkqgNRopIGXW8G+rCaIBy3JL6LfRI04p2z1Q/OKRNQAXJEQ
         RwiYTMEauRELFmmHBLG46o+GXGnf8Imw8bOlKp67UXS97jkl3OxXI+sVZEdk4x29R0rh
         kI3MxHzNvNgyHG/5qz40/Qu3BAfXayJnKsdW0tNtVAZ7TdcE5zBXJyA2jUEfKWsucffA
         KCqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733584576; x=1734189376;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzLgfqnKvZsm4x8KKBJSDir07s9JVqUdD8ZIXFygGkM=;
        b=R4/sBRMNpTKCBtOdvFg+/i4PkWA/E8okXHhPIOpbCMPkiaWptI4pmipd5dYkkCQaS9
         FDtTATiNvE0COcdKJR/v8rSLk7tmKRpyyQ7jas3kDtBNntWOLCZs7+mLXzvl6VDcXKZf
         V3605wgGc+BfgFPrkq3me6kBO+UbDye2ep6N1GRhUMUae0IIaVbPSKtv7SeYelbQEYAs
         s9oyxb0pK2dPN7x7EB8pM2/8lqsHNnO7LkvZbAOGpy155kiBAfubeNESrWoBlVC0PfZ4
         veT8XFiuwe/4l9aFDvG6KBnPt7p61UALz4nYUvLMFpBR5hhX3WWVc1buyzLDfarrlw00
         MCWg==
X-Gm-Message-State: AOJu0Yxz1KGkyv/Dvph0ZFx3kqbofEgbn+bc4cV6Jz0TpvAnIkZ6O9Ss
	WxV2LgIA6LaUHiyacmQh4yfFZBD8YRKfWslhutAz+y9ASYiWJGAC5ccYkABsjUoCWuC2+VaMSDx
	h
X-Gm-Gg: ASbGncvVBFDFp26INXW8+Ndq8l4DZAli2fL+tiFcXwVp5TiNT2kM9t3Q5X7R/99bLjz
	DBkTUK2FFY12fjk2OSm5ZPHNnkhJ2S+PTFdmFzNhMOuScWAtIG4P+K06jXHWXTlj1oey5ISTH/K
	8B+MSWFSoWS8pLgVtqEwTSXpaK+JsZx3+bbklY2yR8yO17RTbZ7oQtpZjU8BH3+onapLjZlzsCj
	oJ93SCM6nuxf7wNGbc+iWx9btm3czDPduDohH1h7A==
X-Google-Smtp-Source: AGHT+IHZfFpWtad7fckKTUwN7obS36tV2uWZApTPqmuguNULJNNRPb46O20GAwC+FtlgrBLW7fEJew==
X-Received: by 2002:a17:902:e5c2:b0:215:94eb:adb6 with SMTP id d9443c01a7336-21614df13bcmr113053015ad.40.1733584576363;
        Sat, 07 Dec 2024 07:16:16 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21618e6a605sm27464455ad.26.2024.12.07.07.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 07:16:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241207004144.783631-1-dw@davidwei.uk>
References: <20241207004144.783631-1-dw@davidwei.uk>
Subject: Re: [PATCH for-next] io_uring: clean up io_prep_rw_setup()
Message-Id: <173358457541.925070.12046047117021242167.b4-ty@kernel.dk>
Date: Sat, 07 Dec 2024 08:16:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Fri, 06 Dec 2024 16:41:44 -0800, David Wei wrote:
> Remove unnecessary call to iov_iter_save_state() in io_prep_rw_setup()
> as io_import_iovec() already does this. Then the result from
> io_import_iovec() can be returned directly.
> 
> 

Applied, thanks!

[1/1] io_uring: clean up io_prep_rw_setup()
      commit: 179e7e105a780f582f73dd7dc4ece3b65c84eece

Best regards,
-- 
Jens Axboe





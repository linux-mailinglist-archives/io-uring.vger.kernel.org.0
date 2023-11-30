Return-Path: <io-uring+bounces-185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D01E07FFF32
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 00:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1675D1C20B0B
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 23:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410F561FAB;
	Thu, 30 Nov 2023 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="azGIg95T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E7F1B3
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 15:09:26 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6cdd2aeaa24so267845b3a.1
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 15:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701385766; x=1701990566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmpnCqUtuoxHHvkEl3B5MTEZYjPTnTR+G4KhZG9sw9Q=;
        b=azGIg95T8DT5YlRh40XmtRd4RMEQHF1NlqeK5L6qqqKxZ/V49sS/8wZFnuJuBGygRw
         xSe9RvnI787ksQ8455sJPxTqb2zACV55jAYcDgo8OsgYAu852AA9pCqpzX9Xg44+GK6a
         /++Bi4zyGWyf0sjnUqq3/g6luTya2FP0Hnczm1Kci4YVZXED3YRhjyqH6nk4QMkrxM6M
         qjg6kgfHJcab3iYu0cQUCbst7bF6b/mDC31VAAj8HLXHyxBz4NrVH23AHFPnOYWVFsmE
         llJRFPVPaF6muX/vU+hhiMNnzbBnV+Wkg8D1dlF3ZHaxClMIhsF5FtAr7KMTHAFz2NtH
         J4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701385766; x=1701990566;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmpnCqUtuoxHHvkEl3B5MTEZYjPTnTR+G4KhZG9sw9Q=;
        b=jLLMo29ZS8/LyQpPWHxSq3Um/nZufzt9Sv9DuOFX0Zp0AQxoaQP5Ds+cuv21GQbbbs
         XNw6VDFzCbmncsXN/7nwNMd4mgmDrCaI2fh2CdJG231Z3B/2iNWGocqEk6E52Ko1eFHd
         rWcTcjfqyn6iEJLq40aCvgBGE6zONMID/+IO4tv9AyHabirl7htvnWW5wofM78HS1zNA
         bU4EyfKKeghaGku2diGXyMAzesLrgqcP7kN8/qUiO14N5vJU/hzhALGS8TKACB6838s3
         5cZ4LeUtyYs8lDGinfgHnySpvYJ9r/seUXK62Kq9EG9dmDJlSi9THA4UvyN0Py/KTrTN
         F1pg==
X-Gm-Message-State: AOJu0YxfcwyMLWRIh0RD+1Hdiw8sJ0I3qnsXl6eU73wLfRgCtUou1frD
	zP1ovsmEsg0aVeJONMZqlseQeg==
X-Google-Smtp-Source: AGHT+IFKPPF8r3m5BMDX5DFNv0M2Ii6euwt49/3tWDuQf1TJfXsX7mSig2AEFjsW0Ceh/6TAPaPTMA==
X-Received: by 2002:a05:6a20:8f05:b0:18c:6148:6a7b with SMTP id b5-20020a056a208f0500b0018c61486a7bmr20428611pzk.0.1701385766268;
        Thu, 30 Nov 2023 15:09:26 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a000300b002850eb8b6dcsm2010297pja.44.2023.11.30.15.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 15:09:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: hch@lst.de, joshi.k@samsung.com, martin.petersen@oracle.com, 
 ming.lei@redhat.com, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20231130215309.2923568-1-kbusch@meta.com>
References: <20231130215309.2923568-1-kbusch@meta.com>
Subject: Re: [PATCHv5 0/4] block integrity: directly map user space
 addresses
Message-Id: <170138576512.699292.6762410631511683338.b4-ty@kernel.dk>
Date: Thu, 30 Nov 2023 16:09:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Thu, 30 Nov 2023 13:53:05 -0800, Keith Busch wrote:
> Handling passthrough metadata ("integrity") today introduces overhead
> and complications that we can avoid if we just map user space addresses
> directly. This patch series implements that, falling back to a kernel
> bounce buffer if necessary.
> 
> v4->v5:
> 
> [...]

Applied, thanks!

[1/4] block: bio-integrity: directly map user buffers
      commit: 5a0584b2c714a219296d97d9f4307ffe53c18937
[2/4] nvme: use bio_integrity_map_user
      commit: aec0ff70f016fdf7b4ba52e34d682a185dd8dd74
[3/4] iouring: remove IORING_URING_CMD_POLLED
      commit: f8243a30dc179ac197bd8315bdf9d55d3d7792c3
[4/4] io_uring: remove uring_cmd cookie
      commit: fb62c0c9b04265539851734ae35cf3f10651a8dd

Best regards,
-- 
Jens Axboe





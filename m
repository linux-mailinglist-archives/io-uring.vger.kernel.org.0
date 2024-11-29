Return-Path: <io-uring+bounces-5154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 608489DEA1E
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 17:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC193B2095A
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 16:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024D214B946;
	Fri, 29 Nov 2024 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kI6RdVCx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6837E153BED
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732896256; cv=none; b=BNJpSfhNgBfo03cbuas+ch03d/IAL3wzqaqJ8G0EGV4ATQlDLH71rgqsa6+RWQPy/ZJ1AvLCcRT5r4BwWCWviHhlwV/K91aDaasWm2ytoB6qLfzvOg5ek8THV/ITvQqdRtrpdxWINpE5FmiJctMH3DG2bwWjbXTsmwNps6sQOUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732896256; c=relaxed/simple;
	bh=xu1NVatpA2ZXqTXPG9XzG+l/h1Z/YiWcWL2kKPmqUyE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CXSe+aFI7j6UbL008IDiU1NpzT/IIl+sXLXIpcHrSglBjurVxZDPCTTWf8HOZN7IGytZNVgzX/xsncnOLCo6fRTy3ONkzvttejCqEDSii1scjEDtiPSy2rd5aX0wgFhQxOJ2BHF7WuBxxe/A78jayPBo9XDv0QVaP5x1q4SAPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kI6RdVCx; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2127d4140bbso19266335ad.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 08:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732896255; x=1733501055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRYCaR++kEU3PDN2eQ+b+5uSQTJ5Bb61ApyC7HopWXU=;
        b=kI6RdVCxu3FlE+LyYaFB2fgCilkcyJVo9bctPBY3EGNmIGZH5K3ICFzTB8Z4hPt9ob
         9GefcI/KhkjcTqglptLus/Atb0nLJ4AHV4krBujLlQvZ8MVOC7LknhlDPfEI9LeRY/DG
         gy45bNpssy+Q3Zau0ypRGzffNtHIBUhNs4Qqikq11FZdfxvkB+a2xYp+buvP5pBWWpTP
         aIHjknJMqT5HtFBeEzsqogI39FYl6VcZyAxg8y1lZkkjQEJfBurV4nI3rmSkmtOyMkff
         +tiZf0R2Q2mAIQfUwx/Ub4bCGEwKEOjTM+RuWoEkZZwVSAqktcICsriDkx1GPBIS62WL
         o5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732896255; x=1733501055;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRYCaR++kEU3PDN2eQ+b+5uSQTJ5Bb61ApyC7HopWXU=;
        b=CIt4/D7Fodd6s3MqrvSQxytS1eElz6lgAZe5oQI8K0xHaaR7IstvfqvhMRB02xBxQH
         DfWUtzeV01N/KtLIx3zvhKv0OwyDn6KMTr8Xs5CUd1nF9BLutwF3M3LESDGbZZlanWdd
         M3L9YWSM9Q2gInmgHy3oShFBR9EC6Pf83Gz4jlcaU4mOMze9J+kO4YYDRsBtYrLsx88J
         AOhOxckGGF6b94EplYlRDRhLQvXlFLiPQDh2tbySi3ZZq5U/MHiMe3HrB4fvCpMt1w8i
         CZRQZGqCQoHJTiJiPbUhiioeOqe0UopknLz9UHbZKWYUJQD5+pepY1a6dxC4LO6Gbxk5
         jEow==
X-Gm-Message-State: AOJu0Yxe/FYDXSge2g4MQg8zqvklbHsiIDUpyaC+vsQiFil1C7nrWsiF
	Vy3Ic3HfnJI4zg9T6OUuBJssJvHL1kByupPfIZQwadDbWHTlpi9sVcGQ9pWfWT0=
X-Gm-Gg: ASbGncuc0SLgfSssy0UYKH2SpTrRRUReL3M4F4MfWeAfFrElWMVB8Qx5GG5p9/XR+OM
	merBGFsdoHVqg04P7PcTdaB6N71VKne4Lt/0H4RYW/MhiVXuWNqeVCNq5ZIQMgXpIZ0aCOMgU9R
	X8uyXnCecNj6ZcTxzcvOsbvHzfQlA9q6xZYWcmSPvl/oZH0YUOuFweFlJjAa2mDpqVOGw6R+Jnk
	knDyN3uFM0xnvfyE2z84qvuAXncVxegeJxT8sw/rQ==
X-Google-Smtp-Source: AGHT+IGy1chS3Zs1DmbJsFkawdj66lilvO7GzDHuIuxS/pEbGyD3FpT+qxCo038R1fV7cDy/7R55Vg==
X-Received: by 2002:a17:902:d502:b0:212:6187:6a76 with SMTP id d9443c01a7336-215010960cfmr158548025ad.14.1732896254809;
        Fri, 29 Nov 2024 08:04:14 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215218f46a1sm32302925ad.39.2024.11.29.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 08:04:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com, 
 asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org, 
 jack@suse.cz, viro@zeniv.linux.org.uk, Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-block@vger.kernel.org, gost.dev@samsung.com, 
 linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
References: <CGME20241128113036epcas5p397ba228852b72fff671fe695c322a3ef@epcas5p3.samsung.com>
 <20241128112240.8867-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v11 00/10] Read/Write with meta/integrity
Message-Id: <173289625329.195012.12251484320092641789.b4-ty@kernel.dk>
Date: Fri, 29 Nov 2024 09:04:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Thu, 28 Nov 2024 16:52:30 +0530, Anuj Gupta wrote:
> This adds a new io_uring interface to exchange additional integrity/pi
> metadata with read/write.
> 
> Example program for using the interface is appended below [1].
> 
> The patchset is on top of block/for-next.
> 
> [...]

Applied, thanks!

[01/10] block: define set of integrity flags to be inherited by cloned bip
        commit: f64ec9926ed2fb603acf4fbc73c09ba3f68e271b
[02/10] block: copy back bounce buffer to user-space correctly in case of split
        commit: fcc1f91de3e3cf013e810183cb6d333b09fb5741
[03/10] block: modify bio_integrity_map_user to accept iov_iter as argument
        commit: 465f05a6462bb67ff51c663759ca9b4952718205
[04/10] fs, iov_iter: define meta io descriptor
        commit: 3e73053699fc91839e711c75d87fe3da732a323b
[05/10] fs: introduce IOCB_HAS_METADATA for metadata
        commit: bbcf8cb45e21c0a4d4afc45fac6cc6b97e737d8e
[06/10] io_uring: introduce attributes for read/write and PI support
        commit: 0ff16f75c747522b403ae8a23513afe354f98fd7
[07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
        commit: ff19426ed1a805571f2a9ccff7d3432b57f4725e
[08/10] nvme: add support for passing on the application tag
        commit: 77a3bcc5847683baefd340f615a51e4fdaf9208e
[09/10] scsi: add support for user-meta interface
        commit: 1c1d47350d4eb585e2cc8f010000225b6a578322
[10/10] block: add support to pass user meta buffer
        commit: a757ddcd74c4b78403e4b46080de6eb73a17ab9e

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-8716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 649C3B0AA32
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B78F7AE905
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA032E7178;
	Fri, 18 Jul 2025 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qw6MQ+yq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAF02E7F06
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752863791; cv=none; b=rNeRFQs64OklJgydo97A7WClk1XBvbvOoMmyy2N9xfdc0gLLqfd93A22MdpszsPxn/RKRrfhXI1elH/4pAAhQ6rrkHFQvl+CcW/J+MODNRlWBLGqs5qc75enQzYQmvG0m5fJdWKaHAKsrExdzPhrP4n7f7IweuXIOqVodh2qVUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752863791; c=relaxed/simple;
	bh=HmaDJ6KK/j+23WfgCx9P6RwpeK3ivPr/AAAIqHCjyXE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CZgTgHfKQxwlb0TIxR+kUbpUs/Oy5lq04lYLFjsbjvxnmuAGgHNenx1ek449RGUOHFJDQGbDJ00x0sOnPqUbYcgEw3DLzpGD3fOV0CWy+/9mZ1PmppnR0WrT/VjVDvnqlJiPiguU6OlHVM1kebkB62synB+MaXpfEb9iC0yWR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qw6MQ+yq; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b39011e5f8eso1959007a12.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752863790; x=1753468590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ypu6ZHCyCszmGrmZOwZT0mlh993mGs8sK1TJDH55uDw=;
        b=qw6MQ+yqr6YxfiGojuoH29i7u/r/IjCUaJNQ+lekfuOy+6dH8EdG8hdOgfe3s6NyJ7
         gCP9UF43bjRL74cYb4eRUEBuWdPBLwTQzE1j0yd24BI1pmugxjlN68KUQCWO5VVAm1Ir
         jtnqHwsi2lwMznm1G+5mKQdaYDdcN5vsRwqIDjmjPGE+TgQY5iZrK2bs5d6PzNPEg8dr
         6NJJApLyTaWMhGL1JAlDKUU2Uz8X9gO70ki7O9SLaNOck75R+I7BoYLH33/txV6jsj/F
         R61UFXxizZrBH/F37DHl7nHAb39uRP7WSxYqM161f36k48MtajFykwviJOGe7Jw/3j2+
         lgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752863790; x=1753468590;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ypu6ZHCyCszmGrmZOwZT0mlh993mGs8sK1TJDH55uDw=;
        b=kLSMTSUHWtZawq3C/sFhx+9NOEWiWt2Kwk2MLjiVA1GYapkL54khC7YMH2gFgomr7f
         BC5wY8G5ofp6vzsWO/QGJMl8sKc01ycxxHa/CAHu7sfipH5kKvAdmzsJnChT52mFh8Of
         DIHH0o/2zw8To7/NteVMp8z6G9vaytLzq8l3w3k/UmVMQufu7dkzJfg52Xpd5alZ1hM6
         n70d0ijJJPaHPxDVbwzUW9Mm856a6JtUO7T0I1ey+2vLaCYe/A3c1oraKa4kFVVklqg2
         nTLTtwZe7C9jfsYV46DDirUsKCu5nXdBEqNkHJuEoWJ1+kP4joh1Gu6394fXrshrSWoU
         lqYw==
X-Forwarded-Encrypted: i=1; AJvYcCWEQoMPncU5xztowFpGAWP8gbSXbOGAv0wMZZIabWiXGBAwTLOEHZjd7moNGb23bYtp2rWimIHqpg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi4joNFe22XEaEKTS6Bj7E4j2AhPz5DRJXmVl1zpYJ3mPOQ2am
	nJIFxoyf+SFC+FVks3R3t2pLGvBHvh9HknpFSY2UrxSGCSh2jK9gmKCt3J/GNsOj6f4=
X-Gm-Gg: ASbGncvGEetDkmtLVQzbz0W7rsxiiVKwyY1agaB51QpPZj0wrcdGTH6XRavhmyufXJF
	omgQ6aPZ/EipVrJwgjUG/okxl2cba2Gmy/wBZTr4n2FsYAadzkhi4viQKSoT18L1QwEB/llGV0i
	HfBqkLaWXZdZWoXhkv5Ls5WKGZzyF9TVtrv7/ujiHTWPxKzbFhwBpZ/OIrN2iLS6IvIYBvQcA5x
	7LGdSEQhFYDsBWC7EV9VtSSC1w5+KmOwk875MoDZxkwSdmop4BaaGM35whH/m3949zeVV21dgSX
	1mOHxIgjJIlbfDY+INfxIlULTAiWgGoS5gzz3DhJL7pumYamb89zUBEZMLvOlN5QmDULaDN2b/3
	wATtVTJI27Ixv5V47uu0pAQws4UiWCvWOVOBHdAHeI5d56XwVVbzmSv8=
X-Google-Smtp-Source: AGHT+IGlsDntYJxObfrXYgVH/QPpuidAJOMArNU0943U5rKRF8s3x8qPhf9Yje8PPd+9AhltaJnSPQ==
X-Received: by 2002:a17:90b:254d:b0:313:352f:6620 with SMTP id 98e67ed59e1d1-31c9f435558mr16657207a91.4.1752863789743;
        Fri, 18 Jul 2025 11:36:29 -0700 (PDT)
Received: from [127.0.0.1] (syn-071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f1e6a68sm5636796a91.19.2025.07.18.11.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:36:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250708202212.2851548-1-csander@purestorage.com>
References: <20250708202212.2851548-1-csander@purestorage.com>
Subject: Re: (subset) [PATCH v2 0/4] io_uring/btrfs: remove struct
 io_uring_cmd_data
Message-Id: <175286378826.415706.5386510015448817454.b4-ty@kernel.dk>
Date: Fri, 18 Jul 2025 12:36:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Tue, 08 Jul 2025 14:22:08 -0600, Caleb Sander Mateos wrote:
> btrfs's ->uring_cmd() implementations are the only ones using io_uring_cmd_data
> to store data that lasts for the lifetime of the uring_cmd. But all uring_cmds
> have to pay the memory and CPU cost of initializing this field and freeing the
> pointer if necessary when the uring_cmd ends. There is already a pdu field in
> struct io_uring_cmd that ->uring_cmd() implementations can use for storage. The
> only benefit of op_data seems to be that io_uring initializes it, so
> ->uring_cmd() can read it to tell if there was a previous call to ->uring_cmd().
> 
> [...]

Applied, thanks!

[2/4] io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
      commit: 733c43f1df34f9185b945e6f12ac00c8556c6dfe
[3/4] btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
      commit: 9aad72b4e3f0233e747bb6b1ec05ea71365f4246
[4/4] io_uring/cmd: remove struct io_uring_cmd_data
      commit: 2e6dbb25ea15844c8b617260d635731c37c85ac9

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-9856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97596B8C82B
	for <lists+io-uring@lfdr.de>; Sat, 20 Sep 2025 14:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBF237A2BD8
	for <lists+io-uring@lfdr.de>; Sat, 20 Sep 2025 12:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94222343C7;
	Sat, 20 Sep 2025 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HLN+SG8v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316051DA3D
	for <io-uring@vger.kernel.org>; Sat, 20 Sep 2025 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758371228; cv=none; b=cGFpo1CeA3e/o8w+H+n5Qjrd2LhO3CqsDcVWaMAJsG5pIJdv6IXd1OMa6sE+gU923htgalkxImBwktpZNhmGjA1P3nwYsyDOMYmKpjWf4aEdcepMMGd32eql2mRofVcYz9aHzdCPvXAvfyjx2m3U5gL8XDYQpYjUU6FTdp9scnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758371228; c=relaxed/simple;
	bh=g765CtLUMm218O0REPR8x/tSa/Hz2dkBsR76yTboZuU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Zo8QbTGKEkmyB1ca9KrEt32Rv4tg1Y+IeTO8gWYGkpfFWds4YUonMr5CYN04iTpPOMl+qm4LOLIOkMxqBI/D7LBIlAb6bfPDvYuu8tR4S1c+8EzdnqlIp6lYdCmyu6WW+2qhJiXyCW8TwHfOyL2mePbHSQmugSkf0GTEiBOr5Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HLN+SG8v; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-88703c873d5so106107439f.3
        for <io-uring@vger.kernel.org>; Sat, 20 Sep 2025 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758371223; x=1758976023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DrfUnZZt/eEE+c2HKV6AcescbyTYRdkE9YUmVIx7oP4=;
        b=HLN+SG8vDMevFeo2w5MGEXW9hsspRw4rrn/UtqRHpcr5dllv0UQc+2a7Sl/BoTzqDz
         QV5e1FNqBfpo7UvgcaQ2D2/uEk27F4m+XxHT5no35kFBmXXdV65cIy9E0quPjCiZo50c
         X2P78pQc/N9LfIrzuDnVKwzuoLUQzFhPiiNpjCBhXkJIc5WadYR3DKNEgJJuU0oWEX1a
         wsNkr/h6POFdKLs2T3IibaEaVC4gGaCEueox246wce2OU/zgAUAgIl0Z6fgafL6M4Q2K
         ISFFiwmWpeoPKNhgU4BgK6qwEFMMKDgNx65S09Hdo+c0I5gZJBeqHw2U4D9GVFEUf/Od
         JNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758371223; x=1758976023;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrfUnZZt/eEE+c2HKV6AcescbyTYRdkE9YUmVIx7oP4=;
        b=DPlcC8lOyOqo2kMDWiPKpngcU91zN1InjDRs0AXZidpfxmcMXpOOTxpx9REwz8B/n5
         tQuGKsMAkcQo9va3A7ifvxCyKbPn0CW/lXTfypDpLIp6PqKgXtUr1ZN5j6/EIq9XAHa0
         ygKmrw+RFZXyH7YL5iCYRB9aVN7c4bnT5UGaCtv9fpQix7AlpDOOs+vp7RSDGvc+T/ka
         BZfaN5vGBNj5OBkFsVFs0UMBaJ9MSrQ7xkoNNf9Gq6sSP0KqPtKW8abEpU80snY51Gw+
         XfNZDiEuXtclpwJCFJ5Zyd0FexXcKEavFYSR/h5147trvxGT8j4ZswzIZ/2MSgQJrBxo
         k4vw==
X-Gm-Message-State: AOJu0YxoJI495okfdt+8Rh+TzuKEfOGY2GmTLmx1OaEwCs+HaP5DvoU6
	A9y7FS50HTc0B6KtYCkuxaPybCmgCrl6yccEPJDe4A6Ap/bO0NjWmOyQWrNkHrHcCT8=
X-Gm-Gg: ASbGncub61O8K3EvgFr5latkZdZon2CpKwEYDMCL4GRnJpJMU+PROB5eUbHuIFGNJZq
	RIRuPl8+zOlrCIrj0MBec8yk7oYj7vEhEebNKWjNHr4+gTjshFjxrQ6MjBDqDpD4NQuQQ9C1Co6
	B0M1rWX8C4OLRjwpi9gm4hE414Rzjri7wZ/ofvFYe7rDyUDBjNjOSRe6Pa+7snH7jgR+VOCJrFZ
	t6jQL/HWDo/N9v7M5O2L1qBfNutN0yQ4C4iIWtiN61JdLPQDjewxa+IB1howRn+wJgnCIkdcCbl
	ZQxEj5IiS6StvFd2IwyZCgl/mCYaWLJpE2L3Jwxi/uFHCxkPq7h53lkQI0lPxNMT9se5wRs+XXo
	Y2ROT9/McQmFM4eU=
X-Google-Smtp-Source: AGHT+IH6PbeinWquegKHF83mRTyDVkSGqVhQ4ja3n6ihc8w60BH/rghaqqrTzmm+v4fm0MbhAmg2gA==
X-Received: by 2002:a05:6602:4887:b0:887:45ad:fcc6 with SMTP id ca18e2360f4ac-8ade617b11dmr1074725739f.15.1758371222963;
        Sat, 20 Sep 2025 05:27:02 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a480438b98sm265068339f.21.2025.09.20.05.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 05:27:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20250919193858.1542767-1-kbusch@meta.com>
References: <20250919193858.1542767-1-kbusch@meta.com>
Subject: Re: [PATCH] io_uring: fix nvme's 32b cqes on mixed cq
Message-Id: <175837122208.915180.3165699897517903214.b4-ty@kernel.dk>
Date: Sat, 20 Sep 2025 06:27:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 19 Sep 2025 12:38:58 -0700, Keith Busch wrote:
> The nvme uring_cmd only uses 32b CQEs. If the ring uses a mixed CQ, then
> we need to make sure we flag the completion as a 32b CQE.
> 
> On the other hand, if nvme uring_cmd was using a dedicated 32b CQE, the
> posting was missing the extra memcpy because it only applied to bit CQEs
> on a mixed CQ.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix nvme's 32b cqes on mixed cq
      commit: 79525b51acc1c8e331ab47eb131a99f5370a76c2

Best regards,
-- 
Jens Axboe





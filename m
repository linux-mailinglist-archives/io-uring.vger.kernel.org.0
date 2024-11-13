Return-Path: <io-uring+bounces-4659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 306C89C7BD8
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0CD2B371E8
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 18:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9F12040B1;
	Wed, 13 Nov 2024 18:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dWZVDRJH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57A6174EFA
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731523611; cv=none; b=dtU+yCX+Nx5t58Eew5Ej+FFQL3cRUF3aDeg9uwVKs85l+XCo8RkWoThe4SQrdROp1mv8O0CMe8pOnrfWrhBPKBtjGdF4zXPinsrBNXMYEiiQ01+WKhK1mtBAS7qM9mq9/ed5yzpMho0KPtd6+EB0BTE18UGnowiNRgylGRFjFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731523611; c=relaxed/simple;
	bh=8RXFfY/QwFw1iJc0lFBsu6djRAxjqHBrxSI6loa3ifo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oiak47veaAyjdelMvxAvYVXeA9sJIeMBgiH+IaGxsqbQXwJVB0P948AQg1SjDopRFzhlRIfojE7iJCy/cO3zenuMt3W8UWN/tdKIcPYcWlokAM0zbfcX5GrWg2sUUuWjj7z0V0bwCKrLmIs2OVP9c0AXiNTWqaliqhyNIr7GYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dWZVDRJH; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-288d70788d6so3139021fac.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 10:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731523609; x=1732128409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6j4wyvW+qjOuARZZJwh1G4pDZjq38FdBGsdmUpGeUg=;
        b=dWZVDRJHSSzrWdwEJ3S4iWXEeksE3UAi1Zv93ci/Fcor0ysgQbTXV1Eae7v1q1SxIV
         OHm/Ga6z4iE+tzsO+x96JUOmiszBwU4vpN1ggrTlqd3TYRiJVLK/lBZcmeEaKIrPejXC
         K66OqIKLF4CbGBGz4KIPunVZGvhAFOZVPzOS2Grd+H+2v7Ts8MX8Y8Bu2uNMdva/q4rw
         dU7LgwEkkUBIUyuglMVAWECf5rtx0Pqk6CKXulxntQOiWDhP7KkiSlAyvtZPTXyTuc0g
         WEzXgezDiFz7Jk1ZU0lisi4SxotKMv3XTZBiInpxilfvJI66wCLmDa7PwnO3C2oqC29Z
         TcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731523609; x=1732128409;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6j4wyvW+qjOuARZZJwh1G4pDZjq38FdBGsdmUpGeUg=;
        b=IryDe1HwBQy+fYrH7L8/7szuOysK/FCDUK0JAMsgcTiZ9jTGmYPU3X7OeghaXmVk24
         eA6dM7xNGZTZrj6/1PTDFix3Wk1C7MuvaROCLZ9IoDT2JLmjJSCh8424FcpIwxQtsGBn
         ErvllWCiXNPAryc7Y+8/jzDCgSae9e6K6Qegugk4ihX3A1c0gEQe4No94oFb5xF6/jQF
         GRMF4jEzb9zDy42XpeO0EfdelmOXCJCIFec9r9p+yKBQA8KHbr2240lcKJn7DgJ5m3Li
         ElqONLog+yf2NHychLPVKZdrTmaLLU0EJUPEpb8hfPs5f+MMIkbbC2bQomVAZEgJ/b2p
         oyag==
X-Forwarded-Encrypted: i=1; AJvYcCU27BJdiTxviUuVehKKuKDmV25wr2T7UqOm1xgZfwigdg6/OYOIeq7SNGYgS4Ii4l6NL+zI2nmMnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyLYx0Q91zOVn2N2PTUpLTj9D2CHgVRhRUhaD/Y5vGD1GOKpVk
	xlzCLfZOoYYTNHESyTuwJb8/5xILzN06fiyk9VNg/oh4ncFEe3a7/F0icvJQMQM=
X-Google-Smtp-Source: AGHT+IGhW5wNVuxAhg949qECoPGMVp0GIeUGc7cEDZZJFiXO83xP2SEoIWQJzy2xwUop4HsywD6gWw==
X-Received: by 2002:a05:6871:811:b0:277:d7f1:db53 with SMTP id 586e51a60fabf-29560110330mr19601816fac.17.1731523608778;
        Wed, 13 Nov 2024 10:46:48 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-295e92afbcbsm1023381fac.40.2024.11.13.10.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 10:46:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
 io-uring@vger.kernel.org
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
References: <20241113152050.157179-1-hch@lst.de>
Subject: Re: don't reorder requests passed to ->queue_rqs
Message-Id: <173152360771.2243093.6096591698137056565.b4-ty@kernel.dk>
Date: Wed, 13 Nov 2024 11:46:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Wed, 13 Nov 2024 16:20:40 +0100, Christoph Hellwig wrote:
> currently blk-mq reorders requests when adding them to the plug because
> the request list can't do efficient tail appends.  When the plug is
> directly issued using ->queue_rqs that means reordered requests are
> passed to the driver, which can lead to very bad I/O patterns when
> not corrected, especially on rotational devices (e.g. NVMe HDD) or
> when using zone append.
> 
> [...]

Applied, thanks!

[1/6] nvme-pci: reverse request order in nvme_queue_rqs
      commit: beadf0088501d9dcf2454b05d90d5d31ea3ba55f
[2/6] virtio_blk: reverse request order in virtio_queue_rqs
      commit: a982a5637e91fd4491da4bb8eb79cde3fed2300e
[3/6] block: remove rq_list_move
      commit: dd53d238d4ca7ff1a0e10eb0205e842560f1394d
[4/6] block: add a rq_list type
      commit: dc56e2a78ba20c472c419c6f2ed8fb7d0c95ad90
[5/6] block: don't reorder requests in blk_add_rq_to_plug
      commit: 05634083a304eb3d4b5733fe8d6e2fd0c1041ca8
[6/6] block: don't reorder requests in blk_mq_add_to_batch
      commit: 65550dea43815d01f45d7ece38e458855d5e2962

Best regards,
-- 
Jens Axboe





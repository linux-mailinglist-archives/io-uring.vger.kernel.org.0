Return-Path: <io-uring+bounces-7599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F898A95390
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 17:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C7C23A42D3
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 15:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17B31AAA1D;
	Mon, 21 Apr 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YB1Kllg5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4A84039
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745249200; cv=none; b=MPmCLNvqyR1VDz+Y+G85v5JyoXpqYkYsyelhlW3cX5x+Xiwr7qzk0E4Wncs45UtXcCB0frcljDbNbSQAGoqjC2TpXjaeE0+8kOvKEsFwkwyzR+MjMjASZ21IIDMevuXho8pWWGSCsZKzFilrPAaMqGr0HHyoPPB3U6PPCLRelIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745249200; c=relaxed/simple;
	bh=wF1cvRcQA8OuE7cPLgILoFQYSfKmmd6HUNWL8mmxJTE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=phkWMHnIcW4Y2x543qok0K3RZcBrxK0rgrnDh1n9yhXD0KGwD9kZ1jrcw1aCxSZMwDK2+/HhR6wGhySLxUf7B69dvu6FjEbzb36V2Y3NG7yOdDCdlIJTem3HJok7aWIyAmXDuuY620aTO5sRiranG2KsL6CGx1WAAgYSELsIYts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YB1Kllg5; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85b43b60b6bso106717239f.0
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 08:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745249198; x=1745853998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+J0bzbJA/HbZe12SWmVxLtZCzmpQd9s0ZQsi18wloA=;
        b=YB1Kllg5uYYhvzB/zW9nay3jbHLQcjClW4CpKMwpH9EK9z4kJCnmKtnUzqf/Bz13J5
         a50ys8xdyQyJnbpFhchYPB227rRF1BokFT4SecdGqEOIZIvfvTJchxt8nojE8x87wp5M
         YCiHCowydFbaGs74capUc+ImS3evz/cbsX3Wdd0v8R2PzFwNEuxwXC9uh7jvYziWlqqn
         ksiVc5hwjVuP7UB/W1OaJWmoTdMm7RuquUaMPtvpWTDnujx3j3bGWpP7r/LffLbGxa0d
         ZGXQ1YXeLmZ+mqINpyvDC9c/sYctBAQiZUmFrH6QjauUaVe6pgZx26OTgtRw87t3iIgE
         V9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745249198; x=1745853998;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+J0bzbJA/HbZe12SWmVxLtZCzmpQd9s0ZQsi18wloA=;
        b=k1J3ceMexlI6ydwMs0WGyZ3CKZFY/c24RXmbeoQS86k3BIGUD2RE6CIrG+EO8pgiaz
         +Oc5b3UlIfNyFaSXqfuKzoGyhfI3hpQaZLi6fH0ErvYYsIhnwaXf5hJtMP8JmSgDO6df
         SMN85EjQ7mFVbCwU5FmhnUVt8zIte/0G2ZfNA6AiuLdmLh4GUEisVowagBk3kzMiMmSV
         gYo0fC3Q8cuhMJ+yCh1uT8PchzOkYaHGhwjdJkRlYjpKMg2C6TR3tZwfuvEkCbPk55r+
         obXrl7oIqSRq7wlkw2iFBodxq5eMOPgvxZmcRG65ZveULlJPG3XkgvgT44SbHd5DSuY3
         erkg==
X-Gm-Message-State: AOJu0YyH7seGVPJuivP6Nh3hF5JCkUA3e/14GK69V0wR2WNXHGg1t7Q5
	0wfobIBsq64lDKU0GlM1AaK9n/bKM9TvA1csQTMKwNdrZ+qr9dE0TD/+ZSMwRW/jNr0ME3ZVSv4
	q
X-Gm-Gg: ASbGncsP2JEc+XXlmmuqwTrIM0isAn65YCtsNFIrg1i2V00zNcZ3qfVB4qFvMIkXGm8
	SrXCnQJ8E/V0EtYIr1tsCADARPrQlXKjxViDndyQysRgY5mTc90TpjrfS6nBqhAWW+wyumXCanF
	ACEOP4KGJkpx7MmoJzFFEocqfkaN5QJ4LdkBR2/GmcEav2OieQOYrFOAZemFDgmiDAKZHHZwQ+H
	HXoPAGQ7guHTzNzNpz3fXsajrawqhHLqEMTMecZKZMkdtjB9jchp9kUo5HK+FKzpS75VqsP1W66
	XnTMTdp+ZrghYbYsLI1mX/SFu8NPsGk=
X-Google-Smtp-Source: AGHT+IEL880l0i8RD+FQFAqV3Th70XaBaazGlgqhxXIp0iWExmVwsfeNRD7dSZzPcfrOdQZHNHg+ow==
X-Received: by 2002:a5e:d718:0:b0:85e:22b3:812b with SMTP id ca18e2360f4ac-861d8a19580mr1062862739f.8.1745249197870;
        Mon, 21 Apr 2025 08:26:37 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3958d60sm1800076173.114.2025.04.21.08.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 08:26:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>
In-Reply-To: <cover.1745220124.git.asml.silence@gmail.com>
References: <cover.1745220124.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/4] zcrx refill queue allocation modes
Message-Id: <174524919703.915029.9986070319607696246.b4-ty@kernel.dk>
Date: Mon, 21 Apr 2025 09:26:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 21 Apr 2025 08:25:28 +0100, Pavel Begunkov wrote:
> Random patches for zcrx. Path 1 removes oneshot mode as it doesn't
> give a good example, and Patch 3 allows to kernel allocations for
> the refill queue.
> 
> v2: rework oneshot/size limiting instead of removal
>     fix flipped allocation mode check
> 
> [...]

Applied, thanks!

[1/4] examples/zcrx: consolidate add_recvzc variants
      commit: 17286dbf9017ae6f4c864216b59ab9919268aff6
[2/4] examples/zcrx: rework size limiting
      commit: b10430f9b004a4f1f54c1a4721c80ce3a98996a0
[3/4] examples/zcrx: constants for request types
      commit: 8cee8f8cbf9f91c4dca9298159f2c5c64f898080
[4/4] examples/zcrx: add refill queue allocation modes
      commit: 353fc7dcc61e059ac8890916f41d39df10e5bfa5

Best regards,
-- 
Jens Axboe





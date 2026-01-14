Return-Path: <io-uring+bounces-11716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C82E5D2080E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 18:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C063B300BA2D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 17:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F6E2F6903;
	Wed, 14 Jan 2026 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="epo8Jnh0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3312FE058
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768411134; cv=none; b=GWIz/XGTxRS7bklVe/11ZUUBG0FN8cyRdlyOn76znSJ3Zno1mGAtEDmRjVBre/SQSDm3GPIoPQIoLXQzydLFlv00bLabtuyiu1iDd0cqezzBYRFI7h1/cQ4mEqP0F2F+jN/2NChYVoIAIVT5OkTLx5m7wpzG9invfCxf7OqVNiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768411134; c=relaxed/simple;
	bh=mxl3Ipzdw/b/hz8fYLTH1gbjiA9vocdLe9R89SiqV5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=idrfCh6D+l3+Td9smHP7ldKbo0U2ipZq5UjoNqew363apkZDRPR7Fo7d9ZTTBX5DaR2FltkNKtmhjjAwX1/mlZroi+fJTS4zquNAWeDmUXo5TYhOUBmscIfXQzabrhejfyHvL5YsGUU363vtOnyhpB2gHJWxZt5tA3Hal+1l0a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=epo8Jnh0; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfd2be567bso13506a34.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 09:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768411125; x=1769015925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YAWlEckmPq2PSM6zAc9AYSjzTMqKbebhNRk5WWnTRg=;
        b=epo8Jnh0ilZG8K8Ere+loMNWPnOyDLVFEojBWC8uKkeyEa2l7tZpVKRXR4KinOmwTb
         5wiemTZFFIVu8gPw1HS2YFmro9ClJKGEh98Ol7o6mqIxT6XdbMnaGh1XlJR4mXnRlEFu
         lJ0Zqq6iD9NL3jAwjCymQTx2qr+sjxTi0NkJbKoELSd217zOFTiEwKP5it5lCapOEJyb
         D3kRIUDoNerp2ahB3RklbITdW3eSWQkJf43vC+TO0PXJQAvYTbwAC3TxXDalQ/NbcQV+
         4MrtQgprDuDkpmxz3q5lLSAoZFQtfrdp1pW10NtD2R6O/TU61u1bw/reF1Wxdq8wqY+q
         eAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411125; x=1769015925;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/YAWlEckmPq2PSM6zAc9AYSjzTMqKbebhNRk5WWnTRg=;
        b=Vwrzg+ulloQXGIVXkVL9W59N9O7vdiyBTMCxEhGGR7UhHZiaNrUlUra0vEYbelJDtl
         J+OLY3jrZQj30TEvINXBtWZWP6VzB7IhgzRPIvw57+ehlVAFJYYUFJJHJSTv98n5ulhH
         hQHMvi7ACw4ekn77SnvCy379om+119ezFWq5WzuE+diCcr0MOOFW153TxxERGhmKeeQB
         Gzc35Yjf8Vt5Se4a9ZvbjegXVity1JJDryCursJQsRHgsTnj+eq9dR89t8MkD19M5lKd
         BM5difo9BwHPz1uS71C/w1SXaqq2jJhTKfU7658v0ambNvG61OJIZKUYWj1X+c2ykQIJ
         BGAQ==
X-Gm-Message-State: AOJu0YytTeLaJXXx6ITQNSIjjYUdpDpNjMvaQLieC0DPp1FY8dVyuX/g
	7Jf0ct/RLjxsUdnrjZi/XOAf9Eipck9TdOrja0QadWnbEl1vPNJRiV/ubIsj5tlly4o=
X-Gm-Gg: AY/fxX4nMSBOn+Thbbi6hdCYDHk0zu0Y93qUXm3Ur3cyelrb/j13EaLA695Ya6tP1ra
	Kra+X9i1gyKi3BD+1R032dd9Tr38G+X6VwulgdHlhShFgpLkiKRc1396flqAkHO5/MpenGicLjK
	MnpFpyVB278+ey9yQyDtzU8mItPVaraK8vnI1/5o6NerHvMq7+AS8jOOxS0AWdS4I+EWQZRy9Oi
	UZ0+Huq/Bu1x8h+uXmZkumFKnn5VO0uSVqM64IeK8UMnymU2YeLpn08VMEe2y2SgMHl9o85Gto6
	k7/GcsT6zFYdBCU4OEoorMuTCigLWkRonjh8Uw84kMy0wT94+d3MWHKEEMTQ7/Hlo6ygUvRsIFm
	/1s4yiInPObwr+D7OMy3CveXq+gpVnRKgc/XU9mJWq9RkTirloqqCI2f6Pm59VUsVMmseaaB+Tz
	1mIQ==
X-Received: by 2002:a05:6830:2691:b0:7cf:d19f:7fc5 with SMTP id 46e09a7af769-7cfd19f807cmr777569a34.37.1768411125217;
        Wed, 14 Jan 2026 09:18:45 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee668sm19425130a34.29.2026.01.14.09.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:18:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>, 
 stable@vger.kernel.org
In-Reply-To: <20260114085405.346872-1-ming.lei@redhat.com>
References: <20260114085405.346872-1-ming.lei@redhat.com>
Subject: Re: [PATCH] io_uring: move local task_work in exit cancel loop
Message-Id: <176841112450.443561.17209876764056331154.b4-ty@kernel.dk>
Date: Wed, 14 Jan 2026 10:18:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 14 Jan 2026 16:54:05 +0800, Ming Lei wrote:
> With IORING_SETUP_DEFER_TASKRUN, task work is queued to ctx->work_llist
> (local work) rather than the fallback list. During io_ring_exit_work(),
> io_move_task_work_from_local() was called once before the cancel loop,
> moving work from work_llist to fallback_llist.
> 
> However, task work can be added to work_llist during the cancel loop
> itself. There are two cases:
> 
> [...]

Applied, thanks!

[1/1] io_uring: move local task_work in exit cancel loop
      commit: da579f05ef0faada3559e7faddf761c75cdf85e1

Best regards,
-- 
Jens Axboe





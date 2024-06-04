Return-Path: <io-uring+bounces-2094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7338FB404
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 15:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3C7C1F21C38
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 13:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5950F148829;
	Tue,  4 Jun 2024 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZbRn8Ink"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7D1487EF
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508333; cv=none; b=l++sK6WDfporeeEOflafLfcJVVRMhJ9LRbsp3anN4Iz29K0igFplL/r+ss9lhbMFINtAIZ0Qe3kqq3ycXgaMEhTyGkbl3qjdn6bY6bpUrdsFdFwo+MutT6kouOM2xYZYPIVTGDYnYEM80prNp4YDAP+00a3u1Q3vlwSrRFaqPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508333; c=relaxed/simple;
	bh=z061h5N4cOjxp0i0teiEj8YYz0gC70c5q+yIiMSWVlc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jhWw7IZ9QWRJJOmNdzwE9HvPS8YNBYzQDzZK8IiEUoPE8r2exmTdRiHMjbtlFDnqB6kXDLOGADhB7qDeB+8XPEVCKHvZ+d7qZgf+FdwwilIInxB05YrafBrWchk9iQWRtjUIpPxnfddLJVafAUyNQvswoNXehK0bNJzQNQatJi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZbRn8Ink; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c21571e99bso384802a91.2
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717508331; x=1718113131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qm870wbxwKAXLW/hEbj68HKPTbDqTHobkkHTbGwT1pI=;
        b=ZbRn8InkM/yAq+6lN7nUakNV56FZEUiB8qHHOADHkydqyjliWLjQAhbebFJJmbaqaa
         6xhECJjyt9Vn1saSVSZCn0CKB5x6d0u+0kpV2VqZKFzKu8Mxk2eOFYqg0ovwCbcDlfXi
         alXw0mVtibxY0b0UkPa/Iu+0vxg7fiWtMjrbjQNTL+u5X0+LqVWJnw4mzTMkUMmDCb1k
         FWI/xVeg96JrjAB+UKBC1InO8M87kImYbR1ATZpF/GvBd0dLKoZQnY9+ORjOTMxMKQGU
         FcqaYVRhECHkQ1sdOU3+smFVNx/YyXYFclNSlIdfBgl4Rl3Vk1hABwYwHbNjEfKgz+/z
         casQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717508331; x=1718113131;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qm870wbxwKAXLW/hEbj68HKPTbDqTHobkkHTbGwT1pI=;
        b=IqrTWL5VeeOAq31qy/ztzILjdF55AUXGmW3nCHemVIVslhOQsPruYV3T4ShRQMS1R+
         92u6n6Rttw/6svYI4dZyd6CK0L1W2wZIBSfx0jTx+VHCIZuze+EFK8KU6s6Dw7GfClJ+
         3SugWgyor/uZRZX3L9ORZojVcf2JVSTJaCIaLaJfRFZRuKMepCh1Ybsm8faXgfJR/wNw
         QqqROSbSXFicJ8P4OlCtHngXufhtz2x916ZGRS+9LknCtNqpELJxK20YT+PlC6scvB1w
         VKQmkULEqQZJN8YRlLN8ZL7slY+7Ek8xFQf4A8WVGTdq2uG/YXurTiiMkEaIQyIqA4Qa
         qOxw==
X-Forwarded-Encrypted: i=1; AJvYcCUPEqW/15li0qc4q8c9miRAG3K4fdSmtkdjhy8cd5TSCTp+3zQw9w07HZJv1mOxAvPt87rZK+WAPImlnuKsuoDiXU6RjAII3bs=
X-Gm-Message-State: AOJu0YwtOC9mYgSq0fwCLxoP+oZEXZTU+PxeaadmKI9nGGphMasA3GtG
	wRSSlynXOkzvpsg87fnUY3Ht11+RIZyceuIpbaRV2XUViZtdR5O9RsA+4sUhfdM=
X-Google-Smtp-Source: AGHT+IFCyPdXOcAxAbUdnZV0B5jNeBKi7NZfc4ouIiei2hl2xFOncL1gQsutNL9dfpsGHk3ZKcIuLw==
X-Received: by 2002:a17:90a:ea86:b0:2b2:4bff:67b7 with SMTP id 98e67ed59e1d1-2c253f1ecabmr2134615a91.3.1717508331353;
        Tue, 04 Jun 2024 06:38:51 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a77bab23sm10440745a91.48.2024.06.04.06.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 06:38:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Hagar Hemdan <hagarhem@amazon.com>
Cc: Maximilian Heyne <mheyne@amazon.de>, 
 Norbert Manthey <nmanthey@amazon.de>, 
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20240604130527.3597-1-hagarhem@amazon.com>
References: <20240604130527.3597-1-hagarhem@amazon.com>
Subject: Re: [PATCH] io_uring: fix possible deadlock in
 io_register_iowq_max_workers()
Message-Id: <171750832945.373240.5340875250569409350.b4-ty@kernel.dk>
Date: Tue, 04 Jun 2024 07:38:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 04 Jun 2024 13:05:27 +0000, Hagar Hemdan wrote:
> The io_register_iowq_max_workers() function calls io_put_sq_data(),
> which acquires the sqd->lock without releasing the uring_lock.
> Similar to the commit 009ad9f0c6ee ("io_uring: drop ctx->uring_lock
> before acquiring sqd->lock"), this can lead to a potential deadlock
> situation.
> 
> To resolve this issue, the uring_lock is released before calling
> io_put_sq_data(), and then it is re-acquired after the function call.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix possible deadlock in io_register_iowq_max_workers()
      commit: a59035de589f31f195ed1fff97007d332552a72b

Best regards,
-- 
Jens Axboe





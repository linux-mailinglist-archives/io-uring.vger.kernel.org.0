Return-Path: <io-uring+bounces-10973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF77CA5A52
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 23:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B697312FE34
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 22:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABB8398FAC;
	Thu,  4 Dec 2025 22:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zJJkFeTJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC8717A305
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 22:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764888435; cv=none; b=Wq/uNrvCLbu/4VHroXKb4RKOlxjBQSqpOtnXaOSQDDp8QxBjaZqlSNbEwVN11sPw+dO3hx5oCEBfck5XzkEpg91F63hgnSa/+5BhOh2pHBNhFaz2R5j1VATOTQQsAplJ+PcxY+8tYsw9mvTBGjzij4K1DTF0EodFeHCt5o2TCts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764888435; c=relaxed/simple;
	bh=wWKkp4pCxLDzzWacMAZ/wlAX5ZMyRTmslvUoB5o1fxg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lbNaQ5g9RPqKQyrBdpU9VPzE4y4OWpK+22XY3HeE3Pq7tICW9yITBvGTktm3LqMuXAOplf+krQQ6EcbAgIelMwhh4CXuPvKoLxzwyluTX2+KG0aAbpqFi4mw7IDeqTNj6T+OlsryG/DcOiaAuSUERWF/rG7vOGja5Gf7scVPyF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zJJkFeTJ; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6592e70b629so800353eaf.0
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 14:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764888433; x=1765493233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTiRMSVEt+rzTo152aZXZ1TGCe9Y5teNUF8eQchZNnY=;
        b=zJJkFeTJHyVXKfIFH+jKmypLo/1xpyT7HOq0FZkhxjsCr/uOpJywnRY13SxwmiQs26
         EM7jPfO1N47YvddPbOSr307MTUEWXWnqJMuvUd2pUAOJJ/st5aYneQ5axmf3T4tZ/m+f
         y9AA2gkxg/zWML/MckH/fV6Dq9Hn2GCikOi0tWoHHZX6CH6sjy1v49lyeIHtu9l+KwZO
         KFLU6T9tvwTNJ8/k2xYi/aN1crqVysIXwJFjH2etI3vvwl+zlNB8SE5Z9xWvJ8f27jFB
         ugT1L8oyMH6GEFV9+TCFeNz7RDoATw2QxOFYmTMz9A0ZSUj2vhEoXEL0XtxGLJj7CmqK
         2CXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764888433; x=1765493233;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yTiRMSVEt+rzTo152aZXZ1TGCe9Y5teNUF8eQchZNnY=;
        b=HOg9DAZhBzpu3BAatnvZ+1v/L4EexqZHL/Ynj7u8PFVNwbhi55/Y7dfEZCk8J16zq9
         +4tn9aaryOpABYQrwpIYRhpBoIQMn5RdtOt7fzsXyeWzNt1waUZ8IiZpxRm8A6PqH6hG
         /8JVZG5hbWaPucvKu+67WYxmJuo17zoAuFjZCbRMSsKOAjThcesHOg+OYLlTfOk98l4r
         vmBUkFevkk+QX5nDBKfXtbJ3FP6JuQuUngXh0W+QQ4Y7vFoT1JL3p1BYXj4rSTNpIP5z
         dkg/MwnrQwgxspP5mmT6PY/TCFvd5GmE8zbhJWbxOA099XPedqW6mfkmR17e6jPqcV2U
         gqZw==
X-Forwarded-Encrypted: i=1; AJvYcCXXRiaKlcG3ssPujkQ5qJuFLst2SbmCrA0Vwu3YpMD7tTgklRgrGJWsmRrTD/8zMgCB+ipnyP+YkA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbft+auPBU22yXgVoMPgwK6M1BEMVJEWV6qqY4cerAcdWCouYl
	62pwpM5osjbj+5RMi5tIIYZDKqNHcmY8lmBe9ULeeaVDA8PQsxpi17QXXCoSKtpySUs=
X-Gm-Gg: ASbGncsnzvhRXZp9eBL26QPLAICEPTqKDCsPz4O8/XU0V7uXgOauYCRyVkX0+s0TlNs
	Fdtl3KBVZtDX5t28zpVjvJTxZHSnVPbPgD3XCXhHFxl9W5mlUUznNI+BkspDm/mzBeoRk78700j
	1PX7N4FEKchCcvm3FuMKSJcBWXtcfh4UHj+0++uPk92s76FwlzNQBwzsQnoV7gHjyl7Z421HiAU
	6s6c5+fcmS3BZnxhjJQM6aZvBGZvPlGWyfKYi1UMoSpGccn9XxTFCK7u2GQzyYF9UAJx3PlaVQA
	MBnlxQN0nhWvoKmfgvVtSpGu87cWhWnYvN8cXWej7vOrFyyVbUuKCglNfXjiV2DiptGQY6QWHA3
	FMn+sAfy9MPwcpi6nZEtFkQfqJpnqeIpRqnHrNF9XvUPvHqOBpjqnbU5JJgm5wz3cG4N3uLIRs9
	THRoA=
X-Google-Smtp-Source: AGHT+IHINhwJWBh7W1nVJOHFAz/NFoFactK1GPLNYZl1nsXMnmabx2iqUjxvXfuFUmNEF4Hffh4lVg==
X-Received: by 2002:a05:6808:308e:b0:44d:c185:f816 with SMTP id 5614622812f47-4536e4f7ccfmr4633395b6e.34.1764888432636;
        Thu, 04 Dec 2025 14:47:12 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453800cc734sm1371757b6e.11.2025.12.04.14.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 14:47:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20251204224332.1181383-1-csander@purestorage.com>
References: <20251204224332.1181383-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/kbuf: use READ_ONCE() for userspace-mapped
 memory
Message-Id: <176488843155.1025927.15790018424964919710.b4-ty@kernel.dk>
Date: Thu, 04 Dec 2025 15:47:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 04 Dec 2025 15:43:31 -0700, Caleb Sander Mateos wrote:
> The struct io_uring_buf elements in a buffer ring are in a memory region
> accessible from userspace. A malicious/buggy userspace program could
> therefore write to them at any time, so they should be accessed with
> READ_ONCE() in the kernel. Commit 98b6fa62c84f ("io_uring/kbuf: always
> use READ_ONCE() to read ring provided buffer lengths") already switched
> the reads of the len field to READ_ONCE(). Do the same for bid and addr.
> 
> [...]

Applied, thanks!

[1/1] io_uring/kbuf: use READ_ONCE() for userspace-mapped memory
      commit: 78385c7299f7514697d196b3233a91bd5e485591

Best regards,
-- 
Jens Axboe





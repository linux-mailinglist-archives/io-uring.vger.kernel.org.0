Return-Path: <io-uring+bounces-9308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F068B38529
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 16:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EBA1164113
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 14:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6656021019E;
	Wed, 27 Aug 2025 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yb3eA3nL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280B41F8AC5
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305661; cv=none; b=bUuWu+5+nXp0OmbqMDc6I0iOkkIkvcr+4Qnoc6jB4ugw/nK1e0ysTWFbUbJS0G8IsxbcBcaAOE9Hf2klWzPZ/xwKEMgORN16BDLGO6QPzedyPKjXd1mO6qDRQClNLBQn06Ap2ucJ3O1SrWhENkAAKbkx2vSHrsk09oUXqYUFUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305661; c=relaxed/simple;
	bh=VcCyV0h99WUADxaBXjHoNSU1j+lFTssXyePUgVwi0NY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F79OuVTKLmQcL8pxLdnQrXtvufZ+b0TiM0IcvscnM33amJ1qAajLYlPpcSefpz4xcWBB+KR3YI7dtfsIQu0+9UvRRoU5BjoP9lSZPr7BK+FxhdDGwUXNv8KxVLDYfsLZaGC/PPIIZukC3owz8VPjTp9kYpDWeFLei+j5DFZ0X10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yb3eA3nL; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88432e29adcso175682439f.2
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756305658; x=1756910458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6jss1HK22eg3m+MD1IuP2xt6eQ1mCmZ4ofGe3ejiHs=;
        b=Yb3eA3nLo+gRCdhrzCWhAyFxt43p9EsWDgpHtRFmd8L4JG1NnYIfFUfKvr3b0qhm4l
         cdep6+0H1UM81J65+4c+1A8S1TElNIVR7fDVuRbuubx7rMKiGskPX1VZusUXOPJdjczJ
         i86YazY0TLq/uj+kDqhsIK/uFPeKV5uFOHjPGqEqT+OhiJ3RnUF6jRaKPqB0chCt5r12
         84kjg8RoKA1WZ1M778Ez0sowXyebOj4DqHj9qW6z0dMHNM0lVzaiEiWauxbIuJ/UBoJf
         RLhPPkW0WnP6VWFmOw9lOU+ITQNzln3zzuODlSi7bGzoKjlVDHiGIOR/flh9n602TXuH
         nTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305658; x=1756910458;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6jss1HK22eg3m+MD1IuP2xt6eQ1mCmZ4ofGe3ejiHs=;
        b=sNq/G7I8Gn+vp2NOQ7Ne01TD4GZcWjzwSS2wFa/4XehgdN/sxrWyonafxqXx3VExVa
         5lHBVp19YwuQLxXoVg8IiajNHdffaoQRKW3V0BOx0UT4bRw5pYlQZHkxdXI8SefYhIyB
         57iRcu9nlk8OqPEPTJNB9dJ78v7E9rUWZHKKZgVwCwPZCcbpzRCnh0z0259cbOsGVtOa
         ltycUq2KmMFn1zVk3rf5Gj7dYZqDeOz9CwBeSGf8d2Ba4AzH6G4n4/lYMWIAREFGI72N
         en1TbALxSeqij/NwoidGQcmRbrsNeKPActZq3C9o1D9mot4OzVznje35pnWAWmRkxCCu
         odOw==
X-Gm-Message-State: AOJu0YzS2QQdHIvbxUf+qPJCaRiGrH0RP88+u7c+KvrFMM+aMo8+IX/P
	SQwXIRLdY567Hnzs+gipiq2BZz0yNFOTxJKm+htrehuiZsz4nkT5uEnj9bVEvyOMlwMBwXrGbXN
	mdYEn
X-Gm-Gg: ASbGnctvXBtt1JMdfHON+QR+qEFo+w+AtfXXmbm76UT4BX5+Gmdd4GBy+A78QHfAj4/
	TXX1zDix+k9Ay+FCIanZ16a64+QFtw8AS6gwrB3eLhj53A9w9avFU5XQy3a71QgU5wx4v2bj73Y
	bFHwCktP4N32Ev2GMs6jP/smlcrbkaRe9GhCU9Ha0Ogxq3jcLwUvXAkPoIdRj+9aLNvTxsOEPM+
	fi1okvjGttvvJcXT8BW9uW9xJZFu0v42hzJHBMsvLRn712AedVPkH8V23NC0f2sLDvW0Vw+ajiK
	0pKlNaZGFdohjX6t3UZXr+X9GUdZvgF4GN2l8/LfgteK2ueVGJ5QvNF9utVpqX/M/RmWVvy+4KZ
	hFpBpPHQLe5MajhwNkYouu/kf
X-Google-Smtp-Source: AGHT+IG4Xk4If6wny0cArzGMonADC9U9f3BTYeY/auZoT4YbfvzU+lW//x1d+jW8i+og7Gf8TGIcyA==
X-Received: by 2002:a6b:784a:0:b0:87c:a4e:fc7d with SMTP id ca18e2360f4ac-886bd2047cdmr2208034939f.14.1756305658194;
        Wed, 27 Aug 2025 07:40:58 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886fc6cd75csm76142139f.6.2025.08.27.07.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 07:40:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Suoxing Zhang <aftern00n@qq.com>
In-Reply-To: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
References: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
Subject: Re: [PATCH 1/2] io_uring/kbuf: fix signedness in this_len
 calculation
Message-Id: <175630565742.226956.8766758074257445746.b4-ty@kernel.dk>
Date: Wed, 27 Aug 2025 08:40:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 27 Aug 2025 19:43:39 +0800, Qingyue Zhang wrote:
> When importing and using buffers, buf->len is considered unsigned.
> However, buf->len is converted to signed int when committing. This
> can lead to unexpected behavior if buffer is large enough to be
> interpreted as a negative value. Make min_t calculation unsigned.
> 
> 

Applied, thanks!

[1/2] io_uring/kbuf: fix signedness in this_len calculation
      commit: c64eff368ac676e8540344d27a3de47e0ad90d21

Best regards,
-- 
Jens Axboe





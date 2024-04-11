Return-Path: <io-uring+bounces-1505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AB88A15A9
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 15:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 995C11C21FB0
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 13:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2582A1509B8;
	Thu, 11 Apr 2024 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LC+0coqd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AE61509A2
	for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842464; cv=none; b=eycvnm3gPbvsVZSx4m70omtBf4YKa90zG5Qflx3vfD77Y4HTXapxlFOyRuTEbBPIDH5sE6HTxLMQCwYZR/vXzxT48jtY/vUTUI9AskR880R+lLDFlH7EXHf48vxjbviYg5yDP1RgEsi6HMxJRz+0+z1fM6+VBa0OOWxNn/MCTOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842464; c=relaxed/simple;
	bh=RxBpwU/kRRGgr7s9/OHBVmoLUXFS+qobsZ+FAmDrctg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VxVUk3CLU0XHj5iA+MVBG39VkIDUnNebM7/RBP/qnRBfYVm9ssx16zNjGCIKPpekTB8A30lLDKGSFgMDHP4VCASg14163MCBYC/NDwPv0W8PxFjBOWTo6PhQzLzDLQ2xtNWC+ZRWNVu1zJV57bRplZWCgoSsRjhd4QuBHk3DgV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LC+0coqd; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7cb9dd46babso80543539f.1
        for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 06:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712842460; x=1713447260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV7BST669sfKAU9q9E3PjsM74g2J5F0Mood+knoqfgg=;
        b=LC+0coqdTkgpTbgkorzzXpIMonNy0zuKuSw0ismcr4Dmz9x/07tiIUP8IyJYtuo9Qj
         ysIjv964TxfsfTlvj6NZee6ynVYb38MNFN+4YJ1dJhwkLjZngslVSn77t2LmY/TC+maA
         gMP642YwcMRla0qhzRUMV1KkXESLMN8E6IAYddTiH3IVStA5Ar3aGvPP0KtTodZbhIN1
         MnUiFY8iq/tFasW+Hy5M1X+kfbweBvFqvf8j9M/0uyU/5sCBVNM53adtyOqgoUJWIMSM
         5Lh9u25qsEFYqTZhXAgs8n7t30NYeYI9dzgN2bLKqKnj6lt3OGJT0EFSg9LVPCZ8rKce
         c8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712842460; x=1713447260;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AV7BST669sfKAU9q9E3PjsM74g2J5F0Mood+knoqfgg=;
        b=nhnXK3llNkW9I1+Bqo6f42kRAEoNNyYVDPdWuatYoHRoo+mmb7mNmXqDExmHivbUhC
         PpPyhtyCgSfd4igVbYgbV3Mon9iZdWg92d4a8HAlsijx4gjRDi/PE+PEQTq+GHgZ63jW
         DQytnq8V/BmozGAhlMWQuvFi/Bw+EuM+PyRcbhYbcT245PsdEtFT4Ngc8al00unXqEYq
         MGhr2oX/kbsDNm2j2HpbQzvYWd3NKPSk9u2CFHLaHSoQx14VrmPZ4r2neP7bVSMio9DC
         vuJuTPiPdjnHsl3q+hpu3zAab1u66NHAY1o6nUhGgnyrXsgKLV5morhvX4uOY3RUXZJO
         y8qA==
X-Forwarded-Encrypted: i=1; AJvYcCW3d4vYtp3urlFG+c7WrYYeAW17rQIvJlKgsej3hKZ73DKQYg0rt73ZH5hPWFp4LMobK4vdtnONyQb0/wjUOJ19GlpG30Xz8NE=
X-Gm-Message-State: AOJu0YzVX5Olz7pOkrWoveJH4YNaHJbKcjUX4me3sHgUY9eoUQ08Bdch
	kxgjwGMusYtg7IlhLSrObUpOvbZv3bPa4uVCRnSh9Lm7vgiQ9AIzqxNHurpD+aOmauxAno/dcAD
	P
X-Google-Smtp-Source: AGHT+IEG6+vVsFTe7a6HgkCt4LmRNF24rYL9lHjQgXZx6ZeAEiB7i5mPrzAnIpYtF2GFHjZNEP6aVg==
X-Received: by 2002:a5e:8d03:0:b0:7d4:1dae:da1a with SMTP id m3-20020a5e8d03000000b007d41daeda1amr5848363ioj.2.1712842459538;
        Thu, 11 Apr 2024 06:34:19 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g5-20020a6b7605000000b007d65ee260d0sm394777iom.6.2024.04.11.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 06:34:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Ruyi Zhang <ruyi.zhang@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, peiwei.li@samsung.com, xue01.he@samsung.com
In-Reply-To: <20240411055953.2029218-1-ruyi.zhang@samsung.com>
References: <CGME20240411060014epcas5p1658ee85070dfc22544e4fbff9436cb46@epcas5p1.samsung.com>
 <20240411055953.2029218-1-ruyi.zhang@samsung.com>
Subject: Re: [PATCH] io_uring/timeout: remove duplicate initialization of
 the io_timeout list.
Message-Id: <171284245862.3311.11180570371949756929.b4-ty@kernel.dk>
Date: Thu, 11 Apr 2024 07:34:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 11 Apr 2024 13:59:53 +0800, Ruyi Zhang wrote:
> In the __io_timeout_prep function, the io_timeout list is initialized
> twice, removing the meaningless second initialization.
> 
> 

Applied, thanks!

[1/1] io_uring/timeout: remove duplicate initialization of the io_timeout list.
      commit: 99e440c5b1d70084eeb2097bd035e50c2de62884

Best regards,
-- 
Jens Axboe





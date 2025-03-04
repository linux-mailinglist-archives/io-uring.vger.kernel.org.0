Return-Path: <io-uring+bounces-6929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 557B0A4E070
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FC027A451C
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 14:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E4C20551B;
	Tue,  4 Mar 2025 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZBQoLGja"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F692054F6
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097793; cv=none; b=m58BwFXkHIZtj8KN5flSbjH6e8PsdExJCu+hZlySPSVsgVgVcMGKYrOyDfG1J62Kmp+Ust/UIbK5cKLoi5CnIr3rqRvsDJQINia4zmpAMyL1BOFzy1Mke2YTDGZJ4pG5UJj9Fw+qARqudqGodJJQnDvk1tqKuOBfa1Ir+ZCRVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097793; c=relaxed/simple;
	bh=ChsJ9RkdUo1r4X4TzdGs7HyBdF3iA2cg5kze8FQH5K0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZA5vYGjL7XxPpT1T7l5bZ7dwOBVZjTJxzYBVIq2hRBXN2hMVJw6EsE0WplPTISf/PqcNtS2mXgiI1ZZIcnSj7yzuBaHK31Zt0OO2BeVd9cWnlhCDMzTrGjxwGrQPVkTFZG3bHmpyAEph8ESHtn+rbXSTyfbBDo0IUfhkmliatXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZBQoLGja; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d04932a36cso57544695ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 06:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741097791; x=1741702591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FM9PNtJtl+yhxDbsm1TCZkNlDxu9xhRfz1Gk9BMDczc=;
        b=ZBQoLGjaCCbY/b8tIF+IAd7okgYX4C842+3XTiye1rnt1eYeKWiv2abGwOi5TFXE60
         SxSSko1K2zq7cyKJa3YEWlsOchoqqzPj/r8QgyWZemzUpdC8aDXZmqFLOOmbqqcRBLB+
         w3WIxdv6ELn9rhONXpQ10bjtVrmu13KsdRxfWZHZAMoWpxZ2xdHf/wTmIgCVO7mwSfKB
         H/PiYwKsdeFzTGV2tJe8l6ByDnkoWHuTDX2rHbEAFWuseFO+MeNbIhOGzoSbBxoC1Z/u
         buOd/jp+QH3oFP0CU6chA9qDiRTND7E63wkvCReAHivr2qyhbYv2ZcnHw3V3vZRGq4Bh
         sTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741097791; x=1741702591;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FM9PNtJtl+yhxDbsm1TCZkNlDxu9xhRfz1Gk9BMDczc=;
        b=KrfHUxMbvpIp5SzpjafPKLQmBO0Xk6aqZ7vnkaK4lGKj2JczyT1O2s5t0RaTN0cG/z
         qVJIyWwxYD8CQeaTHWxxJ35m27jWAQjkK6IS+zTeQ84AvUr1y8i1VKd1dmL0MDdk4q1O
         wkUZpBFufruIyUdNyJXUYoudzPPNUQz44EHcIjfQW6Lidtk+/jpZChW4YtpEA5FqJ27v
         +06ohpRhUKX+siS3hr8SBaQKcm+EAoENB5OYy+9gA6/T83rgKX7xBMfIo0aBZjZ8+EX6
         jSrbf0d4UDGoB9ibbM397qoHHf8S54+ZLnGQRUZ+zQnNl7KQ+dBrAdtCqcJkmaMiR97a
         Nupg==
X-Gm-Message-State: AOJu0Yyyu/gffLb4zeyH4cMxugNZPASKIf2wvWuwNXSSDBgWZjleqOFe
	+csiXeJUOBkylXJDf0V17lvMmSAXqP3M3b3j1DCnb20ao/373Frwif6vS8As3bY=
X-Gm-Gg: ASbGnctUB4di2lAry+TR3t6e7Q9GFfMVEtg02QlN59qaor2y/vcgrtGpfrs/bm7rKQf
	KGhM5YVXNs7OFH5lPuRC1J+N48qKjvI0E9x1RZjS9cvNEam2mOkXA5wd3JzneY3BFOoAQpazoCN
	rvkJzxTEjJifkgfNBxIzzQE43rHIwk9F5+F1eqNNBQ/l8JyFrZESS/zNvKvObhY5zhOGrZHBGsx
	kOgJUpm5kZrAPrIKhfFC0cMO/U6nq+B7A7aqqQ0P/WL1B1QkS1fSjynbjKaOh7eze6D9WWLCHpN
	9tXEEtwdjuydXSGs1giPj/+xsV8qEXYjnHM=
X-Google-Smtp-Source: AGHT+IGF6Zx/rW9mbboTwPHs+JlfjpBg7k/g4yU42/7VmU1fGZrFcCHsi7kIQRTB9DGXWegWS9TfqQ==
X-Received: by 2002:a92:cdab:0:b0:3d0:237e:c29c with SMTP id e9e14a558f8ab-3d3e6e90e50mr189150955ab.12.1741097789907;
        Tue, 04 Mar 2025 06:16:29 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f1e668e5ddsm712422173.140.2025.03.04.06.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 06:16:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250301183612.937529-1-csander@purestorage.com>
References: <20250301183612.937529-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: include io_uring_types.h in rsrc.h
Message-Id: <174109778890.2730103.14634886908772666972.b4-ty@kernel.dk>
Date: Tue, 04 Mar 2025 07:16:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Sat, 01 Mar 2025 11:36:11 -0700, Caleb Sander Mateos wrote:
> io_uring/rsrc.h uses several types from include/linux/io_uring_types.h.
> Include io_uring_types.h explicitly in rsrc.h to avoid depending on
> users of rsrc.h including io_uring_types.h first.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: include io_uring_types.h in rsrc.h
      commit: a1967280a1e5fb2c331f23d162b3672d64ba2549

Best regards,
-- 
Jens Axboe





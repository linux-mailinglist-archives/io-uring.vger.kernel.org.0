Return-Path: <io-uring+bounces-4719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C8E9CF09A
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2334C1F28AF6
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 15:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233891D5166;
	Fri, 15 Nov 2024 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m4820q7J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649472F29
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731685436; cv=none; b=dKgG9COeICbedr+OIbVF0bNaGV0Moq2W3NZMnr4+SimnAgXd2NsnheYSjSVPJu9KTU6IaBdnBZC9ZyJR2wq1jrGjt7JzYCbFI0+zsfdKvwKaYjYG3EkIK/2GCZl8v4q1bZPjOqCGjojhEqnzg6fsMYOFSXoYalnkZ9Fm8JVfxUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731685436; c=relaxed/simple;
	bh=2vXnHLGXI1nqsq4g2fvZanDqWRJ0aXZ76QxPPC06v7I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dTr/LrNokn5E2FW6dG9g0/Bn9rfWfc/oBO/KVSA9ghoYOJEppPqUk/hssHyD9tQzLAOmCtjbI6t43RQZwUACdjxC2wEHLuozClEavz/bl28/UQHanwMoNhLFVmYxzoIftVXziXEGfzHwn6wmn98feCPoZASL0xaIppEvxJ2QJr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m4820q7J; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e6075cba82so1143138b6e.0
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 07:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731685433; x=1732290233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6Q0wdk4ZkvBe0nUUQrCV7YJHywsuhUgJ4bITCNssrc=;
        b=m4820q7JttycVf4rDZM3hPZWHKgZk4NS1mjtFbnKsj6uBDzJidASvMlCStoAq6korm
         7gaILqtNWBKJkkYICR0/8+AtI7aJBO2MA1B/5+bg6Rt8om66UVuWDF8IVYZZmV+ViyH2
         bN00J8rYTdn2dCHfUmQ8OFoCVKNQY/hOsTwtH3J83lAoXF3Rzc2kQNMVlybWb5Q313r1
         d/4XvjRW2ec6iQQw67j/zcK+fAFQl6K0G4JlojMn3bD1NsdLh1vm3UBDmOq79E/7SDgI
         639nK9Ed83YCSNB08YSvMJiAjK/ssRKdcWpMsTEK8XYF3DXZ67vER5TkHfSKNHiWeElK
         ec1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731685433; x=1732290233;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6Q0wdk4ZkvBe0nUUQrCV7YJHywsuhUgJ4bITCNssrc=;
        b=QBxvdIDv3wcQZ4UM5TJuMCI1B5OJng6B/NT/iCmZvvbqHmdx2fp3wy0gSepjr3bPWd
         tNUnIXmKTTK8F+dhqR7DxXzoRto98chO8b0aOxmTUO0WSODx/WV3Li+PqMtgBQ9K/D26
         qK97uS+BKg4mNxtO3LPaFl90vKdsGbbg0qdsDqch+MSFXGElHjAbHkPL67BuY0nyE4jR
         vhz9uKUELvClmXeKFuR4PHJ14uoCPGoyg51gRVBos3CYLWj+9VfLC2pJYRqne05fuJY3
         BusKWZkktPDm+Ynm0FMZyavO0FpQCBXtOJmq9gg8k0J35q4oaXKjj4TC8W1q6tDdPHVe
         4bFw==
X-Gm-Message-State: AOJu0YxeQ+YImB36pqnRp2RSZeyGrzrjQZWLTPdzPEMDgdxnO2UYho9W
	wQoaYh68/J44D8v1+/Nhyn5zGHHSdGFTZAqtG8OT3Jee7VCqF1x40uOU1bOJZ3tNfm5YRLB/+qQ
	r6nk=
X-Google-Smtp-Source: AGHT+IHoKx0DNEOlKpWzoQy2ROeqpBYo8WbCoTYJ6+Hw2EASga/6br7UpMDnvxf+cXpuyIDRatPwSA==
X-Received: by 2002:a05:6808:1a22:b0:3e6:3a82:f790 with SMTP id 5614622812f47-3e7bc7b0b26mr3470295b6e.6.1731685433461;
        Fri, 15 Nov 2024 07:43:53 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd82997sm563072b6e.34.2024.11.15.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 07:43:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
In-Reply-To: <20241115034902.GP3387508@ZenIV>
References: <20241115034902.GP3387508@ZenIV>
Subject: Re: [PATCH] switch io_msg_ring() to CLASS(fd)
Message-Id: <173168543269.2491301.6332603954754033870.b4-ty@kernel.dk>
Date: Fri, 15 Nov 2024 08:43:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 15 Nov 2024 03:49:02 +0000, Al Viro wrote:
> 	Trivial conversion, on top of for-6.13/io_uring.
> No point backmerging and doing that in #work.fd, seeing that
> it's independent from anything in there...
> 
> 

Applied, thanks!

[1/1] switch io_msg_ring() to CLASS(fd)
      commit: ffd58b00769a9cfee6a110231eb7d1fa70fe64b9

Best regards,
-- 
Jens Axboe





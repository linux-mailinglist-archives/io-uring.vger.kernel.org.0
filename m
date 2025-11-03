Return-Path: <io-uring+bounces-10323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B017BC2D13A
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 17:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 085EE4263F9
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 15:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0414830E827;
	Mon,  3 Nov 2025 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DqhkjNNA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909FB286887
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762183906; cv=none; b=jj9KfxwbX9punq79hMja+tDcRnxiqSJSORGhhRuvvzwM4w2MsGGefMf77WZs3Rt0PRlnKhLp/8yWz39Dqq9Nu9oOpy3WOA8Uyf3UyKYL7NkHGaAx9rI6jq9+YLVF+jOMxrstUJL+ukb0bOOe/91VL9w5iw09jjLzYIhgQQydmC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762183906; c=relaxed/simple;
	bh=wXqRBILaE55JdL+E9B9wbUTmWAfxB6SrR/EgtwrIOKk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SbXWXAMUmSzUeTtR9TbM+oe8L57XTU06hgy0nVsGahfDl+MtfP1/Ya67CYEgS6TEHmYIsPBfJZHKBYOW+bG/6baTPRnlHudpdqC6iK6F/7OUh4yIUGg5ZAGa5qG69/bZUxomZ3yCMmxZP85sV2kPQjkjO1D5SZWeIKqv2wewnSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DqhkjNNA; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-945a5731dd3so179558539f.0
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 07:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762183903; x=1762788703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3hgVPxvqQKN83gQ2kvBZd5VQbXv1Ml6JmbzYW4vBlk=;
        b=DqhkjNNARmUumWmAELJ8kG6aFkYpyL/osO+/82gX7guXvoQcO3WYgmnk0LRFkp+G1V
         CtkXa974DGFYOe/ezzuhTCW6iAJwZWTsanKUwVfoFS59vuiRDWIQDY10V6l7ZQux9wHh
         T8qeG2ikGlRb4C8bY23BPled/bsUr2+ZA5kK81m42ZkGrZE/dmbAht7VsbdLJkMIfULU
         dUFftII2zAGIBfkcb+R2MlRwe6+R8mSFgzCDULDdLOIszUwyF38q749EsAIM9vTW2nPL
         Uj9tH21ZIMuXrJTCqSKmPgrmYF7cJf8ZmJz0FzcKrMrRnxCASka4eQNhOo4SdFQYHUtq
         i62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762183903; x=1762788703;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3hgVPxvqQKN83gQ2kvBZd5VQbXv1Ml6JmbzYW4vBlk=;
        b=UKMyNPSsJp7KQ/iiGhiCtU4TwINPtQnRBw+Iuv3yKA2485teBLDG8mDrpzAE8kjXhy
         Vmr4T+NLtNAbGh2SbrRrm2RPM84vapaldf3Ijb/vbC2DSiUpHZtpUBq4+5IFvM3K+d6i
         u7eye7VBsTbbyloc8PlnTb/O9JuJh0doVz8c6WE0rSxzMfQtzwJ1lHPIgmFMyEvNfDVj
         OP7KDRacUuUQ10j0D9RT3s9EnffDzn4qwQ6sTTFVtztPcjD+J0XVlBe3A7J4fHdV/wbs
         4S00de0oksPZnQE9mbSZJIh4ScLkUombOL7V8/bqORm96JAIDjd9JrJ1TgkXB+OV5z09
         pbKQ==
X-Gm-Message-State: AOJu0Yzgimny/PFVkNFUNXDbM4yye+7hs9Ie0Vn9Xso9riCI9++EGId1
	XYmvW4jh4hdihdEWLSoWVVTNGLhb5i2x/onUmUsMYyFKazhec+F83jnjiDyFI47CRyEjdihi5xe
	o8sRb
X-Gm-Gg: ASbGnctp0CMKN0ma2YEiGf2Yw2m4s96aJ6+hE4OWIMHKdgELugrdJygbARwNh7X5i9s
	M+8xNGpYTPrtI0sRMKFYh1Uj1M3lFMLD3lnwTNdFfV71bFK1EgXBmc4Uk1+0VWj+R2NFTxCazJf
	nG2pxpxTO99YZk464WouMfb/uPoqj7MS1MACTybUP6OmMVt6/bTEanAQ68/BZ0vXIfdU1+9WWan
	fHQYTz9QG1xyX/+3Grya3/XpgT+lrgQZk3/0get7Ru3HgNpTIoL94Jdm9+UU3ngkKyKWpC20AYw
	gLMp1q7rg5+2IqHgnzGLwLnWAPpdl5I8cC+ObaJ0O3oPHcviEppzSExO8CJnjeP0k77PFjBcnka
	t7aKjEjw2WoRt0aGJ28P3H4RjqkqjYaUTsUie0+ne+fNPTPRHItGRUVcjpO2OuH2BxPXMKefVFl
	1oAw==
X-Google-Smtp-Source: AGHT+IFTIBxUfn46sYZ6hbUJrbv86bqFQPF02qtQJk8t7o8hAHovGW6C2GZKwz2eeRA4AwfjgvTr9g==
X-Received: by 2002:a05:6e02:3110:b0:431:d093:758d with SMTP id e9e14a558f8ab-4330d1f5a08mr177643355ab.22.1762183903343;
        Mon, 03 Nov 2025 07:31:43 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335b5a92dsm2754945ab.28.2025.11.03.07.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 07:31:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <ming.lei@redhat.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251031203430.3886957-1-csander@purestorage.com>
References: <20251031203430.3886957-1-csander@purestorage.com>
Subject: Re: [PATCH v4 0/3] io_uring/uring_cmd: avoid double indirect call
 in task work dispatch
Message-Id: <176218390170.6648.16490159252453601596.b4-ty@kernel.dk>
Date: Mon, 03 Nov 2025 08:31:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 31 Oct 2025 14:34:27 -0600, Caleb Sander Mateos wrote:
> Define uring_cmd implementation callback functions to have the
> io_req_tw_func_t signature to avoid the additional indirect call and
> save 8 bytes in struct io_uring_cmd.
> 
> v4:
> - Rebase on "io_uring: unify task_work cancelation checks"
> - Small cleanup in io_fallback_req_func()
> - Avoid intermediate variables where IO_URING_CMD_TASK_WORK_ISSUE_FLAG
>   is only used once (Christoph)
> 
> [...]

Applied, thanks!

[1/3] io_uring: only call io_should_terminate_tw() once for ctx
      commit: 4531d165ee39edb315b42a4a43e29339fa068e51
[2/3] io_uring: add wrapper type for io_req_tw_func_t arg
      commit: c33e779aba6804778c1440192a8033a145ba588d
[3/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
      commit: 20fb3d05a34b55c8ec28ec3d3555e70c5bc0c72d

Best regards,
-- 
Jens Axboe





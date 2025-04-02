Return-Path: <io-uring+bounces-7368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA311A78F84
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 15:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D085F1893335
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 13:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBD923BCEC;
	Wed,  2 Apr 2025 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fQgpPeoq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F423A562
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743599571; cv=none; b=txIhbyGB1x8TSq/CTqnNTf7wFf4oS44DPCXSbeWL17K+J6MQdVs3qOj1uUOm9f4207mfQT+3VA4aLVyetbog1hHJ8DZltasGg7JxB+elnjYITonLme/Iu65CAqYMNzpEfQnOj4zGJG1Wzj6gqbfGLlJMknZ2gQQS4WSMCFYI8PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743599571; c=relaxed/simple;
	bh=laVRdo1xwTei+91G3sGRN/pui52rS9shffJKuevQxvU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uc4rfI8MRUno+QBnWN8SEz/kG63477qRi/4L2Szl/mS/DoFJMCbsSkY11ToT4SNq00rsugicu3m/bEKTAPDV+F6r6ceebT/HVWE6fV17cp493lxvwq4PlJKrBidnalCjvi3GBjsmT5Xyh060waNRf3kCedwAcX+M/Ni5NVSQSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fQgpPeoq; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85b4277d03fso223825039f.1
        for <io-uring@vger.kernel.org>; Wed, 02 Apr 2025 06:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743599568; x=1744204368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Te3loAnT3yZB6K73zQM36QBc8XPo0hzdzqWufvaK9+s=;
        b=fQgpPeoqXXmffapxZ0fHbMytzIcVzBE009mny2cAqbkMSQtE7oxbu/KvNxZdrQN0kP
         0gfemPBdhR/6LjAhH4OQAYqBVZwp9Yx9fpu+5NUHgmbeAHsPCIx6fjiAfz7zjLUb8S5p
         gbmfYQpzuXilwC+cEpFhVnDXrdhk9/bAeRCsdRWJvse0voCp8pXxhtEmwDuyNM9MjGlj
         Jnjfq/xUS4weUGPySvfwKjDfcXR5+BPd1LlI/kjWd5tZ+OU6B9KJyac1H/5MFl9GjGTU
         I5nkNlZai09HqI0j9UCvNbq7X/QFygDgARW/Xt6lwo9+SDykmlk+fpJPG9xiduIhCBkh
         2w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743599568; x=1744204368;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Te3loAnT3yZB6K73zQM36QBc8XPo0hzdzqWufvaK9+s=;
        b=oLNMV4DTe/+e0yBkfojFR7xBwVP/pFMC00A7cKgYs5h9lDQ/eQcsHOthzmiUL1thM5
         HHWzMaLyJPEiNqWAeQP7E9wJ13o1B72+HlQTLeOlaP5+/EQtzKYWdqTotOKAwcQAGK4H
         jyF/2eMZPUScyUbdSu2xnqjYbnQPGI/Tb6ih/CnByV3Gkeg3cq94/Yt0DNndd4vZo8Ba
         HUZqS/EIOGQIOK1Urst1euveCHniDb6miYzXusq/qdbXgSMg7MOZcYXYdjBT13T2cq2g
         YcAkYa2OgeUaGpe0XPIzZTQRv/PftyOGhAjERSZh2g8DKPzUBIdl66QjzlgKDZg1GvQr
         ZRhA==
X-Gm-Message-State: AOJu0YxkQsRBZ37hHqapRNL8oF+ax3rTBgxV9ZykiFwOpwFp3WyiSQdP
	PB6lPLg7gb9544pYqG7b8sGkaNeweLPXZnUjZBt8XZjFpn+mN+J0LjyQfyJMXu5YU9xIOBWW+mA
	/
X-Gm-Gg: ASbGncsCPF6ANtI7e+pc2AVZ1uq5xexkGnf0MZ0nxSGskJtO2s2nBvD+2cB3ok0n/Gs
	JwoGE9ljyA++mdNsdn/6vuWORxkEKRoR423VcEAkegO/BMDT/MLP5GGmjLP3uIM8+TdU+SD9re6
	8O16931/ux8oBWUQctabkkgIdvZkcU/5CJjs5hWMo30wc/IF/MFbqZ3yOwqcs33cPZNnBcDThXO
	nGLWZTh/jP29nEVrLoZVbeqqYnFjL3lx5bPpCDWh338BROLOs/MUk83pAXQ6X/mLQCRXZlMir2V
	XGg1cIoNyYeh3dAKze48K5Mw/HPG6HDc03U=
X-Google-Smtp-Source: AGHT+IEBYxW77r4MOzy4HkMVQ0fX2Mb31izV5AD8YPY4idK2uqoZ2wpr7R5UDvzenbt8szPcGbABWg==
X-Received: by 2002:a05:6e02:1c02:b0:3d6:cbed:330c with SMTP id e9e14a558f8ab-3d6d54b9b87mr18305935ab.11.1743599568043;
        Wed, 02 Apr 2025 06:12:48 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a6ca4bsm32985265ab.22.2025.04.02.06.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 06:12:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
 Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Subject: Re: [PATCH 0/4] io_uring: support vectored fixed kernel buffer
Message-Id: <174359956673.20480.12310459002400756833.b4-ty@kernel.dk>
Date: Wed, 02 Apr 2025 07:12:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 25 Mar 2025 21:51:49 +0800, Ming Lei wrote:
> This patchset supports vectored fixed buffer for kernel bvec buffer,
> and use it on for ublk/stripe.
> 
> Please review.
> 
> Thanks,
> Ming
> 
> [...]

Applied, thanks!

[1/4] io_uring: add validate_fixed_range() for validate fixed buffer
      (no commit info)
[2/4] block: add for_each_mp_bvec()
      (no commit info)
[3/4] io_uring: support vectored kernel fixed buffer
      (no commit info)
[4/4] selftests: ublk: enable zero copy for stripe target
      (no commit info)

Best regards,
-- 
Jens Axboe





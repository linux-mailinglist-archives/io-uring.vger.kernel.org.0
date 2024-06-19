Return-Path: <io-uring+bounces-2278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0170D90F173
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05C5E1C247E3
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 14:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AFF44384;
	Wed, 19 Jun 2024 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K7ubQbxq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5799944374
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809092; cv=none; b=hQ/YYT5j5yrnI6WoBwJ/jIPsZGeVIF2Gs4i0FQabiFgQpDhMQ18M63emBhuALs9nqTcm82m4bjfKLJoGpDyfsolgg1cTljsclaHm35T3QnHLGdZjYdB2X8FkcboFI5RbzDT5EjvVnZ5EdXCse70a3/HBu43f1HVZEA/ci7nYNBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809092; c=relaxed/simple;
	bh=qrVVPzjEynBxrsEHQhktFhK1uyJyriLlK6XSMFj/kdw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YNlpOuZRYLfNXPcMeKdJBvIsBh8MeAjaTqqgkQgR9nb3LtH/Ysy8HN32t25ynBKpMECk5nGGrQi8Vk1Jfx7/nqhJcnYPuAO7hypkK+e7j9taz0gF/q7E1kYGEES7vyGpgIZTUyq/CrSseCV7S4wZDLPw2GkACW8gdlAZ1gboUO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K7ubQbxq; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6f799fc5af3so333939a12.3
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 07:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718809090; x=1719413890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XA6KTnuQNURB1QqcwvpXql3oYJbOAS/xh/FTDvEGntU=;
        b=K7ubQbxqy5+T7MuOSqQ4lUthl7oRe+5WSiA0ryW7U14xjtlkkDpDzJVFM4Eg2aHaOA
         0cnA43IUvUmBUpv9KNUYijuwLKQXrczuzobqDy7nm224F4mCVa3M5lDfgPQjWGRTDUUf
         a06YtWFgZvwgV0Sx09EOIBfJIVbwqjCTuCvyQ1bQXirpXttDu3t6/32NZTrKjLA8K825
         U//3Zws7fRYor8V8R87eFmdZr2yvSsoycpIDJJHh0X8ZpQqszsLPCH6t/ATJZjgaq92g
         0fePTI36Ks6H6El5AgK8lFS5srGqRi+ucCuf8bE0Z8k9nfjW80uJnT+6AnWLhUUNKGgd
         0Mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718809090; x=1719413890;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XA6KTnuQNURB1QqcwvpXql3oYJbOAS/xh/FTDvEGntU=;
        b=QQeFRwhRRzh6Cy7FPsC/rSxaytc9uPvEwPCh3fn358/6FYOnqblL6tO/COob1yz6SA
         fc1jFiPzNplWw2Li8uQ1OWTpVnFU78Ot2vEx2L/DFQkh6PP6T6JMUha/Andwc0XnQ3Hc
         XgtO9FApAsB+bp6f8X/8AZa04IchMckAC7YaF5zfzLtFNjA0jyC9UbVN5J4KnqrKNETr
         1P4CxwnK3vtDc1XZimW51VsmZfssdhpmja0aD3xjXGbwtwruiAifxicDtwIVizAW49hX
         xkbb7J9lRbRj88/O7GoJ9CX9PS32bkhyZGwTyeZ6wq8TV4GySwykHxy4Mpsb4vl5YS8W
         rihg==
X-Gm-Message-State: AOJu0YxUOWmS1WyQzrW37oXANs4ftMFZ0KdK4izPNH8hqfvMOCMwabOq
	kymUfSSdEYsKhD7WxpYbJEF1e6e7qyyGlWPGUM1Ns6nuQoXKR3lKP+htLnTcUeKWhFVhDVZXbTf
	Y
X-Google-Smtp-Source: AGHT+IEZSFAdtIVp/yb59keMALUIWHqP1n/mDrav6RdQaOKTddLxpnp8+Xi/bYF2TqPHpKlGQXnELQ==
X-Received: by 2002:a05:6a21:33a5:b0:1b8:622a:cf7c with SMTP id adf61e73a8af0-1bcbb727134mr2796204637.3.1718809090558;
        Wed, 19 Jun 2024 07:58:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc9744ddsm10790861b3a.71.2024.06.19.07.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 07:58:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20240614163047.31581-1-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
Message-Id: <171880908975.117475.7297560909114409579.b4-ty@kernel.dk>
Date: Wed, 19 Jun 2024 08:58:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Fri, 14 Jun 2024 12:30:44 -0400, Gabriel Krisman Bertazi wrote:
> io_uring holds a reference to the file and maintains a
> sockaddr_storage address.  Similarly to what was done to
> __sys_connect_file, split an internal helper for __sys_bind in
> preparation to supporting an io_uring bind command.
> 
> 

Applied, thanks!

[1/4] net: Split a __sys_bind helper for io_uring
      commit: dc2e77979412d289df9049d8c693761db8602867
[2/4] net: Split a __sys_listen helper for io_uring
      commit: bb6aaf736680f0f3c2e6281735c47c64e2042819
[3/4] io_uring: Introduce IORING_OP_BIND
      commit: 7481fd93fa0a851740e26026485f56a1305454ce
[4/4] io_uring: Introduce IORING_OP_LISTEN
      commit: ff140cc8628abfb1755691d16cfa8788d8820ef7

Best regards,
-- 
Jens Axboe





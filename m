Return-Path: <io-uring+bounces-4560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BDA9C11A6
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 23:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 276FA1C20F80
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 22:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0468218958;
	Thu,  7 Nov 2024 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NNVyo6jM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF0A2185AA
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018309; cv=none; b=ct47BN+Zp0w3jJ8vyffKN9IGAWfvKAFCOEauLGS4hgZzYfmAVr3Owh4qj37Push+fuVx8vMwvzmjA7OX9CU/fTo8MM7YQRmeTlejTo/lVOtGkvGqtrZqrYaZRhWzNCtBhqOV9OH4+r0jtVDfs37fBDjHmaAnU9sl3UpxTe9L7iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018309; c=relaxed/simple;
	bh=A0s89LkTZp4qlYQcXSCueb1TirquJIeDVMMJtYmlY8k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RPBcZYlaZsIsvpcFkFRMiVvrF0pvL8INy7qGv1Tz7AHH5fdK/QAiuZmOWBmvBxvqyz+H3znkn0zvWWBkUEOZYV6SLHGnMN+DFe6nqWIocYmcj2CgE8iWk7HYBtADU/WGIiaTTivVUMsMBijebrv9VZZAZ18tijVcv81K1z+kOwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NNVyo6jM; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5ebc349204cso783077eaf.3
        for <io-uring@vger.kernel.org>; Thu, 07 Nov 2024 14:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731018306; x=1731623106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7G1XPfNuNFwsG7zmk4tSO01JI2jTPsrTlLrTnL5erRw=;
        b=NNVyo6jMO+aehwoFwwVC2OeSmm+hWlmRPb0P2Gj0RbkRfIvkXHdmFMRM2xwJYYpYn/
         JXbqRgfm5saAM0bK68BBuTp5QUwJ9SzZmyoYO1uVF+a96lg6qyRHx5q6Y7zX0ng82YYX
         vnBCS/OavELHIEgiOQYuYo9f7lF4l7GxqmdXZyjhA+9S2rL23nhmf8z4mFgbSa3T2PP8
         GjV6F9jgUzIPVXoLE6bzG1fKEfu57qwZt5rOLImm83EM3z2n8ydzJH7MF7k7jVJTb9Si
         yDyvqr7dM4tCQHoTFyeW35OJ/vXt3wLSdR7sl16HYcAMQyMVkXkCkF9o6i75f22dvHKc
         8LMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731018306; x=1731623106;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7G1XPfNuNFwsG7zmk4tSO01JI2jTPsrTlLrTnL5erRw=;
        b=rdHXJYCMAAxc61Nso+TOeQWDx5yN7wnLugPn7qX2iJG8mPS1p/cIxY7BfS9NhGTo3n
         X+YSRctk8aa03RpG1zP42GXBv+iW1QF0/Vuq603lYoH6mwrAe3bp4yVx1VfWmJphcoQt
         z1QiVqyYlEZLEIq4ng6LRR444+GYvHt093ltI7oOM8XuSywJfAOe0BbdSMqWhKNXxxLO
         930Svt4ZgUHytiOTv4LIahG6bS/gdV/s9ZVnRL5i14sCWuJRnz+MaYT7O0O4kCvPUpw/
         RPP0W0+P867FNZAHFd7aXfuuBSpzT0lLMBTFvpz7j9sjJ+sDJA7pDmqZnln/jLsnu4Pd
         QZMg==
X-Gm-Message-State: AOJu0Yz4EsmudpelAT3mMgYhV97+r+ywLrZUcEC9APe5WRMFB3uyOuC4
	pDePchLbxeSgwgdwXdilnsgZkrkZgmIwvVjp1DddE8orJ+HPgYZ+p0JgqnSEhY4=
X-Google-Smtp-Source: AGHT+IG7NijurTJzMy5bPXstDLDynMam3yc58InoQfYqKZ8cHjic1RBivnR17kuenuzAZXOkTTbSOw==
X-Received: by 2002:a05:6820:2018:b0:5e7:caf5:ae03 with SMTP id 006d021491bc7-5ee57ba7a91mr872684eaf.2.1731018306050;
        Thu, 07 Nov 2024 14:25:06 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5ee4950f88bsm421226eaf.17.2024.11.07.14.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 14:25:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
 Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>, 
 Akilesh Kailash <akailash@google.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Subject: Re: (subset) [PATCH V10 0/12] io_uring: support group buffer &
 ublk zc
Message-Id: <173101830487.993487.13218873496602462534.b4-ty@kernel.dk>
Date: Thu, 07 Nov 2024 15:25:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Thu, 07 Nov 2024 19:01:33 +0800, Ming Lei wrote:
> Patch 1~3 cleans rsrc code.
> 
> Patch 4~9 prepares for supporting kernel buffer.
> 
> The 10th patch supports group buffer, so far only kernel buffer is
> supported, but it is pretty easy to extend for userspace group buffer.
> 
> [...]

Applied, thanks!

[01/12] io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
        commit: 0d98c509086837a8cf5a32f82f2a58f39a539192
[02/12] io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
        commit: 4f219fcce5e4366cc121fc98270beb1fbbb3df2b
[03/12] io_uring/rsrc: add & apply io_req_assign_buf_node()
        commit: 039c878db7add23c1c9ea18424c442cce76670f9

Best regards,
-- 
Jens Axboe





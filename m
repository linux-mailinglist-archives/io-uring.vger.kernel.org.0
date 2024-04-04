Return-Path: <io-uring+bounces-1394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E87428992F9
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 04:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04CF2888E3
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 02:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67917CA7D;
	Fri,  5 Apr 2024 02:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0PlOwH4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C36AB6;
	Fri,  5 Apr 2024 02:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712282877; cv=none; b=QaGPzmmZeIk++wcA/8kLYcJ4/v35vtfBavce3bp0INks4OTOZeQ3eMqbwahLVilaWAF7+gm7x3ySS83e7g0hPNidRuVr39tBWonYP2g0Opym9upWdCSq3aWeyEjjg5KcEsWvNuWKxaID95d4GU7UwJ93s9mcfD/EZqG4DMsaUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712282877; c=relaxed/simple;
	bh=STPVYoPQr3IUpl3V11g5YGSOIYs+skD4DTzlIbgQUPo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qc8+FnWa9X9baPVyPFl046UxWayJKVFE6WmK6D0iml1XJnEjuAjYviVfjuPgLYkko+sdnkgMZaeCf9B+06n8jJRVczxFx0afSNwpzRKXSmq7VsEcY9FRFD7s1ovq/scXmyFHTTuaPHMZ7f73DBE3JF5pzyMteH4tu14SA68u78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0PlOwH4; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-789dbd9a6f1so94479085a.1;
        Thu, 04 Apr 2024 19:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712282875; x=1712887675; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZ9R5uibYBrT2uu3N8NZ5MqGVHwCm+hOT4GQItGAlZk=;
        b=j0PlOwH4Yz/WpL923brCObHsHhrRLtYE30dF/gFOXxR9gNchfJGxLixW9R0fQe41/2
         Qt5QPuauq2ikrA6AjHhGdbSpeW5Bhgxmsp63tTGhzE91xdL75IDfmlqT0tRZ0wH25DtX
         ruNBGaP/4dSSi+CFBD6xRB/JF17M82Y+Yam/zAPzOofkPzIYmqa3A5jAKqiHhGhaaObU
         uIReRl7pFM+j6HTL8OteEIoZTrsxGC7qBbA3oCI8/GRv9AL+u2AFos0Qs2cSvZjP8oVE
         NbzorzBdziHUdaGzG5K1B9SkepxirALUElWe54UUN6a1n3rsOZ0QOCLuQIwvdfH4Y/EH
         B9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712282875; x=1712887675;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZ9R5uibYBrT2uu3N8NZ5MqGVHwCm+hOT4GQItGAlZk=;
        b=di/1+NBUBEe6xAo740chyoiAPODLm37TUHRu3H+DFeTlum7JBYE8jYqCneOhHg9RBP
         P5GP6hzsEei4ST59v/tjnEl+pXKjavolRMq5WHdo2qHZRGRtkpyJ1D4bcsnaRUNujlta
         LY8BX0DdL60BGVIO8I0m+ZI+SOfrQQNdPiPFj6H7zfBZy7PnQH282ayQTaFbxYNAGNvX
         f00hyibTLOaj7sKAIYEN1K1vuzAWwv18MbZxwBiG3pAW25WjIpPuHAWtSNFcozR5UL9e
         ZvrO1/BG0Z08Gk05Wb6bJdslnhUazaEh/3vuVSSDBWmhiTWjKeMQ3V9SdGtyi1bBbLWD
         qb7g==
X-Forwarded-Encrypted: i=1; AJvYcCX1ohiECoEQO0g6yR6oWE/VOEFbOspOBRddAIuzw2ljI7d6cjhBTvQTRMdBH1ycrBq/ydYEYbe6Z7cv+fKvtHNSfR25IX1W8/OsUkmvhGChgmi/ih5qjq+M8/6Na/y4wEQW/KXg6RYiM/3V4xz9rYmdB1FpgCCFwkneC3nPI6U5wfEzE8tz
X-Gm-Message-State: AOJu0Yw88u+vvpbhAMuuAcJbZmQCf8BLcW51zJ4DwlNBdTFRrYxO7jpe
	BRToSRYcLRmOX1vEHuphdkuGT25CUpfuvCmVvHEcLMiZCzMAw2jrNXhsidw3
X-Google-Smtp-Source: AGHT+IEZ0Y+Ggjtdk1QIkeoBztmF5GXff/tXhEHhrQ83G49fWIg/xTy4lklVP7/JFpIzA0YnZfafbg==
X-Received: by 2002:a05:620a:5207:b0:78b:c3a2:26c6 with SMTP id dc7-20020a05620a520700b0078bc3a226c6mr140825qkb.21.1712282874782;
        Thu, 04 Apr 2024 19:07:54 -0700 (PDT)
Received: from localhost ([2601:8c:502:14f0:acdd:1182:de4a:7f88])
        by smtp.gmail.com with ESMTPSA id g17-20020a05620a40d100b0078bd8d2b272sm255133qko.123.2024.04.04.19.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 19:07:54 -0700 (PDT)
Date: Thu, 4 Apr 2024 18:07:55 -0400
From: Oliver Crumrine <ozlinuxc@gmail.com>
To: axboe@kernel.dk, asml.silence@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, 
	leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET 0/3] Add REQ_F_CQE_SKIP support to io_uring zerocopy
Message-ID: <aqoc4kq3reefpxhfyj5d7kfdhtznl37a75vuugpyxaaag2iwee@jyxoj3y2vr3r>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patchset allows for io_uring zerocopy to support REQ_F_CQE_SKIP,
skipping the normal completion notification, but not the zerocopy buffer
release notification.

This patchset also includes a test to test these changes, and a patch to
mini_liburing to enable io_uring_peek_cqe, which is needed for the test.

Oliver Crumrine (3):
  io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
  io_uring: Add io_uring_peek_cqe to mini_liburing
  io_uring: Support IOSQE_CQE_SKIP_SUCCESS in io_uring zerocopy test

 io_uring/net.c                                |  6 +--
 tools/include/io_uring/mini_liburing.h        | 18 +++++++++
 .../selftests/net/io_uring_zerocopy_tx.c      | 37 +++++++++++++++++--
 .../selftests/net/io_uring_zerocopy_tx.sh     |  7 +++-
 4 files changed, 59 insertions(+), 10 deletions(-)

-- 
2.44.0



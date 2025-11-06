Return-Path: <io-uring+bounces-10432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D12C3DD1F
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8EA754E5656
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E3633CEBB;
	Thu,  6 Nov 2025 23:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BHoqM9VG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A643043A9
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471539; cv=none; b=W2feRZRV5/rsmvtazkaeoUSNRosSrIrpeJ7GCsv2vj0WQZDUc3RpKBIMZ7pSdfChFxfABmNX7lJKJki57DkSntRDFscNAn7opU0CMIyCWy2QEiqxWSqeah5JuGolS+zdQ2lSM6jR/unoAF5pkcVD/ILBNCFiWlDNviNXzHozvLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471539; c=relaxed/simple;
	bh=OjYS6QBq/KvJNr0ze7JsQRp7bgEHhX9/r4WM+ZEb14c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TQedtOSnlD2+9kcmu40YZQ8lnw45pZ7d4EOS+SoTlr03cCDdKszBZJLVzpJnkNc2JI2DgN3/evcJGwFzDCDbQOwQEbHqN5woiThy61IThTBt4i5zcjpsSOxtyx+ARElv4/lGP7MUxD2BY5e4Sca1p8MSFg7MrWLUxeXxdjcDRwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BHoqM9VG; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-87a092251eeso2195816d6.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762471536; x=1763076336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2y/8i6/MGqS7D/nF/W3skcbR3bl+AFD56zkExJkwik=;
        b=BHoqM9VGnv7QH61mjtM417fRwQN4lSd6e684+uruzdSdgZ2axWxSv+JxT1pEb4hwKa
         bVKttr4VYljg1XleOJyYeVutKQUlvhawr7bDXwYsRtVUSxChlQeg+HmMuiYuSkn8cH5Y
         sbfzcyWqcpoSyOJ5s82leN24VhfKdwzm9vXYcXovAFr22gpmA1pa949HQUepMFxna3Ti
         feyD6UUg71CPlxbwxQWJ+iLIsmp0PNo4ITojG7t6C7pbgq6ThLEGHs6VVuLqS67rQvWk
         RBodBOO0PpmSVyAGE7iuB2LJGihZ9zuIZS5OCZlQPXvQY2y3mkoNlDQq3NzvgWQ4sMsP
         CFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762471536; x=1763076336;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k2y/8i6/MGqS7D/nF/W3skcbR3bl+AFD56zkExJkwik=;
        b=uBahIDuzKPB0KQSi6a5g6kUhL9MH+rE7JiohMP0PuFmP6/yndD0nLYjHbUzl7hB1mI
         adQ9SQwrDhEjVeeYtM1WHk0NFXsl4k7M7jfekeSNWi6aHn4Fa4gzXSYiy+S8O6R63T2D
         BJWYcnZkQCt00m8jfK5DIZegi1ttUVo6gNKzA4415TkLkLOEpNtvNB5QvGhnrOl/wq5a
         PkDyj2L3QqkIJ1dXDOE/n8drwlnA8T+Jktq8MCJ1Ru1uh3OVpTLyRexSjs+QJs+SN+s8
         z1Xeu8H7/36A3TC9sumnx9ZUjcdYZQuZYO57p0szDXE/IbiqAt+ZBIzxB6ll5QTG4Nue
         FQTw==
X-Gm-Message-State: AOJu0YxcuGQ5nxkpA+hN1U3RNmObKw07hUVnwzo083Ejm9T+nRJgi/r0
	iwFrim2BZT4oTrvQU4y8865Qpqimf9BFUsOddYf9+dCnPGg0m5TkAhwkcANVqVtMjLY=
X-Gm-Gg: ASbGncsBdq1eAKQYGbWNzag1+J8wzkRIrhW4cvHIzBhSGArVpRgNr8d9qUAkVQnOSzC
	wSULmLlyBgXfbGTEisIz5FljPZoRAk5ENwphwOPTfaoussc18LsikZxaI41qbpPx6tUu+wPg7lU
	1msQO/XgKInO1qmik86xQMu8nUIKif8mrR/pcUxEgWr8yz558OwsvUpBRiHe8GP7OVli4TgxzYv
	GuL3j6ZRG70PNFXCsVcnjqXyjr9Tn3W7tTNh7C/QwRFXCaEVKKY0/9OYedpBemqvA0C296JG86f
	obtzRPr9v2ZgXb9wOHIORz0KdQBNKVg7EvVzQ5WZp+4WtZBxC0lrchGNtE7LTplelR/cBViTqGM
	F3gGuqhEog+pbfLiFru2fZwXANHCifjOgZe9ZCuZYvBfoNFjKTRJRvo3BcD3nfFWl7VnqQK0=
X-Google-Smtp-Source: AGHT+IGZGitkwHhjcB2RkKVtVD5uAzK6yfew6CVn0xHQZNjTHDdOqMfeuoe0tLQ5bs0EQjpnc3gcHw==
X-Received: by 2002:a05:6214:19c9:b0:880:53a8:4048 with SMTP id 6a1803df08f44-88082939158mr64420026d6.28.1762471536104;
        Thu, 06 Nov 2025 15:25:36 -0800 (PST)
Received: from [127.0.0.1] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88088b7addcsm18224696d6.32.2025.11.06.15.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 15:25:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
Subject: Re: [PATCH v1 0/7] reverse ifq refcount
Message-Id: <176247153219.289461.1674791551192234845.b4-ty@kernel.dk>
Date: Thu, 06 Nov 2025 16:25:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 04 Nov 2025 14:44:51 -0800, David Wei wrote:
> Reverse the refcount relationship between ifq and rings i.e. ring ctxs
> and page pool memory providers hold refs on an ifq instead of the other
> way around. This makes ifqs an independently refcounted object separate
> to rings.
> 
> This is split out from a larger patchset [1] that adds ifq sharing. It
> will be needed for both ifq export and import/sharing later. Split it
> out as to make dependency management easier.
> 
> [...]

Applied, thanks!

[1/7] io_uring/memmap: remove unneeded io_ring_ctx arg
      commit: a5af56a9020c0dd27bc6ab2b58d1820b01621612
[2/7] io_uring/memmap: refactor io_free_region() to take user_struct param
      commit: 1fa7a34131110e3c41a13b19127da132dea32dcd
[3/7] io_uring/rsrc: refactor io_{un}account_mem() to take {user,mm}_struct param
      commit: 6ab39b392e7973ffc45bf7ab523d8777904c4128
[4/7] io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
      commit: edd706ede85fc9a563556945069f87dbec769e07
[5/7] io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
      commit: 5c686456a4e83ef06c74d40be05c21a0ef136684
[6/7] io_uring/zcrx: move io_unregister_zcrx_ifqs() down
      commit: 1bd95163dae80b940ea4b7bfa0720d3cc538a68b
[7/7] io_uring/zcrx: reverse ifq refcount
      commit: 75c299a917e4547dfe640ce7fd83c8a14d8409d0

Best regards,
-- 
Jens Axboe





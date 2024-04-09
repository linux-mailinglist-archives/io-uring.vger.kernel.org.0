Return-Path: <io-uring+bounces-1478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5092D89E4B7
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 23:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF295284059
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 21:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981DD158864;
	Tue,  9 Apr 2024 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xpFEimP6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D35158209
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 21:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712696460; cv=none; b=dWM4MqhgFj5bhdfm0GR/t61g/JXwB90+vCXN+thGCPtpb94dH94zEhKd2qjbJ4HEDPA1heZpQAWli45xY8xMyOLiccgAQnE0EF+tEl87Sn1OsuYjwgZbh/p1Ij1cxuy4M+MDMnu8T/Ry6ZR5VfMUooYQTDWf7Y1SfeGa2Bh+Uks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712696460; c=relaxed/simple;
	bh=qWmIPNYK7wQ6O4u7blxYx+Kxw1lSbFZmjkQOtZTvm/E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nXayyt+oGcXmp55n/32MisiFaAtCl+LKaSMbyz2bclMvxxIdgwDp0K1ccF7G6/C3Sklx4vFTmmb8DnsB8NPlafOinlcWdioO8xTZ+iJT7QX72OdhqUmiXJ4mmIUxElG3ud2vl1no7PbqbJfNPxx8ALbAKCJYfauVeRqEdbQbORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xpFEimP6; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e696233f44so373113b3a.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 14:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712696455; x=1713301255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tzSmQVaCUpsl1j3STDrQDGdJUEmR8EeHK4Egq26W7oE=;
        b=xpFEimP6alJExDhPLEGXu607701SqYShUTkYvod91usq9pa9huVLmXCeJmGTbIm8VI
         S6FhZs2xLOm5GiQS1lor8432i13/XwLljYMY0pIdREQF1/6vgPonva/u4cFFAHhWHLRe
         +5bOySQvcYF0HM11bAdtFfRuCIKUO4mvpr7h8QQfq8fiysFUrFyMXAh4NswVuPOEXloG
         BKW+uDE4VFCrw9bgbktnedNEiEbMorq05dpYBhNZmtfsKahpFbvQE2VvKK1SDLqg16Wg
         A+CD9whCUoGKIH/7yUEqL+3aez6ItD9niFVhvJrOZdGD6XIOIWMCWB4oAgyVk8vLxp5K
         HoVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712696455; x=1713301255;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tzSmQVaCUpsl1j3STDrQDGdJUEmR8EeHK4Egq26W7oE=;
        b=VQbdQYvj0VQ9imC+26W/O5CxTFVX3b+aRH2hwWJdJrr9D+WDAMyzkOcKT2tEr0oHtR
         dB51bB6hOhkKLiTHM5gl3gZKh3jGWZUDiqqzoTN4l3I1HwPhoVfPUqzjLszPksgyQG8j
         xGnxhjgI3mSZ/HtpbuZSRZHCP2aHVZ52L0diZQr7S3VkonDLr+kMNfv8oFvEnISikEmN
         5FSy8L0Ah2qVhDs+M65UjrsNUJrGy6Sw0Mgog3G4zJlkrhu9Iu9DCyTYf+TzkzmtkeyC
         Gs5MIkHCz5YiVqSZeatk6gQbJexRBimrQbT2O4+X+HEdiG+x/Ppw0J6hoC6E4SU66vgR
         o2UQ==
X-Gm-Message-State: AOJu0Yyg0pl0g2HXQ05pb4Fb+naR5b4/IQ0iAwI85QjJD72ooqDG5dqy
	r1yc/XuZs+HvrlbjlX/bttcsn9cH4sVtwMXM9bfZ0/uuYKlNg8HM0/yWwqs362iII3RjgdEagJ+
	H
X-Google-Smtp-Source: AGHT+IHMWEfoPifDen7lICSa3H2KAPGQKenD/lefctFjF2zqltqpCHrFBt92Pkck+Mjbr24WTeFxSg==
X-Received: by 2002:a05:6a21:329f:b0:1a7:80c3:21b4 with SMTP id yt31-20020a056a21329f00b001a780c321b4mr1125166pzb.2.1712696455121;
        Tue, 09 Apr 2024 14:00:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e11-20020aa7980b000000b006ece5ad143esm8780219pfl.127.2024.04.09.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 14:00:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1712534031.git.asml.silence@gmail.com>
References: <cover.1712534031.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/3] sendzc dedup / simplification
Message-Id: <171269645415.133225.6047022156805398697.b4-ty@kernel.dk>
Date: Tue, 09 Apr 2024 15:00:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 08 Apr 2024 00:54:54 +0100, Pavel Begunkov wrote:
> Consolidate two pairs of duplicated callbacks for zerocopy send, which
> was a premature optimisation, and it's cleaner and simpler to keep
> them unified.
> 
> Pavel Begunkov (3):
>   io_uring/net: merge ubuf sendzc callbacks
>   io_uring/net: get rid of io_notif_complete_tw_ext
>   io_uring/net: set MSG_ZEROCOPY for sendzc in advance
> 
> [...]

Applied, thanks!

[1/3] io_uring/net: merge ubuf sendzc callbacks
      (no commit info)
[2/3] io_uring/net: get rid of io_notif_complete_tw_ext
      (no commit info)
[3/3] io_uring/net: set MSG_ZEROCOPY for sendzc in advance
      (no commit info)

Best regards,
-- 
Jens Axboe





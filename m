Return-Path: <io-uring+bounces-2600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1732B9411B5
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4837E1C22A7C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 12:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FD519DF7D;
	Tue, 30 Jul 2024 12:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DglV2fzK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D2D19EEDB
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342057; cv=none; b=Ds+k/6MMPeU93K9/TA9UezRH/5kS5ulhy2uutSBrmDV9ZgSnbrGd0OwcbfjPHpHgwe1SGoIEiQlY1W6Gv7hSzN0UC/xmAts/gol4O9Ul0flaqfhwrNFh9vcfmVN0cTg8Mw2+ysFpoW2KV6quEu0Qf9GAWt99VqsY6gnUHFC1FRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342057; c=relaxed/simple;
	bh=8HPIQUY/2cBr0saowffEgLriMRmf8pLGDzSvZ7lbpj4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jRQHFWt7yE5t4lXgzFsTNe9GY0YvZMvP3L7fvZpztM6MkCJ1RUdHL8k8vTZhHHw2ZxiSg9lSLUBgArAdQbpLe/7SyOKgan/PCfTUobYmYnIzzcR8rRgP2vQG6JEP6EHCIx9XwBYTBEhYVs/mI0mVyJ88UpNPVYxAyit+Uumlqu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DglV2fzK; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2cdba9c71ebso838059a91.2
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 05:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722342054; x=1722946854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8yPt56ub9k06VpskD9bGz2vAuy09mnGyMgcGGcjrMAQ=;
        b=DglV2fzKJCgk88Q2IRbvx9KIOoxSYfCclk6Sw0aUS5lwhv94Cy1GA7Z1bJ5FgLn76I
         DCz7zAGE+I7fD01UGtAIPRSgJbnYS7r8zjhH5Ssuzd5Muu0xEJ7ICHB8PbC6HsqAB/KX
         I05vJpCuymcYpdW/SwtDXqh+eh+6qze15E/sDGjXK5bxgirijqboquB72R1ZASZBHgZJ
         ByUkPswxdX9/99AhtbSnIgLc0LIfMwVfn1p198oiNP1mtOd9/uMntG8kWp3jAeiz4tDF
         U3bZ/sQz2E30UKGzddqjx5i4rTCo3yuyWT4+WVJdhYkTuGyka8RevhM+YOX09G3v8ROR
         Hwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722342054; x=1722946854;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8yPt56ub9k06VpskD9bGz2vAuy09mnGyMgcGGcjrMAQ=;
        b=I8D3n5d+yZKb11zFqIuot6p2S4t5JkMTRQA2+tnuywcitkfiXNGjaRlpCuKab9NCjj
         q2G3omC7asTuv2LOqaIc03eIlvdQZ5ehR+R6JbTOUwHJSAL8EJpZkTrczdJtMnRUpnaF
         otHkH3yb818+saGPyBfI8Fq6ooUKuB0X1HsCSsyXXqOvdRXsdU2ChmqeEAqZbxRbEvCC
         Ck/mEjzTDT5LN5ZrcZl/VOcBHKjmerTymMuDlhYzHUWQrGOG5gjdeTBo6WW5Ow3T36yc
         vEFt8CFAADBAuuCkQgXAmn5m2+j+AxyNthEY0aS4hLrWCr6ESWDtFmboLy7jbrPiPxgQ
         J8kg==
X-Forwarded-Encrypted: i=1; AJvYcCX4PzAX3bfk2vGogET7QLlKI/97ofBn4cRTCe6LMulgvAg3ekDDTMjovpx1aH+/lPueDBh56qa/kBCtfeMKpribilw5UTAxslQ=
X-Gm-Message-State: AOJu0YwwMUHmxFpQ5iOuOtczqCsTWcKu5XBNeNZkpth4PywZcmQ1bHrx
	Lcb3LmjWTKjgeX2Yz3N0uXYwVe2wn5n9QhiNk3jah0nL77W//+Gl05V7xLIGPVg=
X-Google-Smtp-Source: AGHT+IEuYPxdrQbfgSJhVpSXFGPDFTRiPgF2FJw+SF+B8t/zW+wkwruFjzuXQdU2FeYjGnn35sQRdg==
X-Received: by 2002:a17:90a:67cd:b0:2ca:63a7:6b9d with SMTP id 98e67ed59e1d1-2cf25dcca44mr12165932a91.3.1722342053721;
        Tue, 30 Jul 2024 05:20:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb73ddb7dsm12419444a91.24.2024.07.30.05.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 05:20:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com>
References: <0fe61a019ec61e5708cd117cb42ed0dab95e1617.1722294646.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring: keep multishot request NAPI timeout fresh
Message-Id: <172234205222.11941.16252579937452098730.b4-ty@kernel.dk>
Date: Tue, 30 Jul 2024 06:20:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 29 Jul 2024 19:03:33 -0400, Olivier Langlois wrote:
> this refresh statement was originally present in the original patch:
> https://lore.kernel.org/netdev/20221121191437.996297-2-shr@devkernel.io/
> 
> it has been removed with no explanation in v6:
> https://lore.kernel.org/netdev/20230201222254.744422-2-shr@devkernel.io/
> 
> it is important to make the refresh for multishot request because if no
> new requests using the same NAPI device are added to the ring, the entry
> will become stall and be removed silently and the unsuspecting user will
> not know that his ring made busy polling for only 60 seconds.
> 
> [...]

Applied, thanks!

[1/1] io_uring: keep multishot request NAPI timeout fresh
      commit: 2c762be5b798c443612c1bb9b011de4fdaebd1c5

Best regards,
-- 
Jens Axboe





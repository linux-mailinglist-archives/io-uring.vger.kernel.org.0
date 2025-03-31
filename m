Return-Path: <io-uring+bounces-7313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFA6A76698
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 15:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 112BD3A6667
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 13:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24E72AE8D;
	Mon, 31 Mar 2025 13:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bA8jgjXz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CC211282
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743426542; cv=none; b=n8M4MaZ+jB6tSmRSBNWNs/FZ2pvRltXxFOo+x+hndP50swnikwNdnXUSNpRn/4C8Ny+g5gOT7rr3DDC/94vrYFgaHhlOY/SYp3jeBVbMxz47sJcJXXGv0aBaGGRtbBpy4KxutDkONAenlove6b5hAMH4VJH7ljpO51yxAmgMeNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743426542; c=relaxed/simple;
	bh=neKlkun2pHQuQ/aXLgAVLioFZ4urTrXsjxXhDKVioao=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Kmt2CiYdJAckAVgDempia4eg7H8twUfOIPzemA8K7Td6Vx1S5VS22Gu1mT+TwVkDX9gVBURPqivI8lahrWP1ClE91vdc3cFM1RxDuMsL0FA1VFsZvDvW1AWLWAncWvmGHdtAXuk+dTD0vLYXvYP9mo6LNfj9TAORSGzPXpPYAq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bA8jgjXz; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85ea482e3adso42393839f.0
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743426539; x=1744031339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKIQkhxWM0XWIKpq/oW+DhSYXLrD/8S92rdBVfqJllM=;
        b=bA8jgjXzBLbZE2GMTgblrE+Vx1/zAlrYSzJE55ZYTIa46Kse1esOY4WafZoK981e3p
         HlEjbTD0sDsLhET2BjiyL4ldmBFxeagtVyLTKcIsyK0meqJVDdl2JOnY8wETEufUCmip
         DEIpHMvwSqLjyzJLO2G6lc8jvqsLr+czFXb1xrd31cvF8nETffYjSF6lFPMl58K+N9dm
         sLM/cKwea+JOLtDWGCGy90sDXApwG3eE05rQEc7k+Y2IaMv6240z6oRlXQGnEQQa2yEC
         +qkO64ixTug8RqdAketjaWbyamYBKIRYL0PmrtqfgsAjNkvS6j1qTjX8+5cboLYW8L0a
         mh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743426539; x=1744031339;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pKIQkhxWM0XWIKpq/oW+DhSYXLrD/8S92rdBVfqJllM=;
        b=adll7pG70mqT3GPh6jveCZwgdh/+NRpyrNCxtD5HTimYV5Ea3II1de9B3lWr6A9xCx
         n1C1nWPRTWVHhWdcqeXGRK+OcXxV4FEf0eW7WwODcnkI7NkfEHGBDS+SwaLNvVEkGE5b
         TQ+FdPOSfy8SK2M/JvNnAavVlpIQLFLTegGDy2KTJ2yzAa59bqRyx3CM65oHyXT0idJZ
         sxVg7LGwPr9d79aa30W+ipR12bBhbWNBPnRzIql32gBZNWiN0GcnS/pF66mpx4fadX10
         nQsq/OEXFxIjbf1F95DQk41yMn2UIqpH3wabsqT9WqnLK61cIoaiAaiioEg1PyRJmQZA
         WmNg==
X-Gm-Message-State: AOJu0YxosJ69mXrStDXbmvVJtZiY+KiICzodj82YWxs/hY2sv9lyqVRx
	FS+ucb+AWZscpO0sYVrPVGFRwiIMfnRufNKIQbfB5TVypPI2lH/FldE7RofUJA4xFJZpOG3zR2U
	U
X-Gm-Gg: ASbGnctnZxJKzjPQ/KM1R84Vs5GWTW2w5RCVVLrHLRFHdQn46d2xoBHf1+BsuD4L4hv
	MuViS6yXQuDVccJ3FWhc3bN4ln6kzp5N41xBGjcktbpfk4df4DITZvcYd9u9gHvBmd9YNZRydiO
	F8ttXvgIG0003SeBheAhMjOexXRpr8+M5ItuTqL4tdQ6A0+Ed7q/6szhs6XxCqSzkuY3hza0dqj
	AETJrNmBZqTDJZs4cbcikpG5kM8Cli0OBKciUn/8KOddfSj1cyTlKlF7RZn2h1XNsIqKgODhz0A
	guDGKJ7Q0bbd2xD0fwp3Yr/5whACqibQeaIT
X-Google-Smtp-Source: AGHT+IHTqKUhyDW5NdBUJR9Gn8x9Im3OK5k5ZtAojG7ke/9ty9cSS81jvbsPJ5CWNwn12NtgKjej0Q==
X-Received: by 2002:a05:6602:2112:b0:85b:3ae9:da01 with SMTP id ca18e2360f4ac-85e91e14e4dmr942775439f.4.1743426539377;
        Mon, 31 Mar 2025 06:08:59 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f464871886sm1838311173.92.2025.03.31.06.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 06:08:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8dbac0f9acda2d3842534eeb7ce10d9276b021ae.1743357108.git.asml.silence@gmail.com>
References: <8dbac0f9acda2d3842534eeb7ce10d9276b021ae.1743357108.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: cleanup {g,s]etsockopt sqe reading
Message-Id: <174342653808.1705439.15777817976481332490.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 07:08:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 08:55:11 +0100, Pavel Begunkov wrote:
> Add a local variable for the sqe pointer to avoid repetition.
> 
> 

Applied, thanks!

[1/1] etsockopt sqe reading
      commit: ed344511c584479ce2130d7e01a9a1e638850b0c

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-6892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB641A4A80B
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 989D7177E2E
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B571B0F1E;
	Sat,  1 Mar 2025 02:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gmILZOoT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36FB1B95B
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795822; cv=none; b=FCySNgWD+7AXItGDwnzHIh8SnMNh8WvJXdHV9Q5Tk2Pwg9rqCiNPRO9AFMoJxKSjqQwPVOZR28tMhZVI+bE5Ar0IaeDF4jppfH3k68rSUuq8+WoI5nrUub1D5ojAOzX2H5WfYmJcx2V4UNPbCXMbe2e+jDWeBlf/yiGF6zn7hTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795822; c=relaxed/simple;
	bh=wVE3hUnWuhQz2TZNW6Kw7SOk7Du1RwworYOIP4YiWqg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=u5XpsQCgRQQmUenMWLey/Qb8NzrAiXHLXM8UgYPgHFUSv7gcZetRbnUHUVIoT6F00fOHJ9a1zZs9qTcDZTc589kWPAbr17PAaSdpyfPjAYzkmtZOs8BnKcTDPDR2BwFxXXiIP9IyEtKcjUoxQJGKPq7GmfmR3rbqVyfKI5kJgDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gmILZOoT; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6fcf90d09c6so23741097b3.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795819; x=1741400619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BYnKVvuBP350pfI3rfuD1LPU9jxdWbLk68p0lijo6I=;
        b=gmILZOoTpRtmShyTvk+grE5T42XxGnsZIVfuRYCw/AcIDwen6/lqbuznAAYUTf6T5p
         2kn9xmz+N8nzZ8C/vD7j4lMLLeyc+PSlPie0QXjewFQtY+TrDZwQ9XtfVuqRu0Bo5cvF
         +vVFwfSFZ40VozaXznFoIBwPFdYjNbw4bCYwMEU/xlllLoRLsuvGv45MKaUEt9xUsucK
         F3wkE9MWixESTeaCuI7BiJWB8JxAKFMeaoDLDPRzxsCPKCZH8aw7eFyacTfqL7NIlJ2r
         8isciDHk6FHQhxKFQM+ShoqFipatMiOQNrLwzIQJerIzDR0oEL6Zr6t7YBQ+mAAbF3wq
         VxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795819; x=1741400619;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BYnKVvuBP350pfI3rfuD1LPU9jxdWbLk68p0lijo6I=;
        b=Mr3rKq1fclS+Q1DcZO3rMfNVATEXS2Ynr5080O8+vnffMjqjdXJ8unTMHetIBm44r8
         gssRRUrDqNnw/n8gUZEh4zuEZ4cdBfI8FCcMsXMh1GaPPREsPZ0eRioYdgu3cKWwiOhK
         pWa7b+OUieiRljQ2ihrKqsbueAg95iFhJGuUGN+ZfQtO1AgSiri3MdXvCZ1AVCqqBnNY
         OBtVj/Daua9y9JA/Q4ONHxft2airg8jeCN+jwxIKaPgCZnXaH0ddAzWbP+BY1qR1HTdU
         Vvhhhb3tH+xQKyRblCwZEIO/XWAyu/V+khQvNqgsRRn4kYXvrz1LUF+MNmdaqTpDjRlz
         XYKw==
X-Gm-Message-State: AOJu0YyjW/sL2NPt8gftTIiyjD3lNbnhvgcqrkga9wnK8+1yY9IJpuW7
	6W5TCvyS27rcj8doqt3vMSi11QmikJQriRqPn33MwZufQhftUA33jsO+NSpeB4NUR8YzEWT0+uR
	e
X-Gm-Gg: ASbGnctX9+66KW542OzGgIrerH6C8I1PaOIMiCFs3saWhaSsRCSw4atO9G0ugmqcv3s
	lElGN9imdbefqBOCRPqXa9G6iR8vNN2OvDtC7+ZH/NY4E60bKXHYPah7Gvz1CX9Ok/ay23N1Boy
	Srlf/nAVcsXmkCmDI/Moxn+elETaeZFiQvia5kwbDw5mSPUTyk72+L3S1Hdqqe8lGiqFhLjku5G
	x50K8KReaWs/rvOXJn6mtwEO9dmIljLhW3Uq85qcHjkutPzHTAajtYfzxjXOLnYnpzEIbLzkDyM
	kU3W4d5DuVrts6J0bML8gN5A3lnTJVhJ76ZI9Jc=
X-Google-Smtp-Source: AGHT+IG8nJeuHpJEDq1rCORo+ZTYleaO8aWCSHzkaErOv09hrsKrAoI+I7MVjGLe51Rem2KHG+9HzQ==
X-Received: by 2002:a05:690c:23c6:b0:6fd:33a1:f4b with SMTP id 00721157ae682-6fd39470133mr140297157b3.4.1740795819632;
        Fri, 28 Feb 2025 18:23:39 -0800 (PST)
Received: from [127.0.0.1] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd3cb7e02dsm10175307b3.84.2025.02.28.18.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:23:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250228230305.630885-1-csander@purestorage.com>
References: <20250228230305.630885-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: convert cmd_to_io_kiocb() macro to function
Message-Id: <174079581845.2596794.17760767410091854418.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 16:03:04 -0700, Caleb Sander Mateos wrote:
> The cmd_to_io_kiocb() macro applies a pointer cast to its input without
> parenthesizing it. Currently all inputs are variable names, so this has
> the intended effect. But since casts have relatively high precedence,
> the macro would apply the cast to the wrong value if the input was a
> pointer addition, for example.
> 
> Turn the macro into a static inline function to ensure the pointer cast
> is applied to the full input value.
> 
> [...]

Applied, thanks!

[1/1] io_uring: convert cmd_to_io_kiocb() macro to function
      commit: 09fdd35162c289f354326a55d552a8858f6e8072

Best regards,
-- 
Jens Axboe





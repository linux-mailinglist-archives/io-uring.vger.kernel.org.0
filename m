Return-Path: <io-uring+bounces-7595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F238A94FFE
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 13:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2EEE3B26FB
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 11:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4223E2627FE;
	Mon, 21 Apr 2025 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vUBrPVBs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337B2620C3
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 11:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745233996; cv=none; b=AZw8xGcknbseJdbRhxeeLn7n6Me7SX3p4gWveKOnl/y/K6t2+ISzvKoK8NmVcDZqp0qbULNsttN13UcEBo08GvfQkLSDrhWQauEBe+HRWgfxOrR1Jl5w0q3+/4xG9VE+/oKgP/wTJG7dGthNAB36wito7DrVe1OQ8eftvZpaW54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745233996; c=relaxed/simple;
	bh=4pOZeCuSSOv+6kyU0ALAmBFzJmyeFRhfQLkTEs3U1I0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CoPUy8OFXID5rkmaCJvjQ7V3IaM+8BtUCE9HaOkKmPpnAD9GnNRvyxZVWSZWYEn5BjYC/gLfPPZovwJq3zclv+l4oFDy9s0srNgMd2p0PMpbsXdlMES7xi9aJgUdXZSI+TAJdHZP3JHSYADeFFb2v+mBdoEyfGdSPV2vRn8z/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vUBrPVBs; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e15dc8035so87045639f.0
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 04:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745233991; x=1745838791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZPFmJmr+xSFufRNp2Y25sONs0QTPC/ev9wZjOqfHQk=;
        b=vUBrPVBsU78AhG/bs9xMcW1hJkpirgmbD5+TJgiUyLemndxWYS/gjUIcsvgQbwXEW7
         0d8WM0j0zyyE3YV5umBGM1l+f2NWABelfWejeuu4cCNWp/yUiLMcJoRV1bNVeBcjCXif
         tpGLlq+PSXlfusZVOUyRlRQRuQprg6CAmyNMmpty03XVI1vfjbD07PbEdUKwQjL1Eg1G
         SXBC1rS5m+SgPHctiOxQLx3yGdLb/NPFXVG7Kc3Hin54nIBZ/w2VWMCZ+7bdz0L4uUwj
         3xn5snHwr3ehj6xTbIaA0R9R1rmN/G3QHfhuG6YOd7OETCg8CLGw2nKQ7v6eGMZH9xuW
         KhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745233991; x=1745838791;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZPFmJmr+xSFufRNp2Y25sONs0QTPC/ev9wZjOqfHQk=;
        b=En8AxVBRRJ8/bbIqSjvKbbWWEsBv+hnWbp3C+dqVRQXaulmI//guECn8IDAjeULbOK
         sAXre2Gmg1cBkPx2PLJm4O45D6P6WSRI6+DcP+YZSwNvCsq08F4J1sFIgaBmvezJECAu
         /m82BGUobhCm/aSkUGiRAy58OAxNAOYEjnKzHybWQqMwISuvVmY6qopTwXtn4rNSo4SD
         gdHGqECXxKCu9g1gACOwyPPYQhVMEpwopqKRcWYnMmef11scDbTXH2RnoG8gndg4VzAx
         CUaguYrKnki8fWTNxb2KGEtr4wssZ+rJ/jTIUWL5lxg2PgoSC87g7vrot1xO61RzZHsA
         lIrQ==
X-Gm-Message-State: AOJu0YwyAMOyZ1w9IOXQfsA4us2gK3o7pi5d4caZY6syFNL4h9N+L0A+
	saJXa9mdmLSKzWLsls8tEqn4g5e3emjdnwz8NFHUAXogZddqQaqRoIvnc6jBIBmsB5TLIDxizld
	J
X-Gm-Gg: ASbGncs40M2kPARdQeTALKo26WuBxbrnV2yF2h51E6j4hniOsZLDaDioZoFr8PHjDml
	o0z1e5hpi4nsazVjjEcZw6hluIWZ0VZFDYtKIu8GCZdOE321oPimBACGXfnHwBkauLsvxXHapqX
	+adacc1Jjj5z7T+dFp0sNFpgf3kr/I1kDnA5bgJt2Wp3CSFKye+EC+rVV2VqoYDAGpoFHLMmIWQ
	KbKggZmiI/OOzbL/KwUgsF2GpJwAVg7CTQsZobhSFMxIPlPNhbLPByw6BX5SpxDtP+f2kJ2tWu/
	PYMqpLrg0FJLXNLoy78+H+XK1P3OgTQD
X-Google-Smtp-Source: AGHT+IFYt4u2oHyNffZAhsXOe0wD7mw3TqLhrLURko0rMwoh05j7Mk151jtP/Rj2I95MSq8D7CQQnQ==
X-Received: by 2002:a05:6602:3e99:b0:861:7d41:1042 with SMTP id ca18e2360f4ac-861dbe29a31mr1186216639f.4.1745233990711;
        Mon, 21 Apr 2025 04:13:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37f9c7bsm1730535173.37.2025.04.21.04.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 04:13:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1745083025.git.asml.silence@gmail.com>
References: <cover.1745083025.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] registrered buffer coalescing cleanup
Message-Id: <174523398963.875122.9563826681776351618.b4-ty@kernel.dk>
Date: Mon, 21 Apr 2025 05:13:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 19 Apr 2025 18:47:03 +0100, Pavel Begunkov wrote:
> Improve how we handle huge page with registrered buffers, in particular
> make io_coalesce_buffer() a bit more readable.
> 
> Pavel Begunkov (3):
>   io_uring/rsrc: use unpin_user_folio
>   io_uring/rsrc: clean up io_coalesce_buffer()
>   io_uring/rsrc: remove null check on import
> 
> [...]

Applied, thanks!

[1/3] io_uring/rsrc: use unpin_user_folio
      commit: ea76925614189bdcb6571e2ea8de68af409ebd56
[2/3] io_uring/rsrc: clean up io_coalesce_buffer()
      commit: 9cebcf7b0c38bca1b501d8716163aa254b230559
[3/3] io_uring/rsrc: remove null check on import
      commit: be6bad57b217491733754ae8113eec94a90a2769

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3B5805881
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EEF01C20FB3
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB1068E9D;
	Tue,  5 Dec 2023 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATAJCdRL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D97210CC
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:05 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-54c9116d05fso3755836a12.3
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789843; x=1702394643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K3DemUvvfEpFttnMh8cq0hAYfFzkoF2KuR5UG5wEeB8=;
        b=ATAJCdRLWbn1S2VHjXKXrsQXJZccX5RmXRrOcSjXjpLXNR5Zqik5fgeuNT9OMSUhlC
         n6T4o8gFwj/hlQ2ZELrcukebVwuaYUuygWPE3svRs0x52GkAztPQZNecTDlKYv5Ysybi
         7RWuCu7HwuCZGi45bXzClQFc93INoxg8rZAjrk3WvwP34WoBarGSNBHKwQ03YHVb64Su
         LteBJiRQduFnXwEfoj1pkXXiTw96VBHs35gqwLzaVR/bnhHvu6ttlBuRYdPsRuIbLkT2
         q5oIOte9Dcao4E1KxMb0Nr4661mDvK+8ppu24yAYvzz/cMID2P1J1FhbtzUOlpvdULfc
         ebVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789843; x=1702394643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K3DemUvvfEpFttnMh8cq0hAYfFzkoF2KuR5UG5wEeB8=;
        b=hAV7/ZUL++dTMKEGp8z40DhWuWKbaIAZqdr8UAiyFCtJSoH8FA8QVzKKYjxcvsO1ZK
         v1PDmeJtt/7gK+W14GZ1QGKk4Hw97hyA82YIco9S0k6g3g56ODjXmtWFpEhj92c61ncL
         1BE4DSa2/qvqP/kTH2SqOmGQtKdxdO20EVHf5J9ZC6glu59RIW1Nzn9CihKIt+zYwvnK
         VYatCyulFio/pcaiKEut8AtBgOnglKRgrbPbwX0OzIRpaUJV2s/5tBQRKuExk+4IoMDe
         Kri6MbKM6K1ksFGjspTLj2+GiRk/szW3HWVpN+73lwLJKI0G8AFPOg1/FpfBm2Tsdkuq
         NMQA==
X-Gm-Message-State: AOJu0YxOcBT2UiIbyftpujxNgsuGU2uVhUNbfaEzT6hK/mJfT4/7bZaV
	cFg1YD9xyjAe9WI5qVfx4xr4ZJrOBv8=
X-Google-Smtp-Source: AGHT+IFjQmKFrs7dEKafNH7lnooDCrUsq1OuRTXfLuQHolRji2OnOSRuQhaR1RXVJVl7aje085W74g==
X-Received: by 2002:a50:9fa1:0:b0:54c:5492:da1a with SMTP id c30-20020a509fa1000000b0054c5492da1amr2322837edf.50.1701789843304;
        Tue, 05 Dec 2023 07:24:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 0/5] send-zc test/bench improvements
Date: Tue,  5 Dec 2023 15:22:19 +0000
Message-ID: <cover.1701789563.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 tries to resolve some misunderstandings from applications
using the send zc test as an example.

Patches 2-5 are mostly quality of life improvements noticed while
doing some tests.

Pavel Begunkov (5):
  tests: comment on io_uring zc and SO_ZEROCOPY
  examples/sendzc: remove get time overhead
  examples/sendzc: use stdout for stats
  examples/sendzc: try to print stats on SIGINT
  examples/sendzc: improve help message

 examples/send-zerocopy.c | 69 ++++++++++++++++++++++++++++++++--------
 test/send-zerocopy.c     |  4 +++
 2 files changed, 60 insertions(+), 13 deletions(-)

-- 
2.43.0



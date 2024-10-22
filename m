Return-Path: <io-uring+bounces-3908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C4E9AB112
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1A1A1C22165
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98081A072C;
	Tue, 22 Oct 2024 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JGf/fBpX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FB199248
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608161; cv=none; b=HqZPrieOM36wQMlP1h7apwruOhLGxULSpnLbD8RgW65sfY6ZcS9JcmVjsgeCnp9PdKJToyTnU4kK1ydFq2kOFwvHXuCOLPoyBwwH9kOe4X4Hc/jSuKCiZ2lnRcfPCCOBOqH4P3SDuoqFIvu3wB77MnrOeqDg82qbjuk5Z9cAsS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608161; c=relaxed/simple;
	bh=o6CLCKiUkvQbPVi78ppj0r+QddVMZdNcJwt8VfT6r8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ai/htpb7Fms7xJHtVROJ1RPHgArZYVay+UaiOxC5y3ojWH9yiE1xf6E15+JtwlrNw8LcbqX+++oE+pVttxBEzY9HP9QENN51Yd85nW1PpouTpa0IVIW2YW2W1Ke+WYPZc1LQt8h5DJvM60UqVxuekLq1M+0htKu1TSfEK7xxcPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JGf/fBpX; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c9634c9160so6224949a12.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729608158; x=1730212958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AbfbuLTFAfTIcRg2P8M8xn4t7D6dwQUmE2kThnSL2Ls=;
        b=JGf/fBpXedW5RLauafBAf3tTN1oxi09ZI9LVQ47T0fHazMLspy1Xt5lmM2ni/Poy0Q
         Q5YR1JgSZh62ZwMi7m9L7X+uCru8TjHKv5iCjpILYrNpfZkCkQhukz81czZMYctt5FNk
         8/xlYLl6k3SmLa+Z4fUgs81DsPmBd676O4mEuGaccCG0m0aics8MjhrKBklVtlhXUZFn
         vfgGDFJOuCDhvxnC7CpQCo6G2ycTDRLOnT+DwbuyUOi3XrV6aDSdBPiqygmIDhcAtU6B
         lNaPTuXSJE2LdjuNvtYGaeZTClkmtEuta8369KG8Rvxygb+W3b0uAVLVvi9PNjdLcmbA
         nn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608158; x=1730212958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbfbuLTFAfTIcRg2P8M8xn4t7D6dwQUmE2kThnSL2Ls=;
        b=CZDXRKgUUrXMn2CNqMEayjAKryAxNWVtV/cbyLAJqWucV1ELQ40o1sZKu/bUZgoB4j
         Ezzff8R4mSOKw6TtdZ0jpstiuMf3Cy872VQtu2aTsunwA21D3tEs+vEX0tDDbZSY4BBq
         eEpPdxsW92Shaa4gDtf/MJqUqiV/ZuuRlC3CpY5cbLfesWYUKUOdQ8bM/q3u1mFTycfR
         mvTAT/Eu+wMIlgCRCl0KVbPBSg1/oG4v9NtN/EiaReKdwLqwIsbMy7wHkTMezVA6USmQ
         5xtnWk4xonSI7ERu+xUiaT66/T+GGUgVM2vvzMNWMbDBuhxA+xTEVbdxHy7X9dVYkjLA
         K2qA==
X-Gm-Message-State: AOJu0YxUeLJJzY1dLitQsEVx48ejxdb+594dJlfcu9qRKirkxDOSkiA1
	MFs1JKqY9M7tw8Ob+f/bOjpBI1ux97nq1yNTHjUEZvUKkWkzqU88MiLa+A==
X-Google-Smtp-Source: AGHT+IFKgq8mmDC9cQwjoh3ymJzVEBwOP5HwGxEJHbMWx5Bjh8DLvilcKHEy01uelDYgcnh+6/VSRA==
X-Received: by 2002:a05:6402:520c:b0:5cb:6745:539c with SMTP id 4fb4d7f45d1cf-5cb674554a5mr8528949a12.20.1729608157940;
        Tue, 22 Oct 2024 07:42:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b631sm3244434a12.9.2024.10.22.07.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:42:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/4] send[msg] refactoring
Date: Tue, 22 Oct 2024 15:43:11 +0100
Message-ID: <cover.1729607201.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean up the send[msg] setup path. The pathes should be good enough by
themselves, but more can be done on top. It's also needed as a
dependency for supporting vectored fixed buffers for sendmsg zc.

Pavel Begunkov (4):
  io_uring/net: split send and sendmsg prep helpers
  io_uring/net: don't store send address ptr
  io_uring/net: don't alias send user pointer reads
  io_uring/net: clean up io_msg_copy_hdr

 io_uring/net.c | 75 ++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

-- 
2.46.0



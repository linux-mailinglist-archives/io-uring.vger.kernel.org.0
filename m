Return-Path: <io-uring+bounces-2367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A72591A72D
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 15:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E500B1F27C48
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 13:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3F617965E;
	Thu, 27 Jun 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ti3aKW7U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B55181B80;
	Thu, 27 Jun 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493185; cv=none; b=Ne8WVo+dfliknHBgyZqxk1P1fUoCsUkFXIdfktsLLgWPuy72lm7QsepJFNIYwPIEzucNdW9ys3kGM0JuzzHZDi+MK0b2DN0sUw0R5fjP/XChr6VPuSA3zPNM8PX9XVVH0PmLz5QSDwCY77uDED5/aWal58nHYiddrw+3K/knReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493185; c=relaxed/simple;
	bh=SiZUsJ8n9k48fk9kOxA83xBeTqq9wO+4auoSg9aDQWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UNgu7fdGfW1I1VTSd+qBbcIZcQuA9GAlPHz9qg3YAeRQflk+xRnk5ciLJyZ4/9h9pMkTJRUyUeTNspZ7P14m1V3eR5VfXgvpEO0XfjYphPH2U/MObQCTiZImo8pFjfSRNBFv1rwAMrk9DtenJdL41JVOjuzp47ViL+jOmaenbgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ti3aKW7U; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57d05e0017aso1870414a12.1;
        Thu, 27 Jun 2024 05:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719493182; x=1720097982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HvzwzSKiTBp4cf19iS+dry7IoDLRz1GhBnzELhM9iEQ=;
        b=Ti3aKW7ULa3BnZnKUx6F+2BOEAFrdoLdgOgOnRKh8n7JxnMXnChdA675VA0XDJqndb
         VR+vyQLXFAmOg/pg57Y7rCxdxL0N9Ex8+8XifWM+tLD+EISyDYCpslzktdxPBuKY4qEZ
         n78JdTqbW/Dh6NWMbWgaPEH6DVikXY1Uz4pcYxayotILAvSvDxfQAsd2VxMoRW8qo3ol
         CZZP5AHvI0Sy6a3VGysx4qKhhXP7Pnu1t6oZyDiA2R/p1VMU0JOOBb9fHolxadFw8wE/
         gzLZ5iqU9/BAgM2OnBCJO39Q5u9rJadktV66Zj0XmSKUshfQWLHMWVOfh2kaQ8qtyHCC
         cRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493182; x=1720097982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HvzwzSKiTBp4cf19iS+dry7IoDLRz1GhBnzELhM9iEQ=;
        b=iioHq6Q62euDDtcC1iZHk28hWB3vyiOTe0cmmj0w1BuoUZySYO3Y4AkQNYeRNPIGNM
         vO1qa4MSn2jUiDduuvUwSIAdt/KfwsWwQi/BH3XMu56W90CdwUaCgM1M14xR8ud2FTlr
         XEoCYKHsJaOhOd5KgUqu83wACO9qtYVkGNGKUCuY2w71VSeWscV3xkFx3w+5eFtnbG04
         OmfhxD1h80mFS1ccWpkaIKmDBP+4WuxW7HD8+VYYzZwyoEq8hAwCdev9yCVoh4d5Eelb
         WUntl0n4VTq5crumITfRxGvxx44hwCPijIjHS6gXmfS0os+WVqS9nYT6IyTx80QvKoF6
         9d8A==
X-Forwarded-Encrypted: i=1; AJvYcCWSEsVVwEg1qiV/PDqYbtgoJGCQRwscIn1OL8cs1dMmiNptXncAWLxKix1Jdl9QPU2wOMAYn3BiysI6y4G26vHZAu1mQn5P
X-Gm-Message-State: AOJu0YyawnA9PSsaMOxI6scExBeyNx0EeCuEEscVHbldRzB+46a+4x9d
	YXANutBBESeHsk1HvIy8woN+zO2r4VYE3oMXHD8UQvgHkDZG/Uz7A1yGFZmE
X-Google-Smtp-Source: AGHT+IFtHnsA4c6StTlVPT/7w+bs+PFNlRE4p25qZD4BKjkxxIjQFf+TtokN9LgZMQIT6lu5SuaOoQ==
X-Received: by 2002:a17:906:308d:b0:a6f:e05b:b1f1 with SMTP id a640c23a62f3a-a715f94a879mr797818266b.30.1719493181831;
        Thu, 27 Jun 2024 05:59:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a729d7c95a3sm57267766b.194.2024.06.27.05.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 05:59:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 0/5] zerocopy tx cleanups
Date: Thu, 27 Jun 2024 13:59:40 +0100
Message-ID: <cover.1719190216.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assorted zerocopy send path cleanups, the main part of which is
moving some net stack specific accounting out of io_uring back
to net/ in Patch 4.

Pavel Begunkov (5):
  net: always try to set ubuf in skb_zerocopy_iter_stream
  net: split __zerocopy_sg_from_iter()
  net: batch zerocopy_fill_skb_from_iter accounting
  io_uring/net: move charging socket out of zc io_uring
  net: limit scope of a skb_zerocopy_iter_stream var

 include/linux/skbuff.h |  3 +++
 include/linux/socket.h |  2 +-
 io_uring/net.c         | 16 ++++----------
 net/core/datagram.c    | 47 +++++++++++++++++++++++++-----------------
 net/core/skbuff.c      |  6 +++---
 5 files changed, 39 insertions(+), 35 deletions(-)

-- 
2.44.0



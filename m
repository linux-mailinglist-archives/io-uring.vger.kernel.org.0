Return-Path: <io-uring+bounces-10495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4111AC46C1D
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:05:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 24A8E4E6254
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FD21CAA79;
	Mon, 10 Nov 2025 13:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8GRk3qT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811FF1AF4D5
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779900; cv=none; b=NL79/J5MhzmHClRY9LC/BSA63biE0ydnM0SNsCItnuak4F/aLUa81ZQgCLNLHMks4cNZliIxUIVKu8ZSjPplf//tpeMp+Y6dfmGPrtaw/e8f50qbrr9nupBceAke2mhV7ms9Y0mOuphyxGSTLGyAszPUql5mUQdqOuHn3LIHpI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779900; c=relaxed/simple;
	bh=59jzTpQVBQQ2OGTy9qVEs4hY8juc05G2KTcWe+MqVxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WA1gq35+tEe1i2iLtej2BccVxgp7IJEsaZ1rYAEzyZJEjCSwmy/tNnjo/DsJqftHA3yNc9RnEdxR/pNGElvjDTwj81McF1hKnPSwgLnWCugZiV7/S/4KghSz/Mzlq5hf3Rd4ZDmeYglCYOamB3neFjGDywvA66qQmLWbK8dPF3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8GRk3qT; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3c965ca9so352739f8f.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779896; x=1763384696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TaZl7YQgZksDcQXzykQK4V6lCm1G6CXnME/tuSFMlzA=;
        b=Y8GRk3qTaBl2HBYzmbpSX0Df26/5pxZyyPjANCRFXX/KBgZPuam8o3POJS/yRdgiiL
         kao+kBMyJ280p3WBgjJe3ZU56xtGAk1xYAF+CD34thPXAvkpdQBD+mL+qfWHQBeyGjte
         NATLY7OOWBe5ZIunJwZo8n6oi0Lnxx0WeRmXP7AHiZJD0BW+pIxjJphymRq6b7WPkyrX
         y02AF/eXs0wiMygUORPz0kf8hH7Z26fzdAsM+rFSKwrIveO/f4TmNMHJ97STsoWmDHOu
         X2puhZPYMKwezufmXCxqnOzfy7sToOARQxT75Quux/urbZXTt7AzSuIRTazZNTVb+fmX
         LlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779896; x=1763384696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TaZl7YQgZksDcQXzykQK4V6lCm1G6CXnME/tuSFMlzA=;
        b=LlYPnfVKbtJYmkYoozMvGxWXpDwB5HBRpmoD98ix2aBM8011N+qf7rKjplf7C1rMO3
         I2R7A/7SjPVY8MPMXrQaxFodOKw0CqL5p8udNoLtzKLHTKzNrOEPtsA8/dayeRS68yly
         5TZWVxqpb/pObnPrDHMveQR/GR6hQbbZMeQhHPT0RoQCdLYL8xlZf8q1hV5/GPg5hH6Y
         Y5s1NDOhB26ANS0bFe3OLcT0UPn66cp49STtVlWclFLNC0Q6DQx3H0ymszaswRSc89Dw
         wZUKrTeHZHWkZp09/yfddf7EL2KUWZgYDIZcBNumhR3x2Zm4l70/doOH7SE5Rbww4udh
         BHaQ==
X-Gm-Message-State: AOJu0YxRi6ACnO51hvHt1c44YKZdfsOci81ai8oQ27o4VRyqmt6j3eKE
	gRgiPZ8WCkwxg0uXcNC/itlJDi9l4Z6UqKYyOqqHyQYtgd+l8Ze4koDkpjwtNg==
X-Gm-Gg: ASbGncvmc19EyHNV5HxqiYvGytL5um5EBdABqSsZgwt7nQkb8L1RsBZk5fquFyXLvUS
	xrMARtLKvCSwKNUiFzF8iLle5tbRzKmQhZ0U2WO78bRITLUx80SvORlCsvMlLZ1GGeckLCC/Fb/
	K4ietFHcy1dRmBmMAOd8B8nLJyq8I5RJ91/XUijPA2bSfPVbEGrOgVhATdvHHxh4Gm+86w2CcOk
	FIx9G9MeqoeTk+qr+z9hft602JxPeZSV/cGK8iozb8SFqokFUBuMU36cVq1JK7+RaFwqJ3s91vM
	oxVts1+R70PihpwTMHBYA1N3wwVsFtfqbA+p1jx6eeJXBykArLyC9+L7+9BdCo/Ed/UFAm+AbVp
	72vrkliisvfYfANTFnVPon40XqwVp/sehIKXUW0OCKTNs4r+chglHe1OEughS0prwQoCKazXffl
	iX8n8=
X-Google-Smtp-Source: AGHT+IGbB2r0d76RMK2hNrjG6c4vTrB+day2uPLn5ye/9VIDwl1EWU7W6oJyxEVy+92QmMF/7oCtGw==
X-Received: by 2002:a05:6000:310a:b0:42b:3afa:5e1d with SMTP id ffacd0b85a97d-42b3afa602bmr2934903f8f.20.1762779896312;
        Mon, 10 Nov 2025 05:04:56 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b330f6899sm10584648f8f.21.2025.11.10.05.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:04:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/4] random setup cleanups
Date: Mon, 10 Nov 2025 13:04:48 +0000
Message-ID: <cover.1762701490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple cleanups extracted from another series. Nothing noteworthy
apart from that I needed Patch 1 in a couple of places already,
but it's still a good follow up to recent fixes.

Pavel Begunkov (4):
  io_uring: add helper calculating region byte size
  io_uring: pass sq entires in the params struct
  io_uring: use mem_is_zero to check ring params
  io_uring: move flags check to io_uring_sanitise_params

 io_uring/io_uring.c | 22 ++++++++++++----------
 io_uring/io_uring.h |  2 +-
 io_uring/memmap.c   |  4 ++--
 io_uring/memmap.h   |  5 +++++
 io_uring/register.c |  2 +-
 5 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.49.0



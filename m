Return-Path: <io-uring+bounces-8649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE7AB02829
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 02:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3C7B1886CCF
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 00:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EED023BE;
	Sat, 12 Jul 2025 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fFp7Yx9Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A08EC5
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 00:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278633; cv=none; b=fJ0aox+C8d90Y/9PQMWgZ6VZyfkkduaLyVt2IxRIB5PTaP6HBfsBUslDF2FAXo4gbJFCaCaYwTbg2pSdUvDtFaPa6a32kGSoDvS5R9Wr32gh/c30iVfiIE6ex+lmODjx5AlHcz1c1GCqP/cUsjW97DfuK1Lbxcj9/iPgdU2WV7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278633; c=relaxed/simple;
	bh=cnUw4flsweMd3AMDAEStCFDu4fvNN6+NyeTCAMR8qE4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG7d1leacFHSgwRL9wlhYj9Ca7fUQ6lKu+SO1I//JwjDCM9eiqRPzt/wSlepXcooU5hpfXOgvYUyXk10W0JnzYj6D2IEitsItDa9N/tfUS9LLuNNauqe7wqoBiuWRW1zCZlB4FfeO5PesRE7TAKgKx8wNsESecL1RzuJh1Pz6Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fFp7Yx9Q; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-874a68f6516so230157239f.2
        for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 17:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752278627; x=1752883427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EcrRpoo60D2J7GXrlgXOhiO1WjhTSJAVtJIK3ZNY+c=;
        b=fFp7Yx9QW8HxhSBsKqlleE1kACfgcstbdAuw/Ns/Zd1kLP85eSCgO2/S7wv2+yrcb9
         DPQTqBrPQScaz6J8tKmrF3hHYiPTIVTCvZOEGTS0RCB6L2rE5B9jvT+C1O7d31QkOQlN
         WwEVuZ6luLdywP9M37uYWwJ/O+bnuJ1FqOWsNw+2UOiSsDsYzOYGDPN/JPurxLvHX9YW
         jQ5N191WICQdxC561GlcsOEsysvds7vj4DWXto3Yx58lbsfLbsBJPlRscmkF0k9wiRqb
         dFGuLJTnCJveyBzmvMhhvODD2lq0TR9Q4Hk39jKgOtsMCnVLDkMP2D4x7WoAY/Jtr62T
         hV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278627; x=1752883427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EcrRpoo60D2J7GXrlgXOhiO1WjhTSJAVtJIK3ZNY+c=;
        b=omEuqQ0oIBAePEdLqf7+9mg46ZsPFlEybZ81LCR2QYeh3r+BhZhr/lKCeu/SlphHaJ
         3kT3o53ldciLLkzxymh2v5ptg/T2zzieXpvuGET0G465sbhw4lBRxvsejO7jZAZ8t4Hb
         WuS9zawxdFd/URbQ7UXvTJCLtcUy7qpXh7TbxBHiVu1LTcTZZSMl7xZfm52IkYPpyyBW
         L5Ikv0mdKOU4EMjvoD1R3eGX0ChIZQKh1rTQQpWb7078Nkhud27jsKML7Icz9xSucRBt
         iV2DksaMEUTvC87JWIPKnMDpQqbAAhFvV3nM7sxHNGiAbJw3oA+JsxkxdSbUTcAZ/ctY
         etcw==
X-Gm-Message-State: AOJu0YxXu++sQrrbQ3mLRo1dCQH3XLJy+NQ0IgUJD29G8iz0DClRq4/N
	PO8G7CAeLbqu+pJwdmqNtDK2DlCNjUl/7MaWVJi1OQAJD0i39ZzASneTdxb0yqfPboLU/Lo9Wxx
	XBXAP
X-Gm-Gg: ASbGncuNNWBkklz2g1zVUfErv4DPbFKFzmMJLx4CNIFk9Rx+taf7Wprbby10Hh/bRXs
	Bw45yatsVHk+s6RBu5R3r8iGRQcYmUTs0vTIT9XW368scw0URViIMeiHLIPAafmE2ArAl/ziY7T
	+moCnmv+2tiwWX+m6x9ChmeFjvKTfYDan+xporMMemZAidxNGDpq45sexiYlqt3MK46G1yus1A2
	3J7tpO+GIzPt3irXsEzSPMuPR2eROKc7NQc+YfZbhx6NiunKBDGSZdVcPgMGkmeOSaDxbZZKhr9
	4AuQ4o12UXD99tjHmWnrRCAg6ksJVFGXXFmSv6m18ZfMBJw5SK6FLcb04heyO0A9Znr11kMuSR/
	//SrjHw==
X-Google-Smtp-Source: AGHT+IEsGxxE5s2ArXzcz+uOO4BaeWyPaL2bMu/hTZIefi/ZpP5OyrUv3Sah75RJePWJeOECMa6clw==
X-Received: by 2002:a05:6602:6d8c:b0:85b:58b0:7ac9 with SMTP id ca18e2360f4ac-87977fd0e71mr637715239f.10.1752278627184;
        Fri, 11 Jul 2025 17:03:47 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc12eb9sm129810439f.24.2025.07.11.17.03.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 17:03:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: 
Date: Fri, 11 Jul 2025 17:59:22 -0600
Message-ID: <20250712000344.1579663-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

It can be useful to know if a given file/socket/pipe needed to go
through poll arming to successfully execute the request. For example, a
write to a pipe will normally succeed inline. Ditto for a send on a
socket. But if the socket or pipe is full, then io_uring must wait for a
POLLOUT trigger to execute the request. This can be useful backpressure
information for an application. On the read side, it'll tell the
application whether data was readily available or not, if POLLIN
triggering was needed to read/recv the data.

This patchset adds support for IORING_CQE_F_POLLED, which is set in
cqe->flags if a request needed to go through the poll machinery before
it could get successfully executed.

Patch 1 is just an unrelated cleanup I spotted while doing this work.
Patch 2 adds a request flag that gets set via poll wake, and patch 3
wires up using this flag to set IORING_CQE_F_POLLED.

liburing test cases here:

https://git.kernel.dk/cgit/liburing/log/?h=cqe-polled

and the patches here can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-send-full

 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  6 ++++++
 io_uring/io_uring.c            | 14 ++++++--------
 io_uring/io_uring.h            |  2 ++
 io_uring/poll.c                |  1 +
 5 files changed, 18 insertions(+), 8 deletions(-)

-- 
Jens Axboe



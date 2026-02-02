Return-Path: <io-uring+bounces-12022-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELnsIevCgGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12022-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:29:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27740CE3E6
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2359C30D408B
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 15:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB26A37BE9B;
	Mon,  2 Feb 2026 15:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w8u0SG/O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25C37AA8C
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045698; cv=none; b=eT5oH1h7E/lLBcDPArwU+e5ORd0WbonNwt1W0TrB2MmNavYJ13apXjSj63LOuzB2aMVAOGXGG4NEuTIjHbpTHdBWCmDm1qI4oZbOhjNE5ZggFJQCCLEdUywnB4XlZc81/lmKT4xamo6GQ0LvRwrTeVTFnb9cMUOxoFiv6BeiGgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045698; c=relaxed/simple;
	bh=cxS5f7uc7f5GnSEnsquzqegRUY+RwqW1yaO2iV3mNj0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GzLbaNVyGdPywCZJ/7VBjx/+4fvsA0S61Itz/RkYsSRbHJN7xB7MlDyFEWGVOtLN5rlNSCeS7b/N31ka7nnFv/kkIptz3IZj007HuAHwP3BAFtfYK8HiZfWdFCg/QPleEk6O09H8E7PvZaxZSwgr9TjDUSJ9N7EolEm5glgp/ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w8u0SG/O; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d15b8feca3so4426420a34.3
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 07:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770045696; x=1770650496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxj6zizRkl91lZaIWrOHbU5uPIPw1msSpAEANOdO+m4=;
        b=w8u0SG/OWJNKy6KXytuSOrr9jVlB87Jw3YqEAn/kbx62Ul7umG69VwssA8u7iwtjFd
         zbyNsKG1kupKZcySb4zGmJndiIjjw6Q2j0qFnOEqIbDmnrfypMN2ThSRLg/ovjllF+s7
         A2+xgHFnlFBGloJ4WUhuJ11WP2mH45A1p4nKTfrYBd0J4diivrSUdN7eaYab9CiQ2IiX
         3ckeOj1NfAKp/dhsi3JGuKBebhCY/qBZEPOPSwLaPkoF8wMH3Is1xlHecdy1wgSAoEl3
         d6pKMuTwYnQmJtUEmzkYhvHr+oX0C6kseGPrPTjmW1F1uaVILFIhgm3zql5ri+PwU32q
         4TXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045696; x=1770650496;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wxj6zizRkl91lZaIWrOHbU5uPIPw1msSpAEANOdO+m4=;
        b=vKVZ1BtZf0C0Cb4v4wWynh5wNcvJ6egFUJWmLZ7vjjbaE8irtxnNHOnb46gcXUeoP9
         2LdKqD+tuFH4HDHn3TuYsJbw6Hnib3A8QQx58+fYW5xwX93Sr3NeS6UTtG5xdofPEs4h
         qR/DmJ+tYa7E8o4QLFF1hbIzdZ0A+9stTn+n+YDT9GKB+iL9E02L3RYdIzSdEYQ0SfXv
         sbPehGBid+WcFBRSCUSd6SzS6dkTkKbSmuyG131mkVRl7W4dVBlhT6fQGG6fXtvN80oM
         X0/MU6d4854td+NMgE7YtM0jsMkzNnwgE5NwuFHZmJ1ACZrdWPCxA+00kFqolNp1XRvq
         PCKQ==
X-Gm-Message-State: AOJu0Yyc5ilnvC0t/rw42rtJxkopVouYYGBNe/OqxGAhTtM8kTw4T2nU
	fT4BnsndoRVyZne6KF1q7DtuvtLXh2iQoaKjBX83B2cy64/gKYL8tdZfxJy9kvt9j5gA1lc+Uww
	cpfWj7ZQ=
X-Gm-Gg: AZuq6aJbn0QLFXCzAKKpUsuPmc2g+07sIwXNGx4HWLKr2UpZV51rtnjfflN753AXSs7
	KZfV0662rDeIGy5wlLESsZLdj9K2EvkhebzZUGLkftZ79hlEEOkxxUMPvNxrlojTOhaMyeczNad
	1vhqxNKU6BI97Kb2JGpk42FMNj1zpVVsZ0BjHr3sEIAWamK1vK3FGW5AaeL021eL831Rc307n6K
	mrluKkBEYfqYAfqt/mVU9Gw/Drdkm3YCBT+CZJkS9zUvXVB9wDttdIVoQd4YPoiFaDH+bcHnGTR
	Yn8WC/SFmX0Ed2i8+L5W5UWmD5IJCCDi2/Dp98dlwWw25fSFHithLSUPqArKkSyfcdPoOSDMIui
	79gOgFQTCSXiZ7HlLhPLZJy+VVW2KYi0YTOLRLWbyHhxgfV8KXZFC8BLoVox4t3bJZJuzGYcTeU
	zEm8pRGtnlc3vM9abQOBBKFf1HVYli8t5Wfrv+oI9BbgoT8rBLXrab/JufwVAdW5MlMgYMxX5mm
	KE=
X-Received: by 2002:a05:6830:440b:b0:7cf:d1b7:c076 with SMTP id 46e09a7af769-7d1a534ea50mr7157112a34.23.1770045695782;
        Mon, 02 Feb 2026 07:21:35 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7ffcbcsm10613171a34.24.2026.02.02.07.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:21:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <8b46043155b3abd8a6421c6aa9a61064d1d430e4.1769962652.git.asml.silence@gmail.com>
References: <8b46043155b3abd8a6421c6aa9a61064d1d430e4.1769962652.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring 1/1] io_uring/zcrx: fix page array leak
Message-Id: <177004569461.1085433.7355294259467729179.b4-ty@kernel.dk>
Date: Mon, 02 Feb 2026 08:21:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12022-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 27740CE3E6
X-Rspamd-Action: no action


On Sun, 01 Feb 2026 21:18:53 +0000, Pavel Begunkov wrote:
> d9f595b9a65e ("io_uring/zcrx: fix leaking pages on sg init fail") fixed
> a page leakage but didn't free the page array, release it as well.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix page array leak
      commit: 0ae91d8ab70922fb74c22c20bedcb69459579b1c

Best regards,
-- 
Jens Axboe





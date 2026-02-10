Return-Path: <io-uring+bounces-12139-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKlFO1Mki2lyQQAAu9opvQ
	(envelope-from <io-uring+bounces-12139-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 13:28:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E24911ACA7
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 13:28:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B87333043D22
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 12:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540FF328B6A;
	Tue, 10 Feb 2026 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qM4kkhHa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC6A328B4D
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726392; cv=none; b=hzRQOgX+TCThJYFpw+Eb8e52wlF+zPc+y/+indIH3pPOhLmBn4jOGW4KEmqaa5CQ3GuydlJEVwrymbTUzn5jhf6DMUQ2J4+sAB0ahY+WlTO6mhIkak8wLypXTX2uli/gs3zAkti3LP08cFa+Bfh7p7cZ5KeG43YFiU1RGHlBl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726392; c=relaxed/simple;
	bh=YRb2HOzWgmU6BprpsCak/NLFtfG/xrxo/cn2EIBmiok=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UM17+HPg4qsuDLzXr0bgGLwQK2SrqXuADOcnDSvEY/DIQdP3VOshKpSuIgK6Tt1SorNp/MT5artMxaamIG3MB2MzPMcvXvNE7iFoJ7sGqCI4s6uobnewAqVbNVeXKIU7i1M/3WwbO4ov03Q5jEY+Vz1mHKHDTv3juhE/CkZzY7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qM4kkhHa; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d1916d1e24so627610a34.3
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 04:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770726389; x=1771331189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XB+eVCb0S1waRrWAonsVS/4kh4pOBDwTkWkVaXjSGw=;
        b=qM4kkhHa4fD8cH5/q7imRADcYbiiVVzSOHAPxfxpEDt01ZltikeUwvkrAhbz2O+ZvL
         tFELwheiyod0sWYjQ1xF6Gy2aBC6f4j7swmXDEeICUPBgLu9in/IiZPhvlasD5YtWvU1
         1EPfUB7x8izIFBYa1aPn1vUpL563ZoxFITCBmKrgd+YTtAbMdXk7MlRYele0D4xbMcCD
         nvPgs/HBzRnH7yDFbfdahulmJY1jWFUEvocgCAM5uFd5JwJzpTpjIeeRkP0F0wMidPYI
         W5xrC0WkUc0HUdqmzvQ9kNN9qgX2HDFpgDKRRKdacIpoieL2199nD6s11frnSjqs3FM6
         jISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770726389; x=1771331189;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3XB+eVCb0S1waRrWAonsVS/4kh4pOBDwTkWkVaXjSGw=;
        b=KYd3RNM3RE/ivxKeDUw8qqoDsGyiGTPRiIFrQ1wVLkN7cJV/7YhZr0KsiOi+fPVkdV
         MI61P6CMy7gvaNMzh1zTcFvQni8O2+mrHynK57i1prqr+Ao5o1TNLY8UCD4a4zCJ5jaK
         83OaKfrS7HJN4iZAq3ABT13CeezAunNYXSfwyAqeufaAASjSjX4uor13j68T8EXhhBoT
         dj0UYJ0cG/HBH0X2hzFgAS68EeL//B6yExAwhSppRvJCSRpP1sPFy+gFuRleEE22t3S2
         DoY/RVGFpdM/LLQVg5f4Nns7P+HhKHcBwknla/6gVg1OLou5vO5CpPYG1Jf6JQPcCtne
         mEIA==
X-Gm-Message-State: AOJu0YzysU8WYh+WrgUiRjAq5IiXSONw3qbeaB3TS1PmtFluDCsKb45n
	+U1QHNSB2W8FQFvVO/e0XXlqg1G5Qg8uZ+6D0U3we5YbvQeyC/SdiJiDh95doPZDw+M=
X-Gm-Gg: AZuq6aJBGX8PBOR8zNW7aJA7qFix2wnHz4x95iFPHN4TA210gWTsL97Nxd1dwSUpGsB
	8+dk6Tn9luPslsBHen7sa7MS+hrVn06IunIX2OfGaF7ynwxvBQXzWtVN0RFZJBsznwgjTWzn9nf
	KpuY5bhxui7B8yb/j3460wGyF21qk0nb3xR5e5qz9H2ev+O7lzW8vTYnD3dhxtUQcNlVBD49Jb3
	z/gHL7RvMHOJnIzWgIoN3aa8dJCMXLKx26i/0Ygd1NrBvMC3xi+Y1N0WaX3BL4AOrIbRU3MubJp
	nkjZwOE/FqJhm0SHJZSOD2Df+1NeTMJKJLwEyMbJsqhGxTDgZJA+1gdUsUGF2tCb8kcb7zRJ6kG
	QXiiG0YO36x2vDYDJ6YtY1xoMVbIKZF46N6shyluEkHH/wWpTHOXgFi5lFl6o6j4vfrC/cBtaE/
	ywT6ECzdm24hFkZNYoDvEe7Pko2i0FJnZpNX4baW7qCQvBF3YRmah2nBwQxZqJeiVZ2jdk6c1zp
	OFr
X-Received: by 2002:a05:6830:6ad9:b0:7d4:57d6:956 with SMTP id 46e09a7af769-7d4641ebc6fmr7923836a34.0.1770726389077;
        Tue, 10 Feb 2026 04:26:29 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46470dab9sm10115924a34.10.2026.02.10.04.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 04:26:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <ebd70ad4ce36d8487ac994ed464b97aa08d8ed3b.1770314615.git.asml.silence@gmail.com>
References: <ebd70ad4ce36d8487ac994ed464b97aa08d8ed3b.1770314615.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring 1/1] io_uring/zcrx: improve types for size
 calculation
Message-Id: <177072638785.481609.146411505603287880.b4-ty@kernel.dk>
Date: Tue, 10 Feb 2026 05:26:27 -0700
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
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12139-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 3E24911ACA7
X-Rspamd-Action: no action


On Thu, 05 Feb 2026 18:04:43 +0000, Pavel Begunkov wrote:
> Make sure io_import_umem() promotes the type to long before calculating
> the area size. While the area size is capped at 1GB by
> io_validate_user_buf_range() and fits into an "int", it's still too
> error prone.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: improve types for size calculation
      commit: 417d029dc412c1028bce3d4685700332c0539a95

Best regards,
-- 
Jens Axboe





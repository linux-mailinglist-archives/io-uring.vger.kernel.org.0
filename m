Return-Path: <io-uring+bounces-12706-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBkiHbaBuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12706-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:18:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C22642A1621
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D019304FF90
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC0B371CE4;
	Mon, 16 Mar 2026 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="stwxmmIt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA19233A9E9
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699288; cv=none; b=QX+JztIW2k/Unzsrt8eqpXuuzanj9RPLgKWw3/0gh2xtItBxvhPbnSFrnCHClJb4TthvaX/gY7NJTafqRbqWDtQTt3JQ9Kaa9l3moL9BSMgRCRcKEqjUVKPBXxuzolRX+ch/AHX/LkwfDtn3CYRl3IaLnH7dgWIR1DntnmmLzAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699288; c=relaxed/simple;
	bh=mJQXLMF3/r6C8LDr5OMCXDGTIDre7wRcbFA/C55OXyk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KMQtQcjNWAraW18QfItNNNLBVmMfLLqLMcf0CXWFm16fVdxdVK9UNrvMa4WGo5WEUaUbjrj9VijTUgp8neK7HnTQGb5xEoP5694PDxl77UbrR6C6+gtwzLav5vr0kLFp1BN31lm7dpTb4I8HSlthQ5FwFmBwry7ovqWrJImtiys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=stwxmmIt; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d741f61ee5so4399720a34.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773699286; x=1774304086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAp3upALJrMK2vdftm0Mzj9z5vscYKgrSfpwrB2UjPk=;
        b=stwxmmIttHV7cyRbNXL8XYPZdjTDf/31nHq13jgSWJh39nh1/10ljevf22iICvmP/1
         iooh0lg1xQrYiBPtdH+1biE97VWW+IxJnzzpCbAfCHeD78fYzX2DlctZBDvKhCpR7C4D
         t/8ynZhBrS/w+DjLgDVbXk1RlwQ0LVdCYtb9qp/In783Nh88jdE+I3Vzx7rd6HVYi95H
         +RzDbwRC6waBWQyZS4YpMwyFhdQWkEfIHDIEpsd7xifPl243AWX3qL0Wh2M1Q5KNevAx
         kNnLokw6BcoLKpEcYVI9xptkvaDhk3vMTS6G8U2clTwzeqKi6UQWh5byOKSdF/xMn5IP
         jovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699286; x=1774304086;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAp3upALJrMK2vdftm0Mzj9z5vscYKgrSfpwrB2UjPk=;
        b=pc61J8fVHcsSl84r/EyaOOGC4/UxZp91TU2enYEB8/H/9rAQKF5AMYpM7vcolFJIqJ
         zq2rnRTqIdc4qK7AiJXhw38NGVOvGtmmObH/R7+ecy2TVtrAVVT9F4N6i0/8E9dINa8B
         xP3Mxx2Nu+3a8yyY1AOa9CeiTReDZntEB6AxBmzhB/vPOwRGjbyFzieNfn5f5gP/B5sL
         WUdePanbJ+1fI5TrTb0yDpgOyCV6buNdrXuTmNFBEpFzp6qGwesdUDxCUnLp1zp+7yzz
         kMXW+/ykpS/q8WwsKUFpEYbRs52o/yvw/jq0Kd8nHYZpNUARBZ3h3bQRM76s7HmBXY/A
         Rniw==
X-Gm-Message-State: AOJu0YwScXQ5IOsv7bAummFrHKYxzFazdEOHh0BvcZmyqOGqjd+hvXaQ
	RNje4hrsC0umRW6k9m+tyxTcIozlEyQEN1xETiBRrZV1pHoZ0h1MCJHE1CXi6WEkdgI=
X-Gm-Gg: ATEYQzwPLDpIHn46HxChfREDSzQsl+Cm5K3omTFuRRUc09GrmU4y6fEPkuOZ884x8PE
	lAsXAlW9v5LysMGxN8FcyptmNx6X/kk2RGXpJgwwmfyFR2+MotxymIAQGz/3OHZqp/cEOU8Quqo
	9j8qPZDYLWex8kwD2LxecpMJGe1l3ajz0isuv+jkchB+jCd0/zQUArzcEB+8MKXDQLwDyY5v55T
	BvNQQG+29ZkF1+G+2z3YpeJoxxvtJYstBa1fKN+1NGKIUsM/EhxIs7FzWyoQntBAoFgHdJPbcWP
	JLaI5IFfopxqIJUF+b8N70l2cf8jQRwBnlZ/32vjoxvrb+4Ht2t6W83K8yUyze3r4+8JrGucpFp
	Ro2dOH205qy4dwqihDt7eG3Z38UjjwjaxOVfxuJwcotG21o3Dp6vPv5AID8lHOQECGpl4lDdxOZ
	DrAvDoimjST2svpZ+jm+h03lEyq7yyVCi9POh3J3gGM7HGHQCNX9DtIaf10WJXF6fydrkqBAZq8
	wx4
X-Received: by 2002:a05:6830:4107:b0:7cf:d213:7ecf with SMTP id 46e09a7af769-7d7825a0efcmr10863875a34.32.1773699285999;
        Mon, 16 Mar 2026 15:14:45 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aeccd73sm13375261a34.27.2026.03.16.15.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 15:14:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, Ming Lei <ming.lei@redhat.com>
In-Reply-To: <20260302172914.2488599-1-csander@purestorage.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
Subject: Re: [PATCH v5 0/5] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
Message-Id: <177369928494.700746.8101380068186003544.b4-ty@kernel.dk>
Date: Mon, 16 Mar 2026 16:14:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12706-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: C22642A1621
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Mon, 02 Mar 2026 10:29:09 -0700, Caleb Sander Mateos wrote:
> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> requests issued to it to support iopoll. This prevents, for example,
> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> zero-copy buffer registrations are performed using a uring_cmd. There's
> no technical reason why these non-iopoll uring_cmds can't be supported.
> They will either complete synchronously or via an external mechanism
> that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
> io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.
> 
> [...]

Applied, thanks!

[1/5] io_uring: add REQ_F_IOPOLL
      commit: 9165dc4fa969b64c2d4396ee4e1546a719978dd1
[2/5] io_uring: remove iopoll_queue from struct io_issue_def
      commit: 7995be40deb3ab8b5df7bdf0621f33aa546aefa7
[3/5] io_uring: count CQEs in io_iopoll_check()
      commit: 3a5e96d47f7ea37fb6adf37882eec1521f8ca75e
[4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
      commit: 23475637b0c47e5028817c9fd4dabe8f7409ca6c
[5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
      commit: f144dbac4b177cfd026e417ab98da518ff3372cb

Best regards,
-- 
Jens Axboe





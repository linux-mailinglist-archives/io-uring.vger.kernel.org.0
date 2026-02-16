Return-Path: <io-uring+bounces-12249-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHxKGW84k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12249-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:31:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2CC1459CC
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FBDA304A5A7
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2313232A3CC;
	Mon, 16 Feb 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DowSd083"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE72311956
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255801; cv=none; b=NgEWgsjsIfDaohxbMWZckLV5K6fubzK6FZgmsBPtXW9G2joXFAINwVBkzZXJrHkbkle0uQDDm14kAdBbF9FnDERSD4tlVE3yBve81NY25CMJ0ad1AjJKvicxPYvEPvPaK0k25w1ac3lFO3+TeqxJRehjCxmFkKmj7Pa1ts230Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255801; c=relaxed/simple;
	bh=ccliQLVJDMMtdywkwaopviZAgPrf18Hho6MKg28lf2o=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YmN68W4xn33w+KN2n5DO2KiFsCsx8x5bLtzijO7oqhg3sQuoPnbC+Evh7DdKRTEjq9yrm7u17bSpvQ5PnJf/U6WiPg4QxcDwpB5IljojIFzuqW6oP9p67yRqzpgPqr/LCTV35tpBCzn6l3Z9r+tlEOGLbGvzfWZitGYLv1K2uUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DowSd083; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45f09874c4cso1694006b6e.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771255798; x=1771860598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uSR20ZWKojrLXDJMpbk52t3pQdqxtMBbAgvLVTf+POA=;
        b=DowSd0837s9cIYS2ykKk6Rws0RNiga9UIoZYpDdTH5LwyoA6kaH0UD6jnj1mizDTKh
         vw8+Ed7a3rI5g546L2IS6Dfhoz60NSM6V7GKNIU8bga8br2LAKiliQHWL4mZKZ0SvIMJ
         8V/MFdWx7r3NS8b5zXIOuQXIgC7HH34JYefr5hky6QygwZuAdg+LPNI+pmVKc9MQr3mi
         NbqVWos9kSR+9cbjEQaYfkJFZNn6zTs06w900ukrTgDL0zA1T/KAYdznVQ8a3w7D8nN8
         ZgzvVWsBSz9mGpNF6yCLc1nal0VEa9+sT2yAE4kLMT693CEbS0ghR38XSWUI2AzbzhUz
         MAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255798; x=1771860598;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uSR20ZWKojrLXDJMpbk52t3pQdqxtMBbAgvLVTf+POA=;
        b=FD04lWlQCDrMzsUuxFB+VxiS/EtIjpnkeD6oQCD1npuNrwT/c2sdDH/qy2jxnD0qhI
         aZu0MobYNNB7JupbH5Dmw9YhcQ/0Ocjgw0EVbT3kQxM8ngSs9VjblmZyBBcUvtlaZMG+
         Qh81JFJRnbZBV3QUQP9lOnOwKSYRlbtQyw1wCuNrD1HHNdD6fN6/os7w4wnN9eIEe5r6
         qElzHOUO2Opy9ULcb/6H0UXQzZzPZ1t98YIKUr4zYfxvt5KCrCX30AgHIAp8Tq+7FzEx
         36LAnjefyfu98qzMSImhurdf7ZnO2DGRpx9lflBgFZuwKfptWXuDMQ5UpWMiPfZXTgAY
         IeMw==
X-Gm-Message-State: AOJu0YyNAn1Rh1ZmqiOv4t6ARAf0GZfIy1IRDTRbNf1ZAwsMT09nxZD0
	nYQXfE2Bee1YHkPjAgwFaVCMETP3QtmJBqHTuhaSFKeYJfcqQzNuf0gPxgjSkKH6xTg=
X-Gm-Gg: AZuq6aJkuwsWTZVS6yqa9Mzxrmr1MjcmZV0tMWawjCz1UOYnYIttGiWubs9dCnbK+xf
	wDwxAoaokbNzeQl37JERIS0gNz83/JyK6EX+R5hbDduAb87H3da3hd4JIZKKvR2/rVjOlEwPkLd
	kgUaipLvZrOvdFYwSm8GhmyTGKEQGofR9ePFmifOndBh3MNj2cI8H5pro0OhbzKjicqD1eqWLcp
	hMNJSs04KA861ZcwJDWASrcsJsTxbX7QJZqqkZcrQnT0uiz2neaV7tAvYsoC18hJ5hqOSKdH56z
	SD80LlXMe362uwbHQFnOlROWHhVO4s7rvbeecd+7QqAfZrda17Hw2e3I5OuEhSlmjn+JSX/NWU6
	gq/t4pSgG4q4Y5G3VOOAGmhcf+g/HPSZwM2EBGEVM0R1N/YmuLqf3cfVgMPw3Hio7l2bJl1hSqc
	h4eJqYHFJFZYPfV1v2retazBNSFeoeZZD+Zs6ineXy434Jzy+V0r7q8z852hQJM6U5eSAmr+QHM
	LSN
X-Received: by 2002:a05:6820:440d:b0:662:f4cb:207b with SMTP id 006d021491bc7-6771cf971f9mr4763644eaf.0.1771255798338;
        Mon, 16 Feb 2026 07:29:58 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6777c128a11sm6223317eaf.0.2026.02.16.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 07:29:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, asml.silence@gmail.com, 
 Dylan Yudaken <dyudaken@gmail.com>
In-Reply-To: <20260215231523.308665-1-dyudaken@gmail.com>
References: <20260215231523.308665-1-dyudaken@gmail.com>
Subject: Re: [PATCH] io_uring: remove unneeded io_send_zc accounting
Message-Id: <177125579726.125569.5787093425327876848.b4-ty@kernel.dk>
Date: Mon, 16 Feb 2026 08:29:57 -0700
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12249-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: BC2CC1459CC
X-Rspamd-Action: no action


On Sun, 15 Feb 2026 23:15:23 +0000, Dylan Yudaken wrote:
> zc->len and zc->buf are not actually used once you get to the retry
> stage. The buffer remains in kmsg->msg.msg_iter, which is setup in
> io_send_setup.
> Note: it still seems needed in io_send due to io_send_select_buffer
> needing it (for the len parameter).
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: remove unneeded io_send_zc accounting
      commit: 046fcc83ac1ba8747f0bcae13f5e433802735245

Best regards,
-- 
Jens Axboe





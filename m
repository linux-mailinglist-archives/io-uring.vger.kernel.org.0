Return-Path: <io-uring+bounces-11912-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iL36Hq/mdGkQ+wAAu9opvQ
	(envelope-from <io-uring+bounces-11912-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:35:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC647E0B5
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D13E83004051
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 15:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3788D226863;
	Sat, 24 Jan 2026 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xpwxrImt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946681F4174
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769268903; cv=none; b=QIDrzb9W8L6SQfV3poeIhlAKfqfdkSW4dLuuzSIYbHeFzsIN79Lyway64cS5ldOo/S+eESVdW3UFKUMoE+rbMzs3BY/XlbJL/vJ9xSfdGLhZyhvVD26biDM3KrXCjkUZ+nvx7vhFE9z1qrefnzMZtVnl2U/c7C6Y28/o9hxBFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769268903; c=relaxed/simple;
	bh=9+S+EL3Vka9sZfDYF8EpJ5oh7qU2yr4djVySwGkETgo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jkdIV9M62ot6E5E0Lqwbp0BmSbs8ZIpmoMqWjiMkU/UjHJeuDqpupKZ5hwt4fHZEdHg3AmDBz8NE6inQjieD5f2d+c3b8VdFGYWIl4nl0eftMr89i4vfQj5m+XCn2dRzmSfmNokfagRCzp3Ej6QvNm8F6nTIjXUWwMbhgDxdIMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xpwxrImt; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d148dd16edso2736727a34.2
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 07:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769268900; x=1769873700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toWukZl6LrzwPI7vSI0ftHcSw4pjmUQrJH1kEk55zBE=;
        b=xpwxrImt+sGMZbDgeAv5T8W2VDbeu+UJovWk79tmNr6egs39fI8RMOIs9t1h6271to
         YmiW7CC9buvhRKgFU/HDam9x9LyUpDkcibBylrDmJnNyQqiRbDf6CME7DsdOTcMOxm9s
         3yWTWW2zsSU4BL7/1X43F8zME32cP0L0SJUAoTFD+424VGowfA6DaLr8iiGCVuOhuJTe
         zH7XWRNOMTnaCQBfaCWSxifIGF6wKFcNiC35c8LtrtXwGV0q+FYL36IELZP0Mra7hryg
         ap4BiB9t/3UBSw09RfhqKvhg+RTpT6hQN7KontOKbvYylR0u7dZxePRtvfZsOum6RmP5
         XvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769268900; x=1769873700;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=toWukZl6LrzwPI7vSI0ftHcSw4pjmUQrJH1kEk55zBE=;
        b=Hsn0ktHjoKhfnZ+hyoKjMYI1ZiPO/czrPItS5h2u1WKybAm9Zpygl+aTuDhlxYQwQV
         wdZfkMTJTB8/Z56OMrg4KVqIcxh3hA3Hgiz7GqWqXfQF+TJdYfa1+a/AjfbSfLhRw5QQ
         +Q4iKDi2Tvz73erhpMUM9PTNfGrBD1e2oy41A7NRLILe2YJFJaVTagOOrZY7B4Oo+QJV
         vumHjy7+3t1PaUd+LUiFPNYcKFyW9BUwbiS7MbTMCosZ6Nq+lkgmE0sRBmSBqd1OfRZH
         1rQwnmaCW9KFpnjhil2YwLrZG/LBg7lyGpAWoyhs8Xm/gKusdUKZlBK14dt2DHGuKT9z
         ZdAQ==
X-Gm-Message-State: AOJu0YxTOwwqJSizxk2ILvEeLGSTzzil32IaWLwVX+DyXYpwPporl/nN
	Z8Qf7lY5sBqLUL9DGBonUvgF/IyIvylkCHDMgYBSlYana4fJGuab/Lp4S0pDMyvXfLmyPvjGQfI
	+4FnHJ/w=
X-Gm-Gg: AZuq6aJ6miFlQVExyoxKQ6AW3yTDavzOWODyTJG8zeubUFCkOqsZ/eU8SpZnQLcD2ik
	DdgN8vTRP0W9RPSv7//9J8vD9CTbXZPgYWjjOTZISf6JI/BfDiVfPq5OiwuXlK5Tpg8ZxgoZxXX
	wYN7vMbpxV7CFnkVzZ/faYcFSbNBhlidnnG42i42jnzdMGx50nEisci5z+/aEPY7iBmjZaqj3fp
	1AzuR6W3VFpGg/v4g+/UjpMv/C4aSez4Nc2JlVNCV+L6wI2x1He1Emr/ryID/6aPUu4vkSeD6ll
	PHe2XcL2dE1nhL8cB0R7UG9jB+t+pPY/7NJ4IufvR0HWqB7I7qy/FFf4LagJAJ5hETjCJHf2Msr
	bDRnlPQQKTw3zUOVnkHJptQkCJU3vXens2502w9cbOKdkGdXrFR5aH5lk/aEU0wLdba1fR5ujSS
	HGF2qaNgUsW1RJgxhRTE5uQBclzFzWW6d/RNKOgpUXfJApAf5KI6gzWfAq9lUBKBip
X-Received: by 2002:a05:6830:3112:b0:7d0:2e9e:3984 with SMTP id 46e09a7af769-7d160b30c0cmr2770512a34.4.1769268900206;
        Sat, 24 Jan 2026 07:35:00 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b346e03sm4111159a34.1.2026.01.24.07.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 07:34:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <a840a38936ddcaa4c03b81e66e571a38ca68694f.1769249792.git.asml.silence@gmail.com>
References: <cover.1769249792.git.asml.silence@gmail.com>
 <a840a38936ddcaa4c03b81e66e571a38ca68694f.1769249792.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: implement large rx buffer support
Message-Id: <176926889954.811798.10308845596157999017.b4-ty@kernel.dk>
Date: Sat, 24 Jan 2026 08:34:59 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11912-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 7CC647E0B5
X-Rspamd-Action: no action


On Sat, 24 Jan 2026 10:36:17 +0000, Pavel Begunkov wrote:
> There are network cards that support receive buffers larger than 4K, and
> that can be vastly beneficial for performance, and benchmarks for this
> patch showed up to 30% CPU util improvement for 32K vs 4K buffers.
> 
> Allows zcrx users to specify the size in struct
> io_uring_zcrx_ifq_reg::rx_buf_len. If set to zero, zcrx will use a
> default value. zcrx will check and fail if the memory backing the area
> can't be split into physically contiguous chunks of the required size.
> It's more restrictive as it only needs dma addresses to be contig, but
> that's beyond this series.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: implement large rx buffer support
      commit: 795663b4d160ba652959f1a46381c5e8b1342a53

Best regards,
-- 
Jens Axboe





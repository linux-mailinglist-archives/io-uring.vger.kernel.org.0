Return-Path: <io-uring+bounces-12736-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLNNN3S7uWnJMQIAu9opvQ
	(envelope-from <io-uring+bounces-12736-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:37:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1552B2537
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2B323073853
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 20:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9EC5CDF1;
	Tue, 17 Mar 2026 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LmleBf/B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E680345753
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779821; cv=none; b=IuyV1kBiyVOYrXlTPO44q4ue10w6ORlIpsfOIP23i9Vc5aBL8bmeSgNNTbAmnGVKHkVzVHVIu+aeNk1QN0DCZ3LPAhWrXWYdsq4XzbNDvA8msa6irBS8hOvo+TTjVdSqhiQnYFnb8vJUFPvISwjiArmIZ63I67yGEdciqHuMKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779821; c=relaxed/simple;
	bh=l7iRbWOapqJIgTTLs0cMbEWXxOh8y44iHzOGBy/vIY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z3h7cCanMvUU7s8B0M29eBCsRTCBgRaBfFfEHprrdSa/hy6ARs5f+7ZdG4O/d9hlWj9vcm/djNDPIyGH6AJI5pc/xPQ7r0khLtufOKaQQo0ceUEffBWPzvZgSYW/LDVzUm8AZyYYe7I2WldyNqZOBJ85vM4lw797mo65p2n6l88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LmleBf/B; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-67ba6e63922so3640946eaf.2
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773779818; x=1774384618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JW0CbBVgs6GdN5GrP/J143ogxV5NC8azmgNbhuQG6XM=;
        b=LmleBf/BpT3n7k45oD2QvrBZXhQl5BtVmj6BomSw/3eBW4zdbMWd41i8pLTnLh9ZQ/
         QsxboWMoHDD1xs/CYMZaoarNu3NTtIrYVvjGoLyqnclaCiWRPXXYozIt6Pgwh1G6Uxsg
         wi5rM1+pySlHsF70Pmuo16bzlo/8BEj1chivLsl8PlV00sbNAz2jTeTwJBWJH0ONL3uR
         thtjHyhFSqxVjxLlN6Hf/fszj0FMNTI27B7PuLV5x+jO65StS6lOZM1VzHGD+xjNuxMW
         w6N2PxB44CfREyMl6688BVJnUi8BCuIz4UM8+4O3Egv/MyPQDiqjFHk5+xTQJ4AAa+1L
         G4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773779818; x=1774384618;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JW0CbBVgs6GdN5GrP/J143ogxV5NC8azmgNbhuQG6XM=;
        b=mZgMNGjDJYqiGtCIj0w6Rg6X5rB6Vf39dzIuZiPbEgr8e9MT1NEZNFImA4jFj8jDT3
         OnTz7gum0GbQim8Znq2qDSACBEith8WbiKBcHnZJLZk0a/6S0s5D9XLDAFgrWSEJhQFD
         99aDh1WNqW2NixPsvj7sMdLBDKxrlE96OGiaVte0yhphpAhX1v6s8lss8X08sFK7BQ2C
         A+8NKLUMSmbsad5AvSWpYcxN/7dO5x0BLCVeEVCUxPRdVZ+NiFGecmeUGvtanHjS7Axn
         YPWJbC+ucgA5Daetw1ti8o1T4MjzogAbg2lSTH/wxmdTU2r3ZXXLkEaSlQvEeiZKfweV
         Bz7g==
X-Gm-Message-State: AOJu0YxTjJyOjsCzwuYlhnOYs1fdNXBKqVpg+6bOJHdtsMHs4yPYM8MZ
	0/6brY8uH6pVweD7Warq3Aa2ck3rWhjlhWIlwX3S7ON+rH8QV0m1E4szTbxmWs5YJ6g3DUcOlI2
	fFUI6uUg=
X-Gm-Gg: ATEYQzzkGSFew9dGbU2Qd02mD+u3SVtbsmosuGyFe9HhHC7S6CGY+tsLOUCGoW5omqz
	/1mGRXFJOrkZQGg3b/drEPTsS8Pyx8rhK1k/o8S2dsAG6aivk/XJ34rOZrLqWIRgCLdxs5x/+jf
	vlmXYDDrb8+Ai2V5rPj06A72/BCynY6RrYU+46afsMd6aAGOMzxf1JFs5EKc3hGNBTc7hDO5Q/K
	BwfcV+iDTO7Be7F8V2iLzHBcAy/HoR7y1vByoLkqnoR6pJlybawB4xKLTmvopuXKndrFpM9RGLe
	akikIvJ01N7G8TSK9StoI7qq0xWf3Xae8mlVWIUKkpZBDBsqEiuNSYwa1vBupQdNcbwQrv8EL8G
	h124ghhQfD7JZ9urcVqIwxT1OHJQNTcKjP5U4BuzME3sSqj7c/WQXk2RHd8XzbBBKvKB6fYvHOd
	MnjyHX5uCX38KQrLf163iRRzhZidZeRvCtf8XNjlbjospZSg97dwYZp4rpcXzPwtzOZ9/CLqfwM
	Mo=
X-Received: by 2002:a05:6820:4c0c:b0:67b:bf52:9990 with SMTP id 006d021491bc7-67c0db27e83mr503817eaf.58.1773779818436;
        Tue, 17 Mar 2026 13:36:58 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d7e5b46sm461664eaf.2.2026.03.17.13.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 13:36:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
In-Reply-To: <cover.1772109579.git.asml.silence@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
Subject: Re: [PATCH v10 0/4] BPF controlled io_uring
Message-Id: <177377981764.1008333.17403039550067431801.b4-ty@kernel.dk>
Date: Tue, 17 Mar 2026 14:36:57 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12736-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: DA1552B2537
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Thu, 26 Feb 2026 12:48:37 +0000, Pavel Begunkov wrote:
> Introduces a way to override the standard io_uring_enter syscall
> execution with an extendible event loop, which can be controlled
> by BPF via new io_uring struct_ops or from within the kernel.
> 
> There are multiple use cases I want to cover with this:
> 
> - Syscall avoidance. Instead of returning to the userspace for
>   CQE processing, a part of the logic can be moved into BPF to
>   avoid excessive number of syscalls.
> 
> [...]

Applied, thanks!

[1/4] io_uring: introduce callback driven main loop
      commit: 033af2b3eb19c5ed96825572105bca3611635ada
[2/4] io_uring/bpf-ops: implement loop_step with BPF struct_ops
      commit: d0e437b76bd3c979ddaa6205f5e9ad3e0f95faef
[3/4] io_uring/bpf-ops: add kfunc helpers
      commit: 890819248a8616558fe12e6c06c918ee1c3a2bc6
[4/4] io_uring/bpf-ops: implement bpf ops registration
      commit: 98f37634b12b17ad5c56db8fb63cf9d7dc55d74c

Best regards,
-- 
Jens Axboe





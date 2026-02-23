Return-Path: <io-uring+bounces-12363-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPpyEp9anGmzEgQAu9opvQ
	(envelope-from <io-uring+bounces-12363-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:48:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E03541773DE
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 21A053038024
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 13:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F71924676D;
	Mon, 23 Feb 2026 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xpq6RM1h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4DF248F47
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 13:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771854440; cv=none; b=CO7or6P8AvxN0dAkTfl3vSv3Lw1cjD+TyRlhr2eG5p+1zSQucu37WVonoN8LwrR0d8BENYnH+H5zvHJ1txz/Ess3sFbHc76xGek7mXdla0soLJZ/n8UFnxzJXHjBUfC4anOs3nyUvkIbhSfzG6vBv4uXgZn4ueBxQWlBSPeGOwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771854440; c=relaxed/simple;
	bh=7zth/tl2fQpuoc1lmtqB49eQMBf3PBf9/PjlJViut7k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TTsO3HisoHegDu03qAOrk80oHEoNtmZbCgvJdT8R+zP64D+4kH9YUR2YFJak/V+wkLgpdQL6QsiTk8jVXxPrMfpL4+2iOt3Gnh/HQFd9I03bdzlOt4dSSor0UPALbgc4KcHbKl1676yaOAbsu4FouwPqzg8B4Ayxx2G5Xl0IjLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xpq6RM1h; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d19d3c7208so3040152a34.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 05:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771854437; x=1772459237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJP6ra7z2jfLa9U7bYd24o6nRnSCAKMlo+Yar4aWEQE=;
        b=Xpq6RM1hmS4ZiJQr8xqfSVt1Tt+UGXHKpwOStV6NfnDQa2h92GGDpxv41tNW79jfjj
         fQeIdw7Kry59ZibKkcWxcZbVepqAD+FGUXwc6UHei6vHT+1igcmn2FT22KGMHHy57rKd
         Ijarjn/PaUpko22haEMoav45vX8YH2zKIhBoI0sxi+2VTnGz4ewMMXDub4vhBIeASPve
         rNexSKv2jgSlvvydpAOyl7qr1SGdBhEcsfAEU4p6P9RzzewwUqHpMb2gnPwX0WOOc97s
         Q3aVhyb3X6WccddOCoTXSmOibZbPteyB5IPrt4RvEkklr3vhHP2FxeDNwAb1A60xwfll
         eEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771854437; x=1772459237;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IJP6ra7z2jfLa9U7bYd24o6nRnSCAKMlo+Yar4aWEQE=;
        b=S8ElT5AGfLZ2Vu0/+6rCa/6QrONul/oJTMyo94JAV61mIRi0BhsVL5h49TTpap2hkh
         ebQJYHEbxq73uZzMHhH1ja7Lt8maKrldlrCJHOnmJ+4UQlNCqg4C4n0shC8aPEY9+yP1
         X6bTgETFA8P+7bxLRYGsQ5pPBvZ1GYFPPgSKewC+azG4pQ25/AKB8Zu7adRDIahxssnZ
         UBdHG4p7GsVtBeOYxom8+TBX4Od+gAntj1Y2jD1UK0Gv9b5XILfHBitF8VbGjwinFR4w
         6ZItQTnhzZwF78/DkPzNtFEJN+Rv+1DA3zjYhvWslHc8okQ95icoQK+ml64QwLLEzuBn
         2SYA==
X-Gm-Message-State: AOJu0YwX1qdZSsl46ScLHudJdFfLoFTS3tgLVU0s2qrNtVcBUC+aRWKj
	wao3XZRFaEFPKNJPmbvCgxIy9DcscrvB3aF28As1nBALbp6p06sQgpttYEyb1SfzrxW9GKXUygk
	2rp+WmYiOlQ==
X-Gm-Gg: AZuq6aL0YGTOiVMblMBvBLnEa5G0VqDOvyyWBpCRuyHzffI+s3FRMmflTYBwhQAtue+
	SbtjSvzUD2Pmczzmyq6yr5jsJmAm8dksf+3MCwOrBhtpeH5S5p8Xfsw84JXXHglXs4o+853K/yQ
	r6jxKojJg4apOFfndTkK3mBD43FUs0DrGxFiLkYInJ3LFcC1Yf71aqUwHdNORsrYxiKTcoyg3TG
	uU7OQAIclgoSllj3sWa5k4ztDqOxriaUwn4+kFPRT7uRF9HN/XqLNsVNjivJimn4Ud16AsQUM4p
	VeP8sWKxSSxOkUX3U8w3QIDdQ1+P4kFmGturOxafUPTHe5EcgH/gmYlVjXm4MhL7rX6s4jFT6Sb
	LHViygkep5FFnqz6QkyFiWnzh5cFKmyY8y2qEu73kUIvY24GXwY3c2/1Xu5qqMOcxDjWpYllBVP
	2lFHZmlQnw4duHZHpFoG2Lmg6hBrrhKns5Q+sUF3mLxDpqGaXnNGmV40Q/NWaBVoSVGGvuUKkSU
	b5l
X-Received: by 2002:a05:6830:b8b:b0:7cf:dc3f:6b34 with SMTP id 46e09a7af769-7d52bf9c600mr4788579a34.20.1771854437393;
        Mon, 23 Feb 2026 05:47:17 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d04dadesm7246370a34.23.2026.02.23.05.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:47:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: =?utf-8?q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260216160354.73239-1-ast@fiberby.net>
References: <20260216160354.73239-1-ast@fiberby.net>
Subject: Re: [PATCH] io_uring/cmd_net: split ioctl code out of
 io_uring_cmd_sock()
Message-Id: <177185443630.636584.958787696686053869.b4-ty@kernel.dk>
Date: Mon, 23 Feb 2026 06:47:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12363-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E03541773DE
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 16:03:53 +0000, Asbjørn Sloth Tønnesen wrote:
> io_uring_cmd_sock() originally supported two ioctl-based cmd_op
> operations. Over time, additional operations were added with tail calls
> to their helpers.
> 
> This approach resulted in the new operations sharing an ioctl check
> with the original operations.
> 
> [...]

Applied, thanks!

[1/1] io_uring/cmd_net: split ioctl code out of io_uring_cmd_sock()
      commit: 4148bacb19a84ae2c420d13ad1f4d77981974ba8

Best regards,
-- 
Jens Axboe





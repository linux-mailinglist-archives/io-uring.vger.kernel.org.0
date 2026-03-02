Return-Path: <io-uring+bounces-12514-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CP8FhS8pWnNFQAAu9opvQ
	(envelope-from <io-uring+bounces-12514-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:34:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D707F1DCF16
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2135930ED0A6
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8860130498E;
	Mon,  2 Mar 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B9sqq+Xg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7126730B53E
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772468929; cv=none; b=SO/xiKCKvkL4pYaKIkQGxbd2RIMwejLw1Rp6+Z3hBSS389g+tz+q0ECYJPeRTyYd4fpDRGF/V+XcEXvSW7fAsqqURWZ89oLcXp+W1ttG/TblDxSmyXUhFmou/7TEarMzSjAYZ1CE7QhdTHlnvefDNQSuIMSvRVOqq8uALSZpays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772468929; c=relaxed/simple;
	bh=YF1pAQxdq7whYsR24AnUCVCKZevR3hKvC2nr/BRkRbY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FE3127aTADlA5t4s3ieYW6TZDwZrB5kB45cFMbng7MkpWplfrAyCGGSNy+6rqhPeMl/uukYX2yld4tuqB84TSJOq+wiV/JqHxR9bKnSxEC8kP3jkIni5iH4LOpiYzvkwi/HAVkxk1QcjvzHjP81AoPk8dxN3WUv+0cIAphndSDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B9sqq+Xg; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-899e43af784so23783556d6.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772468926; x=1773073726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PGYaiKsC47fZARAZH4Y0YjOAfao+Z5eM479LPqrUQv4=;
        b=B9sqq+XgXsKToEeu2XllgE5Fb2bDUO4i8r2iPJLG8rCx2/1u2/jIwz4HdWCc24Z6iu
         1fOmOhcjWMPXdUdd4jZwhEFkaAR2F0RMHYrCvci7t6c3IebIswFb9XzncyB8x05+JFhK
         BCDRwJVq78OT73b/6D8oC3se56vCCgu5elM0DPI6o5lDDomnZpIArX6nLW4JzSdSzrkT
         OZUAdYMX0lQ3VIIxz8T1bxUhUxzHqjDnO/v6FtZcr3iavNMBqurQrU42jABUt00Egnp+
         yqcMC8a5Bx0JuFBEMbp6QOu+LKblXrtAq/5h8Y0g8olOOV148SEiGrQ6V+aChdtT9+IH
         MXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772468926; x=1773073726;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PGYaiKsC47fZARAZH4Y0YjOAfao+Z5eM479LPqrUQv4=;
        b=gATgPCX/tUk4nZQCxjVh9U6E9YZ5kxJxDKJrUEQuWfSop61edT3Bkl0Ib29cuEfoPH
         TkincEfhhIDBjkNBGZwUGvf5oR4Bc1QBUiIrAA/hCmksndlkBjtTHlbR36rVlMNon7DB
         k4fJ2mWIFSUsE3Cx3sV8m3hPgQDy0KLGPt+STwayu5kB8RRu/gsd8Y4Ag1851jgttIXd
         0xyWQgIEBKL3Aark2FmI5sGgy65VVfGocE4uvmFg3zVy3OBRgUddwIFAHryfRKTWhHdx
         6h2hhIPV5HeLm2fxOcAR8c1RwIyypuD6ZSb4drjC7Kd1uH2YiwU8klw0jaAccMVPD2Ak
         6yog==
X-Gm-Message-State: AOJu0Yxz79OeAUN7DTX2h3ItK+qHPPeB0GsLvVYNAh26PM2OG3IKcSsL
	7esYcTedR6LTN2yrGTavJgBjD+XFjETWeJ/KId/XZhoWoQnQvg1wRFYpmSZHRBdgpU8=
X-Gm-Gg: ATEYQzyGTNFl2o3QG8ml6aOJaK8wN35rlQxqZP3pa5pn2jHjBUct21qgpHjl4zRE7//
	HoCGUpPmphZGydetJ37M/CalP2R1B0v83KrrkOX2jL2UzbCVtBg9+/Fm5LVmZ5VgGoK8LCY1H1v
	rWiWLFIdG6EWuuFRefFqvrFzg2bh+WtJPkyyQEjGUbLR8pOS3uF/wEGlnyczsFO8Q90FrYaOliv
	Zma6lZaAtGIVx2a+AMXzoeL2ZlOoPJJtGPN6Ye+X9jBNDLBw2WoX7E9IIfG4PK7/57nDY2EEUpC
	ux31gqqLQuG6GZ7WCPzTxcBi1jASuHrhYasmcql6FqsvCrvW4x+ke3u0fHLWtA5s8vf28F5cQvp
	va9N8MGIpB6FjWOLy34zy7RHwfMyVSBHOrOlsjF+xAQysQ1tR996xzLzHHYU9faXfil4Y1l7nrI
	Itfq2Wtl2sgsgXVNgOhkVKrmh3+DcVcer3mvdP8r4HzogmsN96MQ5zBucSz4JnGbeRLtnemN9F+
	4EopuYpDTyzow==
X-Received: by 2002:a05:6214:8c2:b0:899:eff6:6e76 with SMTP id 6a1803df08f44-899eff6764amr52855406d6.44.1772468926096;
        Mon, 02 Mar 2026 08:28:46 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a04849cb3sm9035126d6.6.2026.03.02.08.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:28:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <74d3b5c7058d3acd902514e9bab060ff6f9212bd.1772461896.git.asml.silence@gmail.com>
References: <74d3b5c7058d3acd902514e9bab060ff6f9212bd.1772461896.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: reject SEND_VECTORIZED when
 unsupported
Message-Id: <177246892515.112159.7774984137717185830.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 09:28:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: D707F1DCF16
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12514-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action


On Mon, 02 Mar 2026 14:32:04 +0000, Pavel Begunkov wrote:
> IORING_SEND_VECTORIZED with registered buffers is not implemented but
> could be. Don't silently ignore the flag in this case but reject it with
> an error. It only affects sendzc as normal sends don't support
> registered buffers.
> 
> 

Applied, thanks!

[1/1] io_uring/net: reject SEND_VECTORIZED when unsupported
      commit: c36e28becd0586ac98318fd335e5e91d19cd2623

Best regards,
-- 
Jens Axboe





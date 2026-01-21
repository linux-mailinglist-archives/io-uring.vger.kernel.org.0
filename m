Return-Path: <io-uring+bounces-11859-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WG+wCqHycGk+awAAu9opvQ
	(envelope-from <io-uring+bounces-11859-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 16:37:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D2C594C5
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 16:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AE9B976D194
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 15:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A105C306D36;
	Wed, 21 Jan 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xdWm0lNm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9966C7E0E4
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007346; cv=none; b=nBsR5+mdEcP+r8j5Ru3oh9u3C5o13b1OFtLiu8qQR8rfgevESrFqug4BlPTrFd+tmstQYkwgqfs7Q0QECGvFmuS6tKmN4XlB3tNl1QjCKmZtb905wY+4JnmJQNN8RsZ1EkKyHbPSxCLXUceNaMrwz9JNFMsRLjqgOQAczhK5Vdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007346; c=relaxed/simple;
	bh=SQcpTXHAPebzvuwzsWc/VPzU9/WIUspDVvoSBSw/L6I=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pYkgr+zRMm+QOK7tFHoe8MfvvgOt9zY+xOhpvMdDkXtD0JpFMhGB5Ut5HPyUn9eErKsfVssNt3XA9WWYwuVWE2jRIFdVITXpGGeuv6uj8H5JWj/puqTqTL8upg3qx+p3OIukGL7FtL2vYA2O1UBCxAl7MtM1FKLEV2Z3wizmGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xdWm0lNm; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d148dd3421so350412a34.0
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 06:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769007343; x=1769612143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Ee3U5pqhv7jeSVnLG9QRoWOc0jsrMw+ouX+gaOeIsM=;
        b=xdWm0lNmuzlq7mi7qpowvDbha05UZIJsCAcI1yJSPtDjd+dEL/8VP0BEhpIUGZbRqY
         /OzLzvaPP/Yg/R7VnqpcdkLbDNylR84V6CkgPNnKe3zGlCsiTyzZ7aLs6oZ4UeghUxgg
         1Sj3SbspDfueKf10+RBMaorkOwiq6hnLDrUcN3wcXMHveNuvywO5bU1eBmiM9DifhwWK
         wpEIDOHUrV0TGZDs29bDD89IW5PaO6VoowtSukkH0AGCv7jO7f23bnWSi7DjSs/YE/l0
         EPrLagDucn7H6nfcBFioBif+wuoNxvuHXjCuwYjzSqv7xtyN/Yrhzhh2TFF1DnxFI7Ea
         OFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007343; x=1769612143;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4Ee3U5pqhv7jeSVnLG9QRoWOc0jsrMw+ouX+gaOeIsM=;
        b=sif9WJqaeyb9auPBbAPfQSRdpUJbnUZNS5F/P0cGp8nlRLMpch497uPqQlUrPQpIKY
         wf0AqZK4F0dA4oMJC7tpq+vVZZJC6EjCviE6J5CQU/r48cZ3vidXXxOGun9zpUo35oWP
         v4BkgZTT2kbiQcCSqzASTo2VBQkGQEEm+BYYolPF4ttDj/64xNvNaf1T9dqchNvCWrxw
         d0Eqbpuxk/j4v1S/4QTdLWuEAwgFELpNWz0Y6BhMOIbHyETYoYoXkEO1iDmvl47IvAAB
         XBqsJLwbfo/G5bEpXkJ/Hf8AE6P67FkcoHFwTD39/OgHTkCTdVkLyopdSt9yBIAMlY4S
         XOCw==
X-Gm-Message-State: AOJu0Yx8SDkpznzeoGjuwoxKzw8+06vL6JrKL0U1ZmQGd5aJrvtCllpQ
	xChUXcjAJxnIXnQTdeM0+QjDqtThliS2gxxNII8ammC66ypP8+lNrEW8o3wtCRPqO1BMjdSSykU
	GOP+NABo=
X-Gm-Gg: AZuq6aJq6kQZgMzC+/9QQ8HtqZPxAjSlh1rlLhP6DREWIRUAV48yS0c7cNLTU0UNjEn
	TieoHS1QsqArOp7wKGI926b2eDZqNW4P9VZAOQntktR4lXOpUJvaNHsvp4iWt6gDb9GFtGbUy8b
	jccM6yFwxfv629lrY71DxFO/YXPx8W+1GW6Ps6pHYArx2L3LcMXdYQghObM8BHVqyUZmngDqW+L
	DhYVQTIhc87ttJ9viaOYQs9toWWxSn4XDZRjOrZhrro4jG43C5tpt4kmly+x+OWjN8Rexvf874v
	JpfIIu5Dl9zDLnsJiszpFyc2XR6sTNu8OZyFByszFCNIoDhw86an/7AHyteukQDUBMtk2udQUOa
	oQcN3Z8Sh3WFe3NHJtL+0SGLmumCGUNdTeR8iXEvS4WP1lR7z2bC0YgHdWnYUDx6ZmUpXzoEv+/
	Mgy6q9wNm6Azlmcitdb/IWSDGUVrLfDExZCHNo2+0cYih4XiJu9OdveiXQ1lTmmcA=
X-Received: by 2002:a05:6830:64cb:b0:7cf:d7ec:1893 with SMTP id 46e09a7af769-7cfe0229ea0mr7022233a34.25.1769007342982;
        Wed, 21 Jan 2026 06:55:42 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a60f1sm10300762a34.23.2026.01.21.06.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:55:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1768942757.git.asml.silence@gmail.com>
References: <cover.1768942757.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] mini-liburing updates
Message-Id: <176900734149.11503.2663573327241782887.b4-ty@kernel.dk>
Date: Wed, 21 Jan 2026 07:55:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11859-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: C1D2C594C5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Tue, 20 Jan 2026 21:11:43 +0000, Pavel Begunkov wrote:
> Update mini-liburing with NO_SQARRAY and io_uring_queue_init_params()
> support. Sending these separately to get rid of dependencies, but
> they're also nice to have while writing selftests.
> 
> Pavel Begunkov (2):
>   selftests/io_uring: add io_uring_queue_init_params
>   selftests/io_uring: support NO_SQARRAY in miniliburing
> 
> [...]

Applied, thanks!

[1/2] selftests/io_uring: add io_uring_queue_init_params
      commit: 73061dbeca783aaf311e1af9610f8cba1c1176cd
[2/2] selftests/io_uring: support NO_SQARRAY in miniliburing
      commit: 145e0074392587606aa5df353d0e761f0b8357d5

Best regards,
-- 
Jens Axboe





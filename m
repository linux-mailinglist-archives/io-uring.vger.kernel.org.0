Return-Path: <io-uring+bounces-13572-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDdFIB/lHGqZTwkAu9opvQ
	(envelope-from <io-uring+bounces-13572-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 03:49:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D73CB618AC9
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 03:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EADD23007E3C
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 01:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF7A1A6815;
	Mon,  1 Jun 2026 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="jWBrBFEu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B91448D5
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 01:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780278468; cv=none; b=mLYmBbsNAHCRlO9IFNUkmx2aV/WB+UfA9chW7zJMhbEsqQ7EDZ1yqhhCKyt7SSi2sGtLaHoc5Qw3kDDri807BW5KTA9V+pCK+OPIDsA6du232EqxuTUWkfxZv7I2AzjZVqbWLMIb2qHKUM1VYdj9r/F+fJGix4utRywsTaQv94E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780278468; c=relaxed/simple;
	bh=WnRyvGjpMt5RBQl70VieCFocaB97nn4QrlAXnPCTCuE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=opP8byBvVo5GU+5zs+hAWY/B3LJllAadL+Efq2MtEts4IdgHYWfr4/1UR/ivN6ItkjGBLm79Ilha/hudkRhLAinDioXZiKFfm2bdHQ6tMm2vIuHDRpbNMZdPEvAKrspcejsVoSpRI39FnFVksvlffdWoCwli2sZMMo/2aNdCHmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=jWBrBFEu; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43bf5f4ee8dso2694828fac.3
        for <io-uring@vger.kernel.org>; Sun, 31 May 2026 18:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780278465; x=1780883265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tB5EL8Rhi9qKT2QoOgXudFsNdbKOqjFRFUpfHfwDsc0=;
        b=jWBrBFEuKZbhAG/GOmNfoxhOELcM9kYInNjH85p3YpFgKLWLpFLDV65aqVujN1btH/
         6BtSq7JYmqpfI3DZqBrbe9kDdtctDBoEW+I4pohyD4/h3zCKGh/GYNvMhlQ7qPm8s3+b
         s9EjOB4G4z4mhgGbcbWSxlHHBKMUNopKFgr56XOmcOIr0W7fZlxsCybcPOgNeTSjv4C3
         d6PyynfIY6uRcl4ZRNU4DDv1tflqfhBjVXQ2P+8Yf+jh+ywgtrJSx0Ojc34CzZilSDCd
         LGeOWvG96YkOrGfw9Pv3A2oYz/WVTlireMFDU6N7xBhunNgETa6oKqybSjPOTci/dVr/
         FgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780278465; x=1780883265;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tB5EL8Rhi9qKT2QoOgXudFsNdbKOqjFRFUpfHfwDsc0=;
        b=VwEzHkHZus8UFhSDhq5D7JMXkdJZbRwFAVfHg7p5xZCr8LTxWocnfzWxFve6vU2n44
         hzAWFklUBXkvf+3hok6GIiaTX3CZbhuIkd/11ZydDGa/mnp8eJb9B8y/IXAo+QSc7Rm8
         7SGj2ejOVWB1aYr1JwYs3RrWj4AmxCD9bmocXBCvJGt/p7TA0fdBX7+eIH3ugrvs1VtH
         soyrEuOVreExyoIggXGGibbQkNsDkL8G8PB2v7QW+A1w+rIs896AWusy+2mR1nYjqSgJ
         Co1VFCWtpHyyOUUiPAGk1H1yvHnLDfX79Lv5koZeh6xvyUn6CooCUB7yTYCzMLzFnDvU
         aVFA==
X-Forwarded-Encrypted: i=1; AFNElJ+hO882v7bjnfeUZKzjgHCg0YWzDMffwqrgp6PvrYPd5sf48A1pmeUJFcHae8ZiSjuCROpkKJYNFg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5esAsW4qFmJqwxuaKdBJm0S/8sSmFmgry+g1mLS7W3foL9XQT
	Nxd31i7UXYAjnAqSaqc5SCzhnqoAoPN1GJ6wKCBi1YE1d+W4A1kwVgTjW2PqgjGxZbM=
X-Gm-Gg: Acq92OHXXzu66ZkU65KbRJMvSOxA3EU6imwqH47XIAOtJAUaaj9WgK8TBhCWXGtoVFi
	wlek/GV3F83YNHWn2jvTwaudjtUqIWn+VmLM2O/lESSP8dXbHddYZv6C1Q4OiR1XfXD/jU7U37V
	qWnwVbooq5AXnlGLHCyptgjztvYsGdJKjw5cHk9GlBQtPvWDbanxkwvzV0wGzZhK0A+pPfJ8qP9
	JfNm77WZabSG7Bx+YP8//9bRMf2qyCIe/izIbSn/m6nWBUYxEuORgyDqsSrlK+EQe4Wgvw5tV87
	rqinfS7TxYLK8kPTp9fXOUe/RVNG7emMev/gqEuDRVLd8AJWxMjkyaQ6QNpg4wSqj6Z9QI44N9K
	Q1ARHSMvmcIJ3J3dbTx0o0f2YKxj0MjTFfzg5gzx4YnzT+XLbwYwIttSnFBgEDLmDA/tx+8dczS
	x089wzhn8FhhOLm4qi8I2YkjcjoBMP/m0KNS1SvnmMjqcmZ4DPURSZEqWx
X-Received: by 2002:a05:6808:1514:b0:467:70c:a7d1 with SMTP id 5614622812f47-485fb43370fmr4269971b6e.27.1780278464735;
        Sun, 31 May 2026 18:47:44 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.55])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48605f6a38esm3494847b6e.2.2026.05.31.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 18:47:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-mm@kvack.org, 
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
Subject: Re: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
Message-Id: <178027845531.370486.4907470779948430731.b4-ty@b4>
Date: Sun, 31 May 2026 19:47:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13572-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: D73CB618AC9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Thu, 28 May 2026 18:59:02 +0100, Matthew Wilcox (Oracle) wrote:
> Add the convenience helper bvec_folio() to avoid references to bv_page.
> Convert a few of the obvious users.
> 
> v2:
>  - Tweak the kernel-doc (Christoph)
>  - Add the bvec kerneldoc to the documentation build
> 
> [...]

Applied, thanks!

[1/2] block: Add bvec_folio()
      (no commit info)
[2/2] block: Include bvec.h kernel-doc in the htmldocs
      (no commit info)

Best regards,
-- 
Jens Axboe





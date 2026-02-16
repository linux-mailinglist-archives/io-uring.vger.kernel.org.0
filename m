Return-Path: <io-uring+bounces-12250-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GF5DAAU4k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12250-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:30:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8530145998
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1284C3019397
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0199312832;
	Mon, 16 Feb 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0Z4Z/sYT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73362310644
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255801; cv=none; b=Nqxs5qf9Xq07WC/SeCIJwV5wejoZskVaIFC8pOu+J45cQMsyqKE2e3cUFyhTlAZv5E59wmTPQmkq6eV4Obp5BDJWhgQ78DpgF9YW7oml6r5uIYvsO6u39T5WKIPG2S4vlHm8l+cDcvYYfs0HN3+G5xkasz+OpQy55YTNyd7MBoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255801; c=relaxed/simple;
	bh=Fcy9B/4QwjS/frkqR/zDLNiwvrcIeY6mh139NKE2pVI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ovvQBdM4uyrUABOyszqvDZ42R2ujZJrATxXQ9caT74GbRubCIUOQhuMRH7x+Z9Yfz3RO1DpLD6f0aN4GMfbfOanI0Qb9jv/zdRRK+wmhZTWlrQLUnWD7+RPu7FDmWtILR/TmrVa0f6h9ReKscdPcnnmnGnnURKxQRdt9q63FLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0Z4Z/sYT; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-463967f35d7so1978962b6e.1
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771255799; x=1771860599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gb1fpqC4bMtJgv9oGHlyGkx8SL9x2XLeahuAVkXPBOw=;
        b=0Z4Z/sYTAH+oPxfQEc/ozDu/xhNKYA/BMRyDPAh37xRiedmAJRX7XAA7IYBvwAIRjY
         GjadPQY1xeCChoiiPq70sqAroIq6Jq+SBZsBpr6lcNt/pqGiIlGZAT4b4phDF77CFgpd
         ETBiCSMVDg69wXtxUckQuQzgyO3JdVN1xi9RqY/MI7Gia+m5QMtK3i8Hk1n9mGtw2uxm
         u8mDZQQA6i1J7oStzWfvgfttLELSAEk9WsYGqqw6tiUa7SLS0Dh3DncjNx0n7XHYWVaW
         IVdDtbdOopwpM5RdL4TF2UD4dOMbSJk0KnwK2o97OOFNlAHPAhb6WLsmYBiNqPkVmiF8
         wqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255799; x=1771860599;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gb1fpqC4bMtJgv9oGHlyGkx8SL9x2XLeahuAVkXPBOw=;
        b=DPVL80ItcP/nuoLC/bYPnE/wu62LlBZ8J18i/fyKbfbWNMUBOlOdRGMrWU/5WqNahU
         e03i68IpOamya/bz/T3pxKMHm18UYtJ8TKbcMiTKR6qFu1hz4swYYkoQpQllX4mYmB6M
         cs2Gqc7jLrHyOFyY6SA4+WXX5tjin8BIOV4gEDauxj1BeeuzcAjB3nXJ6EhoGZW3aMKv
         TecFGMpSESJdBq5tBwITcIX0cXisTojMfLrh1Rb0r53AyDE+vGAyzl2vRBN5HSvq3sfx
         26fvtAPi1zMi1KfZ59rI0q6ELVJHKD3iM1PoYILnuQfY9N8AgDOZsmhICsIDDt6g2eIG
         3mlg==
X-Gm-Message-State: AOJu0Ywm/hSDkmHdXjCs0tIHrkZIUoI+qDqxvjsx3OKwea6Y/WB/Gc95
	yDmtlHpBkHSBfkNh7jojSRv1/zJ6W3BG/NF8vA+1QcnKlJyHZZg+1y8WLri4DOKWuJQm6kr5/Pe
	PMEtpTZk=
X-Gm-Gg: AZuq6aIJVFMsCwaF9yDCLAL4xTTPApJmPvUz/djtrUDBxfZPyef+S6vYlCBwb5CKFuS
	haIAWHCFNcX2RjZW9J+5adBHe3sKc/ukrq8a6VGqyJ+Gi8SKnAu3RXI1QFYmP5KsIBaRnQtxU4H
	ySUoe90sM1MVkzpu0rFnJ+HNKHM1qXcD0x89MlEOoxmdY8LQKUZqwMKMxj869Qse0ZaCns5ofpz
	JhHXjIUcvQ0ZvR9wtIfk71Jwvemg4YjD2vVlmZ3swhYOb4exUrlX2QjU68z38T7nCZ43uOlLvs6
	WkWWJ6gwUGISfS9WROkv1iLMB0RN1+vXAh+7FiV5VkNjhW3b0AoHzIwcELfhWYAm+grPIsWjmyw
	2mKfM5rP/e4EqGeAPl+WnwDGM5TKRS3ck3AjIckCytxHmvGHe+vBVxoZXm9jqxxx0iYK0EIeoJY
	kwd5EVh3xFWVQ2tW7hIjt36vsjUsIOh69v/KyZurJ3CIyMF8WiNWzQ6NfUO47OvJTRpnV938UnM
	sM79rQzwgVgJ08=
X-Received: by 2002:a05:6820:4dc3:b0:668:d715:1098 with SMTP id 006d021491bc7-67722c5a5f7mr5224788eaf.59.1771255799523;
        Mon, 16 Feb 2026 07:29:59 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6777c128a11sm6223317eaf.0.2026.02.16.07.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 07:29:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ecd56e25297fa8e9cdd03420f96e994d763f984d.1771249534.git.asml.silence@gmail.com>
References: <ecd56e25297fa8e9cdd03420f96e994d763f984d.1771249534.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/rsrc: improve regbuf iov validation
Message-Id: <177125579841.125569.1566167076255469257.b4-ty@kernel.dk>
Date: Mon, 16 Feb 2026 08:29:58 -0700
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12250-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A8530145998
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 13:55:30 +0000, Pavel Begunkov wrote:
> Deduplicate io_buffer_validate() calls by moving the checks into
> io_sqe_buffer_register(). Now we also don't need special handling in
> io_buffer_validate() passing through buffer removal requests. I also
> was using it as a cleanup before some other changes.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: improve regbuf iov validation
      commit: 2e02f9efdbc6c73544e315b7eb85e55a59776b6f

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-12589-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QE3kM/fKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12589-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 37449239BBF
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8096F302BBAC
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06ACA35A38F;
	Mon,  9 Mar 2026 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="10Oh+eqG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542A3A4F50
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062698; cv=none; b=Vi5fbLDpUHUE1rGOIyUc5mdyA6gTVoTUDwAFz/WN6BQPYmc9ahehiUG3HdHSzvgj4CyKwr5s+7EUPYlGN4q4lGltrBkWFZpOt2Q8r7Z9rW9GNV6k01bfIWDgxiZnkb3q+ULma06aCZgmuyh5Sq2yblcd10XnnFvhOatl0I93Ntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062698; c=relaxed/simple;
	bh=VATwanWPzGb2xlk10x85rXCszFdZN3xHOnd3dRzes0E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KZgauuqceyrGcbe4hu1BV9AaUN4V22wyGNSMb7cZ50OuyTlVjD0+E+AeAp0ifGzfzP7yl4/GnHKrmL9qhzwjNbGql/5TGLgqxqfgf7HgE6fKuilNs1wYf9US9X8XmtygGHp2cswSPjanUlcUW4OJRGYUgJV09m4iLbgNBw8ahk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=10Oh+eqG; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cd73c4a827so269922885a.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773062696; x=1773667496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mP3uA8DXTLN6df0id7ImJuN9svPh00AabwIN3mvJQ0=;
        b=10Oh+eqGUy2I+AkI+LZVCNj0q3OJElqLQe8MAG9/U0FDF6pRk1jvGnYfflmSRPiBbA
         mpSsv3ACz+dTHx8E22C5t55LNC/R7JXjfhFEhkFN4h99hLCmTtQsLq2FzdXWZJz+rg+k
         xpim7g94Ye1zKSxEuIaJ/zP8DqA0Og4zUNZYLuw/o+o3KjgXYeJEMUc8QsfUcSk/gV2L
         IlklfyJ9WycsSHM7gnP84k3nN1h50K2J38jafPnVVQDf6KOU4ykvK1udziTVwjbZsZtf
         obGuQXDM5etnQIOGMNQX40ttIP/54c8ZS+XwOqMGITZagE3sv/kkf7h/bcx5Wv6sJFi7
         izAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062696; x=1773667496;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0mP3uA8DXTLN6df0id7ImJuN9svPh00AabwIN3mvJQ0=;
        b=cwqr/vqHu4/3QcxHlT0viCpeWHMavjNR5mFRZeweXCrqGhc092tU058Q+qEoFCy1iJ
         VOWNEIcc1GePMc74vEcvjlttpWTQrQNLhuNuEHzoL469NQo2Isxx8qhPiZVdZsi/kL/7
         jezmRVOxh4DtrdFR69ZN/WjG4t8QVNgq3T7UW7PKF2iQ89wF0pFgg5HmfPlKfruXlVxf
         qejkpt0DBOautDSvQGebLJ6QhXzPXmXJoMzPbgc9ExR/MdVLCgHKYv2LBmAWinsn8N+6
         8VKvzRqKNsda1z4xbvoi0PtIOnnaTyXK2dBgDuoHMjzYWexhU4rm/ysKqq9XNMG0bfPw
         egCQ==
X-Gm-Message-State: AOJu0YyootmMrr7WjzYoV2TGFaoFBw7LcEMQ0jZ3zyZuy09Z1r67nEjY
	eEZlj0Jz2dJapKV/vccEelc5THEsFy5t7BGWABtHMDkHCAdGdy0VU5GAT/Rk5nj5XUs=
X-Gm-Gg: ATEYQzyxu3/sJu68MIc+Ek0KObV52+gh+iuCzvu0yn0KQaexaw4G54Rqf6PqkK7B28V
	zbTC74zwAKWd7UN9FkGswhy7EWGmG9s5lasaNX1NajiuirLAGosbARsU42nbomqqmUIlI5AQSH1
	qYHbf0EH6hvtv+Fv4VTQUqLqsGs8xByIQurQbyH4cet256lrYb0CvykWNznIzEcSOZUPebDSOGg
	gUNP28WhjeOd5dHNLNhiCcLAiTSsUNuiEkcvqS6PuEA1c3t1Diw0YMlrukCRzxSdpKp3pKEp2Sk
	BaTlpAU6OMOii+BRRm6NB39K/gA05NSA46rxl76pMSt9rfCWQp1GR6vgP1TZwEVoKbuWImWYV+Z
	e0Ekk3A8IAKtB50lWIG9QHsGWLyiIK+tGhPSewaoiFPvKgBQe7WOTeXQZ3sSU4vbQ6xLBcDZN93
	p+FNOW7UjRB8DnyPEaE63THguqKZcf4vCz6GRsks+899rLAGc=
X-Received: by 2002:a05:620a:290a:b0:8cd:8f18:d1c0 with SMTP id af79cd13be357-8cd8f18d44dmr165894685a.27.1773062696219;
        Mon, 09 Mar 2026 06:24:56 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f4840b1sm680245985a.1.2026.03.09.06.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 06:24:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
References: <c151f006cbac6eb51863881d338b101186740cc1.1772493339.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: allow vectorised regbuf send zc
Message-Id: <177306269257.10980.9320078608011135738.b4-ty@kernel.dk>
Date: Mon, 09 Mar 2026 07:24:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 37449239BBF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12589-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action


On Tue, 03 Mar 2026 12:32:19 +0000, Pavel Begunkov wrote:
> Enable IORING_SEND_VECTORIZED with registered buffers for
> IORING_OP_SEND_ZC. Set IORING_SEND_VECTORIZED for all msg send requests
> to differentiate if the vectorised version is expected.
> 
> 

Applied, thanks!

[1/1] io_uring/net: allow vectorised regbuf send zc
      commit: dce00c83035b880deebf7b2f0a204f740cb90d64

Best regards,
-- 
Jens Axboe





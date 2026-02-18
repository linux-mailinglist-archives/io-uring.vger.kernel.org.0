Return-Path: <io-uring+bounces-12317-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AM8VFoP6lWknXwIAu9opvQ
	(envelope-from <io-uring+bounces-12317-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 18:44:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D825B158672
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 18:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D0B73300CFED
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354E6334C09;
	Wed, 18 Feb 2026 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r6NLG9hz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2FC3451D9
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771436673; cv=none; b=MrJADjJ48YV7aAt7GQzkn5nL7eqWjpL2KYnOKvwlPKBnmG5DzvcyHrP037XOLcNo5egJR0pUdU09l88pS/o2ZNiE8OAomt7DoxRJzoEcduuPf6NndEOVucnNaT/bQqHADB5dJc4OneT1fXqf8Za+S8Dml1XZ9fSoa0GhqF2rA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771436673; c=relaxed/simple;
	bh=DAPjo5Vesdht9bmwlcZvfhdk4I6QmRF2Twzcn0AX36c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i57KicL4sKT9GD5ycn7UeKBaKJNw5m1jqDd2rsuJmgiPTTmEcyI2AFnOKbPxZ3bvqYslUULFNPgWL/0cmY5F2hfbk1RzmWPe2ahkA/GObmjCRlwKPq0tATA+xRoOWKa9f9y3LFuqzDiOVlQACE+mSBSIdalRYnj+GklSq24P1Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r6NLG9hz; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cb38e86cf2so6081385a.1
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 09:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771436670; x=1772041470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f52Wwd+rDLXDwPRRIQsN1Yx7eFsotz+Oj4co4oyfPt0=;
        b=r6NLG9hzAvoVeSWlXgZGbw+lN8td1J+RDI8qk2USRLFr61sKh7xRAhF/Ooza+b2EYQ
         R1OKBSt0jZVYvSviWOYKbNudYJG/yTngumbRrpN9w8xMPc+efonOWASOpyawZMDuPrjP
         wFul2msURiZxQSD7p7KR6YfmF4QX/jFe9bZgYeblsEM/ur1J8TyvHpWlxoQ5Ps2blUBc
         hYHYtWsuJnzJPeWcVsUUrH2kam3r/cwzjzq9xO1oh5BjGySVwZSFRCuwDw6Ukl7/mbAG
         04P9S0hnss1Nd8W5fTT9cRE5DMA0zAgsGiwIEvEFkR1VjpuHSA1gK+3DYbzP354zXrKV
         BagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771436670; x=1772041470;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f52Wwd+rDLXDwPRRIQsN1Yx7eFsotz+Oj4co4oyfPt0=;
        b=HasELCwwqPbJGC14uEdTuj4gq9Wdhr4VYokiNuL81A8yjvLcqGH98BtolMzc+nHwLQ
         UnCcCYIcfn1lQhEWCQM4gljapCLbJ/I3iTAI2FR93dS9jEokBxLmcf8cMIrnoXPN1OBh
         GDt/hKzb/n2VpxlwhTJKY0F5J+w5zK680SSt1AoNCio+19xYONaD1LssmRmG/lIinJwr
         OCiBRzkFPHxLYfO0aOpihK6Ve9eNx+VjHnJXcevOxTw2eHGiAkTIQHK9aXhoxkV2ICzZ
         6T/7lo8t9Q7Q0Kyy3wc8/8QeKEH5EMxDMj7qyhHrhQ7d0vyxN1VqLCaD62vb3C4xDYd9
         41KQ==
X-Gm-Message-State: AOJu0YwDIjzwEj93dFahCl1xMPQJ8Ie5agv4V7wEipVRhd1MOE73+TYP
	BnHl1ULaU/hI9SRrutoAosax+lyieZd4ohfs8qcEmfvU7Gnk1IhPWI7l0kArK5mOiA0=
X-Gm-Gg: AZuq6aLFSJt+L+VWLGqbeb22koovqfVbgHxiEhdtlznDQpMJGC3uGR3Jg4mqb16AzZe
	sB1+ZMzJZjAtX2yrjnga1mLBoiAQRzXAns3PZP6SM8FJu12zkqI1tiXXQ+lKpFNnXra+QDj5oWL
	fdtTLEw6nYi0KKSMa5lNXQNTfjbMz9DHLM2dp0sk6QiUhWIlrqf0IjJ8jqw1/r8oXuL8dFYlWAD
	+Y7y7bS5ZAb1qqc8nUrSQppQa8EOd6jUeSQCaF9jt5zldI+kVvw5s4/sreLW53+gsV2JTllBY0N
	totVjSLgyiaXnh3XrtUO2pximVUbPLuCrxQOWm7njlLQdJSEwylz0DI4oUOlbDUuLjHeF37F9P6
	1rdxpSKdXD5lS7pwgfxsq/BWCS6w0MJwEA9htpb9drKVH1rYTPGIDxjZQAUjJ71KqTC7TRuXDo6
	h2R3CrHwal4drl4G/PuGP/omFL21lLP6A9YHSW9af+F3Ci
X-Received: by 2002:a05:620a:1712:b0:8b2:e666:70d with SMTP id af79cd13be357-8cb4242a53emr2221223485a.43.1771436670115;
        Wed, 18 Feb 2026 09:44:30 -0800 (PST)
Received: from [127.0.0.1] ([99.196.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b0e12eesm1872969085a.15.2026.02.18.09.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:44:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Kai Aizen <kai@snailsploit.com>
In-Reply-To: <364c2e7d4f53b26bb3133cfc4271183fcd450be2.1771435883.git.asml.silence@gmail.com>
References: <364c2e7d4f53b26bb3133cfc4271183fcd450be2.1771435883.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix user_ref race between scrub and
 refill paths
Message-Id: <177143666453.514340.3486576920762114601.b4-ty@kernel.dk>
Date: Wed, 18 Feb 2026 10:44:24 -0700
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12317-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D825B158672
X-Rspamd-Action: no action


On Wed, 18 Feb 2026 17:36:41 +0000, Pavel Begunkov wrote:
> The io_zcrx_put_niov_uref() function uses a non-atomic
> check-then-decrement pattern (atomic_read followed by separate
> atomic_dec) to manipulate user_refs. This is serialized against other
> callers by rq_lock, but io_zcrx_scrub() modifies the same counter with
> atomic_xchg() WITHOUT holding rq_lock.
> 
> On SMP systems, the following race exists:
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: fix user_ref race between scrub and refill paths
      commit: 003049b1c4fb8aabb93febb7d1e49004f6ad653b

Best regards,
-- 
Jens Axboe





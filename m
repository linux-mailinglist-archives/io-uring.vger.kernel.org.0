Return-Path: <io-uring+bounces-13021-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPKWGn0G2WnolAgAu9opvQ
	(envelope-from <io-uring+bounces-13021-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 16:17:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B75F43D8874
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 16:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D1D130595A2
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 14:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249E03CF691;
	Fri, 10 Apr 2026 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrPaYkMn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95413BED43
	for <io-uring@vger.kernel.org>; Fri, 10 Apr 2026 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775830531; cv=none; b=aVb3rE/N5fGhURIOnN5bJ8hNLXVwULV1mJ563RF9VLr7SvTCufOLuRrUW7h9pviGYzhQYbis/j165X1EVVHQ5qldVhAQuWoeWzLD1jV2lONo0Ft4Pdu+Dii4/SCNgeiFMQewJOOytCnqjMbniJp7HRnPQ06MfU9OVox2pYldGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775830531; c=relaxed/simple;
	bh=ZMMwOHR8+o5eywy7A4dv25R5kTA4VWF1ikDRQjsig3A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcpcOhaa4WtXv0n1biA0xVMI9tirBZVyHfPZEKCnNAKxONU9ka0R3cT4A6hbbh/LFfXPIbtzQFkbKUgn3AxoBytzWSnP/IBeQgPmMkbLXmhakxnF88SrMjCzeK4rRLcmbDzspEjwYTGVfv3FurITPLBfOQdXUr9Ye2nmW/ZP6m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrPaYkMn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so32074205e9.2
        for <io-uring@vger.kernel.org>; Fri, 10 Apr 2026 07:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775830528; x=1776435328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibVIM3YRkDFxVQFXMQG/D+NUY7JRDZKRc/EMBS4wLuY=;
        b=WrPaYkMnAp26p+pfLHavvii60oj5quWpAzHQOoJpk3pNcwB8rRbhAcKP26y3rCOfjE
         2bUhrt7cYb6Ytu4f0pOA7b4UONhlHUH8Sd9zfz3SYosJTJGUD7Hg+ckcXSQKTAis6fZw
         9/ku5BNFLGUqtIy4L5xgrDN1iOl0uNey2cJwZ43btsTFwSwE7HTK49/FdpdwoNxPjkQ4
         pXO8Nw+TAjBMMzhpIg2JFep7mTQqTxtply2zVnqUkP/nz7ZNxLOcaQAz662QuPPQX5jf
         WbmgdSTexyz0b2WpbyKoHyVqOE96QTZGb2TuFeOf3FQiBQ/nRAOW4R3uXWSuJiUuQF3Z
         00gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775830528; x=1776435328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ibVIM3YRkDFxVQFXMQG/D+NUY7JRDZKRc/EMBS4wLuY=;
        b=nbqYT5+T8FvI2pSaGV9OaPp8mZ4Oyyfsf9SXfj5FlQBuj7ryt/ALNVJgISHOVHyfGJ
         Tj6DaPKPeVG19a95j+ye1I23ndcY3xCNqv394EpB2LZLoijsPK+qgdHUDf4bFsUCNnPm
         CENMwP54yJQRtQ7lSlGaELUZeS0UXfmJoDHHmc0W4WGlqWn++iDA9uq1mIDccVltvLA4
         67ZYiBUaliCJyOdFd+vq97HbrHGw8UhDTJOmnN7EpnrGCwPoW3H21/L7NXBLpErv02yN
         0wAjPUGGXZBIiE+YGFgHVaZwiqa+PeR9K/g8zWx5BbSH21P3APK5tSDPg5T4YHfBVDQa
         zTyA==
X-Forwarded-Encrypted: i=1; AJvYcCW6g1SOUUxQSbPU873011SVmvp0U9jGSkQLi5cJAL4ChEEfyNfT+RUMqLkh5Bkj/+CUoO0TK9t/rg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyaUHzqTN03NnNlALZSxHaXiII4JWRGsVhwxh+ZtklNNpf0Bbun
	+N4UjwQYZcRwT1bXg7ZG5NxxVMLfI6wnOkd1lOy2rcIevTDJlVponEYj
X-Gm-Gg: AeBDietp3xBKnADIita3Ak3P5btjGMEM2b6AFSnFr9MrlMOYf2e3e0h965ShvBGFAx7
	W5cP28rNxmGHEexb6G12CcY24ak8ITV4uV5pJHxkPN2mnyBwaKLW2jeWZ4GF0+bznjcluTY+lfs
	XkIfoEld7a8ec97EAgqVjXbBKZ4YUaevQk2AUdH0ARwlBlCdis4FtddFPLoNcelG3UPW78+8wpJ
	oV0D7Ebexcm2puopIR2KN3zbZN8rY4ugE65hXo52EqAX4eoVUsWDivnG+E4vw9s332xITRIXfsb
	6hbgY3/m9FBS5kEcXBUhdRsuS5B+R6Sk9sRtlgDHUZ8++UQPBoxVMiMa+NLU5w65QuAT2L3da5m
	leHsHX1blga2XlxWYpn/FB3HJjHxTLgs8u1XkN4vtLcHLqV73jVrzFHmny8scWQQIGvb/UZJB5x
	yDLhsTkIAK8YZzwcv1UlyeIKTM0OvE5LNHrzO39CJC/bjmGi+SpYXUeLh+Q/BzBX1388q1p8Uiw
	eY=
X-Received: by 2002:a05:600c:c08e:b0:488:9619:9bf4 with SMTP id 5b1f17b1804b1-488d686093bmr29672415e9.20.1775830527797;
        Fri, 10 Apr 2026 07:15:27 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d68585sm36286005e9.1.2026.04.10.07.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 07:15:27 -0700 (PDT)
Date: Fri, 10 Apr 2026 15:15:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Kuniyuki Iwashima
 <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>,
 metze@samba.org, axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>,
 io-uring@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
Message-ID: <20260410151520.3e91c2ce@pumpkin>
In-Reply-To: <adjkn7p4U13WBs2o@gmail.com>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
	<20260408122653.295953dd@pumpkin>
	<adZcnNgxhsUjAgZW@gmail.com>
	<20260408195640.324ee932@pumpkin>
	<adjkn7p4U13WBs2o@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13021-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B75F43D8874
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 10 Apr 2026 05:29:37 -0700
Breno Leitao <leitao@debian.org> wrote:

...
> Since these legacy protocols represent less than 1% of the cases, I'd prefer to
> optimize for the common path and handle the exceptional cases as exceptions.

Optimising for the common path would pass a fixed size on-stack buffer
(say 64 bytes - or perhaps enough for an IPv6 address) through to the protocol
code, update it, and do the copy_to_user() in the system call stub.
Write to small constant offsets onto the buffer could then just be direct
assignments through some pointer.

The 'buffer descriptor' would need to contain any associated user address for
the unusual cases (also look at the sctp socket options).

But I still think you need functions that read/write at offsets into
the buffer rather than using iov_iter - which is only really designed
for sequential access. It isn't as though you need scatter-gather.

	David


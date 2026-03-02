Return-Path: <io-uring+bounces-12517-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0IPHDFbCpWmrFgAAu9opvQ
	(envelope-from <io-uring+bounces-12517-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:01:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8514B1DD6AC
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F6423078EA6
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3425F423162;
	Mon,  2 Mar 2026 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qqEHMF0b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BBC3FFAAD
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772469724; cv=none; b=WV5J+5z8R7HiNRl1qpO2Ef72rRbi3RqaJ5zW6g6oO8BHG8RzcwSqSwj9uPoYZC4Am5vA9DvlJVZT07iJC6hRjGeRjO0OtrCXTKYwZYbS2WS+JEruCSzsLDdrjxD5fo2hEYBNx/pVMowNMWYz4HD1rnykd2TbCUNfH+KLeLA2M1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772469724; c=relaxed/simple;
	bh=zP9o4qlJl5kuYubAcmp9wM9BOLgEINjYXJRNn046zJc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rWw+EP9MgBmehdUDyXUXA95Bapl/0DeOavcQMYevt8REviRxq19EgrShd1ogBskxGWJcKT5hmCpF+RXnAj9llNkf9Ko36zk+hzL5MWII8BAC3jTADtBj7FV2YqOa7xIqCI23l2QjsHjfBzZ1mshSAXC7s8We4aZJpA26YTRd2UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qqEHMF0b; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb39f64348so460086685a.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772469720; x=1773074520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DMixDRqyXj4Fd0Keu6ZPXhNF/wE4q/x9W42uQT5b7FM=;
        b=qqEHMF0bwVRL4IDBBUrDsZ4G+LZ4tb7o8sv9UowVtCMZpPGXLnVmTNxvHfd7Rh9k/G
         DD2pmDvYg44r1OqtmHl7fcx1AHfi8dqaVq2t8WbrhuP03vg4r1ugmi3sIIRdxaxHVi72
         AisOqxZb0jHnYoKg0jSMXzuKTx1fk1DbcF0f+eTefd9NTGFKytZNLVLsPfI4QE+FyJbg
         Q9dYF6OUkxkJCBlaBYLDQsLRaUgoSZ2FnuQRMdUOrEU8zbz9Q+Kv3Sqgtkj3kIU+oR0p
         74OkdIiSO+rvVuxJA4HJNJpPhlloITGzM9zdhFSO/wa0Sgm18PqLbyQe+jotHQFH7pOK
         s6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772469720; x=1773074520;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DMixDRqyXj4Fd0Keu6ZPXhNF/wE4q/x9W42uQT5b7FM=;
        b=wJmnD7N9nmHeiE4FerY24lr2E9YNbg83L5rDgrVQ4oxk7Bl6HuzBgmIenxOnbFfQ3f
         708AaZLRRW2R5wyGdhrfgXExrVKPkzB/EKUSd/pZcj51fZrbPWVM60Zg+llZ0Y3EFBH0
         BD3iljRPB7AAlp0AyZplCzPm/jxe4xg0TWGfaNVeL8k5u7HUhKN3KKJTDsQfegXco7pl
         lbYqILyNISVy9lnG9pIpo7y9SnXJmmL98+zq2PdwwmA0NBzvAE+t/D2Axql0YLu+XZb5
         FkBUqF59bpia1zkegq7Ge0iwu5Kw5+zqolV6Yrz7FSacGlNKjXEg4BDSrSzVCNzypubG
         +T0g==
X-Gm-Message-State: AOJu0YwvQWtrhFGiSvbAe3ODpkscGbvonQ2WTxrsf56mLA8hRDf87sD+
	ZxvguVzUQ0uJKd9mgTqWLsfXF0QTphVffLcoebEMYxVYBS4rpTL2h3iTP4puf0QhvPfPGrs+CCD
	qgskujRY=
X-Gm-Gg: ATEYQzwR1RZrEiwWU1DksF/FgZpf/1f1LouNsUUOw9Y6bhwnpzZ71hj/RfkQEqKSxY8
	DZr9pG7QgQswOGlgVyIzlGwePWYf3ARm9wL1ZVWCkDeJwvQUGCdgfwlC/Aqopk3FdYTGRQh5Yvo
	fZF4bUwggB3XUBE3ifZ78/Nimn+kuu7uhrVFrqDWqixEFiP3z1XOyp3P0XIHtRBSyucuZ3X9Gby
	gaHN7SqWgDlwv1xkKf0A5n6vZ3o9XA/ge6cZMgJ4Sto1jdjcRSSaLtDH1cC1+hp6jKM1FE8fJ04
	aCGL0SrO/J4UJ49iC/ewH5XgZXteR3jx5G6wZ5xUAG75C3x8qh0ox33Yya0RMUHnTVhmVbatVje
	pPpbKzO4aZu4zHjJbZNdL9PA15aIXf1pSiIV7k0NbwJcBR4K7Yp/HWvnDSpc/sbe2uFhQUdYoSs
	Ldir8zGKzj8PGSZdIW4iAKSgZ7WIfwekjJw325W9ewVcLkfrWjWsG6HszY2F5H47ntQtPe4XM3b
	TM=
X-Received: by 2002:a05:620a:28cd:b0:8cb:5130:cfe0 with SMTP id af79cd13be357-8cbc8df7177mr1743090185a.51.1772469720325;
        Mon, 02 Mar 2026 08:42:00 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf659210sm1177020585a.8.2026.03.02.08.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:41:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <89b2497fff2bb02b9f08d693ee1ebd86dc538a8b.1772469512.git.asml.silence@gmail.com>
References: <89b2497fff2bb02b9f08d693ee1ebd86dc538a8b.1772469512.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] man: document that immediate abs timeouts
 are allowed
Message-Id: <177246971932.116007.7968153158350396817.b4-ty@kernel.dk>
Date: Mon, 02 Mar 2026 09:41:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 8514B1DD6AC
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
	TAGGED_FROM(0.00)[bounces-12517-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Mon, 02 Mar 2026 16:39:02 +0000, Pavel Begunkov wrote:
> Add a couple mentions that absolute mode timeout requests don't work
> with IORING_TIMEOUT_IMMEDIATE_ARG, now they do.
> 
> 

Applied, thanks!

[1/1] man: document that immediate abs timeouts are allowed
      commit: e3117ad9f470d7a72eb99cd7052a3965ed1c1a21

Best regards,
-- 
Jens Axboe





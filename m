Return-Path: <io-uring+bounces-13418-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0I2IMkFpC2qnHAUAu9opvQ
	(envelope-from <io-uring+bounces-13418-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 21:32:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B5008572E89
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 21:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 93419300E33F
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 19:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87180390229;
	Mon, 18 May 2026 19:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nVkwfxv8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF0220698
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 19:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132732; cv=none; b=UQ/0r3YYt8KIRP2OQWVg2NozoocoROwCQUvKqSXRGVUOAfrPU/J7d6aNFem7s7AdGvoxMMkxOiu+IS8YX6kjHu/kKCJjsUO/Yb7YAk5hZ6Om9zU0rh7Zn6mkud+Hma8IKKY7+KhnlRiU4Qf+nMYvvHqgsNnt8BGKOf08s3VvXWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132732; c=relaxed/simple;
	bh=QYmuDIiStMaUtsiWssaz6N6y6eIelB3BX8f4iyHfcJo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WJypcz9KWdB1ze6Qd7O+xmnnesCxCeDYt5jlkjyaJDLTEXI2jk5+lNiV4KU5PoHZHmbbzP29P2SNwb+1th0n3tbjrg9sh6IMxWbIcKDlcI5kGBaB1PCmuHw/nVuFAVrUaek/WF/OkNK79yFAKrtknVj2HnB4hlDPvtBSsVR/O2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nVkwfxv8; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479dc6d26e3so1711716b6e.0
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 12:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779132729; x=1779737529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5H8uG/E2bOlZXn8XqsiCaUKXr1rzTmZC5bNmsFZTVYc=;
        b=nVkwfxv8HICtK+Ul2Tz70KzmWMqBk08sdtioaAUc7dnrt2uttR0p7nvkewIUkIQ6/Y
         YA9Vb5c5pgDuZUl04eM0B4mBtpcR5T4EXw7phSfEyHuTPBnHjEHK/6QeNEy03tVMrxzk
         u7i3+GO7iLzfGUQvuhx9MQ1qsIoh00rfnVT4VZfp3iv0NvcRIVRhvwj0oyIqDUS4zaIj
         jxFGCBx/Aqi1BI2rubjmUe1QCRHXbg+5AKpJ6W37RuoxXlwZJC8ZusN9weZTuv0zHv5v
         oAnWoJ4ZDoRZZyDX0eRFWAVHzqkwD1SIilhzIgJKzJdoCzUA+8AY+vhBMgjCz314TkBG
         ozDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779132729; x=1779737529;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5H8uG/E2bOlZXn8XqsiCaUKXr1rzTmZC5bNmsFZTVYc=;
        b=lf2fFhfY/HYyjRu7SAr7wKw5k1Z2pJZSdzcR4pWyv5MU5xGiW1muxRwzTiVZnU8IgI
         LsgpUl/I06e30R9nGSj5tUZ4R7IXs+oQXyocKd2DTexLccwtUK0sZ3Ev1yOHLUC2tmh8
         zXBVp7zrmQvXVWxYo7rKG5tDMDYaxP6KGnqPOWrfqtPyezpNk+HIayjMBQgoNMZ2BWn/
         P7yr1fIhfK+nQDuDXsy1t8QEyqOn0FHiU80Izy8kENRJB15LzW0Bb7T5aoXgo3LZO85a
         J65kFFB5UewVSVy5dVPIGJLIuiCGkG45jhnFpOcHCFD5RAQveNrrXGFUTPhBfqAgygef
         OGXg==
X-Gm-Message-State: AOJu0Yw3EDZ/6QqqZBmSGT4TNDfsoHsvBSqyuYhHuCW3P/NkwfoAnmtB
	3mwoSdS3+BInhYNg7Diec841jaKuUb3ufWO/IXZyUz9KiwWT3ZyuofQ12WxSxXG/2tU=
X-Gm-Gg: Acq92OFqB7EgTVExB4vXVuuRobGztwnQBMtflTVb19UVa7lkj8oQAfSDQ7asYqG0AkZ
	ZMf9YOEW3I4wavtweWW7i5BKWDI/esPKHDrouONCF74tpDKOlkbx/dYlcp9RCyYMLsTCDWfitXd
	9Z/PtMJrikhcz/+SYyC9kiQHZUlzXQf99KcRktGFVeIVd7Gb6OEZJzrIVkdpgpcZGucbbVqCtaW
	zuqJKn6otZlsYAyvYmAsi6YslxFpThIEcNN66aFLYmxwU7oF+ZWa0thZMaJvA9LhPlfIr3vuTu7
	zaULBuiAVt/p6nhfaFjlpKHwbihU20hZgD1OACj0lWzIkm97MfRUGji2+0JWqYkl1kZ/mC4T2LR
	Cf1cB60vARgENSIc5n/LlukpEWHrlzM7PYSEeX4X+ZYz6BSCTDeCqoYVn4+hv7b+7g20bMKpDFE
	BQvLUc9M+JLAUNRgrdrjFXizzuYx1wCDqkzW5APH8aLihMkMQBjY6hfwqvaUdjPY5wWTKPpYerk
	Z8=
X-Received: by 2002:a05:6808:67c1:b0:46a:c987:ba00 with SMTP id 5614622812f47-482e5760189mr11264468b6e.32.1779132729591;
        Mon, 18 May 2026 12:32:09 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482ee5349a5sm5590422b6e.15.2026.05.18.12.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:32:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, 
 Michael Bommarito <michael.bommarito@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Li Zetao <lizetao1@huawei.com>, 
 Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20260517213010.696135-1-michael.bommarito@gmail.com>
References: <20260517213010.696135-1-michael.bommarito@gmail.com>
Subject: Re: [PATCH v2] io_uring: propagate array_index_nospec opcode into
 req->opcode
Message-Id: <177913272776.72259.6860661058366230514.b4-ty@b4>
Date: Mon, 18 May 2026 13:32:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13418-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,kernel.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: B5008572E89
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 17 May 2026 17:30:10 -0400, Michael Bommarito wrote:
> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
> array_index_nospec() to io_init_req(), but applied it only to a local
> opcode variable. req->opcode is initialized from sqe->opcode before the
> bounds check and remains the raw value.
> 
> Keep req->opcode as the canonical opcode in io_init_req(): reject
> out-of-range values architecturally, then write the array_index_nospec()
> result back to req->opcode before any table lookup. This keeps downstream
> users of req->opcode from observing the raw user byte on a mispredicted
> path.
> 
> [...]

Applied, thanks!

[1/1] io_uring: propagate array_index_nospec opcode into req->opcode
      commit: cf18e36455603d65d4745de83e2d1743c54ada47

Best regards,
-- 
Jens Axboe





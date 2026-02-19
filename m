Return-Path: <io-uring+bounces-12334-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLgIFdUfl2m9uwIAu9opvQ
	(envelope-from <io-uring+bounces-12334-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 15:36:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EE315F946
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 15:36:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED55B30A35E8
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D7433F8DE;
	Thu, 19 Feb 2026 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1WDfi59x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59E126C3B0
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771511539; cv=none; b=goYtbHsnTLS2X20+cJ2fA8dJyfKhjZ9erZA17DxZl5J0B2bR4oJBaYkhMSOivhDUmz2Eo3C6+q8NTksRMZGpbCv6Cd1bVYKiNHpTwSXwiyK+PlIamgj5bzTWqGMR4lRCnzesRdoZcV04GfcqfWIn8UKXHbkYoR65eOTj6hq8OPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771511539; c=relaxed/simple;
	bh=8BTA4aCRB6kWdJJUhK6FkguA7xJn9sugiGbZUFNW4ss=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oMB2DjBzBJmckzO1df6GvilI8yOmK63u1R/wAU2y0YKzvCcoy+HZmVB7hJ4Nm9E+EF8kJASA/D1boq6r4IhD9a2TyayfACetfgAowjPVLTat0NfsllHr0c+6lYJ1MAgd72qRjEzA+lufN88npUj+hIuJjYsfx6kwKByWWhCbGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1WDfi59x; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d4c65d744cso586288a34.3
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 06:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771511537; x=1772116337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZuKqmgZR13YVOL3V1FKC2RPoGRD/CLGgTrLcuGYSAI=;
        b=1WDfi59xfAS4CtXl4PhqrzSxpjFKDU3i9uYH94nzpfa4UQPIh9UyXHpOqpKflgHBO8
         AxYoaM1l/CSupLBmBQaKX8STqE/EDxia4oXrYkoJwHFBd7eep6ECTuLmqE0pen7s3v6g
         ZJmRFQ+OJ/XhtBJpAF2zko2No5RH6iJRfzDTVDjMPjFZrnWr1CgFJ4hY6nBNOsF2FV2b
         /YZtI+cBCHb8CZwkohMbNgX6ZKBye1Tgm57A2xX+GivXCFiQZ/8iH+bwHoa9LIFt498m
         SREU5fC4fvh6WKZp7jJBCsW+xNFxhIB8AgNXX+KEr4DeBSxHtsH1zrpuf/EmiE3fi4C7
         COUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771511537; x=1772116337;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+ZuKqmgZR13YVOL3V1FKC2RPoGRD/CLGgTrLcuGYSAI=;
        b=EngZkS9FTfIJ+NStCmfzWeOQkBGxYnJp2JME/lrcrgE8j09I7U/P/TarKFnnuAwOU1
         bLhfXTa3aZfMHFrrDjeDK4GcoC+5Y3xgXytolCz14P+N/NO4n12Qb+ITqB2sr3p1esnN
         0DE5RG2RvkMvMy5kZRCa9XSdeQcoEmcKtV4AWVSaD0jwYPHG+paiwbTVCoKnL5dhOD2I
         DUVXskfW8CcHi2rasFcrW36cWqui/dOx2p6Ul/tCwLBD9Bv8emTtTIMuaEHIMH7JO6+G
         Hy5VncCJHVfAS6WfW2OskVa7FTuB3dXPzVqvD8A/zPnU3bwy1E8dDItCVMfWTODQdfBy
         hBTw==
X-Gm-Message-State: AOJu0Yz06QmHDqk97QGOXCnD4EJJtPbCSrcoY+dy9NM/5JCKCRsFFQbA
	XcH9sJuGm4siCdfDVOWWCqJD6NU03DycfIL8SHDAHaXnGg6wkIt24N/O8CLXHXe2N/c=
X-Gm-Gg: AZuq6aJUV2Y43slyo1zRI+8EEeCbiqmYbEOsocylkrBM6VW//l8AtKeWqyO2pzDZKKG
	ew9JFX/PEdHH/c65IuGcA+isdEiJG2h+LhdNjUJtYPR5OhSCRRwov57YCKoEuzczWXZqaUfTs7u
	tHq13yhts0fWS2uii5UKshhv6UlYObUOHARkVmGIffR6eYIIIQTEBk08lTqsKJwWFWZBmzinuiz
	0XDWkPDo1JzNMWIjFRD+wo5W+RnPvEICW4JLcF9/o2xHheCiibKxteofnOALoXHhY8cSNVc1i7w
	xYt8GB3jVGCIBrrhTFtcHUC1Nd078Z5PnUP7dpECQbYgWxh60kFXFq7KaTEUFny+lZZvsZ9uD/A
	2FPdqRW7lx0kPJ3wHTlV5sApAZdh7h1DLGm+hk0EU8+YFbw4kkAshK2sTKIiKsPWJiAUQCypPU2
	1p95CKthhUpwSAxz91Aa5Icit0hmpa8j4vqRrd4Mo+4MGzsfkdVnAsWW9fDlOTA5BjcxUxHDZzs
	nUxzA==
X-Received: by 2002:a05:6820:150e:b0:679:8861:f58c with SMTP id 006d021491bc7-679a742cd75mr2901928eaf.39.1771511536942;
        Thu, 19 Feb 2026 06:32:16 -0800 (PST)
Received: from [127.0.0.1] ([187.199.77.89])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-678b13aec01sm10280366eaf.8.2026.02.19.06.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 06:32:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, csander@purestorage.com, 
 Govindarajulu Varadarajan <govind.varadar@gmail.com>
Cc: ming.lei@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
 miklos@szeredi.hu
In-Reply-To: <20260219045930.935755-1-govind.varadar@gmail.com>
References: <20260219045930.935755-1-govind.varadar@gmail.com>
Subject: Re: [LINUX PATCH v4] io_uring: Add size check for sqe->cmd
Message-Id: <177151153556.554113.2575771011828245874.b4-ty@kernel.dk>
Date: Thu, 19 Feb 2026 07:32:15 -0700
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
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12334-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,purestorage.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.996];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: C7EE315F946
X-Rspamd-Action: no action


On Wed, 18 Feb 2026 20:59:30 -0800, Govindarajulu Varadarajan wrote:
> For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
> check if size of user struct does not exceed 80 bytes at compile time.
> User doesn't have to track this manually during development.
> 
> Replace io_uring_sqe_cmd() inline func with macro and add
> io_uring_sqe128_cmd() which checks struct
> size for 16 bytes cmd and 80 bytes cmd respectively.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Add size check for sqe->cmd
      commit: ea129e55c9e06a51a93c3f5ef3e32a6cfa3f8ec7

Best regards,
-- 
Jens Axboe





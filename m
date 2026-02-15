Return-Path: <io-uring+bounces-12224-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OG0wORpFkmlysgEAu9opvQ
	(envelope-from <io-uring+bounces-12224-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:13:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6F813FE10
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 03A5930158B2
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5B32FBDFD;
	Sun, 15 Feb 2026 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CkzHYDqI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A76305066
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193612; cv=none; b=ffMqOvlITAHC+r5jNDnCqYM3wb/JnTU5pmfcNc5c5DuFEqM6N7+M676UQClCJ05Hl4gKJPyKyU39R9wiAe4XxCs8u54RUhO0Js5HPMBWkMv1gNMjADn2YIQIddqTtbli1T7Ecqa9I1WOklLFswWtKpl2KeiGmDm0z6GsuNN/21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193612; c=relaxed/simple;
	bh=YnSHyuORvjP1DdDcwkSrXSvWFLgo0jHLdV/qdwBTdhU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EX2ETyCT8Q1/2aVPFNzeIeW1UR5yMWhasRnoDy8KIcRWvAzFRRgl3S6p8EnsCOIZSuzSxIZWw3PsGUDNiKpe/7yhENqOXdNYKHH7WJQSOSxq9ey8C0uMR7sCTaCT4+7tERV4BWzVOrQVFJjvAvFkbeb/yTu8iMu2s9qjpuL0fgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CkzHYDqI; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40ee486a76eso1659730fac.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771193610; x=1771798410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Q5I5/fxr4SnEoRzTQ9BTMDNBCJMEhLFbjF/WzpJaZA=;
        b=CkzHYDqIde0ulfBmhNwFpvczmixhEzapr18FjFEgmha4zEkAZLSbhpYNe1CBHjU5kG
         PeoxPdfhDptct35FTGNrtiulQ63xaY6GWUdDd9JuPeXZFaeNRPmQqzu+ENTjMCUbHfSZ
         G4Pmqr+Dafq8ENUm+UD9VuQRK5Y+22ZjBieG4cjQZqoSVvj+1m8QiFJsxk14zM1Yy5zX
         b+IpxZnE49SofIxtPRfwK0OKa+vuly9FkXu4FuqGGearBJMRhtKkooEStfItuPIz533z
         2RSKrdJacy67VJVVx3X71ajVkYUN/hsvfrDoS/o7zYaAQKOm/hUeFgXQqnF9OA3inMkp
         k8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193610; x=1771798410;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Q5I5/fxr4SnEoRzTQ9BTMDNBCJMEhLFbjF/WzpJaZA=;
        b=h3ry6u2PwofdtoSBUAnkQPBbSwRVlLMgySN2IiQ5qnPOAHMnsB2Z4c+yer5q2+DuPH
         7lt5dHDTFVh/081ewnvm70F9LQoHpA+rvGW3+kk4RYRZx5n5quxRWP/XYigSOpgMtxLd
         iZz+qxGN4OjDsnG3c+RtQNF76tns33b2ncJITo/6O/OhPkfmNCLjkXMK3L5GFBzqHu9G
         bP4y+54pchyLnlr5o0Ka20xN+YZGv3U9VOWEYmBSy6prdAA990XDspwdvFX79UxewFp9
         mDwAxrqQG6BoEZkFtftgsP2B4X8Eo80WaGdH0anSN5MasZJM2QVRB3ZJIU8m/rXo+vhK
         ZzqA==
X-Gm-Message-State: AOJu0YwhO0NiI9zjja0a0Lc60GxHPZYDi9H9iAXSVj9cMTv2/otoWKn8
	uuBF1jfgRvmhh9cmTHgJRnj0Hd6mR2hybzn0c2Sn0WQv9MvY+xmfopt1wWU7IDISdQ8=
X-Gm-Gg: AZuq6aKXifCZTdODmjaDVmtpXUCK836PSKAYUXMNLcmjTIwa3fbFVTEzXNug+uFSrr1
	AvOwsR3b9wjz+xiT4khdCNvTcqoHBRlL1KbZeGIEOMGuumKZqb0M5GS26UJ/l1mStic5YY+njFR
	fhC/eX9JjsMzZsOItUHRAxmPzEM++qls2zpJwDy5BESeocdd9hN8HSJe/ZpyAwIks7O8w2H5buf
	TLzLDUIcbbEKiC+r7htrSKTpHnY3cWss6oPSuZj9FA7+DOg1c0fYyTPCw1SnnsxvGn7UT5jH3FO
	cNj9IzpjA7EhvYJmuQXSlzxr4RCixsgYoWVLAF34swxeQvYqKQtSQOm8AgT4ptLK26MD1dCZ9t/
	Mes7LpaIgi4YtweQbsMzHsEA+5wOB9IvmHjwRi4HMULUVn9IM0I+FCIrw+IKiQlpxGU9BjBc5yE
	MAwCycyiEVyrkIJWkmqYTr4P6j9ml6ozureSvBbALV0g/c7SJtVa7hY+4udpW7Rz6cb7WWxAcPW
	Nsj
X-Received: by 2002:a05:6871:230c:b0:3ec:2fa7:8180 with SMTP id 586e51a60fabf-40eee51d142mr5286854fac.0.1771193609962;
        Sun, 15 Feb 2026 14:13:29 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf178c1fsm13191922fac.17.2026.02.15.14.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 14:13:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
References: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-7.0] io_uring/query: return support for custom
 rx page size
Message-Id: <177119360871.79392.10892699946544286880.b4-ty@kernel.dk>
Date: Sun, 15 Feb 2026 15:13:28 -0700
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
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12224-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 7B6F813FE10
X-Rspamd-Action: no action


On Sun, 15 Feb 2026 21:34:28 +0000, Pavel Begunkov wrote:
> Add an ability to query if the zcrx rx page size setting is available.
> 
> Note, even when the API is supported by io_uring, the registration can
> still get rejected for various reasons, e.g. when the NIC or the driver
> doesn't support it, when the particular specified size is unsupported,
> when the memory area doesn't satisfy all requirements, etc.
> 
> [...]

Applied, thanks!

[1/1] io_uring/query: return support for custom rx page size
      commit: c29214677a9fc1a3a4ee65e189afeb5fd10d676f

Best regards,
-- 
Jens Axboe





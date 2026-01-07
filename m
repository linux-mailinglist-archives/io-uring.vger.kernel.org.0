Return-Path: <io-uring+bounces-11437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47426CFEA0D
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 16:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5A733168A30
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 15:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76596359F86;
	Wed,  7 Jan 2026 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YBYQXsgS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD177359700
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767798504; cv=none; b=U6SYE9NkNyreOi2El/Y/6Qbk93jSpcsc7tdqgqSVaL+mU+R9S7nEjkb5A97hWUvlsoI/qi5OhoYN6NamVwroW7KIbhggImHMtMMHIQNicGUOrEd8+/IuJwgOnYBK2K3NTnCoUiz1ZDE9RgqNUAcFHtfQIdT/x7rUlj98dYLdkjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767798504; c=relaxed/simple;
	bh=4xNefY6sx3j3BqnT6DCwuujklMkaozTfft/phYzXo1Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S7VoG49edr0gClmEgOHQdRRHhESwVEobbZzDTiXb2SUAQ6RllD2TJnppZT+QIEpH7+fianaOY1d7WvsgzENJ7rJ+G9iwrcWINT//RKdGhMyZGBZ+T7CHFOIyGf/EabeCS7JGXKbcETjoUTMRk3Ywuxou1/BPlt4xGW071RNaqCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YBYQXsgS; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3f5aaa0c8d7so1590940fac.3
        for <io-uring@vger.kernel.org>; Wed, 07 Jan 2026 07:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767798501; x=1768403301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMmEbhZsB6GcTHvr66TSYpqkKNAb2anJeM2Sl4gXS3Q=;
        b=YBYQXsgSYKvyHrunVA54s/Rir2XJjBdl8o9a1BLqRwAb9VJJZW6S5yxaXmucsF2xeh
         lLsFdk/ou6xM9LeX8NmbgDe88xgo99WMoGKtIhh6KcwY1+Id/BZrHpJZ59UX77AL5dsT
         7/HxaKZ/eeCbmTVX+xM9H3fSlvGjppj+xfMyD3h+gSc+/JHySt1GUOS7JJLcvfTwbLUH
         EA6j+qPcSbagaRUHO0O2RVpzwGZB3lEA3of75j0SKcmct3LfEtvr/LAyjbAlY1wtsSm0
         GcP4Eb8wdSso2KMQQbDsgXka0GRKkeJxsRPK0JdrZ3LiKJnDoXunRZMCX6omk7Dntb/j
         J1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767798501; x=1768403301;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XMmEbhZsB6GcTHvr66TSYpqkKNAb2anJeM2Sl4gXS3Q=;
        b=jZrP/fEmF9GKMBUbbcUmMt8aCOyvYBaJzKhiZQoV7SrMd5HsvvtnrjV9hIBYImt9UP
         GZQk+dA9BN15katvc/5Q8/YdZEDdV88D7WRxc27BSs2i4UUiuWHylamG3xR/toIqtDXC
         NCqvcrcpkzyv1PevK8LB7jQ23t86COTBzDk0EJZPjH1smBTycdOsQTtkeWKx2BJ1Ut5O
         5H7iuaLovkHxMMg9En+VsstcQcf/RZKVrBXzA0u9XL1r286rB/uDs9gh78Y8s8BPa/eH
         2h8Ouo1fWnDGIlzTDrpJQ+IVfHVG8/eFSLFkwzgx7/OYqSKeVnYnmWb20lAx+/Et3I5q
         e8sg==
X-Gm-Message-State: AOJu0YxwoESfZBHW0HoTrVLl7+jBh97GcvA34KQswYeeI2uHKTwfHGR+
	F1wdMXtP7W6B6xJ7/wC+Aj5j5z2r32cik2JU53QXKDYHVzY6pULFmMJzHQW/jO681/E=
X-Gm-Gg: AY/fxX7eZSKOVV8r2EVfx1PpDd6qIU41wEEuXyPcZ10+STFKhxZflTzhjKRkFwo5wfZ
	KUkBUPcFV/AY/mFjhtqn/VUF3KuaQ03sCfB1sRypRpKq9FL9yiCL1J2uyrf1ydWZIhHQZuu89vy
	Oj8w3SaAsgFHLrJmHoYM97L12AwAIxHpD4wc9lYkrk6/f2sz6kzJ8qrAubv9emDnfK+kIH4PcTB
	gywtSrk5l530mrzrIVGqxwPKy12gxUHguDRLdQPVZqSI0hl85/YM0DYio9hpTi0aaNKz6UzmlMt
	6NDd06BCiWJxFRR4tprUjwe/lJA2de9/WPkseQT4cCn7LSUMV4HqSFjc803f+TMEnYEiLu2gkhh
	otQu/IZW7lmLjix5jge3lM3ygTOgxvWRv9Zs7XeDRz8lcjRUyftHiNm4epY6MOcGErfgcCefgvZ
	olnw==
X-Google-Smtp-Source: AGHT+IHQOj4xYFWSAJWT2fA9/7KrVgQw4vpg7ujm3ZJrcmWA606HyJ1C2W3BvOqkXB7uybsSilpdQg==
X-Received: by 2002:a05:6871:7423:b0:3ec:31a6:8b77 with SMTP id 586e51a60fabf-3ffc094b60amr1330276fac.9.1767798500620;
        Wed, 07 Jan 2026 07:08:20 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de8cbfsm3299436fac.3.2026.01.07.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 07:08:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>, 
 Nitesh Shetty <nj.shetty@samsung.com>
In-Reply-To: <20251231030101.3093960-1-ming.lei@redhat.com>
References: <20251231030101.3093960-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2 0/3] block: avoid to use bi_vcnt in
 bio_may_need_split()
Message-Id: <176779849694.38479.6300884354899625890.b4-ty@kernel.dk>
Date: Wed, 07 Jan 2026 08:08:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 31 Dec 2025 11:00:54 +0800, Ming Lei wrote:
> This series cleans up bio handling to use bi_iter consistently for both
> cloned and non-cloned bios, removing the reliance on bi_vcnt which is
> only meaningful for non-cloned bios.
> 
> Currently, bio_may_need_split() uses bi_vcnt to check if a bio has a
> single segment. While this works, it's inconsistent with how cloned bios
> operate - they use bi_iter for iteration, not bi_vcnt. This inconsistency
> led to io_uring needing to recalculate iov_iter.nr_segs to ensure bi_vcnt
> gets a correct value when copied.
> 
> [...]

Applied, thanks!

[1/3] block: use bvec iterator helper for bio_may_need_split()
      commit: ee623c892aa59003fca173de0041abc2ccc2c72d
[2/3] block: don't initialize bi_vcnt for cloned bio in bio_iov_bvec_set()
      commit: 641864314866dff382f64cd8b52fd6bf4c4d84f6
[3/3] io_uring: remove nr_segs recalculation in io_import_kbuf()
      commit: 15f506a77ad61ac3273ade9b7ef87af9bdba22ad

Best regards,
-- 
Jens Axboe





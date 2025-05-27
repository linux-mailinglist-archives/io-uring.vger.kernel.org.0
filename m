Return-Path: <io-uring+bounces-8118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA71AC52AC
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 18:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D840817C487
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 16:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E11F27E1AC;
	Tue, 27 May 2025 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Izshbmo8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6315F269B08
	for <io-uring@vger.kernel.org>; Tue, 27 May 2025 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362215; cv=none; b=eHAjcV1HqjuYoqNYiqP0OhO+5ePTe52csFv2PFT7aMyYD37B2im6Wg6uDXJ6gd92SQq5v8tb+0U85B0yIpFLIQL0P1HTrWdBdbG5XD39jdhdR2Mf3ZdjPJKHq44fAyCKJGViTGvYwS8sIYYjcUtaQfRh8pREf7s6Ub1uqSWmGiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362215; c=relaxed/simple;
	bh=j8gokFwF4MhDiGidj/d1NWdZ0dWtYffV2o9v9BjnYzo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=U1YWhrxTj4eZQKR4jHk5hjEaNT8/CJg6NL8XHnbgoa5+OjL+yhSOP5l3o+BnrALB+T7TizR0DwYcTj1bMXhj0JjKP9th98fHCqUcoRGJLRR7M9ApYjJ4IhJXSC1//1xcPvn+uvzgN9601QIUo1jRNfx7kx1jNzp9bJ+Ii0bMycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Izshbmo8; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85e46f5c50fso333568139f.3
        for <io-uring@vger.kernel.org>; Tue, 27 May 2025 09:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748362212; x=1748967012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pbnMO/iIeoMJvjf/E3J2wSXTgfyobtiGSTeEDRfJo4A=;
        b=Izshbmo88ONUWfvD+YzmvJEd40c41YwDEvdvuTmwH1x2ccZmxP7VlFur0hENXqHIqd
         KNU3EZ846hQyDQ/XNj/Shdy8lBj6ZSa9eYsCTdAu5tiK8j84eEV3jLjzSvHCXIoeyTFu
         rO1Jcsg5Q/2U0EG2kmvEbJ3ZYWOoGgU7jYDKM1CZu5rG0Y3yP8jaZvnZs2zte0PkAEmu
         gPSONtIrkWga2EeVUyeRFqfd+bXYaIw+9BlJxwCivcT8OJ5pC+Z6Us7DeylOlgTmmKzD
         zz+Kc8eUUUuh5Sj7Wzr9dWOdJOYAHdaqqihlz2RKFYQHdmHY7dSdrG6VDvVbVk56PbHc
         GDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748362212; x=1748967012;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbnMO/iIeoMJvjf/E3J2wSXTgfyobtiGSTeEDRfJo4A=;
        b=bC0BluOcEjtORSggnxYrAAQeUp4KpSQll9VOD7MMWxJhYeDBHOq1K/DGhImSSVJXto
         J30DqJFjCk2tkJr5TWbYPY29wlFvsKu2ZwkSejENgXSlJb6I6/bSneywDBTt9TtuiG9A
         bKTNdu6oi+lBU3cjNwf9ILBy65tEvCvZfit5/fiKndBAFzt0/8eY3LWW8GyufwkzSpfc
         28CV2QF8F1oxz/uk591uxst53rLmg9Cs0gCrcK5abfQgtWm3v0i0flFiU8nBoZoH/nEl
         cnppt8tRQ02/w3+J0Ehw3YwACJYmLCyobZ79VbkDv8NZC/VhzPyNT9sFn4CE1lVTwNF+
         DOlQ==
X-Gm-Message-State: AOJu0YxkIXpX3Tx91C85W4yUGuIAx7y8ZLuL18a/Jid2c0I8fsNGaT5j
	O7vnRuqQM4gK593CUCaK6XC3IcyX4Xjj1tnlRvrJlOllhE/JmImWakdEXkIQlSNAPvDlA8nsU3C
	iMdH7
X-Gm-Gg: ASbGncs24qLqVestCedzqS1GvgGM2Bh5raJEKOCnYV9KBCiAN5porw/NcXTgqO2O04R
	ch69LuSxLcAAcqnf9pK2RMwnjcAx18nPFHwK2reUS/jQRRIVvDZFdphTMPYI44FNmRNJvSOUoVS
	QvrVDbAHsYowjNMemNiUsSBfFxOMziwrzvAmXai/R8Zc0GGOHSlIamiGq67zx4nuUz/aEguCZz9
	iSQGoVlg2rg5o6SF8romhSzn8ubmM4UpMHba16MwR9VcM/MKjr2xC6O12u/uiEOgz68PtOKKkv1
	rhqVpCw/1GvoxzDQVAJdB0g9maImRHc3P2CuaSQeGA==
X-Google-Smtp-Source: AGHT+IGYnv16V9s/zBy/ONx3aBQT52X2yNStBIDt0LjinYjGcpJAfK4tTal57//akftqwuTzirzxyg==
X-Received: by 2002:a05:6e02:1747:b0:3dc:787f:2bc8 with SMTP id e9e14a558f8ab-3dc9b6fc498mr144967835ab.12.1748362212378;
        Tue, 27 May 2025 09:10:12 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dc84ceeca7sm36337615ab.57.2025.05.27.09.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 09:10:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <faea44ef63131e6968f635e1b6b7ca6056f1f533.1748359655.git.asml.silence@gmail.com>
References: <faea44ef63131e6968f635e1b6b7ca6056f1f533.1748359655.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: init id for xa_find
Message-Id: <174836221173.514522.17213762165068432811.b4-ty@kernel.dk>
Date: Tue, 27 May 2025 10:10:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 27 May 2025 16:27:57 +0100, Pavel Begunkov wrote:
> xa_find() interprets id as the lower bound and thus expects it initialised.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: init id for xa_find
      commit: eda4623cf989d033c07355be1469e44f321ce8ae

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-10510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E93BC4977B
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 23:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A0144341433
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F02F50F;
	Mon, 10 Nov 2025 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bWhKw9/1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706534D382
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762812031; cv=none; b=cEivHqxixBQHFGYTB1+lTq1o62QsaEyFxv3c/xIQY3XcQlk+lvLFVrfR1qlxwQRjM4/C+f0jkVEUHlV9EyaTDhaZ+IiWgk0LU2dlN4ptqscRg3kN7A0ng8z4JL/Lo/loFXhJT7wFpBXrQaRfNNHqWajhhbKO+NF6r2TSe44PbJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762812031; c=relaxed/simple;
	bh=sXQUO4+0i56iS5WKJ/jXc9e3LMMjS6TtElI+a1coRcg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=t+rUeUJ9uMppDGOVp8q4k49OdPgEPWK20kGL0cQiDfUnQS2NWBQf2il3AB8jY3RrU6bf5y1KKwgA45VSXbD2geKC06vxEr2BL5mo13ujkMBeH1QUx6k/D/o7lGp3E4t7g25YTcgJlIZF2+ZO3N8HbssMX6/jim6crXgoFUzB4+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bWhKw9/1; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-43320988dcfso15059745ab.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 14:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762812027; x=1763416827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bp5L8eBrxqD0lYIXchZcnhuMBGUK+OBccbNLe28ybL0=;
        b=bWhKw9/1PMLIQlGWOV9BovWL/VIOLzGeNJ3+Pz/gjre40l5TaRRMcyUBq0EU3YtNNL
         sAmlF0+p1sI94BIPJqBcxZjKBzTR9d4d7LW+f+5jR2sbTnm3lib9ueidOCM1sBIj2wUG
         K7cnj7KTro9NdO4mXvuArHGIN9Xanys9tEzst2TAjqViIDI8FuYrE45sII2b1V4p9Jyf
         bIfw+UkjBovNLCNei4kGCetNApvqijCt59wr9BsYxsJY3k+n5fEbPxkbLlp9BNe2o405
         /9uE7e2sjttPF4HzkD0SqYFhXm0KT/xs9JN02wyaXqcSs1SZ+3FoHMPLplyy9VdY6Ucy
         g8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762812027; x=1763416827;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bp5L8eBrxqD0lYIXchZcnhuMBGUK+OBccbNLe28ybL0=;
        b=v49wcWDkE0WrE1qiMtBt5BKKEALUpGT+sUZ3y+88zyWyG/MZEipuj/HefwQ9o7WYGy
         SSM6sgp7tQ8Sb+D05CRykbbBkvME+gQQoQVA1W6nxOmVR+0eeZvAg4YjvCkV/mVvM8pq
         l1y84vV5c1m0pcQ7D0YouYm4w5z8XjuWrRlR9xGV1BYCcxEOYDf8htOfaFY8dxbi/Tb5
         tfQPoVdct9LjOGIqyCIUSH0hPyTQQlIpb6X39r9638yRauwarUCeeWY6MqO8AfvdbtW+
         UQlxi8VYbX2Zw3hbyzKuiedEiO3YghO4hPc0BwDTyA8yaooELjgc19w3aFCP0DXwW6t3
         7UWA==
X-Gm-Message-State: AOJu0YwjR5ehm4srz4cUwV4AuLoRSjfY5/XbQcJTtDu7NUHcXpIHKbJ9
	q9PxvqDFcGyqVVlo9i+aFSVHxdHkN/hO+vgoQX4NTAeoYaJ/6YhK7Want+gEFPQ2gDumEmPBIOi
	/y5yy
X-Gm-Gg: ASbGnct23fcPlTP5aueRjw8qU2cRK65e/8EveTWkHIB1yBoYZVFUbt85X8PMQOVBx5f
	C0XQe81xXWeteOt8FHDqo4MzgK9UerIjJHfL7ZabwhoJAK6ndcI43/BCIn1g0mG/4u+yd03mWuc
	O6sBTYhcLjKPbCcDBMg6onVbZHPl/eWbtQ9oDluw6bseFdSYQrawhG4arlFilyw6rKlp072gjhs
	2P0WKFDXc69tstHjDPdXoY+U3K6mFEqcvFUti19myW03DXXqCa7ntpQjigmhhRnm+94H+hQDyz4
	/7HryE1UOezHRa2wIWe+4TdxaFqC9TwfC0u0ZWfcANZznZW5dPCsyZ6S/An4nWfLycHrFNhGFCq
	BWRXerp5OzWOpmEVcxpsIqayWhulcLLv+y2JGSfsq8miMdLU5mrimewenBnrdeKGgNr3DvPDeoB
	lI1w==
X-Google-Smtp-Source: AGHT+IGQDdRs3Y7vxBALHuJsf4T8EZ/2jW+JfaE6xCRm29Rb5DeP64zV1zl0hIprFyN2GJ+yzJa6Ww==
X-Received: by 2002:a05:6e02:1b01:b0:433:5736:96a2 with SMTP id e9e14a558f8ab-43367e25667mr168920865ab.12.1762812027281;
        Mon, 10 Nov 2025 14:00:27 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b746923b0fsm5425136173.34.2025.11.10.14.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 14:00:26 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bbf6e697e5b298ebf4f42644ce23ef6df33e6e53.1762700289.git.asml.silence@gmail.com>
References: <bbf6e697e5b298ebf4f42644ce23ef6df33e6e53.1762700289.git.asml.silence@gmail.com>
Subject: Re: [PATCH 6.18] io_uring/query: return number of available
 queries
Message-Id: <176281202586.81118.629854693354007370.b4-ty@kernel.dk>
Date: Mon, 10 Nov 2025 15:00:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 10 Nov 2025 13:03:53 +0000, Pavel Begunkov wrote:
> It's useful to know which query opcodes are available. Extend the
> structure and return that. It's a trivial change, and even though it can
> be painlessly extended later, it'd still require adding a v2 of the
> structure.
> 
> 

Applied, thanks!

[1/1] io_uring/query: return number of available queries
      commit: 6a77267d97b5b6cd0e35099ab4eb054e5f965ee6

Best regards,
-- 
Jens Axboe





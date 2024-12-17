Return-Path: <io-uring+bounces-5513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A2A9F3EA6
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 01:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 865AF7A323A
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 00:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA72647;
	Tue, 17 Dec 2024 00:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Da1wes0l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45669479
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393929; cv=none; b=CcmcB89c7fhMlijz2i5Uo1Vr4naRWv8J9Fn/Ib/EOTEky/6tIo3jgCmlZSQOC3eHo1ggzngxcutvFywhMuRSVm+gFzIks+NyLFwBIJxd23mD2FRZ3CRfvqcKgbDiuYvttLaRWuGnfWVOLyFl3tpAIhiHbd4oVrngvySMPqskKVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393929; c=relaxed/simple;
	bh=qR+fzpC2KdHlW/SiO0ikbl/QrdyDYXM5cnZq0oy1Rxc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R3VrbPZkg5UqEv8exCvKaO/pTc0BtgvS+OPjUzyKxG0hgGPCmSv76LNSDpChu1Q5jA/Sj224U1Z4IrDiFM2T5onCG3A5+UxVjYETZoSCFrjSwyFX9+5zJn4UV1vlvtC1yWRKGhVXSncniUOpPa2WlcECSYga0vVMUg5kB5CuXw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Da1wes0l; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-725ef0397aeso4150509b3a.2
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2024 16:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734393926; x=1734998726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7a9uXY1exkTESDyjNuDOUj4cVSEwjPkQpQkrJ6UBFQM=;
        b=Da1wes0lFEp0SiZt/mH7rAWgidJ885VdYBbvTYu1dOMGP6W5fp5PGzwuOKh/kZudvL
         twb/E/yHD0rMrioolhtWVoA/DZqFPhLnQW+XW+JEIlSAquLLymJgnDIasS57IBCghJvs
         3af5Mm2xukh0v+82CWDM1rwGzblGlYqzsDokRe7q3EpaXRSzFdfHS1YhGf7OGcnrInOn
         zqk1RVGO0CDt1nOGEI31265/aEvCNe0AxxPuVQ/qzr+9aOUzUK06UA62rRF4pwfRJLB1
         hSWQ3GE8fkS5BfHBOQJMvY19nDB/9K789TuD2D3liGKQ/9RvL/BBHxURGW4yDxfBIk/U
         Y15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734393926; x=1734998726;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7a9uXY1exkTESDyjNuDOUj4cVSEwjPkQpQkrJ6UBFQM=;
        b=njsawYALaWCxnKLmlhgbrY4LuZbgi2cJQX8k2AZXQeKGIMw+zFvmZMbQ/UxCWARkEF
         MR98u8/+bcDe4BYsLFrDtGWFPRZiLNs2IZnFa3VBWZtHBt+fbyOqHAxzCnQOJtpklq1V
         Wm/OPZ7slLtHef54r9RLl8B1OjrJNJyZ9vgXnobzCgBRSzFwrfMcjmd31w/zSYb82mRj
         tauTRHPjOKb2U3ag4acGtMZu4vFByTONVYhBXPsx6AgKO/tqC41fV7Jwe4QS1PVrAPou
         d81c/BER6a53g7+kIjpEIk71h1FFSIphMYlBPMn0a79v6i9+aT4OZGG7k97FSuQDHgRm
         sutg==
X-Gm-Message-State: AOJu0Yy+sA2Q+eq7XoeWj3AdFdolEmYQu+nUnZ9X6uEEZnMjdO53Kv6j
	z0oaFmdy7071zA/K+ggk7Cfgmd4ldp/jI1o45WyhVyYhOLOMw783TD8hYF/1EKTDxB+l8HFZyGr
	P
X-Gm-Gg: ASbGnct3gq3ufaXiiv54s2+XYS63RUs1RCkabFsNg8gLbvmokOpaxg0DcMBJGyeitCS
	uCClQAJtj82uh1qmxRZWgcJIQc8DvF72usqXp6QeKBxt6DSc1+iUjXK6BiTh9rVMIpdU5NpCNa9
	iRHbl6UPkMs3pwkO/dmpHemKYTXt6ymuj5NBGip4jiDeFs2nVuWL2JbMlzPoDf5aJT1KU8sS6VZ
	X48CwwzG3cH7Vylju7nl2fU5sU2uFflYOG9COTtqIs4SOGq
X-Google-Smtp-Source: AGHT+IF0scbqvrHxRN1aYusxWZyFSS3jmFADOoukfKTJ2n3E8cjuiDTkeccx9sUoMBsyj825JmGQyA==
X-Received: by 2002:a05:6a20:db0a:b0:1e1:72ce:fefc with SMTP id adf61e73a8af0-1e1dfdcb7famr21524552637.22.1734393925665;
        Mon, 16 Dec 2024 16:05:25 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918bad9easm5507861b3a.140.2024.12.16.16.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2024 16:05:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20241216204615.759089-1-krisman@suse.de>
References: <20241216204615.759089-1-krisman@suse.de>
Subject: Re: [PATCH RESEND v2 0/9] Clean up alloc_cache allocations
Message-Id: <173439392472.114512.16832467394329793575.b4-ty@kernel.dk>
Date: Mon, 16 Dec 2024 17:05:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 16 Dec 2024 15:46:06 -0500, Gabriel Krisman Bertazi wrote:
> I sent this v2 originally during US thanksgiving week, so I'm resending
> now under a more suitable time, rebased and retested on top of Jen's
> for-6.14/io_uring branch.  It keeps the changes requested in v1:
> renaming the allocation helper and introducing a callback instead of
> zeroing the entire object, as suggested by Jens.
> 
> This was tested against liburing testsuite, with lockdep and KASAN
> enabled.
> 
> [...]

Applied, thanks!

[1/9] io_uring: Fold allocation into alloc_cache helper
      commit: b1031968b14f83f4bb96ecc4de4f6350ae0f6dad
[2/9] io_uring: Add generic helper to allocate async data
      commit: 694022b01368387cc1ed8485e279dfe27939ee43
[3/9] io_uring/futex: Allocate ifd with generic alloc_cache helper
      commit: b42176e5055a628217ff1536111a9e2df23db835
[4/9] io_uring/poll: Allocate apoll with generic alloc_cache helper
      commit: 4cc6fd392489cd76c7aa138eddace19dbcea366e
[5/9] io_uring/uring_cmd: Allocate async data through generic helper
      commit: 02b3c515d0be7e77dd19920e30cf637e9c7a167d
[6/9] io_uring/net: Allocate msghdr async data through helper
      commit: 23d91035cafa30d186242ebdf583aa1b55f1c59e
[7/9] io_uring/rw: Allocate async data through helper
      commit: 8cf0c459993ee2911f4f01fba21b1987b102c887
[8/9] io_uring: Move old async data allocation helper to header
      commit: 6cd2993dcdc17cac5cf6b11034abc6014caab71b
[9/9] io_uring/msg_ring: Drop custom destructor
      commit: cd7f9fee711c9ca4b909ffaadcac0302358db841

Best regards,
-- 
Jens Axboe





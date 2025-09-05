Return-Path: <io-uring+bounces-9591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA6CB45606
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 13:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEF4A3AB1F9
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600673451AE;
	Fri,  5 Sep 2025 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gqzNFz1m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F55343D6B
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757070845; cv=none; b=ETXD4L5rLEqPNvQPDW1Kqhxo/VXwyIJKN7tOji0MNqs97A5KEBB8QRTa3OIeZqPzEwIlLhdooITugVXqeGdpp0CSdYyAZopprhljjhxQTAXapo9zg/XNBwypAqgSeo+ymRC0cwELuQRpmUOFYgaOgz0digQmCFHq2dTEf3MaqhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757070845; c=relaxed/simple;
	bh=LvPr8ZjWkY5j+R/qUcEAtG1qh+P4cINY04MmTiG6eqg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y4aMXwJQMIk+C/twCWfvnmjt1PSTyXmjB3iDKwY7bXd7n4X0oWHU8h8/uL8xlGZwkRDm7fkNVM1PJlBH6micHIwdvcEXS70mYerldFGEK0vG9y1FltrDnVbiPE7/8NBvaNo8E5BpeeI+nNPL+uI7AHzrNBAXJ0Z2aPCzPq7FBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gqzNFz1m; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e951dfcbc5bso1926436276.3
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757070841; x=1757675641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XohVMPelRMi1Z40i3tKGQQ26fQqgID8bfPjyJfPTGog=;
        b=gqzNFz1mw/RyfOr8p+8dsnHybe2Xgi5MFxK7bkUScLF4P+GwroQv5LmqvHyDaOmA04
         x45cU9xuqHeia30AWAyNX0AvgiT3EavB8GlcWcFiL8K+Gww/QqYG5RPQMUkdIgXz+BiN
         LQE3hpB+eWz3H3xqHSB6/mQ5ago+9/8HNN/M5cpoKTJDlRFauEvUIp4aGO9cnHB9ajAu
         6mzURfUCiwoLxOgA774AUPO61mPyQ+dXHIOzXDpr/LdgOHEkjKEOKXzXFYVAUEhfeJmB
         z67XJGwS5UFf4KIT7otVBvEGejKkdMgknQOLlqUbwXDt+l9B5lOmiT2hlIBd5SC/ePKh
         RxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757070841; x=1757675641;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XohVMPelRMi1Z40i3tKGQQ26fQqgID8bfPjyJfPTGog=;
        b=B6zGlSdJLZJmVjtreqjveqTKLlA4ptDCK8ccEnGJ713KWpYNkss/Rhmg3ybCfUw8LF
         6qUDwfwoIMrHRNsClFh6T5w7UZHREDLNHOtw75Near7EIp0YOKF5QQzep3BhZXJglzbG
         Z/zICMwISXvugOqxVLR+1sjtO0MwoyzdXcjyM4R6A78a2z4s2smWHL302ixbZZKRJGwM
         AoR/usMGAFGU5vSLx+c8FcYngNhOm46+q0f7RXGySSk0pYtq6oD1rZqYEaWUBCsS2f4v
         xhOej7e8BPj74EGeObk8HLeatQiGVNH1H4WGaO4mFTppg39p/D8IJAklUb+z0rZzFtPf
         OS/Q==
X-Gm-Message-State: AOJu0YyHgAMnQL4urbeXo8+uBuoDBEb1jp6tuRQh5UzkScOUdTiwtAyl
	bIa5OWU/zwt0eEWAzUafZCuuWdhvlCS8hQxeb9ynSDI4BWIBtsrIQDe/Z+JSPQBc7F5VcIM0PVc
	ORXfv
X-Gm-Gg: ASbGncv8hBfMJ4RJU1Lq5+7Xx6FHzLT013y16Gs5Tqqvst2N4gUt7hlJo9YjSsNb5z5
	hdwzVv45feSHkOxDIh3n2W9CZM0+4XrU3uAjZZxgw090TWouZEcJaXD7cX5Xst2a1BIlytJJIi5
	JilKPgOfibZOrIHt6XI8qB5P0BHAPmcJxavQhSGu+YonJOMXojgP1Oq3qKSBeeK2YekM+AIDeAM
	N+ZThaEkMFNR4RkueXNBVlkLqggIUcN/0QC4qBFeIRNroX6HEqlh7Sb51Bb2iXBLpwG0H72hkud
	G4LkFCnFg+5t9Nd4yYnDUXNW/LMvXA4E+W6NSJPqtvmWO649dIxbsPuhLVdk2ZvvOxU3ZNr/HC8
	qxY9vS3CPSRkaZYifpTp9vY7vxkf7
X-Google-Smtp-Source: AGHT+IFQGiEhr5yUMqGKD0P94jeQvBpJEYwhpNf7H1jqUT7KYojcKEb7y1jTd42pBM7o87Xc40g0jg==
X-Received: by 2002:a05:6902:120a:b0:e96:c6da:5bcc with SMTP id 3f1490d57ef6-e98a5759523mr20552127276.1.1757070841316;
        Fri, 05 Sep 2025 04:14:01 -0700 (PDT)
Received: from [127.0.0.1] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbdf57266sm2999999276.14.2025.09.05.04.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 04:14:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250904161223.2600435-1-csander@purestorage.com>
References: <20250904161223.2600435-1-csander@purestorage.com>
Subject: Re: [PATCH v2] io_uring: remove WRITE_ONCE() in io_uring_create()
Message-Id: <175707084052.356946.85147804002646222.b4-ty@kernel.dk>
Date: Fri, 05 Sep 2025 05:14:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 04 Sep 2025 10:12:22 -0600, Caleb Sander Mateos wrote:
> There's no need to use WRITE_ONCE() to set ctx->submitter_task in
> io_uring_create() since no other task can access the io_ring_ctx until a
> file descriptor is associated with it. So use a normal assignment
> instead of WRITE_ONCE().
> 
> 

Applied, thanks!

[1/1] io_uring: remove WRITE_ONCE() in io_uring_create()
      (no commit info)

Best regards,
-- 
Jens Axboe





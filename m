Return-Path: <io-uring+bounces-6480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EABF3A3834D
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 13:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAD157A1903
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 12:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C1A21B195;
	Mon, 17 Feb 2025 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v1URe8uT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA721771A
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739796372; cv=none; b=bXHST5ABQTMqBwbArMhddORvUhURv8TAl6KJtlNogrUdLmi9vbA+lP03dCTOLOKSE73H1m6xMyOgZfBdJ8FlNj9BN7OqMUlMrWoNK2rmKcLFCK4bsBIjIRRfDmp0T+PAj0SCKRStKCvHWAJ5GzQ2JUDi8FgtKD9qV7kHygCfi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739796372; c=relaxed/simple;
	bh=WzkMpLwgZbZ/aW+9gub5iOXsySgmY1VT4Ax4KZ+L30A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YBnBEcUiaz3T65Hc83LBjxeRgxCkvXy5rGLt37EGfpvMFQam/G2/ahbNisjWnpwDWvZSyvNdY7m0XFt9gWDQ5QOZvBLZ6DfTe5sMorAWTU8bRrK8KZ/WykBRU0XOV7T22JGjjJVgQrY0rsW1IqecRx3ME4LearAGe3D4xPSwML8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v1URe8uT; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso14739215ab.1
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 04:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739796368; x=1740401168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bNS0FjTwJ6SMd4nioB5wMEX5T9yYEM2Nyv0ek9XFpg=;
        b=v1URe8uT6w764mIOYQLp4BjEBriRRHHWHfvqu8tUSQZxJE3yvJeztI1xGzgGSv2qbn
         mQ77msszRHJ0+IGZB2lH0W6/L1C4A9I1InMJujKD14RTRSoSn1JiZ6OYcOvkVpC3UHY5
         D8CCvhUG08dtnDwdcgLhsC9QOv5lTW/J2mRYegxbw7eN95Z94lR2TyLcfFtlziy3eyfT
         j747xzrHiB62vdPcg0+uEPW4H6Oiro5NdKm2GP4fmCYR0BtPZUpC4+AxbIerxGRSM2iB
         U6mlOzaKeAfsXfpOocC25rirkpxRQhScraosAOiRdt8W6mCVq9+zMJHITm+Z0W09Wr/i
         7A8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739796368; x=1740401168;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bNS0FjTwJ6SMd4nioB5wMEX5T9yYEM2Nyv0ek9XFpg=;
        b=d6w4EMWwvLZEnnHJ6FcsH1cTb99d61xUp/TVZib2cnkL7+a+NR9s2R0QBHCPkTGhzq
         RDxvvAacok0M6TkqNTbXXffU1J6BynzbZo03J1V4WQ9pfre6MU+1OKHrp/YN66bDmiJz
         SSNV1aSDnHLxkzSPxVAQTyWAlS86jWKBq6Jm7omG1khEw0BKCxn1XgfnNiZLvLSCAs+O
         qWKto1j/8hiv4N12WKGODW34m/Ij6QIPU1XlryyQmY97KKpMhEcDz6TRTv730b2C6fnM
         bYgIgaG9S3yw8cF+tKc3nXC+E2NsUKnWmYy1U07J+Bf8fyMNpfg5kDJTxEfrqMZNn78P
         CVXw==
X-Gm-Message-State: AOJu0Yz+iw8gZsZA+yftICFDsMUywtlYulfX1JzQiOmdNh/7Kk8d2yOU
	h3VC8f/NnooQ7UxW9USiDhfTs/E5+QSM5eCTWKCcJVK8WVcaKi98GlpHbfigaJJqcyhSyPjPx8D
	I
X-Gm-Gg: ASbGncvuGtQsnMOsSXOMEW85cu1Ws1XUvhiCzFePfE19TX16etq1bDvI9+NMS1GOMKO
	7KH03oGGeVeZ+unSflKquz403SbwNq7IaW0M46vHcD+IDh/ItnqxrlNp8B3pyVd35DazW4OmgNi
	UmIGnFD6Y9NYT9FkwVHoIcxVBwm5zduklK87eT9JmivaftmicsS262a5y7xkbkWfIEUvrLv0blX
	rvwrKIt9gh8Fb5WGMY0jxm+bF0S60GhK7+Y/I9GzaGwOSMoWzotxG7XgRgoSY1Mx+Jdp8Wprvvt
	vyUKMfE=
X-Google-Smtp-Source: AGHT+IEaa0F1D+BEXNyGvpeYbIUoErtzcPoM1QWVnN2aAi4+nV83Sy5/0J39XasoQ/EEFqFiIqVd5Q==
X-Received: by 2002:a05:6e02:378e:b0:3d0:23f6:2eed with SMTP id e9e14a558f8ab-3d2807b0595mr54037885ab.11.1739796368011;
        Mon, 17 Feb 2025 04:46:08 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee81857773sm1247159173.66.2025.02.17.04.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 04:46:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250216225900.1075446-1-csander@purestorage.com>
References: <20250216225900.1075446-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: avoid NULL check in io_put_rsrc_node()
Message-Id: <173979636710.644986.8096661613228249151.b4-ty@kernel.dk>
Date: Mon, 17 Feb 2025 05:46:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sun, 16 Feb 2025 15:58:59 -0700, Caleb Sander Mateos wrote:
> Most callers of io_put_rsrc_node() already check that node is non-NULL:
> - io_rsrc_data_free()
> - io_sqe_buffer_register()
> - io_reset_rsrc_node()
> - io_req_put_rsrc_nodes() (REQ_F_BUF_NODE indicates non-NULL buf_node)
> 
> Only io_splice_cleanup() can call io_put_rsrc_node() with a NULL node.
> So move the NULL check there.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: avoid NULL check in io_put_rsrc_node()
      commit: 496f56bf9f1acf11ce14489f34d81ba6e4023f42

Best regards,
-- 
Jens Axboe





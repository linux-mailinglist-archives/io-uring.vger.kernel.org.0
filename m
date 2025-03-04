Return-Path: <io-uring+bounces-6930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B76ECA4E0B0
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53D0A3B51E7
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 14:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A49E204874;
	Tue,  4 Mar 2025 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3RVXHejn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F896204C25
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097857; cv=none; b=ClKFkAH00CUQGLLim1qWKZCfMv1JC0F5DQw0AAcW665YX+agS+xtRGtp5BgUfF4vLTEl8rhehNL6Jl95UE19bRmB1KpLJmrlLeNFAojA9HMltZ0yDRwtRE6c9kDXf2oOAWG0b8U5wJ8eG7DoAUPrd5BNXzonHwB4acExnKbyFRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097857; c=relaxed/simple;
	bh=u0YTEmiq/X1E0cMQ/xx/YUxa0cAemZr65/rysSkoufw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RXgPm5kibQAZ26Oz8cqpcFDtaZmGMHxvqVzBwnuszUY6wbw4dv96fPDnFJ1dVTPI8zatz7nVTr2/eBzoZbbcyhQgcmHp0tSB3quvOrr9OG4HZRQsF7CePy4BkyiNUI9VEKQt1x/WHrCrIavjo7QKwNMqt7FqbNDrPTyHGy+VG1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3RVXHejn; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d3dd76a825so20449415ab.2
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 06:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741097855; x=1741702655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gIDjMe8z2x3wyNv++WFZ5B8TQBT5aS6hqx9LtcIW1M=;
        b=3RVXHejniYE77ZbChWpDhwTDcfF+EvsjAXp5GRFqTt3mw3xW97rkhvcgQvzfeTRCEP
         vlUgJtxt5Hvl7zKSlzyz29vEUDbdEgeUFbcDIt2GjvzuFhyAqmsAt8+wrtxYnLBs+0T1
         thCx0KLieqM8S3I7R3NX2v8QmmFMRRuNwL7Z2OIEJn1mWhRMRH5mQId9mfHABZ7miDa9
         q0wrj9EAMaj5vK4/3+bg8UE/o9QEpbqxLjz//H1aGNBZdHaH5ROw96EwbmVO3SIL+zx1
         jRwmOhuPsJtbhA8NbrBTwIUD6Y0L4qimc3HL0HOAyVqldSD2rirg2iZnqDpTUwJ/mucj
         Ka5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741097855; x=1741702655;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gIDjMe8z2x3wyNv++WFZ5B8TQBT5aS6hqx9LtcIW1M=;
        b=WgC/Mnl56C5A1/03PVFm3WTTh2dI89feNz20BULLY+LxEz4MpETr5ols9QqhKFkjW3
         /7YMCQA7piGWaPc0lMGYpqg59ly0eSefoe+Mkqd2pHeBgLkpj+SIss/TimkcTRBmBo3T
         eMBiVrCl4An/3oV2QLvzRhxYdEU8xrwrf2771JjQInIrXaaZYLxBtSbX2peiHTrrMhMO
         +VVELgeZB8m9Led8sioJzW4Wca4S+w7HG4FEImqZAQsvJXZKZiRrpLC4qMKo2t1mq4ED
         1O42Rby6esoNkuhlLz+dG6OxFI3m9YTxaYntqVTMFXAYax6PBKJJ8dQRTf2I5OoEEfoD
         9hQQ==
X-Gm-Message-State: AOJu0YztnTVKYvjviu4Yx4BgZ+Nx41SrMB3yXbABN0XIYIBlIwrf0Nj4
	H8aQqdvB4yMmrJkwQgPumfKCQQEVe8Vgwe3qyJdXEromPZC3bcCNkcuBl9LU6sU=
X-Gm-Gg: ASbGnctfVFYm9/CRzn7Ur3JU9QTLSvaFlidDsrBi7kueYbMUYKF2kU8g/zlMNPIhEM4
	oMec1vmaYu6AGI6E9IgkhNGbxjBFYyUcLoIEpRyXkuseQE96JBHzSOr9+vcjGnpC3HRiPeFPOGs
	Cqt9r1h3ZA89XMdQAlNKC4W2q88aWFBnqfJCPyV5v1apEr+VrZMudE7MnikHCxW3kugNw2O5xR1
	TCu3uiG2a5P/XA7WhP825Zu1I96XrE87Na8OJmramymG57tVeQaakwc9GtfD5EtqEFf7G/n/m5D
	5g5kKwynWns16w5Lix1R3PwomMzSVzesaYE=
X-Google-Smtp-Source: AGHT+IHj1VKM8Q8OB31sMhasbX1Meg0uRuwSvtT5CoFwKJkLRey9eS1GljsQWWmAUoDD7oaBELgAqQ==
X-Received: by 2002:a05:6e02:1a22:b0:3d2:6768:c4fa with SMTP id e9e14a558f8ab-3d3e6f4b145mr181382345ab.21.1741097855233;
        Tue, 04 Mar 2025 06:17:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f08f4e3ae7sm1551749173.80.2025.03.04.06.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 06:17:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250228235916.670437-1-csander@purestorage.com>
References: <20250228235916.670437-1-csander@purestorage.com>
Subject: Re: [PATCH 1/5] io_uring/rsrc: split out io_free_node() helper
Message-Id: <174109785443.2732593.9519321891162952151.b4-ty@kernel.dk>
Date: Tue, 04 Mar 2025 07:17:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 16:59:10 -0700, Caleb Sander Mateos wrote:
> Split the freeing of the io_rsrc_node from io_free_rsrc_node(), for use
> with nodes that haven't been fully initialized.
> 
> 

Applied, thanks!

[1/5] io_uring/rsrc: split out io_free_node() helper
      commit: 6a53541829662c8f1357f522a1d6315179442bf7
[2/5] io_uring/rsrc: free io_rsrc_node using kfree()
      commit: a387b96d2a9687201318826d23c770eb794c778e
[3/5] io_uring/rsrc: call io_free_node() on io_sqe_buffer_register() failure
      commit: 13f7f9686e928dae352972a1a95b50b2d5e80d42
[4/5] io_uring/rsrc: avoid NULL node check on io_sqe_buffer_register() failure
      commit: 6e5d321a08e30f746d63fc56e7ea5c46b06fbe99
[5/5] io_uring/rsrc: skip NULL file/buffer checks in io_free_rsrc_node()
      commit: fe21a4532ef2a6852c89b352cb8ded0d37b4745c

Best regards,
-- 
Jens Axboe





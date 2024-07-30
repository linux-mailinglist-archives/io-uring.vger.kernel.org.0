Return-Path: <io-uring+bounces-2601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B6A9411B6
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E595284FBE
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 12:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74A119DFBB;
	Tue, 30 Jul 2024 12:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yNkTC70K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E81957F0
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 12:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342058; cv=none; b=DLhcdFfdqnEyysfNnFnn4KpESTBsL7/CrkMPTEnxuAh5aCf/1OduzKOhTGjUxdLL7cSBvynBThY4vkOdTn3mymhy2bfixiyeQz4RXBk8Z+UcShFsA8Xke2cfaPd7NAXi28THzkvsTvkM/5CFZf4tvmyl7rLKvKRw90iUoDtcsJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342058; c=relaxed/simple;
	bh=WBGYBb0xEQN9t+CpAuhRFHqEZx2LDaLJMQNqGXSh5oc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NTLWB9N0vBMuNHGnsJoSrv1Owwnw35jzGX+7gmGmiJhVuYt2cyn5iOkeerTaNJVO81IfWaoIdyhgQ6G3u5/SaSWKbdhNQRmORe+85lBNrFqAGNSr7DpSHw3sDRC3fw+xkfjbfQEeenM5DfHbTtbZwOg2YQrrnHCGwoFM0k3/5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yNkTC70K; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d21b41907so408607b3a.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 05:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722342055; x=1722946855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CKWLNwh0hnqKlZieKTXpcQDzvqk1U9+EY7GuvJPRIf0=;
        b=yNkTC70K2+vtutw6bPYlu1D0faq+hCjq22O52qGDGw10oZFxI9WF+MmhO+KwKHLgbF
         H7mdmBsE+OphQB4kVXZM1RJvfSeaoETumN6GwoqpTcy+dYX2WMsU18TJyT3+N7s8Hlos
         TqlV95YT2jK4b6HzN2TfTr/3dmqErc+VAtrUWuPtik44Y4f5/d5rpUbd3s+jLC1vD94I
         GvA/zbsJ2ied6KnCbTPRDMCOKFJ+4LdRrxyOLE7ZJ4b2qY+AKkUTOPbAaO8lutTXjCy7
         tARsjfdYy6kxA9nIjgIEz361e2sKowES4QczJahFOBemo+L49+VF7KXsFDftbGVuLdrg
         wpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722342055; x=1722946855;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKWLNwh0hnqKlZieKTXpcQDzvqk1U9+EY7GuvJPRIf0=;
        b=rLUJlsf4KEVzFxKHBHyL9MBRbaLlNmWtHSicVzpPmUS6bajjzbQf+Ehwwz5iXgRljF
         YjZh+K6u+DX6iAGT/mM3z35sLFVWwiFDJu/OlItKFvz3uGSrBNhdalEnjDE6bSSyQBp/
         SUawC1Ada0YOnzfg2OiDN00g/klCycohgl9QnsMXXExnaw6tS11INoqNG0PNN+LU1aoG
         e0lO9GL+Wzy+hHK1WXVP0ATIZ55M8Z1+knDzhjEdjxi6aK0Bd0oNuNXSXOn4XU2XYily
         QX27T+Kv260BAOw4hRu54TJO6E+p60VVM0J7Eq4JXHbxRTgAF8sTTcL4TAnTt+EraZaG
         uxWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkH9dalbiQBXns6KxBOD3NPRqI6wjh/K6O2QoRgt0v2ljlE+DdyABJ0w6VdG3I5IwM0TKO4YJGIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv8gWIL3qYGzYrpa/TxReUKHoDVbMBUaAB+D5oal6QbRKtD59f
	c1Y9OGufmqlYoIxp2cBL2J+B+yGTWunpVPF4tFjZ4GzqwUS4w/1NiVS2gpWEQAI=
X-Google-Smtp-Source: AGHT+IHRcWkdL83m9xUMPLW9MT9p3orz7JnkxjeRu6HOxktJCDf36bwlmH3YeXvP54EfM4ItPrsN/Q==
X-Received: by 2002:a17:90a:9a93:b0:2c9:6920:d2b2 with SMTP id 98e67ed59e1d1-2cf24fe6961mr11959258a91.1.1722342055427;
        Tue, 30 Jul 2024 05:20:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb73ddb7dsm12419444a91.24.2024.07.30.05.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 05:20:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <0a0ae3e955aed0f3e3d29882fb3d3cb575e0009b.1722294947.git.olivier@trillion01.com>
References: <0a0ae3e955aed0f3e3d29882fb3d3cb575e0009b.1722294947.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring: remove unused local list heads in NAPI
 functions
Message-Id: <172234205379.11941.14761409480527622811.b4-ty@kernel.dk>
Date: Tue, 30 Jul 2024 06:20:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 29 Jul 2024 19:13:35 -0400, Olivier Langlois wrote:
> remove 2 unused local variables
> 
> 

Applied, thanks!

[1/1] io_uring: remove unused local list heads in NAPI functions
      commit: c3fca4fb83f7c84cd1e1aa9fe3a0e220ce8f30fb

Best regards,
-- 
Jens Axboe





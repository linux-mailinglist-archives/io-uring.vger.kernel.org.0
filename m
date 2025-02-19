Return-Path: <io-uring+bounces-6558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9204AA3C313
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 16:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50DC6176FB5
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 15:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C261F4165;
	Wed, 19 Feb 2025 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="J1SaBKR3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4D31F3BBF
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977606; cv=none; b=UGdlH96roJjJivDVqjqmAqlphSjTcybir32LyoQkJo1jGwXjTmLTkPNThyyN+piEaP4BN0vSO8S2FpJ56yCVm0/UDmariS4qTE0//BB+9RUZwuEDphZ8ELNEv0JayqiWCiDVvQyiVHjJ3Nc2pkeHT1heyq1JILAdLHEeJD+p0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977606; c=relaxed/simple;
	bh=RsIgDGy7qZ8B3MBFSHhVZSusxcdoPT4+tAYIqqxrg48=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XkFmnzDFrGZM5G6p/u33c9gSQuH9xrgZoxikYeYijXJoRJvYz4oU6wKsXd4Ntak1wLN6WXDhbdiP8naCh6bt3cwQ/pZiKn6xrFAHQ3o02zimx/XzAYLtWXnZNszdQUynRd0Aq/2c5UZhp/btjQahb5FAa8XRF0+kU8t0Qh8eDb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=J1SaBKR3; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ce915a8a25so22692195ab.1
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 07:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739977601; x=1740582401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Facg3HecWXCU/JkqnQPL5G/CpP1AOCney8P06Ut0gwc=;
        b=J1SaBKR3DXIo6mmI06ls4yYhyhN5ybupBUGq6q0R5sxOEISJvF9Yuww7eKb48URaFl
         DjzAazQcGhGqc7ErtFVbhwCXiXDFpci59QhaxaDLuqN6xvBMDAPcijv+KdoE4vmwC1OM
         UBDRzR4yQ6NEtHBpHLFC5j3d/AXsapAhcN6ZDM/QKRUgIYCDh4p6vFqPRcOHnbEPlNrO
         ENwo+pDjgeDETgduC+zFwg6UPmWk6OW6iiQI02YLxDL3hNZRzbiq/0jsXgwhNAytBf9b
         idUyIqhApS1g2j4TFuiH/uc9b1xjuqQoGu0zUNuS4Id0Hl508vFkoskD/JfnNnDNq2zm
         lgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739977601; x=1740582401;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Facg3HecWXCU/JkqnQPL5G/CpP1AOCney8P06Ut0gwc=;
        b=RgrPDT4yqbTb/FkEAIhmWkuD7fchRu3UolrVroAmz+CF//GVK/Ei3iwb+kTuZvppb8
         66T6B3+/zdkpPhfgUCNKxrZ7TgXAmrqY2gw8ntya6T94FiqDJWiUrUD8pCT1wcZf1Y8u
         TcJkb/uy/hcpy/iA13Xq7AQoX/NmKDYztAmtfqjmRIIGjTvAlfqoDjews4/RW6TgwZRy
         P9jxA/0YChwRoMF41uuP5OUO9lyszLyaeKTC9ShnmNhHy7GQ6e9FRId0jrzJS0qYGKmn
         JdBCDXSUteB7ub5ycHaLJ9tzR0WEnEHbe4qNEq91//L7b7kfDx0xxwv9GyFU61W3RQoT
         2oaw==
X-Gm-Message-State: AOJu0YzcIZM5d++irB/CWBI3c/vzMkv/e5tk+WoJfUADcpzaP6u1t1bK
	n4znZAlXrYiowxmpr7H/1+YSKqrcRPcvhE8fpvrec7SEC3hfMtQrCzGR8e3yq/P70vs+46kHfVV
	z
X-Gm-Gg: ASbGncsO+PSAqMaAqsLN2GzF7m1iwA1Yw5JhhAmvlumFIq8qAjy8Oib8oQWyC7X2TLG
	yCeFCgknbMIIWZEqsTv93hKJjae8EIf2PG0kniR8Ru4aXMG/Klv7TEsjqspfY3XnzNRmsNFvVq3
	sXnQ+Bi0a8DDRxbhW7IwieK3w7XS0+9HGOb9g+37reaTkjyhFSc0YDnX0zBBPJqkOeKOAEPCamq
	7of9GSP5asz70qEgwOyFYiJeIcyQlKja/lHS2gh4i2WfRPlgvYxVwC9vSgk72WAvuIfVsPC9Yi7
	3IjbSw==
X-Google-Smtp-Source: AGHT+IE900lcMYGFzRy4z2mV2nYf+DRnF5ozVCCn29CL/Gd+3WZwyLfLr39McanUqzpQSq2dm5K21w==
X-Received: by 2002:a92:c247:0:b0:3d2:b4b8:bf54 with SMTP id e9e14a558f8ab-3d2b52bc919mr38993545ab.7.1739977601624;
        Wed, 19 Feb 2025 07:06:41 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2b374de28sm5304345ab.71.2025.02.19.07.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:06:40 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250219033444.2020136-1-csander@purestorage.com>
References: <20250219033444.2020136-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: remove unused constants
Message-Id: <173997760046.1535105.540337617191043636.b4-ty@kernel.dk>
Date: Wed, 19 Feb 2025 08:06:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Tue, 18 Feb 2025 20:34:43 -0700, Caleb Sander Mateos wrote:
> IO_NODE_ALLOC_CACHE_MAX has been unused since commit fbbb8e991d86
> ("io_uring/rsrc: get rid of io_rsrc_node allocation cache") removed the
> rsrc_node_cache.
> 
> IO_RSRC_TAG_TABLE_SHIFT and IO_RSRC_TAG_TABLE_MASK have been unused
> since commit 7029acd8a950 ("io_uring/rsrc: get rid of per-ring
> io_rsrc_node list") removed the separate tag table for registered nodes.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: remove unused constants
      commit: fb3331f53e3cb1f1505f918f4f33bb0a3a231e4f

Best regards,
-- 
Jens Axboe





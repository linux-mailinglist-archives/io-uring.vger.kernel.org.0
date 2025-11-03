Return-Path: <io-uring+bounces-10324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A05C2CF43
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 17:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3FD534E86D0
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 15:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D44236435;
	Mon,  3 Nov 2025 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2PushBVw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F3313E1F
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762185380; cv=none; b=YazCN8tUfgNA74OQDAt2A3U1mC5rfxWhNeFwpSwB0r1TrfwNYle/TPD2x9gjvr9aCXw/fL3KIHCbalPjDNs3ZIE+AouxbqLMe74UVGBtpJ0skDRmcDRLRvexHHi+2DYtqSHtdX3M5cDMBLpjcQN4HGsOeZ0zZ2nL6OGocrsGeK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762185380; c=relaxed/simple;
	bh=gGXLHaF7e4fny82kAFdlsB4agfRdVFNgMNI/7GgMq5k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=W+Y6ciwhnBXoZFJlfHEouETp+g45tG1KyJ/YSaEQd9sb9b4wbNGYpF8Sz1Q94AIhrKWbB98Zwr64MvPXpl17XjRzLUR5rRdVvUOXA8HnAy5cTimmCBIoXr5pSJyHkMRVHbiMWsyYU49YbgAgob43lRwsNf6VLF1XxkM272REl9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2PushBVw; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-4332ae0635fso12401135ab.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 07:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762185377; x=1762790177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9YDgAdU/uso0toOOWUSOOo+jH+xe/ikxmfGNGHyhpM=;
        b=2PushBVwbiEzifHC4nhDTf0jBKThaqjXPk045GxaUqihGRB2HjJ/sEILezLLGEGJln
         Nx4bYoPhaWSFUJ9cRUtj2wUSTXzK+9Yg41cKg9666DKVRH2BGe9g0sL9w2sZtF+ubDtB
         fxdnJ7hBubyrMQzKQLDv9j0kO7t3gg4Sd43xmRX0T4s/UQDNLp3UitJg4yJFgpTW71s/
         d1Q9prhfXYcnKHF4EXX1Pm2ispZovU5Q34vSOaPOWtj8gDcc1tD8EHoWsLdh/ii8ViT2
         tXQTUHU8xJ3oIJXBgsikgm3wDy/ZhlnZqogxhfC3V2gbT23a/VK497pMRoX4FhAFDUxb
         1a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762185377; x=1762790177;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9YDgAdU/uso0toOOWUSOOo+jH+xe/ikxmfGNGHyhpM=;
        b=Bi+TEzHGYrkfTxde1iiZklLReTr3/lnHOtcOF98a07cAc3rPwaYcW0tw2qasqC8e4I
         kXcs91GnWwGAnFwgt/ju1WTzOvDNmdS8tICXTIYsRppVNIOOQlCe/nMiXtnN7ex/u7si
         Hn6zbw7hTplwNmEh1g1jRXurzjw4tn3wbi3EAXBD5+wSOmVyIKtoo2YaoGEcNCBucNh0
         GHlkRrEFBR7+uPScDy1Fdwc+8mgfjsMRFGZoGdSIFpSUGFz5KugATLXffChn/79/qnRk
         QGKWJzX/qVQFJbtWTsIhLN+HhyfccTbf3pKqQrkVe/Ggg0OWjk5h8bB/yeBWvwr8a0wz
         qIZA==
X-Gm-Message-State: AOJu0Yzwz6gGHchO+JfBnVKFhDsUr6K5yb8JgHtYt6Io25OTTV3VYv8C
	5KUiiqQqAi31jkBiPqVJCVHBAj3cErR4L5mCnPd4eusofuETWfpP6by5B8HesgRpv1c=
X-Gm-Gg: ASbGncu/0Yk+/WowzvZXZNS5ClaAeRtcu2298kGcSDc1QhbNgZ8R8O8qSpt+ICvhg+i
	FfTVk0QUSo9FNmz12o08pHUtrFhRjKMq30TpLrzrTjiLnVrQ8jVhBHlhhO6YAnVHs95BNvSLOCU
	zWtRjldinvnkz3xGwOWzVbt6cBjZ6+c/gQQ7sVG2r5GurJB0haqkuFbhk3xpkF6D8W5FppPgVyG
	f11HAhC5UjFHPakp9lrmK3knypBShVjKkI0NlzAL3eMC7ljlHAW1XKd5yutVBNKK7GxiUCITbR/
	1jNNJmBNi/4Ze35sO/yIdBNiQUJl6k0GrGXgtzZF5iDzCLZflWCFo44/XWEYunbqHlqR+sDnYOs
	cg4pYSnwAHUubU5hks/AvzVl6C2QJJzM8dA5FGpv0itdEWyOG1xquXxP2EcdyorKlitY=
X-Google-Smtp-Source: AGHT+IGuFezsZMUJsTlRkPOuNfi4qef3irAedHsLZ3STySgCBrNbNoyGoUVxI8tg7r8d+lcYKpJNSg==
X-Received: by 2002:a05:6e02:b4d:b0:433:3115:fdab with SMTP id e9e14a558f8ab-4333115ff66mr40807895ab.19.1762185377383;
        Mon, 03 Nov 2025 07:56:17 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7226b9d53sm277148173.46.2025.11.03.07.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 07:56:16 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <60717dd76d7c38fe750c288a831e5d3a7379a70c.1762164871.git.asml.silence@gmail.com>
References: <60717dd76d7c38fe750c288a831e5d3a7379a70c.1762164871.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.18] io_uring/zcrx: remove sync refill uapi
Message-Id: <176218537597.11358.6534904317135875615.b4-ty@kernel.dk>
Date: Mon, 03 Nov 2025 08:56:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 03 Nov 2025 13:53:13 +0000, Pavel Begunkov wrote:
> There is a better way to handle the problem IORING_REGISTER_ZCRX_REFILL
> solves. The uapi can also be slightly adjusted to accommodate future
> extensions. Remove the feature for now, it'll be reworked for the next
> release.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: remove sync refill uapi
      commit: 819630bd6f86ac8998c7df9deddb6cee50e9e22d

Best regards,
-- 
Jens Axboe





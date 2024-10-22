Return-Path: <io-uring+bounces-3920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFC89AB25D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 17:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 307FB1F2242D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C843B19DF52;
	Tue, 22 Oct 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ejq9BMqE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8612259B71
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729611890; cv=none; b=JNVak5sh/SC9DHVc96ypXWJ5shsrSue+z3QeoTLuIR1FKcwC8iiDSqbPiTbEkTQHq8YNQJ3ZubM5bLzYz6Dxq363gdZiqb82PWNbXcwtfTeBtANMszdrV1fcX6Bxa6FbYYq17SdaUHHklNhtbN8pxARUm9zEQ+LOZA6Lr8qQ+84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729611890; c=relaxed/simple;
	bh=PUAegw/8CMeOBqNU1laD6MR8udl0a2XhHfTDKIK8BII=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nPNTVMdEyhugc0kl2No9MBPpkoK4+eGQYmES7ecuuGpysr1bdHMthK+9y5VMeM1X+Xmm3BSCzBJC0ToZQOO04W1ZOZtZFLAirusty81550q+fBBkNem7omljCHXWB5PiGEL2gNNKlyswj+cNAMIam3HDW/2S5epy9aF6dxL3VLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ejq9BMqE; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83aae6aba1aso215339439f.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 08:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729611886; x=1730216686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6pN7kHy3GQYhOpWxVtFRJmW4cD4D5wbZ/Yt6rtiEQ1o=;
        b=ejq9BMqE71NwSogJ+exUtpi2/rmYAgsVu81HnV2slN02IIZ5Y8xYb5gpl4zf3X7/zl
         cJdt3uFhL/aSkti0+MUw/Jl6HtB/aHFhTvh51tiwBUHnAU6HM6YnxdQyK7hxUWuasEeb
         tPBrrKV240SpqqnCxXCJzM30WJsu96XObQ9VK2ChPk8UE7XZSVk2wH+RHv1oXyIRTvgq
         KzxYgLnoffjDHh7KMKo0K4L9YyHkypwlEGvzBHfChLJ/TMESgMO7XaLg60zz2rh7qmhI
         DZvNXe5rBrd+VgrH2BGlNB2MTfj3bESSnRMJTm5+H8IAVkNXD3a7oPec+BuXqtpiKhqG
         33mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729611886; x=1730216686;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pN7kHy3GQYhOpWxVtFRJmW4cD4D5wbZ/Yt6rtiEQ1o=;
        b=gxRcx4rVf8eZ/Hty+yUui5gcH9HXXi6x/0SwZqhUzifvN6WT+0ix72vkjQYvUPUYx+
         FzyUO2lHeiM6u54W0uiwDB88diaiDT6feYx2gMN0LoGhxi73wx/3AaDlTFok4ZY6R1qB
         /cnamL0pu2ydHZYmalvsULLIErP9Zd7zcbISWy5kgan6kCRSsSOE4NNvWsIpIVQ2EQHf
         KAn3q+oleS+cSGR4gNJOmCOgjDFQjWA1yVpCb9P7zQPkPQZ7tHERZBou45MFFVjicAFM
         +oZQxlw86FixHAg6SUwgEbEm68+yWU0tU+8/BRT45n4xtHk6Ts0gTbHDZp6R0tvQ45ot
         f6cQ==
X-Gm-Message-State: AOJu0Yz0czT8z4nttS4rAtGzbKT8f3mHreekvi1OHksszvcnWKnaT58M
	VUSTyMjrJmtyZAQVyPFGzvbWEvz3EwHPLFlOj9ZdBRRQ+MWSarFfxrNqLG0zINpnvKYV77xY/BX
	T
X-Google-Smtp-Source: AGHT+IGhgRIohNTbMQX6eK2H/HffmtnTostyo8Gr38M5CkNUOc1RQxvOkDR7R5QCKX4oYAllPTAMWQ==
X-Received: by 2002:a05:6602:485:b0:83a:a82b:f855 with SMTP id ca18e2360f4ac-83aba5f0867mr1369862739f.9.1729611886574;
        Tue, 22 Oct 2024 08:44:46 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1c3380dsm166397839f.4.2024.10.22.08.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 08:44:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1729607201.git.asml.silence@gmail.com>
References: <cover.1729607201.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/4] send[msg] refactoring
Message-Id: <172961188587.922081.6617043167691318758.b4-ty@kernel.dk>
Date: Tue, 22 Oct 2024 09:44:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Tue, 22 Oct 2024 15:43:11 +0100, Pavel Begunkov wrote:
> Clean up the send[msg] setup path. The pathes should be good enough by
> themselves, but more can be done on top. It's also needed as a
> dependency for supporting vectored fixed buffers for sendmsg zc.
> 
> Pavel Begunkov (4):
>   io_uring/net: split send and sendmsg prep helpers
>   io_uring/net: don't store send address ptr
>   io_uring/net: don't alias send user pointer reads
>   io_uring/net: clean up io_msg_copy_hdr
> 
> [...]

Applied, thanks!

[1/4] io_uring/net: split send and sendmsg prep helpers
      commit: e16d4fa2e642258237f1899e8569db7dff83fd54
[2/4] io_uring/net: don't store send address ptr
      commit: 1aa83a963550d0bdd83dfc0f1ab4fcfdec1a060e
[3/4] io_uring/net: don't alias send user pointer reads
      commit: f2320d008abab8ed654437febb2f6395cdbec131
[4/4] io_uring/net: clean up io_msg_copy_hdr
      commit: bfd23424a581cefee8e13d0433bcf321a12b2d95

Best regards,
-- 
Jens Axboe





Return-Path: <io-uring+bounces-9156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B84D2B2F6F0
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 13:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6491C80E36
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 11:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE842253A1;
	Thu, 21 Aug 2025 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tl+yeBY8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B030F80C
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755776514; cv=none; b=dy2lM/1N7rykWgLSayEnLS1L3qfn9BngzOQnNkcQZeJ4zqVW8HFMkejl8dJoc7q23Urwiuslrv2JGcJnO/SCUh4bQ3XaQPJhdXgyJsez3MbczEtzc+wotjQ9Xk1oZub2pIhZQZ9NvfZGI46rHzjbBLAWcHyQ45NUykx+4bZmGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755776514; c=relaxed/simple;
	bh=8YILbEVkuJCvOe6hktP9e7AbwFVPyVbsmWOXariB6Us=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lV/VQaKW53JSjTlbp/dDFX+onrgUzrFNUONkx4JdXaA62BezRsCAZmYDGX5Q6nh5mi/CsDgfpQ312vOOcbL2Z/5Na/6RND2f31yfHfq/WDwE7rDmK34xSXBiq3T14tIlc38pg1AEaqjqFMIG0CzLQQEEgcje8sC+fhVrYi0Yjiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tl+yeBY8; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso689421a12.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 04:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755776511; x=1756381311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GnlWssyFpmkR0YRBO4OLh++3XVB+UFMUGMPkyP7ksj0=;
        b=tl+yeBY8nYyMYz9u+5Z18pG3wMQO8ypxMd6HBKAwacqj5mpxCzO4M4gzHQVgwGUM1c
         7ssjbZwEovDv/S2JMxunuyJTNUqoP9alTHKPgUXcZS+LE+Ds0tgf4Mb0nEU+UK2yrRmz
         ZlQ0of5EEKOXXD6oI30R7b3bg4R9AREMBqVKmFTyDikRpzgGuekIPqz/OSoXJ0bM5q5W
         9vwdJj7sEgh+onsMj9Z4UWBFwm3Y51MhYaHT2wjkdUuQQz+fBPLc28cIlqSqz4YFrKxw
         eQqMGHClz5JJhgYy5hNMgBpH/NrYdaIJSM/T1WezCfZ5bhaX++oXscwfFR0TVq+P9MuP
         MSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755776511; x=1756381311;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GnlWssyFpmkR0YRBO4OLh++3XVB+UFMUGMPkyP7ksj0=;
        b=PdiPVQ3hrU/iW5rz2L8p12z+h7ovR+MnNeYzbCYvIhBIHRyfuHY6qrtMAU/pCm/QV4
         jtRYqfV1KW0Nm/og0cnGEuxcICjFLW879fNp8woUzrS2S5WSJVVWwDMddm+sAXHpcrF5
         bO26g6x2PCNdgL6VSfrjqPGyyRWJU16bG57KJvlvO5EH3qysPnOCaiXUIBQw85QsFXeP
         Ush0mN2qhE38Xvv2WD0FTQwYIuWRHykNey1+vH0pTgqQJgg7QrYDtT8XmzN+ROzEQ5pE
         OgIyDzlRc0+5FhqqaWHByVW/3KI7jpy4sMnAjrjFCB/HrEEpQM1m2yyBW6B9DaAGwDik
         YhBw==
X-Gm-Message-State: AOJu0Yy5L5l8qm4R2apPv0mxVGRnDKlxxVUAHGD5jblMV3lr5W8Re3/N
	dlEP6gAy82NEJWxnobLQGeSqc+jeHbuqSvcjS+/zpADE7J1LWISumnaXc8m4BQuwedX31RUj6y7
	XzGMk
X-Gm-Gg: ASbGnctAMWTUunc3jugbCuqcjvVYNLw5qrvuHq313dzmNRCPer7F5/1ReTF8teo4E1L
	diOXbD8lLLhDq0jNTE4wjZG7B6ZxH9sCpK8nsivOFut73zU78I0E9zgqTwkJqLVHKS1k9ZViSkt
	cdDPmTQXK3yxoaZ8CXyDh2aBPAl5y9OiSJZg5wgaf3YlksRBh1/HnE/dkExi1bEJeN02BmBBPVI
	/xOH0B9D1jkB18fzO8sTHus3xIYv1RKn83hawDv8iZuQBd4lmf4KYsgzOAGb4ia/G+ywym11oa9
	XioZGjR9h49my9r6OkZ7ec/DsWoo8xOjbhmzvsXIOnJImCeor7SXxAwSubxg1etyWJn5zHOEG5O
	r9fYzlV0+dG7X6uVxqVOY6cE5tA==
X-Google-Smtp-Source: AGHT+IEJDlMvJSsE6kT9zvbKavEzjGlBXvoHvg9Ka0CI1c434JGFnGtEEvU7UJ88eQ55XF+NfzGGJw==
X-Received: by 2002:a05:6a20:7349:b0:23d:ac50:333e with SMTP id adf61e73a8af0-24330a6922bmr3091947637.43.1755776510891;
        Thu, 21 Aug 2025 04:41:50 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d4fd29fsm8059281b3a.72.2025.08.21.04.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 04:41:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
 Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <20250821040210.1152145-1-ming.lei@redhat.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
Subject: Re: [PATCH V5 0/2] io_uring: uring_cmd: add multishot support with
 provided buffer
Message-Id: <175577650998.615255.10824296654269741369.b4-ty@kernel.dk>
Date: Thu, 21 Aug 2025 05:41:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 21 Aug 2025 12:02:05 +0800, Ming Lei wrote:
> This patchset adds multishot support with provided buffer, see details in
> commit log of patch 2.
> 
> Thanks,
> Ming
> 
> 
> [...]

Applied, thanks!

[1/2] io-uring: move `struct io_br_sel` into io_uring_types.h
      commit: 1a8ceff033519eac7bb5ab1d910e9b0340835c0d
[2/2] io_uring: uring_cmd: add multishot support
      commit: 55dc643dd2ad15e755a706980692a374de1bb7a8

Best regards,
-- 
Jens Axboe





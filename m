Return-Path: <io-uring+bounces-9090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B4DB2D1EB
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 04:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F9824E618C
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 02:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58DDC25C816;
	Wed, 20 Aug 2025 02:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPcb2fGh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2397223AB81;
	Wed, 20 Aug 2025 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755657088; cv=none; b=UKJ6lN68DdxECgsj+Zy7LffXrYmjZ2xoN0DJa0xXVU7qDVn7GzgHfu0CiV7+OEL/X0PustnYIwrw7x4EFWnCbMDfbCko14nw5UtHnfJpnd/tCrgpjUzPhgHQB3TFcQ3Mehgv7rKAnvRwW4Rj7UHFDWmDf6Htfe4X0vAWs4cxyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755657088; c=relaxed/simple;
	bh=Slm/GBRpvflnGfZUhFFb/q0xVw8FcEBmy24cv2K2+T0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYscvIZbr8bxC/pcuya8ustbo2s8Pc89I63sVJHel1k0c5BrEzY+biDKuzG2338g7AZChoDD0Ll8Oj4/aJl5DoqD6E7TCyrz8cvuVbMN1UxDoaDvHoEnv+ukajrclyv+v4xUWVtm2SsQD3Rs1UxciW2bROr/F1CGag9mJjeGLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPcb2fGh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4555AC4CEF1;
	Wed, 20 Aug 2025 02:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755657087;
	bh=Slm/GBRpvflnGfZUhFFb/q0xVw8FcEBmy24cv2K2+T0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JPcb2fGh26tvgfOP5ucYqoaoXhV4UPN+S1t6VgF8eWkQtsG72Ypi6cB2qIIHHFHAw
	 5F2xj+QUjv/sYKsaYM+9fVJykIx5BjdLn9ePoxlOkwrq+ByuXxa1cWjzMyogh/nFHi
	 CAsx7V/eExnovzTfGTPQHjgU8NqSdFWneSZdxzGTWXndkha1rI2WG528kZFlk7OsLT
	 P+UI96T/S0mRxFE3k3ATIRm//1zOSPXidg9e/r1MtF1hegSPy5bEmQ61aTGCyfPKKx
	 CngzEhCiAxoupyk3R6ZjZs+csQrx49hDohjYPtq7zMq+PmLqQdKWdtK6NWQisYotn+
	 eCJ5lUJeDMH1A==
Date: Tue, 19 Aug 2025 19:31:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Willem de
 Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/23][pull request] Queue configs and large
 buffer providers
Message-ID: <20250819193126.2a4af62b@kernel.org>
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Aug 2025 14:57:16 +0100 Pavel Begunkov wrote:
> Jakub Kicinski (20):

I think we need to revisit how we operate.
When we started the ZC work w/ io-uring I suggested a permanent shared
branch. That's perhaps an overkill. What I did not expect is that you
will not even CC netdev@ on changes to io_uring/zcrx.*

I don't mean to assert any sort of ownership of that code, but you're
not meeting basic collaboration standards for the kernel. This needs 
to change first.
-- 
pw-bot: defer


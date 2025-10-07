Return-Path: <io-uring+bounces-9923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FC8BC23A5
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 19:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A694400CCA
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 17:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2824E2E8B82;
	Tue,  7 Oct 2025 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWkCA+cg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26682DC334;
	Tue,  7 Oct 2025 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759857214; cv=none; b=iHHkCdnxqqmS3Q2F3eQC0xqwut7JLCfCq7VjqxTj2eXiCzqIM9IRgwoiipiEFEX6Xt7qJOJduFR87UDPgcLUhXIfcFYGYMWwfO/oPtsooMFudrKAU2jre2lnFxVhg3h3KRkJQimwfCKxSdOLm7iL1lyCkysTzZd+1B+prfs71w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759857214; c=relaxed/simple;
	bh=5bgMtw8ZAA+rdauCeRLAbAwWbXFt0klPw6JBQhsnJk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLZkjNKV7K8lkmVoEHWD6B1RK2MfVfdWlgEEd60J9c/pjC44xOS41x585BVLY+sO5E/hyraP23r0MC3aXgW8m47UJ3BTFQQoclEp3B85V4tvXk+RLIIIwY3btWXxSQK577otqJ9wTTuW93K4j9k03vqM8KsFxmyAJ4+QqizCwug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWkCA+cg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB42C4CEF1;
	Tue,  7 Oct 2025 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759857213;
	bh=5bgMtw8ZAA+rdauCeRLAbAwWbXFt0klPw6JBQhsnJk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWkCA+cgasIgKqyKa4eA4zsOhHJwU+znRNfvrqwgHaZy+779w1E0JAbf36ucqpkrO
	 6vM9qCLL6EgKCKHlo03RuY5i03ZdPZQdtEZUPauZ8drOVRIIeemc+Up2UCyEU6OKXa
	 3ocxOzftNbj0eL7Wm5n4b3S7CjCi5SqItqtUXa4rnmnKVF9BDa48WcYG/QQJVfr6iy
	 1cNPcTIg5leu6/szQwhSJJtciPBXGOGdL0lVn+W/YYcjH/tGS3hfcJ+sbkyk2LA9Eg
	 U0LPMWtqHgaVcX0o8h+9Gv0wUODnt0zMyT0RcHpralZIHWu7/zgf0RDP1vPGfMJMTN
	 9nCBd0JdmHH1w==
Date: Tue, 7 Oct 2025 17:13:31 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: io_uring and crypto
Message-ID: <20251007171331.GB2094443@google.com>
References: <4016104.1759857082@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4016104.1759857082@warthog.procyon.org.uk>

On Tue, Oct 07, 2025 at 06:11:22PM +0100, David Howells wrote:
> Hi Jens,
> 
> I was wondering if it might be possible to adapt io_uring to make crypto
> requests as io_uring primitives rather than just having io_uring call sendmsg
> and recvmsg on an AF_ALG socket.
> 
> The reason I think this might make sense is that for the certain crypto ops we
> need to pass two buffers, one input and one output (encrypt, decrypt, sign) or
> two input (verify) and this could directly translate to an async crypto
> request.
> 
> Or possibly we should have a sendrecv socket call (RPC sort of thing) and have
> io_uring drive that.
> 
> The tricky bit is that it would require two buffers and io_uring seems geared
> around one.
> 
> David

What problem are you trying to solve that can't be solved with a
userspace crypto library?

- Eric


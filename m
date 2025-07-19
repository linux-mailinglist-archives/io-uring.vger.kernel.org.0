Return-Path: <io-uring+bounces-8732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B49EBB0B100
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 19:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60CF61AA2CC3
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 17:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE4B213E74;
	Sat, 19 Jul 2025 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0iXKGdg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B3E288D6;
	Sat, 19 Jul 2025 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752944608; cv=none; b=RAANvbBr2yXi1NB5b5m6n8I+4uJISrYENlNWjk0cG7DN2jzyuHUDSZV99SM4wB9KKImc3F/gzR7yuMWTY9UTksJa83CAJBLFF1PR43sbO01yfqpHHDQdWmxlXpcJjLw0qZT0oADz+JZB2HCUqM0sfbdfG1Ai89dBcUnwiisp+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752944608; c=relaxed/simple;
	bh=sJNnKnkXGsdPPhNfMhZY6tva9BGGaREvLPGZEO1Wn6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIlJxC74kiYDx4EtNJwRQd0X+PFZm09cXcsV38jZHnBXEA3lJFMZypmUDkwH0xdFAo5aEkNYp7X82XQt3/ZTZcaWF5gmOYurxAayOVo8o8AZjEHf2Z537BJoURqDNo5desZH1yUXUzUIwIfQ0kLDVotk5keLE9Y5NgM31cod5kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0iXKGdg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34ABC4CEE3;
	Sat, 19 Jul 2025 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752944608;
	bh=sJNnKnkXGsdPPhNfMhZY6tva9BGGaREvLPGZEO1Wn6Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X0iXKGdgHrgediD/d5EQhRvnRAy5MbMODvn5vzQC6W+Kfp2XVLZSDDBX41DQ4huFz
	 EolTMkquCT2WPksuU4e8co4gkv1PBNR4g/WvMtqgeZpB3TNYrRBsWb/tjCXO/EYy4o
	 pWLT5E7qn0Vhub/PS/okqCbcHj97dyxrCpeiY9q5t5mTOeVviF1yc9K1WugjiYfdPq
	 eSFTOhDN8KFYvN68IlR61lA1k1BmcX7k9BlxsXnE6CIhvK1KBUI3AoUSIztzH5ZetV
	 nG+Ws6k0e+1phUhwp6US4cJ4MNSHmSm6XHttOupSb2N5LA86SmBfzH9gRgR8nQ+e+o
	 Nb62ZVQBzZ58g==
Message-ID: <a0a868ef-107e-4b1b-8443-f10b7a35aabb@kernel.org>
Date: Sat, 19 Jul 2025 19:03:24 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20250719143358.22363-1-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sidong,

On 7/19/25 4:33 PM, Sidong Yang wrote:
> This patch series implemens an abstraction for io-uring sqe and cmd and
> adds uring_cmd callback for miscdevice. Also there is an example that use
> uring_cmd in rust-miscdevice sample.

Please also add Greg, maybe get_maintainer.pl does not list him, since the
entries for miscdevice were missing for a while I think.

For new abstractions I also recommend to Cc the RUST reviewers.

Thanks,
Danilo


Return-Path: <io-uring+bounces-9786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC5EB5619C
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 16:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40811562F82
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 14:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0B82ECD39;
	Sat, 13 Sep 2025 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ynkFk0Al"
X-Original-To: io-uring@vger.kernel.org
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089454723;
	Sat, 13 Sep 2025 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757774432; cv=none; b=FcpAiFoS5UNE9iFdETScog3KX9PuQK++kue6BxAf3K2oiBBOwMag93bZjVjkIRUUBb7wblaXraoXlI76FoZipBh+5QS7PQjXcP2obTDmHYJzIimifOsz8stP2SLxRXshfSPgLtrkgPusYB/Z8FqjEndWSUflhh3C4FaQWaob0dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757774432; c=relaxed/simple;
	bh=bs1jj5XpzcErQhSmzXH6wOSW8ZsoNPCNXOynjLDDBJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1wKTZCkpkdcFFpeqZ0mcWjlWO/+g2rMP7xZ03QJiQZhQcUW5jLBbLJBa758ISGmmjhYivvFEbhJVK8sZdrPctIYVtB+d+012MbwTJUOZuXPqbVtjEoqoYbStXNj5g9D1p8YepGJy9OGGW6ZWvkA91sPwUNcL1wgGFUeYH+2lQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ynkFk0Al; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cPDVM5zDfzltBDd;
	Sat, 13 Sep 2025 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757774426; x=1760366427; bh=RCpZ57OE6NjfFIJI3GSRMcqB
	ZFGJIths38CZgXKjEq0=; b=ynkFk0Al98OyeHWDZfaFOzAimwhyftg82YaqDEB9
	Oo2j/HtvOwxUBdyBOdJeIn1Jyc/yyJb/i8JVaNvhmylbX2z0MxpEXvQxVnsajbVG
	tEEW55KyQQruhypOj+GdKG3c2D9Jm8NAvFT2Q6UxIO+7SnOX/+hOCFx46XJX3UAH
	TxPajYa5iavB6Rx2jY0DxotE7AzeVT65j8XQqmQe0DCs13eSw6pBQXW5gb/Du4Aj
	dKFPP3hwisDnzL7q946dpeLc0eZqSWEJGDZ0L/MdHd8a3Y7CWTAmgcwT14Gsau5m
	hP2SoD0QbGW3BRhKuuukonyYbeDNS7gXfWRSTzPWeMbPOw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ppjM-XIk1y-W; Sat, 13 Sep 2025 14:40:26 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cPDVF42h2zlrvtM;
	Sat, 13 Sep 2025 14:40:20 +0000 (UTC)
Message-ID: <e0559c10-104d-4da8-9f7f-d2ffd73d8df3@acm.org>
Date: Sat, 13 Sep 2025 07:40:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] barrier: Convert C++ barrier functions into
 macros
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>, dr.xiaosa@gmail.com,
 Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20250913131547.466233-1-ammarfaizi2@gnuweeb.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250913131547.466233-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/25 6:15 AM, Ammar Faizi wrote:
> Convert them into macros just like the C version to fix it.

Converting functions into macros is a step backwards. Please check
whether removing the "static" keyword from the inline function 
definitions in header files is sufficient to suppress the compiler
warning about TU-local definitions.

Thanks,

Bart.


Return-Path: <io-uring+bounces-6141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 569D2A1DAB4
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 17:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE0983A4DCE
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3997715CD74;
	Mon, 27 Jan 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b="VHCSvNSw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.charbonnet.com (2024.charbonnet.com [96.126.120.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81541433CB;
	Mon, 27 Jan 2025 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.126.120.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737995939; cv=none; b=ROSLDynaR9MTD6r7FPadyx/pzXDXgT5y2zX3aoH0OqZ40Dx1hmbpL8ya2PYteqTh7UpAP5BoUDM+2A0mkNZJGruRaINUO1iX3kYMUTQWIIV3OZBdqQ+nz48ufeN2O3I9gueXN+Ec0Rru198zM3XO1MpSeWSGbSbZ4/o+dYq5ePs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737995939; c=relaxed/simple;
	bh=mXEEXfmrmakj98sGLZO/IOPtBusrR/3HL7Qsyr/0wDM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tPup0rKcRuQjS+U8gt6keL7KwmNLNsG2Guw88s2lYtAyaRY9zA5dlhQIKoHXV1g0Vm3iYXIwNB1GqlAvaBbvc5r3yviRoiQHfKpyTfI9YcYfxajoN5Uo5WJqt2ISYni+W3h6XhFupzbYl/LCZbTL9xB/jO6p8NRIx9IV8QEGqzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com; spf=pass smtp.mailfrom=charbonnet.com; dkim=pass (1024-bit key) header.d=charbonnet.com header.i=@charbonnet.com header.b=VHCSvNSw; arc=none smtp.client-ip=96.126.120.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=charbonnet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=charbonnet.com
Received: from [192.168.1.91] (unknown [136.49.120.240])
	by mail.charbonnet.com (Postfix) with ESMTPSA id E27E782617;
	Mon, 27 Jan 2025 10:38:53 -0600 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=charbonnet.com;
	s=2024121401; t=1737995934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Og1NWrKSu5KLjb2WBrkxQ39OxcXauckEp53FnMwltCw=;
	b=VHCSvNSwENpoG7gzaT4lOTBwkFmRG9KX1dGxVl8vI/tG+TIQXHVsFnaKThsWIoU32aOQ1X
	raB47rHyw0NAG7cILXaWhqN5yzEyMgClO9t2Q9VAyPEqvKPpzpMlt7oVhBdU00Q0xFocBh
	KOYeqJ/9EVJsbC13ShNHRf2XHu7TDqQ=
Message-ID: <dfc6006d-10cf-4090-aafd-77d62c341911@charbonnet.com>
Date: Mon, 27 Jan 2025 10:38:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
From: Xan Charbonnet <xan@charbonnet.com>
To: Jens Axboe <axboe@kernel.dk>, Salvatore Bonaccorso <carnil@debian.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: 1093243@bugs.debian.org, Bernhard Schmidt <berni@debian.org>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
 <Z5P5FNVjn9dq5AYL@eldamar.lan>
 <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
 <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
Content-Language: en-US
In-Reply-To: <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The MariaDB developers are wondering whether another corruption bug, 
MDEV-35334 ( https://jira.mariadb.org/browse/MDEV-35334 ) might be related.

The symptom was described as:
the first 1 byte of a .ibd file is changed from 0 to 1, or the first 4 
bytes are changed from 0 0 0 0 to 1 0 0 0.

Is it possible that an io_uring issue might be causing that as well? 
Thanks.

-Xan



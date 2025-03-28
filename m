Return-Path: <io-uring+bounces-7270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 876A6A74D46
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D400173C43
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FF74409;
	Fri, 28 Mar 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jGRefvs5"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3579E1
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743174160; cv=none; b=Lpndl9ZTfdOUjCCG2CzwQjo1aa3FExD4xLEZOMIdC2WHrU+PVzQxFELSB0ADPvb0eQvrhw3sgY6hUIKpF3GM7wFgtiR6x3J8DPLfnR5wXEU/ZNpeBtJZ6YAc8Ehq83rGD2q6DZj32PE80R2rupOnoG/bjv+P4eq11wodC/dRQpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743174160; c=relaxed/simple;
	bh=fUqxU/CesVqXOwTMqZXtk5JLd/TWdSGfHDK/GorfyYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNUMZV13o6n7qc5Dm8ZrQbZONgcS9X2J6JuSGr4hoxWRwyZy+cUrjlwFcPj6JBcHQQZM5sW3feCQ/y687l5ya1OZEglJq1Om9VZ/o2vud8/ijCl1ppUGPxZsqqqkZ0GTOJiwjckc+KXcguFXgawHfg4aZoJ51onuUASp7MlN/J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jGRefvs5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xxZmPzM19/NsVRM4snlB/shEcUo1K4+zOCI9b4IW71g=; b=jGRefvs5HAxtRjRhmVPdwpbdKU
	raN0+pDH9PupOgpP0MVJ70niEAvpIwO5nv+XArM4FFYPWoJOqMyhWDqUc0oyMFoa29jQb56EN4GAJ
	e5dEPCS/eSAAhqewvdYNwnFGWtqT3kvsufrGwX0vDf5kKP4pkIEu/YzhKkgDSGAz946HFcoIm2GRl
	iptjiSBHyyFV1vmhELde9J4JmLgevaPLCOxv182BObEqSVjAN1nqYlLz23uZd/0tFEVYR6y1VxEwp
	JZSLZGfreXsk/0/oFXkPqYyTyLB51zG/TKj5kz5fPJuUHRnQZA9JDkjQjOhut86S9SvHvtQFgU82M
	RgwVdxqUJBGJFQTnf8bCWJTjhBj2uNMZH7L79+HDeGcyQmDF49kHbJy/wA52S8qUvuiWfyggyGmUK
	gt1Pa8L6a78R3bdqPZBQ6q9G/PHmpb+JPiUG7QPmlmzy8xXrpKAL0597FM3dAxvv9T0/zLiGH1gCi
	EIAHipL7O+6ZUIsRyxERBULN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tyBEC-0077Pz-0P;
	Fri, 28 Mar 2025 15:02:36 +0000
Message-ID: <0fd93d3b-6646-4399-8eb8-32262fd32ab3@samba.org>
Date: Fri, 28 Mar 2025 16:02:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 28.03.25 um 15:30 schrieb Jens Axboe:
> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>> while playing with the kernel QUIC driver [1],
>> I noticed it does a lot of getsockopt() and setsockopt()
>> calls to sync the required state into and out of the kernel.
>>
>> My long term plan is to let the userspace quic handshake logic
>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>
>> The used level is SOL_QUIC and that won't work
>> as io_uring_cmd_getsockopt() has a restriction to
>> SOL_SOCKET, while there's no restriction in
>> io_uring_cmd_setsockopt().
>>
>> What's the reason to have that restriction?
>> And why is it only for the get path and not
>> the set path?
> 
> There's absolutely no reason for that, looks like a pure oversight?!

It seems RFC had the limitation on both:
https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/

v0 had it only for get because of some userpointer restrictions:
https://lore.kernel.org/io-uring/20230724142237.358769-1-leitao@debian.org/

The merged v7 also talks about the restriction:
https://lore.kernel.org/all/20231016134750.1381153-1-leitao@debian.org/

Adding Breno ...

It seems proto_ops->getsockopt is the problem as it's not changed
to sockptr_t yet.

metze


Return-Path: <io-uring+bounces-523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED94847A76
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 21:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71B081C261DC
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 20:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B8D8062A;
	Fri,  2 Feb 2024 20:23:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C28839E9
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 20:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706905439; cv=none; b=s+tEL+eSDWN7TwVtNMxGIpzUFluxyd8mjk51Qsu05LeEN+UXOXcluvBkJs8mzPkBloEtbqU74E6QR6zZCQiJXJ02I6VVMdQhxra8dV5gc19ZIOgVO3lm2WRaYpYdrEmHr3t3vgzYSY3QBC9uppSRsXy0F0Yg1kPY4mmJnzjhgkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706905439; c=relaxed/simple;
	bh=k1JEblvUfr2KIijR75h0aYpo8u70xy32KphljU8WxKg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ExOSWBzN7RKJiiD9Sy3aPg4zJxPDhAhdEpXg31LSJnI9AcyR7ARMBT5CMgbpt+jktaigT7O82aKW/sa+d2GoCKJhbZ4RcVYOE6oElotk0O47UtqzlAeC9CZaEARfIGIyyehGyOMwUbcUF6VEPbvBGRSi1kA+5ePMNjt50cgEvoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=41066 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1rW04q-00042q-2B;
	Fri, 02 Feb 2024 15:23:56 -0500
Message-ID: <a6bd8fc18d15bf1be4ccf0a8cd4f5445cd849fa2.camel@trillion01.com>
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org, 
	kernel-team@fb.com, ammarfaizi2@gnuweeb.org
Date: Fri, 02 Feb 2024 15:23:55 -0500
In-Reply-To: <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
References: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
	 <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=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
Organization: Trillion01 Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Fri, 2024-02-02 at 13:14 -0700, Jens Axboe wrote:
>=20
> Ah gotcha, yeah that=E2=80=99s odd and could not ever have worked. I wond=
er
> how that was tested=E2=80=A6
>=20
> I=E2=80=99ll setup a liburing branch as well.
>=20
It is easy. You omit to check the function return value by telling to
yourself that it cannot fail...

I caught my mistake on a second pass code review...

C++ has a very useful [[nodiscard]] attribute that can help to catch
this simple error... I am not sure if there is something similar to the
[[nodiscard]] in the ISO C standard...



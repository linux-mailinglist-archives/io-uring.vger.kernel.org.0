Return-Path: <io-uring+bounces-3245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52A897DA26
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 23:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53E24283384
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 21:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0D7EBE;
	Fri, 20 Sep 2024 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="isITz+Fg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968281CFB9
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 21:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726866102; cv=none; b=tdnOHijMD/d9MbmQvuvcJJWV+GP22uHU6GXDZeyKzn1ww/zEy0LytXh6cbX2b9JVLXOAd1N3bWc5oBbl658oGZqvZH8HJPC7+SWDLAX9mZGop03YEOo1B7Wd0sHNOV7t3ptcP+ykLxGL7jJJzvS+AJu9sxnN2qHDmca4GtSB0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726866102; c=relaxed/simple;
	bh=M60xKEWlL/6BdkUsw4+zdj5QVF9yFG0LdeHUmSj3QM0=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=iwQ5r4hnv8Na3MuecbOstqL7LXWgm4Fwr5Jk+lVNEJzWZmex5p875IEgQs3JMVyt/ZpOlF1XgjBRS9PTwNJQKTjxVqj760IHX8qTIQ3nlbKWpVZIAewiuj6+lBwdhZxgS6TIB4iAENBXRu9LpmwKf0qUCHvIIEceL9Y3LmqnE+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=isITz+Fg; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1726866092; x=1727125292;
	bh=M60xKEWlL/6BdkUsw4+zdj5QVF9yFG0LdeHUmSj3QM0=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=isITz+Fgdn1rrweoEUqkQAAFdY/lF5PbvmwUpb9bt0tJpjuZt/cFojyshz+T05ZYO
	 sSq9oThxxOE/ZOImxKKyRx7FfKKukmZLsLcYiB+l0ct0ieQagHvoPfjMHFPX0Ge+P0
	 FD0DssMsJIHjit+zliq6DenzARl4U93+e6tOec/3+AEaV6jy/D2s43ezUU2GNSe7fY
	 h0vdaeE3U3dmUU8iukUOJWkS3YONfs3oV7WWXyV2CnsddcidlwPc7N3X/wPqGmMMEt
	 q3zGlZwZ0542KvrQh9A0POvg49wX8Joz+Cxy281JoALkfvFfwmJcxBR2HkoaNCtvvc
	 681DDJgTE9gZg==
Date: Fri, 20 Sep 2024 21:01:27 +0000
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From: Altan Ozlu <altan.ozlu@proton.me>
Subject: Subscribe
Message-ID: <4HJghBcZ7iuiWs77L8O6k99ODjkeImgl5CQjikzOW_4zT8-5S37s66CNmz7zg7-jnfW4YdaVpXIwmUB-7wIZH4Tphn41LENHdAJiA_hdNXQ=@proton.me>
Feedback-ID: 113167102:user:proton
X-Pm-Message-ID: c51ab92d476fc24de01a142de68139924c9e1923
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



Sent from Proton Mail Android

